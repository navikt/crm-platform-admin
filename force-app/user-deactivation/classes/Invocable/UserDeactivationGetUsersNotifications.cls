public with sharing class UserDeactivationGetUsersNotifications {
    @InvocableMethod(label='Get number of users with notifications that should be deactivated' description='Get users who is not logged in since input login date, and receivied notification.')
    public static List<Integer> getUsersToBeDeactivated(List<Id> userDeactivationId){
        return new List<Integer>{1};
    }
}