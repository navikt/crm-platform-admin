import { LightningElement, track, wire } from 'lwc';
import getEnvironmentData from '@salesforce/apex/DevelopmentPipelineController.getEnvironmentData';
import refreshEnvironmentData from '@salesforce/apex/DevelopmentPipelineController.refreshInstalledPackageData';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DevelopmentPipeline extends NavigationMixin(LightningElement) {
    @track orgs;
    @track initialLoading = true;

    connectedCallback() {
        this.getEnvironmentData();
    }

    getEnvironmentData() {
        let _self = this;
        getEnvironmentData()
            .then((result) => {
                this.orgs = JSON.parse(JSON.stringify(result));
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(function () {
                _self.initialLoading = false;
            });
    }

    handleRefreshData(event) {
        let self = this;
        let orgId = event.detail;
        let orgToUpdate = this.orgs.filter((org) => org.Id == orgId)[0];
        orgToUpdate.loading = true;

        refreshEnvironmentData({ orgIds: [event.detail] })
            .then((result) => {
                self.getEnvironmentData();
                orgToUpdate.loading = false;
            })
            .catch((error) => {
                orgToUpdate.loading = false;
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'An error occured while querying installed packages',
                        message: 'Check the application debug logs for more info',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
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

    get showNoEnvironmentIllustration() {
        return !this.initialLoading && (!Array.isArray(this.orgs) || this.orgs.length === 0);
    }
}
