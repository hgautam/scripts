#!/usr/bin/perl
use strict;
use warnings;

my $timeout = 1200;

#print "Number of args is $#ARGV\n";
# Read command line args
if ( $#ARGV != 1 ) {
	print "Need to pass ebaycentral hostname and file name as argument!!\n";
	print "e.g. curlTest.pl ebaycentral.qa.ebay.com ims-web-2.8.1-20170915.010455-1.war\n";
	exit 1;
}

print "$ARGV[0]\n";
print "$ARGV[1]\n";
#ims-web-2.8.1-20170915.010455-1.war is the file that is currently being uploded
my $time = `curl -s -u RaptorTeam:RaptorTeam  -w '%{time_total}\n' --upload-file ims-web-2.8.1-20170915.010455-1.war http://$ARGV[0]/content/repositories/snapshots/com/ebay/scm/wartest/1.0/$ARGV[1]`;
my $extcode = $?>>8;

if ($extcode != 0) {
	print "exit code is $extcode\n";
	print "curl command failed\n";
	exit 1;
}

print "Time is $time\n";

if ($time > $timeout) {
	print "Build is talking too long!!!\n";
	exit 1;
}

