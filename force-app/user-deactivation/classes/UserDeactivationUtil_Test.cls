@IsTest 
private class UserDeactivationUtil_Test {
    @IsTest
    private static void testGetUsersToBeDeactivated_withTestUser(){
        List<User> users=UserDeactivationUtil.getUsersToBeDeactivated(Date.today(),null,true);
        System.assertEquals(1, users.size(), 'Expect current user to be returned');
    }

    @IsTest
    private static void testGetUsersToBeDeactivated_withActualUsers(){
        List<User> users=UserDeactivationUtil.getUsersToBeDeactivated(Date.today(),null,false);
        System.assertNotEquals(null,users, 'Expect query to be executed');
    }

    @IsTest
    private static void testGetUsersToBeDeactivated_forUsersReceivedNotification(){
        UserDeactivation__c userDeactivation=new UserDeactivation__c();
        insert userDeactivation;

        List<User> users=UserDeactivationUtil.getUsersToBeDeactivated(Date.today(),userDeactivation.Id,false);
        System.assertNotEquals(null,users, 'Expect query to be executed');
    }
}