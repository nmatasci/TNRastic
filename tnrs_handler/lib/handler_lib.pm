# Package handler_lib: Libraries of function to implement a core TNRastic API.
# Author: Naim Matasci <nmatasci@iplantcollaborative.org>
#
# The contents of this file are subject to the terms listed in the LICENSE file you received with this code.
# Copyright (c) 2012, The Arizona Board of Regents on behalf of
# The University of Arizona
#
###############################################################################

package handler_lib;
use strict;
use Exporter;

use tnrs_resolver qw(process);
use Parallel::ForkManager;
use JSON;

our @ISA    = qw(Exporter);
our @EXPORT = qw(get_cfg call_fun);

our $VERSION = '0.1.1';

#################################
#Constants
#################################

#List of the functions that can be called through the call mechanism
my $CALLS = {
	sources_list         => \&sources_list,
	sources_SourceId     => \&sources_SourceId,
	admin_reload_sources => \&admin_reload_sources,
	submit               => \&submit,
	retrieve_Job_id      => \&retrieve_Job_id,
	delete_Job_id        => \&delete_Job_id,
};

#Global configuration file
my $cfg;

#################################
#Public functions
#################################

#Initializes the global configuration
sub get_cfg {
	$cfg = _init(@_);
	return $cfg;
}

#Function wrapper.
#The handler module can only access the call functions through this wrapper.
sub call_fun {
	my $fun = shift;
	if ( !exists $CALLS->{$fun} ) {
		return encode_json {
			'status'  => 'invalid',
			'message' => "This function is not supported"
		};
	}
	else {
		return $CALLS->{$fun}->(@_);
	}
}

#################################
#Call functions
#################################

#Submit a job
sub submit {
	my ( $tmpdir, $filename ) = @_;
	my $res = _submit( $tmpdir, $filename );
	if ( !$res ) {
		return encode_json(
			{
				'status' => 'internal_server_error',
				'message' =>
"Error: The job $filename could not be submitted. Please try again later."
			}
		);
	}
	return encode_json(
		{
			'status'  => 'OK',
			'message' => "Job $filename has been successfully submitted."
		}
	);

}

#Cancel a running job
sub delete_Job_id {
	my $job_id = shift;

	#The job has completed
	if ( -f "$cfg->{storage}/$job_id.json" ) {
		return encode_json(
			{
				'status'  => 'found',
				'message' => "The requested job $job_id has completed.",
			}
		);
	}

	#The job has not completed, but there in no lock
	elsif ( !-f "$cfg->{tempdir}/.$job_id.lck" ) {

		return encode_json(
			{
				'status'  => 'not_found',
				'message' => "Error. Job $job_id does not exits."
			}
		);
	}

	#The job can be canceled
	else {
		my $ok = _delete($job_id);
		if ( !$ok ) {
			return encode_json(
				{
					'status'  => 'internal_server_error',
					'message' => "Error: $job_id could not be canceled."

				}
			);
		}
		else {
			return encode_json(
				{
					'status'  => 'OK',
					'message' => "Job $job_id has been canceled."

				}
			);
		}
	}
}

#Retrieves the results of a resolution job.
sub retrieve_Job_id {
	my $job_id = shift;

	#If the result is available it can be returned (output file is present).
	if ( -f "$cfg->{storage}/$job_id.json" ) {
		open( my $RF, "<$cfg->{storage}/$job_id.json" )
		  or return encode_json(
			{
				'status' => 'internal_server_error',
				'message' =>
"Error: Job $job_id could not be retrieved. Please try again later."
			}
		  );
		my @tmp = (<$RF>);
		close($RF);

		my $res = join '', @tmp;    #is already JSON
		$res =~ s/^\{/{"status":"OK",/;
		return $res;
	}

#The job has been started but hasn't finished yet (no output file but lock present)
	elsif ( -f "$cfg->{tempdir}/.$job_id.lck" ) {
		return encode_json(
			{
				'status' => 'found',
				'message' =>
"Job $job_id is still being processed. Please try refreshing in a few seconds."
			}
		);
	}

	#The job cannot be found (no output file and no lock).
	else {
		return encode_json(
			{
				'status'  => 'not_found',
				'message' => "Error: Job $job_id does not exit."
			}
		);
	}

}

#Administrative function to reload the adapter file.
sub admin_reload_sources {
	my $key = shift;

	my $nm = _load_modules( $cfg->{adapters_file} );
	if ($nm) {
		$cfg->{modules} = $nm;

	}
	else {
		return encode_json(
			{
				'status' => 'internal_server_error',
				'message' =>
				  "Error: Could not load adapter file $cfg->{adapters_file}."
			}
		);
	}

	my $resp = {
		'status' => 'OK',
		'message' =>
		  "File $cfg->{adapters_file} has been successfully reloaded.",
		'adapters' => $cfg->{modules}->{adapters}
	};
	return encode_json($resp);
}

#List the available sources (adaptors)
sub sources_list {
	my @sources;
	foreach ( @{ $cfg->{modules}->{adapters} } ) {
		$sources[ $_->{rank} ] = $_->{sourceId};

	}
	@sources = grep { defined } @sources;
	return encode_json(
		{
			'status'  => 'OK',
			'sources' => \@sources
		}
	);

}

#Retrive the source details. If no argument is passed, returns the details for all the available sources.
sub sources_SourceId {
	my $sourceId = shift;

	#No id specified. Returns the details of all the sources.
	if ( !$sourceId ) {
		return encode_json(
			{
				'status'  => 'OK',
				'sources' => $cfg->{modules}->{adapters}
			}
		);
	}

	my @sources = @{ $cfg->{modules}->{adapters} };

	#Problem: There are no sources.
	if ( !@sources ) {
		return encode_json(
			{
				'status' => 'internal_server_error',
				'message' =>
				  "Error: Could not find any source. Please try again later."
			}
		);
	}

	#Returns the details of a specific source.
	for (@sources) {
		if ( $_->{sourceId} eq $sourceId ) {
			return encode_json(
				{
					'status'   => 'OK',
					'sourceId' => $sourceId,
					'details'  => $_
				}
			);
		}
	}

	#The sourceId doesn't corrispond to any of the available sources
	return encode_json(
		{
			'status'  => 'not_found',
			'message' => "Error: Source $sourceId does not exist."
		}
	);
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

	#load adapters registry
	$cfg_ref->{modules} = _load_modules( $cfg_ref->{adapters_file} );
	$cfg_ref->{modules}->{spellers} =
	  _load_modules( $cfg_ref->{spellers_file} )->{spellers};

	#Creates the tempdir
	my $tempdir = $cfg_ref->{tempdir};
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

	#Creates the output directory
	mkdir $cfg_ref->{storage};

	#The same configuration is used by the handler module.
	return $cfg_ref;
}

#Forks a process to interrogate the TNRSs
sub _submit {
	$SIG{CHLD} = "IGNORE";    #Avoids zombie processes
	my ( $tmpdir, $filename ) = @_;
	fork
	  and
	  return 1;   #Spawn a child process and returns to the http handler fuction

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

	process( "$cfg->{tempdir}/$filename.tmp", $cfg->{modules},
		$cfg->{storage} );

	unlink "$cfg->{tempdir}/.$filename.lck";

	#	$n_pids--;

	kill 9, $pid;    #Process commits suicide
}

#Kills a running job
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

#Load the modules file during the initialization process.
sub _load_modules {
	my $modules_file = shift;
	open( my $MOD, "<$modules_file" )
	  or die "Cannot load adapter configuration file $modules_file: $!";
	my @modules = (<$MOD>);
	close $MOD;
	my $modules_ref = decode_json( join '', @modules );
	return $modules_ref;
}

1;
