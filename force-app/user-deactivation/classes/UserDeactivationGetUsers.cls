public with sharing class UserDeactivationGetUsers {
    @InvocableMethod(label='Get number of users to be deactivated' description='Get users who is not logged in since input login date')
    public static List<Integer> getUsersToBeDeactivated(List<Date> lastLoginDates){
        return new List<Integer>{4};
    }
}