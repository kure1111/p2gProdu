import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProductosPendientes from '@salesforce/apex/P2G_reporteProductosOportunidad.getProducts';
import buscaProductosPendientes from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaProductosPendientes';
import buscaSubProductosPendientes from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaSubProductosPendientes';
import getAccountOptions from '@salesforce/apex/P2G_reporteProductosOportunidad.getAccountOptions';
import getOwnerOppoOptions from '@salesforce/apex/P2G_reporteProductosOportunidad.getOwnerOppoOptions';
import getIcOptions from '@salesforce/apex/P2G_reporteProductosOportunidad.getIcOptions';
import getSubProductos from '@salesforce/apex/P2G_reporteProductosOportunidad.getSubProductos';
import buscaProductosCotizados from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaProductosCotizados';
import buscaSubProductosCotizados from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaSubProductosCotizados';
import buscaProductosAceptados from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaProductosAceptados';
import buscaSubProductosAceptados from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaSubProductosAceptados';
import getServiceLineIEQO from '@salesforce/apex/P2G_reporteProductosOportunidad.getServiceLineIEQO';
import buscaIEQOPendientes from '@salesforce/apex/P2G_reporteProductosOportunidad.buscaIEQOPendientes';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
import getUser from '@salesforce/apex/P2G_reporteProductosOportunidad.getUser';

export default class P2G_ReporteProductosPendientesCotizar extends LightningElement {
    @track listaPendiente;
    @track listaSubproductos;
    @track listaIEQOPendiente;
    @track idProducto;
    @track url;
    @track paraGraficaPendientes;
    @track DataPendiente = [];
    @track optionsCuenta = [];
    @track optionsOwner = [];
    @track optionsIc = [];
    valueCuenta = '';
    valueStatus = '';
    valueOwnerOppo = '';
    valueUserIc = '';
    @track mostrarTodosCotizados = false;
    @track mostrarTodosAceptados = false;

    activeSections = ['Seccion1', 'Seccion2', 'Seccion3'];
    //evento
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
    connectedCallback() {
        this.agregarlistas();
    }
    agregarlistas(){
        getProductosPendientes()
            .then(result => {
                this.listaPendiente = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaPendiente = error;
            });
        getSubProductos()
            .then(result => {
                this.listaSubproductos = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaSubproductos = error;
            });
        getServiceLineIEQO()
                .then(result => {
                    this.listaIEQOPendiente = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listaIEQOPendiente = error;
                });
        getAccountOptions()
            .then(result => {
                this.optionsCuenta = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.optionsCuenta = error;
            });
        getOwnerOppoOptions()
            .then(result => {
                this.optionsOwner = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.optionsOwner = error;
            });
        getIcOptions()
            .then(result => {
                this.optionsIc = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.optionsIc = error;
            });
    }
    //valores status
    get optionsStatus() {
        return [
            { label: 'Pendiente por Cotizar', value: 'Pendiente por Cotizar' },
            { label: 'Cotizada', value: 'Cotizada' },
            { label: 'Aceptada', value: 'Aceptada' },
            { label: 'Negociación con cliente', value: 'Negociación con cliente' },
            { label: 'Rechazada', value: 'Rechazada' },
            { label: 'No Cotizada', value: 'No Cotizada' }
        ];
    }
    //valores Servicio
    get optionsServicio() {
        return [
            { label: 'FN - Flete Nacional', value: 'FN' },
            { label: 'FI - Flete Internacional', value: 'FI' },
            { label: 'A - Aereo', value: 'A' },
            { label: 'CE - Aduanas', value: 'CE - Aduanas' },
            { label: 'M - Maritimo', value: 'M' },
            { label: 'PTO - Puerto', value: 'PTO - Puerto' },
            { label: 'R - Global Routing', value: 'R - Global Routing' },
            { label: 'EX-Seguros', value: 'EX-Seguros' },
            { label: 'PQ - Paqueterias', value: 'PQ' },
            { label: 'T - Tarimas', value: 'T' },
            { label: 'WH - Almacenajes', value: 'WH' }
        ];
    }
    // buscador Account
    @track sideRecordsAccount;
    searchValueAccount ='';
    searchValueIdAccount ='';
    showSideAccount = false;
    SideSelectAccount(event){
        this.searchValueIdAccount = event.currentTarget.dataset.id;
        this.searchValueAccount = event.currentTarget.dataset.name;
        this.showSideAccount = false;
        this.valueCuenta = event.currentTarget.dataset.id;
        this.llamarfiltro();
    }
    searchKeyAccount(event){
        this.searchValueAccount = event.target.value;
        this.searchValueIdAccount='';
        if (this.searchValueAccount.length >= 3) {
            this.showSideAccount = true;
            getAccount({account: this.searchValueAccount})
                .then(result => {
                    this.sideRecordsAccount = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsAccount = null;
                });
        }
        else{
            this.showSideAccount = false;
        }
    }
    // buscador Owner
    @track sideRecordsOwner;
    searchValueOwner ='';
    searchValueIdOwner ='';
    showSideOwner = false;
    SideSelectOwner(event){
        this.searchValueIdOwner = event.currentTarget.dataset.id;
        this.searchValueOwner = event.currentTarget.dataset.name;
        this.showSideOwner = false;
        this.valueOwnerOppo = event.currentTarget.dataset.id;
        this.llamarfiltro();
    }
    searchKeyOwner(event){
        this.searchValueOwner = event.target.value;
        this.searchValueIdOwner='';
        if (this.searchValueOwner.length >= 3) {
            this.showSideOwner = true;
            getUser({name: this.searchValueOwner})
                .then(result => {
                    this.sideRecordsOwner = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsOwner = null;
                });
        }
        else{
            this.showSideOwner = false;
        }
    }
    // buscador UsuarioIc
    @track sideRecordsUsuarioIc;
    searchValueUsuarioIc ='';
    searchValueIdUsuarioIc ='';
    showSideUsuarioIc = false;
    SideSelectUsuarioIc(event){
        this.searchValueIdUsuarioIc = event.currentTarget.dataset.id;
        this.searchValueUsuarioIc = event.currentTarget.dataset.name;
        this.showSideUsuarioIc = false;
        this.valueUserIc = event.currentTarget.dataset.id;
        this.llamarfiltro();
    }
    searchKeyUsuarioIc(event){
        this.searchValueUsuarioIc = event.target.value;
        this.searchValueIdUsuarioIc='';
        if (this.searchValueUsuarioIc.length >= 3) {
            this.showSideUsuarioIc = true;
            getUser({name: this.searchValueUsuarioIc})
                .then(result => {
                    this.sideRecordsUsuarioIc = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsUsuarioIc = null;
                });
        }
        else{
            this.showSideUsuarioIc = false;
        }
    }
    valueServicio = '';
    agregarStatus(event){
        this.valueStatus = event.detail.value;
        this.llamarfiltro();
        if(this.valueStatus === 'Cotizada'){
            this.mostrarTodosCotizados = true;
            this.mostrarTodosAceptados = false;
        }else if(this.valueStatus === 'Aceptada'){
            this.mostrarTodosCotizados = false;
            this.mostrarTodosAceptados = true;
        }else{
            this.mostrarTodosCotizados = false;
            this.mostrarTodosAceptados = false;
        }
    }
    agregarServicio(event){
        this.valueServicio = event.detail.value;
        this.llamarfiltro();
    }
    agregarCliente(event){
        this.valueCuenta = event.detail.value;
        this.llamarfiltro();
    }
    agregarOwner(event){
        this.valueOwnerOppo = event.detail.value;
        this.llamarfiltro();
    }
    agregarUserIc(event){
        this.valueUserIc = event.detail.value;
        this.llamarfiltro();
    }
    llamarfiltro(){
        this.listaPendiente = null;
        this.listaSubproductos = null;
        this.listaIEQOPendiente = null;
        buscaProductosPendientes({status: this.valueStatus, servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
            .then(result => {
                this.listaPendiente = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaPendiente = error;
            });
        buscaSubProductosPendientes({status: this.valueStatus, servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
            .then(result => {
                this.listaSubproductos = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaSubproductos = error;
            });
        buscaIEQOPendientes({servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
            .then(result => {
                this.listaIEQOPendiente = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaIEQOPendiente = error;
            });
    }
    abrirProducto(event){
        const idProducto = event.currentTarget.dataset.id;
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/OpportunityLineItem/${idProducto}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank'); 
    }
    abrirOppo(event){
        const idOppo = event.currentTarget.dataset.id;
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/Opportunity/${idOppo}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank'); 
    }
    abrirSubProducto(event){
        const idProducto = event.currentTarget.dataset.id;
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/Subproducto__c/${idProducto}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank'); 
    }
    abrirServiceLine(event){
        const idSL = event.currentTarget.dataset.id;
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/Import_Export_Fee_Line__c/${idSL}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank'); 
    }
    abrirIEQO(event){
        const idIEQO = event.currentTarget.dataset.id;
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/Customer_Quote__c/${idIEQO}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank'); 
    }
    selectCotizados(event){
        const radio = event.target.checked;
        this.listaPendiente = null;
        this.listaSubproductos = null;
        if(radio === true){
            buscaProductosCotizados({status: this.valueStatus, servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
                .then(result => {
                    this.listaPendiente = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listaPendiente = error;
                });
            buscaSubProductosCotizados({status: this.valueStatus, servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
                .then(result => {
                    this.listaSubproductos = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listaSubproductos = error;
                });
        }else{    
            this.llamarfiltro();
        }
    }
    selectAceptados(event){
        const radio = event.target.checked;
        this.listaPendiente = null;
        this.listaSubproductos = null;
        if(radio === true){
            buscaProductosAceptados({status: this.valueStatus, servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
                .then(result => {
                    this.listaPendiente = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listaPendiente = error;
                });
            buscaSubProductosAceptados({status: this.valueStatus, servicio: this.valueServicio, ownerOppo: this.valueOwnerOppo, userIc: this.valueUserIc, cliente: this.valueCuenta})
                .then(result => {
                    this.listaSubproductos = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listaSubproductos = error;
                });
        }else{    
            this.llamarfiltro();
        }
    }
    clicLimpioFiltro(){
        this.listaPendiente = null;
        this.listaSubproductos = null;
        this.listaIEQOPendiente = null;
        this.valueCuenta = '';
        this.valueStatus = '';
        this.valueOwnerOppo = '';
        this.valueUserIc = '';
        this.valueServicio = '';
        this.searchValueIdAccount = '';
        this.searchValueAccount = '';
        this.searchValueIdOwner = '';
        this.searchValueOwner = '';
        this.searchValueIdUsuarioIc = '';
        this.searchValueUsuarioIc = '';
        this.mostrarTodosCotizados = false;
        this.mostrarTodosAceptados = false;
        this.agregarlistas();
        getProductosPendientes()
            .then(result => {
                this.listaPendiente = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaPendiente = error;
            });
        getSubProductos()
            .then(result => {
                this.listaSubproductos = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaSubproductos = error;
            });
        getServiceLineIEQO()
            .then(result => {
                this.listaIEQOPendiente = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaIEQOPendiente = error;
            });
    }
}