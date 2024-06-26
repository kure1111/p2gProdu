// p2g_monitoreoDisponibilidad.js
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
import getSstName from '@salesforce/apex/P2G_CreacionCargoLines.getSstName';
import getContainerType from '@salesforce/apex/P2G_CreacionCargoLines.getContainerType';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import obtenerDisponibilidades from '@salesforce/apex/P2G_DisponibilidadOfertada.obtenerDisponibilidades';
import creaImportExportQuote from '@salesforce/apex/P2G_DisponibilidadOfertada.creaImportExportQuote';
import deleteDis from '@salesforce/apex/P2G_DisponibilidadOfertada.deleteDis';
import updateDis from '@salesforce/apex/P2G_DisponibilidadOfertada.updateDis';

export default class P2G_MonitoreoDisponibilidad extends LightningElement {
    @track data;
    @track itemId;

    /*
        @track data = [
        { id: '1', ruta: 'CDMX-Toluca', fechaCreacion: '2024-04-15', fechaVigencia: '2024-05-15', num:'2',containerType: 'Tipo A', ticketProm: '12345', venta: '1000', carrier: 'Flete Nacional', planner: 'John Doe', folio: 'ABC123', bandera: 'Rojo' },
        { id: '2', ruta: 'Monterrey-Guadalajara', fechaCreacion: '2024-04-14', fechaVigencia: '2024-05-14', num:'2',containerType: 'Tipo B', ticketProm: '67890', venta: '1500', carrier: 'Flete Falso', planner: 'Jane Smith', folio: 'DEF456', bandera: 'Amarillo' },
        { id: '3', ruta: 'Tijuana-Mérida', fechaCreacion: '2024-04-13', fechaVigencia: '2024-05-13',num:'2', containerType: 'Tipo C', ticketProm: '54321', venta: '1200', carrier: 'Flete Nacional', planner: 'Bob Johnson', folio: 'GHI789', bandera: 'Verde' },
        { id: '4', ruta: 'Puebla-León', fechaCreacion: '2024-04-12', fechaVigencia: '2024-05-12',num:'2', containerType: 'Tipo D', ticketProm: '98765', venta: '1800', carrier: 'Flete Falso', planner: 'Alice Brown', folio: 'JKL012', bandera: 'Rojo' }
    ];
    */
    @track showModal = false;

    connectedCallback() {
        this.obtenerDisponibilidades();
        setInterval(() => {
            this.obtenerDisponibilidades();
        }, 3000); // 60 segundos
    }

    obtenerDisponibilidades(){
        obtenerDisponibilidades({op: 1})
        .then(result => {
            this.data = result;
            console.log('monitoreo Wrapper recibido:', this.wrapperObject);
        })
        .catch(error => {
            console.error('Error al llamar obtenerDisponibilidades:', error);
        });
    }

    // Método para obtener los datos con la clase CSS calculada
    get dataWithRowClass() {
        return this.data.map(item => ({
            ...item,
            rowClass: this.getRowClass(item.bandera)
        }));
    }

    getRowClass(bandera) {
        switch (bandera) {
            case 'Rojo':
                return 'slds-hint-parent slds-theme_red';
            case 'Amarillo':
                return 'slds-hint-parent slds-theme_yellow';
            case 'Verde':
                return 'slds-hint-parent slds-theme_green';
            default:
                return '';
        }
    }

    handleTakeClick(event) {
        this.showModal = true;
        this.itemId = event.target.value; // Obtener el valor del atributo 'value' del botón

    }

    handleDelete(event) {
        deleteDis({id: event.target.value})
        .then(result => {
            this.pushMessage('Exitoso!','success','se elimino con éxito!');
        })
        .catch(error => {
            this.pushMessage('Error','error', error.body.message);
        });

    }

    save() {
        this.showModal = false;
        const itemToSave = this.data.find(item => item.id === this.itemId);
        itemToSave.idUnidadPeso = this.searchValueIdClaveUnidadPeso;
        itemToSave.idAccount = this.idAccount;
        if (itemToSave) {
            this.procesarElementoEncontrado(itemToSave);
        } else {

            console.log('No se encontró ningún elemento con id:', this.itemId);
        }

    }

    procesarElementoEncontrado(item) {
        creaImportExportQuote({ fleteNacional: item })
        .then(result => {
            this.updateDataItem(result);
            this.pushMessage('Exitoso!','success','Se creo IEQO con exito!');
        })
        .catch(error => {
            this.pushMessage('Error','error', error.body.message);
        });
    }

    updateDataItem(updatedItem) {
        this.data = this.data.map(item => {
            return item.id === updatedItem.id ? updatedItem : item;
        });
    }

    // Manejador de evento para el botón "Cancel"
    handleCancel() {
        // Cerrar el modal sin guardar
        this.showModal = false;
    }

    //buscar account
    @track searchValueAccount;
    @track idAccount;
    @track listAccounts;
    SideSelectAccount(event){
        this.searchValueAccount = event.target.outerText;
        this.idAccount = event.currentTarget.dataset.id;
        this.listAccounts = null;

        if(event.currentTarget.dataset.sst !== undefined){
            this.searchKeyIdSST=event.currentTarget.dataset.sst;
            getSstName({idSst: this.searchKeyIdSST})
            .then(result => {
                this.searchSST=result.Name;
            })
            .catch(error => {
                this.pushMessage('Error','getSstName', error.body.message);
            });
        }
        else{
            this.searchSST = 'SERVICIOS LOGISTICOS NACIONALES FN (IC) (FN)';
            this.searchKeyIdSST='a1n4T000002JWphQAG'; //prod a1n4T000001XXYCQA4 UAT:a1n0R000001lZceQAE

        }
        console.log(this.searchKeyIdSST);
        console.log( this.searchSST);
        
    }
    searchKeyAccount(event){
        this.searchValueAccount = event.target.value;
        this.idAccount='';
        if (this.searchValueAccount.length >= 3) {
            getAccount({account: this.searchValueAccount})
                .then(result => {
                    this.listAccounts = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listAccounts = null;
                });
        }
        else{
            this.listAccounts = null;
        }
    }

    //Container Type
    @track searchValueConteiner;
    @track idConteiner;
    @track listContainers;
    SideSelectContainerType(event){
        this.searchValueConteiner = event.target.outerText;
        this.idConteiner = event.currentTarget.dataset.id;
        this.listContainers = null;
    }
    searchKeyContainerType(event){
        this.searchValueConteiner = event.target.value;
        this.idConteiner='';
        if (this.searchValueConteiner.length >= 3) {
            getContainerType({Container: this.searchValueConteiner})
                .then(result => {
                    this.listContainers = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listContainers = null;
                });
        }
        else{
            this.listContainers = null;
        }
    }

    //Clave unidad de Peso
    @track searchValueClaveUnidadPeso = '';
    @track searchValueIdClaveUnidadPeso = 'a3K4T000000SNdIUAW'; //prod a3K4T000000SNdIUAW,, uat a3n0R000000ETiqQAG,
    @track ListClavesUnidad;
    SideSelectClaveUnidadPeso(event){
        this.searchValueClaveUnidadPeso = event.target.outerText;
        this.searchValueIdClaveUnidadPeso = event.currentTarget.dataset.id;
        this.ListClavesUnidad = null;
    }
    searchKeyClaveUnidadPeso(event){
        this.searchValueClaveUnidadPeso = event.target.value;
        this.searchValueIdClaveUnidadPeso='';
        if (this.searchValueClaveUnidadPeso.length >= 3) {
            getClaveSAT({sat: this.searchValueClaveUnidadPeso,record: '4'})
                .then(result => {
                    this.ListClavesUnidad = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.ListClavesUnidad = null;
                });
        }
        else{
            this.ListClavesUnidad = null;
        }
    }
    
    //Clave Servicio SAT
    @track searchValueClaveServicio;
    @track searchValueIdClaveServicio;
    @track ListClaveServicio;
    @track materialPeligroso;
    SideSelectClaveServicio(event){
        this.materialPeligroso = false;
        this.searchValueClaveServicio = event.target.outerText;
        this.searchValueIdClaveServicio = event.currentTarget.dataset.id;
        for (let i in this.ListClaveServicio){
            if(this.searchValueIdClaveServicio == this.ListClaveServicio[i].Id && this.ListClaveServicio[i].Material_PeligrosoCP__c === true){
                this.materialPeligroso = true;
            }
        }
        this.ListClaveServicio=null;
    }
    searchKeyClaveServicio(event){
        this.searchValueClaveServicio = event.target.value;
        this.searchValueIdClaveServicio='';
        console.log('Entraa:', this.searchValueClaveServicio);
        if (this.searchValueClaveServicio.length >= 3) {
            getClaveSAT({sat: this.searchValueClaveServicio,record: '1'})
                .then(result => {
                    this.ListClaveServicio = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.ListClaveServicio = null;
                });
        }
        else{
            this.ListClaveServicio = null;
        }
    }

    @track descripcionProducto = '';
    @track units = '';
    @track pesoBruto = '';
    @track pesoNeto = '';
    @track currency = 'MXN';
    @track totalShippingVolume = '';

    // Función para manejar cambios en la descripción del producto
    handleDescriptionChange(event) {
        this.descripcionProducto = event.target.value;
    }

    // Función para manejar cambios en la cantidad de unidades
    handleUnitsChange(event) {
        this.units = event.target.value;
    }

    // Función para manejar cambios en el peso bruto
    handlePesoBrutoChange(event) {
        this.pesoBruto = event.target.value;
    }

    // Función para manejar cambios en el peso neto
    handlePesoNetoChange(event) {
        this.pesoNeto = event.target.value;
    }

    // Función para manejar cambios en la selección de moneda
    registroCurrency(event) {
        this.currency = event.target.value;
    }

    // Función para manejar cambios en el volumen total de envío
    registroTotalShippingVolume(event) {
        this.totalShippingVolume = event.target.value;
    }

    handleNameClick(event) {
        event.preventDefault(); // Previene la acción predeterminada del enlace
        const recordId = event.currentTarget.dataset.recordId;
    
        // Construye la URL del registro y redirige al usuario
        const recordUrl = `/lightning/r/Customer_Quote__c/${recordId}/view`;
        window.open(recordUrl, '_blank');
    }

    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }

        @track isInputModalOpen = false;
        @track idUpdate;
        inputValue = '';
    
        openInputModal(event) {
            this.isInputModalOpen = true;
            this.idUpdate = event.target.dataset.id;
        }
    
        closeInputModal() {
            this.isInputModalOpen = false;
        }
    
        handleInputChange(event) {
            this.inputValue = event.target.value;
        }
    
        handleSave() {
            updateDis({id: this.idUpdate, No:this.inputValue})
            .then(result => {
                this.pushMessage('Exitoso!','success','se actualizo con éxito!');
                this.obtenerDisponibilidades();
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
            });
            this.closeInputModal();
        }
}