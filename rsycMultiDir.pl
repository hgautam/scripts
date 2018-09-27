#!/usr/bin/perl
use warnings;
use strict;

# this script can be used to rysnc dirs outlined in a file
# if multiple dirs need to be rsynced, split the total number of dirs to many files
# parallelly rsync by running multiple rsync scripts

my $host = "root\@crp-maven05.corp.ebay.com:";
my $remotePath = "/mvn-latest/repo-storage/nexus_work/storage/";
my $localPath = "/nxrepository/nexus_work/storage";

# read line by line from a file
open (MYFILE, 'xaa');
while (<MYFILE>) {
        chomp;
        my $remoteDirPath = $remotePath.$_;
        #print "remote directory is $remoteDirPath\n";
        #print "command is rysnc -avz $host:$remoteDirPath $localPath\n";
        #print "url is $url\n";
        #print "curl -so /dev/null $url\n";
        #print OUTPUT "curl -so /dev/null $url\n";
         #print "$_\n";
        my $cmd = `rsync -avz $host$remoteDirPath $localPath >> output.txt 2>&1`;
        print $cmd;
        #print OUTPUT "$cmd\n";
}
close (MYFILE);

