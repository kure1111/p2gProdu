import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getShipment from '@salesforce/apex/P2G_ValidarMargenShipment.getShipment';

export default class P2G_ConfirmarShipmentConMargen extends LightningElement {
    @api recordId;
    @api message;
    @track shipActual;
    @track messageview = false;
    @track abrirAprobar = false;
    nombre = '';
    buyPrice = '';
    sellPrice = '';
    margen = '';
    @track data = [];
    motivo = '';
    spName = '';
    etd = '';
    operationExe = '';

    connectedCallback() {
        this.recordId = this.message;
        console.log('respuesta2 ',this.message,this.recordId);
        getShipment({shipId: this.recordId})
            .then(result => {
                this.shipActual = result;
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
    // Getter para formatear el valor
    get formattedSell() {
        return this.formatCurrency(this.sellPrice);
    }
    get formattedBuy() {
        return this.formatCurrency(this.buyPrice);
    }
    // Método para formatear a moneda
    formatCurrency(value) {
        const numberValue = Number(value) || 0;
    
        return new Intl.NumberFormat('es-MX', {
            style: 'currency',
            currency: 'MXN',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(numberValue);
    }
    llenardatos(){
        this.nombre = this.shipActual.Name;
        this.buyPrice = this.shipActual.Total_Services_Std_Buy_Amount__c;
        this.sellPrice = this.shipActual.Total_Services_Sell_Amount_number__c;
        this.margen = this.shipActual.Profit__c + '%';
    }
    Cerrar(){
        this.message = false;
        this.abrirAprobar = false;
        const datoDevuelto = {
            seCerro : 'si',
            abrirComponente : false,
        };
        const evento = new CustomEvent('resultados', {
            detail: datoDevuelto
        });
        this.dispatchEvent(evento);
    }
    abrirSP(){
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/Subproducto__c/${idProducto}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank');
    }
}