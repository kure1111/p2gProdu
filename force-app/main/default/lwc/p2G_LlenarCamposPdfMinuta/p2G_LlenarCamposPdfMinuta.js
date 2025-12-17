import { api, LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getEvent from '@salesforce/apex/NEU_GenerateMinuta.getEvent';
import getContact from '@salesforce/apex/NEU_GenerateMinuta.getContact';
import generaPDF from '@salesforce/apex/NEU_GenerateMinuta.generaPDF';


export default class P2G_LlenarCamposPdfMinuta extends NavigationMixin(LightningElement) {
    @api recordId;
    @track urlEvent;
    @track urlPDFMinuta;
    @track infoEvento;
    @track frecuencia = '';
    @track inicioProximo = '';
    @track finProximo = '';
    @track creaPDF;
    @track contactoName = '';
    clicCreaPDF = false;
    //buscar contacto
    @track sideRecordsContacto;
    searchValueContacto ='';
    searchValueIdContacto ='';
    showSideContacto = false;
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
        this.initializeComponent();
    }
    initializeComponent(){
        const urlParams = new URLSearchParams(window.location.search);
        this.recordId = urlParams.get('c__recordId');
        getEvent({eventId: this.recordId})
            .then(result => {
                this.infoEvento = result;
                if(this.infoEvento.WhoId){
                    this.contactoName = this.infoEvento.Who.Name;
                }
                console.log('Informacion del evento: '+ this.infoEvento);
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.infoEvento = error;
                console.log('error en la info del evento: '+ error.body.message);
            });
    }
    //valores Frecuencia
    get optionsFrecuencia() {
        return [
            { label: 'Primera Visita', value: 'Primera Visita' },
            { label: 'Segunda Visita', value: 'Segunda Visita' },
            { label: 'Re visita', value: 'Re visita' }
        ];
    }
    valueFrecuencia = '';
    // buscador Contacto
    SideSelectContacto(event){
        this.showSideContacto = false;
        this.searchValueContacto = event.target.outerText;
        this.searchValueIdContacto = event.currentTarget.dataset.id;
        this.infoEvento.WhoId = event.currentTarget.dataset.id;
        this.infoEvento.Who.Name = event.currentTarget.dataset.name;
        this.contactoName = event.currentTarget.dataset.name;
    }
    searchKeyContacto(event){
        this.searchValueContacto = event.target.value;
        this.searchValueIdContacto='';
        if (this.searchValueContacto.length >= 3) {
            this.showSideContacto = true;
            getContact({nombre: this.searchValueContacto})
                .then(result => {
                    this.sideRecordsContacto = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsContacto = null;
                });
        }
        else{
            this.showSideContacto = false;
        }
    }
    agregarLugar(event){
        this.infoEvento.Location = event.detail.value;
    }
    agregarNotas(event){
        this.infoEvento.Comments_Pric__c = event.detail.value;
    }
    agregarTemasP(event){
        this.infoEvento.Temas_Pendientes__c = event.detail.value;
    }
    agregarFrecuencia(event){
        this.frecuencia = event.detail.value;
    }
    agregarInicioProximo(event){
        this.inicioProximo = event.detail.value;
    }
    agregarFinProximo(event){
        this.finProximo = event.detail.value;
    }
    clicCrearMinuta(){
        this.clicCreaPDF = true;
        generaPDF({evento: this.infoEvento, frecuencia: this.frecuencia, inicio: this.inicioProximo, fin: this.finProximo})
                .then(result => {
                    this.creaPDF = result;
                    if(this.creaPDF === 'Exito'){
                        this[NavigationMixin.Navigate]({
                            type: 'standard__webPage',
                            attributes: {
                                url: `/apex/NEU_GenerateMinuta?id=${this.recordId}`
                            }
                        });
                        this.pushMessage('Exitoso!','success', 'Se modifico el evento listo para generar el PDF');
                    }else{
                        console.log('el mensaje es: '+ this.mensajeCreacion);
                        this.pushMessage('Error','error', this.mensajeCreacion);
                        this.dioClic = false;
                    }
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.creaPDF = null;
                });
    }
    regresaEvent(){
        const recordUrl = "https://pak2gologistics.lightning.force.com/lightning/r/Event/"+this.recordId+"/view";
        window.open(recordUrl,"_self");
    }
}