public with sharing class AccessApplicationController {

	@AuraEnabled(cacheable = true)
	public static List<AccessApplicationModel> getPermissions() { // TODO accept parameter stating if viewing avaiable, assigned or already applied

		// List<PermissionSetAssignment> permsetAssignemnts =  AccessApplicationFetcher.getCurrentlyAssignedPermsets();
		// List<PermissionSet> permsets =                      AccessApplicationFetcher.getAllPermissionSetsAvailable();
		// List<PermissionSetGroup> permsetGroups =            AccessApplicationFetcher.getAllPermissionSetGroupsAvailable();
		// List<AccessApplication__c> accessApplications =     AccessApplicationFetcher.getAccessApplications();

		// List<AccessApplicationModel> permsetModels =        AccessApplicationHelper.convertPermsetToModel( permsets, permsetAssignemnts, accessApplications );
		// List<AccessApplicationModel> permsetGroupModels =   AccessApplicationHelper.convertPermsetGroupToModel( permsetGroups, permsetModels, permsetAssignemnts, accessApplications );
		// permsetModels =                                     AccessApplicationHelper.removePermsetInGroups( permsetModels );
// TODO remove assigned and applied
		// permsetModels.addAll( permsetGroupModels );

		// return permsetModels;



		AccessApplicationModel perm1 = new AccessApplicationModel( '001i000001AWbWugt1', null, 'Tolketjeneste', 'Se hvem som behøver tolketjenester', false, true, false, null );
		AccessApplicationModel perm2 = new AccessApplicationModel( '001i000001AWbWugt2', null, 'Varsler', 'Varslinger som blir sendt til NAV', true, false, false, null );
		AccessApplicationModel perm3 = new AccessApplicationModel( '001i000001AWbWugt3', null, 'Permitteringer', 'Permitteringsvarsler som sendes til NAV', false, false, false, null );
		AccessApplicationModel perm4 = new AccessApplicationModel( '001i000001AWbWugt4', null, 'Aktiviteter', 'All aktivitet som registreres på virksomheter, gjennomført av NAV', false, false, false, null );

		AccessApplicationModel group1_1 = new AccessApplicationModel( '001i000001AWbWugt5', '001i000001AWbWugt7', 'Virksomheter', 'Se virksomheter', true, false, false, null );
		AccessApplicationModel group1_2 = new AccessApplicationModel( '001i000001AWbWugt6', '001i000001AWbWugt7', 'Kontakter', 'Se kontaktene i virkomsheter', false, false, false, null );
		List<AccessApplicationModel> group1List = new List<AccessApplicationModel> { group1_1, group1_2 };
		AccessApplicationModel group1 = new AccessApplicationModel( '001i000001AWbWugt7', null, 'Standardtilganger', 'Standardtilgang de fleste trenger for å bruke Salesforce', false, false, true, group1List );

		AccessApplicationModel group2_1 = new AccessApplicationModel( '001i000001AWbWugt8', '001i000001AWbWug11', 'Avtaler', 'Avtaler som virksomheter inngår med NAV', false, false, false, null );
		AccessApplicationModel group2_2 = new AccessApplicationModel( '001i000001AWbWugt9', '001i000001AWbWug11', 'Arena Aktivitet', 'Aktiviteter som føres i Arena', false, false, false, null );
		AccessApplicationModel group2_3 = new AccessApplicationModel( '001i000001AWbWug10', '001i000001AWbWug11', 'Meldinger', 'Muligheten til å kunne sende meldinger til kontakter i virksomheter', false, false, false, null );
		List<AccessApplicationModel> group2List = new List<AccessApplicationModel> { group2_1, group2_2, group2_3 };
		AccessApplicationModel group2 = new AccessApplicationModel( '001i000001AWbWug11', null, 'Arbeidsgiver', 'For de som jobber mot arbeidsgivere', true, false, true, group2List );

		List<AccessApplicationModel> models = new List<AccessApplicationModel> {perm1, perm2, perm3, perm4, group1, group2};

		System.debug( 'models: ' + models );

		return models;

	}
}
