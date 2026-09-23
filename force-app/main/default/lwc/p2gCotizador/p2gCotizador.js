import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import cotizar from '@salesforce/apex/P2G_CotizadorCompra.cotizar';

const CAMPOS_LOC = ['Location__c.Name'];
const MARGEN_ALERTA = 10; // % debajo del cual se avisa que el margen esta bajo

export default class P2gCotizador extends LightningElement {
    origenId = null;
    destinoId = null;
    km = null;
    @track resultado = null;
    // Decision humana: el motor sugiere, la persona de pricing ajusta y decide
    margen = null;
    venta = null;
    error = null;
    cargando = false;
    copiado = false;

    @wire(getRecord, { recordId: '$origenId', fields: CAMPOS_LOC }) origenRec;
    @wire(getRecord, { recordId: '$destinoId', fields: CAMPOS_LOC }) destinoRec;

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
        this.margen = null;
        this.venta = null;
        this.copiado = false;
        this.cargando = true;
        cotizar({ origenId: this.origenId, destinoId: this.destinoId, kmManual: this.km })
            .then((r) => {
                this.resultado = r;
                this.margen = r.margenPct;
                this.venta = r.ventaSugerida === null || r.ventaSugerida === undefined
                    ? null : Math.round(r.ventaSugerida);
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

    // Margen y precio de venta ligados: editar uno recalcula el otro
    handleMargen(event) {
        const valor = event.target.value;
        this.margen = valor === '' || valor === null ? null : Number(valor);
        this.copiado = false;
        if (this.tieneCosto && this.margen !== null && this.margen < 100) {
            this.venta = Math.round(this.resultado.costo / (1 - this.margen / 100));
        }
    }

    handleVenta(event) {
        const valor = event.target.value;
        this.venta = valor === '' || valor === null ? null : Number(valor);
        this.copiado = false;
        if (this.tieneCosto && this.venta > 0) {
            this.margen = Math.round((1 - this.resultado.costo / this.venta) * 1000) / 10;
        }
    }

    get utilidad() {
        return (this.tieneCosto && this.venta !== null && this.venta !== undefined)
            ? this.venta - this.resultado.costo : null;
    }

    get tieneUtilidad() {
        return this.utilidad !== null;
    }

    get ventaBajoCosto() {
        return this.utilidad !== null && this.utilidad < 0;
    }

    get margenBajo() {
        return !this.ventaBajoCosto && this.margen !== null && this.margen < MARGEN_ALERTA;
    }

    get etiquetaConfianza() {
        return this.resultado ? 'Confianza ' + this.resultado.confianza : '';
    }

    get badgeClass() {
        const base = 'slds-badge ';
        if (!this.resultado) { return base; }
        if (this.resultado.confianza === 'Alta') { return base + 'slds-theme_success'; }
        if (this.resultado.confianza === 'Media') { return base + 'slds-theme_warning'; }
        return base + 'slds-theme_error';
    }

    get etiquetaCopiar() {
        return this.copiado ? 'Copiado ✓' : 'Copiar resumen';
    }

    nombreDe(rec) {
        return (rec && rec.data && rec.data.fields && rec.data.fields.Name)
            ? rec.data.fields.Name.value : '';
    }

    copiarResumen() {
        const r = this.resultado;
        const pesos = (n) => '$' + Math.round(n).toLocaleString('es-MX');
        const lineas = [
            'Cotización FN ' + this.nombreDe(this.origenRec) + ' → ' + this.nombreDe(this.destinoRec),
            'Costo estimado de compra: ' + pesos(r.costo) + (r.km ? ' (' + r.km + ' km)' : ''),
            'Precio de venta: ' + pesos(this.venta) + ' (margen ' + this.margen + '%)',
            'Confianza: ' + r.confianza + ' — ' + r.fuente
        ];
        if (r.pedirProveedor) {
            lineas.push('OJO: confirmar precio con proveedor antes de comprometer.');
        }
        navigator.clipboard.writeText(lineas.join('\n')).then(() => {
            this.copiado = true;
        }).catch(() => {
            this.error = 'No se pudo copiar al portapapeles';
        });
    }
}
