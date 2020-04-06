public with sharing class DevopsDashboardController {

    @AuraEnabled
    public static List<UPM_Environment__c> getEnvironmentData() {
        return [
                SELECT Id,
                        Name,
                        NamedCredential__c,
                        SortOrder__c,
                        LastQueried__c, (
                        SELECT Id,
                                Name,
                                UPM_Version__c,
                                UPM_Description__c,
                                UPM_IsHasKey__c,
                                UPM_IsBeta__c,
                                UnlockedPackage__c,
                                UnlockedPackage__r.GitHubRepositoryPath__c,
                                UnlockedPackage__r.ColorCode__c,
                                UnlockedPackage__r.Team__c
                        FROM UPM_InstalledPackages__r
                        ORDER BY UnlockedPackage__r.Team__c ASC
                )
                FROM UPM_Environment__c
                ORDER BY SortOrder__c ASC
        ];
    }

    @AuraEnabled
    public static void refreshInstalledPackageData(List<Id> orgIds) {
        new InstalledPackageService(new Set<Id>(orgIds)).refreshInstalledPackages();
    }
}