public with sharing class DevopsDashboardController {

    @AuraEnabled
    public static List<UPM_Environment__c> getOrgs() {
        return [SELECT Id, Name, NamedCredential__c, SortOrder__c, (SELECT Id, Name, UPM_Version__c, UPM_Description__c, UPM_IsHasKey__c, UPM_IsBeta__c, UnlockedPackage__c, UnlockedPackage__r.GitHubRepositoryPath__c FROM UPM_InstalledPackages__r) FROM UPM_Environment__c ORDER BY SortOrder__c ASC];
    }

    @AuraEnabled
    public static void refreshOrgs(List<Id> orgIds) {
        OrgCalloutService.refreshOrgInfo(new Set<Id>(orgIds));
    }
}