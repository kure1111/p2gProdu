import { LightningElement, track, wire ,api} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getShipmentFeeLines from '@salesforce/apex/P2G_Advertencia.getShipmentFeeLines';
import approveShipment from '@salesforce/apex/P2G_Advertencia.approveShipment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions'


export default class P2g_Aprobar extends LightningElement {
    @track recordId;
    @track data = [];
    motivo = '';
    spName = '';
    etd = '';
    operationExe = '';
    deApi = true;
    
    // Obtener el c__recordId de la URL utilizando @wire
    @wire(CurrentPageReference)
    wiredPageRef(pageRef) {
        if (pageRef && pageRef.state) {
            this.recordId = pageRef.state.recordId;
            if(this.recordId === undefined){
                this.recordId = pageRef.state.c__recordId;
                this.deApi = false;
            }
        }
        this.loadData(); // Llamar al método loadData después de que se establezca recordId
    }

    // Método para cargar los datos de la tabla
    loadData() {
        getShipmentFeeLines({ idShipment: this.recordId })
            .then(result => {
                this.data = result;
                this.motivo = result[0].motivo;
                this.spName = result[0].spName;
                this.etd = result[0].etd;
                this.operationExe = result[0].operationExe;
            })
            .catch(error => {
                this.showToast('Error Contacte al Administardor', error, 'error');
            });
    }

    handleApprove(event) {
        const actionLabel = event.target.label;
        let actionString;
    
        if (actionLabel === 'Aprobar') {
            actionString = 'Aprobada';
        } else if (actionLabel === 'Rechazar') {
            actionString = 'Rechazada';
        }
        approveShipment({ shipmentId: this.recordId, status: actionString })
            .then(result => {
                if(actionString == 'Aprobada'){
                    this.showToast('Aprobado', 'Status Actualizado a Aprovado', 'success');
                }
                else{
                    this.showToast('Rechazado', 'Status Actualizado a Rechazado', 'error');
                }
                
            })
            .catch(error => {
                this.showToast('Error Contacte al Administardor', 'Error en approveShipment', 'error');
            });
            if(this.deApi){
                this.dispatchEvent(new CloseActionScreenEvent());
            }
        
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

}