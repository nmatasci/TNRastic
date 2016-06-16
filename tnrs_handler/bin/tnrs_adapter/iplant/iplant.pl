#!/usr/bin/perl -w

use warnings;
use strict;

use JSON;

require 'iPlant.pm';

# We'll get the list of names on stdin.
my @names = <STDIN>;

my $iplant = iPlant->new();
print encode_json $iplant->lookup(@names);
