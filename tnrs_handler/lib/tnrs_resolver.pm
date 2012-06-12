package tnrs_resolver;
use strict;
use JSON;
use Exporter;

our @ISA=qw(Exporter);
our @EXPORT=qw(process);

our @VERSION = 1.0;

#process(@ARGV);
#exit 0;

sub process {
	my $names_file    = shift;
	my $adapters_file = shift;
	my $target_dir    = shift;

	#output name
	my $jobId = ( split qr(\/), $names_file )[-1];
	$jobId = ( split( qr(\.), $jobId ) )[0];

	#date
	my $sub_date = localtime;

	#load adapters registry
	my $ad_ref = load_adapters($adapters_file);
	my ($res,$fail) = query_sources( $names_file, $ad_ref );
	$res = merge($res);
	write_output( $res, "$target_dir/$jobId.json", $jobId, $sub_date, $ad_ref,$fail );
	unlink $names_file;
	return 0;
}

#TODO: Parallelize
#send the name batch to each adapter
sub query_sources {
	my $names_file   = shift;
	my $adapters_ref = shift;
	my @results;
	my $failures;
	foreach ( @{ $adapters_ref->{adapters} } ) {
		my %source = %{$_};

		my $input =
		  `cat $names_file | $source{call} 2>/dev/null`
		  ;    #TODO: redirect STDERR to logs
		my $res;
		eval {
			$res = decode_json($input);

			$res->{sourceId}   = $source{sourceId};
			$res->{sourceRank} = $source{rank};
		};
		if(!$res || !defined($res->{errorMessage}) || $res->{errorMessage} eq '' ){
			 $failures->{$source{sourceId}}={status=>500,errorMessage=>'General failure/Unknown'};
			
		}
		elsif($res && $res->{status} == 200){
			push @results, $res;
		}
		else{
			$failures->{$source{sourceId}}={status=>$res->{status},errorMessage=>$res->{errorMessage} };
		}
	}
	return (\@results, $failures);
}

#merge names returned by adapters
sub merge {
	my $results = shift;
	my %matches;
	my %output;
	foreach ( @{$results} ) {    #for every source
		my $res = $_;

		my $sourceid = $res->{sourceId};
		my $rank     = $res->{sourceRank};
		my @names    = @{ $res->{names} };
		foreach (@names) {                #for all the submitted names
			my %input = %{$_};
			if ( !$input{matchedName} || $input{matchedName} eq 'null' ) {
				next;
			}

			#builds the output object
			my $output = {
				sourceId     => $sourceid,
				matchedName  => $input{matchedName},
				acceptedName => $input{acceptedName},
				uri          => $input{uri},
				score        => $input{score},
				annotations  => $input{annotations},

			};
			@{ $matches{ $input{submittedName} } }[$rank] = $output;

		}    #end of matches

	}    #end of source
	return \%matches;
}

sub write_output {
	my $results  = shift;
	my $filename = shift;
	my $jobid    = shift;
	my $sub_date = shift;
	my $sources  =
	  _extract_meta(@_);    #extract the source metadata from the adapters and the failures

	my $output;

	my $meta = {
		jobId    => $jobid,
		sources  => $sources,
		sub_date => $sub_date
	};
	$output->{metadata} = $meta;
	my @names;

	for my $key ( keys %{$results} ) {
		my @matches =  grep { defined } @{ $results->{$key} }; 
		my $entry   = {
			submittedName => $key,
			matchCount    => scalar(@matches),
			matches       => \@matches
		};
		push @names, $entry;
	}

	$output->{names} = \@names;

	$output = encode_json($output);
	open( my $OF, ">$filename" )
	  or return "Cannot open output file $filename: $!\n";
	print $OF $output;
	close $OF;
	return 0;
}

#TODO: Extract metadata from the sources
sub _extract_meta {
	my $sources=shift;
	my $fails=shift;
	my@meta;
	foreach(@{$sources->{adapters}}){
		my%source=%{$_};
		if($fails->{$source{sourceId}}){
			$source{status}=$fails->{status}.": Fail";
			$source{errorMessage}=$fails->{errorMessage};
		} 
		else{
			$source{status}="200: OK";	
		}
		delete $source{call};
		push @meta, \%source;	
	}
	return \@meta
}

sub load_adapters {
	my $adapters_file = shift;
	open( my $ADA, "<$adapters_file" )
	  or die "Cannot load adapter configuration file $adapters_file: $!";
	my @adapters = (<$ADA>);
	close $ADA;
	my $adapters_ref = decode_json( join '', @adapters );
	return $adapters_ref;
}

1;
