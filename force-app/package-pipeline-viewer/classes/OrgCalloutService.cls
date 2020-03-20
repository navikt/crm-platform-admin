public with sharing class OrgCalloutService {

    private static String packageIdFilterString;
    private static Map<Id, Id> unlockedPackageIdBySubscriberPackageId = new Map<Id, Id>();

    static {
        String packageIdsString = '(';
        for (UPM_UnlockedPackage__c up : [SELECT Id, SubscriberPackageId__c FROM UPM_UnlockedPackage__c]) {
            packageIdsString += '\'' + up.SubscriberPackageId__c + '\',';
            unlockedPackageIdBySubscriberPackageId.put(up.SubscriberPackageId__c, up.Id);
        }
        packageIdsString = packageIdsString.removeEnd(',');
        packageIdsString += ')';
        packageIdFilterString = packageIdsString;
    }

    public static void refreshOrgInfo(Set<Id> orgIds) {
        List<UPM_Environment__c> orgs = [SELECT Id, Name, NamedCredential__c FROM UPM_Environment__c WHERE Id IN :orgIds ORDER BY SortOrder__c ASC];
        Map<String, UPM_Environment__c> namedCredentialOrgMap = new Map<String, UPM_Environment__c>();
        for (UPM_Environment__c org : orgs) {
            namedCredentialOrgMap.put(org.NamedCredential__c, org);
        }

        List<UPM_InstalledPackage__c> ipsToInsert = new List<UPM_InstalledPackage__c>();
        for (UPM_Environment__c org : orgs) {
            String body = doCallout(org.NamedCredential__c, packageIdFilterString);
            QueryResponseFormat qrf = QueryResponseFormat.parse(body);

            for (QueryResponseFormat.record record : qrf.records) {
                UPM_InstalledPackage__c ip = new UPM_InstalledPackage__c();
                ip.UPM_Environment__c = org.Id;
                ip.Name = record.subscriberPackage.name;
                ip.UPM_Description__c = record.subscriberPackageVersion.Description;
                ip.UPM_Version__c = record.subscriberPackageVersion.MajorVersion + '.' + record.subscriberPackageVersion.MinorVersion + '.' + record.subscriberPackageVersion.PatchVersion + '-' + record.subscriberPackageVersion.BuildNumber;
                ip.UPM_IsBeta__c = record.subscriberPackageVersion.IsBeta;
                ip.UPM_IsHasKey__c = record.subscriberPackageVersion.IsPasswordProtected;
                ip.UPM_SubscriberPackageVersionId__c = record.subscriberPackageVersion.Id;
                ip.UnlockedPackage__c = unlockedPackageIdBySubscriberPackageId.get(record.SubscriberPackageId);
                ipsToInsert.add(ip);
            }
        }

        delete [SELECT Id FROM UPM_InstalledPackage__c WHERE UPM_Environment__c IN :orgIds];
        insert ipsToInsert;
    }


    @AuraEnabled
    public static String doCallout(String namedCredential, String filterString) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:'
                + namedCredential
                + '/services/data/v48.0/tooling/query/?q=' +
                'SELECT+Id,' +
                '+SubscriberPackageId,' +
                '+SubscriberPackage.NamespacePrefix,' +
                '+SubscriberPackage.Name,' +
                '+SubscriberPackageVersion.Id,' +
                '+SubscriberPackageVersion.Name,' +
                '+SubscriberPackageVersion.Description,' +
                '+SubscriberPackageVersion.IsBeta,' +
                '+SubscriberPackageVersion.IsPasswordProtected,' +
                '+SubscriberPackageVersion.MajorVersion,' +
                '+SubscriberPackageVersion.MinorVersion,' +
                '+SubscriberPackageVersion.PatchVersion,' +
                '+SubscriberPackageVersion.BuildNumber,' +
                '+SubScriberPackageVersion.ReleaseState' +
                '+FROM+InstalledSubscriberPackage' +
                '+WHERE' +
                '+SubscriberPackageId+IN+' + filterString +
                '+ORDER+BY+SubscriberPackageId');
        req.setTimeout(120000);
        HttpResponse res = new Http().send(req);
        return res.getBody();
    }

}