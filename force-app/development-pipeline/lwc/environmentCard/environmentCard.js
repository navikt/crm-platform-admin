import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class EnvironmentCard extends NavigationMixin(LightningElement) {
  @api org;

  handleRefreshEnvironment(event) {
    this.dispatchEvent(new CustomEvent("refreshenvironment", {
      detail: this.org.Id
    }));
  }

  navigateToRecordViewPage() {
    // View a custom object record.
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: this.org.Id,
        actionName: 'view'
      }
    });
  }


}