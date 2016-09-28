#!/usr/bin/perl
use strict;
use warnings;

my $file = "test.cronus";
#system("touch $file");

#my $output = `ls -lrt`;
#print $output;

print "file exists.. \n" if -f "test.cronus";

my $write_secs = (stat($file))[9];
printf "file %s updated at %s\n", $file, scalar localtime($write_secs);

my $current_time = time;

print "currunt time is ". scalar localtime($current_time) ."\n";

my $diff = $current_time - $write_secs;

print "Difference is $diff";