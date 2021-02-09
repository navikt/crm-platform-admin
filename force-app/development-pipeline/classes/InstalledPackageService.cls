public class InstalledPackageService {
    private Set<Id> orgIds;
    private ToolingAPI tooling;
    private Map<String, Id> unlockedPackageIdBySubscriberPackageId;
    private Map<String, Environment__c> environmentByNamedCredential;
    private Map<String, List<ToolingAPI.InstalledSubscriberPackage>> installedPackagesByNamedCredential;

    public InstalledPackageService(Set<Id> orgIds) {
        this.orgIds = orgIds;
        getUnlockedPackageIdBySubscriberPackageId();
    }

    public void refreshInstalledPackages() {
        getEnvironmentsByNamedCredential();
        queryInstalledPackagesByOrg();
        deleteExistingInstalledPackageRecords();
        insertNewInstalledPackageRecords();
        updateEnvironmentLastQueriedTimestamps();
    }

    private void insertNewInstalledPackageRecords() {
        List<InstalledPackage__c> installedPackagesToInsert = new List<InstalledPackage__c>();
        for (
            String namedCredential : this.installedPackagesByNamedCredential.keySet()
        ) {
            for (
                ToolingAPI.InstalledSubscriberPackage isp : this.installedPackagesByNamedCredential.get(
                    namedCredential
                )
            ) {
                installedPackagesToInsert.add(
                    createInstalledPackageRecord(isp, namedCredential)
                );
            }
        }
        insert installedPackagesToInsert;
    }

    private InstalledPackage__c createInstalledPackageRecord(
        ToolingAPI.InstalledSubscriberPackage isp,
        String namedCredential
    ) {
        InstalledPackage__c ip = new InstalledPackage__c();
        ip.Environment__c = environmentByNamedCredential.get(namedCredential)
            .Id;
        System.debug(isp.subscriberPackageId);
        ip.UnlockedPackage__c = unlockedPackageIdBySubscriberPackageId.get(
            isp.subscriberPackageId
        );
        ip.Description__c = isp.subscriberPackageVersion.description;
        ip.Name = isp.subscriberPackage.name;
        ip.Version__c =
            isp.subscriberPackageVersion.MajorVersion +
            '.' +
            isp.subscriberPackageVersion.MinorVersion +
            '.' +
            isp.subscriberPackageVersion.PatchVersion +
            '-' +
            isp.subscriberPackageVersion.BuildNumber;
        ip.IsBeta__c = isp.subscriberPackageVersion.IsBeta;
        ip.IsHasKey__c = isp.subscriberPackageVersion.IsPasswordProtected;
        ip.SubscriberPackageVersionId__c = isp.subscriberPackageVersion.Id;
        return ip;
    }

    private void getEnvironmentsByNamedCredential() {
        Map<String, Environment__c> environmentByNamedCredential = new Map<String, Environment__c>();
        for (Environment__c org : [
            SELECT Id, Name, NamedCredential__c
            FROM Environment__c
            WHERE Id IN :this.orgIds
            ORDER BY SortOrder__c ASC
        ]) {
            environmentByNamedCredential.put(org.NamedCredential__c, org);
        }
        this.environmentByNamedCredential = environmentByNamedCredential;
    }

    private void queryInstalledPackagesByOrg() {
        Map<String, List<ToolingAPI.InstalledSubscriberPackage>> installedPackagesByNamedCredential = new Map<String, List<ToolingAPI.InstalledSubscriberPackage>>();
        for (
            String namedCredential : this.environmentByNamedCredential.keySet()
        ) {
            this.tooling = new ToolingAPI(namedCredential);
            installedPackagesByNamedCredential.put(
                namedCredential,
                getInstalledPackageVersionsForEnvironment()
            );
        }
        this.installedPackagesByNamedCredential = installedPackagesByNamedCredential;
    }

    private List<ToolingAPI.InstalledSubscriberPackage> getInstalledPackageVersionsForEnvironment() {
        ToolingAPI.QueryResult result = tooling.query(
            'SELECT Id, ' +
            'SubscriberPackageId,' +
            'SubscriberPackage.Name,' +
            'SubscriberPackageVersion.Id,' +
            'SubscriberPackageVersion.Description,' +
            'SubscriberPackageVersion.IsBeta,' +
            'SubscriberPackageVersion.IsPasswordProtected,' +
            'SubscriberPackageVersion.MajorVersion,' +
            'SubscriberPackageVersion.MinorVersion,' +
            'SubscriberPackageVersion.PatchVersion,' +
            'SubscriberPackageVersion.BuildNumber' +
            ' FROM InstalledSubscriberPackage' +
            ' WHERE' +
            ' SubscriberPackageId IN' +
            UnlockedPackageService.getUnlockedPackageSOQLFilterFromRecords() +
            ' ORDER BY SubscriberPackageId DESC'
        );
        return (List<ToolingAPI.InstalledSubscriberPackage>) result.records;
    }

    private void deleteExistingInstalledPackageRecords() {
        delete [
            SELECT Id
            FROM InstalledPackage__c
            WHERE Environment__c IN :this.orgIds
        ];
    }

    private void getUnlockedPackageIdBySubscriberPackageId() {
        this.unlockedPackageIdBySubscriberPackageId = new Map<String, Id>();
        for (UnlockedPackage__c up : [
            SELECT Id, SubscriberPackageId__c
            FROM UnlockedPackage__c
        ]) {
            this.unlockedPackageIdBySubscriberPackageId.put(
                up.SubscriberPackageId__c,
                up.Id
            );
        }
    }

    private void updateEnvironmentLastQueriedTimestamps() {
        // Instantiate new Environment records in order to update LastQueried field
        List<Environment__c> environmentsToUpdate = new List<Environment__c>();
        for (Id envId : orgIds) {
            environmentsToUpdate.add(
                new Environment__c(Id = envId, LastQueried__c = Datetime.now())
            );
        }
        update environmentsToUpdate;
    }
}
