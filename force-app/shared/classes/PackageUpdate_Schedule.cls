public class PackageUpdate_Schedule implements Schedulable {
    public void execute(SchedulableContext SC) {
        initiateUpdates();
    }

    public static void initiateUpdates() {
        updateDependencyOrderAndLatestReleasedVersionInfo();
        updateInstalledPackagesForAllEnvironments();
    }

    @Future(Callout=true)
    private static void updateDependencyOrderAndLatestReleasedVersionInfo() {
        PackageUpdateService.updateUnlockedPackageLatestReleasedFields();
    }

    // Initiate @future callout for all Environment records separately,
    // because the Tooling API query is slow and may time out
    private static void updateInstalledPackagesForAllEnvironments() {
        for (Environment__c upm : [SELECT Id FROM Environment__c]) {
            updateInstalledPackagesforEnvironment(upm.Id);
        }
    }

    @Future(Callout=true)
    private static void updateInstalledPackagesforEnvironment(Id environmentId) {
        try {
            new InstalledPackageService(new Set<Id>{ environmentId }).refreshInstalledPackages();
        } catch (CalloutException cex) {
            // Read timeouts are expected as the Tooling API may sometimes take more than 120s to respond
        }
    }
}
