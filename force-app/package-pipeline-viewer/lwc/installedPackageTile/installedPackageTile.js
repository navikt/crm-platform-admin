import { LightningElement, api } from "lwc";

export default class InstalledPackageTile extends LightningElement {
  @api pckge;

  get deployAlternativeText() {
    if(!this.pckge.UnlockedPackage__r.GitHubRepositoryPath__c) {
      return 'No Github Repository defined for the unlocked package';
    } else {
      return 'Deploy package version';
    }
  }

  get deployDisabled() {
    if(!this.pckge.UnlockedPackage__r.GitHubRepositoryPath__c) {
      return true;
    } else {
      return false;
    }
  }

  handleClickDeploy(event) {
    this.dispatchEvent(new CustomEvent("deploy", {
      detail: this.pckge.Id
    }));
  }



}