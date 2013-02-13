#!/usr/bin/env perl
use Dancer;
use tnrs_handler;

  set 'logger'       => 'console';
  set 'log'          => 'debug';
  set 'show_errors'  => 1;
  set 'startup_info' => 1;
  set 'warnings'     => 0;

my$k=dance;
open my$PIDF, ">../.tnrs_handler.pid" or die "Cannot write pid file $k: $!\n";
print $PIDF $k;
close $PIDF;