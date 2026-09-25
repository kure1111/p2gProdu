import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import cotizar from '@salesforce/apex/P2G_CotizadorCompra.cotizar';
import explicar from '@salesforce/apex/P2G_CotizadorCompra.explicar';

const CAMPOS_LOC = ['Location__c.Name'];
const MARGEN_ALERTA = 10; // % debajo del cual se avisa que el margen esta bajo

const pesos = (n) => (n === null || n === undefined) ? '—' : '$' + Math.round(n).toLocaleString('es-MX');
const num = (n) => (n === null || n === undefined) ? '—' : Number(n).toLocaleString('es-MX');

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
    // Panel "¿Cómo se calculó?": se pide aparte para no encarecer el cotizar diario
    @track explicacion = null;
    mostrarExplicacion = false;
    cargandoExplicacion = false;
    copiadoExp = false;
    paramsCotizados = null;

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
        this.explicacion = null;
        this.mostrarExplicacion = false;
        this.copiadoExp = false;
        this.cargando = true;
        // La explicación se amarra a ESTOS parámetros aunque el usuario mueva los pickers después
        this.paramsCotizados = { origenId: this.origenId, destinoId: this.destinoId, kmManual: this.km };
        cotizar(this.paramsCotizados)
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

    // ---------- Panel "¿Cómo se calculó?" ----------

    get etiquetaExplicar() {
        return this.mostrarExplicacion ? 'Ocultar el cálculo' : '¿Cómo se calculó?';
    }

    get tieneMuestra() {
        return this.explicacion && this.explicacion.muestra && this.explicacion.muestra.length > 0;
    }

    get etiquetaCopiarExp() {
        return this.copiadoExp ? 'Copiado ✓' : 'Copiar el detalle';
    }

    verComoSeCalculo() {
        if (this.explicacion) {
            this.mostrarExplicacion = !this.mostrarExplicacion;
            return;
        }
        this.cargandoExplicacion = true;
        explicar(this.paramsCotizados)
            .then((e) => {
                this.explicacion = this.procesaExplicacion(e);
                this.mostrarExplicacion = true;
            })
            .catch((e) => {
                this.error = (e && e.body && e.body.message) ? e.body.message : 'Error al explicar el cálculo';
            })
            .finally(() => {
                this.cargandoExplicacion = false;
            });
    }

    procesaExplicacion(e) {
        const niveles = (e.niveles || []).map((n) => ({
            key: n.nivel,
            titulo: n.nivel + ' · ' + n.nombre,
            queBusco: n.queBusco,
            viajes: n.viajes === null || n.viajes === undefined ? 0 : n.viajes,
            minimoTxt: n.minimo === null || n.minimo === undefined ? '—' : n.minimo,
            medianaTxt: pesos(n.mediana),
            porKmTxt: n.porKm === null || n.porKm === undefined ? '—' : num(n.porKm),
            veredicto: n.veredicto,
            clase: n.usado ? 'nivel-usado' : ''
        }));
        const muestra = (e.muestra || []).map((v, i) => ({
            key: i,
            folio: v.folio || '—',
            fechaTxt: v.fecha || '—',
            transportista: v.transportista || '—',
            buyTxt: pesos(v.buy),
            kmTxt: num(v.km),
            sentido: v.sentido || '—',
            marcador: v.esMediana ? '★ mediana' : '',
            clase: v.esMediana ? 'fila-mediana' : ''
        }));
        const r = e.resultado || {};
        const dispersionTxt = e.minimoBuy === null || e.minimoBuy === undefined ? '' :
            'Dispersión: mín ' + pesos(e.minimoBuy) + ' · p25 ' + pesos(e.p25) + ' · mediana ' + pesos(r.costo) +
            ' · p75 ' + pesos(e.p75) + ' · máx ' + pesos(e.maximoBuy) +
            (e.viajeMasViejo ? ' — viajes del ' + e.viajeMasViejo + ' al ' + e.viajeMasReciente : '');
        const idaVueltaTxt = (e.viajesIda === null || e.viajesIda === undefined) ? '' :
            'Sentido (búsqueda bidireccional): ' + e.viajesIda + ' de ida, ' + e.viajesVuelta + ' de vuelta.';
        const ventaTxt = r.ventaSugerida === null || r.ventaSugerida === undefined ? '' :
            'Venta sugerida: ' + pesos(r.ventaSugerida) + ' = costo ÷ ' + (1 - r.margenPct / 100) + ' (margen del ' + r.margenPct + '% sobre venta).';
        return {
            niveles,
            muestra,
            notaMuestra: e.notaMuestra || '',
            origenKmTxt: 'Kilómetros: ' + (e.origenKm || '—'),
            dispersionTxt,
            idaVueltaTxt,
            ventaTxt
        };
    }

    copiarExplicacion() {
        const x = this.explicacion;
        const lineas = [
            'Cotización FN ' + this.nombreDe(this.origenRec) + ' → ' + this.nombreDe(this.destinoRec) + ' — cómo se calculó',
            x.origenKmTxt,
            '',
            'Cascada:'
        ];
        x.niveles.forEach((n) => {
            lineas.push('  ' + n.titulo + ' | ' + n.queBusco + ' | viajes: ' + n.viajes + ' (mín ' + n.minimoTxt + ') | mediana: ' + n.medianaTxt + ' | $/km: ' + n.porKmTxt + ' | ' + n.veredicto);
        });
        if (x.dispersionTxt) { lineas.push('', x.dispersionTxt, x.idaVueltaTxt); }
        if (x.muestra.length > 0) {
            lineas.push('', 'Viajes de la muestra (folio | fecha | transportista | buy | km | sentido):');
            x.muestra.forEach((v) => {
                lineas.push('  ' + v.folio + ' | ' + v.fechaTxt + ' | ' + v.transportista + ' | ' + v.buyTxt + ' | ' + v.kmTxt + ' | ' + v.sentido + (v.marcador ? ' | ' + v.marcador : ''));
            });
        }
        if (x.notaMuestra) { lineas.push(x.notaMuestra); }
        if (x.ventaTxt) { lineas.push('', x.ventaTxt); }
        navigator.clipboard.writeText(lineas.join('\n')).then(() => {
            this.copiadoExp = true;
        }).catch(() => {
            this.error = 'No se pudo copiar al portapapeles';
        });
    }
}
