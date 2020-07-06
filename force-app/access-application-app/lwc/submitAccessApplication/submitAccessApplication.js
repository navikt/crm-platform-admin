import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getPermissions from '@salesforce/apex/AccessApplicationController.getPermissions';
import {
    COLUMNS,
} from './data';

export default class SubmitAccessApplication extends LightningElement {

    @track availablePermissions;
    @track permissionsInReview;
    @track assignedPermissions;

    @track columns = COLUMNS;
    deWireResult;

    @track error;
    @track loading;
    @track errorMsg;

    @wire(getPermissions)
    deWire(result) {
        this.deWireResult = result;
        console.log('result.data: ' + result.data);
        console.log('result.error: ' + result.error);
        if (result.data) {

            this.availablePermissions = this.dataFromResults(result.data.availablePermissions);
            this.permissionsInReview = this.dataFromResults(result.data.permissionsInReview);
            this.assignedPermissions = this.dataFromResults(result.data.assignedPermissions);
            this.loading = false;


        } else if (result.error) {

            this.error = true;
            this.loading = false;
            this.setError(result.error);
        }
    }

    dataFromResults(data) {
        let extensibleData = JSON.parse(JSON.stringify(data));
        extensibleData.forEach(function (element) {
            if (element.children && element.children.length > 0) {
                element._children = element.children;
            }
        });
        return extensibleData;
    }

    refreshData() {
        this.error = false;
        this.loading = true;
        return refreshApex(this.deWireResult).then(() => {
            this.loading = false;
        });
    }


    setError(error) {
        if (error.body && error.body.exceptionType && error.body.message) {
            this.errorMsg = `[ ${error.body.exceptionType} ] : ${error.body.message}`;
        } else if (error.body && error.body.message) {
            this.errorMsg = `${error.body.message}`;
        } else if (typeof error === String) {
            this.errorMsg = error;
        } else {
            this.errorMsg = JSON.stringify(error);
        }
    }

}
