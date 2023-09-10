public with sharing class UserDeactivationCreateCSV {
    @InvocableMethod(label='Create CSV files' description='Generate CSV files for each profiles with users who should be deactivated')
    public static List<Integer> createCsvFiles(List<Id> userDeactivationId){
        return new List<Integer>{2};
    }
}