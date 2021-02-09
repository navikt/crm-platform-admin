import { LightningElement, track, wire } from 'lwc';
import getObjectPermissions from '@salesforce/apex/ObjectPermissionViewerController.getObjectPermissions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const OBJECT_PERMISSION_COLUMNS = [
    { label: 'Permission Set', fieldName: 'permissionSetLabel', type: 'text' },
    { label: 'Object', fieldName: 'sObjectType', type: 'text' },
    {
        label: 'Assigned Users',
        fieldName: 'assignedUserCount',
        type: 'number',
        cellAttributes: { alignment: 'left' }
    },
    {
        label: 'View All',
        fieldName: 'permissionViewAllRecords',
        type: 'boolean'
    },
    {
        label: '"View All" Violation',
        fieldName: 'permissionViewAllRecordsViolation',
        type: 'boolean'
    },
    {
        label: 'Modify All',
        fieldName: 'permissionModifyAllRecords',
        type: 'boolean'
    },
    {
        label: '"Modify All" Violation',
        fieldName: 'permissionModifyAllRecordsViolation',
        type: 'boolean'
    },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Show Assignment by Profile', name: 'show_details' }
            ],
            menuAlignment: 'auto'
        }
    }
];

const ASSIGNED_USER_PROFILES_COLUMNS = [
    { label: 'Profile', fieldName: 'profileName', type: 'text' },
    {
        label: 'Assigned Users',
        fieldName: 'assignedUserCount',
        type: 'number',
        cellAttributes: { alignment: 'left' }
    }
];

export default class ObjectPermissionViewer extends LightningElement {
    objectPermissionColumns = OBJECT_PERMISSION_COLUMNS;
    assignedUserProfilesColumns = ASSIGNED_USER_PROFILES_COLUMNS;
    objectPermissions;
    onlyCustomPermissionSets = true;
    error;
    assignedUserProfiles;
    actionRow;
    showObjectPermissionSpinner;

    @wire(getObjectPermissions, {
        onlyCustomPermissionSets: '$onlyCustomPermissionSets'
    })
    wiredObjectPermissions({ error, data }) {
        this.showObjectPermissionSpinner = true;
        if (data) {
            this.objectPermissions = data;
            this.error = undefined;
            this.showObjectPermissionSpinner = false;
        } else if (error) {
            this.error = error;
            this.objectPermissions = undefined;
            console.log(error);
            this.showObjectPermissionSpinner = false;
        }
    }

    handleToggleChange(event) {
        this.onlyCustomPermissionSets = event.target.checked;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'show_details':
                let assignedUserProfiles = this.objectPermissions.filter(
                    (op) => op.uniqueKey === row.uniqueKey
                )[0].assignedUserProfiles;
                if (assignedUserProfiles == null) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'No Permission Set Assignments Available',
                            message:
                                'This Permission Set is not currently assigned to users ',
                            variant: 'info',
                            mode: 'dismissable'
                        })
                    );
                } else {
                    this.assignedUserProfiles = assignedUserProfiles;
                    this.actionRow = row;
                }
        }
    }

    handleAssignedUserProfilesClose(event) {
        this.assignedUserProfiles = null;
    }

    get objectPermissionTableClass() {
        if (this.assignedUserProfiles) {
            return 'adaptive-height';
        } else {
            return 'full-height';
        }
    }

    get selectedPermissionSetName() {
        if (this.actionRow) {
            return this.actionRow.permissionSetLabel;
        }
    }
}
