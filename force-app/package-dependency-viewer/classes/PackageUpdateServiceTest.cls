@IsTest
private class PackageUpdateServiceTest {
    
    @IsTest
    private static void testUpdateUnlockedPackageLatestReleasedFields(){
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(
            new List<String>{ TestDataFactory_PlatformAdmin.package2Response, TestDataFactory_PlatformAdmin.package2VersionResponse }
        );
        Test.setMock(HttpCalloutMock.class, responses);

        Test.startTest();    
        PackageUpdateService.updateUnlockedPackageLatestReleasedFields();
        Test.stopTest();
    }
}