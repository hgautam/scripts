#!/usr/bin/perl
use warnings;
use strict;

# list of qa and corp DNS servers to be queried
my @qaDNSList = ("10.108.139.154", "10.109.104.20", "10.109.104.21");
my @corpDNSList = ("10.254.58.54", "10.254.58.55");

# list of qa and corp servers to be queried against DNS servers
#my @qaServers = ("qa-proxy.qa.ebay.com", "mailhost.qa.ebay.com", "ebaycentral.qa.ebay.com");
my @corpServers = ("atom.corp.ebay.com", "ebaycentral.corp.ebay.com", "npm.corp.ebay.com");

# collect dns query errors
#my @qaErrors = queryDNS(\@qaDNSList, \@qaServers);
my @corpErrors = queryDNS(\@corpDNSList, \@corpServers);

#if (scalar @qaErrors > 0 || scalar @corpErrors > 0) {
if (scalar @corpErrors > 0) {
    # Remove dupliates from @corpErrors
    my %hash   = map { $_ => 1 } @corpErrors;
    my @unique = keys %hash;
    foreach my $failedLookup (@unique) {
        print "Failed DNS server(s): $failedLookup\n";
        #system("/usr/bin/python /cygdrive/c/cygwin64/home/hgautam/monitoring/scripts/slackApiPost.py $failedLookup");
        system("/usr/bin/python slackApiPost.py $failedLookup");
    }
    exit 1;
}

sub queryDNS{
    my ($one_ref, $two_ref) = @_;
    my @nameServers = @{ $one_ref }; # dereferencing and copying array
    my @testServers = @{ $two_ref };
    my @errorList = ();
    foreach my $dns (@nameServers) {
        foreach my $server (@testServers) {
            print "******\n";
            #my $statusCode = system("nslookup -query=a -timeout=1 $server $dns");
            my $output = `nslookup -query=a -timeout=1 $server $dns`;
            my $statusCode = $?>>8;
            #print "******\n";
            if ($statusCode != 0) {
                print "$statusCode\n";
                print "DNS server $dns is not responding to a query\n";
                push(@errorList, $dns);
            } else {
                if ($output =~ /DNS request timed out/) {
                    print "$dns timed out\n";
                    push(@errorList, $dns);
                }
                if ($output =~ /connection timed out/) {
                    print "$dns timed out\n";
                    push(@errorList, $dns);
                }
            }
        }
    }
    return @errorList;
}
