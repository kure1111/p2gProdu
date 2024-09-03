import { LightningElement, api, track } from "lwc";
import myModal2 from "c/p2G_asignarFolioEnOportunidad";
import myModal from "c/p2g_cargaProducto";
import infoGrupo from '@salesforce/apex/P2G_loadProducts.infoGrupo';
import p2G_newSubProducto from "c/p2G_newSubProducto";

export default class P2g_nuevosNegocios extends LightningElement {
    @api recordId;
    //@track creaSubproducto = false;
    @track grupo;
    @track cargarProducto = true;
    async handleClick1() {
        console.log('id es: ', this.recordId);
        const result = await myModal.open({
            size: 'large',
            description: 'Modal para cargar',
            recordId: this.recordId,
            label: 'Modal Heading'
        });
        console.log(result);
    }

    async handleClick2() {
        console.log('id es: ', this.recordId);
        const result = await myModal2.open({
            size: 'medium',
            description: 'Modal para cargar',
            recordId: this.recordId,
            label: 'Modal Heading'
        });
        console.log(result);
    }
    handleNewSubProducto(event) {
        console.log(event.detail.message);
        
    }
    handleClick3() {
        //this.creaSubproducto = true;
        const newSubProductoEvent = new CustomEvent('newsubproducto', {
            detail: { message: 'New SubProducto clicked from another button'}
        });
        this.template.querySelector('c-p2g_new_sub_producto').dispatchEvent(newSubProductoEvent);
    }
    connectedCallback() {
        // Este código se ejecutará cuando el componente se conecte a la interfaz de usuario
        console.log('recordId: ', this.recordId);
        infoGrupo({idOppo: this.recordId})
            .then(result => {
                this.inforGrupo = result;
                this.grupo = this.inforGrupo.Group__c;
                console.log('el grupo',this.grupo);
                if((this.grupo === 'SP-PQ-PAQUETERIA') || (this.grupo === 'SP-WH-ALMACENAJE') || (this.grupo === 'SP-T-CONSOLIDADO')){
                    console.log('Entra en el if de grupo');
                    this.cargarProducto = false;
                }
            })
            .catch(error => {
                this.showToast('Error al cargar informacion del Producto','error', error.body.message);
            });
    }
}