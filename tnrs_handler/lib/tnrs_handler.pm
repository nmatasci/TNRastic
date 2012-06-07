package tnrs_handler;
use Dancer ':syntax';
use JSON;
use Digest::MD5 qw(md5_hex);

#use tnrs_handler::resolver;

our $VERSION = '0.1';
#my$config_file_path="/home/nmatasci/test.cfg";
##my$cfg=load_config($config_file_path);
#my$adapters_file=$cfg->{adapters};
#my$tempdir=$cfg->{tempdir};
#my$storage=$cfg->{storage};
my$storage="/home/nmatasci/TNRastic/testdata";

#prefix '/1';


get '/' => sub {
    template 'index';
};

any ['post'|'get'] => '/submit'  => sub {
	#examine contents
	my$para=request->params;

	if(!defined($para)){
		status 'bad_request';
		return "Please specify either an input file or a list of names\n";	
	}
	else{
		return "1234";	
	}
};

get '/retrieve/:job_id' => sub {
	my$job_id=param('job_id');
	if(-f "$storage/$job_id.out"){
		open (my$RF,"<$storage/$job_id.out") or error_code("generic");
		my@tmp=(<$RF>);
		close($RF);
		return join '',@tmp;
	} 
#TODO: add test for freshness: if request is older then 24h, then return 404
	status 'accepted';
	return "Job $job_id is still being processed\n";
	
	
};

sub error_code{
	status 'internal_server_error';
	return "General error. Please retry later\n";
	
}



sub submit{
	my$names=shift;
	my$filename=shift;
	#create temp file
	open(my $TF, ">$filename.tmp");
	#call resolver.pl w name file	
	my $pid = fork;
	if(!defined($pid)) {
		return "Unable to fork $!";
	}
    exec "./resolver.pl $names";  # Some long running process.
		return "Unable to start resolver: $!"
}
	
	



true;
