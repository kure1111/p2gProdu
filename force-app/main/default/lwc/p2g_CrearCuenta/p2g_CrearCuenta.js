import { LightningElement,track ,api,wire} from 'lwc';//api
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getWrapper from '@salesforce/apex/p2g_Cotizador.getWrapper';
import codigoPostal from '@salesforce/apex/p2g_Cotizador.codigoPostal';
import guardarDatos from '@salesforce/apex/p2g_asignarCuentaSpot.guardarDatos';
import validacionRfc from '@salesforce/apex/p2g_asignarCuentaSpot.validacionRfc';

export default class P2g_CrearCuenta extends LightningElement {
    //variables
    @api recordId;//obtiene el ID de la cotizacion desde el registro actual
    asignarCuenta = true;
    accountAddress = false;
    activeSections = ['Seccion1','Seccion2','PreSeccion'];
    activeSections2=['Seccion3'];
    tipodeServicio = '';
    resultadoActualizalead;

    lead;
    wrapper2;
    wrapper;
    existeRFC = false;
    esLead = false;
    rfc = '';
    razonsocial;
    telefono;
    correo;
    banco;
    numerocuenta;
    callefis;
    calleor;
    calledes;
    etd;
    eta;
    
    numerointeriorfis;
    numerointerioror;
    numerointeriordes;
    numeroexteriorfis;
    numeroexterioror;
    numeroexteriordes;

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

    //inicio
connectedCallback() {
    this.initializeComponent();
    console.log('si se actualizo el js');
}
initializeComponent(){
                console.log('el id de la quote actual es',this.recordId);
    getWrapper()
        .then(result => {
            this.wrapper2 = result;
            this.error = false;
            if (this.recordId) {
                this.wrapper2.quoteId = this.recordId; // Asigna recordId a quoteId
            }
        })
        .catch(error => {
            this.pushMessage('Error al abrir el wrapper','error', error.body.message);
            this.showAdvertencia = true;                     
        });
}
pushMessage(title, variant, message){
    const event = new ShowToastEvent({
        title: title,
        variant: variant,
        message: message,
    });
    this.dispatchEvent(event);
}
//botones
creaAddress(){
    this.accountAddress = true;
    this.asignarCuenta = false;
    console.log('si da clic');
    if (this.recordId) {
        this.wrapper.quoteId = this.recordId; // Asigna recordId a quoteId
        console.log('el id de la quote actual es',this.recordId);
    }
}
Anterior(){
    this.accountAddress = false;
    this.asignarCuenta = true;
}
Aceptar(){
    this.wrapper.emailCliente = this.correo;
    console.log('el correo es: ',this.wrapper.emailCliente);
    guardarDatos({cotizador: this.wrapper})
                .then(result => {
                    this.resultadoActualizalead = result;
                    this.pushMessage('Exitoso!','success','Se creo la cuenta con exito!');
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.resultadoActualizalead = null;
                });
}

verificar(){
    this.existeRFC=false;
    this.esLead=false;
    console.log('el rfc es:'+this.existeRFC);
    console.log('si se actualizo lo subido');
    this.wrapper=null;
    
    console.log('El wrapper esta:'+this.wrapper);
    
    console.log('recordId: '+ this.recordId,'rfc:',this.rfc,'correo: ',this.correo);
    validacionRfc({rfc: this.rfc,correo: this.correo, quoteId: this.recordId})
    .then(result => {
        this.wrapper = result;
        if(this.wrapper.tarifario === true){
            this.existeRFC = true;
        }else{
            this.esLead = true;
        }
        this.pushMessage('Exitoso!','success','Se realizo la validacion con exito!');
    })
    .catch(error => {
        this.pushMessage('Error','error', error.body.message);
    });
}
//fin botones
// Listas de opciones
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
    //primera ventana
    RFCCustomer(event){
        this.rfc = event.detail.value;
    }
    telefonoCustomer(event){
        this.telefono = event.detail.value;
        this.wrapper.telefonoCliente = this.telefono;
    }
    EmailCustomer(event){
        this.correo = event.detail.value;
    }
    razonSocialCustomer(event){
        this.razonsocial = event.detail.value;
        this.wrapper.razonSocial = this.razonsocial;
    }
    bancoSeleccionado(event){
        this.banco= event.detail.value;
        this.wrapper.banco = this.banco;
    }
    numCuentaCustommer(event){
        this.numerocuenta= event.detail.value;
        this.wrapper.numeroCuenta= this.numerocuenta;
    }
    calleFiscal(event){
        this.callefis = event.detail.value;
        this.wrapper.calleFiscal = this.callefis;
    }
    interiorFiscal(event){
        this.numerointeriorfis = event.detail.value;
        this.wrapper.interiorFiscal = this.numerointeriorfis;
    }
    exteriorFiscal(event){
        this.numeroexteriorfis= event.detail.value;
        this.wrapper.exteriorFiscal = this.numeroexteriorfis;
    }
    SideSelectCPFis(event){
        this.searchValueCPFis = event.target.outerText;
        this.showSideCPFis = false;
        this.searchValueIdCPFis = event.currentTarget.dataset.id;
        this.wrapper.cPFiscalId = event.currentTarget.dataset.id;
        this.wrapper.cPFiscal = event.target.outerText;
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
                    console.log('entra al catch');
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
        this.wrapper.coloniaFiscalId = event.currentTarget.dataset.id;
        this.wrapper.coloniaFiscal = event.target.outerText;
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
    //inicia segunda ventana
    
calleOrigen(event){
    this.wrapper.calleOrigen = event.detail.value;
    this.calleor = event.detail.value;
}
interiorOrigen(event){
    this.wrapper.interiorOrigen = event.detail.value;
    this.numeroexterioror = event.detail.value;
}
exteriorOrigen(event){
    this.wrapper.exteriorOrigen = event.detail.value;
    this.numeroexterioror = event.detail.value;
}
SideSelectCPOr(event){
    this.searchValueCPOr = event.target.outerText;
    this.showSideCPOr = false;
    this.searchValueIdCPOr = event.currentTarget.dataset.id;
    this.wrapper.cPOrigenId = event.currentTarget.dataset.id;
    this.wrapper.cPOrigen = event.target.outerText;
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
    this.wrapper.coloniaOrigenId = event.currentTarget.dataset.id;
    this.wrapper.coloniaOrigen = event.target.outerText;
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
    this.wrapper.calleDestino = event.detail.value;
    this.calledes = event.detail.value;
}
interiorDestino(event){
    this.wrapper.interiorDestino = event.detail.value;
    this.numerointeriordes = event.detail.value;
}
exteriorDestino(event){
    this.wrapper.exteriorDestino = event.detail.value;
    this.numeroexteriordes = event.detail.value;
}
SideSelectCPDes(event){
    this.searchValueCPDes = event.target.outerText;
    this.showSideCPDes = false;
    this.searchValueIdCPDes = event.currentTarget.dataset.id;
    this.wrapper.cPDestinoId = event.currentTarget.dataset.id;
    this.wrapper.cPDestino = event.target.outerText;
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
    this.wrapper.coloniaDestinoId = event.currentTarget.dataset.id;
    this.wrapper.coloniaDestino = event.target.outerText;
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
Fechadesalida(event){
    this.wrapper.etd = event.detail.value;
    this.etd = event.detail.value;
}
Fechadellegada(event){
    this.wrapper.eta = event.detail.value;
    this.eta = event.detail.value;
}
}