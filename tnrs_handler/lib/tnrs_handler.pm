package tnrs_handler;
use Dancer ':syntax';
use JSON;
use Digest::MD5 qw(md5_hex);

#use tnrs_handler::resolver;

our $VERSION = '0.1';
my$config_file_path="/home/nmatasci/test.cfg";
my$cfg=load_config($config_file_path);
my$adapters_file=$cfg->{adapters};
my$tempdir=$cfg->{tempdir};
my$storage=$cfg->{storage};


prefix '/1';


get '/' => sub {
    template 'index';
};

any ['post'|'get'] => '/submit'  => sub {
	#examine contents
	my$para=request->params;
	if ($para->{file}){
		#upload the file
		my $file  = request-> upload($para->{file});
		print $file->size;
		#send the names to processing
	}
	elsif ($para->{names}) {
		#send the names to processing
		return "names\n"
	}
	else{
		status 'bad_request';
		return "Please specify either an input file or a list of names\n";	
	}
};



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
