public with sharing class AccessApplicationController {




	@AuraEnabled(cacheable = true)
	public static AccessApplicationModelWrapper getPermissions() {

		// List<PermissionSetAssignment> permsetAssignemnts =  AccessApplicationFetcher.getCurrentlyAssignedPermsets();
		// List<PermissionSet> permsets =                      AccessApplicationFetcher.getAllPermissionSetsAvailable();
		// List<PermissionSetGroup> permsetGroups =            AccessApplicationFetcher.getAllPermissionSetGroupsAvailable();
		// List<AccessApplication__c> accessApplications =     AccessApplicationFetcher.getAccessApplications();

		// List<AccessApplicationModel> permsetModels =        AccessApplicationHelper.convertPermsetToModel( null, permsets, permsetAssignemnts, accessApplications );
		// List<AccessApplicationModel> permsetGroupModels =   AccessApplicationHelper.convertPermsetGroupToModel( permsetGroups, null, permsetModels, permsetAssignemnts, accessApplications );
		// permsetModels =                                     AccessApplicationHelper.removePermsetInGroups( permsetModels );

		// permsetModels.addAll( permsetGroupModels );

		// return permsetModels;

		AccessApplicationModel perm1 = new AccessApplicationModel( 'Tolketjeneste', 'Se hvem som behøver tolketjenester', null, true, false, null );
		AccessApplicationModel perm2 = new AccessApplicationModel( 'Varsler', 'Varslinger som blir sendt til NAV', null, false, false, null );
		AccessApplicationModel perm3 = new AccessApplicationModel( 'Permitteringer', 'Permitteringsvarsler som sendes til NAV', null, false, false, null );
		AccessApplicationModel perm4 = new AccessApplicationModel( 'Aktiviteter', 'All aktivitet som registreres på virksomheter, gjennomført av NAV', null, false, false, null );

		AccessApplicationModel group1_1 = new AccessApplicationModel( 'Virksomheter', 'Se virksomheter', null, false, false, null );
		AccessApplicationModel group1_2 = new AccessApplicationModel( 'Kontakter', 'Se kontaktene i virkomsheter', null, false, false, null );
		List<AccessApplicationModel> group1List = new List<AccessApplicationModel> { group1_1, group1_2 };
		AccessApplicationModel group1 = new AccessApplicationModel( 'Standardtilganger', 'Standardtilgang de fleste trenger for å bruke Salesforce', null, false, true, group1List );

		AccessApplicationModel group2_1 = new AccessApplicationModel( 'Avtaler', 'Avtaler som virksomheter inngår med NAV', null, false, false, null );
		AccessApplicationModel group2_2 = new AccessApplicationModel( 'Arena Aktivitet', 'Aktiviteter som føres i Arena', null, false, false, null );
		AccessApplicationModel group2_3 = new AccessApplicationModel( 'Meldinger', 'Muligheten til å kunne sende meldinger til kontakter i virksomheter', null, false, false, null );
		List<AccessApplicationModel> group2List = new List<AccessApplicationModel> { null, group2_1, group2_2, group2_3 };
		AccessApplicationModel group2 = new AccessApplicationModel( 'Arbeidsgiver', 'For de som jobber mot arbeidsgivere', null, false, true, group2List );

		List<AccessApplicationModel> assigned = new List<AccessApplicationModel> { perm1, perm2, group2_3, group2 }; // TODO null, remove permset if already in group
		List<AccessApplicationModel> applied = new List<AccessApplicationModel> { perm3 };
		List<AccessApplicationModel> available = new List<AccessApplicationModel> { perm4, group1 };

		AccessApplicationModelWrapper wrapper = new AccessApplicationModelWrapper( available, applied, assigned );

		// System.debug( 'models: ' + models );

		return wrapper;

	}
}
