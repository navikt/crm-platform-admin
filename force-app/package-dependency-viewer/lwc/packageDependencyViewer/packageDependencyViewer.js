import { LightningElement, wire } from 'lwc';
import getPackageVersionsWithDependencies from '@salesforce/apex/PackageDependencyViewerController.getPackageDependencies';

const columns = [
    {
        type: 'text',
        fieldName: 'packageName',
        label: 'Package'
    },
    {
        type: 'text',
        fieldName: 'packageVersion',
        label: 'Version'
    },
    {
        type: 'text',
        fieldName: 'subscriberPackageVersionId',
        label: 'Version Id'
    }
];

export default class PackageDependencyViewer extends LightningElement {
    columns = columns;
    releasedOnly = true;
    packageDependencies;
    showLoadingSpinner;

    @wire(getPackageVersionsWithDependencies, {
        releasedVersionsOnly: '$releasedOnly'
    })
    wiredObjectPermissions({ error, data }) {
        this.showLoadingSpinner = true;

        if (data) {
            let extensibleData = JSON.parse(JSON.stringify(data));
            extensibleData.forEach(function (element) {
                if (element.dependencies && element.dependencies.length > 0) {
                    element._children = element.dependencies;
                }
            });

            this.packageDependencies = extensibleData;
            console.log(extensibleData);
            this.error = undefined;
            this.showLoadingSpinner = false;
        } else if (error) {
            this.error = error;
            this.packageDependencies = undefined;
            console.log(error);
            this.showLoadingSpinner = false;
        }
    }

    handleToggleChange(event) {
        this.showLoadingSpinner = true;
        const grid = this.template.querySelector('lightning-tree-grid');
        // grid.collapseAll();
        this.releasedOnly = event.target.checked;
    }
}
