import { LightningElement,track,wire,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CurrentPageReference } from 'lightning/navigation';
import getLineQuote from '@salesforce/apex/p2g_CreateServiceLineQuote.getLineQuote';
import getRate from '@salesforce/apex/p2g_CreateServiceLineQuote.getRateTarifario';
import getWrapper from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getwrapper';
//import getWrapper2 from '@salesforce/apex/p2g_CreateServiceLineQuote.getWrapper2';//P2G_PruebaALbert
import lineTarifario from '@salesforce/apex/p2g_CreateServiceLineQuote.CrearLineTarifario';
import getSst from '@salesforce/apex/p2g_CreateServiceLineQuote.getSapServiceTypeQuote';
import getCreaLine from '@salesforce/apex/p2g_CreateServiceLineQuote.getCreaLine';
import createNewLine from '@salesforce/apex/p2g_CreateServiceLineQuote.Create';//P2G_PruebaALbert

export default class P2g_CreateQuoteServiceLine  extends LightningElement {
    @api recordId;
    activeSections = ['Seccion1', 'Seccion2', 'Seccion3'];
    /*@wire(getLineQuote, {Id: '$recordId'}) listServiceLine;
    @wire(getRate, {Id: '$recordId'}) listaRateTarifario;
    @wire(getCreaLine, {Id: '$recordId'}) vistaLine;*/
    @track listServiceLine;
    @track createServiceLine;
    @track listaRateTarifario;
    @track vistaLine;
    @track elemento;
    cargoLine = true;
    idString='';
    deURL=false;
    //seccion 3
    rateName;
    sellPrice;
    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        const recordIdURL = urlParams.get('c__recordId');
        if (recordIdURL) {
            this.deURL = true;
            this.recordId= recordIdURL;
        }
            this.initializeComponent();
    }
    initializeComponent(){
        console.log("El ide que llega: ",this.recordId);
        getLineQuote({Id: this.recordId})
            .then(result => {
                this.listServiceLine = result;
                this.error = false;
                console.log("Entra al then s1", this.listServiceLine);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 1','error', error.body.message);
                this.showAdvertencia = true;   
                console.log("Entra al catch s1", error);                     
            });
        getRate({Id: this.recordId})
            .then(result => {
                this.listaRateTarifario = result;
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 2','error', error.body.message);
                this.showAdvertencia = true;                        
            });
        getCreaLine({Id: this.recordId})
            .then(result => {
                this.vistaLine = result;
                this.cargoLine = true;
                console.log("Entra al then", this.vistaLine);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 3','error', error.body.message);
                this.vistaLine = null;   
                this.cargoLine = false;       
                console.log("Entra al carch", this.vistaLine);              
            });
            console.log("record Id wp", this.recordId);
    }

    @track sideRecordsSsts;
    searchValueSsts ='';
    searchValueIdSsts ='';
    showSideSsts = false;
    showVista = false;

    nWrapper=0;
    ruta = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+this.recordId+"/view";
    //produccion https://pak2gologistics.lightning.force.com/lightning/r/
    //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }

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
                    this.updateLine = result;
                    this.pushMessage('Exitoso!','success','Se actualizo con exito!');
                    for (let i in this.updateLine){
                        const ultimoElemento = this.updateLine[i];
                        this.listServiceLine = Array.from(this.listServiceLine);
                        this.listServiceLine.push(ultimoElemento);
                    const updatedlistaRateTarifario = this.listaRateTarifario.map( (item) => { 
                        if (item.Id === this.wrapper[i].Id) { 
                            return {...item, seModifica: false, };
                        } 
                        return item; }); // Actualiza la lista de service lines con los valores actualizados
                        this.listaRateTarifario = updatedlistaRateTarifario;
                    }
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.updateLine = null;
                }); 
        return refreshApex(this.listServiceLine);
        }else{ this.pushMessage('Error','error', 'Seleccionar una service Line para modificar');} 
    }

    //
    SideSelectSsts(event){
        this.showVista = false;
        this.searchValueSsts = event.currentTarget.outerText;
        this.showSideSsts = false;
        this.searchValueIdSsts = event.currentTarget.dataset.id;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, SapServiceTypeId : this.searchValueIdSsts,SapServiceType: this.searchValueSsts};
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
        console.log("modif", this.vistaLine);
        
    }
    searchKeySsts(event){
        this.searchValueSsts = event.target.value;
        this.searchValueIdSsts='';
        if (this.searchValueSsts.length >= 3) {
            this.showSideSsts = true;
            this.showVista = true;
            getSst({SapService: this.searchValueSsts, IdQuote: this.recordId})
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
        this.showVista = false;
    }
    close() {
        const closeModalEvent = new CustomEvent("modalclose");
        this.dispatchEvent(closeModalEvent);
    }
    crearLines(){
        this.key=true;
        console.log('name:',this.rateName);
        if (typeof this.rateName === 'undefined' || this.rateName === null || (this.rateName && this.rateName.length === 0)) {
            this.pushMessage('Error','error', 'Se requiere Rate Name');
            return
        }
        createNewLine({data: this.vistaLine[0]})
        .then(result => {
            /*if (this.listServiceLine.length > 0) {
                const ultimoElemento = this.listServiceLine[this.listServiceLine.length - 1];
            }*/
            this.elemento = result;
            this.listServiceLine.push(this.elemento);
            this.pushMessage('Exitoso!','success','Se actualizo con exito!');
            console.log();
                this.searchValueSsts = null;
                this.rateName = null;
                this.sellPrice = null;
                   
        })
        .catch(error => {
            this.pushMessage('Error','error', error.body.message);
        });
        getCreaLine({Id: this.recordId})
            .then(result => {
                this.vistaLine = result;
                this.cargoLine = true;
                console.log("Entra al then", this.vistaLine);
            })
            .catch(error => {
                this.pushMessage('Error en cargar Seccion 3','error', error.body.message);
                this.vistaLine = null;   
                this.cargoLine = false;       
                console.log("Entra al carch", this.vistaLine);              
        });

    }
    registroCurrency(event){
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, Moneda : event.target.value };
        }); // Actualiza la lista de service lines
        this.vistaLine = updateVistaLine;
    }
    saveName(event){
        this.rateName = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
            return {...item, ServiceRateName : this.rateName, };
        }); // Actualiza la lista de service lines con los valores actualizados
        this.vistaLine = updateVistaLine;
        console.log('line', this.vistaLine);
    }
    saveSellPrice(event){
        const sellPrice = event.target.value;
        const updateVistaLine = this.vistaLine.map( (item) => { 
                return {...item, SellRate: sellPrice, };
            }); // Actualiza la lista de service lines con los valores actualizados
            this.vistaLine = updateVistaLine;
        console.log('line', this.vistaLine);
    }
    abrirLinea(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        //produccion https://pak2gologistics.lightning.force.com/lightning/r/Import_Export_Fee_Line__c/
        //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Import_Export_Fee_Line__c/
        this.varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Import_Export_Fee_Line__c/"+IdServiceLine+"/view";
        var win = window.open(this.varurl, '_blank');
        win.focus();
    }
    abrirQuote(){
        //produccion https://pak2gologistics.lightning.force.com/lightning/r/
        //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/
        const idQuote = this.recordId;
        console.log('el id es: ',this.recordId);
        this.ruta = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+idQuote+"/view";
        window.location = this.ruta;
    }
}