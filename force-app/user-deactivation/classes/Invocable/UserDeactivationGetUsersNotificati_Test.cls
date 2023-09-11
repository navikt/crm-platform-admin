@IsTest
private class UserDeactivationGetUsersNotificati_Test {
   @IsTest
   private static void testGetUsersToBeDeactivated(){
    UserDeactivation__c userDeactivation=new UserDeactivation__c();
    insert userDeactivation;
    
    List<Integer> numberOfUsers=UserDeactivationGetUsersNotifications.getUsersToBeDeactivated(new List<Id>{userDeactivation.Id});
    System.assertNotEquals(1, numberOfUsers[0], 'Expect other user than current user to be returned');
   }
}