#!/usr/bin/perl
use warnings;
use strict;

# read ips from a file
my @errorIps = ();
open (MYFILE, 'sortedIps.txt');
while (<MYFILE>) {
	chomp;
	system("ping -n 1 $_");
	my $statusCode = `echo $?`;
	if ($statusCode != 0) {
	   push(@errorIps, $_)
	}
}
close (MYFILE);
if (scalar @errorIps > 0) {
    print "Following Nameserver(s) not responding:\n";
	print "@errorIps\n";
	exit 1;
} else {
	exit 0;
}
	    

