package handler_lib;
use strict;
use Exporter; 

use tnrs_resolver qw(process);
use Parallel::ForkManager;
use JSON;

our @ISA    = qw(Exporter);
our @EXPORT = qw(get_cfg call_fun);


our $VERSION = '0.0.1';



my$CALLS={
	sources_list => \&sources_list,
	sources_SourceId => \&sources_SourceId,
	admin_reload_sources => \&admin_reload_sources,
	_submit => \&_submit,
	retrieve_Job_id => \&retrieve_Job_id,
	delete_Job_id => \&delete_Job_id,
};

my$cfg;



#################################
#Public functions
#################################
sub get_cfg {
	$cfg=_init(@_);
	return $cfg;	
}

sub call_fun{
	my$fun = shift;
	if(! exists $CALLS->{$fun}){
		return encode_json {'status'=>'invalid', 'message'=>"This function is not supported"};
	}
	else{
		return $CALLS->{$fun}->(@_);
	}
}




#################################
#Call functions
#################################

sub delete_Job_id {
	my$job_id=shift;
	#The job has completed
	if ( -f "$cfg->{storage}/$job_id.json" ) {
		return encode_json ({
			'status' =>'found',
			'message' =>
"The requested job $job_id has completed. You can retrieve the results at $cfg->{host}/retrieve/$job_id",
			'uri' => "$cfg->{host}/retrieve/$job_id",
		});
	}

	#The job has not completed, but there in no lock
	elsif ( !-f "$cfg->{tempdir}/.$job_id.lck" ) {
		
		return encode_json(
			{ 'status' => 'not_found',
			 'message' => "Error. Job $job_id does not exits." 
			});
	}

	#The job can be canceled
	else {
		my $ok = _delete($job_id);
		if ( !$ok ) {
			return encode_json(
				{ 'status'=>'internal_server_error',
					'message' => "Error: $job_id could not be canceled." 
					
				} );
		}
		else {
			return encode_json(
				{ 'status'=>'OK',
					'message' => "Job $job_id has been canceled." 
					
				} );
		}
	}
	
	
	
}


sub retrieve_Job_id {
	my$job_id=shift;
	if ( -f "$cfg->{storage}/$job_id.json" ) {
		open( my $RF, "<$cfg->{storage}/$job_id.json" ) or 
			return encode_json({			
				'status'=>'internal_server_error',
				'message' => "Error: Job $job_id could not be retrieved. Please try again later." 
				} );	
		my @tmp = (<$RF>);
		close($RF);
		my$res=join '', @tmp;    #is already JSON
		$res=~ s/^\{/{"status":"OK",/;
		return $res;
	}
	elsif ( -f "$cfg->{tempdir}/.$job_id.lck" ) {
		return encode_json({
			'status'=>'found',
			'message' => "Job $job_id is still being processed. Please try refreshing in a few seconds." 
				} );	
	}
	else {
		return encode_json({
			'status' => 'not_found',
			'message' => "Error: Job $job_id does not exit."
		});
	}
	
}


sub admin_reload_sources {
		my$key=shift;

			my$nm = _load_adapters($cfg->{adapters_file});
			if($nm) {
				$cfg->{modules} = $nm;
				
			}
			else {
				return encode_json({
					'status' => 'internal_server_error',
					'message' => "Error: Could not load adapter file $cfg->{adapters_file}."
				});
			} 	
		
		my$resp={
			'status' => 'OK',	
			'message'=>"File $cfg->{adapters_file} has been successfully reloaded.",
			'adapters' => $cfg->{modules}->{adapters}
		};
		return encode_json($resp);		
}



sub sources_list{
		my@sources;
	foreach ( @{ $cfg->{modules}->{adapters} } ) {
		$sources[$_->{rank}] = $_->{sourceId};
		
	}
	@sources=grep { defined } @sources;
	return encode_json( {
		'status' => 'OK',
		'sources' => \@sources
	} );
	
}

sub sources_SourceId {
	my$sourceId=shift;
	if(! $sourceId){
		return encode_json({
			'status' => 'OK',
			'sources'=> $cfg->{modules}->{adapters}
		});		
	}	
	my@sources=@{ $cfg->{modules}->{adapters} };
	if(! @sources) {
		return encode_json({
			'status' => 'internal_server_error',
			'message' => "Error: Could not find any source. Please try again later."
		});
	}
#	if($source{$sourceId}){
#			
#		return encode_json({
#			'status' => 'OK',
#			'sources'=> $cfg->{modules}->{adapters}->{$sourceId};
#		});		
#	}
	for(@sources){
		if ($_->{sourceId} eq $sourceId){
			return encode_json({
				'status'=>'OK',
				'sourceId'=>$sourceId,
				'details'=> $_
			});	
		}
	}
	return encode_json({
		'status' => 'not_found',
		'message' => "Error: Source $sourceId does not exist."
	});
}


#################################
#Accessory functions
#################################


#Initialization function
sub _init {
	my $config_file = shift;
	open( my $CFG, "<$config_file" )
	  or die "Cannot load handler configuration file $config_file: $!";
	my @cfg = (<$CFG>);
	close $CFG;
	my $cfg_ref = decode_json( join '', @cfg );
	my $host = $cfg_ref->{host};
	$host = $cfg_ref->{port} ? "$host:" . $cfg_ref->{port} : $host;
	$cfg_ref->{host} = $host;
	
	#load adapters registry
	$cfg_ref->{modules} = _load_adapters($cfg_ref->{adapters_file});
	$cfg_ref->{modules}->{spellers} = _load_adapters($cfg_ref->{spellers_file})->{spellers};
	 
	my $tempdir = $cfg_ref->{tempdir};

	#Creates the tempdir
	mkdir $tempdir;

	#Wipe the tempdir clean
	eval {
		opendir( my $DIR, $tempdir ) || die "can't opendir $tempdir: $!";
		my @files = grep ( !/^\.+$/, readdir $DIR );
		closedir $DIR;
		for (@files) {
			my $k = unlink "$tempdir/$_";
		}
	};
	mkdir $cfg_ref->{storage};
	return $cfg_ref;
}

#Forks a process to interrogate the TNRSs
sub _submit {
	$SIG{CHLD} = "IGNORE";    #Avoids zombie processes
	my ( $tmpdir, $filename ) = @_;
	fork
	  and return 1; #Spawn a child process and returns to the http handler fuction

	#Following code run by the children

	my $pid = $$;    #PID of the child process

	open( my $PIDF, ">$cfg->{tempdir}/.$filename.lck" )
	  or die "Cannot open .$filename.lck: $!\n";
	print $PIDF "$pid";
	close $PIDF;

	#	$n_pids++;
	#	if ( $n_pids >= $cfg->{MAX_PIDS} ) {
	#		sleep $n_pids * 10;
	#	}

	process( "$cfg->{tempdir}/$filename.tmp", $cfg->{modules}, $cfg->{storage} );

	unlink "$cfg->{tempdir}/.$filename.lck";

	#	$n_pids--;

	kill 9, $pid;    #Process commits suicide
}

sub _delete {
	my $job_id = shift;
	open( my $LOCK, "<$cfg->{tempdir}/.$job_id.lck" ) or return 0;
	my $pid = <$LOCK>;
	close $LOCK;

	#kill the job
	kill 9, $pid;

	#remove the lock
	unlink "$cfg->{tempdir}/.$job_id.lck";

	#remove the name file
	unlink "$cfg->{tempdir}/$job_id.tmp";
	return 1;
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

1;