import { LightningElement, track, api, wire } from 'lwc';
import GetServiceLines from '@salesforce/apex/APX_Debit_Note.getShipmentsAndLines';
import createInvoice from '@salesforce/apex/APX_Debit_Note.createInvoice';
import showInvoicesAndLines from '@salesforce/apex/APX_Debit_Note.showInvoicesAndLines';
import sendPdf from '@salesforce/apex/APX_Debit_Note.sendPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {CloseActionScreenEvent} from 'lightning/actions';

export default class LWC_Debit_Note_Action extends LightningElement {///El componente se utiliza para el objeto  Debit note en el boton "Create Debit Note Invoice"

    @api recordId;
    @api shipments = [];    
    @track isCreateInvoice = true;
    @track isDetailModal = false;    
    @track shipmentsLine;
    @track invoiceResponse;
    @track title;    
    debitNoteResponse;
    isLoadedAll; 

    
    handleIsLoading(isLoading) {
        this.isLoadedAll = isLoading;
    }        

    @wire(GetServiceLines,{shipments:'$shipments',recordId:'$recordId'})
    wireRecord(response){
        console.log('this.shipments: ' + this.shipments);
        this.debitNoteResponse = response;
        let data = response.data;
        let error = response.error;        

        if(data){

            console.log('data de un boton');
            console.log(data);    
            this.title = 'Creación de Invoices';        
            this.shipmentsLine = data;                   

        }else if(error){

            console.log('error');
            console.log(error.body.message);
        }

    }

    generateInvoice(){

        try {
            this.handleIsLoading(true);
            console.log('Entrando al metodo de generar invoice');
            var  shipments = [];                

            for(let i=0; i<this.shipmentsLine.length; i++){                
                shipments.push(this.shipmentsLine[i].shipmentId);
            }      
            
            createInvoice({shipments: shipments})
            .then(result =>{
                
                console.log('Resultado: '+ result);  
                this.title = 'Detalles de la Invoice Debit Note';              
                
                showInvoicesAndLines({shipments:shipments})
                .then(result =>{
                    console.log('Entrando al metodo showInvoicesAndLines:');                    
                    this.isCreateInvoice=false;
                    this.isDetailModal = true;
                    console.log('invoices creadas: ' + result);
                    this.showNotification('Operación Exitosa','Se han generado las siguientes Invoices','success');
                    this.invoiceResponse = result;                    
                })
                .catch(error =>{
                    console.log('error showInvoicesAndLines:');
                    console.error('error.body showInvoicesAndLines => ' + error);
                    this.showNotification('Ocurrio un error',error,'error');
                })                
                this.handleIsLoading(false);               
            })
            .catch(error =>{
                console.log('error createInvoice:');
                console.error('error.body createInvoice => '+ error);                 
                this.showNotification('Ocurrio un error','','error');
                this.handleIsLoading(false);
            })

        } catch (error) {                  
            console.error('error.name generateInvoice => ' + error.name );
            console.error('error.message generateInvoice => ' + error.message );
            this.handleIsLoading(false);            
            this.showNotification('Ocurrio un error',error.message,'error');
        }        
    }

    generatePDF(){
        
        try{
            
            console.log('Entrando al metodo generatePDF: ');

            sendPdf({recordId:this.recordId})
            .then(result =>{
                this.showNotification('Operación Exitosa',result,'success');
            })
            .catch(error =>{
                console.error('error generatePDF => ' + error);
                this.showNotification('Ocurrio un error',error,'error');
            })

        }catch(error){
            console.log('Error: ' + error);
        }        
        

    }

    finalizar(){    
        console.log('Finalizar operación');  
        this.dispatchEvent(new CloseActionScreenEvent());//Cerramos el modal
        this.showNotification('Operación Exitosa','Se ha Finalizado la operación correctamente','success');
    }

    cancelar(){
        this.dispatchEvent(new CloseActionScreenEvent());//Cerramos el modal
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


}