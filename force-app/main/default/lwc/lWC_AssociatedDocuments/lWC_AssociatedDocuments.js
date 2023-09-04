import { LightningElement,api,track, wire } from 'lwc';
import getDocumentUploaded from '@salesforce/apex/APX_AssociatedDocuments.getDocumentUploaded';


export default class LWC_AssociatedDocuments extends LightningElement {
    
   @api recordId;   
   @track documentsUpload;
   @api spId;

   @wire(getDocumentUploaded,{recordId:'$recordId'}) 
   documentsF
   ({error,data}){                
        if(data){ 
            this.updateRecordView();               
            console.log('Documentos obtenidos en Associated Documents: ',data.length);            
            this.documentsUpload = data;            
            //this.updateRecordView();                                           
        }else if(error){
            console.error('checar el siguiente error (documentsF) ',error);
        }        
    }

    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
    }

    openfileUpload(event){
        this.template.querySelector('c-l-w-c-_-verificacion-_-pak-_-control').openfileUpload(event);
    }

    async refreshData() {
        await this.apiCallout();
      }
        
}