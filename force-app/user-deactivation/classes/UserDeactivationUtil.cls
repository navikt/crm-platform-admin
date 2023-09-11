public with sharing class UserDeactivationUtil {
    
   public Static List<User> getUsersToBeDeactivated(Date lastLoginDate, Id userDeactivationRecordId, Boolean useTestUsers){
    DateTime lastLoginDateTime= Datetime.newInstance(lastLoginDate, Time.newInstance(23,59,59,59));
    String query='SELECT Id, CRM_NAV_Ident__c FROM User';
    query +=' WHERE IsActive=true ';
    if(useTestUsers){
        //return only current user
        query+='AND Id=\'' + UserInfo.getUserId() + '\'';
    }
    else{
        Set<Id> profileIds=getProfileIdsForDeactivation();
        //return all users who haven't been logged in since selected last login date, and with profiles who can be deactivated
        query+=' AND ProfileId in: profileIds';
        query+=' AND LastLoginDate <:lastLoginDateTime';
    }

    if(userDeactivationRecordId!=null){
        query +=' AND UserDeactivationId__c=:userDeactivationRecordId';
    }
    system.System.debug(query);
    return Database.query(query);
   }

   private static Set<Id> getProfileIdsForDeactivation(){
    List<String> profileNames=new List<String>();
    for(UserDeactivationProfile__mdt userDeactivationProfile:[SELECT Label FROM UserDeactivationProfile__mdt]){
        profileNames.add(userDeactivationProfile.Label);
    }
    
    Set<Id> profileIds=new Set<Id>();
    for(Profile profile:[SELECT Id FROM Profile WHERE Name in:profileNames]){
        profileIds.add(profile.Id);
    }
    return profileIds;
   }
}