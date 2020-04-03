import { LightningElement, wire } from "lwc";
import getPackageDependencies from "@salesforce/apex/PackageDependencyViewerController.getPackageDependencies";

const columns = [
  {
    type: 'text',
    fieldName: 'name',
    label: 'Package'
  },
  {
    type: 'text',
    fieldName: 'version',
    label: 'Version'
  },
  {
    type: 'text',
    fieldName: 'versionId',
    label: 'Version Id'
  }
];

export default class PackageDependencyViewer extends LightningElement {

  columns = columns;
  releasedOnly = true;
  packageDependencies;
  showLoadingSpinner;

  @wire(getPackageDependencies, { releasedOnly: "$releasedOnly" })
  wiredObjectPermissions({ error, data }) {
    let self = this;
    this.showLoadingSpinner = true;

    if (data) {
      let packageVersions = [];
      data.forEach(function(element) {
        let flattenedPackageVersion = self.flattenPackageVersion(element);
        packageVersions.push(flattenedPackageVersion);
      });
      this.packageDependencies = packageVersions;
      console.log(packageVersions)
      this.error = undefined;
      this.showLoadingSpinner = false;
    } else if (error) {
      this.error = error;
      this.packageDependencies = undefined;
      console.log(error);
      this.showLoadingSpinner = false;
    }
  }

  flattenPackageVersion(packageVersion) {
    let flattenedPackageVersion = {};
    flattenedPackageVersion.name = packageVersion.packageVersion.package2.name;
    flattenedPackageVersion.version = packageVersion.packageVersion.majorVersion + "." + packageVersion.packageVersion.minorVersion + "." + packageVersion.packageVersion.patchVersion + "." + packageVersion.packageVersion.buildNumber;
    flattenedPackageVersion.versionId = packageVersion.packageVersion.subscriberPackageVersionId;

    if(packageVersion.dependentPackageVersions && packageVersion.dependentPackageVersions.length > 0) {
      let dependentPackageVersions = [];
      packageVersion.dependentPackageVersions.forEach(function(element) {
        let depenentPackageVersion = {};
        depenentPackageVersion.name = element.package2.name;
        depenentPackageVersion.version = element.majorVersion + "." + element.minorVersion + "." + element.patchVersion + "." + element.buildNumber;
        depenentPackageVersion.versionId = element.subscriberPackageVersionId;
        dependentPackageVersions.push(depenentPackageVersion);
      });
      flattenedPackageVersion._children = dependentPackageVersions;
    }
    return flattenedPackageVersion;
  }

  handleToggleChange(event) {
    this.showLoadingSpinner = true;
    const grid =  this.template.querySelector('lightning-tree-grid');
    grid.collapseAll();
    this.releasedOnly = event.target.checked;
  }

}