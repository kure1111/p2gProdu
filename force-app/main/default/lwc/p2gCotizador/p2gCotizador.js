import { LightningElement, track } from 'lwc';
import cotizar from '@salesforce/apex/P2G_CotizadorCompra.cotizar';

export default class P2gCotizador extends LightningElement {
    origenId = null;
    destinoId = null;
    km = null;
    @track resultado = null;
    error = null;
    cargando = false;

    handleOrigen(event) {
        this.origenId = event.detail.recordId;
    }

    handleDestino(event) {
        this.destinoId = event.detail.recordId;
    }

    handleKm(event) {
        const valor = event.target.value;
        this.km = valor === '' || valor === null ? null : Number(valor);
    }

    get sinSeleccion() {
        return !this.origenId || !this.destinoId;
    }

    cotizarRuta() {
        this.error = null;
        this.resultado = null;
        this.cargando = true;
        cotizar({ origenId: this.origenId, destinoId: this.destinoId, kmManual: this.km })
            .then((r) => {
                this.resultado = r;
            })
            .catch((e) => {
                this.error = (e && e.body && e.body.message) ? e.body.message : 'Error al cotizar';
            })
            .finally(() => {
                this.cargando = false;
            });
    }

    get tieneCosto() {
        return this.resultado && this.resultado.costo !== null && this.resultado.costo !== undefined;
    }
}
