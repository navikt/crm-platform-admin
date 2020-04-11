#!/bin/bash
packageVersions=$(sfdx force:data:soql:query -q "SELECT LatestReleasedSubscriberPackageVersionId__c FROM UnlockedPackage__c WHERE LatestReleasedSubscriberPackageVersionId__c != null ORDER BY LatestReleasedVersionInstallOrder__c ASC" -u devhub --json)
for p in $(jq '.result.records | .[].LatestReleasedSubscriberPackageVersionId__c' -r <<< "$packageVersions"); do
   result=$(sfdx force:package:install -u scratch-org -p "$p" -k "$1" -w 10 -b 10 --json)
   status=$(jq '.status' <<< "$result")
   if [ "$status" -eq 1 ]
    then
    echo $(jq '.message' <<< "$result")
    break
  fi
done