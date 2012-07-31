# Package tnrs_resolver: Submit lists of taxonomic names to TNRSs and consolidates the results
# Author: Naim Matasci <nmatasci@iplantcollaborative.org>
#
# The contents of this file are subject to the terms listed in the LICENSE file you received with this code.
# Copyright (c) 2012, The Arizona Board of Regents on behalf of
# The University of Arizona
#
###############################################################################

package tnrs_resolver;
use strict;
use JSON;
use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(process);

our $VERSION = '1.1.0';

sub process {
	my $names_file = shift;
	my $ad_ref     = shift;
	my $target_dir = shift;
	my $do_spell   = shift;
	if ( !$ad_ref->{spellers} ) {
		$do_spell = 0;
	}

	#output name
	my $jobId = ( split qr(\/), $names_file )[-1];
	$jobId = ( split( qr(\.), $jobId ) )[0];

	#date
	my $sub_date = localtime;

	my ( $res, $fail ) = query_sources( $names_file, $ad_ref, 'adapters' );

	$res = merge($res);
	if ( $do_spell && _find_mismatches( $res, $names_file ) )
	{    #Identify matches with score < 1 and stores them in a name file
		    #spell check
		my ( $spell_res, $spell_fail ) =
		  query_sources( $names_file, $ad_ref, 'spellers' );
		$spell_res = merge($spell_res);

		#match newly spelled names
		my $name_map = _make_name_map( $spell_res, $names_file )
		  ;    #write name file with correctly spelled names

		( $spell_res, $spell_fail ) =
		  query_sources( $names_file, $ad_ref, 'adapters' )
		  ;    #query spellechecked names
		$spell_res = merge($spell_res);

		$res = _restore( $res, $spell_res, $name_map )
		  ;    #replace old results with new results
	}
	write_output( $res, "$target_dir/$jobId.json", $jobId, $sub_date, $ad_ref,
		$fail );

	unlink $names_file;
	return 0;
}

#TODO: Parallelize
#send the name batch to each adapter
sub query_sources {
	my $names_file   = shift;
	my $adapters_ref = shift;
	my $mode         = shift;
	my @results;
	my $failures;
	foreach ( @{ $adapters_ref->{$mode} } ) {
		my %source = %{$_};

		my $input = `cat $names_file | $source{call} 2>/dev/null`
		  ;    #TODO: redirect STDERR to logs
		my $res;
		eval {
			$res = decode_json($input);

			$res->{sourceId}   = $source{sourceId};
			$res->{sourceRank} = $source{rank};
		};

		if ( !$res || !defined( $res->{status} ) ) {
			$failures->{ $source{sourceId} } =
			  { status => 500, errorMessage => 'General failure/Unknown' };
		}
		elsif ( $res && $res->{status} == 200 ) {
			push @results, $res;
		}
		else {
			$failures->{ $source{sourceId} } = {
				status       => $res->{status},
				errorMessage => $res->{errorMessage}
			};
		}
	}
	return ( \@results, $failures );
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
		foreach (@names) {       #for all the submitted names
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
	my $ad_refs  = shift;
	my $fails    = shift;

	my $output;

	my $meta = {
		jobId   => $jobid,
		sources => _extract_meta( $ad_refs, $fails )
		,    #extract the source metadata from the adapters and the failures
		sub_date         => $sub_date,
		resolver_version => $VERSION,
		spellcheckers    => $ad_refs->{'spellers'}
	};

	$output->{metadata} = $meta;
	my @names;

	for my $key ( keys %{$results} ) {
		my @matches = grep { defined } @{ $results->{$key} };
		my $entry = {
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

sub _extract_meta {
	my $sources = shift;
	my $fails   = shift;
	my @meta;
	foreach ( @{ $sources->{adapters} } ) {
		my %source = %{$_};
		if ( $fails->{ $source{sourceId} } ) {
			$source{status} =
			  $fails->{ $source{sourceId} }->{status} . ": Fail";
			$source{errorMessage} =
			  $fails->{ $source{sourceId} }->{errorMessage};
		}
		else {
			$source{status} = "200: OK";
		}
		delete $source{call};
		push @meta, \%source;
	}
	return \@meta;
}

sub _load_adapters {
	my $adapters_file = shift;
	open( my $ADA, "<$adapters_file" )
	  or die "Cannot load adapter configuration file $adapters_file: $!";
	my @adapters = (<$ADA>);
	close $ADA;
	my $adapters_ref = decode_json( join '', @adapters );
	return $adapters_ref;
}

sub _find_mismatches {
	my $res       = shift;
	my $name_file = shift;
	my @no_match;
	for my $key ( keys %{$res} ) {
		my @matches = grep { defined } @{ $res->{$key} };
		my $max_score = 0;
		for (@matches) {
			if ( $_->{score} == 1 ) {
				$max_score = 1;
				last;
			}
			if ( $_->{score} > $max_score ) {
				$max_score = $_->{score};
			}
		}
		if ( $max_score < 1 ) {
			push @no_match, $key;
		}
	}
	if ( !@no_match ) {
		return 0;
	}

	#write new name file
	open( my $NFN, ">$name_file" );
	print $NFN join "\n", @no_match;
	close $NFN;
	return 1;

}

sub _make_name_map {
	my $res       = shift;
	my $name_file = shift;
	my %name_map;
	for my $submitted ( keys %{$res} ) {
		my @matches = grep { defined } @{ $res->{$submitted} };

		my %names;
		for (@matches) {
			$names{ $_->{'matchedName'} } = 1;
		}
		@matches = keys %names;
		if ( @matches > 1 ) {
			warn "Alternative spellings for $submitted!\n";
		}

		$name_map{ shift @matches } = $submitted;
	}

	#write new name file
	open( my $NFN, ">$name_file" );
	print $NFN join "\n", keys %name_map;
	close $NFN;
	return \%name_map;
}

sub _restore {
	my ( $res, $spell_res, $map ) = @_;

	for my $checked ( keys %{$spell_res} ) {

		my @matches          = @{ $spell_res->{$checked} };
		my $original_name    = $map->{$checked};
		my @original_matches = @{ $res->{$original_name} };

		for ( my $i = 0 ; $i < @matches ; $i++ ) {
			if ( !$matches[$i]->{acceptedName} ) {
				next;
			}

			if (  !$original_matches[$i]
				|| $matches[$i]->{score} > $original_matches[$i]->{score} )
			{    #There is a better match for the same source
				$original_matches[$i] =
				  $matches[$i];    #replace the original match with the new one
			}
		}

		$res->{$original_name} = \@original_matches;
	}
	return $res;
}
1;
