@IsTest
private class PermissionAssignmentHandlerTest {
    // PermissionAssignmentRequest__c request = getPermissionAssignmentRequests( 'TAG_CreateReports' );
	private static PermissionAssignmentRequest__c getPermissionAssignmentRequest( String permissionSetName ) {

		PermissionAssignmentRequest__c request = new PermissionAssignmentRequest__c(
			Name = UserInfo.getUserEmail(),
			CRM_PermissionSet__c = permissionSetName
			);

		return request;
	}
}
