import { LightningElement, api, track, wire } from 'lwc';
//import uploadFile from '@salesforce/apex/APX_Verificacion_Pak_Control.uploadFile';
//import uploadFileSF from '@salesforce/apex/APX_Verificacion_Pak_Control.uploadFileSF';
import getSp from '@salesforce/apex/APX_Verificacion_Pak_Control.getRecord';
import cancelModal from '@salesforce/apex/APX_Verificacion_Pak_Control.cancelModal';
import updateShipmentObject from '@salesforce/apex/APX_Verificacion_Pak_Control.updateShipmentObject';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import STATUS_PLANNER from '@salesforce/schema/Shipment__c.Shipment_Status_Plann__c';
import VERIFICACIONPAK from '@salesforce/schema/Shipment__c.VERIFY_PAK_CONTROL__c'; // campo para mostrar el modal junto con bandera
import SERVICE from '@salesforce/schema/Shipment__c.ShipmentService__c'; // campo para saber que servicio tiene el SP
import updateShipmentData from '@salesforce/apex/APX_Verificacion_Pak_Control.updateShipmentData';
import validateAllDocuments from '@salesforce/apex/APX_AssociatedDocuments.ValidateAllDocuments';
const FIELDS=[STATUS_PLANNER,VERIFICACIONPAK,SERVICE];
const STATUS = 'Confirmed';


export default class LWC_Verificacion_Pak_Control extends LightningElement {
   @api recordId;
   fileData     
   @track fileId;
      //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
   @track isModalOpen = true;
   @track isCredito = false;
   @track isContado = true;
   @track itsAlldocumentsUp = false;    
   @track itsAllOK = false;
   @track documentosFaltantes;
   isLoadedAll=true;  

   //Variable para visualizar el modal, se activa cuando esta en true
   @track bandera; 
   shipment;
   @track pakVerificacion;    
    
    
   @wire(validateAllDocuments,{recordId:'$recordId'})
   validate({ error, data }){
        if (error) {
            console.log('error occured in validateAllDocuments');
        } else if (data) {
            console.log('lo que regresa validate documents up',data.documentsUpWrap);
            console.log('lo que regresa validate messageST',data.messageST);
            if(data.messageST != null){
                this.documentosFaltantes=data.messageST;
                this.itsAlldocumentsUp=false;
            }
            else{
                this.documentosFaltantes=null;
                this.itsAlldocumentsUp=true;
            }

        }
   }
   
   @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
   wiredRecord({ error, data }) {
       if (error) {
          console.log('error occured: ' + error.body.message);
       } else if (data) {            
        this.isLoadedAll=false;
        this.shipment = data;            
           let modifiedDate = this.shipment.lastModifiedDate;            

           if(!this.lastModifiedDate) {                
               this.lastModifiedDate = this.shipment.lastModifiedDate;
           }    
           
           let estatus = getFieldValue(this.shipment, STATUS_PLANNER);
           let vPak = getFieldValue(this.shipment, VERIFICACIONPAK);
           let servicio = getFieldValue(this.shipment, SERVICE);
           let ser = false;

           console.log('Servicio del SP: ' + servicio);

           if(estatus != STATUS){
               console.log('No son iguales: ');
               this.bandera = false;
           }            

           else if(estatus == STATUS){
               console.log('Son iguales... ');
               this.bandera = true;
           }
           
           if(!vPak){
                this.pakVerificacion = false;
           }
           else if(vPak){
                this.pakVerificacion = true;
           }

           if(servicio == 'SP-FN'){            
                ser = true;
           }else{
                this.bandera = false;
                this.pakVerificacion = true;
           }


           if (modifiedDate != this.lastModifiedDate && this.bandera && !this.pakVerificacion && ser) {
                console.log('Activando modal....');                              
                this.bandera = true;               
           }
       }
   }
   
    @wire(getSp,{spId:'$recordId'}) 
    records;
      
   textValue;

//    
   _title = 'Shipment No confirmado';
   message = 'Favor de llenar los campos faltantes';
   variant = 'error';
   variantOptions = [
       { label: 'error', value: 'error' },
       { label: 'warning', value: 'warning' },
       { label: 'success', value: 'success' },
       { label: 'info', value: 'info' },
   ];

   titleChange(event) {
       this._title = event.target.value;
   }

   messageChange(event) {
       this.message = event.target.value;
   }

   variantChange(event) {
       this.variant = event.target.value;
   }

    showNotification() {
       const evt = new ShowToastEvent({
           title: this._title,
           message: this.message,
           variant: this.variant,
       });
       this.dispatchEvent(evt);
   }
// 

    handleInputFocus(event) {
        // modify parent to properly highlight visually
        const classList = event.target.parentNode.classList;
        classList.add('lgc-highlight');
    }

    handleInputBlur(event) {
        // modify parent to properly remove highlight
        const classList = event.target.parentNode.classList;
        classList.remove('lgc-highlight');
    }

    handleInputChange(event) {
        this.textValue = event.detail.value;
    }

   openModal() {
       // to open modal set isModalOpen tarck value as true
       this.isModalOpen = true;
   }
   closeModal() {
       // to close modal set isModalOpen tarck value as false
       //Cuando cierran el modal, se va actualizar el Shipment status planner en: In Progress  
       cancelModal({recordId: this.recordId})
       .then(result =>{
            console.debug('Actualizando status.....');
            console.debug('Recargando pagina.....');
            window.location.reload();
         
         //this.updateRecordView();
       }).catch(error =>{
            console.log('Error: ' + error);
            this._title = 'Ocurrido un error';
            this.message = error.body.message;//'No se ha podido cambiar de estatus, el Shipment necesita tener: Carrier, Vehiculo y Operador (Operator 1)';
            this.variant = 'error'; 
            this.showNotification()
            this.updateRecordView();               
       })
       this.isModalOpen = false;
   }
   submitDetails() {
       // to close modal set isModalOpen tarck value as false
       //Add your code to call apex method or do some processing
       this.isModalOpen = false;
   }
    
   
   @api openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }

    /*handleClick(){

        const {base64, filename, recordId} = this.fileData                   
            
        uploadFileSF({base64:base64,filename:filename,recordId:recordId})
        .then(result =>{
            this.fileData = null;                      

            let title = result + " uploaded successfully"
            this.success(title)
        })
        .catch(error =>{
            log.message('Error: '  + error);
            this._title = 'Ocurrio un erro al subir el archivo';
            this.message = error;
            this.variant = 'error';            
            this.showNotification()   
        })
        uploadFile({ fileContent:base64, filename:filename, idRecord:recordId }).then(result=>{
            console.log('file name: ' + result);

            if(result == null){

                this.badError("Ocurrio un error al subir el archivo...");
            }

            this.fileData = null
            let title = result + ' uploaded successfully!!';
            this.success(title)
        })       
    }*/

    badError(title){

        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent)

    }


    success(title){
        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent)
    }
    
    get acceptedFormats() {
        return ['.pdf', '.png', '.csv', '.doc', '.docx'];
    }    

    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
     }

     
     validateFieds(event){
        refreshApex(this.validate);
        // validateAllDocuments({recordId:this.recordId})
        // .then(result =>{

        //     if(result){
        //         console.log('lo que regresa validate documents up',result.documentsUpWrap);
        //         console.log('lo que regresa validate messageST',result.messageST);

        //         if(result.messageST != null){
        //             this.documentosFaltantes=result.messageST;
        //             this.itsAlldocumentsUp=false;
        //         }
        //         if (result.messageST == null||result.messageST == undefined){
        //             this.documentosFaltantes=result.messageST;
        //             this.itsAlldocumentsUp=true;
        //         }
        //         this.updateRecordView();
        //     }
        // })
        // .catch(error =>{
        //     console.log('Ocurrio un error');
        //     this._title = 'Ocurrio un error';
        //     this.message = error.body.message;
        //     this.variant = 'error';            
        //     this.showNotification();
        //     this.isLoadedAll=false;
        // });
        

        console.log('Current value of the input: ' + event.target.value);

        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);        

        var companiaGps = this.template.querySelector('.companiaGPS');
        var ligaCuenta = this.template.querySelector('.ligaCuenta');
        var usuarioCuenta = this.template.querySelector('.usuarioCuenta');
        var passwordCuenta = this.template.querySelector('.passwordCuenta');

        var aseguradoraN = this.template.querySelector('.aseguradoraN');
        var registrationN  = this.template.querySelector('.registrationN');
        var polizaCarga  = this.template.querySelector('.polizaCarga');
        var polizaResp  = this.template.querySelector('.polizaResp');
        var polizaSeguro  = this.template.querySelector('.polizaSeguro');

        var numLicVig = this.template.querySelector('.numLicVig');
        var licenciaVigente  = this.template.querySelector('.licenciaVigente');        
        var fechaVigencia  = this.template.querySelector('.fechaVigencia');
        var telefonoFijo  = this.template.querySelector('.telefonoFijo');

        //Arreglos para actualizar Shipment, Vehiculo, Operador y Account
        console.log('Arreglos para actualizar');
        var shipmentRecord ={                       
            Liga_Cuenta_Espejo__c: ligaCuenta.value,
            Usuario_Cuenta_Espejo__c: usuarioCuenta.value,
            Contrasena_Cuenta_Espejo__c: passwordCuenta.value
        } 
        console.log('shipmentRecord'+shipmentRecord.value);               
        var vehiculoRecord ={      
            Nombre_Aseguradora__c: aseguradoraN.value,             
            Registration_Number__c: registrationN.value,
            Numero_Poliza_Seguro__c: polizaCarga.value,
            Poliza_Responsabilidad_civil__c: polizaResp.value,
            Poliza_Seguro_Medio_Ambiente__c: polizaSeguro.value
        }

        var operadorRecord = {
            Numlicvig_ope__c:numLicVig.value,
            Licvig_ope__c: true,//licenciaVigente.value,
            Fecha_de_vigencia_de_la_licencia__c : fechaVigencia.value,
            Telfij_ope__c : telefonoFijo.value
        }
        
        // updateShipmentCheck({recordId:this.recordId})
        // .then(result =>{   
        //     console.log('ACtualizacion de check pak control')                                         
        // })
        // .catch(error =>{
        //     log.message('Error: '  + error);
        //     this._title = 'Ocurrio un erro al al activar pak control';
        //     this.message = 'Ocurrio un erro al actualizar los datos: ' + error;
        //     this.variant = 'error';            
        //     this.showNotification();   
        // });
        
        this.isLoadedAll=true;
        console.log('itsAlldocumentsUp: ',this.itsAlldocumentsUp);
        if (allValid && (this.itsAlldocumentsUp || !this.itsAlldocumentsUp)) {
            console.log('Todos los campos tiene registro...');                                                                
            updateShipmentData({recordId:this.recordId,spData:shipmentRecord,vData:vehiculoRecord,opeData:operadorRecord,carrierGPS:companiaGps.value})
            .then(result =>{                                            
                this._title = '';
                this.message = result;
                this.variant = 'success';
                this.showNotification()
                this.updateRecordView()
                this.isModalOpen = false; ///Al mandar el mensaje success se va a cerrar el modal
                this.isLoadedAll=false;
            })
            .catch(error =>{

                log.message('Error: '  + error);
                this._title = 'Ocurrio un erro al validar los datos';
                this.message = 'Ocurrio un erro al actualizar los datos: ' + error;
                this.variant = 'error';            
                this.showNotification();
                this.isLoadedAll=false;     
            });
            shipmentRecord = {};
            vehiculoRecord = {};
            operadorRecord = {};

        } else if(!allValid){            
            console.log('Todos los campos no tiene registro...');
            this._title = 'Ocurrio un error';
            this.message = 'No ha registrado todos los campos';
            this.variant = 'error';            
            this.showNotification();
            this.isLoadedAll=false;
            
        }
            
     }

    //Metodo para obtener el id del objeto en el lookup 
    onAccountSelection(event){          

        this.handleIsLoading(true);
        let objId = event.detail.selectedRecordId;
        console.log('Id: ' +objId);
        updateShipmentObject({spId:this.recordId,objId:objId})
        .then(result =>{
            this._title = 'Se ha registrado el ' + result + ' correctamente';  
            this.message = null;          
            this.variant = 'success';            
            this.showNotification()   
            objId = null;
            this.isLoadedAll = null;
            return refreshApex(this.records);            
        })
        .catch(error =>{
            this._title = 'Ocurrio un error al registrar el ' + error;            
            this.variant = 'error';
            this.message = null;             
            this.showNotification() 
            objId = null;
            this.isLoadedAll = null;
            return refreshApex(this.records);
        })
        //console.log('Id: ' +event.detail.selectedRecordId);        
    } 

    //Metodo para actualizar el SP para mostrar el lookup
    /*changeData(){
        this.handleIsLoading(true);
        console.log('entrando1');
        const objId =  this.template.querySelector('.idV').value;  
        console.log('objId: ' + objId);

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
        
    }*/
    
    handleIsLoading(isLoading) {
        this.isLoadedAll = isLoading;
    }
    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
     }
}