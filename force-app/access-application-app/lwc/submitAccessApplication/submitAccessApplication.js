import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getPermissions from '@salesforce/apex/AccessApplicationController.getPermissions';
import {
    COLUMNS,
} from './data';

export default class SubmitAccessApplication extends LightningElement {

    @track data;
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


            let extensibleData = JSON.parse(JSON.stringify(result.data));
            extensibleData.forEach(function (element) {
                if (element.children && element.children.length > 0) {
                    element._children = element.children;
                }
            });

            console.log(extensibleData)

            this.data = extensibleData;
            this.loading = false;


        } else if (result.error) {

            this.error = true;
            this.loading = false;
            this.setError(result.error);
        }
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
