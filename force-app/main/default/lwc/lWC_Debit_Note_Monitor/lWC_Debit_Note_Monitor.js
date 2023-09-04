import { LightningElement,api,wire,track  } from 'lwc';
import getDNobj from '@salesforce/apex/APX_Debit_Note.getDNandSPtoMonitor';
import getInvoice from '@salesforce/apex/APX_Debit_Note.getInvoice';
import uploadFiles from '@salesforce/apex/APX_Debit_Note.uploadFiles';
import sendPdf from '@salesforce/apex/APX_Debit_Note.sendPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createDebitNote from '@salesforce/apex/APX_Debit_Note.createDebitNote';
import changeCurrency from '@salesforce/apex/APX_Debit_Note.changeCurrency';
import {refreshApex} from '@salesforce/apex';

export default class LWC_Debit_Note_Monitor extends LightningElement {
    @api recordId;
    @track witDN=false;
    @track showDN = false;
    @track isEnable;// variable para habilitar o deshabilitar el boton de timbrar debit note
    @track showModal=false;
    dnWrapp;
    @wire(getDNobj,{recordId:'$recordId'}) 
    Metadatoinicial({error,data}){
        if (data) {
            console.log('@@@@ lo que responde getDNobj ',data.length);
            console.log('@@@@ lo que responde getDNobj ',data);
            this.dnWrapp=data;
            this.witDN=this.dnWrapp.ContainsDN;
            getInvoice({recordId: this.recordId})
            .then(result =>{
                    console.log('result ' + result);
                    this.isEnable = result;        
                    console.log('invoice: ' + this.isInvoice);        
            })
            .catch(error =>{
                    this.showNotification('Ocurrio un error',error.message,'error');
            })
            console.log('@@@@ lo que contiene witDN ',this.witDN);
        }else if(error){
            console.error('@@@@ checar el siguiente error en Metadatoinicial: ' + error.body.message);
        }
    }
    showModalCreateDN() {  
        this.showModal = true;
    }

    createDN(){

        createDebitNote({recordId:this.recordId})
        .then(result =>{
            this.showNotification('Operación Exitosa',result,'success');
            this.hideModalCreateDN();
        })
        .catch(error =>{
            console.log('Error al crear la DN ' + error);
            this.showNotification('Ocurrio un error al crear la Debit Note',error,'error');
        })
        this.updateRecordView();
    }

    hideModalCreateDN() {  
        this.showModal = false;
        getDNobj({recordId: this.recordId})
        .then(result =>{
            this.dnWrapp=result;
            this.witDN=this.dnWrapp.ContainsDN;
            console.log('@@@@ lo que contiene witDN ',this.witDN);        
        })
        .catch(error =>{
            console.error('@@@@ checar el siguiente error en Metadatoinicial: ' + error.body.message);
        })
    }
    

    createPDF(){
        try{

            
            console.log('Entrando al metodo createPDF: ');
            let  shipments = this.dnWrapp.shipmentsDN;
            console.log('shipments: ' + shipments.length);
            var  sps = [];                
    
            console.log('Iterando sps');
            for(let i=0; i<shipments.length; i++){                
                sps.push(shipments[i].Id);
            } 
    
            console.log('SPs encontrado: '  + sps);
            
            changeCurrency({spId:this.recordId})
            .then(result =>{
                console.log('changeCurrency');
                if(result){
                    sendPdf({recordId:this.recordId})
                    .then(result =>{
                        uploadFiles({spsId:sps,fileName:result})
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
                console.log('Ocurrio un error changeCurrency: ' + result);
                this.showNotification('Ocurrio un error',error.body.message,'error');
            })            
            this.updateRecordView();

        }catch(error){
            console.log('catch: ' + error);
        }       
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

    showDebitNote(){
        console.log('showDN:'+this.showDN);
        this.showDN = true;
    }
}