import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountAddress from '@salesforce/apex/P2G_AccountAddress.getAddress';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getCP from '@salesforce/apex/P2G_asignarAccountAddressMap.getCP';
import buscarAccountAddress from '@salesforce/apex/P2G_asignarAccountAddressMap.getBuscaAddress';
import seleccionLocacion from '@salesforce/apex/P2G_asignarAccountAddressMap.seleccionLocacion';
import agregarDireccion from '@salesforce/apex/P2G_asignarAccountAddressMap.agregarDireccion';
import getAddress from '@salesforce/apex/P2G_asignarAccountAddressMap.getAddress';

export default class P2G_AsignarAccountAddressMap extends LightningElement {
    //variables
    @api recordId;
    @api objectApiName;
    @api conoceDireccion;
    @track mapMarkers = [];
    @track buscaMap = false;
    @track formaBusqueda = true;
    @track listaAddressOrigen;
    @track listaAddressDestino;
    @track guardaOrigen = true;
    @track guardaDestino = true;
    @track guardaDirecion = false;
    @track botonOrigen = false;
    @track botonDestino = false;
    @track rutaMap = false;
    @track location;
    @track selectedMarkerValue = '';
    @track idSiteOrigen = '';
    @track nameSiteOrigen = '';
    @track idSiteDestino = '';
    @track nameSiteDestino = '';
    //para account address origen
    @track sideRecordsAddressOrigen;
    searchValueAddressOrigen ='';
    searchValueIdAddressOrigen ='';
    showSideAddressOrigen = false;
    //para account address Destino
    @track sideRecordsAddressDestino;
    searchValueAddressDestino ='';
    searchValueIdAddressDestino ='';
    showSideAddressDestino = false;
    //para ciudad origen
    @track sideRecordsLoad;
    searchValueLoad ='';
    searchValueIdLoad ='';
    showSideLoad = false;
    //para cuidad destino
    @track sideRecordsDischarge;
    searchValueDischarge ='';
    searchValueIdDischarge ='';
    showSideDischarge = false;
    //para cp origen
    @track searchCpOrigen = '';
    @track CpOrigenId = '';
    @track showCpOrigen = false;
    //para cp destino
    @track searchCpDestino = '';
    @track CpDestinoId = '';
    @track showCpDestino = false;
    @track deURL = false;
    @track isLoading = false;
    connectedCallback() {
        console.log('el record id: ', this.recordId);
        const urlParams = new URLSearchParams(window.location.search);
        const recordIdURLaction = urlParams.get('recordId');
        const recordIdURL = urlParams.get('c__recordId');
        console.log('el recordIdURL id: ', this.recordIdURL);
        if (recordIdURL) {
            this.deURL = true;
            this.recordId= recordIdURL;
            this.conoceDireccion = true;
            getAddress({idQuote: this.recordId})
                .then(result => {
                    this.accountExistentes = result;
                    this.llenarDatosExistentes(this.accountExistentes);
                    this.seleccionRuta();
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.accountExistentes = null;
                });
        }else if (recordIdURLaction) {
            this.deURL = true;
            this.recordId= recordIdURLaction;
            this.conoceDireccion = true;
            getAddress({idQuote: this.recordId})
                .then(result => {
                    this.accountExistentes = result;
                    this.llenarDatosExistentes(this.accountExistentes);
                    this.seleccionRuta();
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.accountExistentes = null;
                });
        }
    }
    //llenar datos existentes
    llenarDatosExistentes(account){
        this.searchValueAddressOrigen = account.nameOrigen;
        this.searchValueIdAddressOrigen = account.idOrigen;
        this.searchValueAddressDestino = account.nameDestino;
        this.searchValueIdAddressDestino = account.idDestino;
        this.searchValueLoad = account.nameSiteOrigen;
        this.searchValueIdLoad = account.idSiteOrigen;
        this.searchValueDischarge  = account.nameSiteDestino;
        this.searchValueIdDischarge = account.idSiteDestino;
        this.CpOrigenId = account.codigoPostalIdOrigen;
        this.searchCpOrigen = account.codigoPostalOrigen;
        this.CpDestinoId = account.codigoPostalIdDestino;
        this.searchCpDestino = account.codigoPostalDestino;
        this.idOrigen = account.idOrigen;
        this.nameOrigen = account.nameOrigen;
        this.idSiteOrigen = account.idSiteOrigen;
        this.nameSiteOrigen = account.nameSiteOrigen;
        this.calleOrigen = account.calleOrigen;
        this.numeroExteriorOrigen = account.numeroExteriorOrigen;
        this.numeroInteriorOrigen = account.numeroInteriorOrigen;
        this.codigoPostalOrigen = account.codigoPostalOrigen;
        this.coloniaOrigen = account.coloniaOrigen;
        this.municipioOrigen = account.municipioOrigen;
        this.localidadOrigen = account.localidadOrigen;
        this.estadoOrigen = account.estadoOrigen;
        this.paisOrigen = account.paisOrigen;
        this.folioAddressOrigen = account.folioAddressOrigen;
        this.latitudOrigen = account.latitudOrigen;
        this.longitudOrigen = account.longitudOrigen;
        this.idDestino = account.idDestino;
        this.nameDestino = account.nameDestino;
        this.idSiteDestino = account.idSiteDestino;
        this.nameSiteDestino = account.nameSiteDestino;
        this.calleDestino = account.calleDestino;
        this.numeroExteriorDestino = account.numeroExteriorDestino;
        this.numeroInteriorDestino = account.numeroInteriorDestino;
        this.codigoPostalDestino = account.codigoPostalDestino;
        this.coloniaDestino = account.coloniaDestino;
        this.municipioDestino = account.municipioDestino;
        this.localidadDestino = account.localidadDestino;
        this.estadoDestino = account.estadoDestino;
        this.paisDestino = account.paisDestino;
        this.folioAddressDestino = account.folioAddressDestino;
        this.latitudDestino = account.latitudDestino;
        this.longitudDestino = account.longitudDestino;
    }
    // buscador Address Origen
    SideSelectAddressOrigen(event){
        this.searchValueIdAddressOrigen = event.currentTarget.dataset.id;
        this.searchValueAddressOrigen = event.currentTarget.dataset.name;
        this.showSideAddressOrigen = false;
    }
    searchKeyAddressOrigen(event){
        this.searchValueAddressOrigen = event.target.value;
        this.searchValueIdAddressOrigen='';
        if (this.searchValueAddressOrigen.length >= 3) {
            this.showSideAddressOrigen = true;
            getAccountAddress({address: this.searchValueAddressOrigen, account: this.searchValueIdAccount})
                .then(result => {
                    this.sideRecordsAddressOrigen = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsAddressOrigen = null;
                });
        }
        else{
            this.showSideAddressOrigen = false;
        }
    }
    // buscador Address Destino
    SideSelectAddressDestino(event){
        this.searchValueIdAddressDestino = event.currentTarget.dataset.id;
        this.searchValueAddressDestino = event.currentTarget.dataset.name;
        this.showSideAddressDestino = false;
    }
    searchKeyAddressDestino(event){
        this.searchValueAddressDestino = event.target.value;
        this.searchValueIdAddressDestino='';
        if (this.searchValueAddressDestino.length >= 3) {
            this.showSideAddressDestino = true;
            getAccountAddress({address: this.searchValueAddressDestino, account: this.searchValueIdAccount})
                .then(result => {
                    this.sideRecordsAddressDestino = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsAddressDestino = null;
                });
        }
        else{
            this.showSideAddressDestino = false;
        }
    }
    // buscador Site of Load
    SideSelectLoad(event){
        this.searchValueLoad = event.target.outerText;
        this.showSideLoad = false;
        this.searchValueIdLoad = event.currentTarget.dataset.id;
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
        this.searchValueDischarge = event.target.outerText;
        this.showSideDischarge = false;
        this.searchValueIdDischarge = event.currentTarget.dataset.id;
        //console.log(event.currentTarget.dataset.id);
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
    //CpOrigen
    cpOrigenSelect(event){
        this.CpOrigenId = event.currentTarget.dataset.id;
        this.searchCpOrigen = event.currentTarget.dataset.name;
        this.showCpOrigen = false;
    }
    searchKeyCpOrigen(event){
        this.searchCpOrigen = event.target.value;
        this.CpOrigenId='';
        if (this.searchCpOrigen.length >= 3) {
            this.showCpOrigen = true;
            getCP({ cp: this.searchCpOrigen })
                .then(result => {
                    this.listCpOrigen = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listCpOrigen = null;
                });
        }
        else{
            this.showCpOrigen = false;
        }
    }
    //CpDestino
    cpDestinoSelect(event){
        this.searchCpDestino = event.currentTarget.dataset.name;
        this.CpDestinoId = event.currentTarget.dataset.id;
        this.showCpDestino = false;
    }
    searchKeyCpDestino(event){
        this.searchCpDestino = event.target.value;
        this.CpDestinoId = '';
        if (this.searchCpDestino.length >= 3) {
            this.showCpDestino = true;
            getCP({ cp: this.searchCpDestino })
                .then(result => {
                    this.listCpDestino = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listCpDestino = null;
                });
        } else {
            this.showCpDestino = false;
        }
    }
    //llenar marke de origen
    llenarMarcadorOrigen(lista){
        this.mapMarkers = lista.map( (location) => {
            if(location.status === 'Validado'){
                return {
                        location: {
                        Latitude: location.latitud,
                        Longitude: location.longitud
                    },
                    mapIcon: {
                        path: `M32 12L12 32H20V52H28V40H36V52H44V32H52L32 12Z`,
                        fillColor: 'Red',
                        fillOpacity: 1,
                        scale: 0.80,
                        label: {
                            text: '2GO',
                            color: 'white',
                            fontSize: '25px',
                            fontWeight: 'bold'
                        }
                    },
                    title: location.nameAddress,
                    value: location.idAddress,
                    description: '<p><b><h1>'+location.nameAddress+'</h1></b></p><p><b>Informacion de la direccion</b></p><p><b>Pais</b>: '+location.pais+'  <b>Estado</b>: '+location.estado+
                    '</p><p><b>Municipio</b>: '+location.municipio+'</p><p><b>Localidad</b>: '+location.localidad+
                    '</p><p><b>Codigo Postal</b>: '+location.codigoPostal+'<p><b>Colonia</b>: '+location.colonia+
                    '</p><p><b>Calle</b>: '+location.calle+'</p><p><b>Numero Exterior</b>: '+location.numeroExterior+
                    ' <b>Numero Interior</b>: '+location.numeroInterior+'</p><p><b>Folio Address</b>: '+location.folioAddress+' <b>Status</b>: '+location.status+'</p>',
                };
            }
            if(location.status === 'Pendiente'){
                return {
                        location: {
                        Latitude: location.latitud,
                        Longitude: location.longitud
                    },
                    mapIcon: {
                        path: `M32 12L12 32H20V52H28V40H36V52H44V32H52L32 12Z`,
                        fillColor: '#C4C909',
                        fillOpacity: 1,
                        scale: 0.80,
                        label: {
                            text: '2GO',
                            color: 'white',
                            fontSize: '25px',
                            fontWeight: 'bold'
                        }
                    },
                    title: location.nameAddress,
                    description: '<p><b><h1>'+location.nameAddress+'</h1></b></p><p><b>Informacion de la direccion</b></p><p><b>Pais</b>: '+location.pais+'  <b>Estado</b>: '+location.estado+
                    '</p><p><b>Municipio</b>: '+location.municipio+'</p><p><b>Localidad</b>: '+location.localidad+
                    '</p><p><b>Codigo Postal</b>: '+location.codigoPostal+'<p><b>Colonia</b>: '+location.colonia+
                    '</p><p><b>Calle</b>: '+location.calle+'</p><p><b>Numero Exterior</b>: '+location.numeroExterior+
                    '<b> Numero Interior</b>: '+location.numeroInterior+'</p><p><b>Folio Address</b>: '+location.folioAddress+' <b>Status</b>: '+location.status+'</p>',
                };
            }
        });
    }
    //llenar marke de destino
    llenarMarcadorDestino(lista){
        this.mapMarkers = lista.map( (location) => {
            if(location.status === 'Validado'){
                return {
                        location: {
                        Latitude: location.latitud,
                        Longitude: location.longitud
                    },
                    mapIcon: {
                        path: `M 50 150 L 50 100 L 100 100 L 100 150 Z
                            M 100 150 L 100 80 L 150 80 L 150 150 Z
                            M 150 150 L 150 60 L 200 60 L 200 150 Z
                            M 60 60 L 60 30 L 80 30 L 80 60 Z
                            M 50 100 L 60 90 L 70 100 L 80 90 L 90 100 L 100 90 L 100 100 Z`,
                        fillColor: 'Red',
                        fillOpacity: 1,
                        scale: 0.30,
                        label: {
                            text: '2GO',
                            color: 'white',
                            fontSize: '25px',
                            fontWeight: 'bold'
                        }
                    },
                    title: location.nameAddress,
                    value: location.idAddress,
                    description: '<p><b><h1>'+location.nameAddress+'</h1></b></p><p><b>Informacion de la direccion</b></p><p><b>Pais</b>: '+location.pais+'  <b>Estado</b>: '+location.estado+
                    '</p><p><b>Municipio</b>: '+location.municipio+'</p><p><b>Localidad</b>: '+location.localidad+
                    '</p><p><b>Codigo Postal</b>: '+location.codigoPostal+'<p><b>Colonia</b>: '+location.colonia+
                    '</p><p><b>Calle</b>: '+location.calle+'</p><p><b>Numero Exterior</b>: '+location.numeroExterior+
                    ' <b>Numero Interior</b>: '+location.numeroInterior+'</p><p><b>Folio Address</b>: '+location.folioAddress+' <b>Status</b>: '+location.status+'</p>',
                };
            }
            if(location.status === 'Pendiente'){
                return {
                        location: {
                        Latitude: location.latitud,
                        Longitude: location.longitud
                    },
                    mapIcon: {
                        path: `M 50 150 L 50 100 L 100 100 L 100 150 Z
                            M 100 150 L 100 80 L 150 80 L 150 150 Z
                            M 150 150 L 150 60 L 200 60 L 200 150 Z
                            M 60 60 L 60 30 L 80 30 L 80 60 Z
                            M 50 100 L 60 90 L 70 100 L 80 90 L 90 100 L 100 90 L 100 100 Z`,
                        fillColor: '#C4C909',
                        fillOpacity: 1,
                        scale: 0.30,
                        label: {
                            text: '2GO',
                            color: 'white',
                            fontSize: '25px',
                            fontWeight: 'bold'
                        }
                    },
                    title: location.nameAddress,
                    description: '<p><b><h1>'+location.nameAddress+'</h1></b></p><p><b>Informacion de la direccion</b></p><p><b>Pais</b>: '+location.pais+'  <b>Estado</b>: '+location.estado+
                    '</p><p><b>Municipio</b>: '+location.municipio+'</p><p><b>Localidad</b>: '+location.localidad+
                    '</p><p><b>Codigo Postal</b>: '+location.codigoPostal+'<p><b>Colonia</b>: '+location.colonia+
                    '</p><p><b>Calle</b>: '+location.calle+'</p><p><b>Numero Exterior</b>: '+location.numeroExterior+
                    ' <b>Numero Interior</b>: '+location.numeroInterior+'</p><p><b>Folio Address</b>: '+location.folioAddress+' <b>Status</b>: '+location.status+'</p>',
                };
            }
        });
    }
    //seleccionar direccion de origen
    direccionOrigen(){
        console.log('se dio clic en direccion de origen');
        this.guardaDirecion = false;
        buscarAccountAddress({ address: this.searchValueAddressOrigen, ciudad: this.searchValueLoad, cp: this.CpOrigenId})
        .then(result => {
            console.log('lista address ', result);
            this.listaAddress = result;
            if(this.listaAddress != null || this.listaAddress !=''){
                this.llenarMarcadorOrigen(this.listaAddress);
                console.log('El marcador: ', this.mapMarkers);
                this.buscaMap = true;
                this.formaBusqueda = false;
                this.botonOrigen = true;
            }else{
                this.pushMessage('Error','error', 'No se encontro ninguna ruta');
            }
        })
        .catch(error => {
            console.log('Error: ', 'error', error.body.message);
            this.pushMessage('Error','error', error.body.message);
            this.listaAddress = null;
        });
    }
    direccionDestino(){
        this.guardaDirecion = false;
        this.listaAddress = '';
        this.mapMarkers = [];
        console.log('se dio clic en direccion de destino');
        buscarAccountAddress({ address: this.searchValueAddressDestino, ciudad: this.searchValueDischarge, cp: this.CpDestinoId})
        .then(result => {
            console.log('lista address ', result);
            this.listaAddress = result;
            if(this.listaAddress != null || this.listaAddress !=''){
                this.llenarMarcadorDestino(this.listaAddress);
                console.log('El marcador: ', this.mapMarkers);
                this.buscaMap = true;
                this.formaBusqueda = false;
                this.botonDestino = true;
            }else{
                this.pushMessage('Error','error', 'No se encontro ninguna ruta');
            }
        })
        .catch(error => {
            console.log('Error: ', 'error', error.body.message);
            this.pushMessage('Error','error', error.body.message);
            this.listaAddress = null;
        });
    }
    handleMarkerSelect(event) {
        this.idAddress = '';
        this.selectedMarkerValue = event.target.selectedMarkerValue;
        const updatedlistaAddress = this.listaAddress.map( (item) => { 
            if((item.idAddress === this.selectedMarkerValue) && (item.status === 'Validado')){
                this.idAddress = this.selectedMarkerValue;
                return {...item, seleccion: true, };
            }else{
                return {...item, seleccion: false, };
            }
        });
        this.listaAddress = updatedlistaAddress;
        console.log('la lista mod: ', this.listaAddress);
    }
    //seleccion de direccion
    @track selectedRadio = false;
    @track idAddress;
    selectAddress(event){
        this.idAddress = event.target.closest('tr').dataset.id;
        const radio = event.target.checked;
        console.log('lo que se selecciona: '+this.idAddress);
        const updatedlistaAddress = this.listaAddress.map( (item) => { 
            if (item.idAddress === this.idAddress) {
                if(radio === item.seleccion){
                    return {...item, seleccion: false, };
                }else{
                    return {...item, seleccion: this.selectedRadio, };
                }
            } 
            return item; });
            this.listaAddress = updatedlistaAddress;
            console.log('la lista mod: ', this.listaAddress);
        if(radio === true){
            this.selectedMarkerValue = this.idAddress;
        }
    }
    aprobarBuequedaOrigen(){
        //modificar registro
        const updatedlistaAddress = this.listaAddress.map( (item) => { 
            console.log('El item id: ', item.idAddress ,' el producto ', this.idAddress);
            if (item.idAddress === this.idAddress) {
                this.guardarOrigen(item);
                return {...item, seleccion: this.selectedRadio, };
            } 
            return item; });
            this.listaAddress = updatedlistaAddress;
            console.log('la lista mod: ', this.listaAddress);
        seleccionLocacion({municipio: this.municipioOrigen, location: this.localidadOrigen, estado: this.estadoOrigen, claveSat: this.claveSatOrigen})
            .then(result => {
                if(result.Zona_Metropolitana__c != null && result.Zona_Metropolitana__c != ''){
                    this.idSiteOrigen = result.Zona_Metropolitana__c;
                    this.nameSiteOrigen = result.Zona_Metropolitana__r.Name;
                }else{
                    this.idSiteOrigen = result.Id;
                    this.nameSiteOrigen = result.Name;
                }
                console.log('ciudad: ', this.idSiteOrigen, this.nameSiteOrigen);
                this.guardaOrigen = false;
                this.botonOrigen = false;
                this.buscaMap = false;
                this.formaBusqueda = true;
                this.seleccionRuta();
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.location = null;
            });
            this.idAddress = '';
    }
    aprobarBuequedaDestino(){
        const updatedlistaAddress = this.listaAddress.map( (item) => { 
        console.log('El item id: ', item.idAddress ,' el producto ', this.idAddress);
        if (item.idAddress === this.idAddress) {
            this.guardarDestino(item);
            return {...item, seleccion: this.selectedRadio, };
        } 
        return item; });
        this.listaAddress = updatedlistaAddress;
        console.log('la lista mod: ', this.listaAddress);
        seleccionLocacion({municipio: this.municipioDestino, location: this.localidadDestino, estado: this.estadoDestino, claveSat: this.claveSatDestino})
            .then(result => {
                if(result.Zona_Metropolitana__c != null && result.Zona_Metropolitana__c != ''){
                    this.idSiteDestino = result.Zona_Metropolitana__c;
                    this.nameSiteDestino = result.Zona_Metropolitana__r.Name;
                }else{
                    this.idSiteDestino = result.Id;
                    this.nameSiteDestino = result.Name;
                }
                this.guardaDestino= false;
                this.botonDestino = false;
                this.buscaMap = false;
                this.formaBusqueda = true;
                this.seleccionRuta();
            })
            .catch(error => {
                console.log('Error','error', error);
                this.pushMessage('Error','error', error.body.message);
                this.location = null;
            });
            this.idAddress = '';
    }
    //regresa a principal
    aprobarBuequeda(){
        if(this.deURL == false){
            const datosDevueltos = {
                idOrigen : this.idOrigen,
                nameOrigen : this.nameOrigen,
                idSiteOrigen : this.idSiteOrigen,
                nameSiteOrigen : this.nameSiteOrigen,
                calleOrigen : this.calleOrigen,
                numeroExteriorOrigen : this.numeroExteriorOrigen,
                numeroInteriorOrigen : this.numeroInteriorOrigen,
                codigoPostalOrigen : this.codigoPostalOrigen,
                coloniaOrigen : this.coloniaOrigen,
                municipioOrigen : this.municipioOrigen,
                localidadOrigen : this.localidadOrigen,
                estadoOrigen : this.estadoOrigen,
                paisOrigen : this.paisOrigen,
                folioAddressOrigen : this.folioAddressOrigen,
                latitudOrigen : this.latitudOrigen,
                longitudOrigen : this.longitudOrigen,
                idDestino : this.idDestino,
                nameDestino : this.nameDestino,
                idSiteDestino : this.idSiteDestino,
                nameSiteDestino : this.nameSiteDestino,
                calleDestino : this.calleDestino,
                numeroExteriorDestino : this.numeroExteriorDestino,
                numeroInteriorDestino : this.numeroInteriorDestino,
                codigoPostalDestino : this.codigoPostalDestino,
                coloniaDestino : this.coloniaDestino,
                municipioDestino : this.municipioDestino,
                localidadDestino : this.localidadDestino,
                estadoDestino : this.estadoDestino,
                paisDestino : this.paisDestino,
                folioAddressDestino : this.folioAddressDestino,
                latitudDestino : this.latitudDestino,
                longitudDestino : this.longitudDestino,
                ruta : this.ruta,
                seCerro : 'no',
                abrirComponente : false
            };
            this.conoceDireccion = false;
            const evento = new CustomEvent('resultados', {
                detail: datosDevueltos
            });
            this.dispatchEvent(evento);
        }else{
            this.isLoading = true;
            agregarDireccion({ idQuote: this.recordId, idOrigen: this.idOrigen, idDestino: this.idDestino, idCiudadOrigen: this.idSiteOrigen, idCiudadDestino: this.idSiteDestino, })
                .then(result => {
                    console.log('lista address ', result);
                    this.updateQuote = result;
                    if(this.updateQuote == 'Se agregaron las direcciones correctamente'){
                        // uat "https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/"
                        // prod 
                        const varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+this.recordId+"/view";
                        console.log('view all '+ varurl);
                        window.open(varurl,"_self");
                        this.pushMessage('Success','success', this.updateQuote);
                    }else{
                        this.pushMessage('Error','error', this.updateQuote);
                    }
                    this.isLoading = false;
                })
                .catch(error => {
                    console.log('Error: ', 'error', error.body.message);
                    this.pushMessage('Error','error', error.body.message);
                    this.updateQuote = null;
                    this.isLoading = false;
                });
        }
    }
    //guardar datos seleccionados
    guardarOrigen(listaAddress){
        this.idOrigen = listaAddress.idAddress;
        this.nameOrigen = listaAddress.nameAddress;
        this.calleOrigen = listaAddress.calle;
        this.numeroExteriorOrigen = listaAddress.numeroExterior;
        this.numeroInteriorOrigen = listaAddress.numeroInterior;
        this.codigoPostalOrigen = listaAddress.codigoPostal;
        this.coloniaOrigen = listaAddress.colonia;
        this.municipioOrigen = listaAddress.municipio;
        this.localidadOrigen = listaAddress.localidad;
        this.estadoOrigen = listaAddress.estado;
        this.paisOrigen = listaAddress.pais;
        this.folioAddressOrigen = listaAddress.folioAddress;
        this.latitudOrigen = listaAddress.latitud;
        this.longitudOrigen = listaAddress.longitud;
        this.claveSatOrigen = listaAddress.claveSat;
        this.statusOrigen = listaAddress.status;
    }
    guardarDestino(listaAddress){
        this.idDestino = listaAddress.idAddress;
        this.nameDestino = listaAddress.nameAddress;
        this.calleDestino = listaAddress.calle;
        this.numeroExteriorDestino = listaAddress.numeroExterior;
        this.numeroInteriorDestino = listaAddress.numeroInterior;
        this.codigoPostalDestino = listaAddress.codigoPostal;
        this.coloniaDestino = listaAddress.colonia;
        this.municipioDestino = listaAddress.municipio;
        this.localidadDestino = listaAddress.localidad;
        this.estadoDestino = listaAddress.estado;
        this.paisDestino = listaAddress.pais;
        this.folioAddressDestino = listaAddress.folioAddress;
        this.latitudDestino = listaAddress.latitud;
        this.longitudDestino = listaAddress.longitud;
        this.claveSatDestino = listaAddress.claveSat;
        this.statusDestino = listaAddress.status;
    }
    //Aparece ruta
    seleccionRuta(){
        if(this.nameSiteOrigen != '' && this.nameSiteDestino != ''){
            this.guardaDirecion = true;
            this.ruta = this.nameSiteOrigen +' - '+ this.nameSiteDestino;
        }else{
            this.guardaDirecion = false;
        }
    }
    //evento
    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
    //ver ruta seleccionada
    llenarMarcadorRuta(){
        this.mapMarkers = [
                {
                    location: {
                        Latitude: this.latitudOrigen,
                        Longitude: this.longitudOrigen
                    },
                    mapIcon: {
                        path: `M32 12L12 32H20V52H28V40H36V52H44V32H52L32 12Z`,
                        fillColor: 'Red',
                        fillOpacity: 1,
                        scale: 0.80
                    },
                    title: this.nameOrigen,
                    description: '<p><b><h1>'+this.nameOrigen+'</h1></b></p><p><b>Informacion de la direccion</b></p><p><b>Pais</b>: '+this.paisOrigen+'  <b>Estado</b>: '+this.estadoOrigen+
                    '</p><p><b>Municipio</b>: '+this.municipioOrigen+'</p><p><b>Localidad</b>: '+this.localidadOrigen+
                    '</p><p><b>Codigo Postal</b>: '+this.codigoPostalOrigen+'<p><b>Colonia</b>: '+this.coloniaOrigen+
                    '</p><p><b>Calle</b>: '+this.calleOrigen+'</p><p><b>Numero Exterior</b>: '+this.numeroExteriorOrigen+
                    ' <b>Numero Interior</b>: '+this.numeroInteriorOrigen+'</p><p><b>Folio Address</b>: '+this.folioAddressOrigen+' <b>Status</b>: '+this.statusOrigen+'</p>',
                },
                {
                    location: {
                        Latitude: this.latitudDestino,
                        Longitude: this.longitudDestino
                    },
                    mapIcon: {
                        path: `M 50 150 L 50 100 L 100 100 L 100 150 Z
                            M 100 150 L 100 80 L 150 80 L 150 150 Z
                            M 150 150 L 150 60 L 200 60 L 200 150 Z
                            M 60 60 L 60 30 L 80 30 L 80 60 Z
                            M 50 100 L 60 90 L 70 100 L 80 90 L 90 100 L 100 90 L 100 100 Z`,
                        fillColor: 'Red',
                        fillOpacity: 1,
                        scale: 0.20
                    },
                    title: this.nameDestino,
                    description: '<p><b><h1>'+this.nameDestino+'</h1></b></p><p><b>Informacion de la direccion</b></p><p><b>Pais</b>: '+this.paisDestino+'  <b>Estado</b>: '+this.estadoDestino+
                    '</p><p><b>Municipio</b>: '+this.municipioDestino+'</p><p><b>Localidad</b>: '+this.localidadDestino+
                    '</p><p><b>Codigo Postal</b>: '+this.codigoPostalDestino+'<p><b>Colonia</b>: '+this.coloniaDestino+
                    '</p><p><b>Calle</b>: '+this.calleDestino+'</p><p><b>Numero Exterior</b>: '+this.numeroExteriorDestino+
                    '<b> Numero Interior</b>: '+this.numeroInteriorDestino+'</p><p><b>Folio Address</b>: '+this.folioAddressDestino+' <b>Status</b>: '+this.statusDestino+'</p>',
                }
            ];
    }
    verRuta(){
        this.rutaMap = true;
        this.formaBusqueda = false;
        this.mapMarkers = [];
        this.llenarMarcadorRuta();
        console.log('El marcador: ', this.mapMarkers);
    }
    //cerrar modal
    closeModal(){
        if(this.deURL == false){
            this.conoceDireccion = false;
            const datosDevueltos = {
                seCerro : 'si',
                abrirComponente : false
            };
            const evento = new CustomEvent('resultados', {
                detail: datosDevueltos
            });
            this.dispatchEvent(evento);
        }else{
            const varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+this.recordId+"/view";
            console.log('view all '+ varurl);
            window.open(varurl,"_self");
        }
    }
    //atras
    volverFormulario(){
        this.buscaMap = false;
        this.formaBusqueda = true;
        this.guardaDirecion = false;
        this.botonOrigen = false;
        this.botonDestino = false;
        this.rutaMap = false;
        this.searchValueAddressOrigen = '';
        this.searchValueIdAddressOrigen = '';
        this.searchValueAddressDestino = '';
        this.searchValueIdAddressDestino = '';
        this.searchValueLoad = '';
        this.searchValueIdLoad = '';
        this.searchValueDischarge  = '';
        this.searchValueIdDischarge = '';
        this.CpOrigenId = '';
        this.searchCpOrigen = '';
        this.CpDestinoId = '';
        this.searchCpDestino = '';
        this.seleccionRuta();
    }
}