import { LightningElement, track, wire } from "lwc";
import refreshOrg from "@salesforce/apex/DevopsDashboardController.refreshOrgs";
import getOrgs from "@salesforce/apex/DevopsDashboardController.getOrgs";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";


export default class UnlockedPackageMonitor extends NavigationMixin(LightningElement) {

  @track orgs;

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

    refreshOrg({ orgIds: [event.detail] }).then(result => {
      self.getOrgs();
      orgToUpdate.loading = false;
    }).catch(error => {
      orgToUpdate.loading = false;
      console.log(error);
      this.dispatchEvent(new ShowToastEvent({
        title: "An error occured while querying installed packages",
        message: "Check the application debug logs for more info",
        variant: "error",
        mode: "dismissable"
      }));
    });
  }

  navigateToRecordViewPage(event) {
    console.log(event.target.dataset.orgid);
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: event.target.dataset.orgid,
        actionName: "view"
      }
    });
  }

}