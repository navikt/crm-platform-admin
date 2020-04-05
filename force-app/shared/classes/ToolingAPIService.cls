public class ToolingAPIService {
    private static final String TOOLING_API_URI = '/services/data/v48.0/tooling';
    private final Mode DEPENDENCY_MODE;
    private final Http http;

    public ToolingAPIService() {
        this.http = new Http();
        this.DEPENDENCY_MODE = Mode.LATEST;
    }

    public ToolingAPIService(Mode dependencyMode) {
        this.http = new Http();
        this.DEPENDENCY_MODE = dependencyMode;
    }

    public enum Mode {
        LATEST, RELEASED
    }

    private HttpRequest getQueryRequest(String query) {
        HttpRequest request = this.createHttpRequest();
        query = query.replace(' ', '+');
        request.setEndpoint(request.getEndpoint() + '/query?q=' + query);
        return request;
    }

    private String getPackage2VersionsFilter() {
        String filterString = '';
        switch on this.DEPENDENCY_MODE {
            when LATEST {
                filterString = ' ORDER BY CreatedDate DESC LIMIT 1';
            }
            when RELEASED {
                filterString = ' WHERE IsReleased = TRUE ORDER BY CreatedDate DESC LIMIT 1';
            }
        }
        return filterString;
    }

    private HttpRequest createHttpRequest() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:NAV_Salesforce_Production' + TOOLING_API_URI);
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(120000);
        request.setMethod('GET');
        return request;
    }

    public Package2Response getPackagesWithDependencies() {
        HttpRequest request = this.getQueryRequest('SELECT Id, (SELECT Id, SubscriberPackageVersionId, SubscriberPackageVersion.Dependencies FROM Package2Versions' + getPackage2VersionsFilter() + ') FROM Package2');
        System.debug(request.getEndpoint());
        HttpResponse res = this.http.send(request);
        System.debug('xxx getPackagesWithDependencies:');
        System.debug(res.getBody());
        Package2Response toolingResponse = (Package2Response) Json.deserialize(res.getBody(), Package2Response.class);
        return toolingResponse;
    }

    public Package2Response getPackageWithLatestReleasedVersions() {
        HttpRequest request = this.getQueryRequest('SELECT Id, (SELECT Id, SubscriberPackageVersionId FROM Package2Versions' + getPackage2VersionsFilter() + ') FROM Package2');
        System.debug(request.getEndpoint());
        HttpResponse res = this.http.send(request);
        System.debug('xxx getPackageWithLatestReleasedVersions:');
        System.debug(res.getBody());
        Package2Response toolingResponse = (Package2Response) Json.deserialize(res.getBody(), Package2Response.class);
        return toolingResponse;
    }

    public Package2VersionResponse listPackage2Versions() {
        HttpRequest request = this.getQueryRequest('SELECT Id, Package2.SubscriberPackageId, Package2.Name, Package2.Id, MajorVersion, MinorVersion, PatchVersion, BuildNumber, SubscriberPackageVersionId FROM Package2Version');
        HttpResponse res = this.http.send(request);
        System.debug('xxx listPackage2Versions:');
        System.debug(res.getBody());
        Package2VersionResponse toolingResponse = (Package2VersionResponse) Json.deserialize(res.getBody(), Package2VersionResponse.class);
        return toolingResponse;
    }


    public class Package2Response {
        public List<Package2> records;
    }

    public class Package2 {
        @AuraEnabled public Id id;
        @AuraEnabled public Id subscriberPackageId;
        @AuraEnabled public String name;
        public Package2VersionObject package2Versions;
    }

    public class Package2VersionObject {
        public List<Package2Version> records;
    }

    public class Package2Version {
        @AuraEnabled public SubscriberPackageVersion subscriberPackageVersion;
        @AuraEnabled public Id subscriberPackageVersionId;
        public String name;
        @AuraEnabled public Integer majorVersion;
        @AuraEnabled public Integer minorVersion;
        @AuraEnabled public Integer patchVersion;
        @AuraEnabled public Integer buildNumber;
        @AuraEnabled public Package2 package2;
    }

    public class SubscriberPackageVersion {
        public SubscriberPackageVersionDependency dependencies;
    }

    public class SubscriberPackageVersionDependency {
        public List<SubscriberPackageVersionDependencyId> ids;
    }

    public class SubscriberPackageVersionDependencyId {
        public String subscriberPackageVersionId;
    }

    public class Package2VersionResponse {
        public List<Package2Version> records;
    }
}
