import { LightningElement, api, wire } from 'lwc';
import uploadFileSF from '@salesforce/apex/APX_UploadFiles.uploadFileSF';
import uploadFile from '@salesforce/apex/APX_UploadFiles.uploadFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDocumentUploaded from '@salesforce/apex/APX_AssociatedDocuments.getDocumentUploaded';
import validateAllDocuments from '@salesforce/apex/APX_AssociatedDocuments.ValidateAllDocuments';
import validateDocument from '@salesforce/apex/OCR_API.getImageText';
import {refreshApex} from '@salesforce/apex';
import MensajeOCR1 from '@salesforce/resourceUrl/MensajeOCR1';
import MensajeOCR2 from '@salesforce/resourceUrl/MensajeOCR2';
import MensajeOCR3 from '@salesforce/resourceUrl/MensajeOCR3';
import MensajeOCR4 from '@salesforce/resourceUrl/MensajeOCR4';

export default class LWC_UploadFiles extends LightningElement {


    @api recordid;
    @api spId;
    fileData
    isLoadedAll;
    @api documentType; 
    
    resultValidationDoc;
    
    MensajeUrl;
    isModalOpen;

    disableButton = true; //deshabilitar boton si no ha cargado nada...           
    documentName;

    title;
    message;
    variant;    


    @wire(getDocumentUploaded,{recordId:'$recordid'}) 
    documentsF

    @wire(validateAllDocuments,{recordId:'$spId'})
    validateDocuments;
  
    openfileUpload(event) {
        this.changeDisableButton(false);
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64                
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }

    handleClick(){
        this.handleIsLoading(true);
        console.log('Id atrapado: ' + this.recordid);
        console.log('Id sp: ' + this.spId);
        console.log('document type: ' + this.documentType);
        const {base64, filename} = this.fileData  
        var name = null;         
        

        uploadFileSF({base64:base64,filename:filename,recordId:this.recordid, documentType: this.documentType})
        .then(result =>{                                  
            this.documentName = result.Title;
            this.documentID = result.Id;
            console.log('Lo que regresa uploadFileSF: ',result);
            console.log('documentName: ',result.Title);
            console.log('documentID: ',result.Id);
            console.log('this.documentID: ',this.documentID);
            console.log('Tipo de Documento: ',this.documentType);
            this.fileData = null;                                  
            console.log('Nombre: ' + result);                    
            name = result;             
            console.log('dentro del metodo: ' + this.documentName);                    

            if(this.documentType=='Licencia'||this.documentType=='Poliza Vigente y del Prestador'||this.documentType=='Tarjeta Circulacion'||this.documentType=='Tercerizado'){
                 console.log("Entrando a :",this.documentType);
                 validateDocument({records:this.recordid,IdDocument:this.documentID,documentType: this.documentType})
                 .then(result => {
                     this.resultValidationDoc=result;
                     console.log("lo que responde el servicio de OCR: ",result);
                     if(result.Succes==true){
                         console.log("Entrando a licencia true");
                         uploadFile({fileContent:base64,filename:filename,idRecord:this.recordid,nameFile:this.documentName,documentType:this.documentType})
                         .then(result =>{            
                            this.title = 'Se ha guardado el archivo correctamente';
                            this.message = result + " uploaded successfully";
                            this.variant = 'success'; 
                            this.updateRecordView();                      
                            this.showNotification();
                            this.changeDisableButton(true);
                            this.handleIsLoading(false); 
                            refreshApex(this.documentsF);
                            refreshApex(this.validateDocuments);
                         })   
                     }
                     else if(result.ShowMessage1){
                         this.MensajeUrl = MensajeOCR1;
                         this.isModalOpen = true;
                         this.title = 'Ocurrio un error al subir el archivo';
                         this.message = 'El Archivo que intentas  subir no es legible';
                         this.variant = 'error';
                         this.showNotification();
                         this.handleIsLoading(false);
                     }
                     else if(result.ShowMessage2){
                         this.MensajeUrl = MensajeOCR2;
                         this.isModalOpen = true;
                         this.title = 'Ocurrio un error al subir el archivo';
                         this.message = 'El Archivo que intentas  subir no concuerda con el registro';
                         this.variant = 'error';
                         this.showNotification();
                         this.handleIsLoading(false);
                     }
                     else if(result.ShowMessage3){
                         this.MensajeUrl = MensajeOCR3;
                         this.isModalOpen = true;
                         this.title = 'Ocurrio un error al subir el archivo';
                         this.message = 'El Archivo que intentas  subir no concuerda con el registro';
                         this.variant = 'error';
                         this.showNotification();
                         this.handleIsLoading(false);
                     }
                     else if(result.ShowMessage4){
                         this.MensajeUrl = MensajeOCR4;
                         this.isModalOpen = true;
                         this.title = 'Ocurrio un error al subir el archivo';
                         this.message = 'El Archivo que intentas  subir no concuerda con el registro';
                         this.variant = 'error';
                         this.showNotification();
                         this.handleIsLoading(false);
                     }

                 })
                 .catch(error=>{ console.log('thenCatchApproach error =>',error.body.message);})
             } 
             else{
                 uploadFile({fileContent:base64,filename:filename,idRecord:this.recordid,nameFile:this.documentName,documentType:this.documentType})
                 .then(result =>{            
                    this.title = 'Se ha guardado el archivo correctamente';
                    this.message = result + " uploaded successfully";
                    this.variant = 'success'; 
                    this.updateRecordView();                      
                    this.showNotification();
                    this.changeDisableButton(true);
                    this.handleIsLoading(false); 
                    refreshApex(this.documentsF);
                    refreshApex(this.validateDocuments);
                 })   

             }
             
            
            // deleteFileSF({title:this.documentName})
            // .then(result =>{

            //     if(result){
            //         this.title = 'Se ha eliminado el archivo de SF correctamente';
            //         this.message = '';
            //         this.variant = 'success';

            //     }else{
            //         this.title = 'Ocurrio un error al subir el archivo';
            //         this.message = '';
            //         this.variant = 'error';
            //     }

            // })

            /*uploadFile({fileContent:base64,filename:filename,idRecord:this.recordid,nameFile:this.documentName,documentType:this.documentType})
            .then(result =>{            
                this.title = 'Se ha guardado el archivo correctamente';
                this.message = result + " uploaded successfully";
                this.variant = 'success'; 
                this.updateRecordView();                      
                this.showNotification();
                this.changeDisableButton(true);
                this.handleIsLoading(false); 
                //return refreshApex(this.documentsF, this.validateDocuments);                                                             
                refreshApex(this.documentsF);
                refreshApex(this.validateDocuments);
            })
            .catch(error =>{
                console.log('Ocurrio un error en el metodo uploadFile del la clase APX_UploadFiles: ' + error);               
                this.handleIsLoading(false);                             
                this.updateRecordView();
                this.changeDisableButton(true);   
            })*/
            
        })      
        .catch(error =>{
            console.log(`thenCatchApproach error => ${error}.`);
            this.title = 'Ocurrio un error al subir el archivo';
            this.message = error.body.message;
            this.variant = 'error';
            this.handleIsLoading(false);             
            this.showNotification();            
            this.updateRecordView();
            this.changeDisableButton(true);   
        })                  
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this.title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

   

    //Obtenemos el id del objeto que este llamando
    @api getRecordId(id){
        this.recordid = id;
    }

    /*@api getObjectName(name){
        this.objectName = name;
    } */   

    @api getDocumentType(type){
        this.documentType = type;
    }   

    //show/hide spinner
    handleIsLoading(isLoading) {
        this.isLoadedAll = isLoading;
    }
    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
    }

    changeDisableButton(isChange){
        this.disableButton = isChange;
    }
    closeModal() {
        this.isModalOpen = false;
    }
}