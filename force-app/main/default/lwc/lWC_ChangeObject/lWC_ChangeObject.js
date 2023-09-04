import {LightningElement,api,wire, track} from 'lwc';
import recordChangeData from '@salesforce/apex/APX_Verificacion_Pak_Control.recordChangeData';
import getSp from '@salesforce/apex/APX_Verificacion_Pak_Control.getRecord';
import changeShipment from '@salesforce/apex/APX_Debit_Note.changeShipment';
import getDebitNote from '@salesforce/apex/APX_Debit_Note.getDebitNote';
import {refreshApex} from '@salesforce/apex';

export default class LWC_ChangeObject extends LightningElement {

    @api recordId;
    @api objId;    
    @api objectName;
    @api iconName;
    @api recordName
    isLoadedAll;

    //Debit Note
    @track debitNoteResponse;
    debitN;

    @wire(getSp,{spId:'$recordId'}) 
    records;

    
    @wire(getDebitNote,{recordId: '$recordId'})
    debitNote(response){
 
         this.debitNoteResponse = response;
         let data = response.data;
         let error = response.error;
         this.debitN = null;
         this.isDebitNote = null;
 
         if(data){
 
             console.log('data changeObject');
             console.log(data);            
             this.debitN = data;
             
             if(this.debitN.length == 0){
                 this.isDebitNote = true;
             }else{
                 this.isDebitNote = false;
             }
 
         }else if(error){
 
             console.log('error');
             console.log(error.body.message);
         }
 
    }
   
    //Metodo para actualizar el SP para mostrar el lookup
    changeData(){
        this.handleIsLoading(true);
        console.log('entrando1');
        const objId =  this.template.querySelector('.idV').value;  
        console.log('objId: ' + objId);
        console.log('objeto: ' + this.objectName);


        if(this.objectName == 'Shipment'){

            console.debug('Dentro del metodo..');
            changeShipment({debitNoteId:this.recordId,spId:objId})
            .then(result =>{                
                console.log(result);
                this.handleIsLoading(false);
                refreshApex(this.debitNoteResponse);
            })
            .catch(error =>{
                console.log('Ocurrio un error al cambiar de Shipment en la DN: ' + error.body.message);
                this.handleIsLoading(false);
                refreshApex(this.debitNoteResponse);
            })

        }else{
            recordChangeData({recordId:this.recordId,objId:objId})
            .then(result =>{

                console.debug('Dentro del metodo');
                if(result){
                    console.log('Se ha eliminado el registro del SP');
                    this.handleIsLoading(false);
                    return refreshApex(this.records);
                }
                else{
                    console.log('No se  ha eliminado el registro del SP');
                    this.handleIsLoading(false);
                    return refreshApex(this.records);
                }
            })  
        }             
        
    }

    handleIsLoading(isLoading) {
        this.isLoadedAll = isLoading;
    }
}