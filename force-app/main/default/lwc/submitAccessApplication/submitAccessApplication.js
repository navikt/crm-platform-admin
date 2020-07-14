import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getPermissions from '@salesforce/apex/AccessApplicationController.getPermissions';
import {
    COLUMNS,
} from './data';

export default class SubmitAccessApplication extends LightningElement {

    @track data;
    @track dataObj;
    @track dataObjChildren;
    deWireResult;
    @track columns = COLUMNS;


    @track selectedRows = [];
    @track previouslySelectedRows = [];
    childIds = [];
    parentIds = [];

    @track error = false;
    @track loading = true;
    @track errorMsg;

    @track canChangeUser = true; // TODO implement check
    @track isButtonDisabled = true;

    @wire(getPermissions)
    deWire(result) {
        this.deWireResult = result;
        if (result.data) {

            this.dataObj = result.data;
            this.getDataFromResults(result.data);

            this.selectedRows = [...this.selectedRows];

            this.parentIds = this.setParentIds(result.data);
            this.childIds = this.setChildIds(result.data);

            this.loading = false;
        } else if (result.error) {
            this.error = true;
            this.loading = false;
            this.setError(result.error);
        }
    }

    setParentIds(data) { // TODO move to getDataFromResults
        var tmp = [];
        data.forEach(function (record) {
            tmp.push(record.id);
        });
        return tmp;
    }

    setChildIds(data) { // TODO move to getDataFromResults
        var tmp = [];
        data.forEach(function (record) {
            if (record.children) {
                record.children.forEach(function (childRecord) {
                    tmp.push(childRecord.id);
                });
            }
        });
        return tmp;
    }

    getDataFromResults(data) {

        let dataObjChildren = [];
        let extensibleData = JSON.parse(JSON.stringify(data));

        extensibleData.forEach(function (record) {
            if (record.children && record.children.length > 0) {
                record._children = record.children;

                record.children.forEach(function (child) {
                    dataObjChildren.push(child);
                });
            }
        });

        this.data = extensibleData;
        this.dataObjChildren = dataObjChildren;
    }

    updateSelectedRows() {

        var selectedRows = this.template.querySelector('lightning-tree-grid').getSelectedRows();

        if (selectedRows.length > 0) {
            var tmp = [];
            var tmpPrevious = this.previouslySelectedRows;

            var parentIds = this.parentIds;
            var childIds = this.childIds;

            // add all to list
            selectedRows.forEach(function (record) {
                tmp.push(record.id);
            });

            this.dataObj.forEach(function (record) {

                var recordChecked = tmp.includes(record.id) && !tmpPrevious.includes(record.id);
                var recordUnchecked = !tmp.includes(record.id) && tmpPrevious.includes(record.id);
                var hasChildren = record.children && record.children.length > 0;

                // check children
                if (recordChecked && hasChildren) {
                    record.children.forEach(function (item) {
                        tmp.push(item.id);
                    });
                }

                // uncheck children
                if (recordUnchecked && hasChildren) {
                    record.children.forEach(function (item) {
                        tmp.pop(item.id);
                    });
                }
            });

            // this.dataObjChildren.forEach(function (childRecord) {

            //     var recordChecked = tmp.includes(childRecord.id) && !tmpPrevious.includes(childRecord.id);
            //     var recordUnchecked = !tmp.includes(childRecord.id) && tmpPrevious.includes(childRecord.id);

            //     // cherck if child is unchecked
            //     if (recordUnchecked) {
            //         tmp.pop(childRecord.parentId);
            //     }
            // });

            this.selectedRows = tmp;
            this.previouslySelectedRows = tmp;
            // console.log(this.selectedRows);
        }
    }

    handleClick(event) {
        switch (event.target.name) {
            case "changeUser":
                break;
            case "cancel":
                break;
            case "apply":
                alert(this.selectedRows);
                break;
            default:
                break;
        }
    }

    changeUser() {

    }

    cancel() {

    }

    apply() {
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
