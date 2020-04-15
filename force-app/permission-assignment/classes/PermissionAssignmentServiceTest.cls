@IsTest
private class PermissionAssignmentServiceTest {
    @IsTest
	private static void assignPermisisonSet() {
        
        Test.startTest();
        String errorMessage=new PermissionAssignmentService().assignPermisisonSet(UserInfo.getUserEmail(),'TAG_CreateReports');
        Test.stopTest();

        System.assertEquals(null,errorMessage);
        PermissionSet permissionSet=[SELECT Id FROM PermissionSet WHERE Name='TAG_CreateReports' LIMIT 1];
        System.assertEquals(1, [SELECT count() FROM PermissionSetAssignment WHERE AssigneeId=:UserInfo.getUserId() AND PermissionSetId=:permissionSet.Id]);
	}
}
