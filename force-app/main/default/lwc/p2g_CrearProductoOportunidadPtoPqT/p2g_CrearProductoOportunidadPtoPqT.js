import { LightningElement, track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProductos from '@salesforce/apex/P2g_CrearProductoOpoPaqueteria.getProductos';
import csvProduct from '@salesforce/apex/P2g_CrearProductoOpoPaqueteria.getCsv';
import cargarProducto from '@salesforce/apex/P2g_CrearProductoOpoPaqueteria.cargarProducto';

export default class P2g_CrearProductoOportunidadPtoPqT extends LightningElement {
    @api recordId;
    @track listaProductos;
    @track cargaProducto;
    @track seleccionProducto = true;
    @track formularioProducto = false;
    @track idProducto;
    @track nameProducto;
    @track mensajeCreacion;
    produccion = true;
    @track valueURL;
    @track dioClic = false;

    //evento
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
    connectedCallback() {
        this.initializeComponent();
    }
    initializeComponent(){
        const urlParams = new URLSearchParams(window.location.search);
        this.recordId = urlParams.get('c__recordId');
        if(this.produccion === true){
            this.valueURL = "https://pak2gologistics.lightning.force.com/lightning/r/Opportunity/"+this.recordId+"/view";
        }else{
            this.valueURL = "https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Opportunity/"+this.recordId+"/view";
        }
        getProductos()
            .then(result => {
                this.listaProductos = result;
                console.log('la lista de productos es: '+ this.listaProductos);
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaProductos = error;
                console.log('error en la lista de productos: '+ error.body.message);
            });
        csvProduct()
            .then(result => {
                this.cargaProducto = result;
                console.log('el wrapper es: '+ this.cargaProducto);
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.cargaProducto = error;
                console.log('error en wrapper: '+ error.body.message);
            });
    }
    
    //valores status
    get optionsStatus() {
        return [
            { label: 'Cotizada', value: 'Cotizada' },
            { label: 'No Cotizada', value: 'No Cotizada' },
            { label: 'Pendiente por Cotizar', value: 'Pendiente por Cotizar' },
            { label: 'Rechazada', value: 'Rechazada' },
            { label: 'Aceptada', value: 'Aceptada' },
            { label: 'Negociación con cliente', value: 'Negociación con cliente' }
        ];
    }
    valueStatus = 'Pendiente por Cotizar';
    //valores Frecuencia
    get optionsFrecuencia() {
        return [
            { label: 'Diario', value: 'Diario' },
            { label: 'Semanal', value: 'Semanal' },
            { label: 'Mensual', value: 'Mensual' },
            { label: 'Anual', value: 'Anual' }
        ];
    }
    valueFrecuencia = '';
    // valores moneda
    optionsMoneda = [
        { label: 'MXN', value: 'MXN' },
        { label: 'USD', value: 'USD' },
        { label: 'EUR', value: 'EUR' }
    ];
    valueMoneda = 'MXN';

    seleccionaProducto(event){
        this.seleccionProducto = false;
        this.formularioProducto = true;
        this.idProducto = event.currentTarget.dataset.id;
        this.nameProducto = event.currentTarget.dataset.name;
    }
    agregarMoneda(event){
        this.valueMoneda = event.detail.value;
        this.cargaProducto.currencyOli = event.detail.value;
    }
    agregarStatus(event){
        this.valueStatus = event.detail.value;
        this.cargaProducto.status = event.detail.value;
    }
    agregarPrecioVenta(event){
        this.cargaProducto.precioVenta = event.detail.value;
    }
    agregarCantidad(event){
        this.cargaProducto.cantidad = event.detail.value;
    }
    agregarFrecuencia(event){
        this.cargaProducto.frecuencia = event.detail.value;
    }
    agregarComentario(event){
        this.cargaProducto.comentarios = event.target.value;
    }
    clicCrearProducto(){
        this.dioClic = true;
        this.llenarCargaProducto();
        console.log('carga de producto: '+ this.cargaProducto);
        const serializedItems = JSON.stringify(this.cargaProducto);
        cargarProducto({ jsonProduct: serializedItems})
            .then(result => {
                this.mensajeCreacion = result;
                if(this.mensajeCreacion === 'Exito'){
                    window.open(this.valueURL,"_self");
                    this.pushMessage('Exitoso!','success', 'Producto cargado con exito en la oportunidad');
                    console.log('el mensaje es: '+ this.mensajeCreacion+' la liga de regreso es: '+ this.valueURL);
                }else{
                    console.log('el mensaje es: '+ this.mensajeCreacion);
                    this.pushMessage('Error','error', this.mensajeCreacion);
                    this.dioClic = false;
                }
                
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.mensajeCreacion = error;
                console.log('error al crear producto: '+ error.body.message);
                this.dioClic = false;
            });
        
    }
    llenarCargaProducto(){
        this.cargaProducto.opportunityId = this.recordId;
        this.cargaProducto.pricebookEntryId = this.idProducto;
        this.cargaProducto.currencyOli = this.valueMoneda;
        this.listaProductos.map((producto) => {
            if (producto.id === this.idProducto) {
                this.cargaProducto.product2Id = producto.Product2Id;
            }
            return producto;
        });
    }
    regresaOppo(){
        window.open(this.valueURL,"_self");
    }
    volverProductos(){
        this.seleccionProducto = true;
        this.formularioProducto = false;
    }
}