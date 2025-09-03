import { LightningElement, track } from 'lwc';
import LightningModal from 'lightning/modal';
import getWrapper from '@salesforce/apex/P2G_CreacionFoliosWrapper.getwrapper2';
import getCargolineWraper from '@salesforce/apex/P2G_CreacionFoliosWrapper.getCargoline2';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
import getSst from '@salesforce/apex/P2G_CreacionFoliosWrapper.getSapServiceType';
import getCustomer from '@salesforce/apex/P2G_CreacionCargoLines.getCustomerQuote';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import getCargoLine from '@salesforce/apex/P2G_creacionFolioInternacionales.getCargoLine';
import getServiceLine from '@salesforce/apex/P2G_creacionFolioWhAlmacenaje.getServiceLine';
import getFolios from '@salesforce/apex/P2G_creacionFolioInternacionales.getFolios';
import updatePrice from '@salesforce/apex/P2G_CreacionCargoLines.updatePrice';
import updatePriceList from '@salesforce/apex/P2G_CreacionCargoLines.updatePriceList';
import crearMasCargoLine from '@salesforce/apex/P2G_creacionFolioInternacionales.crearMasCargoLine';
import creaFolios from '@salesforce/apex/P2G_creacionFolioInternacionales.creaFolios';

export default class P2G_creacionFolioGlobalAereo extends LightningModal {
    isProduccion = true;
    //Variables utilizadas
    @track wrapperFolio;
    @track wrapperCargoLine;
    @track folioCrado;
    @track cargoLineCrado;
    @track serviceLineCrado;
    @track idFolios;
    @track grupo = 'SP-AW-GLOBAL AEREO';
    @track numfolios = 1;
    formulario = true;
    resumen = false;
    newCargoLine = false;
    isLoading = false;
    serviceSi = false;
    esTarifario = false;
    customerId = false;
    @track undatetarifario;
    @track updatePriceList;
    @track creaCargoLine;
    precio;
    quoteSellPrice = 0;
    url;

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
                console.log('el wrapper folio es: '+ this.wrapperFolio);
            })
            .catch(error => {
                this.showToast('Error','error', error.body.message);
                this.wrapperFolio = error;
                console.log('el wrapper folio es: '+ this.wrapperFolio);
            });
        getCargolineWraper()
            .then(result => {
                this.wrapperCargoLine = result;
                console.log('el wrapper CargoLine es: '+ this.wrapperCargoLine);
            })
            .catch(error => {
                this.showToast('Error','error', error.body.message);
                this.wrapperCargoLine = error;
                console.log('el error es: '+ this.wrapperCargoLine);
            });
        if(this.isProduccion === true){
            this.url = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/";
        }else{
            this.url ="https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/";
        }
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
    valueTeam = 'WCA';
    //valores Currency
    get optionsCurrency() {
        return [
            { label: 'MXN', value: 'MXN' },
            { label: 'EUR', value: 'EUR' },
            { label: 'USD', value: 'USD' },
        ];
    }
    valueCurrency = 'MXN';
    //valores Service Mode
    get optionsServiceMode() {
        return [
            { label: 'EXPORT', value: 'EXPORT' },
        ];
    }
    valueServiceMode='EXPORT';
    //valores Service Type
    get optionsServiceType() {
        return [
            { label: 'PAQUETERIA', value: 'PAQUETERIA' },
            { label: 'CARGA', value: 'CARGA' },
            { label: 'ENVIO NACIONAL', value: 'ENVIO NACIONAL' },
        ];
    }
    valueServiceType='';
//Acciones de busqueda
    // buscador Account
    SideSelectAccount(event){
        this.searchValueIdAccount = event.currentTarget.dataset.id;
        this.wrapperFolio.idAccount = event.currentTarget.dataset.id;
        this.searchValueAccount = event.currentTarget.dataset.name;
        this.showSideAccount = false;
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
    // buscador ClaveServicio
    SideSelectClaveServicio(event){
        this.searchValueIdClaveServicio = event.currentTarget.dataset.id;
        this.wrapperCargoLine.idClaveSat = event.currentTarget.dataset.id;
        this.searchValueClaveServicio = event.currentTarget.dataset.name;
        this.wrapperCargoLine.extencionItemName = event.currentTarget.dataset.name;
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
        this.numfolios = event.target.value;
    }
    registroServiceType(event){
        this.wrapperFolio.servicetype = event.target.value;
        this.valueServiceType = event.target.value;
    }
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
        this.valueCurrency = event.target.value;
        this.wrapperCargoLine.currencyIsoCode = event.target.value;
    }
    registroTotalShippingVolume(event){
        this.wrapperCargoLine.totalShipping = event.target.value;
    }
    registroLength(event){
        this.wrapperCargoLine.length = event.target.value;
    }
    registroWidth(event){
        this.wrapperCargoLine.width = event.target.value;
    } 
    registroHeight(event){
        this.wrapperCargoLine.height = event.target.value;
    }
    registroWeight(event){
        this.wrapperCargoLine.weight = event.target.value;
    }
    RegistrItemPrice(event){
        this.precio = event.target.value;
        this.quoteSellPrice = event.target.value;
    }
//metodos
    llenaCamposFijos(){
        this.wrapperFolio.numFoliosCrear = this.numfolios;
        this.wrapperFolio.grupo = this.grupo;
        this.wrapperFolio.comercioExterior = this.valueCE;
        this.wrapperFolio.team = this.valueTeam;
        this.wrapperCargoLine.currencyIsoCode = this.valueCurrency;
        this.wrapperFolio.currencyIsoCode = this.valueCurrency;
    }
    camposRequeridos(){
        const requiredFields = [
            this.searchValueIdAccount,
            this.searchValueIdSst,
            this.searchValueIdLoad,
            this.searchValueIdDischarge,
            this.searchValueIdClaveServicio,
            this.wrapperFolio.ETD,
            this.wrapperFolio.ETA,
            this.wrapperCargoLine.units,
            this.wrapperCargoLine.pesoBruto,
            this.wrapperCargoLine.pesoNeto,
            this.wrapperCargoLine.totalShipping
        ];
        return requiredFields.every(field => field !== undefined && field !== '' && field !== null);
    }
//clic de botones
    //crear folios
    clicCrearFolio(){
        // revisa si todos los campos requerido estan llenos
        if (!this.camposRequeridos()) {
            this.showToast('Error','error', 'Favor de llenar todos los campos requeridos');
            return;
        }
        this.isLoading = true;
        this.llenaCamposFijos();
        console.log('el wrapperFolio '+this.wrapperFolio);
        console.log('el wrapperCargoLine '+this.wrapperCargoLine);
        creaFolios({flete: this.wrapperFolio, cargoLine: this.wrapperCargoLine})   
            .then(result => {
                this.folioCrado = result;
                console.log('el valor de error '+this.folioCrado[0].error);
                if(this.folioCrado[0].error != 'sin error'){
                    this.showToast('ERROR','error', this.folioCrado[0].error);
                    this.isLoading = false;
                }else{
                    console.log('el id del folio '+this.folioCrado[0].id);
                    getCargoLine({idQuote: this.folioCrado[0].id})
                        .then(result => {
                            this.cargoLineCrado = result;
                            console.log('el nombre del cargo line '+this.cargoLineCrado[0].Name);
                        })
                        .catch(error => {
                            this.showToast('Error','error', error.body.message);
                            this.cargoLineCrado = null;
                        });
                    getServiceLine({idQuote: this.folioCrado[0].id})
                        .then(result => {
                            this.serviceLineCrado = result;
                            this.serviceSi = true;
                            if(this.folioCrado[0].warehouseService === true){
                                this.esTarifario = true;
                                this.quoteSellPrice = serviceLineCrado.Sell_Rate__c;
                            }else{
                                this.esTarifario = false;
                            }
                            console.log('el nombre del serice line '+this.serviceLineCrado.Name+' rate '+this.serviceLineCrado.Service_Rate_Name__r.Name);
                        })
                        .catch(error => {
                            this.showToast('Error','error', error.body.message);
                            this.serviceLineCrado = null;
                        });
                    getFolios({listFlete: this.folioCrado})
                        .then(result => {
                            this.idFolios = result;
                            if (this.idFolios[0].Account_for__r.Customer_Id__c == null){
                                this.customerId = true;
                            }
                            console.log('los id de folios '+this.idFolios);
                        })
                        .catch(error => {
                            this.showToast('Error','error', error.body.message);
                            this.idFolios = null;
                        });
                        this.formulario = false;
                        this.isLoading = false;
                        this.resumen = true;
                }
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('ERROR','error', error.body.message);
                this.folioCrado = null;
            });
    }
    AgregarItemPrice(){
        if(this.esTarifario === true){
            updatePrice({listaFolio: this.idFolios, price: this.precio, sapType: this.searchValueSst})
                .then(result => {
                    this.undatetarifario = result;
                    this.precio = null;
                    this.showToast('Exitoso!','success','Se actualizo el precio con exito!');
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.undatetarifario = null;
                });
        }else{
            updatePriceList({listaFolio: this.idFolios, price: this.precio, sapType: this.searchValueSst})
                .then(result => {
                    this.updatePriceList = result;
                    this.precio = null;
                    this.showToast('Exitoso!', 'success', 'Se actualizo el precio con exito!');
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.updatePriceList = null;
                });
        }
    }
    abrirCargoLine(){
        this.resumen = false;
        this.newCargoLine = true;
        this.searchValueEmbalaje = null;
        this.searchValueMaterialPeligroso = null;
        this.searchValueClaveServicio = null;
        this.wrapperCargoLine.description = null;
        this.wrapperCargoLine.units = null;
        this.wrapperCargoLine.pesoBruto = null;
        this.wrapperCargoLine.pesoNeto = null;
        this.valueCurrency = 'MXN';
        this.wrapperCargoLine.totalShipping = null;
        this.wrapperCargoLine.length = null;
        this.wrapperCargoLine.width = null;
        this.wrapperCargoLine.height = null;
        this.wrapperCargoLine.weight = null;
    }
    agregarCargoLine(){
        this.isLoading = true;
        crearMasCargoLine({listaFolio: this.folioCrado, cargoLine: this.wrapperCargoLine})
        .then(result => {
            this.creaCargoLine = result;
            if(result!==null){
                this.cargoLineCrado.push(this.creaCargoLine);
                this.showToast('Exitoso!', 'success', 'Cargo line agregada con exito!');
                this.isLoading = false;
                this.newCargoLine = false;
                this.resumen = true;
            }
            else{
                this.showToast('Error', 'error', 'Error al Crear Cargo Line, Consulte a su Administrador');this.isLoading = false;
                this.isLoading = false;
            }
        })
        .catch(error => {
            this.showToast('Error','error', error.body.message);
            this.creaCargoLine = null;
            this.isLoading = false;
        });
    }
    Regresar(){
        this.resumen = true;
        this.newCargoLine = false;
    }
    abrirIdFolio;
    abrirFolio(event){
        this.abrirIdFolio = event.currentTarget.dataset.id;
        this.varurl = this.url+this.abrirIdFolio+"/view";
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