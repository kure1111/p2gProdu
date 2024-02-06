import { LightningElement,track,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getIEQO from '@salesforce/apex/p2G_FoliosEnOportunidades.getIEQO';
import folioAsignado from '@salesforce/apex/p2G_FoliosEnOportunidades.asignarFolio';
import getRutas from '@salesforce/apex/p2G_FoliosEnOportunidades.getRoute';
import getWrapper from '@salesforce/apex/p2G_FoliosEnOportunidades.getWrapper';
import foliosACrear from '@salesforce/apex/p2G_FoliosEnOportunidades.foliosACrear';
import LightningModal from 'lightning/modal';

export default class P2G_asignarFolioEnOportunidad extends LightningModal {
    @api recordId;
    asignarCrearFolio = true;
    pag1 = true;
    asignarFolio = false;
    resFolioAsignado;
    creacionFolio = false;
    listRutas;
    wrapper;
    foliosParaCrear = 0;
    folioCreado;
    isLoading = false;

    @track sideRecordsAsignaFolio;
    searchValueAsignaFolio ='';
    searchValueIdAsignaFolio ='';
    showSideAsignaFolio = false;

//botones
    clickAsignarFolio(){
        this.asignarFolio = true;
        this.pag1 = false;
        console.log('el id de la oportunidad actual es',this.recordId);
    }
    clickCrearFolio(){
        this.creacionFolio = true;
        this.pag1 = false;
        console.log('el id de la oportunidad actual es',this.recordId);
        getRutas({idOpportunity: this.recordId})
                .then(result => {
                    this.listRutas = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.listRutas = null;
                });
        getWrapper()
            .then(result => {
                this.wrapper = result;
            })
            .catch(error => {
                this.showToast('Error','error', error.body.message);
                this.wrapper = null;
            });
    }
    clicSeCrea(event){
        const idProducto = event.target.closest('tr').dataset.id; 
        const seCrea = event.target.checked;
        //numero de rutas seleccionadas
        if(seCrea === true){
            this.foliosParaCrear = this.foliosParaCrear + 1;
        }else{
            this.foliosParaCrear = this.foliosParaCrear - 1;
        }
        console.log('El valor del check es: ', seCrea, ' folios Para Crear:',this.foliosParaCrear);
        //modificar registro
        const updatedlistRutas = this.listRutas.map( (item) => { 
            console.log('El item id: ', item.id ,' el producto ', idProducto);
            if (item.id === idProducto) { 
                return {...item, seCrea: seCrea, };
            } 
            return item; });
            this.listRutas = updatedlistRutas;
            console.log('la lista mod: ', this.listRutas);
        //aviso de 5 rutas seleccionadas
        if(this.foliosParaCrear === 5){
            this.showToast('Advertencia','warning', 'Se seleccionado 5 rutas para crear folios');
        }else if(this.foliosParaCrear > 5){
            this.showToast('Advertencia','warning', 'La ruta seleccionada se creara despues de unos minitos, le llegara un correo de confirmación');
        }
    }
    clicCrearFolios(){
        if(this.foliosParaCrear > 0){
            this.isLoading = true;
            for (let posicion in this.listRutas){
                if(this.listRutas[posicion].seCrea === true){
                    this.wrapper.push(this.listRutas[posicion]);
                    posicion++;
                    console.log('la posicion es',posicion,this.wrapper);
                }
            }
            //this.contenido = JSON.stringify(this.wrapper);
            console.log('El wrapper es',this.wrapper);
            foliosACrear({wrapperProduct: this.wrapper})
                .then(result => {
                    this.isLoading = false;
                    this.folioCreado = result;
                    if(this.folioCreado === 'Los folios fueron creados correctamente'){
                        this.showToast('Operación Exitosa','success', this.folioCreado);
                        this.close('close');location.reload();
                    }else if(this.folioCreado === 'Los folios se crearon sin cargo line'){
                        this.showToast('Advertencia','warning', this.folioCreado);
                        this.close('close');location.reload();
                    }else{
                        this.showToast('Error','error', this.folioCreado);
                    }
                })
                .catch(error => {
                    this.isLoading = false;
                    this.showToast('Error','error', error.body.message);
                    this.folioCreado = null;
                }); 
        }else{ 
            this.showToast('Error','error', 'Seleccionar una ruta para crear un folio');
        } 
    }
    clicAtras(){
        this.pag1 = true;
        this.asignarFolio = false;
        this.creacionFolio = false;
    }
// Cerrar
    clicCerrar(){
        this.close('close');
        //this.dispatchEvent(new CloseActionScreenEvent());
        //location.reload(); //para actualizar la pagina
    }
//Asignar folio
    guardarFolio(){
        if (typeof this.searchValueAsignaFolio === 'undefined' || this.searchValueAsignaFolio === null || this.searchValueAsignaFolio === '') {
        this.showToast('ERROR','error', 'Favor de seleccionar un folio');
        return
        }
        this.isLoading = true;
        folioAsignado({idOppo: this.recordId, folio: this.searchValueIdAsignaFolio})
                .then(result => {
                    this.resFolioAsignado = result;
                    this.isLoading = false;
                    if(this.resFolioAsignado === 'Actualizacion Exitosa'){
                        this.showToast('Operación Exitosa','success', 'Se asigno correctamente el folio a la oportunidad');
                        this.close('close');location.reload();
                    }else{
                        this.showToast('Error','error', this.resFolioAsignado);
                    }
                })
                .catch(error => {
                    this.isLoading = false;
                    console.log('entra al catch');
                    this.showToast('Error','error', error.body.message);
                    this.resFolioAsignado = null;
                });
    }

//Buscar Folio
    SideSelectAsignaFolio(event){
        this.searchValueAsignaFolio = event.target.outerText;
        this.searchValueIdAsignaFolio = event.currentTarget.dataset.id;
        this.showSideAsignaFolio = false;
    }
    searchKeyAsignaFolio(event){
        this.searchValueAsignaFolio = event.target.value;
        this.searchValueIdAsignaFolio='';
        if (this.searchValueAsignaFolio.length >= 3) {
            this.showSideAsignaFolio = true;
            getIEQO({idOppo: this.recordId, folio: this.searchValueAsignaFolio})
                .then(result => {
                    this.sideRecordsAsignaFolio = result;
                })
                .catch(error => {
                    console.log('entra al catch');
                    this.showToast('Error','error', error.body.message);
                    this.sideRecordsAsignaFolio = null;
                });
        }
        else{
            this.showSideAsignaFolio = false;
        }
    }
    showToast(title, variant, message) {
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