#!/usr/bin/perl
use strict;
use warnings;

my $hostName="phx5qa01c-316b.stratus.phx.qa.ebay.com";
my $defaultBackup="phx5qa01c-8072.stratus.phx.qa.ebay.com";
my $logFile='/ebay/scripts/logs/newMon.log';
my $startCommand="service nexus start";
my $stopCommand="service nexus stop";
my $appURL = "http://$hostName";
my $remoteAppURL = "http://$defaultBackup";
my $logString = "**********\n";
my $localHost = `hostname --fqdn`;

my $appStatus = system("/usr/bin/wget -T 10 -t 3 --spider $appURL > /dev/null 2>&1");
my $remoteWget = "/usr/bin/wget -T 10 -t 3 --spider $remoteAppURL > /dev/null 2>&1";
#my $remoteAppStatus = system($remoteWget);
my $remoteAppStatus = "Not initialized";
$logString = $logString."Script running on $localHost";
$logString = $logString."Script run at ".`date`;

#check if local app is up
if ($appStatus == 0) {
   $logString = $logString."$hostName Nexus web app is UP!\n";
   $logString = $logString."Checking $defaultBackup Nexus web app...\n";
   $remoteAppStatus = system($remoteWget);
   if ($remoteAppStatus !=0) {
      $logString = $logString."$defaultBackup Nexus web app is DOWN!\n";
      $logString = $logString."$hostName is ACTIVE master!...\n";
      $logString = $logString."No further action needed. Exiting!...\n";
      #exit 0;
   }else {
      $logString = $logString."$defaultBackup Nexus web app is UP!\n";
      $logString = $logString."Both apps cannot be up at the same time...\n";
      $logString = $logString."Sleeping for 20 seconds before retry...\n";
      sleep(20);
      $remoteAppStatus = system($remoteWget);
      if ($remoteAppStatus !=0) {
        $logString = $logString."$defaultBackup Nexus web app is DOWN!\n";
        $logString = $logString."$hostName is ACTIVE master!...\n";
        $logString = $logString."No further action needed. Exiting!...\n";
        #exit 0;
      }else {
        $logString = $logString."$defaultBackup Nexus web app is still UP!\n";
        $logString = $logString."Sleeping for 40 seconds before retry...\n";
        sleep(40);
        $remoteAppStatus = system($remoteWget);
        if ($remoteAppStatus !=0) {
           $logString = $logString."$defaultBackup Nexus web app is DOWN!\n";
           $logString = $logString."$hostName is ACTIVE master!...\n";
           $logString = $logString."No further action needed. Exiting!...\n";
           #exit 0;
        }else {
           $logString = $logString."$defaultBackup Nexus web app is still UP!\n";
           $logString = $logString."Both apps cannot be up at the same time...\n";
           $logString = $logString."Stopping Nexus on $hostName...\n";
           my $commandStatus = `$stopCommand`;
           $logString = $logString.$commandStatus."\n";
           #exit 0;
        }
      }
   }
}

if ($appStatus != 0) {
   $logString = $logString."$hostName Nexus web app is DOWN!\n";
   $logString = $logString."Checking $defaultBackup Nexus web app...\n";
   $remoteAppStatus = system($remoteWget);
   if ($remoteAppStatus !=0) {
      $logString = $logString."$defaultBackup Nexus web app is DOWN!\n";
      $logString = $logString."Nexus web app should always be running on one of the hosts...\n";
      $logString = $logString."Sleeping for 20 seconds before retrying Nexus web app on $defaultBackup...\n";
      sleep(20);
      $remoteAppStatus = system($remoteWget);
      if ($remoteAppStatus !=0) {
        $logString = $logString."$defaultBackup Nexus web app is still DOWN!\n";
        $logString = $logString."Sleeping for 40 seconds before another retry...\n";
        sleep(40);
        $remoteAppStatus = system($remoteWget);
        if ($remoteAppStatus !=0) {
           $logString = $logString."$defaultBackup Nexus web app is still DOWN after second retry!\n";
           $logString = $logString."Starting Nexus app on $hostName...\n";
           my $commandStatus = `$startCommand`;
           $logString = $logString.$commandStatus."\n";
           #exit 0;
        }else {
           $logString = $logString."$defaultBackup Nexus web app is now UP!...\n";
           $logString = $logString."No further action needed. Exiting...\n";
        }
      }else {
        $logString = $logString."$defaultBackup Nexus web app is UP!\n";
        $logString = $logString."$defaultBackup is ACTIVE master...\n";
        $logString = $logString."No further action needed. Exiting...\n";
      }

   }else {
      $logString = $logString."$defaultBackup Nexus web app is UP!\n";
      $logString = $logString."$defaultBackup is ACTIVE master...\n";
      $logString = $logString."No further action needed. Exiting...\n"
   }
}


if (-e $logFile) {
   #print "found the log file\n";
   if (-s $logFile > 1000000) {
      system("mv $logFile $logFile.old");
      open(MYFILE, ">>$logFile") || die ("cant open $!");
      $logString = $logString."**********\n";
      print MYFILE $logString;
      close (MYFILE);
   }else {
      #print "log String is $logString";
      open(MYFILE, ">>$logFile") || die ("cant open $!");
      $logString = $logString."**********\n";
      print MYFILE $logString;
      close (MYFILE);
   }
}else {
      open(MYFILE, ">>$logFile") || die ("cant open $!");
      $logString = $logString."**********\n";
      print MYFILE $logString;
      close (MYFILE);
}