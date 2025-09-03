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
import getSstNfiltro from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getSst';
import getCarrier from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getCarrier';
import { refreshApex } from '@salesforce/apex';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getServiceLine from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getLineSp';
import getStatusClose from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getStatusClose';
import updateStatus from '@salesforce/apex/P2G_UpdateShipmentServiceLine.updateStatus';
//import getShipName from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getShipmentName';
import ChangeLine from '@salesforce/apex/P2G_UpdateShipmentServiceLine.ChangeLine';


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

    //chance
    @wire(getServiceLine, { Id: '$recordId' }, { cacheable: false })
    listCServiceLine;
    @track prueba;
    @track sideRecordsCCarrier;
    searchValueCCarrier = "";
    searchValueIdCCarrier ='';
    showSideCCarrier = false;

    @track sideRecordsCSstb;
    searchValueCSstb = "";
    searchValueIdCSstb ='';
    showSideCSstb = false;

    @track sideRecordsCSsts;
    searchValueCSsts = "";
    searchValueIdCSsts ='';
    showSideCSsts = false;

    @track showCAdvertencia;
    updateEsc = false;

    conCtenido='';
    rowIndex;
    deURL = false;

    connectedCallback() {
        console.log("Entra al connected", this.recordId);
        const urlParams = new URLSearchParams(window.location.search);
        const recordIdURL = urlParams.get('c__recordId');
        if (recordIdURL) {
            this.deURL = true;
            this.recordId= recordIdURL;
        }
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
    }


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
                    const updatedListServiceLine = [...this.listCServiceLine.data];
                    result.forEach(item => {
                        updatedListServiceLine.push(item);
                    });
                    this.listCServiceLine = { data: updatedListServiceLine };
                    for (let posicion in this.wrapper2){
                        const updatedlistLineQuote = this.listLineQuote.map( (item) => { 
                        if (item.Id === this.wrapper2[posicion].Id) { 
                            return {...item, Tarifario: true, };
                        } 
                        return item; }); // Actualiza la lista de service lines con los valores actualizados
                        this.listLineQuote = updatedlistLineQuote;
                    }
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
                    const updatedListServiceLine = [...this.listCServiceLine.data];
                    result.forEach(item => {
                        updatedListServiceLine.push(item);
                    });
                    this.listCServiceLine = { data: updatedListServiceLine };
                    this.RespuestaRateTarifario = result;
                    console.log('original: ',this.listCServiceLine.data[0]);
                    for (let i in this.RespuestaRateTarifario){
                         //
                         console.log('elemnto: ',result[0]);
                         //
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
            return {...item, SapServiceTypeBuyId : this.searchValueIdSstb, SapServiceTypeBuy : this.searchValueSstb};
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine; 
    }
    searchKeySstb(event){
        this.searchValueSstb = event.target.value;
        this.searchValueIdSstb='';
        if (this.searchValueSstb.length >= 3) {
            this.showSideSstb = true;
            this.showVistaSstb = true;
            getSstNfiltro({SapService: this.searchValueSstb, IdShip: this.recordId})
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
        if (typeof this.rateName === 'undefined' || this.rateName === null || (this.rateName && this.rateName.length === 0) || this.rateName === '') {
            this.pushMessage('Error','error', 'Se requiere Rate Name');
            return
        }
        createNewLine({data: this.vistaLine[0]})
        .then(result => {
            this.elemento = result;
            this.listServiceLine = Array.from(this.listServiceLine);
            this.listServiceLine.push(this.elemento);
            //
            const updatedListServiceLine = [...this.listCServiceLine.data];
            updatedListServiceLine.push(result); 
            this.listCServiceLine = { data: updatedListServiceLine };
            //
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
        }); // Actualiza la lista de service lines
        this.vistaLine = updateVistaLine;
    }
    saveSellPrice(event){
        this.sellPrice = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, SellRate: this.sellPrice, };
        }); // Actualiza la lista de service lines
        this.vistaLine = updateVistaLine;
    }
    saveBuyPrice(event){
        this.buyPrice = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, BuyRate : this.buyPrice, };
        }); // Actualiza la lista de service lines
        this.vistaLine = updateVistaLine;
    }
    //Guardar devolucion
    saveDevolucion(event){
        this.Devolucion = event.target.checked;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, Activo : this.Devolucion, };
        }); // Actualiza la lista de service lines
        this.vistaLine = updateVistaLine;
    }
    //Guardar comentario
    saveComentario(event){
        this.comentario = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, ShipmentBuyPrice : this.comentario, };
        }); // Actualiza la lista de service lines
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

    registroCurrency(event){
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, Moneda : event.target.value };
        }); // Actualiza la lista de service lines
        this.vistaLine = updateVistaLine;

        console.log('Registro: ',this.vistaLine);
    }

    //------------chance --------------
    searchKeyCCarrier(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;  
        const rowElement = event.target.closest('tr');
        const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
        this.rowIndex = rowIndex;
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            const itemToUpdate = updatedListServiceLine[indexToUpdate];
            const updatedItem = { ...itemToUpdate, listCarrier: true }; // Actualizar el valor de listCarrier a true
            updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };

        for (let posicion in this.listCServiceLine.data){ 
            if (this.listCServiceLine.data[posicion].Id === IdServiceLine) {
                this.searchValueCCarrier = event.target.value; 
                this.searchValueIdCCarrier='';
                this.showSideCCarrier = true;            
                if (this.searchValueCCarrier.length >= 3) {
                    getCarrier({carrier: this.searchValueCCarrier})
                        .then(result => {
                            this.sideRecordsCCarrier = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.sideRecordsCCarrier = null;
                        });
                }
                else{
                    this.showSideCCarrier = false;
                }
             }};
    }
    
    SideSelectCCarrier(event) {
        this.showSideCCarrier = false;
        const searchValueIdCarrier = event.currentTarget.dataset.id;

        //const IdServiceLine = event.target.closest('tr').dataset.id;
        const carrierName = event.target.closest('tr').querySelector('.slds-truncate:first-child').innerText;
        
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, CarrierName: carrierName , CarrierId:searchValueIdCarrier, listCarrier: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };
        this.searchValueCCarrier = carrierName;
    }

    closelistCCarrier(){
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, listCarrier: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };
        return refreshApex(this.listCServiceLine);
    }

    clearCCarrier(event){
        if (!event.target.value.length) {
            const rowElement = event.target.closest('tr');
            const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
            const indexToUpdate = rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
            const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
            if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            
                const itemToUpdate = updatedListServiceLine[indexToUpdate];
                const updatedItem = { ...itemToUpdate, CarrierName: null , CarrierId: null};
                updatedListServiceLine[indexToUpdate] = updatedItem;
            }      
            this.listCServiceLine = { data: updatedListServiceLine };
        }
    }
    
    searchKeyCSstb(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;  
        const rowElement = event.target.closest('tr');
        const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
        this.rowIndex = rowIndex;
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            const itemToUpdate = updatedListServiceLine[indexToUpdate];
            const updatedItem = { ...itemToUpdate, listSstb: true }; // Actualizar el valor de listCarrier a true
            updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };

        for (let posicion in this.listCServiceLine.data){ 
            if (this.listCServiceLine.data[posicion].Id === IdServiceLine) {
                this.searchValueCSstb = event.target.value; 
                this.searchValueIdCSstb='';
                this.showSideCSstb = true;            
                if (this.searchValueCSstb.length >= 3) {
                    getSstNfiltro({SapService: this.searchValueCSstb, IdShip: this.recordId})
                        .then(result => {
                            this.sideRecordsCSstb = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.sideRecordsCSstb = null;
                        });
                }
                else{
                    this.showSideCSstb = false;
                }
             }};
    }

    SideSelectCSstb(event) {
        this.showSideCSstb = false;
        const searchValueIdSstb = event.currentTarget.dataset.id;

        //const IdServiceLine = event.target.closest('tr').dataset.id;
        const SstbName = event.target.closest('tr').querySelector('.slds-truncate:first-child').innerText;
        
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, SapServiceTypeBuy: SstbName , SapServiceTypeBuyId:searchValueIdSstb, listSstb: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };
        this.searchValueCSstb = SstbName;
    }

    closelistCSstb(){
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, listSstb: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };
        return refreshApex(this.listCServiceLine);
    }

    clearCSstb(event){
        if (!event.target.value.length) {
            const rowElement = event.target.closest('tr');
            const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
            const indexToUpdate = rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
            const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
            if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            
                const itemToUpdate = updatedListServiceLine[indexToUpdate];
                const updatedItem = { ...itemToUpdate, SapServiceTypeBuy: null , SapServiceTypeBuyId: null};
                updatedListServiceLine[indexToUpdate] = updatedItem;
            }      
            this.listCServiceLine = { data: updatedListServiceLine };
        }
    }
    
    searchKeyCSsts(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;  
        const rowElement = event.target.closest('tr');
        //const rowKey = rowElement.getAttribute('key');
        const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
        this.rowIndex = rowIndex;
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            const itemToUpdate = updatedListServiceLine[indexToUpdate];
            const updatedItem = { ...itemToUpdate, listSsts: true }; // Actualizar el valor de listCarrier a true
            updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };

        for (let posicion in this.listCServiceLine.data){ 
            if (this.listCServiceLine.data[posicion].Id === IdServiceLine) {
                this.searchValueCSsts = event.target.value; 
                this.searchValueIdCSsts='';
                this.showSideCSsts = true;            
                if (this.searchValueCSsts.length >= 3) {
                    getSst({SapService: this.searchValueCSsts, IdShip: this.recordId})
                        .then(result => {
                            this.sideRecordsCSsts = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.sideRecordsCSsts = null;
                        });
                }
                else{
                    this.showSideCSstss = false;
                }
             }};
    }

    SideSelectCSsts(event) {
        this.showSideCSsts = false;
        const searchValueIdSsts = event.currentTarget.dataset.id;
        const SstsName = event.target.closest('tr').querySelector('.slds-truncate:first-child').innerText;
        
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, SapServiceType: SstsName , SapServiceTypeId:searchValueIdSsts, listSsts: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };
        this.searchValueCSsts = SstsName;
    }

    closelistCSsts(){
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listCServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, listSsts: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listCServiceLine = { data: updatedListServiceLine };
        return refreshApex(this.listCServiceLine);
    }
    
    ShipmentSellPrice(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;
        const SellPrice = event.target.value;
        const updatedListServiceLine = this.listCServiceLine.data.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, ShipmentSellPrice: SellPrice, };
            } 
            return item; });
            this.listCServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod: ', this.listCServiceLine);
    }
    
    ShipmentBuyPric(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;
        const BuyPrice = event.target.value;
        const updatedListServiceLine = this.listCServiceLine.data.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item,
                    ShipmentBuyPrice: BuyPrice,
                  };
            } 
            return item; });
            this.listCServiceLine = { data: updatedListServiceLine };
    }

    Change(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        const seModifica = event.target.checked;
        console.log('El valor del check es: ', seModifica);
        // Mapea la lista de service lines y actualiza el precio de venta en la fila correspondiente
        const updatedListServiceLine = this.listCServiceLine.data.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, seModifica: seModifica, };
            } 
            return item; }); // Actualiza la lista de service lines con los valores actualizados
            this.listCServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod: ', this.listCServiceLine);
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

    updateLines(){
        for (let posicion in this.listCServiceLine.data){
            if(this.listCServiceLine.data[posicion].seModifica === true){
                this.wrapper[posicion] = this.listCServiceLine.data[posicion];
                this.nWrapper = posicion++;
            }
          }
        this.conCtenido = JSON.stringify(this.wrapper);
        if(this.wrapper != {} && this.nWrapper>=0){
            ChangeLine({line: this.conCtenido, numLinea: this.nWrapper})
                .then(result => {
                    this.updateLine = result;                 
                    this.pushMessage('Exitoso!','success','Se actualizo con exito!');
                    //this.close();
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.updateLine = null;
                });
        }else{ this.pushMessage('Error','error', 'Seleccionar una service Line para modificar');}  
        return refreshApex(this.listCServiceLine);
    }
    
    abrirShipment(){
        //produccion https://pak2gologistics.lightning.force.com/lightning/r/Shipment__c/
        //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Shipment__c/
        const idShipment = this.recordId;
        console.log('el id es: ',this.recordId);
        this.ruta = "https://pak2gologistics.lightning.force.com/lightning/r/Shipment__c/"+idShipment+"/view";
        window.location = this.ruta;
    }
    abrirLinea(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        //produccion https://pak2gologistics.lightning.force.com/lightning/r/Shipment_Fee_Line__c/
        //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Shipment_Fee_Line__c/
        this.varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Shipment_Fee_Line__c/"+IdServiceLine+"/view";
        var win = window.open(this.varurl, '_blank');
        win.focus();
    }
}