public with sharing class UserDeactivationGetUsers {
    @InvocableMethod(label='Get number of users to be deactivated' description='Get users who is not logged in since input login date')
    public static List<Integer> getUsersToBeDeactivated(List<Date> lastLoginDates){
        Boolean useTestUsers=false;
        if(lastLoginDates[0]==Date.Today()){
            useTestUsers=true; //if test user is chosen in flow, the last login date should be changed today's date in the flow
        }
        List<User> usersToBeDeactivated=UserDeactivationUtil.getUsersToBeDeactivated(lastLoginDates[0],null,useTestUsers);
        return new List<Integer>{usersToBeDeactivated.size()}; //retrun number of users back to the flow
    }
}