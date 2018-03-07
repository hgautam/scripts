#!/bin/bash

# download a jar from ebaycentral-sjc
cd /nexus/scripts/data
pwd
rm *.jar
echo "downloading jar from ebaycentral-sjc" >> monitoring.out
(time wget -q http://ebaycentral-sjc.corp.ebay.com/content/repositories/releases/com/ebay/bullseye/bullseye-models/0.9.20/bullseye-models-0.9.20-javadoc.jar) >> monitoring.out 2>&1
echo "finished" >> monitoring.out


#download the same jar from TLV:
rm *.jar
echo "downloading jar from tlv" >> monitoring.out
(time wget -q http://tlv-wacas-001.corp.ebay.com/content/repositories/releases/com/ebay/bullseye/bullseye-models/0.9.20/bullseye-models-0.9.20-javadoc.jar) >> monitoring.out 2>&1
echo "finished" >> monitoring.out

echo "cloning benchmark git repo" >> monitoring.out
rm -rf benchmark.git/
(time git clone --bare git@github.corp.ebay.com:hgautam/benchmark.git) >> monitoring.out 2>&1
echo "finished" >> monitoring.out
date >> monitoring.out
git add monitoring.out
git commit -m "performance data"
git push origin master

#check the size of the monitor log and rotate it
#check the size
myfilesize=$(stat --format=%s "monitoring.out")
currentDate=$(date +%d-%m-%Y)
if [ "$myfilesize" -ge "100000" ]; then
    mv monitoring.out monitoring.out_$currentDate
    echo "rotated old file" >> monitoring.out
    git add monitoring.out
    git add monitoring.out_$currentDate
    git commit -m "performance data"
    git push origin master
fi
