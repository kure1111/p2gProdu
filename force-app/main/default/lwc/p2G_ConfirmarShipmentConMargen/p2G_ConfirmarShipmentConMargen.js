import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getShipment from '@salesforce/apex/P2G_ValidarMargenShipment.getShipment';

export default class P2G_ConfirmarShipmentConMargen extends LightningElement {
    @api recordId;
    @api message;
    @track shipActual;
    @track messageview = false;
    nombre = '';
    buyPrice = '';
    sellPrice = '';
    margen = '';

    connectedCallback() {
        this.recordId = this.message;
        console.log('respuesta2 ',this.message,this.recordId);
        getShipment({shipId: this.recordId})
            .then(result => {
                this.shipActual = result;
                console.log('respuesta ',this.shipActual.Total_Services_Std_Buy_Amount__c);
                this.llenardatos();
                this.messageview = true;
            })
            .catch(error => {
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })
                this.shipActual = null;
            });
    }
    llenardatos(){
        this.nombre = this.shipActual.Name;
        this.buyPrice = this.shipActual.Total_Services_Std_Buy_Amount__c;
        this.sellPrice = this.shipActual.Total_Services_Sell_Amount_number__c;
        this.margen = this.shipActual.Profit__c;
    }
    Cerrar(){
        this.message = false;
        const datoDevuelto = {
            seCerro : 'si',
            abrirComponente : false
        };
        const evento = new CustomEvent('resultados', {
            detail: datoDevuelto
        });
        this.dispatchEvent(evento);
    }
}