public with sharing class AccessApplicationModel {

	@AuraEnabled public Id id;
	@AuraEnabled public String name;
	@AuraEnabled public String description;
	@AuraEnabled public String applicationReason;
	@AuraEnabled public Boolean isApplied;
	@AuraEnabled public Boolean isAssigned;
	@AuraEnabled public Boolean isGroup;

	@AuraEnabled public List<AccessApplicationModel> children;

	public AccessApplicationModel( Id id, String name, String description, Boolean isApplied, Boolean isAssigned, Boolean isGroup, List<AccessApplicationModel> permissions ) {
		this.id = id;
		this.name = name;
		this.description = description;
		this.isApplied = isApplied;
		this.isAssigned = isAssigned;
		this.isGroup = isGroup;
		this.children = permissions;
	}

	// TODO add sorting
}
