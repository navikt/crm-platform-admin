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

		Account acc1 = new Account( Name = '1' );
		Account acc2 = new Account( Name = '2' );
		Account acc3 = new Account( Name = '3' );
		Account acc4 = new Account( Name = '4' );
		Account acc5 = new Account( Name = '5' );
		Account acc6 = new Account( Name = '6' );
		Account acc7 = new Account( Name = '7' );
		Account acc8 = new Account( Name = '8' );
		Account acc9 = new Account( Name = '9' );
		Account acc10 = new Account( Name = '10' );
		Account acc11 = new Account( Name = '11' );
		insert new List<Account> { acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11 };


		AccessApplicationModel perm1 = new AccessApplicationModel( acc1.Id, 'Tolketjeneste', 'Se hvem som behøver tolketjenester', false, true, false, null );
		AccessApplicationModel perm2 = new AccessApplicationModel( acc2.Id, 'Varsler', 'Varslinger som blir sendt til NAV', true, false, false, null );
		AccessApplicationModel perm3 = new AccessApplicationModel( acc3.Id, 'Permitteringer', 'Permitteringsvarsler som sendes til NAV', false, false, false, null );
		AccessApplicationModel perm4 = new AccessApplicationModel( acc4.Id, 'Aktiviteter', 'All aktivitet som registreres på virksomheter, gjennomført av NAV', false, false, false, null );

		AccessApplicationModel group1_1 = new AccessApplicationModel( acc5.Id, 'Virksomheter', 'Se virksomheter', true, false, false, null );
		AccessApplicationModel group1_2 = new AccessApplicationModel( acc6.Id, 'Kontakter', 'Se kontaktene i virkomsheter', false, false, false, null );
		List<AccessApplicationModel> group1List = new List<AccessApplicationModel> { group1_1, group1_2 };
		AccessApplicationModel group1 = new AccessApplicationModel( acc7.Id, 'Standardtilganger', 'Standardtilgang de fleste trenger for å bruke Salesforce', false, false, true, group1List );

		AccessApplicationModel group2_1 = new AccessApplicationModel( acc8.Id, 'Avtaler', 'Avtaler som virksomheter inngår med NAV', false, false, false, null );
		AccessApplicationModel group2_2 = new AccessApplicationModel( acc9.Id, 'Arena Aktivitet', 'Aktiviteter som føres i Arena', false, false, false, null );
		AccessApplicationModel group2_3 = new AccessApplicationModel( acc10.Id, 'Meldinger', 'Muligheten til å kunne sende meldinger til kontakter i virksomheter', false, false, false, null );
		List<AccessApplicationModel> group2List = new List<AccessApplicationModel> { group2_1, group2_2, group2_3 };
		AccessApplicationModel group2 = new AccessApplicationModel( acc11.Id, 'Arbeidsgiver', 'For de som jobber mot arbeidsgivere', true, false, true, group2List );

		List<AccessApplicationModel> models = new List<AccessApplicationModel> {perm1, perm2, group1, group2};

		System.debug( 'models: ' + models );

		return models;

	}
}
