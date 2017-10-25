#!/usr/bin/perl
use warnings;
use strict;

# read ips from a file
my @errorIps = ();
open (MYFILE, 'sortedIps.txt');
while (<MYFILE>) {
	chomp;
	system("ping -c 1 $_");
	my $statusCode = `echo $?`;
	if ($statusCode != 0) {
	   push(@errorIps, $_)
	}
}
close (MYFILE);
if (scalar @errorIps > 0) {
    print "Following Nameserver(s) not responding:\n";
<<<<<<< HEAD
	print "ERR_MSG=@errorIps not responding\n";
=======
	print "ERR_MSG=@errorIps not responding!!!";
>>>>>>> 1cf7bd060d3373a12f0f29150c09b4d9ca6f4609
	#exit 1;
} else {
	exit 0;
}
	    

