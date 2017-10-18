#!/usr/local/bin/perl
use strict;
use warnings;
open (MYFILE, 'usercount.txt');
 while (<MYFILE>) {
        chomp;
        #print "moving $_ to /cronus/apache2/htdocs/packages/purgedFiles\n";
        system("net user $_ /DOM | grep \"Logon script\"");
 }
 close (MYFILE);
