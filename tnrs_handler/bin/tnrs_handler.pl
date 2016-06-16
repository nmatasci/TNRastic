#!/usr/bin/env perl
use Dancer;
use tnrs_handler;

use FindBin '$RealBin';
my$script_loc=path($RealBin,'..','bin');
chdir "$script_loc";


  set 'logger'       => 'file';
  set 'log'          => 'error';
  set 'show_errors'  => 0;
  set 'startup_info' => 1;
  set 'warnings'     => 0;

my$k=dance;
#open my$PIDF, ">$ENV{HOME}/.tnrs_handler.pid" or die "Cannot write pid file $k: $!\n";
#print $PIDF $k;
#close $PIDF;
