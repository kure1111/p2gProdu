import { LightningElement, track } from 'lwc';
import LightningModal from 'lightning/modal';
import getWrapper from '@salesforce/apex/P2G_CreacionFoliosWrapper.getwrapper2';
import getCargolineWraper from '@salesforce/apex/P2G_CreacionFoliosWrapper.getCargoline2';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
import getSst from '@salesforce/apex/P2G_CreacionFoliosWrapper.getSapServiceType';
import getCustomer from '@salesforce/apex/P2G_CreacionCargoLines.getCustomerQuote';
import getCargoLine from '@salesforce/apex/P2G_creacionFolioInternacionales.getCargoLine';
import getServiceLine from '@salesforce/apex/P2G_creacionFolioWhAlmacenaje.getServiceLine';
import getFolios from '@salesforce/apex/P2G_creacionFolioInternacionales.getFolios';
import updatePrice from '@salesforce/apex/P2G_CreacionCargoLines.updatePrice';
import updatePriceList from '@salesforce/apex/P2G_CreacionCargoLines.updatePriceList';
import crearMasCargoLine from '@salesforce/apex/P2G_creacionFolioInternacionales.crearMasCargoLine';
import creaFolios from '@salesforce/apex/P2G_creacionFolioInternacionales.creaFolios';

export default class P2G_CreacionFoliosPaqueteria extends LightningModal {

    isProduccion = true;
    //Variables utilizadas
    @track wrapperFolio;
    @track wrapperCargoLine;
    @track folioCrado;
    @track cargoLineCrado;
    @track serviceLineCrado;
    @track idFolios;
    @track grupo = 'SP-PQ-PAQUETERIA';
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
    searchValueLoad ='ZM del Valle de Mexico';
    searchValueIdLoad ='';
    //para site dicharge
    searchValueDischarge ='Monterrey';
    searchValueIdDischarge ='';
    //valires fijos
    todoUno = '1';
    @track fijoEtd;
    @track fijoEta;
    cajaId;
    sobreId;

//Inicia cuando se abre el componente
    connectedCallback() {
        const today = new Date();
        const tomorrow = new Date();
        tomorrow.setDate(today.getDate() + 1);
        this.fijoEtd = today.toISOString().slice(0, 10);
        this.fijoEta = tomorrow.toISOString().slice(0, 10);
        console.log('que se envia fijo ',this.fijoEtd,' y ', this.fijoEta);
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
            this.searchValueIdLoad ='a034T00000C660xQAB';
            this.searchValueIdDischarge ='a034T000004F9RaQAK';
            this.cajaId = 'a3K4T000000Q8c5UAC';
            this.sobreId = 'a3K4T000000QBhHUAW';
        }else{
            this.url ="https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/";
            this.searchValueIdLoad ='a030R000008RxEyQAK';
            this.searchValueIdDischarge ='a034T000004F9RaQAK';
            this.cajaId = 'a3n0R000000EVywQAG';
            this.sobreId = 'a3n0R000000EZ81QAG';
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
    //valores Clave de Servicio
    get optionsClaveServicio() {
        return [
            { label: 'Caja', value: this.cajaId },
            { label: 'Sobres', value: this.sobreId },
        ];
    }
    valueClaveServicio = '';
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
    // buscador ClaveServicio
    registroClaveServicio(event){
        this.valueClaveServicio = event.target.value;
        this.wrapperCargoLine.idClaveSat = event.target.value;
        if(this.valueClaveServicio === 'a3K4T000000Q8c5UAC' || this.valueClaveServicio === 'a3n0R000000EVywQAG'){
            this.wrapperCargoLine.extencionItemName = 'Caja';
        }else if(this.valueClaveServicio === 'a3K4T000000QBhHUAW' || this.valueClaveServicio === 'a3n0R000000EZ81QAG'){
            this.wrapperCargoLine.extencionItemName = 'Sobres';
        }
    }
// guardar Registro
    //para folio
    numFoliosCrear(event){
        this.wrapperFolio.numFoliosCrear = event.target.value;
        this.numfolios = event.target.value;
    }
    registroCustomer(event){
        this.wrapperFolio.reference = event.target.value;
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
    registroCurrency(event){
        this.wrapperCargoLine.currencyIsoCode = event.target.value;
        this.valueCurrency = event.target.value;
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
        this.wrapperFolio.recordTypeUnidad = this.searchValueIdClaveUnidadPeso;
    }
    camposRequeridos(){
        const requiredFields = [
            this.searchValueIdAccount,
            this.searchValueIdSst,
            this.searchValueIdLoad,
            this.searchValueIdDischarge,
            this.valueClaveServicio,
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
        this.wrapperFolio.idSideLoad = this.searchValueIdLoad;
        this.wrapperFolio.idSideDischarged = this.searchValueIdDischarge;
        this.wrapperCargoLine.units = this.todoUno;
        this.wrapperCargoLine.pesoBruto = this.todoUno;
        this.wrapperCargoLine.pesoNeto = this.todoUno;
        this.wrapperCargoLine.totalShipping = this.todoUno;
        this.wrapperFolio.ETD = this.fijoEtd;
        this.wrapperFolio.ETA = this.fijoEta;
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
        this.ValueClaveServicio = '';
        this.wrapperCargoLine.description = null;
        this.wrapperCargoLine.units = 1;
        this.wrapperCargoLine.pesoBruto = 1;
        this.wrapperCargoLine.pesoNeto = 1;
        this.valueCurrency = 'MXN';
        this.wrapperCargoLine.totalShipping = 1;
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