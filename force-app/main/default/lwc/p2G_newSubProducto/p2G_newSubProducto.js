import { LightningElement,track,wire,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getWrapper from '@salesforce/apex/P2G_crearSubProductos.getWrapper';
import getSubProductOppo from '@salesforce/apex/P2G_crearSubProductos.getSubProductOppo';
import getSubProductProduct from '@salesforce/apex/P2G_crearSubProductos.getSubProductProduct';
import infoProduct from '@salesforce/apex/P2G_crearSubProductos.infoProduct';
import getOppoProduct from '@salesforce/apex/P2G_crearSubProductos.getOppoProduct';
import getSapServiceType from '@salesforce/apex/P2G_crearSubProductos.getSapServiceType';
import crearSubProducto from '@salesforce/apex/P2G_crearSubProductos.crearSubProducto';

export default class P2G_newSubProducto extends LightningElement {
    produccion = false;
    @api recordId;
    @api objectApiName;
    wrapper;
    listSupProducto;
    listaProductos;
    infoProducto;
    subProductoCreado;
    esOportunidad;
    nuevoSubProducto = false;
    productos = false;
    formulario = false;
    isLoading = false;
    reefer = false;
    aereo = false;
    ce = false;
    idOppo;
    grupo;
    abrirSub;
    listRelated;
    buyPrice = 0;
    sellPrice = 0;
    @track selectedEscalaTemperatura;
    //para seleccionar SAP Service Type Sell
    @track sideRecordsSst;
    searchValueSst ='';
    searchValueIdSst ='';
    showSideSst = false;
    //para seleccionar SAP Service Type Buy
    @track sideRecordsSstBuy;
    searchValueSstBuy ='';
    searchValueIdSstBuy ='';
    showSideSstBuy = false;
//inicio
    connectedCallback() {
        this.initializeComponent();
        if(this.produccion === true){

        }else{
            this.abrirSub = 'https://pak2gologistics.lightning.force.com/lightning/r/SubProducto__c/';
            this.listRelated = 'https://pak2gologistics.lightning.force.com/lightning/r/';
            //this.abrirSub = 'https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/SubProducto__c/';
            //this.listRelated = 'https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/';
        }
    }
    initializeComponent(){
        console.log('el nombre api: '+this.objectApiName);
        getWrapper()
            .then(result => {
                this.wrapper = result;
            })
            .catch(error => {
                this.pushMessage('Error al cargar el wrapper','error', error.body.message);
            });
        if(this.objectApiName === 'Opportunity'){
            this.esOportunidad = true;
            getSubProductOppo({idOppo: this.recordId})
                .then(result => {
                    this.listSupProducto = result;
                })
                .catch(error => {
                    this.pushMessage('Error al cargar los subproductos','error', error.body.message);
                });
        }else{
            this.esOportunidad = false;
            getSubProductProduct({idProduct: this.recordId})
                .then(result => {
                    this.listSupProducto = result;
                })
                .catch(error => {
                    this.pushMessage('Error al cargar los subproductos','error', error.body.message);
                });
        }
    }
//para mensaje en pantalla
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
//valores Currency
    get optionsCurrency() {
        return [
            { label: 'MXN', value: 'MXN' },
            { label: 'EUR', value: 'EUR' },
            { label: 'USD', value: 'USD' },
        ];
    }
    valueCurrency = 'MXN';
    //metodo grupo
    tipogrupo(grupo){
        switch (grupo) {
            case 'SP-CE-COMERCIO EXT':
                this.ce = true;
                break;
            case 'SP-A-AEREO':
                this.aereo = true;
                break;
            default:
                // Tratar variantes desconocidas
                break;
        }
    }
//guardar valores
    // buscador SAP Service Type Sell
    SideSelectSst(event){
        this.searchValueIdSst = event.currentTarget.dataset.id;
        this.wrapper.idSapServiceType = event.currentTarget.dataset.id;
        this.searchValueSst = event.currentTarget.dataset.name;
        this.showSideSst = false;
    }
    searchKeySst(event){
        this.searchValueSst = event.target.value;
        this.searchValueIdSst='';
        if (this.searchValueSst.length >= 3) {
            this.showSideSst = true;
            getSapServiceType({sst: this.searchValueSst, idOppo: this.idOppo})
                .then(result => {
                    this.sideRecordsSst = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsSst = null;
                });
        }
        else{
            this.showSideSst = false;
        }
    }
    // buscador SAP Service Type Buy
    SideSelectSstBuy(event){
        this.searchValueIdSstBuy = event.currentTarget.dataset.id;
        this.wrapper.idSapServiceTypeBuy = event.currentTarget.dataset.id;
        this.searchValueSstBuy = event.currentTarget.dataset.name;
        this.showSideSstBuy = false;
    }
    searchKeySstBuy(event){
        this.searchValueSstBuy = event.target.value;
        this.searchValueIdSstBuy='';
        if (this.searchValueSstBuy.length >= 3) {
            this.showSideSstBuy = true;
            getSapServiceType({sst: this.searchValueSstBuy, idOppo: this.idOppo})
                .then(result => {
                    this.sideRecordsSstBuy = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsSstBuy = null;
                });
        }
        else{
            this.showSideSstBuy = false;
        }
    }
    //Escala de temperatura
    escalaTemperaturaOptions = [
        { label: '°C', value: '°C' },
        { label: '°F', value: '°F' }
    ];
    handleEscalaTemperaturaChange(event) {
        this.selectedEscalaTemperatura = event.detail.value;
        this.obj.escalaTemperatura = event.detail.value;
    }
    registroName(event){
        this.wrapper.name = event.target.value;
    }
    registroCurrency(event){
        this.valueCurrency = event.target.value;
    }
    registroBuyPrice(event){
        this.buyPrice = event.target.value;
    }
    registroSellPrice(event){
        this.sellPrice = event.target.value;
    }
    registroDetalles(event){
        this.wrapper.detalles = event.target.value;
    }
    handleItemHeightChange(event){
        this.wrapper.itemHeight = event.target.value;
    }
    handleItemWidthChange(event){
        this.wrapper.width = event.target.value;
    }
    handleItemLenghtChange(event){
        this.wrapper.lenght = event.target.value;
    }
    registroSeguroMercancia(event){
        this.wrapper.mercancia = event.target.value;
    }
    registroSeguroContenedor(event){
        this.wrapper.seguroContenedor = event.target.value;
    }
    registroTrasborda(event){
        this.wrapper.trasborda = event.target.checked;
    }
    registroHazmat(event){
        this.wrapper.hazmat = event.target.checked;
    }
    registroReefer(event){
        this.wrapper.reefer = event.target.checked;
        console.log('Valor reefer '+this.wrapper.reefer);
        if(this.wrapper.reefer === true){
            this.pushMessage('Advertencia','warning','Se requiere especificar la temperatura');
            this.reefer = true;
        }
    }
    registroTemperatura(event){
        this.wrapper.temperatura = event.target.value;
    }
    registroUnits(event){
        this.wrapper.units = event.target.value;
    }
    registroAsesoria(event){
        this.wrapper.asesoria = event.target.value;
    }
    registroDespacho(event){
        this.wrapper.despacho = event.target.value;
    }
    registroComercializadora(event){
        this.wrapper.comercializadora = event.target.value;
    }
//botones
    clicNew(){
        const event = new CustomEvent('newsubproducto', {
            detail: { message: 'New SubProducto clicked' }
        });
        this.dispatchEvent(event);
        this.nuevoSubProducto = true;
        if(this.objectApiName === 'Opportunity'){
            this.idOppo = this.recordId;
            getOppoProduct({idOppo: this.recordId})
                .then(result => {
                    this.listaProductos = result;
                    this.productos = true;
                })
                .catch(error => {
                    this.pushMessage('Error al cargar los productos','error', error.body.message);
                });
        }else{
            infoProduct({idProduct: this.recordId})
                .then(result => {
                    this.infoProducto = result;
                    this.wrapper.idOportunidad = this.infoProducto.OpportunityId;
                    this.idOppo = this.infoProducto.OpportunityId;
                    this.wrapper.idOpoProduct = this.recordId;
                    this.wrapper.grupo = this.infoProducto.Opportunity.Group__c;
                    this.grupo = this.infoProducto.Opportunity.Group__c;
                    this.tipogrupo(this.grupo);
                    this.formulario = true;
                })
                .catch(error => {
                    this.pushMessage('Error al cargar informacion del Producto','error', error.body.message);
                });
        }
    }
    clicAgregarSub(event){
        this.wrapper.idOpoProduct = event.currentTarget.dataset.id;
        console.log('se dio clic y el id product es: '+this.wrapper.idOpoProduct);
        this.wrapper.idOportunidad = this.recordId;
        infoProduct({idProduct: this.wrapper.idOpoProduct})
            .then(result => {
                this.infoProducto = result;
                this.grupo = this.infoProducto.Opportunity.Group__c;
                this.wrapper.grupo = this.infoProducto.Opportunity.Group__c;
                this.tipogrupo(this.grupo);
                this.productos = false;
                this.formulario = true;
            })
            .catch(error => {
                this.pushMessage('Error al cargar informacion de productos','error', error.body.message);
            });
    }
    clicCrearSub(){
        this.wrapper.tipoMoneda = this.valueCurrency;
        this.wrapper.currencyIsoCode = this.infoProducto.CurrencyIsoCode
        this.wrapper.buyPrice = this.buyPrice;
        this.wrapper.sellPrice = this.sellPrice;
        this.isLoading = true;
        crearSubProducto({wrapper: this.wrapper})
            .then(result => {
                this.subProductoCreado = result;
                if(this.subProductoCreado.error != 'Sin Error'){
                    this.isLoading = false;
                    this.pushMessage('Error al crear subProductos','error', this.subProductoCreado.error);
                }else{
                    this.isLoading = false;
                    this.nuevoSubProducto = false;
                    location.reload();
                    this.pushMessage('El subProductos se creo correctamente ','Success', this.subProductoCreado.error);
                }
            })
            .catch(error => {
                this.isLoading = false;
                this.pushMessage('Error al crear subProductos','error', error.body.message);
            });
    }
    clicAbrirSub(event){
        const idSub = event.target.dataset.id;
        console.log('id del subProductos '+ idSub);
        const varurl = this.abrirSub+idSub+"/view";
        window.open(varurl,"_self");
        //var win = window.open(this.varurl, '_blank');
        //win.focus();
    }
    clicViewAll(){
        const varurl = this.listRelated+this.objectApiName+"/"+this.recordId+"/related/SubProductos__r/view";
        console.log('view all '+ varurl);
        window.open(varurl,"_self");
    }
    Cerrar() {
        this.wrapper = null;
        //this.listaProductos = null;
        //this.infoProducto = null;
        //this.esOportunidad = null;
        this.nuevoSubProducto = false;
        this.productos = false;
        this.formulario = false;
        this.Reefer = false;
        this.aereo = false;
        this.ce = false;
        //this.idOppo = null;
        //this.grupo = null;
        this.searchValueSst ='';
        this.searchValueIdSst ='';
        this.searchValueSstBuy ='';
        this.searchValueIdSstBuy ='';
        this.sellPrice = 0;
        this.valueCurrency = 'MXN';
    }
}