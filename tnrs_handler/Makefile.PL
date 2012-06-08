use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'tnrs_handler',
    AUTHOR              => q{Naim Matasci <nmatasci@iplantcollaborative.org>, Siavash Mirarab <smirarab@gmail.com>, Gaurav Vaidya <gaurav@ggvaidya.com> },
    VERSION_FROM        => 'lib/tnrs_handler.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3095,
        'Parallel::ForkManager' => 0,
        'Digest::MD5' => 0,
        'JSON' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'tnrs_handler-*' },
);
