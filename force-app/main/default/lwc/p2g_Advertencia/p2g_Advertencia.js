import { LightningElement, wire, api, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateLogAprobacion from '@salesforce/apex/P2G_Advertencia.updateLogAprobacion';
import mostrarAdvertencia from '@salesforce/apex/P2G_Advertencia.mostrarAdvertencia';
import WARNING_FIELD from '@salesforce/schema/Shipment__c.LastModifiedDate';
import NAME_FIELD from '@salesforce/schema/Shipment__c.Name';

export default class P2g_Advertencia extends LightningElement {
    @api recordId; // Id del registro de Shipment__c proporcionado desde el componente padre
    @track lastModifiedDate;
    @track approvalReason = '';
    @track recordName;
    @track warningMessage2;
    @track showApprovalSection = false;
    @track datos;
    previousValue;

    @wire(getRecord, { recordId: '$recordId', fields: [WARNING_FIELD, NAME_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            const lastModifiedDateValue = getFieldValue(data, WARNING_FIELD);
            this.recordName = getFieldValue(data, NAME_FIELD);
            // Comprobamos si la fecha de modificación ha cambiado
            if (lastModifiedDateValue !== this.previousValue) {
                this.callMostrarAdvertencia();
            }
        } else if (error) {
            console.error('Error al cargar el registro:', error);
        }
    }

    handleReasonChange(event) {
        this.approvalReason = event.target.value;
    }

    handleApprove() {
        console.log('Motivo de aprobación:', this.approvalReason);
        updateLogAprobacion({ recordId: this.recordId, motivo: this.approvalReason })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Se ha enviado la solicitud',
                    variant: 'warning'
                }));
            })
            .catch(error => {
                // Muestra un mensaje de error si la actualización falla
                console.error('Error al enviar la solicitud de aprobación:', error);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error al enviar la solicitud',
                    message: error.body.message,
                    variant: 'error'
                }));
            });

        this.showApprovalSection = false;
    }

    callMostrarAdvertencia() {
        mostrarAdvertencia({ shipmentId: this.recordId })
            .then(result => {
                if (result && Object.keys(result).length > 0){
                    console.log('¡Si mostar solicitud!');
                    this.datos = result;
                    this.showApprovalSection = true;
                    this.warningMessage2 = true;

                } else {
                    console.log('Noooo mostar !');
                    this.showApprovalSection = false;
                    this.warningMessage2 = false;
                }
            })
            .catch(error => {
                console.error('Error al llamar a la función mostrarAdvertencia:', error);
            });
    }
}