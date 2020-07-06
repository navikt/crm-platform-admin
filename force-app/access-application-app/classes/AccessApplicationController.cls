public with sharing class AccessApplicationController {

	@AuraEnabled(cacheable = true)
	public static List<AccessApplicationModel> getPermissions() {

		// List<PermissionSetAssignment> permsetAssignemnts =  AccessApplicationFetcher.getCurrentlyAssignedPermsets();
		// List<PermissionSet> permsets =                      AccessApplicationFetcher.getAllPermissionSetsAvailable();
		// List<PermissionSetGroup> permsetGroups =            AccessApplicationFetcher.getAllPermissionSetGroupsAvailable();
		// List<AccessApplication__c> accessApplications =     AccessApplicationFetcher.getAccessApplications();

		// List<AccessApplicationModel> permsetModels =        AccessApplicationHelper.convertPermsetToModel( permsets, permsetAssignemnts, accessApplications );
		// List<AccessApplicationModel> permsetGroupModels =   AccessApplicationHelper.convertPermsetGroupToModel( permsetGroups, permsetModels, permsetAssignemnts, accessApplications );
		// permsetModels =                                     AccessApplicationHelper.removePermsetInGroups( permsetModels );

		// permsetModels.addAll( permsetGroupModels );

		// return permsetModels;

		AccessApplicationModel perm1 = new AccessApplicationModel( 'Permset 1', 'Desc 1', true, false, null );
		AccessApplicationModel perm2 = new AccessApplicationModel( 'Permset 2', 'Desc 2', false, false, null );

		AccessApplicationModel group1_1 = new AccessApplicationModel( 'Permset i gruppe 1', 'Ganske viktig', false, false, null );
		AccessApplicationModel group1_2 = new AccessApplicationModel( 'Permset i gruppe 2', 'Litt mindre her', false, false, null );
		List<AccessApplicationModel> group1List = new List<AccessApplicationModel> { group1_1, group1_2 };
		AccessApplicationModel group1 = new AccessApplicationModel( 'Group 1', 'For alle personer', false, true, group1List );

		AccessApplicationModel group2_1 = new AccessApplicationModel( 'Permset i gruppe 1', 'Ganske viktig', false, false, null );
		AccessApplicationModel group2_2 = new AccessApplicationModel( 'Permset i gruppe 2', 'Litt mindre her', false, false, null );
		AccessApplicationModel group2_3 = new AccessApplicationModel( 'Permset i gruppe 3', 'Litt mer her', false, false, null );
		List<AccessApplicationModel> group2List = new List<AccessApplicationModel> { group2_1, group2_2, group2_3 };
		AccessApplicationModel group2 = new AccessApplicationModel( 'Group 2', 'For alle personer', false, true, group2List );

		List<AccessApplicationModel> models = new List<AccessApplicationModel> {perm1, perm2, group1, group2};

		System.debug( 'models: ' + models );

		return models;

	}
}
