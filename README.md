# crm-platform-admin
This package contains administration, audit and monitoring functionality in order to monitor and support development and
deployment on the Salesforce platform. 

## Setup and Installation
The unlocked package depends only on [crm-platform-base](https://github.com/navikt/crm-platform-base). Components
that query other Salesforce environments through the Tooling API rely on the use of Named Credentials and Auth Providers
(included in the package) tied to Connected Apps for Production and Sandbox Salesforce environments (not included in the
 package - these are admistered in the NAV Production org).  
 
 To automatically schedule updating of installed package versions, latest released package versions, and installation
  dependency order, schedule the `PackageUpdate_Schedule` class to run regularily (e.g. every hour):

 ```
 System.schedule('Hourly update of Platform Admin App objects (package dependencies, installed packages accross environments)', '0 0 * * * ?', new PackageUpdate_Schedule());
  ```

## Functionality
### Development Pipeline
This component displays the Unlocked Package versions currently installed accross configured Sandbox and Production
environments. Environments to monitor is configurable through the `Environment__c` custom object. Packages to monitor 
are configurable through the `UnlockedPackage__c` custom object. An Apex callout using the Salesforce Tooling API queries 
defined environments using the Tooling API to populate the custom object `InstalledPackage__c` is populated
with the current package versions installed in the given environment. The query may run on a schedule or be triggered 
manually from the associated Lightning Web Component.


## Package Dependency Viewer
This component displays Unlocked Package versions with their declared dependencies. The Lightning Web Component allows
a developer to understand the package dependency tree for all package associated with the Dev Hub environment. 
The associated backend logic is also used to populate the fields `LatestReleasedVersionInstallOrder__c` and
 `LatestReleasedVersionInstallOrder__c` on the `UnlockedPackage__c` custom object. These fields can be used to
 ascertain the required installation order of the latest released version of all packages, enabling other scriptable
 workflows for testing and deployment.


## Object Permission Viewer
This component queries and visualizes object permissions granted through Permission Sets in the current Salesforce 
environment. For sensitive objects where "View All" and/or "Modify All" permissions should not be granted through
 permisison sets, these restrictions can be defined through the Custom Metadata Object 
 `PermissionAnalyzerObjectSettings__mdt`.