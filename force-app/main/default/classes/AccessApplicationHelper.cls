public with sharing class AccessApplicationHelper {

	public static List<AccessApplicationModel> convertPermsetToModel( List<PermissionSet> permsets, List<PermissionSetAssignment> permsetAssignemnts, List<AccessApplication__c> accessApplications ) {

		List<AccessApplicationModel> permsetModels = new List<AccessApplicationModel> ();

		for ( PermissionSet ps : permsets ) {

			// AccessApplicationModel permsetModel = new AccessApplicationModel(name, description, isAssigned, false, null);

		}

		return null;
	}

	public static List<AccessApplicationModel> convertPermsetGroupToModel( List<PermissionSetGroup> permsetGroups, List<AccessApplicationModel> permsetModels, List<PermissionSetAssignment> permsetAssignemnts, List<AccessApplication__c> accessApplications ) {

		List<AccessApplicationModel> permsetGroupModels = new List<AccessApplicationModel> ();

		for ( PermissionSetGroup ps : permsetGroups ) {

			List<AccessApplicationModel> permsetsInGroup = new List<AccessApplicationModel>();
			for ( AccessApplicationModel psm : permsetModels ) {
				// TODO get permset in group
			}

			// AccessApplicationModel permsetModel = new AccessApplicationModel(name, description, isAssigned, true, permsetsInGroup);

		}

		return null;
	}

	public static List<AccessApplicationModel> removePermsetInGroups( List<AccessApplicationModel> permsetModels ) {
		return null;
	}
}
