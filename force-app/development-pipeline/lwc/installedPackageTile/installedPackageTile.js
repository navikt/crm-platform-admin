import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class InstalledPackageTile extends NavigationMixin(
    LightningElement
) {
    @api pckge;

    navigateToRecordViewPage() {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.pckge.Id,
                actionName: 'view'
            }
        });
    }

    get tileStyle() {
        return (
            'background-color: #' + this.pckge.UnlockedPackage__r.ColorCode__c
        );
    }
}
