import { LightningElement, api } from "lwc";
import getPackage from "@salesforce/apex/DeploymentModalController.getPackage";
import getWorkflow from "@salesforce/apex/DeploymentModalController.getDefaultWorkflow";
import dispatchWorkflow from "@salesforce/apex/DeploymentModalController.dispatchWorkflow";
import getWorkflowRuns from "@salesforce/apex/DeploymentModalController.getWorkflowRuns";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

// import getWorkflowRunStatus from "@salesforce/apex/DeploymentModalController.getWorkflowRunStatus";


export default class Modal extends LightningElement {
  showModal = false;
  selectedInstalledPackage;
  selectedPackage;
  githubWorkflow;
  githubWorkflowRuns;
  deployStep;
  secondsCounter;
  loadingWorkflowRuns = false;

  getWorkflowError;

  pollWorkflowRuns() {
    let self = this;
    let pollEveryNSeconds = 30;
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    let timeoutRef = setInterval(function() {
      pollEveryNSeconds--;
      self.secondsCounter = pollEveryNSeconds;
      if (pollEveryNSeconds === 0) {
        clearInterval(timeoutRef);
        self.getWorkflowRuns();
      }
    }, 1000);
  }

  @api show(selectedInstalledPackage) {
    this.selectedInstalledPackage = selectedInstalledPackage;
    this.getPackageInfo();
    this.showModal = true;
  }

  @api hide() {
    this.showModal = false;
  }

  handleClose() {
    // const closedialog = new CustomEvent("closedialog");
    // this.dispatchEvent(closedialog);
    this.hide();

  }

  handleDeploy() {
    const closedialog = new CustomEvent("deploydialog");
    this.dispatchEvent(closedialog);
    // this.hide();
    this.deployStep = true;
    this.dispatchWorkflow();
    this.loadingWorkflowRuns = true;

    // Give Github time to queue the workflow run
    self = this;
    setTimeout(function() {
      self.getWorkflowRuns();
    }, 5000);

  }

  getPackageInfo() {
    getPackage({ unlockedPackageId: this.selectedInstalledPackage.UnlockedPackage__c }).then(result => {
      console.log("getPackageInfo result:");
      console.log(result);
      this.selectedPackage = result;
      console.log("calling getWorkflowInfo from getPackageInfo:");
      this.getWorkflowInfo();
    }).catch(error => {
      console.log(error);
    });
  }

  getWorkflowInfo() {
    getWorkflow({ packageRepositoryURL: this.selectedPackage.GitHubRepositoryPath__c }).then(result => {
      this.githubWorkflow = result;
      console.log("getWorkflowInfo result:");
      console.log(this.githubWorkflow);
    }).catch(error => {
      this.showModal = false;
      let errorMessage = "An error has occured";
      if (error.body.message) {
        errorMessage = error.body.message;
      }
      this.showToast('Eror', errorMessage, 'error');
    });
  }

  showToast(theTitle, theMessage, theVariant) {
    const event = new ShowToastEvent({
      title: theTitle,
      message: theMessage,
      variant: theVariant
    });
    this.dispatchEvent(event);
  }


  dispatchWorkflow() {
    dispatchWorkflow({ workflowId: this.githubWorkflow.id }).then(result => {
      console.log("dispatchWorkflow result (null if success)");
    }).catch(error => {
      console.log(error);
    });
  }


  getWorkflowRuns() {
    this.loadingWorkflowRuns = true;
    getWorkflowRuns({ workflowId: this.githubWorkflow.id }).then(result => {
      this.githubWorkflowRuns = result;

      let incompleteWorkflowruns = result.filter(res => res.conclusion == null);
      if (incompleteWorkflowruns.length > 0) {
        this.pollWorkflowRuns();
      }
      this.loadingWorkflowRuns = false;

    }).catch(error => {
      console.log(error);
      this.loadingWorkflowRuns = false;
    });
  }

}
