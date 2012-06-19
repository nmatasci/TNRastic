#!/usr/bin/env perl
use Dancer;
use tnrs_handler;
my$k=dance;
open my$PIDF, ">../.tnrs_handler.pid" or die "Cannot write pid file $k: $!\n";
print $PIDF $k;
close $PIDF;