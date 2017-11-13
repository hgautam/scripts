use strict;
use warnings;

#my $host1 = "ebaycentral02-1410820.lvs02.dev.ebayc3.com";
#my $host2 = "ebaycentral01-1410816.lvs02.dev.ebayc3.com";

my @hostlist = ("ebaycentral02-1410820.lvs02.dev.ebayc3.com", "ebaycentral01-1410816.lvs02.dev.ebayc3.com");

my $commandStatus = 0;
my @errorList = ();
foreach my $host (@hostlist) {
    $commandStatus = system("wget $host --spider --quiet -T 20");
    if ($commandStatus != 0) {
        #system("echo '$host proxy is down' | mail -s 'Warning' hgautam\@ebay.com");
        push(@errorList, $host)
    }
}

if (scalar @errorList > 0 ) {
    system("echo '@errorList proxy is down' | mail -s 'Warning' hgautam\@ebay.com");
}
