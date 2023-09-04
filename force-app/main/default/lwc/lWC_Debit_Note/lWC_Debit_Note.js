import { LightningElement, api, track, wire } from 'lwc';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi'; // Importacion para indicar cuando se va a mostrar el modal
import STATUS_PLANNER from '@salesforce/schema/Shipment__c.Shipment_Status_Plann__c';
import ACCOUNT from '@salesforce/schema/Shipment__c.Account_for__c';
import NAME from '@salesforce/schema/Shipment__c.Name';
import updateDebitNote from '@salesforce/apex/APX_Debit_Note.updateDebitNote';
import getDebitNote from '@salesforce/apex/APX_Debit_Note.getDebitNote';
import getInvoice from '@salesforce/apex/APX_Debit_Note.getInvoice';
import {refreshApex} from '@salesforce/apex';
import createDebitNote from '@salesforce/apex/APX_Debit_Note.createDebitNote';
import createInvoice from '@salesforce/apex/APX_Debit_Note.createInvoice';
import updateDebitNoteSearch from '@salesforce/apex/APX_Debit_Note.updateDebitNoteSearch';
import GetServiceLines from '@salesforce/apex/APX_Debit_Note.getShipmentsAndLines';
import showInvoicesAndLines from '@salesforce/apex/APX_Debit_Note.showInvoicesAndLines';
import sendPdf from '@salesforce/apex/APX_Debit_Note.sendPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFiles from '@salesforce/apex/APX_Debit_Note.uploadFiles';
import changeCurrency from '@salesforce/apex/APX_Debit_Note.changeCurrency';
import createAndAssignDebitNote from '@salesforce/apex/APX_Debit_Note.createAndAssignDebitNote';
import AssignDebitNoteShipmentsOmitted from '@salesforce/apex/APX_Debit_Note.AssignDebitNoteShipmentsOmitted';
const FIELDS=[STATUS_PLANNER,ACCOUNT,NAME];
const STATUS = 'Closed';

export default class LWC_Debit_Note extends LightningElement {
   
   @api recordId;         
   @api estatus;   
   @track shipmentsId = [];    
   @track isModalOpen = true;
   @track isInvoice = true; //Bandera para indicar si el SP tiene una invoice; 
   @track isCredito = false;
   @track isContado = true;   
   @track itsAllOK = false;
   @track isPrincipalModal = true;
   @track isDetailModal; //bandera para mostrar las invoices generadas
   @track accountFor;   
   @track debitNoteResponse;
   @track invoiceResponse;
   @track shipmentsLine; // Muestra los SP que se van a mandar a timbrar
   @track shipmentsnotClose; // Muestra los SP que no se van a mandar a timbrar y se va a crear una debit note para los SP   
   @track shipmentsUnsold; // Muestra los SP de las lineas omitidas que no estan vendidas
   @track debitNotes; //Obtenemos las DN para que seleccione una y se asigne a los sp que fueron omitidos
   @track manyDebitNotes = false // Bandera para mostrar las debit notes encontradas
   @track debitNoteId ; // Obtenemos la DN encontrada para los SP Omitidos
   @track spName;
   @track sp1Actual = false; // bandera para identificar que shipment esta mostrando
   @track sp2Actual = false;
   @track sp3Actual = false;
   @track sp4Actual = false;
   @track sp5Actual = false;
   debitN
   isLoadedAll;  
   @track isDebitNote;
   searchDN = false;
   @track shipmentList = [];

   //Variable para visualizar el modal, se activa cuando esta en true
   @track bandera = false; 
   shipment;
   @track pakVerificacion;    

   //Banderas para agregar los sp de la dn
   @track sp1 = false;
   @track sp2 = false;
   @track sp3 = false;
   @track sp4 = false;
   @track sp5 = false;

     
    openModal() {
    // to open modal set isModalOpen tarck value as true
    this.isModalOpen = true;
    this.isPrincipalModal = true;
    }
    closeModal() {
    // to close modal set isModalOpen tarck value as false        
    this.isModalOpen = false;
    } 

    handleIsLoading(isLoading) {
        this.isLoadedAll = isLoading;
    }
       
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
       if (error) {          
            console.log('Ocurrio un erro al mostrar el modal: ' , error);       
        } else if (data) {            
           
           getInvoice({recordId: this.recordId})
           .then(result =>{
                console.log('result ' + result);
                this.isInvoice = result;        
                console.log('invoice: ' + this.isInvoice);        
           })
           .catch(error =>{
                this.showNotification('Ocurrio un error',error.message,'error');
           })
           this.isLoadedAll=false;
           this.shipment = data;            
           let modifiedDate = this.shipment.lastModifiedDate;            

           if(!this.lastModifiedDate) {                
               this.lastModifiedDate = this.shipment.lastModifiedDate;
           }    
                      
           let estatus = getFieldValue(this.shipment, STATUS_PLANNER);                                 
           this.accountFor = getFieldValue(this.shipment,ACCOUNT);
           this.spName = getFieldValue(this.shipment,NAME);
                    
           if(estatus == STATUS){
               console.log('Son iguales... ');
               this.bandera = true;               
           }else if(this.estatus == STATUS){
               console.log('Activando modal desde el monitor'); 
               this.bandera = true;
           }
                   
           if (modifiedDate != this.lastModifiedDate && this.bandera && !this.isInvoice) {
                console.log('Activando modal....');                              
                this.bandera = true;               
           }else{
                console.log('No entro al modal DN');
           }
       }
   }

   @wire(getDebitNote,{recordId: '$recordId'})
   debitNote(response){

       try{
            console.log('entrando al metodo debitNote');
            this.debitNoteResponse = response;
            let data = response.data;
            let error = response.error;
            this.debitN = null;
            this.isDebitNote = null;

            if(data){

                console.log('data');
                console.log(data);            
                this.debitN = data;
                

                var  shipments = [];                                          
                 
                if(this.debitN.length != 0){

                    var dn = this.debitN[0];

                    if(dn.Shipment_Number_1__c != null){                        
                        this.sp1 = true;                   
                        this.sp2 = true;
                        shipments.push(dn.Shipment_Number_1__c);
                        
                        if(dn.Shipment_Number_1__r.Name == this.spName){
                            this.sp1Actual = true;
                        }
                    }
                    if(dn.Shipment_Number_2__c != null){ 
                        this.sp2 = true;                        
                        this.sp3 = true;
                        shipments.push(dn.Shipment_Number_2__c);
                        
                        if(dn.Shipment_Number_2__r.Name == this.spName){
                            this.sp2Actual = true;                            
                        }
                    }
                    if(dn.Shipment_Number_3__c != null){      
                        this.sp3 = true;                  
                        this.sp4 = true;
                        shipments.push(dn.Shipment_Number_3__c);

                        if(dn.Shipment_Number_3__r.Name == this.spName){
                            this.sp3Actual = true;
                        }
                    }
                    if(dn.Shipment_Number_4__c != null){     
                        this.sp4 = true;                   
                        this.sp5 = true;
                        shipments.push(dn.Shipment_Number_4__c);

                        if(dn.Shipment_Number_4__r.Name == this.spName){
                            this.sp4Actual = true;
                        }
                    }
                    if(dn.Shipment_Number_5__c != null){                         
                        this.sp5 = true;
                        shipments.push(dn.Shipment_Number_5__c);

                        if(dn.Shipment_Number_5__r.Name == this.spName){
                            this.sp5Actual = true;
                        }
                    }            
                    this.shipmentsId = shipments;            
                }
                
                if(this.debitN.length == 0){
                    this.isDebitNote = true;
                }else{
                    this.isDebitNote = false;
                }
                console.log('this.isDebitNote'+ this.isDebitNote);

            }else if(error){

                console.log('Ocurrio un error al mostrar la Debit note: ' + error);
                console.log(error);
            }

       }catch(error){
            console.log('catch: ' + error);
       }

   }
       
   createDebitNote(){
    
    this.handleIsLoading(true);
    createDebitNote({recordId:this.recordId})
    .then(result =>{

        console.log(result);
        this.handleIsLoading(false);
        this.isDebitNote = false;        
        refreshApex(this.debitNoteResponse);

    }) 
    .catch(error =>{
        console.log('Error: ' + error.body.message);
        this.handleIsLoading(false);
        refreshApex(this.debitNoteResponse);
    })
    
   }

   onAccountSelection(event){          
    
    this.handleIsLoading(true);
    let objId = event.detail.selectedRecordId;
    console.log('Id: ' +objId);

    if(this.searchDN){

        updateDebitNoteSearch({dnId:objId, spId: this.recordId})
        .then(result =>{
            console.log(result);        
            this.handleIsLoading(false);
            refreshApex(this.debitNoteResponse);        
        })
        .catch(error =>{
            console.log('Error: '+error.body.message);
            this.handleIsLoading(false);
            refreshApex(this.debitNoteResponse);
        })

    }else{

        var dnId = this.template.querySelector('.dnId').value;
        console.log('debit note id '+dnId);
        
        updateDebitNote({dnId:dnId,spId:objId})
        .then(result =>{

            console.log(result);        
            this.handleIsLoading(false);
            refreshApex(this.debitNoteResponse);        
        })
        .catch(error =>{
            console.log(error.body.message);
            this.handleIsLoading(false);
            refreshApex(this.debitNoteResponse);
        })    
    }

   }
   
   searchDebitNote(){

        console.log('Buscar Debit Note...');
        this.searchDN = true;

   }

   CrearInvoicesBtn(){
    
    this.isPrincipalModal=false;
    this.isCompConfirmation=true;
    this.isDetailModal = false;
    this.handleIsLoading(true);

    console.log('Entrando CrearDebitNoteBtn');
    /*var  shipments = [];                            
    var sp1 = this.template.querySelector('.sp1');                    
    var sp2  = this.template.querySelector('.sp2');                            
    var sp3  = this.template.querySelector('.sp3');                    
    var sp4  = this.template.querySelector('.sp4');                    
    var sp5  = this.template.querySelector('.sp5');    
                
    if(sp1 != null){                   
        shipments.push(sp1.value);
    }
    if(sp2 != null){                        
        shipments.push(sp2.value);
    }
    if(sp3 != null){                        
        shipments.push(sp3.value);
    }
    if(sp4 != null){                        
        shipments.push(sp4.value);
    }
    if(sp5 != null){                        
        shipments.push(sp5.value);
    }*/

    GetServiceLines({shipments:this.shipmentsId, recordId: this.recordId})
    .then(result =>{
        console.log(result);
        this.shipmentsLine=result.shipmentClose;
        this.shipmentsnotClose = result.shipmentNotClose;
        this.shipmentsUnsold = result.shipmentUnsold;            
        this.handleIsLoading(false);
    })
    .catch(error =>{
        console.error('error.body CrearDebitNoteBtn => ' + error.body.message );
        console.error('error.name CrearDebitNoteBtn => ' + error.name );
        console.error('error.message CrearDebitNoteBtn => ' + error.message ); 
        this.showNotification('Ocurrio un error',error.message,'error');
        this.handleIsLoading(false);
    })
    
   }

    generateInvoice(){ //Metodo para quitar los shipments omitidos y crear / asignar una debit note. Tambien, para timbrar los shipments

        try {
            this.handleIsLoading(true);
            
            //Metodo para crear / asignar una debit note a los shipments omitidos
            console.log('Debit note Id: ' + this.debitN[0].Id);
            var spsNClose = [];

            for(let i=0; i<this.shipmentsnotClose.length; i++){                                 
                spsNClose.push(this.shipmentsnotClose[i].spId);
            } 

            var  shipments = [];                

            for(let i=0; i<this.shipmentsLine.length; i++){                
                shipments.push(this.shipmentsLine[i].shipmentId);
            }
            
            if(spsNClose.length != 0){
                createAndAssignDebitNote({sps:spsNClose, recordId: this.debitN[0].Id})
                .then(result =>{

                    if(result == null || result.length == 0){

                        console.log('Se ha creado / asignado una debit note')
                        console.log('Entrando al metodo de generar invoice');                          
                        
                        createInvoice({shipments: shipments})   
                        .then(result =>{
                            
                            console.log(result);                
                            this.isPrincipalModal=false;
                            this.isCompConfirmation=false;
                            this.isDetailModal = true;

                            showInvoicesAndLines({shipments:shipments})
                            .then(result =>{                   
                                console.log('invoices creadas: ' + result);
                                this.showNotification('Operación Exitosa','Se han generado las siguientes Invoices','success');
                                this.invoiceResponse = result;
                                this.handleIsLoading(false); 
                            })
                            .catch(error =>{
                                console.error('error.body showInvoicesAndLines => ' + error.body.message );
                                this.showNotification('Ocurrio un error',error.body.message,'error');
                                this.handleIsLoading(false);                                                                                      
                        })
                        .catch(error =>{
                            console.error('error.body createInvoice => ' + error.body.message );                
                            this.showNotification('Ocurrio un error',error.body.message,'error');
                            this.handleIsLoading(false);
                        })})
                    
                    }else{
                        console.log('Se encontro varias Debit notes');
                        console.log(result);
                        this.debitNotes = result;
                        this.handleIsLoading(false);
                        this.manyDebitNotes = true;
                        this.isPrincipalModal=false;
                        this.isCompConfirmation=false;
                        this.isDetailModal = false;
                    }

                })
                .catch(error =>{
                    console.error('error createAndAssignDebitNote => ' + error.body.message );
                    this.handleIsLoading(false);
                })
            }else{
                createInvoice({shipments: shipments})   
                .then(result =>{
                    
                    console.log(result);                
                    this.isPrincipalModal=false;
                    this.isCompConfirmation=false;
                    this.isDetailModal = true;

                    showInvoicesAndLines({shipments:shipments})
                    .then(result =>{                   
                        console.log('invoices creadas: ' + result);
                        this.showNotification('Operación Exitosa','Se han generado las siguientes Invoices','success');
                        this.invoiceResponse = result;
                        this.handleIsLoading(false); 
                    })
                    .catch(error =>{
                        console.error('error.body showInvoicesAndLines => ' + error.body.message );
                        this.showNotification('Ocurrio un error',error.body.message,'error');
                        this.handleIsLoading(false);                                                                                      
                })
                .catch(error =>{
                    console.error('error.body createInvoice => ' + error.body.message );                
                    this.showNotification('Ocurrio un error',error.body.message,'error');
                    this.handleIsLoading(false);
                })})
            }                        
                        
        } catch (error) {                  
            console.error('error.name generateInvoice => ' + error.name );
            console.error('error.message generateInvoice => ' + error.message );
            this.handleIsLoading(false);            
            this.showNotification('Ocurrio un error',error.message,'error');
        }        
   }
   
   finalizar(){    
        console.log('Finalizar operación');

        console.log('this.invoiceResponse '+ this.invoiceResponse);

        var  shipments = [];                

        for(let i=0; i<this.invoiceResponse.length; i++){                
            shipments.push(this.invoiceResponse[i].shipmentId);
        }  

        console.log('Entrando al metodo generatePDF: ' + shipments);

        changeCurrency({spId:shipments[0]})
        .then(result =>{
            console.log('Entrando al metodo changeCurrency');
            if(result){
                sendPdf({recordId:this.recordId})
                .then(result =>{
                    uploadFiles({spsId:shipments,fileName:result})
                    .then(result =>{
                        
                        this.showNotification('Se ha finalizado la operación correctamente',result,'success');                
                        this.closeModal();
                    })
                    .catch(error =>{
                        console.error('error uploadFiles => ' + error.body.message);
                        this.showNotification('Ocurrio un error',error.body.message,'error');    
                    })            
                })
                .catch(error =>{
                    console.error('error generatePDF => ' + error);
                    this.showNotification('Ocurrio un error',error.body.message,'error');
                })    
            }
        })
        .catch(error =>{
                console.error('error changeCurrency => ' + error);
                this.showNotification('Ocurrio un error',error.body.message,'error');
        })
            
        this.updateRecordView();
   }

    createInvoices(){

        console.log('Entrando al metodo createInvoices:' + this.shipmentsnotClose.length + ' idDN: ' + this.debitNoteId);

        var  shipmentsNotClose = [];                
        for(let i=0; i<this.shipmentsnotClose.length; i++){   
                console.log('this.shipmentNotClose[i]: '  + this.shipmentsnotClose[i].spId);
            if(!this.shipmentsnotClose[i].isInvoice){
                console.log('this.shipmentsnotClose[i].isInvoice: '  + this.shipmentsnotClose[i].isInvoice);
                shipmentsNotClose.push(this.shipmentsnotClose[i].spId);
            }                         
        } 
        console.log('shipmentsNotClose: ' + shipmentsNotClose);

        AssignDebitNoteShipmentsOmitted({recordId:this.debitNoteId,sps: shipmentsNotClose})
        .then(result =>{

            if(result != null){
                console.log('Creando invoice..');

                var  shipments = [];                

                for(let i=0; i<this.shipmentsLine.length; i++){                
                    shipments.push(this.shipmentsLine[i].shipmentId);
                } 

                createInvoice({shipments: shipments})   
                .then(result =>{
                    
                    console.log(result);                
                    this.isPrincipalModal=false;
                    this.isCompConfirmation=false;
                    this.isDetailModal = true;

                    showInvoicesAndLines({shipments:shipments})
                    .then(result =>{                   
                        console.log('invoices creadas: ' + result);
                        this.showNotification('Operación Exitosa','Se han generado las siguientes Invoices','success');
                        this.invoiceResponse = result;
                    })
                    .catch(error =>{
                        console.error('error.body showInvoicesAndLines => ' + error.body.message );
                        this.showNotification('Ocurrio un error',error.body.message,'error');
                                
                    this.handleIsLoading(false);               
                })
                .catch(error =>{
                    console.error('error.body createInvoice => ' + error.body.message );                
                    this.showNotification('Ocurrio un error',error.body.message,'error');
                    this.handleIsLoading(false);
                })})
            }
        })
        .catch(error =>{
            console.error('error.body AssignDebitNoteShipmentsOmitted => ' + error.body.message )
            this.handleIsLoading(false);
        })                         
   }

    getDebitNoteId(event){

        this.debitNoteId = event.currentTarget.dataset.id;
        console.log('this.debitNoteId: ' + this.debitNoteId);
    }

    regresarModal(){
        this.handleIsLoading(true);
        this.isPrincipalModal=true;
        this.isCompConfirmation=false;
        this.handleIsLoading(false);
    }

    regresarOpciones(){        
        this.isDebitNote = true;
        this.searchDN = false;
    }

    refreshModal(){
        console.debug('Refresh modal');
        this.handleIsLoading(true);
            refreshApex(this.debitNoteResponse);
        this.handleIsLoading(false);
        this.showNotification('Operación Exitosa','Se ha actualizado el modal correctamente','success');
    }

    updateRecordView() {
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
    }
    
    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}