public with sharing class QueryResponseFormat {

    public Integer size;
    public Integer totalSize;
    public Boolean done;
    public List<record> records;

    public class record {
        public String Id;
        public String name;
        public String subscriberPackageId;
        public SubscriberPackage subscriberPackage;
        public SubscriberPackageVersion subscriberPackageVersion;
    }

    public class SubscriberPackage {
        public String name;
    }

    public class SubscriberPackageVersion {
        public String SubscriberPackageId;
        public String Id;
        public String Name;
        public Integer MajorVersion;
        public Integer MinorVersion;
        public Integer PatchVersion;
        public Integer BuildNumber;
        public String Description;
        public Boolean IsBeta;
        public Boolean IsPasswordProtected;
    }

    public static QueryResponseFormat parse(String json) {
        return (QueryResponseFormat) System.JSON.deserialize(json, QueryResponseFormat.class);
    }

}


