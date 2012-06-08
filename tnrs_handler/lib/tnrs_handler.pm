package tnrs_handler;
use Dancer ':syntax';
use Parallel::ForkManager;
use JSON;
use Digest::MD5 qw(md5_hex);

our $VERSION = '0.1';

#my$config_file_path="/home/nmatasci/test.cfg";
##my$cfg=load_config($config_file_path);
#my$adapters_file=$cfg->{adapters};
#my$tempdir=$cfg->{tempdir};
#my$storage=$cfg->{storage};
my $storage       = "/home/nmatasci/TNRastic/testdata/out";
my $adapters_file = "tnrs_adapter/adapters.json";
my $host          = "http://128.196.142.37:3000";
my $tempdir       = "/tmp/tnrs_handler";
my $n_pids        = 0;
my $MAX_PIDS      = 5;
#make the tempdir
my$f=mkdir $tempdir;
print "$f\n";
#wipe the tempdir
opendir(my$DIR, $tempdir) || die "can't opendir $tempdir: $!";
my@files= grep (!/^\.+$/ , readdir $DIR);
closedir $DIR;
for(@files){
	my$k=unlink "$tempdir/$_";
}


#TODO: error messages as JSON
#TODO: Date format
#TODO: Config loader
#TODO: Count sources
#TODO: Sources metadata

get '/' => sub {
	template 'index';
};
any [ 'get', 'post' ] => '/status' => sub {
	return "Up!\n";
};

any [ 'post', 'get' ] => '/submit' => sub {

	#examine contents
	wait;
	my $para = request->params;

	if ( !defined($para) || !$para->{query} ) {
		status 'bad_request';
		return "Please specify a list of newline separated names\n";
	}
	else {
		my $names = $para->{query};
		my $fn = md5_hex( $names, time );
		open( my $TF, ">$tempdir/$fn.tmp" ) or error_code('generic');
		print $TF $names;
		close $TF;

		my $status = submit("$tempdir/$fn.tmp");

		my $uri  = "$host/$fn";
		my $date = localtime;
		my $json = {
			"submit date" => $date,
			token         => $fn,
			uri           => "$host/retrieve/$fn",
			message       =>
"Your request is being processed. You can retrieve the results at $host/retrieve/$fn."
		};
		return encode_json($json);
	}
};

get '/retrieve/:job_id' => sub {
	wait;
	my $job_id = param('job_id');
	if ( -f "$storage/$job_id.json" ) {
		open( my $RF, "<$storage/$job_id.json" ) or error_code("generic");
		my @tmp = (<$RF>);
		close($RF);
		return join '', @tmp;
	}
	elsif ( -f "$tempdir/$job_id.tmp" ) {

	#TODO: add test for freshness: if request is older then 24h, then return 404
		status 'accepted';
		return "Job $job_id is still being processed.\n";
	}
	else {
		status 'not_found';
		return "Error. Job $job_id doesn't exits.\n";
	}

};

sub error_code {
	status 'internal_server_error';
	return "General error. Please retry later\n";

}

sub submit {
	wait;
	my $filename = shift;
	my $pm       = new Parallel::ForkManager(2);

	$n_pids++;
	my $pid = $pm->start and return;
	if ( $n_pids >= $MAX_PIDS ) {
		sleep $n_pids * 10;
	}
	system "./resolver.pl $filename $adapters_file $storage"
	  ;    # Some long running process.
	$n_pids--;
	$pm->finish;

}

true;
