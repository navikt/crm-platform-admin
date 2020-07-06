public with sharing class AccessApplicationModel {

	@AuraEnabled public Id permsetId;
	@AuraEnabled public String name;
	@AuraEnabled public String description;
	@AuraEnabled public String applicationReason;
	@AuraEnabled public Boolean isAssigned;
	@AuraEnabled public Boolean isGroup;
	@AuraEnabled public Boolean awaitingApproval;

	@AuraEnabled public List<AccessApplicationModel> children;

	public AccessApplicationModel( String name, String description, Id permsetId, Boolean isAssigned, Boolean isGroup, List<AccessApplicationModel> permissions ) {
		this.permsetId = permsetId;
		this.name = name;
		this.description = description;
		this.isAssigned = isAssigned;
		this.isGroup = isGroup;
		this.children = permissions;
	}

	// TODO add sorting
}
