import { LightningElement,api,wire,track } from 'lwc';
import getInfoMetadata from '@salesforce/apex/APX_AssociatedDocuments.getInfoMetadata';

export default class LWC_AssociatedDocuments_Uploader extends LightningElement {
    
    @track listDocuments = [];
    @api recordId;
    @track documentType;   


    @wire(getInfoMetadata,{recordId:'$recordId'}) 
    documentosRequeridos({error,data}){
        if (data) {
                console.log('Documentos obtenidos en AD Uploader: ',data.length);
                for(const list of data){                    
                    const option = {
                        label: list,
                        value: list
                    };
                    // this.listDocuments.push(option);
                    this.listDocuments = [ ...this.listDocuments, option ];
                }                
            // this.listDocuments=data; 
        }else if(error){
            console.error('checar el siguiente error en AD Uploader: ',error);
        }        
    }

    handleChange(event) {
        this.documentType = event.detail.value;
    }   
   
}