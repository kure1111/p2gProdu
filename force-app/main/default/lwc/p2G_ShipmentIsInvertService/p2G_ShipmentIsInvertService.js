import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';


import updateFieldIsInverted from '@salesforce/apex/P2G_Validacion_Datos_CartaPorte.updateFieldIsInverted';

export default class ToggleDevolucionModal extends LightningElement {
    @api recordId;
    isProcessing = false;

    
    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    
    handleConfirm() {
    
        if (this.isProcessing) return;
        this.isProcessing = true;

    
        updateFieldIsInverted({ shipmentId: this.recordId })
            .then(() => {
                // Mostrar mensaje de éxito
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Éxito',
                        message: 'La información se ha invertido correctamente.',
                        variant: 'success',
                    })
                );

    
                getRecordNotifyChange([{ recordId: this.recordId }]);

    
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch((error) => {
    
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body?.message || 'Ocurrió un error inesperado.',
                        variant: 'error',
                    })
                );
                this.isProcessing = false; 
            });
    }
}