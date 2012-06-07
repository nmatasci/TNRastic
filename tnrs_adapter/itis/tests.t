#!/usr/bin/perl -w

use Test::More tests => 6;
use JSON;

require "ITIS.pm";

my $itis = ITIS->new();
isa_ok($itis, "ITIS", "Checking if we can create an itis object.");

my $result = encode_json $itis->lookup('Panthera');
is($result, q({"names":[{"submittedName":"Panthera","acceptedName":"Panthera","score":0.5,"matchedName":"Panthera","annotations":{"TSN":"180592","originalTSN":"180592"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=180592"}],"status":200,"errorMessage":""}), "Checking if the result from 'Panthera' is identical to expected.");

$result = encode_json $itis->lookup('Mangifera indica');
is($result, q({"names":[{"submittedName":"Mangifera indica","acceptedName":"Mangifera indica","score":0.5,"matchedName":"Mangifera indica","annotations":{"TSN":"28803","originalTSN":"28803"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=28803"}],"status":200,"errorMessage":""}), "Checking if the result from 'Mangifera indica' is identical to expected.");

$result = encode_json $itis->lookup('Eutamias minimus');
is($result, 
    q({"names":[{"submittedName":"Eutamias minimus","acceptedName":"Tamias minimus","score":0.5,"matchedName":"Eutamias minimus","annotations":{"TSN":"180195","originalTSN":"180144"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=180195"}],"status":200,"errorMessage":""}),
    "Checking if the result from 'Eutamias minimus' (accepted name: 'Tamias minimus') is identical to expected."
);

$result = $itis->lookup(
    'Iris confusa',
    'Iris cristata',
    'Iris gracilipes',
    'Iris japonica',
    'Iris lacustris' ,
    'Iris milesii',
    'Iris tectorum',
    'Iris tenuis',
    'Iris wattii',
    'Iris xiphium',
    'Iris boissieri',
    'Iris filifolia',
    'Iris juncea',
    'Iris latifolia',
    'Iris serotina',
    'Iris tingitana',
    'Iris xiphium',
    'Iris collettii',
    'Iris decora'
);

is(scalar(@{$result->{'names'}}), 19, "Checking number of returned names");

my $result_str = encode_json($result);
is($result_str, 
    qq<{"names":[{"submittedName":"Iris confusa","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris cristata","acceptedName":"Iris cristata","score":0.5,"matchedName":"Iris cristata","annotations":{"TSN":"43204","originalTSN":"43204"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=43204"},{"submittedName":"Iris gracilipes","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris japonica","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris lacustris","acceptedName":"Iris lacustris","score":0.5,"matchedName":"Iris lacustris","annotations":{"TSN":"43218","originalTSN":"43218"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=43218"},{"submittedName":"Iris milesii","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris tectorum","acceptedName":"Iris tectorum","score":0.5,"matchedName":"Iris tectorum","annotations":{"TSN":"507025","originalTSN":"507025"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=507025"},{"submittedName":"Iris tenuis","acceptedName":"Iris tenuis","score":0.5,"matchedName":"Iris tenuis","annotations":{"TSN":"43229","originalTSN":"43229"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=43229"},{"submittedName":"Iris wattii","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris xiphium","acceptedName":"Iris xiphium","score":0.5,"matchedName":"Iris xiphium","annotations":{"TSN":"43202","originalTSN":"43202"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=43202"},{"submittedName":"Iris boissieri","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris filifolia","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris juncea","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris latifolia","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris serotina","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris tingitana","acceptedName":"Iris tingitana","score":0.5,"matchedName":"Iris tingitana","annotations":{"TSN":"503205","originalTSN":"503205"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=503205"},{"submittedName":"Iris xiphium","acceptedName":"Iris xiphium","score":0.5,"matchedName":"Iris xiphium","annotations":{"TSN":"43202","originalTSN":"43202"},"uri":"http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=43202"},{"submittedName":"Iris collettii","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""},{"submittedName":"Iris decora","acceptedName":"","score":0,"matchedName":"","annotations":{},"uri":""}],"status":200,"errorMessage":""}>,
    "Checking 19 Iris spp");
