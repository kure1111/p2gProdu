import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContainerType from '@salesforce/apex/P2G_CreacionCargoLines.getContainerType';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getCarrier from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getCarrier';
import getOpeExe from '@salesforce/apex/P2G_AsignacionOppr.searchOpExecutive';
import mapeoWrapperObj from '@salesforce/apex/P2G_DisponibilidadOfertada.crearDisponibilidad';
import getWrapper from '@salesforce/apex/P2G_DisponibilidadOfertada.getWrapper';
import obtenerDisponibilidades from '@salesforce/apex/P2G_DisponibilidadOfertada.obtenerDisponibilidades';
import rutasVencidasApex from '@salesforce/apex/P2G_DisponibilidadOfertada.rutasVencidas';
import cargaLineas from '@salesforce/apex/P2G_cargaDisponibilidad.cargaLineas';

export default class P2g_Disponibilidad extends LightningElement {
    @track isModalOpen = false;
    @track isMassiveModalOpen = false;
    
    @track wrapper;
    @track errores;

    openModal() {
        this.isModalOpen = true;
        this.disponibilidades();
    }

    openMassiveModal() {
        this.isMassiveModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    closeMassiveModal() {
        this.isMassiveModalOpen = false;
    }

    rutasVencidas() {
        const selectedItems = this.data.filter(item => item.isSelected);
        rutasVencidasApex({ wrapperList: selectedItems })
            .then(result => {
                this.pushMessage('Exitoso!','success','Se actualizaron con exito!');
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
            });
        this.isModalOpen = false;
    }

    @track data;

    connectedCallback() {
        this.disponibilidades();
        getWrapper()
        .then(result => {
            this.wrapper = result;
            console.log('disponibilidad:', this.wrapperObject);
        })
        .catch(error => {
            console.error('Error disponibilidad', error);
        });
    }

    disponibilidades(){
        obtenerDisponibilidades({op: 2})
        .then(result => {
            this.data = result;
            console.log('Objeto Wrapper recibido:', this.wrapperObject);
        })
        .catch(error => {
            console.error('Error al llamar obtenerDisponibilidades:', error);
        });
    }

    //Container Type
    @track searchValueConteiner;
    @track idConteiner;
    @track listContainers;
    SideSelectContainerType(event){
        this.searchValueConteiner = event.target.outerText;
        this.idConteiner = event.currentTarget.dataset.id;
        this.listContainers = null;
    }
    searchKeyContainerType(event){
        this.searchValueConteiner = event.target.value;
        this.idConteiner='';
        if (this.searchValueConteiner.length >= 3) {
            getContainerType({Container: this.searchValueConteiner})
                .then(result => {
                    this.listContainers = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.listContainers = null;
                });
        }
        else{
            this.listContainers = null;
        }
    }
    @track time = '';

    handleDateTimeChange(event) {
        this.time = event.target.value;
        console.log('fecha: ',this.time);
    }

    @track units;
    handleUnitsChange(event) {
        this.units = event.target.value;
    }

    @track tikectProm;
    handletikectPromChange(event) {
        this.tikectProm = event.target.value;
    }

    @track venta;
    handleVentaChange(event) {
        this.venta = event.target.value;
    }

    // buscador Site of Load
    @track searchValueLoad;
    @track searchValueIdLoad;
    @track sideRecordsLoad;
    SideSelectLoad(event){
        this.searchValueLoad = event.target.outerText;
        this.searchValueIdLoad = event.currentTarget.dataset.id;
        this.sideRecordsLoad = null;
    }
    searchKeyLoad(event){
        this.searchValueLoad = event.target.value;
        this.searchValueIdLoad='';
        if (this.searchValueLoad.length >= 3) {
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
            this.sideRecordsLoad = null;
        }
    }

    // buscador Site of UnLoad
    @track searchValueUnLoad;
    @track searchValueIdUnLoad;
    @track sideRecordsUnLoad;
    SideSelectUnLoad(event){
        this.searchValueUnLoad = event.target.outerText;
        this.searchValueIdUnLoad = event.currentTarget.dataset.id;
        this.sideRecordsUnLoad = null;
    }
    searchKeyUnLoad(event){
        this.searchValueUnLoad = event.target.value;
        this.searchValueIdUnLoad='';
        if (this.searchValueUnLoad.length >= 3) {
            getSide({country: this.searchValueUnLoad})
                .then(result => {
                    this.sideRecordsUnLoad = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsUnLoad = null;
                });
        }
        else{
            this.sideRecordsUnLoad = null;
        }
    }

    //buscar Carrier
    @track searchValueCarrier;
    @track searchValueIdCarrier;
    @track sideRecordsCarrier;
    searchKeyCarrier(event) {
        this.searchValueCarrier = event.target.value;
        this.searchValueIdCarrier = '';

        if (this.searchValueCarrier.length >= 3) {
            getCarrier({ carrier: this.searchValueCarrier })
                .then(result => {
                    this.sideRecordsCarrier = result;
                })
                .catch(error => {
                    this.pushMessage('Error', 'error', error.body.message);
                    this.sideRecordsCarrier = null;
                });
        } else {
            this.sideRecordsCarrier = null;
        }
    }

    // Modifica este método para manejar la selección de un carrier
    SideSelectCarrier(event) {
        this.searchValueCarrier = event.target.outerText;
        this.searchValueIdCarrier = event.currentTarget.dataset.id;
        this.sideRecordsCarrier = null;
    }

    //Operation Executive
    @track searchValueOpExecutive;
    @track searchValueIdOpExecutive;
    @track sideRecordsOpExecutive;
    searchKeyOpExecutive(event) {
        this.searchValueOpExecutive = event.target.value;
        this.searchValueIdOpExecutive = '';
    
        if (this.searchValueOpExecutive.length >= 3) {
            getOpeExe({ search: this.searchValueOpExecutive })
                .then(result => {
                    this.sideRecordsOpExecutive = result;
                })
                .catch(error => {
                    this.pushMessage('Error', 'error', error.body.message);
                    this.sideRecordsOpExecutive = null;
                });
        } else {
            this.sideRecordsOpExecutive = null;
        }
    }

    SideSelectOpExecutive(event) {
        this.searchValueOpExecutive = event.target.outerText;
        this.sideRecordsOpExecutive = null;
        this.searchValueIdOpExecutive = event.currentTarget.dataset.id;
    }

    agregar(){
        this.wrapper.searchValueIdLoad = this.searchValueIdLoad;
        this.wrapper.searchValueIdUnLoad = this.searchValueIdUnLoad;
        this.wrapper.fechaVigencia = this.time+':00';
        this.wrapper.noRutas = this.units;
        this.wrapper.idContainerType = this.idConteiner;
        this.wrapper.ticketPromedio = this.tikectProm;
        this.wrapper.venta = this.venta;
        this.wrapper.carrier = this.searchValueIdCarrier;
        this.wrapper.planner = this.searchValueIdOpExecutive;
        console.log('fechaVigencia ',  this.fechaVigencia);
        mapeoWrapperObj({ wrapper: this.wrapper })
        .then(result => {
            this.wrapper = null;
            this.isModalOpen = false;
            this.pushMessage('Exitoso!','success','Se creo con exito!');

        })
        .catch(error => {
            this.isModalOpen = false;
            console.log('Error en Crear Objeto mapeoWrapperObj');
            this.pushMessage('Error','error', error.body.message);
        });

        
    }

    handleCheckboxChange(event) {
        const index = event.target.dataset.index;
        this.data[index].isSelected = event.target.checked;
        console.log(this.data[index].id);
    }

    pushMessage(title, variant, message){
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        });
        this.dispatchEvent(event);
    }
    
    triggerFileUpload() {
        this.template.querySelector('input[type="file"]').click();
    }

    downloadTemplate() {
        const url = 'https://pak2gologistics.my.salesforce.com/sfc/p/4T000000DybZ/a/RQ000004PspJ/WK8lindKYVM4aUGaw6rtjP2_tHxX2NMyg10Pch.nHjc';
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', 'plantilla.csv'); // Nombre del archivo para descargar
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    
    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = () => {
                const csv = reader.result;
                const json = this.csvToJson(csv);
                this.csvData = json;
                this.processCSV(json);
            };
            reader.readAsText(file, 'UTF-8');
        }
        
    }

    csvToJson(csv) {
        const lines = csv.split("\n");
        const result = [];
        const headers = lines[0].split(",");
    
        for (let i = 1; i < lines.length; i++) {
            const currentline = lines[i].trim();
    
            // Saltar líneas vacías
            if (currentline === "") {
                continue;
            }
    
            const obj = {};
            const data = currentline.split(",");
    
            for (let j = 0; j < headers.length; j++) {
                obj[headers[j].trim()] = data[j] ? data[j].trim() : null;
            }
    
            result.push(obj);
        }
    
        return result;
    }
    

    mapCsvToWrapperDispo(data) {
        return data.map(item => {
            return {
                carrier: item["Carrier"],
                idContainerType: item["Container Type"],
                fechaVigencia: item["Fecha de vigencia"] +" "+item["Hora de vencimiento (hrs)"] + ":00",
                planner: item["Planner"],
                searchValueIdLoad: item["Locacion de origen"],
                searchValueIdUnLoad: item["Locacion de destino"],
                ticketPromedio: item["Ticket Prom"],
                noRutas: item["No rutas"]
            };
        });
    }

    processCSV(data) {
        console.log('Processing CSV data');
        const mappedData = this.mapCsvToWrapperDispo(data);
        console.log('Mapped data:', mappedData);
        cargaLineas({ csvData: JSON.stringify(mappedData) })
            .then(result => {
                this.pushMessage('Exitoso!', 'success', 'Datos cargados con éxito!');
            })
            .catch(error => {
                this.pushMessage('Error', 'error', error.body.message);
            });
    }

        
}