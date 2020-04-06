public with sharing class PackageUpdateService {

    public static void updateUnlockedPackageLatestReleasedFields() {
        List<PackageDependencyService.SimplePackageVersion> packageVersions = new PackageDependencyService().getDependenciesForLatestReleasedVersions();
        Map<Id, PackageDependencyService.SimplePackageVersion> packageVersionsByPackageId = getPackageVersionByPackageId(packageVersions);
        List<UPM_UnlockedPackage__c> packagesToUpdate = initializePackagesToUpdate(packageVersionsByPackageId);
        update packagesToUpdate;
    }

    private static List<UPM_UnlockedPackage__c> initializePackagesToUpdate(Map<Id, PackageDependencyService.SimplePackageVersion> packagesByPackageId) {
        Map<Id, Integer> installationOrderByPackageId = getInstallationOrderMap(packagesByPackageId.values());
        List<UPM_UnlockedPackage__c> upmUnlockedPackages = [SELECT Id, SubscriberPackageId__c FROM UPM_UnlockedPackage__c];
        for (UPM_UnlockedPackage__c upm : upmUnlockedPackages) {
            if (packagesByPackageId.containsKey(upm.SubscriberPackageId__c)) {
                upm.LatestReleasedVersionInstallOrder__c = installationOrderByPackageId.get(upm.SubscriberPackageId__c);
                upm.LatestReleasedSubscriberPackageVersionId__c = packagesByPackageId.get(upm.SubscriberPackageId__c).subscriberPackageVersionId;
                upm.LastQueried__c = Datetime.now();
            } else {
                upm.LatestReleasedVersionInstallOrder__c = null;
                upm.LatestReleasedSubscriberPackageVersionId__c = null;
            }
        }
        return upmUnlockedPackages;
    }

    private static Map<Id, Integer> getInstallationOrderMap(List<PackageDependencyService.SimplePackageVersion> packageVersions) {
        Map<Id, Integer> installationOrderByPackageId = new Map<Id, Integer>();
        Integer i = 0;
        for (PackageDependencyService.SimplePackageVersion spv : packageVersions) {
            installationOrderByPackageId.put(spv.subscriberPackageId, i);
            i++;
        }
        return installationOrderByPackageId;
    }

    private static Map<Id, PackageDependencyService.SimplePackageVersion> getPackageVersionByPackageId(List<PackageDependencyService.SimplePackageVersion> packageVersions) {
        Map<Id, PackageDependencyService.SimplePackageVersion> packageVersionsByPackageId = new Map<Id, PackageDependencyService.SimplePackageVersion>();
        for (PackageDependencyService.SimplePackageVersion spv : packageVersions) {
            packageVersionsByPackageId.put(spv.subscriberPackageId, spv);
        }
        return packageVersionsByPackageId;
    }
}