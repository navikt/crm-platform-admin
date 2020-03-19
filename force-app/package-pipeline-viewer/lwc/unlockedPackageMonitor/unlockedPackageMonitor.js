import { LightningElement, track, wire } from "lwc";
import refreshOrg from "@salesforce/apex/DevopsDashboardController.refreshOrgs";
import getOrgs from "@salesforce/apex/DevopsDashboardController.getOrgs";
import { NavigationMixin } from 'lightning/navigation';



export default class UnlockedPackageMonitor extends NavigationMixin(LightningElement) {

  orgs;

  connectedCallback() {
    this.getOrgs();
  }

  getOrgs() {
    getOrgs().then(result => {
      console.log(result);
      this.orgs = JSON.parse(JSON.stringify(result));
    }).catch(error => {
      console.log(error);
    });
  }

  refreshOrg(event) {
    let self = this;
    let orgId = event.detail;
    let orgToUpdate = this.orgs.filter(org => org.Id == orgId)[0];
    orgToUpdate.loading = true;

    refreshOrg({orgIds: [event.detail]}).then(result => {
      self.getOrgs();
      orgToUpdate.loading = false;
    }).catch(error => {
      console.log(error);
    });
  }

  navigateToRecordViewPage(event) {
    console.log(event.target.dataset.orgid);
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: event.target.dataset.orgid,
        actionName: 'view'
      }
    });
  }

  handleDeploy(event) {
    let selectedInstalledPackage;

    this.orgs.forEach(org => {
      if(org.hasOwnProperty('UPM_InstalledPackages__r')) {
        org.UPM_InstalledPackages__r.forEach(installedPackage => {
          if(installedPackage.Id === event.detail) {
            selectedInstalledPackage = installedPackage;
          }
        })
      }
    });

    const modal = this.template.querySelector('c-modal');
    modal.show(selectedInstalledPackage);
  }

}