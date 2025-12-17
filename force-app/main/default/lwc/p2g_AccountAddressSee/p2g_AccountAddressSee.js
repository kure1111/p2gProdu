import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getAddressDetails from '@salesforce/apex/P2G_AlternativeAddress.getAddressDetails';
import updateDireccionAlternativa from '@salesforce/apex/P2G_AlternativeAddress.updateDireccionAlternativa';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Campos de Shipment__c
const SHIPMENT_FIELDS = [
    'Shipment__c.Account_Origin_Address__c',
    'Shipment__c.Account_Destination_Address__c',
    'Shipment__c.Direccion_Alternativa__c',
    'Shipment__c.Id'
];

export default class P2g_AccountAddressSee extends LightningElement {
    @api recordId;
    addresses = [];
    isLoading = true;
    error;
    originChecked = false;
    destinationChecked = false;
    isSaving = false;

    @wire(getRecord, { recordId: '$recordId', fields: SHIPMENT_FIELDS })
    wiredShipment({ error, data }) {
        if (data) {
            const originId = getFieldValue(data, SHIPMENT_FIELDS[0]);
            const destinationId = getFieldValue(data, SHIPMENT_FIELDS[1]);
            const direccionAlternativa = getFieldValue(data, SHIPMENT_FIELDS[2]);
            
            // Procesar el campo Direccion_Alternativa__c
            if (direccionAlternativa) {
                const valores = direccionAlternativa.split('|');
                this.originChecked = valores[0] === 'true';
                this.destinationChecked = valores[1] === 'true';
            }
            console.log('destinationId',destinationId);
            
            getAddressDetails({ originId: originId, destinationId: destinationId })
                .then(result => {
                    this.addresses = result;
                    console.log('Address ',this.addresses);
                    
                    this.isLoading = false;
                })
                .catch(error => {
                    this.error = error;
                    this.isLoading = false;
                });
        } else if (error) {
            this.error = error;
            this.isLoading = false;
        }
    }

    // Manejar cambio en checkbox de origen
    handleOriginChange(event) {
        this.originChecked = event.detail.checked;
    }

    // Manejar cambio en checkbox de destino
    handleDestinationChange(event) {
        this.destinationChecked = event.detail.checked;
    }

    // Manejar click en botón OK
    handleOkClick() {
        this.isSaving = true;
        
        // Crear el string en formato "true|false"
        const nuevoValor = `${this.originChecked}|${this.destinationChecked}`;
        
        updateDireccionAlternativa({
            shipmentId: this.recordId,
            nuevoValor: nuevoValor
        })
        .then(() => {
            this.showToast('Éxito', 'Dirección alternativa actualizada correctamente', 'success');
        })
        .catch(error => {
            console.error('Error al actualizar:', error);
            this.showToast('Error', 'No se pudo actualizar la dirección alternativa', 'error');
        })
        .finally(() => {
            this.isSaving = false;
        });
    }

    // Mostrar toast message
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    get origin() {
        return this.addresses[0] || {};
    }

    get destination() {
        return this.addresses[1] || {};
    }

    // Verificar si hay datos de origen
    get hasOriginData() {
        return this.origin && this.origin.calle;
    }

    // Verificar si hay datos de destino
    get hasDestinationData() {
        return this.destination && this.destination.calle;
    }

    // Verificar si al menos un checkbox está marcado
    get isOkButtonDisabled() {
        return this.isSaving || (!this.originChecked && !this.destinationChecked);
    }

    get errorMessage() {
        if (this.error && this.error.body) {
            return this.error.body.message;
        } else if (this.error) {
            return this.error.message;
        }
        return 'Error desconocido';
    }
}