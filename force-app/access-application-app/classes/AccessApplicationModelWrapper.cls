public with sharing class AccessApplicationModelWrapper {

	@AuraEnabled public List<AccessApplicationModel> availablePermissions;
	@AuraEnabled public List<AccessApplicationModel> permissionsInReview;
	@AuraEnabled public List<AccessApplicationModel> assignedPermissions;

	public AccessApplicationModelWrapper( List<AccessApplicationModel> availablePermissions, List<AccessApplicationModel> permissionsInReview, List<AccessApplicationModel> assignedPermissions ) {
		this.availablePermissions = availablePermissions;
		this.permissionsInReview = permissionsInReview;
		this.assignedPermissions = assignedPermissions;
	}
}
