@IsTest
public class PackageUpdate_ScheduleTest {
    @IsTest
    static void testExecuteMethod() {
        // Create test data
        List<Environment__c> environments = new List<Environment__c>();
        environments.add(
            new Environment__c(Name = 'Integration Sandbox', NamedCredential__c = 'INT', SortOrder__c = 0)
        );
        environments.add(new Environment__c(Name = 'UAT Sandbox', NamedCredential__c = 'UAT', SortOrder__c = 1));
        insert environments;

        
        String CRON_EXP = '0 0 0 1 6 ? 2029';
        String jobId = System.schedule('PackageUpdate', CRON_EXP, new PackageUpdate_Schedule());
        System.assertNotEquals(null, jobId);
    }
}
