public with sharing class ObjectPermissionViewerController {

    @AuraEnabled(Cacheable=true)
    public static List<ObjectPermissionAnalyzerService.SensitivePermission> getObjectPermissions(Boolean onlyCustomPermissionSets) {
        return ObjectPermissionAnalyzerService.getViewAllModifyAllObjectPermissions(
                false,
                onlyCustomPermissionSets,
                false,
                null);
    }

}