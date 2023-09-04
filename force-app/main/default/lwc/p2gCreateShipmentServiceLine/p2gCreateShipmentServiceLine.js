import { LightningElement,track,wire,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getlineShip from '@salesforce/apex/p2g_CreateServiceLineShipment.getLineShip';
import getLineQuote from '@salesforce/apex/p2g_CreateServiceLineShipment.getLineQuote';
import crealineQuote from '@salesforce/apex/p2g_CreateServiceLineShipmentSec2.CrearLineQuote';
import getRate from '@salesforce/apex/p2g_CreateServiceLineShipment.getRateTarifario';
import lineTarifario from '@salesforce/apex/p2g_CreateServiceLineShipment.CrearLineTarifario';
import getWrapper from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getwrapper';
import getCreaLine from '@salesforce/apex/p2g_CreateServiceLineShipment.getCreaLine';
//import wrapperNuevo from '@salesforce/apex/p2g_CreateServiceLineShipment.wrapper2';
import createNewLine from '@salesforce/apex/p2g_CreateServiceLineShipment.Create';//P2G_PruebaALbert
import getSst from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getSapServiceTypeShipment';
import getCarrier from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getCarrier';

export default class P2gCreateShipmentServiceLine extends LightningElement {
        
    @api recordId;
    activeSections = ['Seccion1', 'Seccion2', 'Seccion3', 'Seccion4'];
    @track listServiceLine;
    @track listLineQuote;
    @track listaRateTarifario;
    @track RespuestaLineQuote;
    @track RespuestaRateTarifario;
    @track createServiceLine;
    @track vistaLine;
    @track elemento;
    error;
    idString='';
    rateName;
    sellPrice;
    buyPrice;
    Devolucion;
    comentario;
    connectedCallback() {
        console.log("Entra al connected", this.recordId);
        this.initializeComponent();
    }
    initializeComponent(){
        getlineShip({Id: this.recordId})
            .then(result => {
                this.listServiceLine = result;
                console.log("lo que trae1: ",this.listServiceLine);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 1','error', error.body.message);
                this.showAdvertencia = true;                        
            });
        getLineQuote({Id: this.recordId})
            .then(result => {
                this.listLineQuote = result;
                console.log("lo que trae2: ",this.listLineQuote);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 2','error', error.body.message);
                this.showAdvertencia = true;                        
            });
        getRate({Id: this.recordId})
            .then(result => {
                this.listaRateTarifario = result;
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 3','error', error.body.message);
                this.showAdvertencia = true;                        
            });
        getCreaLine({Id: this.recordId})
            .then(result => {
                this.vistaLine = result;
                console.log("Entra al then4", this.vistaLine);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 4','error', error.body.message);
                this.vistaLine = null;
                console.log("Entra al carch", this.vistaLine);              
            });
        /*wrapperNuevo({idQuote: this.recordId})
            .then(result => {
                this.createServiceLine = result;
            })
            .catch(error => {
                this.pushMessage('Error en cargar wrapperNuevo','error', error.body.message);
                this.createServiceLine = null;
                console.log("Entra al carch", this.createServiceLine);              
            });*/
    }

    @track sideRecordsSsts;
    searchValueSsts ='';
    searchValueIdSsts ='';
    showSideSsts = false;
    showVistaSsts = false;
    @track sideRecordsCarrier;
    searchValueCarrier ='';
    searchValueIdCarrier ='';
    showSideCarrier = false;
    showVistaCarrier = false;
    @track sideRecordsSstb;
    searchValueSstb ='';
    searchValueIdSstb ='';
    showSideSstb = false;
    showVistaSstb = false;

    nWrapper=0;
    //para ver el message en pantalla
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
//Seccion 2 inicia
    //seleccion para crear Service Line con tatifario
    seleccionLinea(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        const seModifica = event.target.checked;
        console.log('El valor del check es: ', seModifica);
        // Mapea la lista de service lines y actualiza el precio de venta en la fila correspondiente
        const updatedlistLineQuote = this.listLineQuote.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, seModifica: seModifica, };
            } 
            return item; }); // Actualiza la lista de service lines con los valores actualizados
            this.listLineQuote = updatedlistLineQuote;
            console.log('la lista mod: ', this.listLineQuote);
        getWrapper() //abre el wrapper
            .then(result => {
                this.wrapper2 = result;
                console.log('Entra al wrapper2 sin problema',this.wrapper2);
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.wrapper2 = null;
            });
    }
    //Guardar devolucion
    guardaDevolucion(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        const Devolucion = event.target.checked;
        // Mapea la lista de service lines y actualiza el precio de venta en la fila correspondiente
        const updatedlistLineQuote = this.listLineQuote.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, Activo: Devolucion, };
            } 
            return item; }); // Actualiza la lista de service lines con los valores actualizados
            this.listLineQuote = updatedlistLineQuote;
            console.log('la lista mod: ', this.listLineQuote);
    }
    //Guardar comentario
    guardarComentario(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        const comentario = event.target.value;
        // Mapea la lista de service lines y actualiza el precio de venta en la fila correspondiente
        const updatedlistLineQuote = this.listLineQuote.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, ShipmentBuyPrice: comentario, };
            } 
            return item; }); // Actualiza la lista de service lines con los valores actualizados
            this.listLineQuote = updatedlistLineQuote;
            console.log('la lista mod: ', this.listLineQuote);
    }
    //crear Service line del Quote
    crearLinesQuote(){
        if(this.wrapper2 != {} && this.nWrapper >= 0){
            for (let posicion in this.listLineQuote){
                if(this.listLineQuote[posicion].seModifica === true){
                    this.wrapper2[posicion] = this.listLineQuote[posicion];
                    this.nWrapper = posicion++;
                }
            }
            this.contenido = JSON.stringify(this.wrapper2);
            console.log('El wrapper2 es',this.wrapper2,' en nwrapper: ',this.nWrapper);
            crealineQuote({line: this.contenido, numLinea: this.nWrapper})
                .then(result => {
                    this.RespuestaLineQuote = result;
                    //this.listServiceLine.push(this.RespuestaLineQuote);
                    for (let i in this.RespuestaLineQuote){
                        const ultimoElemento = this.RespuestaLineQuote[i];
                    this.listServiceLine = Array.from(this.listServiceLine);
                        this.listServiceLine.push(ultimoElemento);
                    }
                    for (let posicion in this.wrapper2){
                        const updatedlistLineQuote = this.listLineQuote.map( (item) => { 
                        if (item.Id === this.wrapper2[posicion].Id) { 
                            return {...item, Tarifario: true, };
                        } 
                        return item; }); // Actualiza la lista de service lines con los valores actualizados
                        this.listLineQuote = updatedlistLineQuote;
                        //this.listLineQuote = listLineQuote.splice(posicion,1); //para eliminar
                    }
                    console.log(this.listServiceLine);
                    console.log('Respuesta: ',this.RespuestaLineQuote);
                    //const ultimoElemento = result[result.length - 1];
                    //this.listServiceLine.push(ultimoElemento);
                    this.pushMessage('Exitoso!','success','Se actualizo con exito!');
                    this.nWrapper = 0;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.RespuestaLineQuote = null;
                });
        }else{ this.pushMessage('Error','error', 'Seleccionar una service Line para modificar');}
    }
//Seccion 2 termina
//Seccion 3 inicia
    //seleccion para crear Service Line con tatifario
    creaTarifario(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        const seModifica = event.target.checked;
        console.log('El valor del check es: ', seModifica);
        // Mapea la lista de service lines y actualiza el precio de venta en la fila correspondiente
        const updatedlistaRateTarifario = this.listaRateTarifario.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, seModifica: seModifica, };
            } 
            return item; }); // Actualiza la lista de service lines con los valores actualizados
            this.listaRateTarifario = updatedlistaRateTarifario;
            console.log('la lista mod: ', this.listaRateTarifario);
        getWrapper() //abre el wrapper
            .then(result => {
                this.wrapper = result;
                console.log('Entra al wrapper sin problema',this.wrapper);
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.wrapper = null;
            });
    }
    //crear Service line con tarifario
    crearLinesTarifario(){
        if(this.wrapper != {} && this.nWrapper>=0){
            for (let posicion in this.listaRateTarifario){
                if(this.listaRateTarifario[posicion].seModifica === true){
                    this.wrapper[posicion] = this.listaRateTarifario[posicion];
                    this.nWrapper = posicion++;
                }
            }
            this.contenido = JSON.stringify(this.wrapper);
            console.log('El wrapper es',this.wrapper);
            lineTarifario({line: this.contenido, numLinea: this.nWrapper})
                .then(result => {
                    this.RespuestaRateTarifario = result;
                    for (let i in this.RespuestaRateTarifario){
                        const ultimoElemento = this.RespuestaRateTarifario[i];
                        this.listServiceLine = Array.from(this.listServiceLine);
                        this.listServiceLine.push(ultimoElemento);
                    console.log('rate: ',this.listServiceLine);
                        const updatedlistaRateTarifario = this.listaRateTarifario.map( (item) => { 
                        if (item.Id === this.wrapper[i].Id) { 
                            return {...item, seModifica: false, };
                        } 
                        return item; }); // Actualiza la lista de service lines con los valores actualizados
                        this.listaRateTarifario = updatedlistaRateTarifario;
                    }
                    this.pushMessage('Exitoso!','success','Se actualizo con exito!');
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.RespuestaRateTarifario = null;
                }); 
        }else{ this.pushMessage('Error','error', 'Seleccionar una service Line para modificar');} 
    }
//Seccion 3 termina
//Seccion 4 Inicia
    //Seleccionar SAP Service Type Sell
    SideSelectSsts(event){
        this.showVistaSsts = false;
        this.searchValueSsts = event.currentTarget.outerText;
        this.showSideSsts = false;
        this.searchValueIdSsts = event.currentTarget.dataset.id;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, SapServiceTypeId : this.searchValueIdSsts, SapServiceType : this.searchValueSsts, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;  
    }
    searchKeySsts(event){
        this.searchValueSsts = event.target.value;
        this.searchValueIdSsts='';
        if (this.searchValueSsts.length >= 3) {
            this.showSideSsts = true;
            this.showVistaSsts = true;
            getSst({SapService: this.searchValueSsts, IdShip: this.recordId})
                .then(result => {
                    this.sideRecordsSsts = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsSsts = null;
                });
        }
        else{
            this.showSideSsts = false;
        }
    }
    closelistSsts(){
        this.showVistaSsts = false;
    }
    //Seleccionar Carrier
    SideSelectCarrier(event){
        this.showVistaCarrier = false;
        this.searchValueCarrier = event.currentTarget.outerText;
        this.showSideCarrier = false;
        this.searchValueIdCarrier = event.currentTarget.dataset.id;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, CarrierId : this.searchValueIdCarrier, CarrierName : this.searchValueCarrier, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine; 
    }
    searchKeyCarrier(event){
        this.searchValueCarrier = event.target.value;
        this.searchValueIdCarrier='';
        if (this.searchValueCarrier.length >= 3) {
            this.showSideCarrier = true;
            this.showVistaCarrier = true;
            getCarrier({carrier: this.searchValueCarrier})
                .then(result => {
                    this.sideRecordsCarrier = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsCarrier = null;
                });
        }
        else{
            this.showSideCarrier = false;
        }
    }
    closelistCarrier(){
        this.showVistaCarrier = false;
    }
    //Seleccionar SAP Service Type Buy
    SideSelectSstb(event){
        this.showVistaSstb = false;
        this.searchValueSstb = event.currentTarget.outerText;
        this.showSideSstb = false;
        this.searchValueIdSstb = event.currentTarget.dataset.id;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, SapServiceTypeBuyId : this.searchValueIdSstb, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine; 
    }
    searchKeySstb(event){
        this.searchValueSstb = event.target.value;
        this.searchValueIdSstb='';
        if (this.searchValueSstb.length >= 3) {
            this.showSideSstb = true;
            this.showVistaSstb = true;
            getSst({SapService: this.searchValueSstb, IdShip: this.recordId})
                .then(result => {
                    this.sideRecordsSstb = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsSstb = null;
                });
        }
        else{
            this.showSideSstb = false;
        }
    }
    closelistSstb(){
        this.showVistaSstb = false;
    }
    crearLines(){
        this.key=true;
        if (typeof this.rateName === 'undefined' || this.rateName === null || (this.rateName && this.rateName.length === 0)) {
            this.pushMessage('Error','error', 'Se requiere Rate Name');
            return
        }
        createNewLine({data: this.vistaLine[0]})
        .then(result => {
            this.elemento = result;
            this.listServiceLine = Array.from(this.listServiceLine);
            this.listServiceLine.push(this.elemento);
            this.pushMessage('Exitoso!','success','Se actualizo con exito!');
            this.searchValueSsts = null;
            this.searchValueCarrier = null;
            this.searchValueSstb = null;
            this.rateName = null;
            this.sellPrice = null;
            this.buyPrice = null;
            this.comentario = null;
            this.Devolucion = false;
        })
        .catch(error => {
            this.pushMessage('Error','error', error.body.message);
        });
        getCreaLine({Id: this.recordId})
            .then(result => {
                this.vistaLine = result;
                console.log("Entra al then4", this.vistaLine);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 4','error', error.body.message);
                this.vistaLine = null;
                console.log("Entra al carch", this.vistaLine);              
            });
    }
    saveName(event){
        this.rateName = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, ServiceRateName : this.rateName, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
    }
    saveSellPrice(event){
        this.sellPrice = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, SellRate: this.sellPrice, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
    }
    saveBuyPrice(event){
        this.buyPrice = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, BuyRate : this.buyPrice, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
    }
    //Guardar devolucion
    saveDevolucion(event){
        this.Devolucion = event.target.checked;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, Activo : this.Devolucion, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
    }
    //Guardar comentario
    saveComentario(event){
        this.comentario = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, ShipmentBuyPrice : this.comentario, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
    }
    abrirLinea(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        //produccion https://pak2gologistics.lightning.force.com/lightning/r/Shipment_Fee_Line__c/
        //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Shipment_Fee_Line__c/
        this.varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Shipment_Fee_Line__c/"+IdServiceLine+"/view";
        var win = window.open(this.varurl, '_blank');
        win.focus();
    }
    close() {
        const closeModalEvent = new CustomEvent("modalclose");
        this.dispatchEvent(closeModalEvent);
        location.reload();
    }
}