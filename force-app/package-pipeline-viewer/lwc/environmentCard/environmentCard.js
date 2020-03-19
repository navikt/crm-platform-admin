import { LightningElement, api } from "lwc";

export default class EnvironmentCard extends LightningElement {
  @api org;

  handleRefreshEnvironment(event) {
    this.dispatchEvent(new CustomEvent("refreshenvironment", {
      detail: this.org.Id
    }));
  }

  handleDeploy(evt) {
    const event = new CustomEvent('deployclicked', {
      detail: evt.detail
    });
    this.dispatchEvent(event);
  }


}