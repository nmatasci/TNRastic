#! /bin/env bash
ps aux |grep "perl tnrs_handler.pl" |grep -v "grep perl" |wc -l
