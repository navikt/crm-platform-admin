@IsTest
private class PackageDependencyViewerControllerTest {
    @IsTest
    private static void testGetPackageDependencies_whenNotReleasedVersionsOnly() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.package2Response, TestDataFactory_PlatformAdmin.package2VersionResponse }
        );
        Test.setMock(HttpCalloutMock.class, responses);


        Test.startTest();
        List<PackageDependencyService.SimplePackageVersion> result=PackageDependencyViewerController.getPackageDependencies(false);
        Test.stopTest();
        System.assertNotEquals(null, result);
    }

    @IsTest
    private static void testGetPackageDependencies_whenReleasedVersionsOnly() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.package2Response, TestDataFactory_PlatformAdmin.package2VersionResponse }
        );
        Test.setMock(HttpCalloutMock.class, responses);


        Test.startTest();
        List<PackageDependencyService.SimplePackageVersion> result=PackageDependencyViewerController.getPackageDependencies(true);
        Test.stopTest();
        System.assertNotEquals(null, result);
    }
}