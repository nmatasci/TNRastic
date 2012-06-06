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

use Carp;
use LWP::UserAgent;
use JSON;

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

    croak "No names provided!" if (0 == scalar @names);

    # Make the API call.
    my $names = join(',', @names); 

    my $lwp = $self->{'lwp'};
    if (not defined $lwp) {
        $lwp = $self->{'lwp'} = LWP::UserAgent->new(
            'agent' => "TRNastic ITIS TNRS adaptor/0.1 "
        );
    }

    my $url = "http://tnrs.iplantc.org/tnrsm-svc/matchNames";
    my $response = $lwp->post($url, {
        'retrieve' => 'best',
        'names' => $names
    });

    # If no success, report an error.
    unless($response->is_success) {
        return {
            'status' => $response->code,
            'errorMessage' => $response->message
        };
    }

    # Pull out the data we need and construct a JSON object to return.
    my $results = decode_json($response->decoded_content(
        charset => 'none'   
            # Without this, I think decode_json tries to
            # re-decode Unicode characters; simpler to let
            # decode_json do the decoding, I think.
    ));

    my @returned_names;
    foreach my $item (@{$results->{'items'}}) {
        my $name = {
            'submittedName' => $item->{'nameSubmitted'},
            'matchedName' => $item->{'nameScientific'},
            'acceptedName' => $item->{'acceptedName'},
            'uri' => $item->{'acceptedNameUrl'},
            'annotations' => {
                'Authority' => $item->{'acceptedAuthor'}
            },
            'score' => $item->{'overall'}
        };

        push @returned_names, $name;
    }

    my $error_message = $response->message;
    if($error_message eq 'OK') {
        $error_message = "";
    }

    return {
        'status' => $response->code,
        'errorMessage' => $error_message,
        'names' => \@returned_names
    };
}

1;
