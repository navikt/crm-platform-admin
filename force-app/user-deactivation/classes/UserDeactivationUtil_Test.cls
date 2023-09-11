@IsTest 
private class UserDeactivationUtil_Test {

    @IsTest
    private static void testGetUsersToBeDeactivated_withTestUser(){
        List<User> users=UserDeactivationUtil.getUsersToBeDeactivated(Date.today(),false,true);
        System.assertEquals(1, users.size(), 'Expect current user to be returned');
    }

    @IsTest
    private static void testGetUsersToBeDeactivated_withActualUsers(){
        List<User> users=UserDeactivationUtil.getUsersToBeDeactivated(Date.today(),false,false);
        System.assertNotEquals(null,users, 'Expect query to be executed');
    }
}