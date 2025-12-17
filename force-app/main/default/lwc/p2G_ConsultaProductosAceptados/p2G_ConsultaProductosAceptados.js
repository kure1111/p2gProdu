import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProductsAceptados from '@salesforce/apex/P2G_reporteProductosOportunidad.getProductsAceptados';
import getAccount from '@salesforce/apex/P2G_reporteProductosOportunidad.getAccountAceptados';
import getProductsEnCuentas from '@salesforce/apex/P2G_reporteProductosOportunidad.getProductsEnCuentas';
import foliosACrear from '@salesforce/apex/p2G_FoliosEnOportunidades.foliosACrear';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import getWrapper from '@salesforce/apex/p2G_FoliosEnOportunidades.getWrapper';


export default class P2G_ConsultaProductosAceptados extends LightningElement {
    @track Crear = false;
    @track listaProductos;
    @track optionsCuenta = [];
    valueServicio = '';
    foliosParaCrear = 0;
    @track crearPqWhT = false;
    @track agregarDireccion = false;
    @track abrirComponenteBusqueda = false;
    @track isLoading = false;
    @track folioCreado;
    @track wrapper;
    @track idProducto;
    @track seCrearan = [];
    @track listaParaCrear = false;
    activeSections = ['Seccion1', 'Seccion2'];

    //buscar cuenta
    @track sideRecordsAccount;
    searchValueAccount ='';
    searchValueIdAccount ='';
    showSideAccount = false;

    //para site load
    @track sideRecordsLoad;
    searchValueLoad ='';
    searchValueIdLoad ='';
    showSideLoad = false;
    //para site dicharge
    @track sideRecordsDischarge;
    searchValueDischarge ='';
    searchValueIdDischarge ='';
    showSideDischarge = false;
    //para clave de servicio
    @track sideRecordsClaveServicio;
    searchValueClaveServicio ='';
    searchValueIdClaveServicio ='';
    showSideClaveServicio = false;

    //evento
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
    //mostrar listas
    connectedCallback() {
        this.agregarlistas();
    }
    agregarlistas(){
        getProductsAceptados()
            .then(result => {
                this.listaProductos = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaProductos = error;
            });
        getWrapper()
            .then(result => {
                this.wrapper = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.wrapper = null;
            });
    }
    
// buscador Account
SideSelectAccount(event){
    this.searchValueAccount = event.target.outerText;
    this.showSideAccount = false;
    this.searchValueIdAccount = event.currentTarget.dataset.id;
    this.llamarfiltro();
}
searchKeyAccount(event){
    this.searchValueAccount = event.target.value;
    this.searchValueIdAccount='';
    if (this.searchValueAccount.length >= 3) {
        this.showSideAccount = true;
        getAccount({cuenta: this.searchValueAccount})
            .then(result => {
                this.sideRecordsAccount = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsAccount = null;
            });
    }
    else{
        this.showSideAccount = false;
    }
}
    //valores Servicio
    get optionsServicio() {
        return [
            { label: 'FN - Flete Nacional', value: 'FN' },
            { label: 'FI - Flete Internacional', value: 'FI' },
            { label: 'A - Aereo', value: 'A' },
            { label: 'CE - Aduanas', value: 'CE - Aduanas' },
            { label: 'M - Maritimo', value: 'M' },
            { label: 'PTO - Puerto', value: 'PTO - Puerto' },
            { label: 'R - Global Routing', value: 'R - Global Routing' },
            { label: 'EX-Seguros', value: 'EX-Seguros' },
            { label: 'PQ - Paqueterias', value: 'PQ' },
            { label: 'T - Tarimas', value: 'T' },
            { label: 'WH - Almacenajes', value: 'WH' }
        ];
    }
    agregarServicio(event){
        this.valueServicio = event.detail.value;
        this.llamarfiltro();
    }
    llamarfiltro(){
        this.listaProductos = null;
        getProductsEnCuentas({idCuentas: this.searchValueIdAccount, servicio: this.valueServicio})
            .then(result => {
                this.listaProductos = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaProductos = error;
            });
    }
    //clic nombre producto
    abrirProducto(event){
        const idProducto = event.target.closest('tr').dataset.id; 
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/OpportunityLineItem/${idProducto}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank'); 
    }
    //clic limpiar filtros
    clicLimpioFiltro(){
        this.listaProductos = null;
        this.searchValueIdAccount = '';
        this.searchValueAccount = '';
        this.valueServicio = '';
        this.agregarlistas();
        getProductsAceptados()
            .then(result => {
                this.listaProductos = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.listaProductos = error;
            });
        this.foliosParaCrear = 0;
        //modificar registro
        const updatedlistaProductos = this.listaProductos.map( (item) => { 
            if (item.seCrea === true) {
                return {...item, seCrea: false, existeDireccion: '' };
            } 
            return item; });
            this.listaProductos = updatedlistaProductos;
            console.log('la lista mod: ', this.listaProductos);
    }
    //clic Seleccion de productos a crear
    clicSeCrea(event){
        this.idProducto = event.target.closest('tr').dataset.id; 
        const seCrea = event.target.checked;
        //numero de rutas seleccionadas
        if(seCrea === true){
            this.foliosParaCrear = this.foliosParaCrear + 1;
            console.log('El valor del check es: ', seCrea, ' folios Para Crear:',this.foliosParaCrear);
            //modificar registro
            const updatedlistaProductos = this.listaProductos.map( (item) => { 
                if (item.id === this.idProducto) { 
                    if((item.grupo === 'SP-PQ-PAQUETERIA') || (item.grupo === 'SP-WH-ALMACENAJE') || (item.grupo === 'SP-T-CONSOLIDADO')){
                        console.log('Entra en el if de grupo');
                        this.crearPqWhT = true;
                        this.agregarDireccion = false;
                    }else{
                        this.agregarDireccion = true;
                        this.crearPqWhT = false;
                    }
                    return {...item, seCrea: seCrea, };
                } 
                return item; });
                this.listaProductos = updatedlistaProductos;
                console.log('la lista mod: ', this.listaProductos);
        }else{
            this.foliosParaCrear = this.foliosParaCrear - 1;
            console.log('El valor del check es: ', seCrea, ' folios Para Crear:',this.foliosParaCrear);
            //modificar registro
            const updatedlistaProductos = this.listaProductos.map( (item) => { 
                if (item.id === this.idProducto) {
                    return {...item, seCrea: seCrea, };
                } 
                return item; });
                this.listaProductos = updatedlistaProductos;
                console.log('la lista mod: ', this.listaProductos);
        }
    }
    //Seleccion de direcciones Pq Wh T
    // buscador Site of Load
    SideSelectLoad(event){
        this.searchValueIdLoad = event.currentTarget.dataset.id;
        this.searchValueLoad = event.currentTarget.dataset.name;
        this.showSideLoad = false;
    }
    searchKeyLoad(event){
        this.searchValueLoad = event.target.value;
        this.searchValueIdLoad='';
        if (this.searchValueLoad.length >= 3) {
            this.showSideLoad = true;
            getSide({country: this.searchValueLoad})
                .then(result => {
                    this.sideRecordsLoad = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsLoad = null;
                });
        }
        else{
            this.showSideLoad = false;
        }
    }
    // buscador Site of Discharge
    SideSelectDischarge(event){
        this.searchValueIdDischarge = event.currentTarget.dataset.id;
        this.searchValueDischarge = event.currentTarget.dataset.name;
        this.showSideDischarge = false;
    }
    searchKeyDischarge(event){
        this.searchValueDischarge = event.target.value;
        this.searchValueIdDischarge='';
        if (this.searchValueDischarge.length >= 3) {
            this.showSideDischarge = true;
            getSide({country: this.searchValueDischarge})
                .then(result => {
                    this.sideRecordsDischarge = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsDischarge = null;
                });
        }
        else{
            this.showSideDischarge = false;
        }
    }
    // buscador ClaveServicio
    SideSelectClaveServicio(event){
        this.searchValueIdClaveServicio = event.currentTarget.dataset.id;
        this.searchValueClaveServicio = event.currentTarget.dataset.name;
        this.showSideClaveServicio = false;
    }
    searchKeyClaveServicio(event){
        this.searchValueClaveServicio = event.target.value;
        this.searchValueIdClaveServicio='';
        if (this.searchValueClaveServicio.length >= 3) {
            this.showSideClaveServicio = true;
            getClaveSAT({sat: this.searchValueClaveServicio,record: '1'})
                .then(result => {
                    this.sideRecordsClaveServicio = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsClaveServicio = null;
                });
        }
        else{
            this.showSideClaveServicio = false;
        }
    }

    //clic agregar direccion Pq Wh T
    agregarDirecciones(){
        console.log('Lo que llega: ', this.idProducto);
        //modificar registro
        const updatedlistaProductos = this.listaProductos.map( (item) => { 
            console.log('El item id: ', item.id ,' el producto ', this.idProducto);
            if (item.id === this.idProducto) { 
                return {...item, loadSite: this.searchValueIdLoad, dischargeSite: this.searchValueIdDischarge, extencionItemName: this.searchValueClaveServicio,};
            } 
            return item; });
            this.listaProductos = updatedlistaProductos;
            console.log('la lista mod: ', this.listaProductos);
        this.searchValueIdLoad ='';
        this.searchValueLoad ='';
        this.searchValueIdDischarge ='';
        this.searchValueDischarge ='';
        this.searchValueClaveServicio = '';
        this.searchValueIdClaveServicio = '';
        this.idProducto = '';
        this.crearPqWhT = false;
    }//para crear los tipos PQ, WH, T
    cerrarDirecciones(){
        this.crearPqWhT = false;
    }
    //agregar direcciones llamado al componente asignar direcciones
    noConoce(){
        this.agregarDireccion = false;
        const updatedlistaProductos = this.listaProductos.map( (item) => { 
            console.log('El item id: ', item.id ,' el producto ', this.idProducto);
            if (item.id === this.idProducto) { 
                return {...item, existeDireccion: 'Sin asignar dirección'};
            } 
            return item; });
        this.listaProductos = updatedlistaProductos;
        console.log('la lista mod: ', this.listaProductos);
    }
    siConoce(){
        this.agregarDireccion = true;
        this.abrirComponenteBusqueda = true;
        //pasar origen y destino
    }
    recibirDatos(event) {
        this.datosRecibidos = event.detail;
        console.log('Lo que llega: ', this.idProducto);
        console.log('Datos recibidos:', this.datosRecibidos);
        if(this.datosRecibidos.seCerro === 'si'){
            this.agregarDireccion = false;
            this.abrirComponenteBusqueda = false;
            const updatedlistaProductos = this.listaProductos.map( (item) => { 
                console.log('El item id: ', item.id ,' el producto ', this.idProducto);
                if (item.id === this.idProducto) { 
                    return {...item, seCrea:  false,};
                } 
                return item; });
            this.listaProductos = updatedlistaProductos;
            console.log('la lista mod: ', this.listaProductos);
        }else{
            console.log('entra al else');
            console.log('El origen id: ', this.datosRecibidos.idOrigen ,' el destino id ', this.datosRecibidos.idDestino);
            const updatedlistaProductos = this.listaProductos.map( (item) => { 
                console.log('El item id: ', item.id ,' el producto ', this.idProducto);
                if (item.id === this.idProducto) { 
                    return {...item, idAddressOrigen: this.datosRecibidos.idOrigen, idAddressDestino:  this.datosRecibidos.idDestino, existeDireccion: 'Se asigno dirección'};
                } 
                return item; });
            this.listaProductos = updatedlistaProductos;
            console.log('la lista mod: ', this.listaProductos);
            this.idProducto = '';
            this.abrirComponenteBusqueda = false;
            this.agregarDireccion = false;
        }
    }
    //desmarcar todo
    clicDesmarcar(){
        this.foliosParaCrear = 0;
        //modificar registro
        const updatedlistaProductos = this.listaProductos.map( (item) => { 
            if (item.seCrea === true) {
                return {...item, seCrea: false, existeDireccion: ''};
            } 
            return item; });
            this.listaProductos = updatedlistaProductos;
            console.log('la lista mod: ', this.listaProductos);
    }
    //vista folios a crear
    listaCrear(){
        this.listaParaCrear = true;
        for (const producto of this.listaProductos) {
            if (producto.seCrea === true) {
                this.seCrearan.push(producto);
            }
        }
    }
    //clic regresa cierra modal
    clicRegresa(){
        this.listaParaCrear = false;
    }
    //crear los folios
    clicCrear(){
        if(this.foliosParaCrear > 0){
            this.isLoading = true;
            this.listaParaCrear = false;
            console.log('el wrapper es: ', this.wrapper);
            if(this.wrapper != null){
                this.wrapper.splice(0);
                console.log('el wrapper con if: ', this.wrapper);
            }
            console.log('el wrapper sin if: ', this.wrapper);
            for (let posicion in this.listaProductos){
                if(this.listaProductos[posicion].seCrea === true){
                    this.wrapper.push(this.listaProductos[posicion]);
                    posicion++;
                    console.log('la posicion es',posicion,this.wrapper);
                }
            }
            //this.contenido = JSON.stringify(this.wrapper);
            console.log('El wrapper es',this.wrapper);
            foliosACrear({wrapperProduct: this.wrapper})
                .then(result => {
                    this.isLoading = false;
                    this.listaParaCrear = false;
                    this.folioCreado = result;
                    if(this.folioCreado === 'Los folios fueron creados correctamente'){
                        this.pushMessage('Operación Exitosa','success', this.folioCreado);
                        this.close('close');location.reload();
                    }else if(this.folioCreado === 'Los folios se crearon sin cargo line'){
                        this.pushMessage('Advertencia','warning', this.folioCreado);
                        this.close('close');location.reload();
                    }else{
                        this.pushMessage('Error','error', this.folioCreado);
                    }
                })
                .catch(error => {
                    this.isLoading = false;
                    this.listaParaCrear = true;
                    this.pushMessage('Error','error', error.body.message);
                    this.folioCreado = null;
                }); 
        }else{ 
            this.pushMessage('Error','error', 'Seleccionar una ruta para crear un folio');
        } 
    }
}