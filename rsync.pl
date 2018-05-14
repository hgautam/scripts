#!/usr/bin/perl
# run this as a local process
# here is the command to execute at the dir level where storage dir is located:
# nohup perl rsync.pl & disown
use strict;
use warnings;
my $wait = 900;
while (1) {
   system("rsync -avz storage/ --exclude='**/.nexus/' --update root\@nxraptor-01-1722072.slc07.dev.ebayc3.com:/mnt/storage");
   sleep($wait);
}
