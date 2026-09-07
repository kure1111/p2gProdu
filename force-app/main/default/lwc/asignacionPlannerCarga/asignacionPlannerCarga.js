import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import descargarBase from '@salesforce/apex/AsignacionPlannerCtrl.descargarBase';
import subirBase from '@salesforce/apex/AsignacionPlannerCtrl.subirBase';

export default class AsignacionPlannerCarga extends LightningElement {
    @track resultado;
    cargando = false;
    reemplazarTodo = false;
    nombreArchivo = '';
    filasLeidas = 0;
    filas = [];

    get subirDeshabilitado() {
        return this.cargando || this.filas.length === 0;
    }
    get hayErrores() {
        return this.resultado && this.resultado.errores && this.resultado.errores.length > 0;
    }
    get hayAvisos() {
        return this.resultado && this.resultado.avisos && this.resultado.avisos.length > 0;
    }

    cambiarReemplazo(e) {
        this.reemplazarTodo = e.target.checked;
    }

    async descargar() {
        this.cargando = true;
        try {
            const datos = await descargarBase();
            const enc = (v) => {
                const s = v === null || v === undefined ? '' : String(v);
                return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
            };
            const lineas = ['Ruta,Ruta Consolidada,Planner,Activa'];
            for (const f of datos) {
                lineas.push([enc(f.ruta), enc(f.consolidada), enc(f.planner), enc(f.activa)].join(','));
            }
            // BOM para que Excel abra bien los acentos
            const blob = new Blob(['﻿' + lineas.join('\r\n')], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const hoy = new Date().toISOString().slice(0, 10);
            const a = document.createElement('a');
            a.setAttribute('href', url);
            a.setAttribute('download', 'base-planner-' + hoy + '.csv');
            a.setAttribute('target', '_self');
            // en Lightning el link debe estar en el DOM para que respete el nombre del archivo
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            setTimeout(() => URL.revokeObjectURL(url), 1000);
            this.toast('Listo', datos.length + ' rutas descargadas', 'success');
        } catch (e) {
            this.toast('Error al descargar', this.mensajeError(e), 'error');
        } finally {
            this.cargando = false;
        }
    }

    archivoSeleccionado(e) {
        const archivo = e.target.files && e.target.files[0];
        this.resultado = undefined;
        this.filas = [];
        this.filasLeidas = 0;
        this.nombreArchivo = '';
        if (!archivo) return;
        const lector = new FileReader();
        lector.onload = () => {
            try {
                this.filas = this.parsearCsv(lector.result);
                this.filasLeidas = this.filas.length;
                this.nombreArchivo = archivo.name;
                if (this.filas.length === 0) {
                    this.toast('Archivo vacío', 'No se encontraron filas con datos', 'warning');
                }
            } catch (err) {
                this.toast('Archivo inválido', err.message, 'error');
            }
        };
        lector.readAsText(archivo);
    }

    parsearCsv(texto) {
        // parser simple con soporte de comillas
        const filas = [];
        let campo = '', linea = [], enComillas = false;
        const t = texto.replace(/^﻿/, '');
        const empujar = () => { linea.push(campo); campo = ''; };
        const cerrarLinea = () => {
            if (linea.length > 1 || (linea.length === 1 && linea[0].trim() !== '')) filas.push(linea);
            linea = [];
        };
        for (let i = 0; i < t.length; i++) {
            const c = t[i];
            if (enComillas) {
                if (c === '"') {
                    if (t[i + 1] === '"') { campo += '"'; i++; } else { enComillas = false; }
                } else campo += c;
            } else if (c === '"') enComillas = true;
            else if (c === ',') empujar();
            else if (c === '\n') { empujar(); cerrarLinea(); }
            else if (c !== '\r') campo += c;
        }
        empujar(); cerrarLinea();

        if (filas.length < 2) return [];
        const encabezado = filas[0].map(h => h.trim().toLowerCase());
        const idx = (nombres) => encabezado.findIndex(h => nombres.some(n => h.startsWith(n)));
        const iRuta = idx(['ruta']);
        const iCons = encabezado.findIndex(h => h.startsWith('ruta consolidada'));
        const iPlanner = idx(['planner', 'planer']);
        const iActiva = idx(['activa', 'activo']);
        if (iRuta < 0 || iPlanner < 0) {
            throw new Error('El CSV debe tener al menos las columnas "Ruta" y "Planner"');
        }
        // ojo: si "ruta" e "ruta consolidada" comparten prefijo, iRuta podria caer en consolidada
        const iRutaReal = encabezado.findIndex(h => h === 'ruta' || h === 'last shipment: route');
        const colRuta = iRutaReal >= 0 ? iRutaReal : iRuta;
        return filas.slice(1).map(f => ({
            ruta: (f[colRuta] || '').trim(),
            consolidada: iCons >= 0 ? (f[iCons] || '').trim() : '',
            planner: (f[iPlanner] || '').trim(),
            activa: iActiva >= 0 ? (f[iActiva] || '').trim() : ''
        })).filter(f => f.ruta !== '' || f.planner !== '');
    }

    async subir() {
        this.cargando = true;
        this.resultado = undefined;
        try {
            const res = await subirBase({
                jsonFilas: JSON.stringify(this.filas),
                reemplazarTodo: this.reemplazarTodo
            });
            this.resultado = res;
            const variante = res.conError > 0 ? 'warning' : 'success';
            this.toast('Carga terminada',
                res.creados + ' creadas, ' + res.actualizados + ' actualizadas, '
                + res.desactivados + ' desactivadas, ' + res.conError + ' con error', variante);
        } catch (e) {
            this.toast('Error al subir', this.mensajeError(e), 'error');
        } finally {
            this.cargando = false;
        }
    }

    mensajeError(e) {
        return (e && e.body && e.body.message) ? e.body.message : String(e);
    }

    toast(titulo, mensaje, variante) {
        this.dispatchEvent(new ShowToastEvent({ title: titulo, message: mensaje, variant: variante }));
    }
}
