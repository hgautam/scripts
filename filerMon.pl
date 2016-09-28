#!/usr/bin/perl
use strict;
use warnings;

my $alarmThreshold = 256000;
my $phxStatus = 0;
my $slcStatus = 0;

print "Checking LVS...";
my $lvsUsage = `curl -s http://cronus-srepo.vip.ebay.com/cgi-bin/diskUsage.py | grep cronusdata01 | tail -1 | awk '{print \$3}'`;
print "Usage in LVS = $lvsUsage";


print "Checking PHX...";
my $phxUsage = `curl -s http://cronus-srepo.vip.phx.ebay.com/cgi-bin/diskUsage.py | grep cronusdata01 | tail -1 | awk '{print \$3}'`;
print "Usage in PHX = ".$phxUsage;
my $Diff = $lvsUsage - $phxUsage;
if ($Diff > $alarmThreshold) {
	print "Difference between LVS and PHX is $Diff\n";
	print "PHX filer volume is behind...\n";
	$phxStatus = 1;
} else {
	print "Difference between LVS and PHX is $Diff\n";
}

print "Checking SLC...";
my $slcUsage = `curl -s http://cronus-srepo.vip.slc.ebay.com/cgi-bin/diskUsage.py | grep cronusdata01 | tail -1 | awk '{print \$3}'`;
print "Usage in SLC = ".$slcUsage;
my $Diff1 = $lvsUsage - $slcUsage;
if ($Diff1 > $alarmThreshold) {
	print "Difference between LVS and SLC is $Diff1\n";
	print "SLC filer voume is behind...\n";
	$slcStatus = 1;
} else {
	print "Difference between LVS and SLC is $Diff1\n";
}

if ($phxStatus or $slcStatus != 0) {
	print "Remote volumes are out of sync...\n";
	exit 1;
}

