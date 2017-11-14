#!/usr/bin/perl
use strict;
use warnings;

my $timeout = 1200;

if ( $#ARGV != 1 ) {
	die "Need to pass ebaycentral hostname as argument!!";
}

print "$ARGV[0]\n";
my $time = `curl -s -u RaptorTeam:RaptorTeam  -w '%{time_total}\n' --upload-file ims-web-2.8.1-20170915.010455-1.war http://$ARGV[0]/content/repositories/snapshots/com/ebay/scm/wartest/1.0/ims-web-2.8.1-20170915.010455-1.war`;
print "Time is $time\n";

if ($time > $timeout) {
	print "Build is talking too long!!!\n";
	exit 1;
}

