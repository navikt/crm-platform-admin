public with sharing class AccessApplicationModel {

	@AuraEnabled public String name;
	@AuraEnabled public String description;
	@AuraEnabled public Boolean isAssigned;
	@AuraEnabled public Boolean isGroup;
	@AuraEnabled public Boolean awaitingApproval;

	@AuraEnabled public List<AccessApplicationModel> permissions;

	public AccessApplicationModel( String name, String description, Boolean isAssigned, Boolean isGroup, List<AccessApplicationModel> permissions ) {
		this.name = name;
		this.description = description;
		this.isAssigned = isAssigned;
		this.isGroup = isGroup;
		this.permissions = permissions;
	}
}
