#!/usr/bin/perl -w

use warnings;
use strict;

use JSON;

require 'ITIS.pm';

# We'll get the list of names on stdin.
my @names = <STDIN>;
chomp @names;

my $itis = ITIS->new();
print encode_json $itis->lookup(@names);
