@IsTest
private class UnlockedPackageServiceTest {
    
    @IsTest
    private static void testGetUnlockedPackageSOQLFilterFromRecords(){

        //insert test data
        List<UnlockedPackage__c> packages = new List<UnlockedPackage__c>();
        packages.add(new UnlockedPackage__c(Name = 'test-package-1', SubscriberPackageId__c = '0332o000000TyICAA0'));
        packages.add(new UnlockedPackage__c(Name = 'test-package-2', SubscriberPackageId__c = '0332o000000TyIHAA0'));
        packages.add(
            new UnlockedPackage__c(Name = 'test-package-3', SubscriberPackageId__c = '0332o000000XXXXXXX') // Doesn't exist in mock response
        );
        insert packages;

        Test.startTest();
        String result=UnlockedPackageService.getUnlockedPackageSOQLFilterFromRecords();
        Test.stopTest();

        System.assertNotEquals(null, result);
    }
}