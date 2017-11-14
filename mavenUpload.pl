
# Script to upload an artifact to ebaycentral
#!/usr/bin/perl
use strict;
use warnings;

my $timeout = 1200;

#print "Number of args is $#ARGV\n";
# Read command line args
if ( $#ARGV != 2 ) {
	print "Need to pass ebaycentral hostname and file name as argument!!\n";
	print "e.g. curlTest.pl ebaycentral.qa.ebay.com ims-web-2.8.1-20170915.010455-1.war ebaycentralProxy\n";
	exit 1;
}

print "ebaycentral host is: $ARGV[0]\n";
print "file to upload is: $ARGV[1]\n";
print "dir to upload the file in is: $ARGV[2]\n";
#ims-web-2.8.1-20170915.010455-1.war is the file that is currently being uploded
my $time = `curl -s -u RaptorTeam:RaptorTeam  -w '%{time_total}\n' --upload-file $ARGV[1] http://$ARGV[0]/content/repositories/snapshots/com/ebay/scm/$ARGV[2]/1.0/$ARGV[1]`;
# capture the error code of above command. Very important or script will still 0 code even if the curl command failed due to file not found error
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

