public class PackageUpdateSchedule implements Schedulable {
    public void execute(SchedulableContext SC) {
        doUpdates();
    }

    public static void doUpdates() {
        initiateEnvironmentUpdate();
        initiateInstalledPackageUpdate();
    }

    @Future(Callout=true)
    private static void initiateEnvironmentUpdate() {
        PackageUpdateService.updateUnlockedPackageLatestReleasedFields();

    }

    public static void initiateInstalledPackageUpdate() {
        Map<Id, UPM_Environment__c> environmentsById = new Map<Id, UPM_Environment__c>([SELECT Id FROM UPM_Environment__c]);
        for (UPM_Environment__c upm : [SELECT Id FROM UPM_Environment__c]) {
            doCallout(upm.Id);
        }
    }

    @Future(Callout=true)
    private static void doCallout(Id environmentId) {
        new InstalledPackageService(new Set<Id>{
                environmentId
        }).refreshInstalledPackages();
    }
}