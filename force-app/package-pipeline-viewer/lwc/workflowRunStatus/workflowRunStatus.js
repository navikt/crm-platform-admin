import { LightningElement, api } from "lwc";

export default class WorkflowRunStatus extends LightningElement {
  @api workflowRun;

  get conclusion() {
    if (this.workflowRun.conclusion == null) {
      return 'unknown';
    } else {
      return this.workflowRun.conclusion;
    }
  }

  get ringValue() {
    if (this.workflowRun.conclusion == "failure") {
      return 100;
    } else if (this.workflowRun.conclusion == "success") {
      return 100;
    } else if (this.workflowRun.status == "queued") {
      return 10;
    } else if (this.workflowRun.status == "in_progress") {
      return 50;
    }
  }

  get ringVariant() {
    if (this.workflowRun.conclusion == "failure") {
      return "expired";
    } else if (this.workflowRun.conclusion == "success") {
      return "base-autocomplete";
    } else if (this.workflowRun.status == "queued") {
      return "active-step";
    } else if (this.workflowRun.status == "in_progress") {
      return "base";
    }
  }

}