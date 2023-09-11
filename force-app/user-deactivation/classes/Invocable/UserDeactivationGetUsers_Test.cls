@IsTest
private class UserDeactivationGetUsers_Test {
    
    @IsTest
    private static void testGetUsersToBeDeactivated_withTestUser(){
        Date lastLoginDate=Date.today();
        List<Integer> numberOfUsers=UserDeactivationGetUsers.getUsersToBeDeactivated(new List<Date>{lastLoginDate});
        System.assertEquals(1, numberOfUsers[0], 'Expect current user to be returned');
    }

    @IsTest
    private static void testGetUsersToBeDeactivated_withActualUsers(){
        Date lastLoginDate=Date.today().addDays(-60);
        List<Integer> numberOfUsers=UserDeactivationGetUsers.getUsersToBeDeactivated(new List<Date>{lastLoginDate});
        System.assertNotEquals(1, numberOfUsers[0], 'Expect other user than current user to be returned');
    }
}