import { LightningElement,track,wire,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getServiceLine from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getLineSp';
import getStatusClose from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getStatusClose';
import updateStatus from '@salesforce/apex/P2G_UpdateShipmentServiceLine.updateStatus';
import getCarrier from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getCarrier';
//import getShipName from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getShipmentName';
import getWrapper from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getwrapper';
import ChangeLine from '@salesforce/apex/P2G_UpdateShipmentServiceLine.ChangeLine';
import getSst from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getSapServiceTypeShipment';
import getSstNfiltro from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getSst';

export default class P2G_LWC_ChangeCarrier extends LightningElement {
    @api recordId;
    @wire(getServiceLine, {Id: '$recordId'}) listServiceLine;
    shipName;
   /* @wire(getShipName, {Id: '$recordId'}) 
    shipmentName({data,error}){
        if (data) {
            this.shipName = data.Name;
            console.log('entra en data: ',this.shipName);
        }else if(error){
            console.error('el error es: ' + error.body.message);
        }
    }*/

    @track sideRecordsCarrier;
    searchValueCarrier = "";
    searchValueIdCarrier ='';
    showSideCarrier = false;

    @track sideRecordsSstb;
    searchValueSstb = "";
    searchValueIdSstb ='';
    showSideSstb = false;

    @track sideRecordsSsts;
    searchValueSsts = "";
    searchValueIdSsts ='';
    showSideSsts = false;

    @track showAdvertencia;
    updateEsc = false;

    contenido='';
    rowIndex;

    handleOkay() {
        updateStatus({Id: this.recordId, status:'Confirmed'})
                        .then(result => {
                            this.showAdvertencia = false;
                            this.updateEsc = true;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.showAdvertencia = true;
                            this.updateEsc = false;
                        });
        
    }
    connectedCallback() {
        this.initializeComponent();
    }
    
    initializeComponent(){
        getStatusClose({Id: this.recordId})
                        .then(result => {
                            this.showAdvertencia = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error en initializeComponent','error', error.body.message);
                            this.showAdvertencia = true;                        
                        });
    }

    //para ver el message en pantalla
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }

    searchKeyCarrier(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;  
        const rowElement = event.target.closest('tr');
        //const rowKey = rowElement.getAttribute('key');
        const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
        this.rowIndex = rowIndex;
        //console.log('Número de fila:', rowIndex);
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            const itemToUpdate = updatedListServiceLine[indexToUpdate];
            const updatedItem = { ...itemToUpdate, listCarrier: true }; // Actualizar el valor de listCarrier a true
            updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        //console.log('actualzia carrier: ', this.listServiceLine);

        for (let posicion in this.listServiceLine.data){ 
            if (this.listServiceLine.data[posicion].Id === IdServiceLine) {
                this.searchValueCarrier = event.target.value; 
                this.searchValueIdCarrier='';
                this.showSideCarrier = true;            
                if (this.searchValueCarrier.length >= 3) {
                    getCarrier({carrier: this.searchValueCarrier})
                        .then(result => {
                            this.sideRecordsCarrier = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.sideRecordsCarrier = null;
                        });
                }
                else{
                    this.showSideCarrier = false;
                }
             }};
    }
    
    SideSelectCarrier(event) {
        this.showSideCarrier = false;
        const searchValueIdCarrier = event.currentTarget.dataset.id;

        //const IdServiceLine = event.target.closest('tr').dataset.id;
        const carrierName = event.target.closest('tr').querySelector('.slds-truncate:first-child').innerText;
        
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, CarrierName: carrierName , CarrierId:searchValueIdCarrier, listCarrier: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        this.searchValueCarrier = carrierName;
    }
    closelistCarrier(){
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, listCarrier: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        //console.log('la lista mod: ', this.listServiceLine);
        //console.log('Número de fila Carrier:', rowIndex);
        return refreshApex(this.listServiceLine);
    }
    clearCarrier(event){
        if (!event.target.value.length) {
            const rowElement = event.target.closest('tr');
            const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
            const indexToUpdate = rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
            const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
            if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            
                const itemToUpdate = updatedListServiceLine[indexToUpdate];
                const updatedItem = { ...itemToUpdate, CarrierName: null , CarrierId: null};
                updatedListServiceLine[indexToUpdate] = updatedItem;
            }      
            this.listServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod!: ', this.listServiceLine);
        }
    }
    
    searchKeySstb(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;  
        const rowElement = event.target.closest('tr');
        //const rowKey = rowElement.getAttribute('key');
        const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
        this.rowIndex = rowIndex;
        //console.log('Número de fila:', rowIndex);
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            const itemToUpdate = updatedListServiceLine[indexToUpdate];
            const updatedItem = { ...itemToUpdate, listSstb: true }; // Actualizar el valor de listCarrier a true
            updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        //console.log('actualzia carrier: ', this.listServiceLine);

        for (let posicion in this.listServiceLine.data){ 
            if (this.listServiceLine.data[posicion].Id === IdServiceLine) {
                this.searchValueSstb = event.target.value; 
                this.searchValueIdSstb='';
                this.showSideSstb = true;            
                if (this.searchValueSstb.length >= 3) {
                    getSstNfiltro({SapService: this.searchValueSstb, IdShip: this.recordId})
                        .then(result => {
                            this.sideRecordsSstb = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.sideRecordsSstb = null;
                        });
                }
                else{
                    this.showSideSstb = false;
                }
             }};
    }
    SideSelectSstb(event) {
        this.showSideSstb = false;
        const searchValueIdSstb = event.currentTarget.dataset.id;

        //const IdServiceLine = event.target.closest('tr').dataset.id;
        const SstbName = event.target.closest('tr').querySelector('.slds-truncate:first-child').innerText;
        
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, SapServiceTypeBuy: SstbName , SapServiceTypeBuyId:searchValueIdSstb, listSstb: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        this.searchValueSstb = SstbName;
        //console.log('El sap buy', SstbName);
        //console.log('El Id sap', this.searchValueIdSstb);
        console.log('la lista mod: ', this.listServiceLine);
        //console.log('Número de fila sstb:', rowIndex);
    }
    closelistSstb(){
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, listSstb: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        //console.log('la lista mod: ', this.listServiceLine);
        //console.log('Número de fila sstb:', rowIndex);
        return refreshApex(this.listServiceLine);
    }
    clearSstb(event){
        if (!event.target.value.length) {
            const rowElement = event.target.closest('tr');
            const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
            const indexToUpdate = rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
            const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
            if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            
                const itemToUpdate = updatedListServiceLine[indexToUpdate];
                const updatedItem = { ...itemToUpdate, SapServiceTypeBuy: null , SapServiceTypeBuyId: null};
                updatedListServiceLine[indexToUpdate] = updatedItem;
            }      
            this.listServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod!: ', this.listServiceLine);
        }
    }
    //
    searchKeySsts(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;  
        const rowElement = event.target.closest('tr');
        //const rowKey = rowElement.getAttribute('key');
        const rowIndex = Array.from(rowElement.parentNode.children).indexOf(rowElement);
        this.rowIndex = rowIndex;
        console.log('Número de fila:', rowIndex);
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
            const itemToUpdate = updatedListServiceLine[indexToUpdate];
            const updatedItem = { ...itemToUpdate, listSsts: true }; // Actualizar el valor de listCarrier a true
            updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        //console.log('actualzia ssts: ', this.listServiceLine);

        for (let posicion in this.listServiceLine.data){ 
            if (this.listServiceLine.data[posicion].Id === IdServiceLine) {
                this.searchValueSsts = event.target.value; 
                this.searchValueIdSsts='';
                this.showSideSsts = true;            
                if (this.searchValueSsts.length >= 3) {
                    getSst({SapService: this.searchValueSsts, IdShip: this.recordId})
                        .then(result => {
                            this.sideRecordsSsts = result;
                        })
                        .catch(error => {
                            this.pushMessage('Error','error', error.body.message);
                            this.sideRecordsSsts = null;
                        });
                }
                else{
                    this.showSideSstss = false;
                }
             }};
    }
    SideSelectSsts(event) {
        this.showSideSsts = false;
        const searchValueIdSsts = event.currentTarget.dataset.id;
        const SstsName = event.target.closest('tr').querySelector('.slds-truncate:first-child').innerText;
        
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, SapServiceType: SstsName , SapServiceTypeId:searchValueIdSsts, listSsts: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        this.searchValueSsts = SstsName;
        //console.log('la lista mod: ', this.listServiceLine);
    }
    closelistSsts(){
        const indexToUpdate = this.rowIndex; // Índice del elemento que deseas actualizar (por ejemplo, la posición 1)
        const updatedListServiceLine = [...this.listServiceLine.data]; // Crear una copia de la lista actual
        
        if (indexToUpdate >= 0 && indexToUpdate < updatedListServiceLine.length) {
          const itemToUpdate = updatedListServiceLine[indexToUpdate];
          const updatedItem = { ...itemToUpdate, listSsts: false};
          updatedListServiceLine[indexToUpdate] = updatedItem;
        }      
        this.listServiceLine = { data: updatedListServiceLine };
        console.log('la lista mod: ', this.listServiceLine);
        console.log('Número de fila sstb:', rowIndex);
        return refreshApex(this.listServiceLine);
    }
    
    ShipmentSellPrice(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;
        const SellPrice = event.target.value;
        const updatedListServiceLine = this.listServiceLine.data.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, ShipmentSellPrice: SellPrice, };
            } 
            return item; });
            this.listServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod: ', this.listServiceLine);
    }
    
    ShipmentBuyPric(event){
        const IdServiceLine = event.target.closest('tr').dataset.id;
        const BuyPrice = event.target.value;
        const updatedListServiceLine = this.listServiceLine.data.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item,
                    ShipmentBuyPrice: BuyPrice,
                  };
            } 
            return item; });
            this.listServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod: ', this.listServiceLine);
    }
    Change(event){
        const IdServiceLine = event.target.closest('tr').dataset.id; // Obtiene el identificador de la fila donde se realizó el cambio 
        const seModifica = event.target.checked;
        console.log('El valor del check es: ', seModifica);
        // Mapea la lista de service lines y actualiza el precio de venta en la fila correspondiente
        const updatedListServiceLine = this.listServiceLine.data.map( (item) => { 
            if (item.Id === IdServiceLine) { 
                return {...item, seModifica: seModifica, };
            } 
            return item; }); // Actualiza la lista de service lines con los valores actualizados
            this.listServiceLine = { data: updatedListServiceLine };
            console.log('la lista mod: ', this.listServiceLine);
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

    updateLines(){
        for (let posicion in this.listServiceLine.data){
            if(this.listServiceLine.data[posicion].seModifica === true){
                this.wrapper[posicion] = this.listServiceLine.data[posicion];
                this.nWrapper = posicion++;
            }
          }
        this.contenido = JSON.stringify(this.wrapper);
        console.log('El wrapper es',this.wrapper);
        if(this.wrapper != {} && this.nWrapper>=0){
            ChangeLine({line: this.contenido, numLinea: this.nWrapper})
                .then(result => {
                    this.updateLine = result;
                    this.pushMessage('Exitoso!','success','Se actualizo con exito!');
                    this.close();
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.updateLine = null;
                });
        }else{ this.pushMessage('Error','error', 'Seleccionar una service Line para modificar');}  
        return refreshApex(this.listServiceLine);
    }

    close() {
        if(this.updateEsc)
        updateStatus({Id: this.recordId, status:'Closed'})
        .then(result => {
            this.updateEsc = false;
        })
        .catch(error => {
            this.pushMessage('Error','error', error.body.message);
            this.updateEsc = false;
        });
        const closeModalEvent = new CustomEvent("modalclose");
        this.dispatchEvent(closeModalEvent);
        location.reload();
    }
}