import { LightningElement, track, wire ,api} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getShipmentFeeLines from '@salesforce/apex/P2G_Advertencia.getShipmentFeeLines';
import approveShipment from '@salesforce/apex/P2G_Advertencia.approveShipment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getShipmentFeeLinesMargen from '@salesforce/apex/P2G_ValidarMargenShipment.getShipmentFeeLines';
import { CloseActionScreenEvent } from 'lightning/actions'


export default class P2g_Aprobar extends LightningElement {
    //@track recordId;
    @track data = [];
    motivo = '';
    spName = '';
    etd = '';
    operationExe = '';
    totalBuy = '';
    totalSell = '';
    margen = '';
    deApi = true;
    @track messageApprove;
    @track approvalMargen = false;
    @api recordId
    /*
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
    }*/

    connectedCallback(){
        this.loadData();
    }

    

    // Método para cargar los datos de la tabla
    loadData() {
        getShipmentFeeLines({ idShipment: this.recordId })
            .then(result => {
                this.spName = result[0].spName;
                if(result[0].motivo === 'Solicitud de confirmación por Margen'){
                    console.log('el resultado', result);
                    getShipmentFeeLinesMargen({ idShipment: this.recordId })
                        .then(result2 => {
                                console.log('el resultado2', result2);
                                this.approvalMargen = true;
                                this.data = result2;
                                this.etd = this.data[0].etd;
                                this.operationExe = this.data[0].operationExe;
                                this.totalBuy = this.data[0].motivo;
                                this.totalSell = this.data[0].spName;
                                this.margen = this.data[0].BuyRateMax;
                        })
                        .catch(error => {
                            this.showToast('Error Contacte al Administardor', error, 'error');
                        });
                }else{
                    this.approvalMargen = false;
                    this.data = result;
                    this.motivo = result[0].motivo;
                    this.spName = result[0].spName;
                    this.etd = result[0].etd;
                    this.operationExe = result[0].operationExe;
                }
            })
            .catch(error => {
                this.showToast('Error Contacte al Administardor', error, 'error');
            });
    }

    handleApprove(event) {
        console.log(' this.recordId ', event.target.label);
        const actionLabel = event.target.label;
        let actionString;
    
        if (actionLabel === 'Aprobar') {
            actionString = 'Aprobada';
        } else if (actionLabel === 'Rechazar') {
            actionString = 'Rechazada';
        }
        approveShipment({ shipmentId: this.recordId, status: actionString })
            .then(result => {
                this.messageApprove = result;
                if(this.messageApprove === 'Todo bien'){
                    if(actionString == 'Aprobada'){
                        this.showToast('Aprobado', 'Status Actualizado a Aprovado', 'success');
                        location.reload();
                    }
                    else{
                        this.showToast('Rechazado', 'Status Actualizado a Rechazado', 'error');
                    }
                }else{
                    this.showToast('Alerta', this.messageApprove, 'error');
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