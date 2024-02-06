// p2g_cargaProducto.js
import { LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpportunityLineItems from '@salesforce/apex/P2G_loadProducts.getOpportunityLineItems';
import createProduct from '@salesforce/apex/P2G_loadProducts.handleProduct';
import getCountry from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getContainerType from '@salesforce/apex/P2G_CreacionCargoLines.getContainerType';
import getCsv from '@salesforce/apex/P2G_loadProducts.getCsv';
import updateItems from '@salesforce/apex/P2G_loadProducts.updateOli';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import LightningModal from 'lightning/modal';

export default class P2g_cargaProducto extends LightningModal {
    @api recordId;
    @track isLoading = false;

    @track obj;
    @track selectedFrecuencia;
    @track opportunityLineItems;
    @track unitPerFrequency;
    @track weight;
    @track loadingAddress;
    @track unloadingAddress;
    @track quantity;
    @track timeLoad;
    @track timeUnload;
    @track comentarios;
    @track buyPrice;

    frecuenciaOptions = [
        { label: 'Diario', value: 'Diario' },
        { label: 'Semanal', value: 'Semanal' },
        { label: 'Mensual', value: 'Mensual' },
        { label: 'Anual', value: 'Anual' }
    ];

    handleFrecuenciaChange(event) {
        this.selectedFrecuencia = event.detail.value;
        this.obj.frecuencia = event.detail.value;
    }

    connectedCallback() {
        getCsv()
            .then(result => {
                this.obj = result;
            })
            .catch(csvError => {
                console.error('Error al cargar csv');
            });
            setTimeout(() => {
                this.rellenaLista();
            }, 400);
    }

    rellenaLista(){
        getOpportunityLineItems({ opportunityId: this.recordId})
        .then(result => {
            this.opportunityLineItems = result;
            console.log('se llama rellena ', this.opportunityLineItems);
        })
        .catch(error => {
            //this.pushMessage('Error','error', error.body.message);
            console.error('Error rellenaLista');
        });

    }

    handleInputChange(event) {
        const IdOli = event.target.closest('tr').dataset.id;
        const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
            if (oli.IdOli === IdOli) {
                return { ...oli, [event.target.name]: event.target.value };
            }
            return oli;
        });
        this.opportunityLineItems = updatedOpportunityLineItems;
    }

    handleCheck(event) {
        const IdOli = event.target.closest('tr').dataset.id;
        //click
        const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
            if (oli.IdOli === IdOli) {
                return { ...oli, modificar: event.target.checked };
            }
            return oli;
        });
    
        this.opportunityLineItems = updatedOpportunityLineItems;
    }

    
    @track searchMercancia2;
    @track showMercancia2 = false;
    @track idTemporal;

    mercanciaSelect2(event){   
        this.searchMercancia2 = event.currentTarget.dataset.name;
        const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
            if (oli.IdOli === this.idTemporal) {
                return { ...oli, tipoMercancia: this.searchMercancia2, showFila:false};
            }
            return oli;
        });
        this.opportunityLineItems = updatedOpportunityLineItems;
        this.idTemporal='';
    }

    searchKeyMercancia2(event){
        this.searchMercancia2 = event.target.value;
        if (this.searchMercancia2.length >= 3) {
            const IdOli = event.target.closest('tr').dataset.id;
            this.idTemporal = IdOli;
            const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
                if (oli.IdOli === IdOli) {
                    return { ...oli, showFila: true};
                }
                return oli;
            });
            this.opportunityLineItems = updatedOpportunityLineItems;
            getClaveSAT({sat: this.searchMercancia2,record: '1'})
            .then(result => {
                this.listMercancia2 = result;
            })
            .catch(error => {
                this.showToast('Error', ' Carga de Mercancia: ' + error.body.message, 'error');
                this.listMercancia2 = null;
            });
        }
    }


    updateItems(event){
        this.isLoading = true;
        const itemsToModify = this.opportunityLineItems.filter(oli => oli.modificar);

        if (itemsToModify.length > 0) {
            const serializedItems = JSON.stringify(itemsToModify);
            updateItems({ jsonProduct: serializedItems})
            .then(() => {
                this.rellenaLista();
                this.showToast('Éxito', 'La operación se completó con éxito', 'success');
            })
            .catch(error => {
                //this.pushMessage('Error','error', error.body.message);
                this.showToast('Error', 'Se produjo un error durante la operación', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
            
        } 
        else {
            this.isLoading = false;
            this.showToast('warning', 'No ha seleccinoado lineas', 'warning');
        }

    }

    //Origen
    @track searchOrigen = '';
    @track OrigenId = '';
    @track showOrigen = false;

    origenSelect(event){
        this.searchOrigen = event.currentTarget.dataset.name;
        this.showOrigen = false;
        this.OrigenId = event.currentTarget.dataset.id;
        this.obj.origenId = event.currentTarget.dataset.id;
        this.obj.origen = event.target.outerText;
    }
    searchKeyOrigen(event){
        this.searchOrigen = event.target.value;
        this.OrigenId='';
        if (this.searchOrigen.length >= 3) {
            this.showOrigen = true;
            getCountry({country: this.searchOrigen})
                .then(result => {
                    this.listOrige = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listOrige = null;
                });
        }
        else{
            this.showOrigen = false;
        }
    }

    @track searchDestino = '';
    @track destinoId = '';
    @track showDestino = false;

    searchKeyDestino(event){
        this.searchDestino = event.target.value;
        this.destinoId = '';
        if (this.searchDestino.length >= 3) {
            this.showDestino = true;
            getCountry({ country: this.searchDestino })
                .then(result => {
                    this.listDestino = result;
                })
                .catch(error => {
                    this.listDestino = [];
                });
        } else {
            this.showDestino = false;
        }
    }
    destinoSelect(event){
        this.searchDestino = event.currentTarget.dataset.name;
        this.showDestino = false;
        this.destinoId = event.currentTarget.dataset.id;
        this.obj.destinoId = event.currentTarget.dataset.id;
        this.obj.destino = event.target.outerText;
    }

    //ContainerType
    searchModalidad ='';
    modalidadId ='';
    showModalidad = false;
    
    selectModalidad(event){
        this.searchModalidad = event.currentTarget.dataset.name;
        this.showModalidad = false;
        this.modalidadId = event.currentTarget.dataset.id;
        this.obj.modalidad = event.target.outerText;
    }

    searchKeyModalidad(event){
        this.searchModalidad = event.target.value;
        this.modalidadId='';
        if (this.searchModalidad.length > 2) {
            this.showModalidad = true;
            getContainerType({Container: this.searchModalidad})
                .then(result => {
                    this.listModalidad = result;
                })
                .catch(error => {
                    this.listModalidad = null;
                });
        }
        else{
            this.showModalidad = false;
        }
    }

        //Tipo Mercancia
        @track searchMercancia = '';
        @track showMercancia = false;
    
        mercanciaSelect(event){   
            this.searchMercancia = event.currentTarget.dataset.name;
            this.showMercancia = false;
        }
        searchKeyMercancia(event){
            this.searchMercancia = event.target.value;
            if (this.searchMercancia.length >= 3) {
                this.showMercancia = true;
                getClaveSAT({sat: this.searchMercancia,record: '1'})
                .then(result => {
                    this.listMercancia = result;
                })
                .catch(error => {
                    this.showToast('Error', ' Carga de Mercancia: ' + error.body.message, 'error');
                    this.listMercancia = null;
                });
            }
            else{
                this.showMercancia = false;
            }
        }

    //Es para agregar un nuevo producto
    aceptar() {

        if (!this.isValid()) {
            // Si no son válidos, muestra un mensaje de advertencia
            this.showToast('Error', 'Faltan campos requeridos','error');
            return;
        }

        this.isLoading = true;
        this.obj.unidadPorFrecuencia = this.unitPerFrequency;
        this.obj.tipoMercancia = this.searchMercancia;
        this.obj.pesoDeCarga = this.weight;
        this.obj.direccionCarga = this.loadingAddress;
        this.obj.direccionDescarga = this.unloadingAddress;
        this.obj.cantidad = this.quantity;
        this.obj.tiempoCarga = this.timeLoad;
        this.obj.tiempoDescarga = this.timeUnload;
        this.obj.comentarios = this.comentarios;
        const serializedObj = JSON.stringify(this.obj);

        createProduct({opportunityId: this.recordId, jsonProduct: serializedObj})
        .then(result => {
            for (let key in this.obj) {
                if (this.obj.hasOwnProperty(key)) {
                    this.obj[key] = '';  // o cualquier valor predeterminado
                }
            }

            this.searchOrigen='';
            this.searchDestino='';
            this.selectedFrecuencia = '';
            this.searchModalidad = '';
            
            this.unitPerFrequency ='';
            this.searchMercancia = '';
            this.weight='';
            this.loadingAddress='';
            this.unloadingAddress='';
            this.quantity='';
            this.timeLoad='';
            this.timeUnload='';
            this.comentarios='';
            this.buyPrice='';
            this.rellenaLista();
            this.showToast('Éxito', 'Operación completada exitosamente.', 'success');
        })
        .catch(error => {
            this.showToast('Error', 'No se pudo crear Contacte a su Administrador: ' + error.body.message, 'error');
        })
        .finally(() => {
            this.isLoading = false;
        }); 
        
    }

    isValid() {
        const requiredFields = [
            this.searchOrigen,
            this.searchDestino,
            this.searchModalidad,
            this.unitPerFrequency,
            this.searchMercancia,
            this.weight,
            this.loadingAddress,
            this.unloadingAddress,
            this.quantity,
            this.timeLoad,
            this.timeUnload
        ];
    
        // Verifica si alguno de los campos requeridos es nulo o vacío
        return requiredFields.every(field => field !== undefined && field !== '' && field !== null);
    }
    


    cerrar(){
        this.close('close');
        //history.back();
        //this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleChange(event) {
        const fieldName = event.target.dataset.fieldname;
        const value = event.target.value;
        this[fieldName] = value;
    }

    showToast(title, message, variant) {
        switch (variant) {
            case 'success':
                this.showSuccess = true;
                this.successMessage = message;
                this.successClass = 'success-message';
                break;
            case 'warning':
                this.showWarning = true;
                this.warningMessage = message;
                this.warningClass = 'warning-message';
                break;
            case 'error':
                this.showError = true;
                this.errorMessage = message;
                this.errorClass = 'error-message';
                break;
            default:
                // Tratar variantes desconocidas
                break;
        }
    
        // Ocultar mensajes después de un tiempo determinado
        setTimeout(() => {
            this.showSuccess = this.showWarning = this.showError = false;
        }, 3500);
    }

@track showWarning = false;
@track warningMessage = '';
@track warningClass = '';

@track showSuccess = false;
@track successMessage = '';
@track successClass = '';

@track showError = false;
@track errorMessage = '';
@track errorClass = '';

closeMessage() {
    this.showSuccess = this.showWarning = this.showError = false;
}

}