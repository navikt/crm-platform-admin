public class PackageDependencyService {
    private final String DEVHUB_NAMED_CREDENTIAL = 'NAV_Salesforce_Production';
    private ToolingAPI tooling;
    private Boolean filterByReleasedOnly = false;
    private Map<Id, List<Id>> subscriberPackageVersionIdDependencyMap;
    private List<SimplePackageVersion> allSimplePackageVersions;
    private List<SimplePackageVersion> simplePackageVersionsWithDependencies;

    public PackageDependencyService() {
        this.tooling = new ToolingAPI(DEVHUB_NAMED_CREDENTIAL);
    }

    public List<SimplePackageVersion> getDependenciesForLatestReleasedVersions() {
        this.filterByReleasedOnly = true;
        return getDependenciesForLatestVersions();
    }

    public List<SimplePackageVersion> getDependenciesForLatestVersions() {
        buildDependencyMap();
        buildSimplePackageVersions();
        buildSimplePackageVersionListWithDependencies();
        orderByRequiredInstallationSequence();
        return this.simplePackageVersionsWithDependencies;
    }

    private void buildSimplePackageVersionListWithDependencies() {
        Map<Id, SimplePackageVersion> dataStructureBySpvId = new Map<Id, SimplePackageVersion>();
        for (SimplePackageVersion ds : this.allSimplePackageVersions) {
            dataStructureBySpvId.put(ds.subscriberPackageVersionId, ds);
        }

        List<SimplePackageVersion> simplePackageVersionsWithDependencies = new List<SimplePackageVersion>();
        for (Id pvId : subscriberPackageVersionIdDependencyMap.keySet()) {
            SimplePackageVersion spv = dataStructureBySpvId.get(pvId);
            List<SimplePackageVersion> dependencies = new List<SimplePackageVersion>();
            for (
                Id dependencyPvId : subscriberPackageVersionIdDependencyMap.get(
                    pvId
                )
            ) {
                dependencies.add(dataStructureBySpvId.get(dependencyPvId));
            }
            spv.dependencies = dependencies;
            simplePackageVersionsWithDependencies.add(spv);
        }
        this.simplePackageVersionsWithDependencies = simplePackageVersionsWithDependencies;
    }

    private void buildDependencyMap() {
        Map<Id, List<Id>> dependenciesBySubscriberPackageVersionId = new Map<Id, List<Id>>();
        for (
            ToolingAPI.Package2 package2 : getLatestPackageVersionPerPackageWithDependencies()
        ) {
            if (package2.package2Versions != null) {
                for (
                    ToolingAPI.Package2Version p2v : package2.package2Versions.records
                ) {
                    List<Id> dependencies = new List<Id>();
                    if (p2v.subscriberPackageVersion.dependencies != null) {
                        for (
                            ToolingAPI.SubscriberPackageDependency id : p2v.subscriberPackageVersion.dependencies.ids
                        ) {
                            dependencies.add(id.subscriberPackageVersionId);
                        }
                    }
                    dependenciesBySubscriberPackageVersionId.put(
                        p2v.subscriberPackageVersionId,
                        dependencies
                    );
                }
            }
        }
        this.subscriberPackageVersionIdDependencyMap = dependenciesBySubscriberPackageVersionId;
    }

    private List<ToolingAPI.Package2> getLatestPackageVersionPerPackageWithDependencies() {
        ToolingAPI.QueryResult result = tooling.query(
            'SELECT Id, Name, (SELECT Id, SubscriberPackageVersionId, SubscriberPackageVersion.Dependencies FROM Package2Versions' +
            getVersionFilter() +
            ') FROM Package2'
        );
        return (List<ToolingAPI.Package2>) result.records;
    }

    private String getVersionFilter() {
        if (this.filterByReleasedOnly) {
            return ' WHERE IsReleased = TRUE ORDER BY CreatedDate DESC LIMIT 1';
        } else {
            return ' ORDER BY CreatedDate DESC LIMIT 1';
        }
    }

    private void buildSimplePackageVersions() {
        List<SimplePackageVersion> simplePackageVersions = new List<SimplePackageVersion>();
        for (ToolingAPI.Package2Version p2v : getAllPackageVersions()) {
            SimplePackageVersion ds = new SimplePackageVersion();
            ds.packageName = p2v.package2.name;
            ds.packageVersion =
                p2v.majorVersion +
                '.' +
                p2v.minorVersion +
                '.' +
                p2v.patchVersion +
                '.' +
                p2v.buildNumber;
            ds.subscriberPackageVersionId = p2v.subscriberPackageVersionId;
            ds.subscriberPackageId = p2v.package2.subscriberPackageId;
            simplePackageVersions.add(ds);
        }
        this.allSimplePackageVersions = simplePackageVersions;
    }

    private List<ToolingAPI.Package2Version> getAllPackageVersions() {
        ToolingAPI.QueryResult result = tooling.query(
            'SELECT Id, Package2.SubscriberPackageId, Package2.Name, Package2.Id, MajorVersion, MinorVersion, PatchVersion, BuildNumber, SubscriberPackageVersionId FROM Package2Version'
        );
        return (List<ToolingAPI.Package2Version>) result.records;
    }

    public void orderByRequiredInstallationSequence() {
        Map<Id, SimplePackageVersion> spvBySubscriberPackageVersionId = getPackageVersionsBySubscriberPackageId();
        this.simplePackageVersionsWithDependencies = findRequiredOrder(
            spvBySubscriberPackageVersionId
        );
    }

    private Map<Id, SimplePackageVersion> getPackageVersionsBySubscriberPackageId() {
        Map<Id, SimplePackageVersion> spvBySubscriberPackageVersionId = new Map<Id, SimplePackageVersion>();
        for (
            SimplePackageVersion spv : this.simplePackageVersionsWithDependencies
        ) {
            spvBySubscriberPackageVersionId.put(spv.subscriberPackageId, spv);
        }
        return spvBySubscriberPackageVersionId;
    }

    private List<SimplePackageVersion> findRequiredOrder(
        Map<Id, SimplePackageVersion> spvBySubscriberPackageId
    ) {
        Map<Id, SimplePackageVersion> packageVersionsByRequiredOrderOfInstallation = new Map<Id, SimplePackageVersion>();
        while (!spvBySubscriberPackageId.keySet().isEmpty()) {
            for (Id subscriberPackageId : spvBySubscriberPackageId.keySet()) {
                SimplePackageVersion pv = spvBySubscriberPackageId.get(
                    subscriberPackageId
                );
                // Package Versions that have no dependencies
                if (pv.dependencies == null) {
                    packageVersionsByRequiredOrderOfInstallation.put(
                        subscriberPackageId,
                        pv
                    );
                    spvBySubscriberPackageId.remove(subscriberPackageId);
                } else {
                    // Add only if all dependencies are already added
                    Boolean allParentsAdded = true;
                    for (SimplePackageVersion dependencySpv : pv.dependencies) {
                        if (
                            !packageVersionsByRequiredOrderOfInstallation.containsKey(
                                dependencySpv.subscriberPackageId
                            )
                        ) {
                            allParentsAdded = false;
                        }
                    }
                    if (allParentsAdded) {
                        packageVersionsByRequiredOrderOfInstallation.put(
                            subscriberPackageId,
                            pv
                        );
                        spvBySubscriberPackageId.remove(subscriberPackageId);
                    }
                }
            }
        }
        return packageVersionsByRequiredOrderOfInstallation.values();
    }

    public class SimplePackageVersion {
        @AuraEnabled
        public String packageName;
        @AuraEnabled
        public String packageVersion;
        @AuraEnabled
        public String subscriberPackageVersionId;
        @AuraEnabled
        public String subscriberPackageId;
        @AuraEnabled
        public List<SimplePackageVersion> dependencies;
    }
}
