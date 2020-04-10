public with sharing class DevelopmentPipelineController {

    @AuraEnabled
    public static List<Environment__c> getEnvironmentData() {
        return [
                SELECT Id,
                        Name,
                        NamedCredential__c,
                        SortOrder__c,
                        LastQueried__c, (
                        SELECT Id,
                                Name,
                                Version__c,
                                Description__c,
                                IsHasKey__c,
                                IsBeta__c,
                                UnlockedPackage__c,
                                UnlockedPackage__r.GitHubRepositoryPath__c,
                                UnlockedPackage__r.ColorCode__c,
                                UnlockedPackage__r.Team__c
                        FROM InstalledPackages__r
                        ORDER BY UnlockedPackage__r.Team__c ASC,
                                UnlockedPackage__r.LatestReleasedVersionInstallOrder__c ASC
                )
                FROM Environment__c
                ORDER BY SortOrder__c ASC
        ];
    }

    @AuraEnabled
    public static void refreshInstalledPackageData(List<Id> orgIds) {
        new InstalledPackageService(new Set<Id>(orgIds)).refreshInstalledPackages();
    }
}