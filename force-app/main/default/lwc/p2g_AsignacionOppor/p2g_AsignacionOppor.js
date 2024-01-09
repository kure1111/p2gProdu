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

    //seccion 1 ----------
    @track selectedGroup = '';
    @track selectedRadio = 'all';
    @track startDate = '';
    @track endDate = '';

    @track isLoading = false;
    // Opciones para el filtro de grupo
    groupOptions = [
        { label: 'Venta', value: 'venta' },
        { label: 'Marketing', value: 'marketing' },
        { label: 'Admin', value: 'admin' },
    ];

    radioOptions = [
        { label: 'All shipments', value: 'all' },
        { label: 'Mis Shipments', value: 'mios' },
    ];
    handleNameClick(event) {
        event.preventDefault(); // Previene la acción predeterminada del enlace
        const recordId = event.currentTarget.dataset.recordId;
    
        // Construye la URL del registro y redirige al usuario
        const recordUrl = `/lightning/r/Shipment__c/${recordId}/view`;
        window.open(recordUrl, '_blank');
    }
    connectedCallback() {
        this.updateColumns();
        setInterval(() => {
            this.updateColumns();
            this.refreshData();
        }, 30000); // 30 segundos
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
        console.log('El id seleccionado es: ',this.searchValueIdAccount);
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

    //   Carrierr

    // Asegúrate de tener esta variable definida en tu componente
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
        console.log('El id seleccionado del carrier es: ', this.searchValueIdCarrier);
    }

    //------------ seccion 2
    updateColumns() {
        getColumns({datos: ['2', 'Pending', this.startDate, this.endDate,this.selectedRadio,this.searchValueIdAccount,this.searchValueIdCarrier,this.searchValueIdOpExecutive]})
        .then(result => {
            this.listShipmentsCol2 = result[0];
            this.listShipmentsCol3 = result[1];
            this.listShipmentsCol4 = result[2];
            this.listShipmentsCol5 = result[3];
            this.listShipmentsCol6 = result[4];
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
        const value = event.target.value;
    
        if (fieldName === 'startDate' || fieldName === 'endDate') {
            this[fieldName] = value;
            this.updateColumns();
            this.refreshData();
        }
    }

    handleTakeButtonClick(event) {
        const shipmentId = event.currentTarget.dataset.id;
        this.isLoading = true;
        updateExecute({ shipmentId: shipmentId, datos: ['2', 'Pending', this.startDate, this.endDate,this.selectedRadio]})
            .then(result => {
                //this.listShipmentsCol2 = result[0];
                //this.listShipmentsCol3 = result[1];
                this.updateColumns();
            })
            .catch(error => {
                console.error('Error al llamar a updateExecute:', error);
            })
            .finally(() => {
                this.isLoading = false;
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

get colorCoded() {
    return this.listShipmentsCol3.map(account => {
        const lastModifiedDate = account.LastModifiedDate;
        const now = new Date();
        const modifiedDate = new Date(lastModifiedDate);
        const differenceInMinutes = Math.abs((now - modifiedDate) / (1000 * 60));

        let circleClass = '';

        if (differenceInMinutes > 120) {
            circleClass = 'circle red';
        } else if (differenceInMinutes >= 30 && differenceInMinutes <= 120) {
            circleClass = 'circle yellow';
        } else if (differenceInMinutes < 30) {
            circleClass = 'circle green';
        }
        return {
            ...account,
            circleClass: circleClass,
        };
    });
}
get colorCoded2() {
    return this.listShipmentsCol2.map(account => {
        const lastModifiedDate = account.LastModifiedDate;
        const now = new Date();
        const modifiedDate = new Date(lastModifiedDate);
        const differenceInMinutes = Math.abs((now - modifiedDate) / (1000 * 60));

        let circleClass = '';

        if (differenceInMinutes > 2) {
            circleClass = 'circle red';
        } else if (differenceInMinutes >= 1 && differenceInMinutes <= 2) {
            circleClass = 'circle yellow';
        } else if (differenceInMinutes < 1) {
            circleClass = 'circle green';
        }
        return {
            ...account,
            circleClass2: circleClass,
        };
    });
}


    
    
///-------------------------secicon 3----------
@track status = 'All';
@track seccion3Data;


handleStatusAndFechaChange(event){
    const value = event.target.value;
    this.status = value;
    this.refreshData();
}

refreshData() {
    seccion3({datos:[this.status,this.startDate,this.endDate,this.selectedRadio,this.searchValueIdAccount,this.searchValueIdCarrier,this.searchValueIdOpExecutive]})
        .then(result => {
            this.seccion3Data = result;
        })
        .catch(error => {
            console.error('Error al llamar a refreshData:', error);
        });
}



}