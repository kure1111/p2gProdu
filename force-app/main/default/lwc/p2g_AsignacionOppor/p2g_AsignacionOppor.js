// accountListLWC.js
import { LightningElement, wire,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import seccion3 from '@salesforce/apex/P2G_AsignacionOppr.seccion3';
import updateExecute from '@salesforce/apex/P2G_AsignacionOppr.updateExecute';
import getColumns from '@salesforce/apex/P2G_AsignacionOppr.columns'; 
import getAccount from '@salesforce/apex/P2G_AsignacionOppr.searchAccounts';
import getOpeExe from '@salesforce/apex/P2G_AsignacionOppr.searchOpExecutive';
import getCarrier from '@salesforce/apex/P2G_UpdateShipmentServiceLine.getCarrier';

export default class P2g_AsignacionOppor extends LightningElement {
    @track listShipmentsCol1;
    @track listShipmentsCol2;
    @track listShipmentsCol3;
    @track listShipmentsCol4;
    @track listShipmentsCol5;
    @track listShipmentsCol6;
    @track listShipmentsCol7;

    //seccion 1 ----------
    @track selectedGroup = '';
    @track selectedRadio = 'all';
    @track startDate = '';
    @track endDate = '';

    @track isLoading = false;
    @track tipoServicio = 'All';

    @track status = 'All';
    @track seccion3Data;

    @track valorCheckbox = true;


    radioOptions = [
        { label: 'All shipments', value: 'all' },
        { label: 'Mis Shipments', value: 'mios' },
    ];

    @track showButton = true;

    handleNameClick(event) {
        event.preventDefault(); // Previene la acción predeterminada del enlace
        const recordId = event.currentTarget.dataset.recordId;
    
        // Construye la URL del registro y redirige al usuario
        const recordUrl = `/lightning/r/Shipment__c/${recordId}/view`;
        window.open(recordUrl, '_blank');
    }
    connectedCallback() {
        this.updateColumns();
        this.refreshData();
        setInterval(() => {
            this.updateColumns();
            this.refreshData();
        }, 60000); // 30 segundos
    }

    chanceVerTodo(event) {
        this.valorCheckbox = event.target.checked;
    }

    /// busqueda account
    @track searchValueAccount = '';
    @track showSideAccount = false;
    @track sideRecordsAccount;
    @track searchValueIdAccount;

    SideSelectAccount(event){
        this.searchValueAccount = event.target.outerText;
        this.showSideAccount = false;
        this.searchValueIdAccount = event.currentTarget.dataset.id;
        this.updateColumns();
        this.refreshData();
    }
    searchKeyAccount(event){
        this.searchValueAccount = event.target.value;
        this.searchValueIdAccount='';
        if (this.searchValueAccount.length >= 3) {
            this.showSideAccount = true;
            getAccount({search: this.searchValueAccount})
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

    //Operation Executive
    @track sideRecordsOpExecutive;
    @track searchValueOpExecutive = '';
    @track showSideOpExecutive = false;
    @track searchValueIdOpExecutive;

    searchKeyOpExecutive(event) {
        this.searchValueOpExecutive = event.target.value;
        this.searchValueIdOpExecutive = '';
    
        if (this.searchValueOpExecutive.length >= 3) {
            this.showSideOpExecutive = true;
            // Llama a tu método Apex para buscar ejecutivos de operaciones
            getOpeExe({ search: this.searchValueOpExecutive })
                .then(result => {
                    this.sideRecordsOpExecutive = result;
                })
                .catch(error => {
                    this.pushMessage('Error', 'error', error.body.message);
                    this.sideRecordsOpExecutive = null;
                });
        } else {
            this.showSideOpExecutive = false;
            this.updateColumns();
        }
    }

    SideSelectOpExecutive(event) {
        this.searchValueOpExecutive = event.target.outerText;
        this.showSideOpExecutive = false;
        this.searchValueIdOpExecutive = event.currentTarget.dataset.id;
        this.updateColumns();
        this.refreshData();
        console.log('El id seleccionado del ejecutivo de operaciones es: ', this.searchValueIdOpExecutive);
    }

    //Operation Executive Asignado
    @track sideRecordsOpExecutiveA;
    @track searchValueOpExecutiveA = '';
    @track showSideOpExecutiveA = false;
    @track searchValueIdOpExecutiveA;

    searchKeyOpExecutiveA(event) {
        this.searchValueOpExecutiveA = event.target.value;
        this.searchValueIdOpExecutiveA = 'No';
    
        if (this.searchValueOpExecutiveA.length >= 3) {
            this.showSideOpExecutiveA = true;
            this.showButton = false;
            // Llama a tu método Apex para buscar ejecutivos de operaciones
            getOpeExe({ search: this.searchValueOpExecutiveA })
                .then(result => {
                    this.sideRecordsOpExecutiveA = result;
                })
                .catch(error => {
                    this.pushMessage('Error', 'error', error.body.message);
                    this.sideRecordsOpExecutiveA = null;
                    this.searchValueIdOpExecutiveA = 'No';
                });
        } else {
            this.showButton = true;
            this.showSideOpExecutiveA = false;
            this.updateColumns(); //quitar ????????????????????????????????????????????
        }
    }

    SideSelectOpExecutiveA(event) {
        this.searchValueOpExecutiveA = event.target.outerText;
        this.showSideOpExecutiveA = false;
        this.searchValueIdOpExecutiveA = event.currentTarget.dataset.id;
        this.updateColumns();
        this.refreshData();
    }

    //   Carrierr
    @track searchValueCarrier = '';
    @track showSideCarrier = false;
    @track sideRecordsCarrier;
    @track searchValueIdCarrier;

    // Agrega este método para manejar la búsqueda de carriers
    searchKeyCarrier(event) {
        this.searchValueCarrier = event.target.value;
        this.searchValueIdCarrier = '';

        if (this.searchValueCarrier.length >= 3) {
            this.showSideCarrier = true;
            // Llama a tu método Apex para buscar carriers
            getCarrier({ carrier: this.searchValueCarrier })
                .then(result => {
                    this.sideRecordsCarrier = result;
                })
                .catch(error => {
                    this.pushMessage('Error', 'error', error.body.message);
                    this.sideRecordsCarrier = null;
                });
        } else {
            this.showSideCarrier = false;
        }
    }

    // Modifica este método para manejar la selección de un carrier
    SideSelectCarrier(event) {
        this.searchValueCarrier = event.target.outerText;
        this.showSideCarrier = false;
        this.searchValueIdCarrier = event.currentTarget.dataset.id;
        this.updateColumns();
        this.refreshData();
    }

    //------------ seccion 2
    updateColumns() {
        getColumns({datos: ['2', 'Pending', this.startDate, this.endDate,this.selectedRadio,this.searchValueIdAccount,this.searchValueIdCarrier,this.searchValueIdOpExecutive,this.tipoServicio]})
        .then(result => {
            this.listShipmentsCol2 = result[0];
            this.listShipmentsCol3 = result[1];
            this.listShipmentsCol4 = result[2];
            this.listShipmentsCol5 = result[3];
            this.listShipmentsCol6 = result[4];
            this.listShipmentsCol7 = result[5];
        })
        .catch(error => {
            console.error('Error al llamar a updateExecute:', error);
        });         
    }

    handleGroupChange(event) {
        this.selectedGroup = event.detail.value;
    }

    handleRadioChange(event) {
        this.selectedRadio = event.detail.value;
        this.updateColumns();
        this.refreshData();
    }

    fechaChangeSec1(event) {
        const fieldName = event.target.name;
        let value = event.target.value;
    
        if (fieldName === 'startDate' || fieldName === 'endDate') {
            const august2023 = new Date('2023-08-01');
            const selectedDate = new Date(value);
    
            if (selectedDate < august2023) {
                const formattedAugust2023 = august2023.toISOString().split('T')[0];
                value = formattedAugust2023;
            }
            this[fieldName] = value;
            this.updateColumns();
            this.refreshData();
        }
    }

    handleTakeButtonClick(event) {
        const shipmentId = event.currentTarget.dataset.id;
        event.preventDefault();
        this.isLoading = true;
        updateExecute({ shipmentId: shipmentId, datos: ['2', this.searchValueIdOpExecutiveA, this.startDate, this.endDate,this.selectedRadio]})
            .then(result => {
                this.updateColumns();
            })
            .catch(error => {
                console.error('Error al llamar a updateExecute:', error);
            })
            .finally(() => {
                this.isLoading = false;
                const recordUrl = `/lightning/r/Shipment__c/${shipmentId}/view`;
                window.open(recordUrl, '_blank');
            });        
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    get colorCoded2() {
        return this.listShipmentsCol2.map(account => {
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            const fechaString = account.ETD_from_Point_of_Load__c;
            const fechaParts = fechaString.split('-'); 
            // Convertir milisegundos a minutos
            const etdMinutes = etdTimeMillis / (1000 * 60);
    
            const now = new Date();
            const nowMinutes = now.getHours() * 60 + now.getMinutes(); // Convertir la hora actual a minutos
    
            const differenceInMinutes = etdMinutes - nowMinutes;
    
            let circleClass = '';
    
            if (differenceInMinutes > 360) { // Más de 6 horas
                circleClass = 'circle green';
            } else if (differenceInMinutes >= 240 && differenceInMinutes <= 360) { // Entre 4 y 6 horas
                circleClass = 'circle yellow';
            } else if (differenceInMinutes >= 0 && differenceInMinutes < 240) { // Menos de 4 horas
                circleClass = 'circle red';
            } else { // Negativo (pasado)
                circleClass = 'circle black';
            }
            if (parseInt(fechaParts[0]) <= now.getFullYear() && parseInt(fechaParts[1]) <= now.getMonth() + 1 && parseInt(fechaParts[2]) < now.getDate()) {
                circleClass = 'circle black';
            }
    
            return {
                ...account,
                circleClass2: circleClass,
            };
        });
    }

    get colorCoded4() {
        return this.listShipmentsCol4.map(account => {
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            const fechaString = account.ETD_from_Point_of_Load__c;
            const fechaParts = fechaString.split('-'); 
            // Convertir milisegundos a minutos
            const etdMinutes = etdTimeMillis / (1000 * 60);
    
            const now = new Date();
            const nowMinutes = now.getHours() * 60 + now.getMinutes(); // Convertir la hora actual a minutos
    
            const differenceInMinutes = etdMinutes - nowMinutes;
    
            let circleClass = '';
    
            if (differenceInMinutes > 360) { // Más de 6 horas
                circleClass = 'circle green';
            } else if (differenceInMinutes >= 240 && differenceInMinutes <= 360) { // Entre 4 y 6 horas
                circleClass = 'circle yellow';
            } else if (differenceInMinutes >= 0 && differenceInMinutes < 240) { // Menos de 4 horas
                circleClass = 'circle red';
            } else { // Negativo (pasado)
                circleClass = 'circle black';
            }
            if (parseInt(fechaParts[0]) <= now.getFullYear() && parseInt(fechaParts[1]) <= now.getMonth() + 1 && parseInt(fechaParts[2]) < now.getDate()) {
                circleClass = 'circle black';
            }
    
            return {
                ...account,
                circleClass: circleClass,
            };
        });
    }
    
    get colorCoded5() {
        return this.listShipmentsCol5.map(account => {
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            const fechaString = account.ETD_from_Point_of_Load__c;
            const fechaParts = fechaString.split('-'); 
            // Convertir milisegundos a minutos
            const etdMinutes = etdTimeMillis / (1000 * 60);
    
            const now = new Date();
            const nowMinutes = now.getHours() * 60 + now.getMinutes(); // Convertir la hora actual a minutos
    
            const differenceInMinutes = etdMinutes - nowMinutes;
    
            let circleClass = '';
    
            if (differenceInMinutes > 360) { // Más de 6 horas
                circleClass = 'circle green';
            } else if (differenceInMinutes >= 240 && differenceInMinutes <= 360) { // Entre 4 y 6 horas
                circleClass = 'circle yellow';
            } else if (differenceInMinutes >= 0 && differenceInMinutes < 240) { // Menos de 4 horas
                circleClass = 'circle red';
            } else { // Negativo (pasado)
                circleClass = 'circle black';
            }
            if (parseInt(fechaParts[0]) <= now.getFullYear() && parseInt(fechaParts[1]) <= now.getMonth() + 1 && parseInt(fechaParts[2]) < now.getDate()) {
                circleClass = 'circle black';
            }
    
            return {
                ...account,
                circleClass: circleClass,
            };
        });
    }
///-------------------------secicon 3----------


handleStatusAndFechaChange(event){
    const value = event.target.value;
    this.status = value;
    this.refreshData();
}
handleTipoServicio(event){
    const value = event.target.value;
    this.tipoServicio = value;
    this.updateColumns();
    this.refreshData();
}

refreshData() {
    seccion3({datos:[this.status,this.startDate,this.endDate,this.selectedRadio,this.searchValueIdAccount,this.searchValueIdCarrier,this.searchValueIdOpExecutive,this.tipoServicio]})
        .then(result => {
            this.seccion3Data = result;
        })
        .catch(error => {
            console.error('Error al llamar a refreshData:', error);
        });
}



}