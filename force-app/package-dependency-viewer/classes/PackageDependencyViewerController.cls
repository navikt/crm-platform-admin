public class PackageDependencyViewerController {

    @AuraEnabled(Cacheable=true)
    public static List<PackageDependencyService.PackageVersionDependency> getPackageDependencies(Boolean releasedOnly) {
        if (releasedOnly) {
            return PackageDependencyService.getDependencies(ToolingAPIService.Mode.RELEASED);
        } else {
            return PackageDependencyService.getDependencies(ToolingAPIService.Mode.LATEST);
        }
    }

}