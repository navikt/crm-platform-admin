public class PackageDependencyViewerController {

    @AuraEnabled(Cacheable=true)
    public static List<PackageDependencyService.SimplePackageVersion> getPackageDependencies(Boolean releasedVersionsOnly) {
        if(releasedVersionsOnly) {
            return new PackageDependencyService().getDependenciesForLatestReleasedVersions();
        } else {
            return new PackageDependencyService().getDependenciesForLatestVersions();
        }
    }

}