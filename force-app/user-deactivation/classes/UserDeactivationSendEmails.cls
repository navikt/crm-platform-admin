public with sharing class UserDeactivationSendEmails {
    @InvocableMethod(label='Send email notifications' description='Send email notifications to users who have not been logged in lately')
    public static List<Integer> sendEmailNotifications(List<Id> userDeactivationId){
        return new List<Integer>{3};
    }
}