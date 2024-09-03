// p2g_cargaProducto.js
import { LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpportunityLineItems from '@salesforce/apex/P2G_loadProducts.getOpportunityLineItems';
import createProduct from '@salesforce/apex/P2G_loadProducts.handleProduct';
import getCountry from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getContainerType from '@salesforce/apex/P2G_CreacionCargoLines.getContainerType';
import getCsv from '@salesforce/apex/P2G_loadProducts.getCsv';
import updateItems from '@salesforce/apex/P2G_loadProducts.updateOli';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import infoGrupo from '@salesforce/apex/P2G_loadProducts.infoGrupo';
import getCp from '@salesforce/apex/P2G_loadProducts.getCp';
import uploadFile from '@salesforce/apex/P2G_loadProducts.uploadFile';
import LightningModal from 'lightning/modal';

export default class P2g_cargaProducto extends LightningModal {
    @api recordId;
    @track isLoading = false;
    @track noEjecucion = true;

    @track obj;
    @track selectedFrecuencia;
    @track opportunityLineItems;
    @track unitPerFrequency;
    @track weight;
    @track loadingAddress;
    @track unloadingAddress;
    @track quantity;
    @track timeLoad;
    @track timeUnload;
    @track comentarios;
    @track buyPrice;
    @track selectedMoneda;

    //variables extras
    @track inforGrupo;
    @track grupo;
    @track selectedUnidadPeso;
    @track target;
    @track selectedIncoterm;
    @track selectedTipoServicio;
    @track selectedTipoRuta;
    @track selectedServicioEspecial;
    @track selectedservicioAdicional;
    @track selectedTipoContenedor;
    @track selectedHazmat;
    @track selectedCertificaciones;
    @track selectedAeropuertoSalidaArribo;
    @track selectedTipoSeguro;
    @track selectedTipoServicioEmbarque;
    @track selectedBorder;
    @track selectedCustomsNorte;
    @track selectedCustomsSur;
    @track selectedCustomsMaritimas;
    @track selectedCustomsInteriores;
    @track vistaPMFC = false;
    @track vistaPMFAC = false;
    @track vistaPM = false;
    @track vistaPMFA = false;
    @track vistaFA = false;
    @track vistaF = false;
    @track vistaAC = false;
    @track vistaC = false;
    @track vistaS = false;
    @track opPM = false;
    @track opF = false;
    @track opC = false;
    @track siservicioEspecial = false;
    @track sihazmat = false;
    @track opCustomsNorte = false;
    @track opCustomsSur = false;
    @track opCustomsMaritimas = false;
    @track opCustomsInteriores = false;
    @track fileServicioEspecialData;
    @track fileHazmatData;
    @track inicioWrapper = false;

    frecuenciaOptions = [
        { label: 'Diario', value: 'Diario' },
        { label: 'Semanal', value: 'Semanal' },
        { label: 'Mensual', value: 'Mensual' },
        { label: 'Anual', value: 'Anual' }
    ];

    handleFrecuenciaChange(event) {
        this.selectedFrecuencia = event.detail.value;
        this.obj.frecuencia = event.detail.value;
        if(this.unitPerFrequency != null){
            this.calculoVolumenMensual(this.unitPerFrequency);
        }
    }
    
    monedaOptions = [
        { label: 'MXN', value: 'MXN' },
        { label: 'USD', value: 'USD' },
        { label: 'EUR', value: 'EUR' }
    ];
    
    handleMonedaChange(event) {
        this.selectedMoneda = event.detail.value;
        this.obj.currencyOli = event.detail.value;
    }
    
    UnidadPesoOptions = [
        { label: 'Kg', value: 'Kg' },
        { label: 'Lb', value: 'Lb' }
    ];

    handleUnidadPesoChange(event) {
        this.selectedUnidadPeso = event.detail.value;
        this.obj.unidadPeso = event.detail.value;
    }

    incotermOptions = [
        { label: 'CFR', value: 'CFR' },
        { label: 'CIF', value: 'CIF' },
        { label: 'CIP', value: 'CIP' },
        { label: 'CPT', value: 'CPT' },
        { label: 'DAP', value: 'DAP' },
        { label: 'DAT', value: 'DAT' },
        { label: 'DDP', value: 'DDP' },
        { label: 'EXW', value: 'EXW' },
        { label: 'FCA', value: 'FCA' },
        { label: 'FOB', value: 'FOB' }
    ];
    handleIncotermChange(event) {
        this.selectedIncoterm = event.detail.value;
        this.obj.incoterm = event.detail.value;
    }
    
    OptionsTipoServicioPM = [
        { label: 'Full', value: 'Full' },
        { label: 'Sencillo', value: 'Sencillo' },
        { label: 'Door to Dooor', value: 'Door to Dooor' },
        { label: 'Door to Port', value: 'Door to Port' },
        { label: 'Port to Door', value: 'Port to Door' },
        { label: 'Port to Port', value: 'Port to Port' }
    ];
    OptionsTipoServicioF = [
        { label: 'FTL', value: 'FTL' },
        { label: 'LTL', value: 'LTL' },
        { label: 'Door to Dooor', value: 'Door to Dooor' },
        { label: 'Door to Port', value: 'Door to Port' },
        { label: 'Port to Door', value: 'Port to Door' },
        { label: 'Port to Port', value: 'Port to Port' }
    ];
    OptionsTipoServicioC = [
        { label: 'A', value: 'A' },
        { label: 'B', value: 'B' },
        { label: 'C', value: 'C' },
        { label: 'Door to Dooor', value: 'Door to Dooor' },
        { label: 'Door to Port', value: 'Door to Port' },
        { label: 'Port to Door', value: 'Port to Door' },
        { label: 'Port to Port', value: 'Port to Port' }
    ];
    handleTipoServicioChange(event) {
        this.selectedTipoServicio = event.detail.value;
        this.obj.tipoServicio = event.detail.value;
    }

    tipoRutaOptions = [
        { label: 'Impo', value: 'Impo' },
        { label: 'Expo', value: 'Expo' }
    ];
    handleTipoRutaChange(event) {
        this.selectedTipoRuta = event.detail.value;
        this.obj.tipoRuta = event.detail.value;
    }
    servicioEspecialOptions = [
        { label: 'Sobrepeso', value: 'Sobrepeso' },
        { label: 'Sobredimensión', value: 'Sobredimensión' }
    ];
    handleServicioEspecialChange(event) {
        this.selectedServicioEspecial = event.detail.value;
        this.obj.servicioEspecial = event.detail.value;
        this.siservicioEspecial = true;
    }
    handleFileServicioEspecialChange(event){
        const file = event.target.files[0]
        if (file) {
        console.log('lo que se carga '+ file);
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileServicioEspecialData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId,
                'tipo' : 'ServicioEspecial'
            }
            console.log(this.fileServicioEspecialData)
        }
        reader.readAsDataURL(file)
        }
    }
    handleServicioEspecialUpload() {
        if (this.fileServicioEspecialData) {
            const {base64, filename, recordId, tipo} = this.fileServicioEspecialData
            uploadFile({ base64, filename, recordId, tipo }).then(result=>{
                    this.fileServicioEspecialData = null
                    this.showToast('Success', 'El archivo de Servicio Especial se subio con exito '+result, 'success');
                })
                .catch(error => {
                    this.showToast('Error', 'Error al cargar el archivo '+error.body.message, 'error');
                });
        }
    }
    servicioAdicionalOptions = [
        { label: 'Custodio', value: 'Custodio' },
        { label: 'Permisos', value: 'Permisos' }
    ];
    handleServicioAdicionalChange(event) {
        this.selectedservicioAdicional = event.detail.value;
        this.obj.servicioAdicional = event.detail.value;
    }
    tipoContenedorOptions = [
        { label: '20', value: '20' },
        { label: '40', value: '40' },
        { label: 'OT', value: 'OT' },
        { label: 'FR', value: 'FR' }
    ];
    handleTipoContenedorChange(event) {
        this.selectedTipoContenedor = event.detail.value;
        this.obj.tipoContenedor = event.detail.value;
    }
    optionsSiNo = [
        { label: 'Si', value: 'Si' },
        { label: 'No', value: 'No' }
    ];
    handleHazmatChange(event) {
        console.log('se dio clic '+event.detail.value);
        this.selectedHazmat = event.detail.value;
        if(this.selectedHazmat === 'Si'){
            this.obj.hazmat = true;
            this.sihazmat = true;
        }else{
            this.obj.hazmat = false;
            this.sihazmat = false;
        }
    }
    handleFileHazmatChange(event){
        const file = event.target.files[0]
        if (file) {
        console.log('lo que se carga '+ file);
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileHazmatData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId,
                'tipo': 'Hazmat'
            }
            console.log(this.fileHazmatData)
        }
        reader.readAsDataURL(file)
        }
    }
    handleHazmatUpload() {
        if (this.fileHazmatData) {
            const {base64, filename, recordId, tipo} = this.fileHazmatData
            uploadFile({ base64, filename, recordId, tipo }).then(result=>{
                    this.fileHazmatData = null
                    this.showToast('Success', 'El archivo de Servicio Especial se subio con exito '+result, 'success');
                })
                .catch(error => {
                    this.showToast('Error', 'Error al cargar el archivo '+error.body.message, 'error');
                });
        }
    }

    certificacionesOptions = [
        { label: 'CTPAT', value: 'CTPAT' },
        { label: 'OEA', value: 'OEA' }
    ];
    handleCertificacionesChange(event) {
        this.selectedCertificaciones = event.detail.value;
        this.obj.certificaciones = event.detail.value;
    }
    
    aeropuertoSalidaArriboOptions = [
        { label: 'NLU', value: 'NLU' },
        { label: 'LHR', value: 'LHR' },
        { label: 'JFK', value: 'JFK' }
    ];
    handleAeropuertoSalidaArriboChange(event) {
        this.selectedAeropuertoSalidaArribo = event.detail.value;
        this.obj.aeropuertoSalidaArribo = event.detail.value;
    }

    tipoSeguroOptions = [
        { label: 'Mercancia', value: 'Mercancia' },
        { label: 'Contenedor', value: 'Contenedor' }
    ];
    handleTipoSeguroChange(event) {
        this.selectedTipoSeguro = event.detail.value;
        this.obj.tipoSeguro = event.detail.value;
    }
    
    tipoServicioEmbarqueOptions = [
        { label: 'AEREO', value: 'AEREO' },
        { label: 'TERRESTRE', value: 'TERRESTRE' },
        { label: 'MARITIMO', value: 'MARITIMO' }
    ];
    handleTipoServicioEmbarqueChange(event) {
        this.selectedTipoServicioEmbarque = event.detail.value;
        this.obj.tipoServicioEmbarque = event.detail.value;
    }

    handleTransbordoChange(event) {
        this.selectedTransbordo = event.detail.value;
        if(this.selectedTransbordo === 'Si'){
            this.obj.transbordo = true;
        }
    }
    borderOptions = [
        { label: 'Norte', value: 'Norte' },
        { label: 'Sur', value: 'Sur' },
        { label: 'Marítimas', value: 'Marítimas' },
        { label: 'Interiores', value: 'Interiores' }
    ];
    handleBorderChange(event) {
        this.selectedBorder = event.detail.value;
        this.obj.border = event.detail.value;
        if(this.selectedBorder === 'Norte'){
            this.opCustomsNorte = true;
            this.opCustomsSur = false;
            this.opCustomsMaritimas = false;
            this.opCustomsInteriores = false;
        }else if(this.selectedBorder === 'Sur'){
            this.opCustomsNorte = false;
            this.opCustomsSur = true;
            this.opCustomsMaritimas = false;
            this.opCustomsInteriores = false;
        }else if(this.selectedBorder === 'Marítimas'){
            this.opCustomsNorte = false;
            this.opCustomsSur = false;
            this.opCustomsMaritimas = true;
            this.opCustomsInteriores = false;
        }else if(this.selectedBorder === 'Interiores'){
            this.opCustomsNorte = false;
            this.opCustomsSur = false;
            this.opCustomsMaritimas = false;
            this.opCustomsInteriores = true;
        }
    }
    OptionsCustomsNorte = [
        { label: 'Agua Prieta', value: 'Agua Prieta' },
        { label: 'Ciudad Acuña', value: 'Ciudad Acuña' },
        { label: 'Ciudad Camargo', value: 'Ciudad Camargo' },
        { label: 'Ciudad Juárez', value: 'Ciudad Juárez' },
        { label: 'Ciudad Miguel Alemán', value: 'Ciudad Miguel Alemán' },
        { label: 'Ciudad Reynosa', value: 'Ciudad Reynosa' },
        { label: 'Colombia', value: 'Colombia' },
        { label: 'Matamoros', value: 'Matamoros' },
        { label: 'Mexicali', value: 'Mexicali' },
        { label: 'Naco', value: 'Naco' },
        { label: 'Nogales', value: 'Nogales' },
        { label: 'Nuevo Laredo', value: 'Nuevo Laredo' },
        { label: 'Ojinaga', value: 'Ojinaga' },
        { label: 'Piedras Negras', value: 'Piedras Negras' },
        { label: 'Puerto Palomas', value: 'Puerto Palomas' },
        { label: 'San Luis Río Colorado', value: 'San Luis Río Colorado' },
        { label: 'Sonoyta', value: 'Sonoyta' },
        { label: 'Tecate', value: 'Tecate' },
        { label: 'Tijuana', value: 'Tijuana' }
    ];
    OptionsCustomsSur = [
        { label: 'Ciudad Hidalgo', value: 'Ciudad Hidalgo' },
        { label: 'Subteniente López', value: 'Subteniente López' }
    ];
    OptionsCustomsMaritimas = [
        { label: 'Acapulco', value: 'Acapulco' },
        { label: 'Altamira', value: 'Altamira' },
        { label: 'Cancún', value: 'Cancún' },
        { label: 'Ciudad del Carmen', value: 'Ciudad del Carmen' },
        { label: 'Coatzacoalcos', value: 'Coatzacoalcos' },
        { label: 'Dos Bocas', value: 'Dos Bocas' },
        { label: 'Ensenada', value: 'Ensenada' },
        { label: 'Guaymas', value: 'Guaymas' },
        { label: 'La Paz', value: 'La Paz' },
        { label: 'Lázaro Cárdenas', value: 'Lázaro Cárdenas' },
        { label: 'Manzanillo', value: 'Manzanillo' },
        { label: 'Mazatlán', value: 'Mazatlán' },
        { label: 'Progreso', value: 'Progreso' },
        { label: 'Salina Cruz', value: 'Salina Cruz' },
        { label: 'Tampico', value: 'Tampico' },
        { label: 'Tuxpan', value: 'Tuxpan' },
        { label: 'Veracruz', value: 'Veracruz' }
    ];
    OptionsCustomsInteriores = [
        { label: 'Aguascalientes', value: 'Aguascalientes' },
        { label: 'Chihuahua', value: 'Chihuahua' },
        { label: 'Guadalajara', value: 'Guadalajara' },
        { label: 'Guanajuato', value: 'Guanajuato' },
        { label: 'México', value: 'México' },
        { label: 'Monterrey', value: 'Monterrey' },
        { label: 'Puebla', value: 'Puebla' },
        { label: 'Querétaro', value: 'Querétaro' },
        { label: 'Toluca', value: 'Toluca' },
        { label: 'Torreón', value: 'Torreón' }
    ];
    handleCustomsChange(event) {
        this.selectedCustoms = event.detail.value;
        this.obj.customs = event.detail.value;
    }

    connectedCallback() {
        getCsv()
            .then(result => {
                this.obj = result;
                this.inicioWrapper = true;
            })
            .catch(csvError => {
                console.error('Error al cargar csv');
            });
            setTimeout(() => {
                this.rellenaLista();
            }, 400);
        infoGrupo({idOppo: this.recordId})
            .then(result => {
                this.inforGrupo = result;
                this.grupo = this.inforGrupo.Group__c;
                this.tipogrupo(this.grupo);
                if(this.inforGrupo.StageName === 'Ejecución'){
                   this.noEjecucion = false; 
                }
                console.log('la etapa es: ', this.inforGrupo.StageName);
            })
            .catch(error => {
                this.showToast('Error al cargar informacion del Producto','error', error.body.message);
            });
    }

    tipogrupo(grupo){
        switch (grupo) {
            case 'SP-PTO-PUERTOS':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaPM = true;
                this.vistaPMFA = true;
                this.opPM = true;
                break;
            case 'SP-M-MARITIMO':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaPM = true;
                this.vistaPMFA = true;
                this.opPM = true;
                break;
            case 'SP-FI-FLETE INTER':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaPMFA = true;
                this.vistaFA = true;
                this.vistaF = true;
                this.opF = true;
                break;
            case 'SP-A-AEREO':
                this.vistaPMFAC = true;
                this.vistaPMFA = true;
                this.vistaFA = true;
                this.vistaAC = true;
                break;
            case 'SP-CE-COMERCIO EXT':
                this.vistaPMFC = true;
                this.vistaPMFAC = true;
                this.vistaAC = true;
                this.vistaC = true;
                this.opC = true;
                break;
            case 'SP-EX-SEGUROS':
                this.vistaS = true;
                break;
            default:
                // Tratar variantes desconocidas
                break;
        }
    }

    rellenaLista(){
        getOpportunityLineItems({ opportunityId: this.recordId})
        .then(result => {
            this.opportunityLineItems = result;
            console.log('se llama rellena ', this.opportunityLineItems);
        })
        .catch(error => {
            //this.pushMessage('Error','error', error.body.message);
            console.error('Error rellenaLista');
        });

    }

    handleInputChange(event) {
        const IdOli = event.target.closest('tr').dataset.id;
        const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
            if (oli.IdOli === IdOli) {
                return { ...oli, [event.target.name]: event.target.value };
            }
            return oli;
        });
        this.opportunityLineItems = updatedOpportunityLineItems;
    }

    handleCheck(event) {
        const IdOli = event.target.closest('tr').dataset.id;
        //click
        const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
            if (oli.IdOli === IdOli) {
                return { ...oli, modificar: event.target.checked };
            }
            return oli;
        });
    
        this.opportunityLineItems = updatedOpportunityLineItems;
    }

    
    @track searchMercancia2;
    @track showMercancia2 = false;
    @track idTemporal;

    mercanciaSelect2(event){   
        this.searchMercancia2 = event.currentTarget.dataset.name;
        const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
            if (oli.IdOli === this.idTemporal) {
                return { ...oli, tipoMercancia: this.searchMercancia2, showFila:false};
            }
            return oli;
        });
        this.opportunityLineItems = updatedOpportunityLineItems;
        this.idTemporal='';
    }

    searchKeyMercancia2(event){
        this.searchMercancia2 = event.target.value;
        if (this.searchMercancia2.length >= 3) {
            const IdOli = event.target.closest('tr').dataset.id;
            this.idTemporal = IdOli;
            const updatedOpportunityLineItems = this.opportunityLineItems.map((oli) => {
                if (oli.IdOli === IdOli) {
                    return { ...oli, showFila: true};
                }
                return oli;
            });
            this.opportunityLineItems = updatedOpportunityLineItems;
            getClaveSAT({sat: this.searchMercancia2,record: '1'})
            .then(result => {
                this.listMercancia2 = result;
            })
            .catch(error => {
                this.showToast('Error', ' Carga de Mercancia: ' + error.body.message, 'error');
                this.listMercancia2 = null;
            });
        }
    }

    
    updateItems(event){
        this.isLoading = true;
        const itemsToModify = this.opportunityLineItems.filter(oli => oli.modificar);

        if (itemsToModify.length > 0) {
            const serializedItems = JSON.stringify(itemsToModify);
            updateItems({ jsonProduct: serializedItems})
            .then(() => {
                this.rellenaLista();
                this.showToast('Éxito', 'La operación se completó con éxito', 'success');
            })
            .catch(error => {
                //this.pushMessage('Error','error', error.body.message);
                this.showToast('Error', 'Se produjo un error durante la operación', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
            
        } 
        else {
            this.isLoading = false;
            this.showToast('warning', 'No ha seleccinoado lineas', 'warning');
        }

    }

    //Origen
    @track searchOrigen = '';
    @track OrigenId = '';
    @track showOrigen = false;

    origenSelect(event){
        this.searchOrigen = event.currentTarget.dataset.name;
        this.showOrigen = false;
        this.OrigenId = event.currentTarget.dataset.id;
        this.obj.origenId = event.currentTarget.dataset.id;
        this.obj.origen = event.currentTarget.dataset.name;
    }
    searchKeyOrigen(event){
        this.searchOrigen = event.target.value;
        this.OrigenId='';
        if (this.searchOrigen.length >= 3) {
            this.showOrigen = true;
            getCountry({country: this.searchOrigen})
                .then(result => {
                    this.listOrige = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.listOrige = null;
                });
        }
        else{
            this.showOrigen = false;
        }
    }

    @track searchDestino = '';
    @track destinoId = '';
    @track showDestino = false;

    searchKeyDestino(event){
        this.searchDestino = event.target.value;
        this.destinoId = '';
        if (this.searchDestino.length >= 3) {
            this.showDestino = true;
            getCountry({ country: this.searchDestino })
                .then(result => {
                    this.listDestino = result;
                })
                .catch(error => {
                    this.listDestino = [];
                });
        } else {
            this.showDestino = false;
        }
    }
    destinoSelect(event){
        this.searchDestino = event.currentTarget.dataset.name;
        this.showDestino = false;
        this.destinoId = event.currentTarget.dataset.id;
        this.obj.destinoId = event.currentTarget.dataset.id;
        this.obj.destino = event.currentTarget.dataset.name;
    }

    //ContainerType
    searchModalidad ='';
    modalidadId ='';
    showModalidad = false;
    
    selectModalidad(event){
        this.searchModalidad = event.currentTarget.dataset.name;
        this.showModalidad = false;
        this.modalidadId = event.currentTarget.dataset.id;
        this.obj.modalidad = event.currentTarget.dataset.name;
    }

    searchKeyModalidad(event){
        this.searchModalidad = event.target.value;
        this.modalidadId='';
        if (this.searchModalidad.length > 2) {
            this.showModalidad = true;
            getContainerType({Container: this.searchModalidad})
                .then(result => {
                    this.listModalidad = result;
                })
                .catch(error => {
                    this.listModalidad = null;
                });
        }
        else{
            this.showModalidad = false;
        }
    }

        //Tipo Mercancia
        @track searchMercancia = '';
        @track showMercancia = false;
    
        mercanciaSelect(event){   
            this.searchMercancia = event.currentTarget.dataset.name;
            this.showMercancia = false;
        }
        searchKeyMercancia(event){
            this.searchMercancia = event.target.value;
            if (this.searchMercancia.length >= 3) {
                this.showMercancia = true;
                getClaveSAT({sat: this.searchMercancia,record: '1'})
                .then(result => {
                    this.listMercancia = result;
                })
                .catch(error => {
                    this.showToast('Error', ' Carga de Mercancia: ' + error.body.message, 'error');
                    this.listMercancia = null;
                });
            }
            else{
                this.showMercancia = false;
            }
        }

    // guardar Registro extras
    //CpOrigen
    @track searchCpOrigen = '';
    @track CpOrigenId = '';
    @track showCpOrigen = false;

    cpOrigenSelect(event){
        this.searchCpOrigen = event.currentTarget.dataset.name;
        this.showCpOrigen = false;
        this.CpOrigenId = event.currentTarget.dataset.id;
        this.obj.idCpOrigen  = event.currentTarget.dataset.id;
        this.obj.direccionCarga = event.currentTarget.dataset.name;
    }
    searchKeyCpOrigen(event){
        this.searchCpOrigen = event.target.value;
        this.CpOrigenId='';
        if (this.searchCpOrigen.length >= 3) {
            this.showCpOrigen = true;
            getCp({cp: this.searchCpOrigen})
                .then(result => {
                    this.listCpOrigen = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.listCpOrigen = null;
                });
        }
        else{
            this.showCpOrigen = false;
        }
    }

    @track searchCpDestino = '';
    @track CpDestinoId = '';
    @track showCpDestino = false;

    searchKeyCpDestino(event){
        this.searchCpDestino = event.target.value;
        this.CpDestinoId = '';
        if (this.searchCpDestino.length >= 3) {
            this.showCpDestino = true;
            getCp({cp: this.searchCpDestino })
                .then(result => {
                    this.listCpDestino = result;
                })
                .catch(error => {
                    this.showToast('Error','error', error.body.message);
                    this.listCpDestino = null;
                });
        } else {
            this.showCpDestino = false;
        }
    }
    cpDestinoSelect(event){
        this.searchCpDestino = event.currentTarget.dataset.name;
        this.showCpDestino = false;
        this.cpDestinoId = event.currentTarget.dataset.id;
        this.obj.idCpDestino = event.currentTarget.dataset.id;
        this.obj.direccionDescarga = event.currentTarget.dataset.name;
    }
    handleUnitPerFrequencyChange(event){
        this.unitPerFrequency = event.target.value;
        console.log('entra a unidad de frecuencia ',this.unitPerFrequency);
        this.calculoVolumenMensual(this.unitPerFrequency);
    }
    @track valueVolumenMensual;
    calculoVolumenMensual(unitFrequency){
        console.log('entra a calculo mensual ',unitFrequency,' La frecuencia: ',this.selectedFrecuencia);
        var calculo = 0;
        const frecuencia = +unitFrequency;
        console.log(' La frecuencia: ',frecuencia);
        switch (this.selectedFrecuencia) {
            case 'Diario':
                calculo = frecuencia * 30;
                console.log('tipo de frecuencia Diario: ', calculo);
                break;
            case 'Semanal':
                calculo = frecuencia * 4;
                console.log('tipo de frecuencia Semanal: ', calculo);
                break;
            case 'Mensual':
                calculo = frecuencia;
                console.log('tipo de frecuencia Mensual: ', calculo);
                break;
            case 'Anual':
                calculo = frecuencia / 12;
                console.log('tipo de frecuencia Anual: ', calculo);
                break;
            default:
                // Tratar variantes desconocidas
                break;
        }
        console.log('el calculo: ', calculo);
        this.valueVolumenMensual = calculo;
    }
    handleVolumenMensualChange(event){
        this.obj.volumenMensual = event.target.value;
        this.valueVolumenMensual = event.target.value;
    }
    handlePuertoSalidaChange(event){
        this.obj.puertoSalidaArribo = event.target.value;
    }
    handleAccesorialesChange(event){
        this.obj.accesoriales = event.target.value;
    }
    handleItemHeightChange(event){
        this.obj.itemHeight = event.target.value;
    }
    handleItemWidthChange(event){
        this.obj.itemWidth = event.target.value;
    }
    handleItemLenghtChange(event){
        this.obj.itemLenght = event.target.value;
    }
    handleFronteraCruceChange(event){
        this.obj.fronteraCruce = event.target.value;
    }
    handleFechaInicioEmbarqueChange(event){
        this.obj.fechaInicioEmbarque = event.target.value;
    }
    handleFechaFinEmbarqueChange(event){
        this.obj.fechaFinEmbarque = event.target.value;
    }
    handleRazonSocialEmbarcadorChange(event){
        this.obj.razonSocialEmbarcador = event.target.value;
    }
    handleRazonSocialImportadorChange(event){
        this.obj.razonSocialImportador = event.target.value;
    }
    handlePiezasChange(event){
        this.obj.piezas = event.target.value;
    }

    //Es para agregar un nuevo producto
    aceptar() {
        if (!this.isValid()) {
            // Si no son válidos, muestra un mensaje de advertencia
            this.showToast('Error', 'Faltan campos requeridos','error');
            return;
        }

        this.isLoading = true;
        this.obj.unidadPorFrecuencia = this.unitPerFrequency;
        this.obj.tipoMercancia = this.searchMercancia;
        this.obj.pesoDeCarga = this.weight;
        this.obj.cantidad = this.unitPerFrequency;
        this.obj.tiempoCarga = this.timeLoad;
        this.obj.tiempoDescarga = this.timeUnload;
        this.obj.comentarios = this.comentarios;
        this.obj.target = this.target;
        const serializedObj = JSON.stringify(this.obj);

        createProduct({opportunityId: this.recordId, jsonProduct: serializedObj})
        .then(result => {
            for (let key in this.obj) {
                if (this.obj.hasOwnProperty(key)) {
                    this.obj[key] = '';  // o cualquier valor predeterminado
                }
            }
            this.limpiar();
            this.rellenaLista();
            if(this.siservicioEspecial === true){
                this.handleServicioEspecialUpload();
            }
            if(this.sihazmat === true){
                this.handleHazmatUpload();
            }
            this.showToast('Éxito', 'Operación completada exitosamente.', 'success');
        })
        .catch(error => {
            this.showToast('Error', 'No se pudo crear Contacte a su Administrador: ', 'error');
        })
        .finally(() => {
            this.isLoading = false;
        });
    }

    isValid() {
        const requiredFields = [
            this.searchOrigen,
            this.searchDestino,
            this.searchModalidad,
            this.unitPerFrequency,
            this.searchMercancia,
            this.weight,
            //this.cpOrigenId,
            //this.cpDestinoId,
            //this.quantity,
            this.timeLoad,
            this.timeUnload,
            this.selectedMoneda
        ];
    
        // Verifica si alguno de los campos requeridos es nulo o vacío
        return requiredFields.every(field => field !== undefined && field !== '' && field !== null);
    }
    
    limpiar(){
        this.searchOrigen='';
        this.searchDestino='';
        this.selectedFrecuencia = '';
        this.searchModalidad = '';
        this.unitPerFrequency ='';
        this.searchMercancia = '';
        this.weight='';
        this.cpDestinoId='';
        this.cpOrigenId='';
        this.quantity='';
        this.timeLoad='';
        this.timeUnload='';
        this.comentarios='';
        this.target='';
        this.selectedIncoterm='';
        this.buyPrice='';
        this.selectedMoneda = '';
        this.searchCpOrigen = '';
        this.searchCpDestino = '';
        this.selectedUnidadPeso = '';
        this.selectedTipoServicio = '';
        this.selectedTipoRuta = '';
        this.selectedServicioEspecial = '';
        this.siservicioEspecial = false;
        this.fileServicioEspecialData = false;
        this.selectedServicioAdicional = '';
        this.selectedTipoContenedor = '';
        this.selectedHazmat = '';
        this.sihazmat = false;
        this.fileHazmatData = false;
        this.selectedCertificaciones = '';
        this.selectedTransbordo = '';
        this.selectedTipoSeguro = '';
        this.selectedTipoServicioEmbarque = '';
        this.valueVolumenMensual = '';
        this.obj.puertoSalidaArribo = '';
        this.obj.accesoriales = '';
        this.obj.itemHeight = '';
        this.obj.itemWidth = '';
        this.obj.itemLenght = '';
        this.obj.fronteraCruce = '';
        this.obj.fechaInicioEmbarque = '';
        this.obj.fechaFinEmbarque = '';
        this.obj.razonSocialEmbarcador = '';
        this.obj.razonSocialImportador = '';
        this.obj.piezas = '';
        this.selectedBorder = '';
        this.selectedCustoms = '';
    }

    cerrar(){
        this.close('close');
        location.reload();
        //history.back();
        //this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleChange(event) {
        const fieldName = event.target.dataset.fieldname;
        const value = event.target.value;
        this[fieldName] = value;
    }

    showToast(title, message, variant) {
        switch (variant) {
            case 'success':
                this.showSuccess = true;
                this.successMessage = message;
                this.successClass = 'success-message';
                break;
            case 'warning':
                this.showWarning = true;
                this.warningMessage = message;
                this.warningClass = 'warning-message';
                break;
            case 'error':
                this.showError = true;
                this.errorMessage = message;
                this.errorClass = 'error-message';
                break;
            default:
                // Tratar variantes desconocidas
                break;
        }
    
        // Ocultar mensajes después de un tiempo determinado
        setTimeout(() => {
            this.showSuccess = this.showWarning = this.showError = false;
        }, 3500);
    }

@track showWarning = false;
@track warningMessage = '';
@track warningClass = '';

@track showSuccess = false;
@track successMessage = '';
@track successClass = '';

@track showError = false;
@track errorMessage = '';
@track errorClass = '';

closeMessage() {
    this.showSuccess = this.showWarning = this.showError = false;
}

}