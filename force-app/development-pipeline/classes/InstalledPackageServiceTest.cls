@IsTest
private class InstalledPackageServiceTest {
    @IsTest
    private static void doTest() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.int_environment_query_response, TestDataFactory_PlatformAdmin.uat_environment_query_response }
        );
        Test.setMock(HttpCalloutMock.class, responses);

        List<UnlockedPackage__c> packages = new List<UnlockedPackage__c>();
        packages.add(new UnlockedPackage__c(Name = 'test-package-1', SubscriberPackageId__c = '0332o000000TyICAA0'));
        packages.add(new UnlockedPackage__c(Name = 'test-package-2', SubscriberPackageId__c = '0332o000000TyIHAA0'));
        packages.add(
            new UnlockedPackage__c(Name = 'test-package-3', SubscriberPackageId__c = '0332o000000XXXXXXX') // Doesn't exist in mock response
        );
        insert packages;

        List<Environment__c> environments = new List<Environment__c>();
        environments.add(
            new Environment__c(Name = 'Integration Sandbox', NamedCredential__c = 'INT', SortOrder__c = 0)
        );
        environments.add(new Environment__c(Name = 'UAT Sandbox', NamedCredential__c = 'UAT', SortOrder__c = 1));
        insert environments;

        Test.startTest();
        Map<Id, Environment__c> environmentsById = new Map<Id, Environment__c>([SELECT Id FROM Environment__c]);
        new InstalledPackageService(environmentsById.keySet()).refreshInstalledPackages();
        Test.stopTest();

        List<InstalledPackage__c> intInstalledPackages = [
            SELECT Id
            FROM InstalledPackage__c
            WHERE Environment__r.Name = 'Integration Sandbox'
        ];
        List<InstalledPackage__c> uatInstalledPackages = [
            SELECT Id
            FROM InstalledPackage__c
            WHERE Environment__r.Name = 'UAT Sandbox'
        ];
        System.assertEquals(2, intInstalledPackages.size());
        System.assertEquals(1, uatInstalledPackages.size());
    }
}   
