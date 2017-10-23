#!/usr/bin/perl
use strict;
use warnings;

#download AppToDNSMapping.md from GH
system("curl -s -O --user \"hgautam:bb89121c2764b1af51c819f0a21a7f3207ccecde\" -H \"Accept: application/vnd.github.v4.raw\" https://github.corp.ebay.com/api/v3/repos/SCM/docs/contents/AppToDNSMapping.md");

# Reads IPs from AppToDNSMapping.md file
open(MYFILE, 'AppToDNSMapping.md');
# file to store IPs
my $filename = 'ips.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
while(<MYFILE>) {
	chomp;
    # match an ip in format of 10.254.10.55 as multiple ips in one line
	while ($_ =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/g) {
		#print "$1\n";
		print $fh "$1\n";
	}
}
close (MYFILE);
close $fh;
system("sort ips.txt | uniq > sortedIps.txt");

