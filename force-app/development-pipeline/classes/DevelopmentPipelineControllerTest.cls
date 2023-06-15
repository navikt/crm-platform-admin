@isTest
public class DevelopmentPipelineControllerTest {

    @TestSetup
    private static void makeData(){
       
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


        List<InstalledPackage__c> installedPackages= new List<InstalledPackage__c>();
        installedPackages.add(new InstalledPackage__c(Name='Test Installed Package', UnlockedPackage__c=packages[0].Id, Environment__c=environments[0].Id));
        insert installedPackages;
    }

    @isTest
    public static void testGetEnvironmentData() {

        Test.startTest();
        List<Environment__c> result = DevelopmentPipelineController.getEnvironmentData();
        Test.stopTest();
        
        // Assert the result
        System.assertEquals(2, result.size());
        Environment__c retrievedEnvironment = result[0];
        System.assertEquals('Integration Sandbox', retrievedEnvironment.Name);
        System.assertEquals(0, retrievedEnvironment.SortOrder__c);
        
        List<InstalledPackage__c> installedPackages = [SELECT Name FROM InstalledPackage__c];
        System.assertEquals(1, installedPackages.size());
        InstalledPackage__c retrievedPackage = installedPackages[0];
        System.assertEquals('Test Installed Package', retrievedPackage.Name);
    }
    
    @isTest
    public static void testRefreshInstalledPackageData() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.int_environment_query_response, TestDataFactory_PlatformAdmin.uat_environment_query_response }
        );
        Test.setMock(HttpCalloutMock.class, responses);

        Test.startTest();
        Environment__c env=[SELECT Id FROM Environment__c LIMIT 1];
        List<Id> orgIds = new List<Id>{env.Id};
        DevelopmentPipelineController.refreshInstalledPackageData(orgIds);
        Test.stopTest();

        List<InstalledPackage__c> intInstalledPackages = [
            SELECT Id
            FROM InstalledPackage__c
            WHERE Environment__r.Name = 'Integration Sandbox'
        ];
        System.assertEquals(2, intInstalledPackages.size());
    }
}
