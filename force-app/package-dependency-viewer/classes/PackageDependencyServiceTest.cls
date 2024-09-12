@IsTest
private class PackageDependencyServiceTest {
    @IsTest
    static void testGetDependencies() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.package2Response, TestDataFactory_PlatformAdmin.package2VersionResponse }
        );
        Test.setMock(HttpCalloutMock.class, responses);

        Test.startTest();
        List<PackageDependencyService.SimplePackageVersion> packageVersions = new PackageDependencyService()
            .getDependenciesForLatestReleasedVersions();
        Test.stopTest();

        // Assert that the response is correctly parsed and returned in the correct order
        System.assertEquals(2, packageVersions.size());
        System.assertEquals('fflib-apex-mocks', packageVersions[0].packageName);
        System.assertEquals('fflib-apex-common', packageVersions[1].packageName);
    }

    @IsTest
    static void testUpdatePackageRecords() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.package2Response, TestDataFactory_PlatformAdmin.package2VersionResponse }
        );
        Test.setMock(HttpCalloutMock.class, responses);

        List<UnlockedPackage__c> packages = new List<UnlockedPackage__c>();

        UnlockedPackage__c package1 = new UnlockedPackage__c();
        package1.Name = 'test-package-1';
        package1.SubscriberPackageId__c = '0332o000000TyICAA0';
        packages.add(package1);

        UnlockedPackage__c package2 = new UnlockedPackage__c();
        package2.Name = 'test-package-2';
        package2.SubscriberPackageId__c = '0332o000000TyIHAA0';
        packages.add(package2);

        UnlockedPackage__c package3 = new UnlockedPackage__c();
        package3.Name = 'test-package-3';
        package3.SubscriberPackageId__c = '0332o000000XXXXXXX'; // Doesn't exist in mock response
        packages.add(package3);

        insert packages;

        Test.startTest();
        PackageUpdateService.updateUnlockedPackageLatestReleasedFields();
        Test.stopTest();

        packages = [
            SELECT Id, LatestReleasedSubscriberPackageVersionId__c, LatestReleasedVersionInstallOrder__c
            FROM UnlockedPackage__c
            ORDER BY Name ASC
        ];

        System.assertEquals(3, packages.size());

        System.assertEquals('04t2o000001MwxDAAS', packages[0].LatestReleasedSubscriberPackageVersionId__c);
        System.assertEquals('04t2o000001MwxIAAS', packages[1].LatestReleasedSubscriberPackageVersionId__c);
        System.assertEquals(null, packages[2].LatestReleasedSubscriberPackageVersionId__c);

        System.assertEquals(0, packages[0].LatestReleasedVersionInstallOrder__c);
        System.assertEquals(1, packages[1].LatestReleasedVersionInstallOrder__c);
        System.assertEquals(null, packages[2].LatestReleasedVersionInstallOrder__c);
    }
}