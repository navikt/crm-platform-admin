public class UnlockedPackageService {

    public static String getUnlockedPackageSOQLFilterFromRecords() {
        String filterString = '(';
        for (UnlockedPackage__c up : [SELECT Id, SubscriberPackageId__c FROM UnlockedPackage__c]) {
            filterString += '\'' + up.SubscriberPackageId__c + '\',';
        }
        filterString = filterString.removeEnd(',');
        filterString += ')';
        return filterString;
    }

}