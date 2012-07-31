# Package tnrs_handler: Web services for a TNRastic API.
# Author: Naim Matasci <nmatasci@iplantcollaborative.org>
#
# The contents of this file are subject to the terms listed in the LICENSE file you received with this code.
# Copyright (c) 2012, The Arizona Board of Regents on behalf of
# The University of Arizona
#
###############################################################################

package tnrs_handler;
use handler_lib qw(get_cfg call_fun);
use Dancer ':syntax';
use JSON;
use Digest::MD5 qw(md5_hex);

our $VERSION = '2.1.0';

my $config_file_path = "handler_config.json";
my $cfg              = get_cfg($config_file_path);

my $n_pids = 0;

#TODO: Add cache

#Wrapper for the external call function
#All the functions except su
sub call {
	my $res = call_fun(@_);

	if ( !$res || $res !~ m/\"status\":\"(\w+)\"/ ) {
		status 'internal_server_error';
		$res = $res ? " :$res" : '';
		return encode_json(
			{
				'status'  => 'internal_server_error',
				'message' => "General error$res. Please try again later.",
			}
		);
	}
	status $1;
	return $res;
}

#Information
get '/' => sub {
	template 'index' => { host => $cfg->{host}, version => $VERSION };
};

#Only for debugging purposes
get '/wait' => sub {
	sleep 10;
};

#Status
any [ 'get', 'post' ] => '/status' => sub {
	return encode_json( { "status" => "OK" } );
};

#Sources
get '/sources/list' => sub {
	return call('sources_list');
};

#Information on available sources
get '/sources/:sourceId?' => sub {
	return call( 'sources_SourceId', param('sourceId') );
};

#Admin tool to cause a reload of the adapter files
get '/admin/reload_sources' => sub {
	my $key = param('key');
	if ( !$key ) {
		return _error( 'bad_request', "Please provide the admin key." );
	}
	elsif ( !_is_valid($key) ) {
		return _error( 'forbidden', "The submitted key is not valid." );
	}
	else {
		return call( 'admin_reload_sources', $key );
	}
};

#Submit
any [ 'post', 'get' ] => '/submit' => sub {

	my $para = request->params;

	if ( !defined($para) || ( !$para->{query} && !$para->{file} ) ) {
		return _error( 'bad_request',
"Please provide an input list of newline separated names: $para->{query}"
		);
	}

	my $fn;    #name of the temporary file = token = job id

	if ( $para->{query} ) {
		$fn = _stage( $para->{query} );
	}
	elsif ( $para->{file} ) {
		my $upload = request->uploads->{file};
		$fn = md5_hex( $upload->content, time );
		$upload->copy_to("$cfg->{tempdir}/$fn.tmp");
	}

	my $date = localtime
	  ;    #For some reason, printing localtime directly doesn't format properly
	info "Request submitted\t$date\t", request->address(), "\t",
	  request->user_agent();    #Writes the request to the log

	my $res = call( 'submit', $cfg->{tempdir}, $fn );

	if ($res) {
		return _build_response( $fn, $date );
	}
	else {
		return _error();
	}
};

#Retrieve
get '/retrieve/:job_id?' => sub {
	if ( !defined( param('job_id') ) ) {
		return _error( 'bad_request',
"Please specify a job id. Usage: GET $cfg->{'host'}/retrieve/&ltjob_id&gt"
		);
	}
	return call( 'retrieve_Job_id', param('job_id') );
};

#Canceling a running job
any [ 'del', 'get', 'post' ] => '/delete/:job_id?' => sub {
	if ( !defined( param('job_id') ) ) {
		return _error( 'bad_request',
"Please specify a job id. Usage: DELETE | GET | POST $cfg->{'host'}/delete/&ltjob_id&gt"
		);
	}
	return call( 'delete_Job_id', param('job_id') );
};

#Stores a submitted list of names in a temporary file
sub _stage {
	my $names = shift;
	my $fn = md5_hex( $names, time );
	open( my $TF, ">$cfg->{tempdir}/$fn.tmp" ) or return _error();
	print $TF $names;
	close $TF;
	return $fn;
}

#Error handling
sub _error {
	my $status = shift();
	my $msg    = shift();

	$status = $status ? $status : 'internal_server_error';
	status $status;
	$msg = $msg ? $msg : "General error: Please try again later.";
	return encode_json(
		{
			'status'  => $status,
			'message' => $msg
		}
	);
}

#Build the response to a successful submission.
sub _build_response {
	my ( $fn, $date ) = @_;
	my $uri = "$cfg->{host}/retrieve/$fn";

	my $json = {
		'status'      => 'found',
		'submit date' => $date,
		'version'     => $VERSION,
		'token'       => $fn,
		'uri'         => $uri,
		'message' =>
"Your request is being processed. You can retrieve the results at $uri."
	};
	status 'found';
	redirect $uri;
	return encode_json($json);
}

#Dummy function to authorize administrative functions
sub _is_valid {
	my $key = shift;
	if ( $key == 12345 ) {
		return 1;
	}
	else {
		return 0;
	}
}

1;
