import { LightningElement, api,wire,track } from 'lwc';
import getDebitNoteAndCreateInvoice from '@salesforce/apex/APX_Debit_Note.getDebitNoteAndCreateInvoice';
import IsDebitNoteSP from '@salesforce/apex/APX_Debit_Note.IsDebitNoteSP';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Shipment__c.Name';
import createDNSP from '@salesforce/apex/APX_Debit_Note.createDNSP';
import {CloseActionScreenEvent} from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import removeAndAssigneDebitNote from '@salesforce/apex/APX_Debit_Note.removeAndAssigneDebitNote';

export default class LWC_DebitNoteSP extends LightningElement {

    @api recordId;
    @track debitNList; // Devuelve varias debit note encontradas
    @track debitNoteOne; // Mostramos la debit note obtenida
    @track debitNoteResponse;
    @track isDebitList;
    @track isDebitNote;
    @track isDebitSize;    
    @track debitNoteId;
    @track shipment;
    @track spName;
    @track msj1;
    @track msj2;
    @track  invoiceResponse;
    @track isInvoice;
  

    @wire(getDebitNoteAndCreateInvoice,{recordId:'$recordId'})    
    debitNote(response){
        console.log('this.shipments: ');
        this.debitNoteResponse = response;
        let data = response.data;
        let error = response.error;        

        if(data){

            console.log( 'Mostrando dn: ' + data);
            console.log(data);                
            this.debitNList = data;   
            console.log('this.debitNList.length: ' + this.debitNList.length);

            try{

                if(this.debitNList.length == 0){

                    console.log('No tiene debit note: ');
                    createDNSP({recordId:this.recordId})
                    .then(result =>{
                                                                   
                        console.log('Debit note creada');
                        console.log(result);
                        this.isDebitList = false;                    
                        this.isDebitSize = false;
                        this.isDebitNote = true;
                        this.debitNoteOne = result;
                        this.msj1 = 'Se ha creado una  Debit Note:';
                        console.log('Debit note creada: ' + this.debitNoteOne.Name);
                        console.log('debit note: ' +dn.length + ' this.debitNoteId:' + this.debitNoteId);                    
                    })
                    .catch(error =>{
                        console.log('Error createDNSP: ' + error.body.message);
                    });
    
                }else if(this.debitNList.length == 1){
    
                    this.debitNoteOne = this.debitNList[0];

                    IsDebitNoteSP({spId:this.recordId,dnId:this.debitNoteOne.Id})
                    .then(result =>{                        

                        console.log('Tiene una debit note: ' + result);
                        this.msj2 = 'Se te ha asignado la Debit Note: ';             
                        console.log('msj2: ' + this.msj2);   
                        this.isDebitList = false;                
                        this.isDebitNote = true; 

                    })
                    .catch(error =>{
                        console.log('Ocurrio un Error IsDebitNoteSP: ' + error.body.message);
                    })                                                       
    
                }else{
    
                    console.log('Tiene varias debit notes: ' + this.debitNList.length);
                    this.isDebitList = true;  
                    this.isDebitSize = true;
                    this.isDebitNote = false;                    
                }

            }catch(e){
                console.log('Ocurrio un Error: ' + e);
            }        

        }else if(error){

            console.log('Ocurrio un error');
            console.log(error.body.message);
        }

    }

    @wire(getRecord, { recordId: '$recordId' , fields: [NAME]})
    wireRecord({ error, data }) {
        if (error) {          
            console.log('Ocurrio un error al mostrar el nombre: ' , error);       
        } else if (data) {                                
           this.shipment = data;                       
           this.spName = getFieldValue(this.shipment,NAME);          
       }
    }   

    getDebitNoteId(event){

        this.debitNoteId = event.currentTarget.dataset.id;
        console.log('this.debitNoteId: ' + this.debitNoteId);
    }

    assignarDebitNote(){
        console.log('Entrando al metodo assignarDebitNote');

        var dns = [];

        for(let i=0; i<this.debitNList.length; i++){
            dns.push(this.debitNList[i].Id);
        }

        console.log('dns: '+ dns );

        removeAndAssigneDebitNote({recordId:this.debitNoteId,dns:dns,spId:this.recordId})
        .then(result =>{

            this.dispatchEvent(new CloseActionScreenEvent());//Cerramos el modal
            this.showNotification('Operación Exitosa',('Se asigno la Debit Note: ' + result + ' correctamente') ,'success');
            this.updateRecordView();            

        })
        .catch(error =>{
            console.log('Error removeAndAssigneDebitNote: ' + error);
        })


    }

    finisher(){        
        this.dispatchEvent(new CloseActionScreenEvent());//Cerramos el modal
        this.showNotification('Operación Exitosa','Se ha Finalizado la operación correctamente','success');
        
        if(this.msj1 != null){
            console.log('condicion 1');
            window.location.reload();
        }else{
            console.log('condicion 2');
            this.updateRecordView();
        }        
    }

    showNotification(title, message, variant) {                                  
        this.dispatchEvent(
            new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            })
        );
    }

    updateRecordView() {
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
    }
}