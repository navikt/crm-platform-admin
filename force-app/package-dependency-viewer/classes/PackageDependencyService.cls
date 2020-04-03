public with sharing class PackageDependencyService {

    public static void updateUnlockedPackageDependencyOrder() {
        Map<Id, PackageVersionDependency> dependencyBySubscriberPackageId = new Map<Id, PackageVersionDependency>();
        for (PackageVersionDependency pvd : getReleasedPackageVersionsInOrderOfInstallation()) {
            dependencyBySubscriberPackageId.put(pvd.packageVersion.package2.subscriberPackageId, pvd);
        }

        System.debug(dependencyBySubscriberPackageId);

        List<UPM_UnlockedPackage__c> upmUnlockedPackages = [SELECT Id, SubscriberPackageId__c FROM UPM_UnlockedPackage__c];
        for (UPM_UnlockedPackage__c upm : upmUnlockedPackages) {
            if(dependencyBySubscriberPackageId.containsKey(upm.SubscriberPackageId__c)) {
                upm.LatestReleasedVersionInstallOrder__c = dependencyBySubscriberPackageId.get(upm.SubscriberPackageId__c).dependencyOrder;
                upm.LatestReleasedVersion__c = dependencyBySubscriberPackageId.get(upm.SubscriberPackageId__c).packageVersion.subscriberPackageVersionId;
            } else {
                upm.LatestReleasedVersionInstallOrder__c = null;
                upm.LatestReleasedVersion__c = null;
            }
        }
        update upmUnlockedPackages;

    }

    public static List<PackageVersionDependency> getReleasedPackageVersionsInOrderOfInstallation() {
        List<PackageVersionDependency> dependencies = getDependencies(ToolingAPIService.Mode.RELEASED);

        // Map of SubscriberPackageVersionId -> PackageVersionDependency
        // Used to iterate over in order to find out the installation order of packages.
        // Entries will removed as they are added to the orderedDependencyMap collection
        Map<Id, PackageVersionDependency> pvdByPackageVersionId = new Map<Id, PackageVersionDependency>();
        for (PackageVersionDependency pvd : dependencies) {
            pvdByPackageVersionId.put(pvd.packageVersion.subscriberPackageVersionId, pvd);
        }

        // Map to hold the package version in required order of installation
        Map<Id, PackageVersionDependency> orderedDependencyMap = new Map<Id, PackageVersionDependency>();
        // Iterate over package versions. If the package has no dependencies, or all dependencies
        // have been added to the orderedDependencyMap, add the package to the orderedDependencyMap
        // and remove it from the pvdByPackageVersionId map. Repeat until all packages have been added.
        while (!pvdByPackageVersionId.keySet().isEmpty()) {
            for (Id pvId : pvdByPackageVersionId.keySet()) {
                PackageVersionDependency pv = pvdByPackageVersionId.get(pvId);
                // Package Versions that have no dependencies
                if (pv.dependentPackageVersions == null) {
                    orderedDependencyMap.put(pvId, pv);
                    pvdByPackageVersionId.remove(pvId);
                } else {
                    // Add only if all dependencies are already added
                    Boolean allParentsAdded = true;
                    for (ToolingAPIService.Package2Version p2v : pv.dependentPackageVersions) {
                        if (!orderedDependencyMap.containsKey(p2v.subscriberPackageVersionId)) allParentsAdded = false;
                    }
                    if (allParentsAdded) {
                        orderedDependencyMap.put(pvId, pv);
                        pvdByPackageVersionId.remove(pvId);
                    }
                }
            }
        }

        for (Integer i = 0; i < orderedDependencyMap.values().size() ; i++) {
            orderedDependencyMap.values()[i].dependencyOrder = i;
        }

        return orderedDependencyMap.values();
    }

    public static List<PackageVersionDependency> getDependencies(ToolingAPIService.Mode dependencyMode) {
        ToolingAPIService ts = new ToolingAPIService(dependencyMode);

        // Query for Package2 records with related Package2Versions and SubscriberPackageVersion.
        // SubscriberPackageVersion contains a list of dependencies (other 04t SubscriberPackageVersions)
        // Construct a map of SubscriberPackageVersionId to SubscriberPackageVersions it is dependent on
        Map<Id, List<Id>> packageDependencyIdsByPackageVersionId = new Map<Id, List<Id>>();
        for (ToolingAPIService.Package2 p2 : ts.getPackagesWithDependencies().records) {
            if (p2.package2Versions == null) continue;
            for (ToolingAPIService.Package2Version p2ver : p2.package2Versions.records) {
                List<Id> packageDependencyIds = new List<Id>();
                if (p2ver.subscriberPackageVersion.dependencies != null) {
                    for (ToolingAPIService.SubscriberPackageVersionDependencyId versionDependency : p2ver.subscriberPackageVersion.dependencies.ids) {
                        packageDependencyIds.add(versionDependency.subscriberPackageVersionId);
                    }
                }
                packageDependencyIdsByPackageVersionId.put(p2ver.subscriberPackageVersionId, packageDependencyIds);
            }
        }

        // Query for released Package2Versions and build map of Id -> Package2Version
        Map<Id, Id> latestReleasedPackageVersionByPackageId = new Map<Id, Id>();
        for (ToolingAPIService.Package2 p2 : ts.getPackageWithLatestReleasedVersions().records) {
            if (p2.package2Versions == null) continue;
            latestReleasedPackageVersionByPackageId.put(p2.id, p2.package2Versions.records[0].subscriberPackageVersionId);
        }

        // Query for all Package2Versions and build map of Id -> Package2Version
        Map<Id, ToolingAPIService.Package2Version> packageVersionBySubscriberPackageId = new Map<Id, ToolingAPIService.Package2Version>();
        for (ToolingAPIService.Package2Version p2ver : ts.listPackage2Versions().records) {
            packageVersionBySubscriberPackageId.put(p2ver.subscriberPackageVersionId, p2ver);
        }

        // Iterate over dependency map and build dependency object structure
        List<PackageVersionDependency> packageVersionsWithDependencies = new List<PackageVersionDependency>();
        for (Id pvId : packageDependencyIdsByPackageVersionId.keySet()) {
            PackageVersionDependency pv = new PackageVersionDependency();
            pv.packageVersion = packageVersionBySubscriberPackageId.get(pvId);
            List<ToolingAPIService.Package2Version> latestDependentPackageVersions = new List<ToolingAPIService.Package2Version>();
            List<ToolingAPIService.Package2Version> releasedDependentPackageVersions = new List<ToolingAPIService.Package2Version>();
            for (Id depPvId : packageDependencyIdsByPackageVersionId.get(pvId)) {
                latestDependentPackageVersions.add(packageVersionBySubscriberPackageId.get(depPvId));
                releasedDependentPackageVersions.add(packageVersionBySubscriberPackageId.get(latestReleasedPackageVersionByPackageId.get(packageVersionBySubscriberPackageId.get(depPvId).package2.id)));
            }
            if (dependencyMode == ToolingAPIService.Mode.LATEST) {
                pv.dependentPackageVersions = latestDependentPackageVersions;
            } else {
                pv.dependentPackageVersions = releasedDependentPackageVersions;
            }
            packageVersionsWithDependencies.add(pv);
        }

        return packageVersionsWithDependencies;
    }

    public class PackageVersionDependency {
        public Integer dependencyOrder;
        @AuraEnabled public ToolingAPIService.Package2Version packageVersion;
        @AuraEnabled public List<ToolingAPIService.Package2Version> dependentPackageVersions;
    }

}