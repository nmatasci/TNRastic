
use strict;
use JSON;

our @VERSION=1.0;


sub process{
	my$names_file=shift;
	my$adapters_file=shift;
	my$target_dir=shift;
	
	#output name
	my$jobId=(split qr(\/), $names_file)[-1];
	$jobId=(split(qr(\.),$jobId))[0];
	
	#date
	my$sub_date=localtime;
	
	#load the names to process
	open(my$NF,"<$names_file") or return "Cannot load names file: $!\n";
	my@names=(<$NF>);
	close $NF;
	
	#load adapters registry
	my$ad_ref=load_adapters($adapters_file);
	my$res=query_sources(join('',@names),$ad_ref);
	$res=merge($res);
	write_output($res,"$target_dir/$jobId.json",$jobId,$sub_date, $ad_ref);
	kill $names_file;
	return 0;
}

#TODO: Parallelize
#send the name batch to each adapter
sub query_sources{
	my$names_file=shift;
	my$adapters_ref=shift;
	my@results;
	foreach(@{$adapters_ref}){
		my%source=%{$_};
		my$res=decode_json(system("cat $names_file | $source{call}")); 
		$res->{sourceId}=$source{id};
		$res->{sourceRank}=$source{rank};
		push @results, $res;
	}
	return \@results;
}

#merge names returned by adapters
sub merge {
	my$results=shift;
	my%matches;
	foreach(@{$results}){ #for every source
		my$res=$_;
		if($res->{status} ne 200){ #there was a failure
#TODO: Error message should go in the job source metadata
			next;	
		}
		my$sourceid=$res->{sourceId};
		my$rank=$res->{rank};
		my@names=@{$res->{names}}; 
		foreach(@names){ #for all the submitted names
			my%input=%{$_};
			
#			#initializes the array if it doesn't exist yet
#			if(!$matches{$input{submittedName}}) { 
#				$matches{$input{submittedName}} =();			
#			}

			#builds the output object
			my$output = {
				sourceId=>$sourceid,
				matchedName=>$input{matchedName},
				acceptedName=>$input{acceptedName},
				uri=>$input{uri},
				score=>$input{score},
				annotations=>$input{annotations}
			};
			
			@{$matches{$input{submittedName}}}[$rank]=$output;
		} #end of submitted names	
		
	} #end of source
	return \%matches;
}


sub write_output{
	my$output=shift;
	my$filename=shift;
	my$jobid=shift;
	my$sub_date=shift;
	my$sources=extract_meta(shift); #extract the source metadata from the adapters
	
	
	my$meta={
		jobId => $jobid,
		sources => $sources,
		sub_date => $sub_date
	};
	$output->{metadata}=$meta;
	$output = encode_json($output);
	open(my$OF,">$filename") or return "Cannot open output file $filename: $!\n";
	print $OF $output;
	close $OF;
	return 0;
}

#Extract metadata from the sources
sub extract_meta{
	return my%dummy;
}

sub load_adapters{
	my$adapters_file=shift;
	open(my$ADA, "<$adapters_file") or die "Cannot load adapter configuration file $adapters_file: $!";
	my@adapters=(<$ADA>);
	close $ADA;
	my$adapters_ref=decode_json(join '',@adapters); 
	return $adapters_ref;
}