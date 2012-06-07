
use strict;
use JSON;

our @VERSION=1.0;

#load the registry file
#my$ads_ref=load_config();
process([1,2,3],1);
sub process{
	my$names_file=shift;
	my$adapters_file=shift;
	my$target_dir=shift;
	
	#output name
	my$jobId=(split qr(\/), $names_file)[-1];
	$jobId=(split(qr(\.),$jobId))[0];
	
	#data
#TODO:	#Find input file creation date
	my$sub_date="1 1 1";
	
	#obtain the names
	open(my$NF,"<$names_file") or return "Cannot load names file: $!\n";
	my@names=(<$NF>);
	close $NF;
	
	#load adapters registry
	my$ad_ref=load_adapters($adapters_file);
	my$res=query_sources($names_file,$ad_ref);
	$res=merge($res);
	write_output($res,"$target_dir/$jobId.json",$jobId,$sub_date, $ad_ref);
	kill $names_file;
	return 0;
}


#send the name batch to each adapter
sub query_sources{
	my$names_file=shift;
	my$adapters_ref=shift;
	my@results;
	foreach(@{$adapters_ref}){
		my%source=%{$_};
		my$res=decode_json(system("$source{call} $names_file")); #TODO: separate cases with names vs. filenames
		$res->{sourceId}=$source{id};
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
		my$sourceid=$res->{sourceId};
		my@names=@{$res->{names}}; 
		foreach(@names){ #for all the submitted names
			my%input=%{$_};
			
			#initializes the array if it doesn't exist yet
			if(!$matches{$input{submittedName}}) { 
				$matches{$input{submittedName}} =();			
			}

			#builds the output object
			my$output = {
				sourceId=>$sourceid,
				matchedName=>$input{matchedName},
				acceptedName=>$input{acceptedName},
				uri=>$input{uri},
				score=>$input{score},
				annotations=>$input{annotations}
			};
			
			push @{$matches{$input{submittedName}}}, $output;
		} #end of submitted names	
		
	} #end of source
	return \%matches;
}


sub write_output{
	my$output=shift;
	my$filename=shift;
	my$jobid=shift;
	my$sub_date=shift;
	my$sources=extract_meta(shift);
	
	
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
	
}

sub load_adapters{
	my$adapters_file=shift;
	open(my$ADA, "<$adapters_file") or die "Cannot load adapter configuration file $adapters_file: $!";
	my@config=(<$ADA>);
	close $ADA;
	my@adapters=decode_json(join '',@config);
	return \@adapters;
}