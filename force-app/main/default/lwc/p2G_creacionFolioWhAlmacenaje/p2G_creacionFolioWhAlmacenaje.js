import { LightningElement,track,api } from 'lwc';
import LightningModal from 'lightning/modal';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
import getSst from '@salesforce/apex/P2G_CreacionFoliosWrapper.getSapServiceType';
import getWrapper from '@salesforce/apex/P2G_CreacionFoliosWrapper.getwrapper2';
import getCargolineWraper from '@salesforce/apex/P2G_CreacionFoliosWrapper.getCargoline2';
import getCustomer from '@salesforce/apex/P2G_CreacionCargoLines.getCustomerQuote';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getAccountAddress from '@salesforce/apex/P2G_CreacionCargoLines.getAccountAddress';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import creaFolios from '@salesforce/apex/P2G_creacionFolioWhAlmacenaje.creaFolios';
import getCargoLine from '@salesforce/apex/P2G_creacionFolioWhAlmacenaje.getCargoLine';
import getServiceLine from '@salesforce/apex/P2G_creacionFolioWhAlmacenaje.getServiceLine';

export default class P2G_creacionFolioWhAlmacenaje extends LightningModal {
//Variables utilizadas
    @track accountP2G = false;
    @track wrapperFolio;
    @track wrapperCargoLine;
    @track grupo = 'SP-WH-ALMACENAJE';
    @track numfolios = 1;
    @track folioCrado;
    formulario = true;
    resumen = false;
    isLoading = false;
    @track sstIdP2G = 'a1n4T000001XXYyQAO';//uat a1n0R000001lZdhQAE  Prod a1n4T000001XXYyQAO
    @track sstNameP2G = 'SERVICIOS DE ALMACENAJE (IC) (WH)';
    @track cargoLineCrado;
    @track cargoSi = false;
    @track serviceLineCrado;
    @track serviceSi = false;

//Variables para busqueda
    //para selecionar account
    @track sideRecordsAccount;
    searchValueAccount ='';
    searchValueIdAccount ='';
    showSideAccount = false;
    //para seleccionar SAP Service Type
    @track sideRecordsSst;
    searchValueSst ='';
    searchValueIdSst ='';
    showSideSst = false;
    //para costumer refereces
    @track sideRecordsCustomer;
    searchValueCustomer ='';
    searchValueIdCustomer ='';
    showSideCustomer = false;
    //para site load
    @track sideRecordsLoad;
    searchValueLoad ='';
    searchValueIdLoad ='';
    showSideLoad = false;
    //para site dicharge
    @track sideRecordsDischarge;
    searchValueDischarge ='';
    searchValueIdDischarge ='';
    showSideDischarge = false;
    //para account address origen
    @track sideRecordsAddressOrigen;
    searchValueAddressOrigen ='';
    searchValueIdAddressOrigen ='';
    showSideAddressOrigen = false;
    //para account address Destino
    @track sideRecordsAddressDestino;
    searchValueAddressDestino ='';
    searchValueIdAddressDestino ='';
    showSideAddressDestino = false;
    //para clave de servicio
    @track sideRecordsClaveServicio;
    searchValueClaveServicio ='';
    searchValueIdClaveServicio ='';
    showSideClaveServicio = false;
    //para material peligroso
    materialPeligroso = false;
    @track sideRecordsMaterialPeligroso;
    searchValueMaterialPeligroso ='';
    searchValueIdMaterialPeligroso ='';
    showSideMaterialPeligroso = false;
    //para embalaje
    @track sideRecordsEmbalaje;
    searchValueEmbalaje ='';
    searchValueIdEmbalaje ='';
    showSideEmbalaje = false;
    

//Inicia cuando se abre el componente
    connectedCallback() {
        this.initializeComponent();
    }
    initializeComponent(){
        getWrapper()
            .then(result => {
                this.wrapperFolio = result;
                console.log('el wrapper folio es: '+ result);
            })
            .catch(error => {
                this.showToast('Error','error', error.body.message);
                this.wrapperFolio = error;
                console.log('el wrapper folio es: '+ this.wrapperFolio);
            });
        getCargolineWraper()
            .then(result => {
                this.wrapperCargoLine = result;
            })
            .catch(error => {
                this.showToast('Error','error', error.body.message);
                this.wrapperCargoLine = error;
                console.log('el error es: '+ this.wrapperCargoLine);
            });
    }

// botones de opciones
    //valores Comercio Exterior
    get optionsCE() {
        return [
            { label: 'Si', value: 'Si' },
            { label: 'No', value: 'No' },
        ];
    }
    valueCE = 'No';
    //valores Team
    get optionsTeam() {
        return [
            { label: 'P2G', value: 'P2G' },
            { label: 'WCA', value: 'WCA' },
        ];
    }
    valueTeam = 'P2G';
    //valores Currency
    get optionsCurrency() {
        return [
            { label: 'MXN', value: 'MXN' },
            { label: 'EUR', value: 'EUR' },
            { label: 'USD', value: 'USD' },
        ];
    }
    valueCurrency = 'MXN';

//Acciones de busqueda
    // buscador Account
    SideSelectAccount(event){
        this.searchValueIdAccount = event.currentTarget.dataset.id;
        this.wrapperFolio.idAccount = event.currentTarget.dataset.id;
        this.searchValueAccount = event.currentTarget.dataset.name;
        this.showSideAccount = false;
        if(this.searchValueAccount === 'ALMACEN 2GO LOGISTIC CLIENTE'){
            this.searchValueIdSst = this.sstIdP2G;
            this.searchValueSst = this.sstNameP2G;
            this.wrapperCargoLine.idSST = this.sstIdP2G;
            this.accountP2G = true;
        }
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
    // buscador SAP Service Type
    SideSelectSst(event){
        this.searchValueIdSst = event.currentTarget.dataset.id;
        this.wrapperCargoLine.idSST = event.currentTarget.dataset.id;
        this.searchValueSst = event.currentTarget.dataset.name;
        this.showSideSst = false;
    }
    searchKeySst(event){
        this.searchValueSst = event.target.value;
        this.searchValueIdSst='';
        if (this.searchValueSst.length >= 3) {
            this.showSideSst = true;
            getSst({sapServiceT: this.searchValueSst, grupo: this.grupo})
                .then(result => {
                    this.sideRecordsSst = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsSst = null;
                });
        }
        else{
            this.showSideSst = false;
        }
    }
    // buscador Customer
    SideSelectCustomer(event){
        this.searchValueIdCustomer = event.currentTarget.dataset.id;
        this.wrapperFolio.idReferenceForm = event.currentTarget.dataset.id;
        this.searchValueCustomer = event.target.outerText;
        this.showSideCustomer = false;
    }
    searchKeyCustomer(event){
        this.searchValueCustomer = event.target.value;
        this.searchValueIdCustomer='';
        this.wrapperFolio.idReferenceForm = '';
        if (this.searchValueCustomer.length >= 3) {
            this.showSideCustomer = true;
            getCustomer({folio: this.searchValueCustomer,Customer: this.searchValueIdAccount})
                .then(result => {
                    this.sideRecordsCustomer = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsCustomer = null;
                });
        }
        else{
            this.showSideCustomer = false;
        }
    }
    // buscador Site of Load
    SideSelectLoad(event){
        this.searchValueIdLoad = event.currentTarget.dataset.id;
        this.wrapperFolio.idSideLoad = event.currentTarget.dataset.id;
        this.searchValueLoad = event.currentTarget.dataset.name;
        this.showSideLoad = false;
    }
    searchKeyLoad(event){
        this.searchValueLoad = event.target.value;
        this.searchValueIdLoad='';
        if (this.searchValueLoad.length >= 3) {
            this.showSideLoad = true;
            getSide({country: this.searchValueLoad})
                .then(result => {
                    this.sideRecordsLoad = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsLoad = null;
                });
        }
        else{
            this.showSideLoad = false;
        }
    }
    // buscador Site of Discharge
    SideSelectDischarge(event){
        this.searchValueIdDischarge = event.currentTarget.dataset.id;
        this.wrapperFolio.idSideDischarged = event.currentTarget.dataset.id;
        this.searchValueDischarge = event.currentTarget.dataset.name;
        this.showSideDischarge = false;
    }
    searchKeyDischarge(event){
        this.searchValueDischarge = event.target.value;
        this.searchValueIdDischarge='';
        if (this.searchValueDischarge.length >= 3) {
            this.showSideDischarge = true;
            getSide({country: this.searchValueDischarge})
                .then(result => {
                    this.sideRecordsDischarge = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsDischarge = null;
                });
        }
        else{
            this.showSideDischarge = false;
        }
    }
    // buscador Address Origen
    SideSelectAddressOrigen(event){
        this.searchValueIdAddressOrigen = event.currentTarget.dataset.id;
        this.wrapperFolio.AccountOriginAddress = event.currentTarget.dataset.id;
        this.searchValueAddressOrigen = event.currentTarget.dataset.name;
        this.showSideAddressOrigen = false;
    }
    searchKeyAddressOrigen(event){
        this.searchValueAddressOrigen = event.target.value;
        this.searchValueIdAddressOrigen='';
        if (this.searchValueAddressOrigen.length >= 3) {
            this.showSideAddressOrigen = true;
            getAccountAddress({address: this.searchValueAddressOrigen, account: this.searchValueIdAccount})
                .then(result => {
                    this.sideRecordsAddressOrigen = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsAddressOrigen = null;
                });
        }
        else{
            this.showSideAddressOrigen = false;
        }
    }
    // buscador Address Destino
    SideSelectAddressDestino(event){
        this.searchValueIdAddressDestino = event.currentTarget.dataset.id;
        this.wrapperFolio.AccountDestinAddress = event.currentTarget.dataset.id;
        this.searchValueAddressDestino = event.currentTarget.dataset.name;
        this.showSideAddressDestino = false;
    }
    searchKeyAddressDestino(event){
        this.searchValueAddressDestino = event.target.value;
        this.searchValueIdAddressDestino='';
        if (this.searchValueAddressDestino.length >= 3) {
            this.showSideAddressDestino = true;
            getAccountAddress({address: this.searchValueAddressDestino, account: this.searchValueIdAccount})
                .then(result => {
                    this.sideRecordsAddressDestino = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsAddressDestino = null;
                });
        }
        else{
            this.showSideAddressDestino = false;
        }
    }
    // buscador ClaveServicio
    SideSelectClaveServicio(event){
        this.searchValueIdClaveServicio = event.currentTarget.dataset.id;
        this.wrapperCargoLine.idClaveSat = event.currentTarget.dataset.id;
        this.searchValueClaveServicio = event.currentTarget.dataset.name;
        this.showSideClaveServicio = false;
        this.materialPeligroso = false;
        for (let i in this.sideRecordsClaveServicio){
            if(this.searchValueIdClaveServicio == this.sideRecordsClaveServicio[i].Id && this.sideRecordsClaveServicio[i].Material_PeligrosoCP__c === true){
                this.materialPeligroso = true;
                console.log('es un material peligroso '+this.sideRecordsClaveServicio[i].Material_PeligrosoCP__c);
            }
        }
    }
    searchKeyClaveServicio(event){
        this.searchValueClaveServicio = event.target.value;
        this.searchValueIdClaveServicio='';
        if (this.searchValueClaveServicio.length >= 3) {
            this.showSideClaveServicio = true;
            getClaveSAT({sat: this.searchValueClaveServicio,record: '1'})
                .then(result => {
                    this.sideRecordsClaveServicio = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsClaveServicio = null;
                });
        }
        else{
            this.showSideClaveServicio = false;
        }
    }
    // buscador Material Peligroso
    SideSelectMaterialPeligroso(event){
        this.searchValueIdMaterialPeligroso = event.currentTarget.dataset.id;
        this.wrapperCargoLine.MaterialPeligroso = event.currentTarget.dataset.id;
        this.searchValueMaterialPeligroso = event.currentTarget.dataset.name;
        this.showSideMaterialPeligroso = false;
    }
    searchKeyMaterialPeligroso(event){
        this.searchValueMaterialPeligroso = event.target.value;
        this.searchValueIdMaterialPeligroso='';
        if (this.searchValueMaterialPeligroso.length >= 3) {
            this.showSideMaterialPeligroso = true;
            getClaveSAT({sat: this.searchValueMaterialPeligroso,record: '2'})
                .then(result => {
                    this.sideRecordsMaterialPeligroso = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsMaterialPeligroso = null;
                });
        }
        else{
            this.showSideMaterialPeligroso = false;
        }
    }
    // buscador Embalaje
    SideSelectEmbalaje(event){
        this.searchValueIdEmbalaje = event.currentTarget.dataset.id;
        this.wrapperCargoLine.Embalaje = event.currentTarget.dataset.id;
        this.searchValueEmbalaje = event.currentTarget.dataset.name;
        this.showSideEmbalaje = false;
    }
    searchKeyEmbalaje(event){
        this.searchValueEmbalaje = event.target.value;
        this.searchValueIdEmbalaje='';
        if (this.searchValueEmbalaje.length >= 3) {
            this.showSideEmbalaje = true;
            getClaveSAT({sat: this.searchValueEmbalaje,record: '3'})
                .then(result => {
                    this.sideRecordsEmbalaje = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsEmbalaje = null;
                });
        }
        else{
            this.showSideEmbalaje = false;
        }
    }
// guardar Registro
    //para folio
    numFoliosCrear(event){
        this.wrapperFolio.numFoliosCrear = event.target.value;
    }
    customer;
    registroCustomer(event){
        this.wrapperFolio.reference = event.target.value;
    }
    registroETD(event){
        this.wrapperFolio.ETD = event.target.value;
    }
    registroETA(event){
        this.wrapperFolio.ETA = event.target.value;
    }
    registroloadtime(event){
        this.wrapperFolio.Awaitingloadtime = event.target.value;
    }
    registrounloadtime(event){
        this.wrapperFolio.Awaitingunloadtime = event.target.value;
    }
    //para cargo line
    registroDescripcionProducto(event){
        this.wrapperCargoLine.description = event.target.value;
    }
    registroUnits(event){
        this.wrapperCargoLine.units = event.target.value;
    }
    registroPesoBruto(event){
        this.wrapperCargoLine.pesoBruto = event.target.value;
    }
    registroPesoNeto(event){
        this.wrapperCargoLine.pesoNeto = event.target.value;
    } 
    registroCurrency(event){
        this.wrapperCargoLine.currencyIsoCode = event.target.value;
    }
    registroTotalShippingVolume(event){
        this.wrapperCargoLine.totalShipping = event.target.value;
    }
    registroBuyPrice(event){
        this.wrapperFolio.buyPrice = event.target.value;
    }
    registroSellPrice(event){
        this.wrapperFolio.sellPrice = event.target.value;
    }
//clic de botones
    //crear folios
    clicCrearFolio(){
        this.isLoading = true;
        console.log('si se dio clic');
        this.wrapperFolio.grupo = this.grupo;
        this.wrapperFolio.comercioExterior = this.valueCE;
        this.wrapperFolio.team = this.valueTeam;
        this.wrapperFolio.rurrencyIsoCode = this.valueCurrency;
        this.wrapperCargoLine.currencyIsoCode = this.valueCurrency;
        creaFolios({fleteNacional: this.wrapperFolio, cargoLine: this.wrapperCargoLine})   
            .then(result => {
                this.folioCrado = result;
                console.log('el valor de error '+this.folioCrado.error);
                if(this.folioCrado.error != 'sin error'){
                    this.showToast('ERROR','error', this.folioCrado.error);
                    this.isLoading = false;
                }else{
                    console.log('el id del folio '+this.folioCrado.id);
                    getCargoLine({idQuote: this.folioCrado.id})
                        .then(result => {
                            this.cargoLineCrado = result;
                            this.cargoSi = true;
                            console.log('el nombre del cargo line '+this.cargoLineCrado.Name);
                        })
                        .catch(error => {
                            this.showToast('Error','error', error.body.message);
                            this.cargoLineCrado = null;
                        });
                        getServiceLine({idQuote: this.folioCrado.id})
                        .then(result => {
                            this.serviceLineCrado = result;
                            this.serviceSi = true;
                            console.log('el nombre del serice line '+this.serviceLineCrado.Name+' rate '+this.serviceLineCrado.Service_Rate_Name__r.Name);
                        })
                        .catch(error => {
                            this.showToast('Error','error', error.body.message);
                            this.serviceLineCrado = null;
                        });
                        this.formulario = false;
                        this.isLoading = false;
                        this.resumen = true;
                }
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('ERROR','error', error.body.message);
                this.folioCrado = error;
            });
    }
    abrirFolio(){
        //produccion https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/
        //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/
        this.varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+this.folioCrado.id+"/view";
        var win = window.open(this.varurl, '_blank');
        win.focus();
    }
    // Cerrar
    clicCerrar(){
        this.close('close');
    }
// mensaje en pantalla
    showToast(title, variant, message) {
        switch (variant) {
            case 'success':
                this.showSuccess = true;
                this.successMessage = message;
                this.successClass = 'success-message';
                break;
            case 'warning':
                this.showWarning = true;
                this.warningMessage = message;
                this.warningClass = 'warning-message';
                break;
            case 'error':
                this.showError = true;
                this.errorMessage = message;
                this.errorClass = 'error-message';
                break;
            default:
                // Tratar variantes desconocidas
                break;
        }
   
        // Ocultar mensajes después de un tiempo determinado
        setTimeout(() => {
            this.showSuccess = this.showWarning = this.showError = false;
        }, 3500);
    }
    @track showWarning = false;
    @track warningMessage = '';
    @track warningClass = '';
    
    @track showSuccess = false;
    @track successMessage = '';
    @track successClass = '';
    
    @track showError = false;
    @track errorMessage = '';
    @track errorClass = '';
    
    closeMessage() {
        this.showSuccess = this.showWarning = this.showError = false;
    }
}