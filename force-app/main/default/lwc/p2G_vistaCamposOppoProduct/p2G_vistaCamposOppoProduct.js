import { LightningElement, track, api} from 'lwc';
import getFiles from '@salesforce/apex/P2G_loadProducts.getFiles';
import getproducto from '@salesforce/apex/P2G_loadProducts.getproducto';
import updateNotas from '@salesforce/apex/P2G_loadProducts.updateNotas';

export default class P2G_vistaCamposOppoProduct extends LightningElement {
    @api recordId;

    @track vistaPMFC = false;
    @track vistaPMFAC = false;
    @track vistaPM = false;
    @track vistaPMFA = false;
    @track vistaFA = false;
    @track vistaF = false;
    @track vistaAC = false;
    @track vistaC = false;
    @track vistaS = false;
    @track vistaIncoterm = false;
    @track nota;
    @track grupo;
    @track producto;
    @track modifica = false;
    @track simodifico;
    @track files;
    @track listFiles;
    @track sifiles = false;
    @track esFN = false;

    connectedCallback() {
        getproducto({idOli: this.recordId})
            .then(result => {
                this.producto = result;
                this.grupo = this.producto[0].Opportunity.Group__c;
                this.tipogrupo(this.grupo);
                this.nota = this.producto[0].Notas__c;
                console.log('valor notas: ',this.nota);
            })
            .catch(error => {
                this.showToast('Error al traer información del Producto','error', error.body.message);
            });
        /*getFiles({idOli: this.recordId})
            .then(result => {
                this.listFiles = result;
                this.files = listFiles.map(file => ({
                    Id: file.Id,
                    Title: file.Title,
                    VersionData: `/sfc/servlet.shepherd/document/download/${file.ContentDocumentId}`,
                    FileExtension: file.FileExtension
                }));
                this.listFiles = true;
            })
            .catch(error => {
                this.showToast('Error al traer información del Producto','error', error.body.message);
            });*/
    }
    tipogrupo(grupo){
        switch (grupo) {
            case 'SP-PTO-PUERTOS':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaPM = true;
                this.vistaPMFA = true;
                this.opPM = true;
                this.vistaIncoterm = true;
                break;
            case 'SP-M-MARITIMO':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaPM = true;
                this.vistaPMFA = true;
                this.vistaIncoterm = true;
                break;
            case 'SP-FI-FLETE INTER':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaPMFA = true;
                this.vistaFA = true;
                this.vistaF = true;
                this.vistaIncoterm = true;
                break;
            case 'SP-A-AEREO':
                this.vistaPMFAC = true;
                this.vistaPMFA = true;
                this.vistaFA = true;
                this.vistaAC = true;
                this.vistaIncoterm = true;
                break;
            case 'SP-CE-COMERCIO EXT':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaAC = true;
                this.vistaC = true;
                this.vistaS = true;
                this.vistaIncoterm = true;
                break;
            case 'SP-EX-SEGUROS':
                this.vistaS = true;
                this.vistaIncoterm = true;
                break;
            case 'SP-FN-FLETE NACIONAL':
                    this.esFN = true;
                    break;
            default:
                // Tratar variantes desconocidas
                break;
        }
    }
    abrirModificar(){
        this.modifica = true;
    }
    updateNotas(event){
        this.producto[0].Notas__c = event.target.value;
    }
    clicGuardar(){
        updateNotas({idOli: this.recordId, notas: this.producto[0].Notas__c})
            .then(result => {
                this.modifica = false; //false
            })
            .catch(error => {
                this.showToast('Error al traer información del Producto','error', error.body.message);
            });
    }
}