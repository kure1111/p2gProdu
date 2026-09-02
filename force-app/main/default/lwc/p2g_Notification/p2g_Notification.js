import { LightningElement, api, wire } from 'lwc';
import getSapResponse from '@salesforce/apex/P2G_Notification.getSapResponse';

export default class p2g_Notification extends LightningElement {
    //traer id del shipment actual @api
    @api recordId;
    response;
    responseUrl;
    error;
    
    @wire(getSapResponse, { recordId: '$recordId'})
    getResponse({data, error}) {
        if(data) {
            console.log('resultado', data);
            this.response = data;
            this.responseUrl = '/lightning/r/Response__c/' + data.Id + '/view';
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.response = undefined;
        }

    }
    get responseClass() {
        if (!this.response) {
            return 'response-box';
        }

        switch(this.response.Type__c) {
            case 'CONFIRM':
                return 'response-box success';

            case 'ERROR':
                return 'response-box error';

            default:
                return  'response-box';
        }
    }
}