import { LightningElement, api } from "lwc";
import myModal2 from "c/p2G_asignarFolioEnOportunidad";
import myModal from "c/p2g_cargaProducto";

export default class P2g_nuevosNegocios extends LightningElement {
    @api recordId;

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

    connectedCallback() {
        // Este código se ejecutará cuando el componente se conecte a la interfaz de usuario
        console.log('recordId: ', this.recordId);
    }
}