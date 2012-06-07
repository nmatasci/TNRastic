=head1 NAME

ITIS.pm -- A TNRastic adaptor for the ITIS TNRS

=head1 SYNOPSIS

    require "$PATH/ITIS.pm";

    my $itis = ITIS->new();
    my %results = $itis->lookup($name1, $name2, $name3);

    die "Could not query ITIS TNRS: $results{'error'}" unless ($results{'success'} eq 'ok');

    foreach my $name (@names) {
        print "For name " . $name->{'submittedName'} . ":\n";
        my @matches = $name->{'matches'};
        if(0 == scalar @matches) {
            foreach my $match (@matches) {
                print "\tMatch found: " . $match->{'acceptedName'} . "\n";
            }
        } else {
            print "\tNo match found on ITIS TNRS!\n";
        }
    }

=cut

package ITIS;

BEGIN {
    push @INC, "./SOAPInterface";
}

use Carp;
use LWP::UserAgent;
use JSON;
use XML::Entities;

use MyInterfaces::ITISService::ITISServiceHttpSoap11Endpoint;

=head2 new

Creates a new ITIS object, which can be used to make requests against
the ITIS TNRS.

=cut

sub new {
    my ($class) = @_;
    
    croak "No class provided!" unless defined $class;

    my $self = bless {}, $class;

    return $self;
}

=head2 lookup

  my %results = $iplant->lookup(@names);

Given a list of names, lookup will return the results from
ITIS TNRS for each of the names.

=cut

sub lookup {
    my ($self, @names) = @_;
    my @returned_names;

    croak "No names provided!" if (0 == scalar @names);

    foreach my $name (@names) {

        # Make the API call.
        my $itis = $self->{'itis'};
        if (not defined $itis) {
            $itis = $self->{'itis'} = MyInterfaces::ITISService::ITISServiceHttpSoap11Endpoint->new();
        }

        my $response = $itis->getITISTermsFromScientificName({
            srchKey => $name
        });

        if(not $response) {
            return {
                'status' => 500,
                'errorMessage' => $response->get_faultstring()
            };
        }

        # All terms.
        my @terms = @{$response->get_return()->get_itisTerms()};

        # ITIS does a simple text search against its entire database.
        # So let's try to find an ITIS term with a scientific name
        # that precisely matches what we currently have.
        my $term_to_use;
        foreach my $term (@terms) {
            my $scientificName = $term->get_scientificName();
            next unless defined $scientificName;

            my $decoded_name = $scientificName;
            $decoded_name = XML::Entities::decode('all', $scientificName)
                if ($scientificName ne '');
            
            if($decoded_name eq $name) {
                # A match! Use this term. 
                $term_to_use = $term;
                last;
            }
        }

        unless(defined $term_to_use) {
            push @returned_names, {
                'submittedName' => $name,
                'matchedName' => "",
                'acceptedName' => "",
                'uri' => "",
                'annotations' => {},
                'score' => 0
            };
            next;
        }

        # Figure out the accepted name.
        my $tsn = $term_to_use->get_tsn();
        $response = $itis->getAcceptedNamesFromTSN({
            tsn => $tsn
        }); 

        if(not $response) {
            return {
                'status' => 500,
                'errorMessage' => $response->get_faultstring()
            };
        }

        my $warning;
        my $accepted_name;
        my $accepted_tsn;
        my @accepted_names = @{$response->get_return()->get_acceptedNames()};

        if(0 == scalar @accepted_names) {
            $accepted_name = "";
            $accepted_tsn = "";   

            warn "No accepted name found for $name/$tsn on ITIS.";

        } elsif(1 != scalar @accepted_names) {
            # I don't know what it means for ITIS to have multiple
            # accepted names for a single TSN; so right now, I'll
            # bail out if we hit that case.
            die("Several accepted names found on ITIS for $name/$tsn:\n" . join("\n\t", @accepted_names));

        } else {
            if($accepted_names[0] eq "") {
                # This appears to be ITIS behavior for when the provided
                # TSN is the accepted name.
                $accepted_name = $name;
                $accepted_tsn = $tsn;
            } else {
                $accepted_name = $accepted_names[0]->get_acceptedName();
                $accepted_tsn = $accepted_names[0]->get_acceptedTsn();
            }
        }

        push @returned_names, {
            'submittedName' => $name,
            'matchedName' => ($term_to_use->get_scientificName()) . "", # Cast it to a string
            'acceptedName' => $accepted_name . "",
            'uri' => "http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=$accepted_tsn",
            'annotations' => {
                'originalTSN' => $tsn . "",
                'TSN' => $accepted_tsn . ""
            },
            'score' => 0.5
        };
    }

    return {
        'status' => 200,
        'errorMessage' => "",
        'names' => \@returned_names
    };
}

1;
