import { LightningElement,track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import getContainerType from '@salesforce/apex/P2G_CreacionCargoLines.getContainerType';
import getSapServiceType from '@salesforce/apex/p2g_Cotizador.getSapServiceType';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getWrapper from '@salesforce/apex/p2g_Cotizador.getWrapper';
import cotizador from '@salesforce/apex/p2g_Cotizador.Cotizador';
import crearEmbarque from '@salesforce/apex/p2g_Cotizador.crearEmbarque';
import codigoPostal from '@salesforce/apex/p2g_Cotizador.codigoPostal';
import updateCosto from '@salesforce/apex/p2g_Cotizador.updateCosto';
import correoCliente from '@salesforce/apex/P2G_callsCotizador.enviarArchivosPorCorreo';

export default class P2g_cotizador extends LightningElement {
    showSection1 = true;
    showSection2 = false;
    showSection3 = false;


//inicio
connectedCallback() {
    this.initializeComponent();
}
initializeComponent(){
    getWrapper()
        .then(result => {
            this.wrapper = result;
            this.error = false;
        })
        .catch(error => {
            this.pushMessage('Error al abrir el wrapper','error', error.body.message);
            this.showAdvertencia = true;                     
        });
}
//variables
wrapper;
returncotizador;
resultDevolucion;
resultEmbarque;
declinar = false;
aprobar = false;
sideclino = false;
pantallaresumen = false;
creoEmbarque = false;
conCuenta = false;
cotizarDisabled = false;
embarqueDisabled = false;

@track sideRecordsLoad;
searchValueLoad ='';
searchValueIdLoad ='';
showSideLoad = false;

@track sideRecordsDischarge;
searchValueDischarge ='';
searchValueIdDischarge ='';
showSideDischarge = false;

@track sideRecordsClaveServicio;
searchValueClaveServicio ='';
searchValueIdClaveServicio ='';
showSideClaveServicio = false;

@track sideRecordsContainerType;
searchValueContainerType ='';
searchValueIdContainerType ='';
showSideContainerType = false;

@track sideRecordsSST;
showSideSST = false;
searchValueSST ='SERVICIOS LOGISTICOS NACIONALES FN (IC) (FN)';
searchValueIdSST ='a1n4T000002JWphQAG';
searchValueSST ='';
searchValueIdSST ='';

@track sideRecordsCPFis;
searchValueCPFis ='';
searchValueIdCPFis ='';
showSideCPFis = false;

@track sideRecordsColoniaFis;
searchValueColoniaFis ='';
searchValueIdColoniaFis ='';
showSideColoniaFis = false;

@track sideRecordsCPOr;
searchValueCPOr ='';
searchValueIdCPOr ='';
showSideCPOr = false;

@track sideRecordsColoniaOr;
searchValueColoniaOr ='';
searchValueIdColoniaOr ='';
showSideColoniaOr = false;

@track sideRecordsCPDes;
searchValueCPDes ='';
searchValueIdCPDes ='';
showSideCPDes = false;

@track sideRecordsColoniaDes;
searchValueColoniaDes ='';
searchValueIdColoniaDes ='';
showSideColoniaDes = false;

tipodeServicio = '';
    get options() {
        return [
            { label: 'SP-FN-FLETE NACIONAL', value: 'SP-FN-FLETE NACIONAL' },
            { label: 'SP-FI-FLETE INTER', value: 'SP-FI-FLETE INTER' },
        ];
    }
    get optionBanco() {
        return [
            { label: 'ACCENDO BANCO', value: '1010' },
            { label: 'AFIRME', value: '0062' },
            { label: 'ANAHUAC', value: '0065' },
            { label: 'AZTECA', value: '0127' },
            { label: 'BANAMEX', value: '0002' },
            { label: 'BANCO BASE', value: '0145' },
            { label: 'BANCO DEL BAJIO', value: '0030' },
            { label: 'BANCO FAMSA', value: '0131' },
            { label: 'BANCOMEXT', value: '0006' },
            { label: 'BANCO MONEX', value: '0112' },
            { label: 'BANCOPPEL', value: '0137' },
            { label: 'BANCO PROMERICA', value: '1012' },
            { label: 'BANCREA', value: '1016' },
            { label: 'BANJERCITO', value: '0019' },
            { label: 'BANK OF AMERICA SA', value: '0003' },
            { label: 'BANOBRAS', value: '0009' },
            { label: 'BANORTE IXE', value: '0072' },
            { label: 'BANPAIS', value: '0071' },
            { label: 'BANREGIO', value: '0058' },
            { label: 'BANSI', value: '0060' },
            { label: 'BANXICO', value: '0001' },
            { label: 'BBVA BANCOMER', value: '0012' },
            { label: 'CIBANCO', value: '0143' },
            { label: 'HSBC', value: '0021' },
            { label: 'HSBC BANK USA', value: '1018' },
            { label: 'INBURSA', value: '0036' },
            { label: 'INTER BANCO', value: '0136' },
            { label: 'INTERCAM Banco', value: '1019' },
            { label: 'INVEX', value: '0059' },
            { label: 'IXE', value: '0032' },
            { label: 'JPMorgan SA México', value: '1013' },
            { label: 'MIFEL', value: '0042' },
            { label: 'MUFG BANK MEXICO, S.A.', value: '1014' },
            { label: 'MULTIVA', value: '0132' },
            { label: 'NULL', value: '1011' },
            { label: 'PROMEX', value: '0068' },
            { label: 'QUADRUM', value: '0056' },
            { label: 'SANTANDER', value: '0014' },
            { label: 'SCOTIABANK INVERLAT', value: '0044' },
            { label: 'STANDAR CHARTERED BANK', value: '1015' },
            { label: 'SUMITOMO MITSUI BANKING CORP', value: '1017' },
        ];
    }
pushMessage(title, variant, message){
    const event = new ShowToastEvent({
        title: title,
        variant: variant,
        message: message,
    });
    this.dispatchEvent(event);
}
//Botones
abrirSection1(){
    this.showSection1 = true;
    this.showSection2 = false;
    this.showSection3 = false;
    this.declinar = false;
    this.aprobar = false;
    this.sideclino = false;
    this.pantallaresumen = false;
    this.creoEmbarque = false;
    this.searchValueLoad ='';
    this.searchValueIdLoad ='';
    this.searchValueDischarge ='';
    this.searchValueIdDischarge ='';
    this.searchValueClaveServicio ='';
    this.searchValueIdClaveServicio ='';
    this.searchValueContainerType ='';
    this.searchValueIdContainerType ='';
    this.searchValueSST ='';
    this.searchValueIdSST ='';
    this.searchValueCPOr ='';
    this.searchValueIdCPOr ='';
    this.searchValueColoniaOr ='';
    this.searchValueIdColoniaOr ='';
    this.searchValueCPDes ='';
    this.searchValueIdCPDes ='';
    this.searchValueColoniaDes ='';
    this.searchValueIdColoniaDes ='';
    this.costoMenor = false;
    this.costoEntrada = 0;
    this.conCuenta = false;
    this.cotizarDisabled = false;
    this.embarqueDisabled = false;
}
abrirSection2(){
    this.cotizarDisabled = true;
    console.log('lo que se envia: ',this.wrapper);
    cotizador({cotizador: this.wrapper,ban: 1})
        .then(result => {
            this.returncotizador = result;
            console.log('el resultado de cotizacion: ',this.returncotizador);
            this.showSection1 = false;
            this.showSection2 = true;
        })
        .catch(error => {
            this.cotizarDisabled = false;
            this.pushMessage('Error','error', error.body.message);
            this.sideRecordsCustomer = null;
        });
}
resumenSection2(){
    this.showSection1 = false;
    this.showSection2 = true;
}
correoEnviado;
showAprobar(){
    if(this.returncotizador.conCuenta === true){
        this.conCuenta = true;
    }
    this.declinar = false;
    this.aprobar = true;
    this.showSection1 = false;
    this.showSection2 = false;
    this.showSection3 = true;
    correoCliente({correoDestino: this.returncotizador.emailCliente,recordId: this.returncotizador.quoteId})
    .then(result => {
        this.correoEnviado = result;
    })
    .catch(error => {
        this.pushMessage('Error','error', error.body.message);
        this.sideRecordsCustomer = null;
    });
}
showDeclinarAprova(){
    this.declinar = true;
    this.aprobar = false;
    this.pantallaresumen = false;
    this.showSection1 = false;
    this.showSection2 = false;
    this.showSection3 = true;
}
showDeclinar() {
    this.declinar = true;
    this.pantallaresumen = true;
    this.showSection1 = false;
    this.showSection2 = false;
    this.showSection3 = true;
}
get varRecordId() {
    return [{ name: 'recordId',
              type: 'SObject',
              value: this.returncotizador.quoteId}]}
closeUtilityBar() {
    // Cerrar el Utility Bar
    const utilityBarAPI = this.template.querySelector('lightning-utility-bar-api');
    utilityBarAPI.minimizeUtility();
}
abrirQuote(){
    //produccion https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/
    //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/
const idQuote = this.returncotizador.quoteId;
    console.log('el id es: ',this.returncotizador.quoteId);
    this.ruta = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+idQuote+"/view";
    var win = window.open(this.ruta, '_blank');
    win.focus();
}
abrirCuenta(){
    //produccion https://pak2gologistics.lightning.force.com/lightning/r/Account/
    //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Account/
    const Cuenta = this.resultEmbarque.cuentaId;
    console.log('el id es: ',this.resultEmbarque.cuentaId);
    this.ruta = "https://pak2gologistics.lightning.force.com/lightning/r/Account/"+Cuenta+"/view";
    var win = window.open(this.ruta, '_blank');
    win.focus();
}

generaEmbarque(){
    this.embarqueDisabled = true;
    crearEmbarque({cotizador: this.returncotizador})
        .then(result => {
            this.resultEmbarque = result;
            this.creoEmbarque = true;
            this.aprobar = false;
        })
        .catch(error => {
            this.embarqueDisabled = false;
            this.pushMessage('Error','error', error.body.message);
            this.sideRecordsContainerType = null;
        });
}
quotePDF(){
    //produccion
    //uat 
    const idQuote = this.returncotizador.quoteId;
    console.log('el id es: ',idQuote);
    this.ruta = "/apex/NEU_Import_Export_Quote_save_pdf?id="+idQuote;
    var win = window.open(this.ruta, '_blank');
    win.focus();
}
//parte 1 inicio
SaveNameCustomer(event){
    this.wrapper.nameCliente = event.target.value;
}
telefonoCustomer(event){
    this.wrapper.telefonoCliente = event.target.value;
}
emailCustomer(event){
    this.wrapper.emailCliente = event.target.value;
}
SideSelectSST(event){
    this.searchValueSST = event.target.outerText;
    this.showSideSST = false;
    this.searchValueIdSST = event.currentTarget.dataset.id;
    this.wrapper.sapServiceTypeName = event.target.outerText;
    this.wrapper.sapServiceType = event.currentTarget.dataset.id;
}
searchKeySST(event){
    this.searchValueSST = event.target.value;
    this.searchValueIdSST='';
    if (this.searchValueSST.length >= 3) {
        this.showSideSST = true;
        console.log('para sap service type: ',this.searchValueSST, 'tipoServicio:', this.tipodeServicio);
        getSapServiceType({SapService: this.searchValueSST, tipoServicio: this.tipodeServicio})
            .then(result => {
                this.sideRecordsSST = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsSST = null;
            });
    }
    else{
        this.showSideSST = false;
    }
}
SideSelectLoad(event){
    this.searchValueLoad = event.target.outerText;
    this.showSideLoad = false;
    this.searchValueIdLoad = event.currentTarget.dataset.id;
    this.wrapper.siteLoad = event.currentTarget.dataset.id;
    this.wrapper.siteLoadName = event.target.outerText;
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
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsLoad = null;
            });
    }
    else{
        this.showSideLoad = false;
    }
}
// buscador Site of Discharge
SideSelectDischarge(event){
    this.searchValueDischarge = event.target.outerText;
    this.showSideDischarge = false;
    this.searchValueIdDischarge = event.currentTarget.dataset.id;
    this.wrapper.siteDischargeName = event.target.outerText;
    this.wrapper.siteDischarge = event.currentTarget.dataset.id;
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
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsDischarge = null;
            });
    }
    else{
        this.showSideDischarge = false;
    }
}
// buscador ClaveServicio
SideSelectClaveServicio(event){
    this.searchValueClaveServicio = event.target.outerText;
    this.showSideClaveServicio = false;
    this.searchValueIdClaveServicio = event.currentTarget.dataset.id;
    this.wrapper.claveServicio = event.currentTarget.dataset.id;
    this.wrapper.claveServicioName = event.target.outerText;
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
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsClaveServicio = null;
            });
    }
    else{
        this.showSideClaveServicio = false;
    }
}
// buscador Container Type
SideSelectContainerType(event){
    this.searchValueContainerType = event.target.outerText;
    this.showSideContainerType = false;
    this.searchValueIdContainerType = event.currentTarget.dataset.id;
    this.wrapper.containerType = event.currentTarget.dataset.id;
    this.wrapper.containerTypeName = event.target.outerText;
}
searchKeyContainerType(event){
    this.searchValueContainerType = event.target.value;
    this.searchValueIdContainerType='';
    if (this.searchValueContainerType.length >= 3) {
        this.showSideContainerType = true;
        getContainerType({Container: this.searchValueContainerType})
            .then(result => {
                this.sideRecordsContainerType = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsContainerType = null;
            });
    }
    else{
        this.showSideContainerType = false;
    }
}
//parte 1 termina
//tipo de Servicio inicia
tipoServicio(event){
    this.tipodeServicio = event.detail.value;
    this.wrapper.tipoServicio = event.detail.value;
    console.log('tipo de servicio: '+this.tipodeServicio);
    
    if(this.tipodeServicio == 'SP-FN-FLETE NACIONAL'){
        this.searchValueSST ='SERVICIOS LOGISTICOS NACIONALES FN (IC) (FN)';
        this.searchValueIdSST ='a1n4T000002JWphQAG';
        this.wrapper.sapServiceTypeName = this.searchValueSST;
        this.wrapper.sapServiceType = this.searchValueIdSST;
    }else{
        this.searchValueSST ='';
        this.searchValueIdSST ='';
    }
}
//tipo de Servicio final
//carga embarque inicia
costoMenor = false;
updatecosto;
costoEntrada;
costo(event){
    this.costoEntrada = event.detail.value;
    //this.returncotizador.costo = event.detail.value;
    console.log('el costo entrada: ',this.costoEntrada,' costo: ',this.returncotizador.costo);
}
AgregarCosto(){
    console.log('el costo: ',this.costoEntrada,' el buy rate: ',this.returncotizador.buyRate);
    if( this.costoEntrada >= this.returncotizador.buyRate){
        console.log('entra en if');
        this.costoMenor = false;
        updateCosto({quoteId: this.returncotizador.quoteId, price: this.costoEntrada})
        .then(result => {
            this.updatecosto = result;
            this.precio = null;
            this.pushMessage('Exitoso!','success','Se actualizo el precio con exito!');
        })
        .catch(error => {
            this.pushMessage('Error','error', error.body.message);
            this.undatetarifario = null;
        });
    }else{
        console.log('entra en else');
        this.costoMenor = true;
        this.pushMessage('El costo esta por debajo del costo permitido','error', error.body.message);
    }
}
RFCCustomer(event){
    this.returncotizador.rfc = event.detail.value;
}
razonSocialCustomer(event){
    this.returncotizador.razonSocial = event.detail.value;
}
bancoSeleccionado(event){
    this.returncotizador.banco = event.detail.value;
}
numCuenta(event){
    this.returncotizador.numeroCuenta = event.detail.value;
}
calleFiscal(event){
    this.returncotizador.calleFiscal = event.detail.value;
}
interiorFiscal(event){
    this.returncotizador.interiorFiscal = event.detail.value;
}
exteriorFiscal(event){
    this.returncotizador.exteriorFiscal = event.detail.value;
}
SideSelectCPFis(event){
    this.searchValueCPFis = event.target.outerText;
    this.showSideCPFis = false;
    this.searchValueIdCPFis = event.currentTarget.dataset.id;
    this.returncotizador.cPFiscalId = event.currentTarget.dataset.id;
    this.returncotizador.cPFiscal = event.target.outerText;
    console.log('se guardo id cp Fis: ',this.searchValueIdCPFis,' name: ',this.searchValueCPFis);
}
searchKeyCPFis(event){
    this.searchValueCPFis = event.target.value;
    this.searchValueIdCPFis='';
    if (this.searchValueCPFis.length >= 3) {
        this.showSideCPFis = true;
        codigoPostal({search: this.searchValueCPFis, op: 1, Idcp: ''})
            .then(result => {
                this.sideRecordsCPFis = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsCPFis = null;
            });
    }
    else{
        this.showSideCPFis = false;
    }
}
SideSelectColoniaFis(event){
    this.searchValueColoniaFis = event.target.outerText;
    this.showSideColoniaFis = false;
    this.searchValueIdColoniaFis = event.currentTarget.dataset.id;
    this.returncotizador.coloniaFiscalId = event.currentTarget.dataset.id;
    this.returncotizador.coloniaFiscal = event.target.outerText;
    console.log('se guardo id colonia Fis: ',this.searchValueIdColoniaFis,' name: ',this.searchValueColoniaFis);
}
searchKeyColoniaFis(event){
    this.searchValueColoniaFis = event.target.value;
    this.searchValueIdColoniaFis='';
    if (this.searchValueColoniaFis.length >= 3) {
        this.showSideColoniaFis = true;
        console.log('lo que se envia: ',this.searchValueColoniaFis,' name: ',this.searchValueIdCPFis);
        codigoPostal({search: this.searchValueColoniaFis, op: 2, Idcp: this.searchValueIdCPFis})
            .then(result => {
                this.sideRecordsColoniaFis = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsColoniaFis = null;
            });
    }
    else{
        this.showSideColoniaFis = false;
    }
}
calleOrigen(event){
    this.returncotizador.calleOrigen = event.detail.value;
}
interiorOrigen(event){
    this.returncotizador.interiorOrigen = event.detail.value;
}
exteriorOrigen(event){
    this.returncotizador.exteriorOrigen = event.detail.value;
}
SideSelectCPOr(event){
    this.searchValueCPOr = event.target.outerText;
    this.showSideCPOr = false;
    this.searchValueIdCPOr = event.currentTarget.dataset.id;
    this.returncotizador.cPOrigenId = event.currentTarget.dataset.id;
    this.returncotizador.cPOrigen = event.target.outerText;
    console.log('se guardo id cp or: ',this.searchValueIdCPOr,' name: ',this.searchValueCPOr);
}
searchKeyCPOr(event){
    this.searchValueCPOr = event.target.value;
    this.searchValueIdCPOr='';
    if (this.searchValueCPOr.length >= 3) {
        this.showSideCPOr = true;
        codigoPostal({search: this.searchValueCPOr, op: 1, Idcp: ''})
            .then(result => {
                this.sideRecordsCPOr = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsCPOr = null;
            });
    }
    else{
        this.showSideCPOr = false;
    }
}
SideSelectColoniaOr(event){
    this.searchValueColoniaOr = event.target.outerText;
    this.showSideColoniaOr = false;
    this.searchValueIdColoniaOr = event.currentTarget.dataset.id;
    this.returncotizador.coloniaOrigenId = event.currentTarget.dataset.id;
    this.returncotizador.coloniaOrigen = event.target.outerText;
    console.log('se guardo id colonia or: ',this.searchValueIdColoniaOr,' name: ',this.searchValueColoniaOr);
}
searchKeyColoniaOr(event){
    this.searchValueColoniaOr = event.target.value;
    this.searchValueIdColoniaOr='';
    if (this.searchValueColoniaOr.length >= 3) {
        this.showSideColoniaOr = true;
        console.log('lo que se envia: ',this.searchValueColoniaOr,' name: ',this.searchValueIdCPOr);
        codigoPostal({search: this.searchValueColoniaOr, op: 2, Idcp: this.searchValueIdCPOr})
            .then(result => {
                this.sideRecordsColoniaOr = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsColoniaOr = null;
            });
    }
    else{
        this.showSideColoniaOr = false;
    }
}
calleDestino(event){
    this.returncotizador.calleDestino = event.detail.value;
}
interiorDestino(event){
    this.returncotizador.interiorDestino = event.detail.value;
}
exteriorDestino(event){
    this.returncotizador.exteriorDestino = event.detail.value;
}
SideSelectCPDes(event){
    this.searchValueCPDes = event.target.outerText;
    this.showSideCPDes = false;
    this.searchValueIdCPDes = event.currentTarget.dataset.id;
    this.returncotizador.cPDestinoId = event.currentTarget.dataset.id;
    this.returncotizador.cPDestino = event.target.outerText;
    console.log('se guardo id cp Des: ',this.searchValueIdCPDes,' name: ',this.searchValueCPDes);
}
searchKeyCPDes(event){
    this.searchValueCPDes = event.target.value;
    this.searchValueIdCPDes='';
    if (this.searchValueCPDes.length >= 3) {
        this.showSideCPDes = true;
        codigoPostal({search: this.searchValueCPDes, op: 1, Idcp: ''})
            .then(result => {
                this.sideRecordsCPDes = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsCPDes = null;
            });
    }
    else{
        this.showSideCPDes = false;
    }
}
SideSelectColoniaDes(event){
    this.searchValueColoniaDes = event.target.outerText;
    this.showSideColoniaDes = false;
    this.searchValueIdColoniaDes = event.currentTarget.dataset.id;
    this.returncotizador.coloniaDestinoId = event.currentTarget.dataset.id;
    this.returncotizador.coloniaDestino = event.target.outerText;
    console.log('se guardo id colonia Des: ',this.searchValueIdColoniaDes,' name: ',this.searchValueColoniaDes);
}
searchKeyColoniaDes(event){
    this.searchValueColoniaDes = event.target.value;
    this.searchValueIdColoniaDes='';
    if (this.searchValueColoniaDes.length >= 3) {
        this.showSideColoniaDes = true;
        console.log('lo que se envia: ',this.searchValueColoniaDes,' name: ',this.searchValueIdCPDes);
        codigoPostal({search: this.searchValueColoniaDes, op: 2, Idcp: this.searchValueIdCPDes})
            .then(result => {
                this.sideRecordsColoniaDes = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsColoniaDes = null;
            });
    }
    else{
        this.showSideColoniaDes = false;
    }
}
registroETD(event){
    this.returncotizador.etd = event.detail.value;
}
registroETA(event){
    this.returncotizador.eta = event.detail.value;
}
//carga embarque
}