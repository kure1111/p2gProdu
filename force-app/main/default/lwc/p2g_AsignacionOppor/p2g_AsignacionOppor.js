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

    @track sizecol2;
    @track sizecol3;
    @track sizecol4;
    @track sizecol5;
    @track sizecol6;
    @track sizecol7;
    @track sizecol8;

    @track totalCol2;
    @track totalCol3;
    @track totalCol4;
    @track totalCol5;
    @track totalCol6;
    @track totalCol7;

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
    @track semaforo = 'all';

    radioOptions = [
        { label: 'All shipments', value: 'all' },
        { label: 'Mis Shipments', value: 'mios' },
    ];

    @track showButton = true;
    @track zona = 'All';

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
        }, 60000); // 60 segundos
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
            this.refreshData();
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
    @track searchValueIdOpExecutiveA = 'No';

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

    //Ejecutivo SAC
    @track sideRecordsOpExecutiveSAC;
    @track searchValueOpExecutiveSAC = '';
    @track showSideOpExecutiveSAC = false;
    @track searchValueEmail = '';

    searchKeyOpExecutiveSAC(event) {
        this.searchValueOpExecutiveSAC = event.target.value;
    
        if (this.searchValueOpExecutiveSAC.length >= 3) {
            this.showSideOpExecutiveSAC = true;
            // Llama a tu método Apex para buscar ejecutivos de operaciones
            getOpeExe({ search: this.searchValueOpExecutiveSAC })
                .then(result => {
                    this.sideRecordsOpExecutiveSAC = result;
                })
                .catch(error => {
                    this.pushMessage('Error', 'error', 'utut');
                    this.sideRecordsOpExecutiveSAC = null;
                });
        } else {
            this.searchValueEmail = '';
            this.showSideOpExecutiveSAC = false;
        }
    }

    SideSelectOpExecutiveSAC(event) {
        this.searchValueOpExecutiveSAC = event.target.outerText;
        this.showSideOpExecutiveSAC = false;
        this.searchValueEmail = event.currentTarget.dataset.email;
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
        getColumns({datos: ['2', 'Pending', this.startDate, this.endDate,this.selectedRadio,this.searchValueIdAccount,this.searchValueIdCarrier,this.searchValueIdOpExecutive,this.tipoServicio,this.zona,this.searchValueEmail]})
        .then(result => {
            this.listShipmentsCol2 = result[0];
            this.listShipmentsCol3 = result[1];
            this.listShipmentsCol4 = result[2];
            this.listShipmentsCol5 = result[3];
            this.listShipmentsCol6 = result[4];
            this.listShipmentsCol7 = result[5];

            this.countGreenCircleElements();
        })
        .catch(error => {
            console.error('Error al llamar a updatecolumns:', error);
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

    handleTakeButtonAsignar(event) {
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
            let showSemaforo = true;
            const now = new Date();
            const dateString = account.ETD_from_Point_of_Load__c; // "2024-04-05"

            const equipPlacedDate = new Date(account.Equip_Placed__c); // Obtener la fecha de equipPlacedDate
    
            const etdHoursPT = equipPlacedDate.getHours();
            const etdMinutesPT = equipPlacedDate.getMinutes();
            const timeStringPT = etdHoursPT + ':' + (etdMinutesPT < 10 ? '0' + etdMinutesPT : etdMinutesPT);
            
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            // Convertir milisegundos en horas y minutos
            const etdHours = Math.floor((etdTimeMillis / (1000 * 60 * 60)) % 24);
            const etdMinutes = Math.floor((etdTimeMillis / (1000 * 60)) % 60);
            const timeString = etdHours + ':' + (etdMinutes < 10 ? '0' + etdMinutes : etdMinutes);
            
            const [year, monthIndex, day] = dateString.split('-');
    
            // Crear una nueva instancia de Date con la fecha y hora especificadas
            const etdDate = new Date(year, monthIndex - 1, day, etdHours, etdMinutes);
        
            let circleClass = '';
    
            // Comparar solo las fechas (sin tener en cuenta la hora)
            const etdDateWithoutTime = new Date(etdDate.getFullYear(), etdDate.getMonth(), etdDate.getDate());
            const nowWithoutTime = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            if (etdDateWithoutTime < nowWithoutTime) {
                circleClass = 'circle black'; // Evento pasado
            } else if (etdDateWithoutTime > nowWithoutTime) {
                circleClass = 'circle green'; // Evento futuro
            } else {
                // Evento hoy, comparar los minutos
                const etdTotalMinutes = etdHours * 60 + etdMinutes;
                const nowTotalMinutes = now.getHours() * 60 + now.getMinutes();
                const differenceInMinutes = etdTotalMinutes - nowTotalMinutes;
                if (differenceInMinutes > 360) {
                    circleClass = 'circle green'; // Más de 6 horas
                } else if (differenceInMinutes >= 240) {
                    circleClass = 'circle yellow'; // Entre 4 y 6 horas
                } else if (differenceInMinutes >= 0) {
                    circleClass = 'circle red'; // Menos de 4 horas
                } else {
                    circleClass = 'circle black'; // Evento pasado
                }
            }
            showSemaforo = this.filterSemaforo(circleClass);
            return {
                ...account,
                circleClass: circleClass,
                Account_Shipment_Reference__c: timeString,
                Monitoreo_Recepci_n_Acuse__c:showSemaforo,
                Reason_for_declined__c:timeStringPT,

            };
        });
    }

    semaforoChance(event) {
        const value = event.target.value;
        this.semaforo = value;
        this.countGreenCircleElements();
    }
    
    countGreenCircleElements() {
        // Obtener el tamaño de las listas col6 y col7
        this.sizecol6 = this.listShipmentsCol6.length;
        this.sizecol7 = this.listShipmentsCol7.length;
        this.totalCol6 = this.sumField(this.listShipmentsCol6, 'Total_Services_Sell_Amount__c');
        // Sumar el campo Total_Services_Sell_Amount__c para listShipmentsCol7
        this.totalCol7 = this.sumField(this.listShipmentsCol7, 'Total_Services_Sell_Amount__c');
        // Si semaforo es 'all', obtener el tamaño de las listas sin filtrar
        if (this.semaforo === 'all') {
            this.sizecol2 = this.colorCoded2.length;
            this.sizecol3 = this.colorCoded3.length;
            this.sizecol4 = this.colorCoded4.length;
            this.sizecol5 = this.colorCoded5.length;

            this.totalCol2 = this.sumField(this.listShipmentsCol2, 'Total_Services_Sell_Amount__c');
            this.totalCol3 = this.sumField(this.listShipmentsCol3, 'Total_Services_Sell_Amount__c');
            this.totalCol4 = this.sumField(this.listShipmentsCol4, 'Total_Services_Sell_Amount__c');
            this.totalCol5 = this.sumField(this.listShipmentsCol5, 'Total_Services_Sell_Amount__c');

        } else {
            // Filtrar y contar elementos según el semaforo para colorCoded2
            this.sizecol2 = this.getCountByCircleClass(this.colorCoded2, this.semaforo);
            // Filtrar y contar elementos según el semaforo para colorCoded3
            this.sizecol3 = this.getCountByCircleClass(this.colorCoded3, this.semaforo);
            // Filtrar y contar elementos según el semaforo para colorCoded4
            this.sizecol4 = this.getCountByCircleClass(this.colorCoded4, this.semaforo);
            // Filtrar y contar elementos según el semaforo para colorCoded5
            this.sizecol5 = this.getCountByCircleClass(this.colorCoded5, this.semaforo);
            // Sumar el campo Total_Services_Sell_Amount__c para colorCoded2 filtrado por semaforo
            this.totalCol2 = this.sumFieldByCircleClass(this.colorCoded2, 'Total_Services_Sell_Amount__c', this.semaforo);
            // Sumar el campo Total_Services_Sell_Amount__c para colorCoded3 filtrado por semaforo
            this.totalCol3 = this.sumFieldByCircleClass(this.colorCoded3, 'Total_Services_Sell_Amount__c', this.semaforo);
            // Sumar el campo Total_Services_Sell_Amount__c para colorCoded4 filtrado por semaforo
            this.totalCol4 = this.sumFieldByCircleClass(this.colorCoded4, 'Total_Services_Sell_Amount__c', this.semaforo);
            // Sumar el campo Total_Services_Sell_Amount__c para colorCoded5 filtrado por semaforo
            this.totalCol5 = this.sumFieldByCircleClass(this.colorCoded5, 'Total_Services_Sell_Amount__c', this.semaforo);
            }
    }
    
    // Función para contar elementos filtrados por circleClass
    getCountByCircleClass(list, circleClass) {
        return list.filter(item => item.circleClass === circleClass).length;
    }
    
    // Función para sumar el valor de un campo filtrado por circleClass
    sumFieldByCircleClass(list, fieldName, circleClass) {
        return list.reduce((total, item) => {
            if (item.circleClass === circleClass) {
                return total + (item[fieldName] || 0);
            }
            return total;
        }, 0);
    }
    sumField(list, fieldName) {
        return list.reduce((total, item) => {
            // Convertir el valor del campo a número (si es un string numérico) y sumarlo al total
            return total + (item[fieldName] || 0);
        }, 0);
    }
    

    filterSemaforo(semaforo) {
        if(this.semaforo === 'all'){
            return true;
        }
        else{
            if(this.semaforo === semaforo){
                return true;
            }
            else return false;
        }

    }

    get colorCoded3() {
        return this.listShipmentsCol3.map(account => {
            let showSemaforo = true;
            const now = new Date();
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            const dateString = account.ETD_from_Point_of_Load__c; // "2024-04-05"

            const equipPlacedDate = new Date(account.Equip_Placed__c); // Obtener la fecha de equipPlacedDate
    
            const etdHoursPT = equipPlacedDate.getHours();
            const etdMinutesPT = equipPlacedDate.getMinutes();
            const timeStringPT = etdHoursPT + ':' + (etdMinutesPT < 10 ? '0' + etdMinutesPT : etdMinutesPT);
            
            // Convertir milisegundos en horas y minutos
            const etdHours = Math.floor((etdTimeMillis / (1000 * 60 * 60)) % 24);
            const etdMinutes = Math.floor((etdTimeMillis / (1000 * 60)) % 60);
            const timeString = etdHours + ':' + (etdMinutes < 10 ? '0' + etdMinutes : etdMinutes);
            const [year, monthIndex, day] = dateString.split('-');
    
            // Crear una nueva instancia de Date con la fecha y hora especificadas
            const etdDate = new Date(year, monthIndex - 1, day, etdHours, etdMinutes);
            let circleClass = '';
    
            // Comparar solo las fechas (sin tener en cuenta la hora)
            const etdDateWithoutTime = new Date(etdDate.getFullYear(), etdDate.getMonth(), etdDate.getDate());
            const nowWithoutTime = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            if (etdDateWithoutTime < nowWithoutTime) {
                circleClass = 'circle black'; // Evento pasado
            } else if (etdDateWithoutTime > nowWithoutTime) {
                circleClass = 'circle green'; // Evento futuro
            } else {
                // Evento hoy, comparar los minutos
                const etdTotalMinutes = etdHours * 60 + etdMinutes;
                const nowTotalMinutes = now.getHours() * 60 + now.getMinutes();
                const differenceInMinutes = etdTotalMinutes - nowTotalMinutes;
    
                if (differenceInMinutes > 360) {
                    circleClass = 'circle green'; // Más de 6 horas
                } else if (differenceInMinutes >= 240) {
                    circleClass = 'circle yellow'; // Entre 4 y 6 horas
                } else if (differenceInMinutes >= 0) {
                    circleClass = 'circle red'; // Menos de 4 horas
                } else {
                    circleClass = 'circle black'; // Evento pasado
                }
            }
            showSemaforo = this.filterSemaforo(circleClass);
            return {
                ...account,
                circleClass: circleClass,
                Account_Shipment_Reference__c: timeString,
                Monitoreo_Recepci_n_Acuse__c:showSemaforo,
                Reason_for_declined__c:timeStringPT,
            };
        });
    }
    
    get colorCoded4() {
        return this.listShipmentsCol4.map(account => {
            let showSemaforo = true;
            const now = new Date();
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            const dateString = account.ETD_from_Point_of_Load__c; // "2024-04-05"

            const equipPlacedDate = new Date(account.Equip_Placed__c); // Obtener la fecha de equipPlacedDate
            const etdHoursPT = equipPlacedDate.getHours();
            const etdMinutesPT = equipPlacedDate.getMinutes();
            const timeStringPT = etdHoursPT + ':' + (etdMinutesPT < 10 ? '0' + etdMinutesPT : etdMinutesPT);
            
            // Convertir milisegundos en horas y minutos
            const etdHours = Math.floor((etdTimeMillis / (1000 * 60 * 60)) % 24);
            const etdMinutes = Math.floor((etdTimeMillis / (1000 * 60)) % 60);
            const timeString = etdHours + ':' + (etdMinutes < 10 ? '0' + etdMinutes : etdMinutes);
            const [year, monthIndex, day] = dateString.split('-');
    
            // Crear una nueva instancia de Date con la fecha y hora especificadas
            const etdDate = new Date(year, monthIndex - 1, day, etdHours, etdMinutes);

            let circleClass = '';
    
            // Comparar solo las fechas (sin tener en cuenta la hora)
            const etdDateWithoutTime = new Date(etdDate.getFullYear(), etdDate.getMonth(), etdDate.getDate());
            const nowWithoutTime = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            if (etdDateWithoutTime < nowWithoutTime) {
                circleClass = 'circle black'; // Evento pasado
            } else if (etdDateWithoutTime > nowWithoutTime) {
                circleClass = 'circle green'; // Evento futuro
            } else {
                // Evento hoy, comparar los minutos
                const etdTotalMinutes = etdHours * 60 + etdMinutes;
                const nowTotalMinutes = now.getHours() * 60 + now.getMinutes();
                const differenceInMinutes = etdTotalMinutes - nowTotalMinutes;

                if (differenceInMinutes > 360) {
                    circleClass = 'circle green'; // Más de 6 horas
                } else if (differenceInMinutes >= 240) {
                    circleClass = 'circle yellow'; // Entre 4 y 6 horas
                } else if (differenceInMinutes >= 0) {
                    circleClass = 'circle red'; // Menos de 4 horas
                } else {
                    circleClass = 'circle black'; // Evento pasado
                }
            }
            showSemaforo = this.filterSemaforo(circleClass);
            return {
                ...account,
                circleClass: circleClass,
                Account_Shipment_Reference__c: timeString,
                Monitoreo_Recepci_n_Acuse__c:showSemaforo,
                Reason_for_declined__c:timeStringPT,
            };
        });
    }

    get colorCoded5() {
        return this.listShipmentsCol5.map(account => {
            let showSemaforo = true;
            const now = new Date();
            const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
            const dateString = account.ETD_from_Point_of_Load__c; // "2024-04-05"

            const equipPlacedDate = new Date(account.Equip_Placed__c); // Obtener la fecha de equipPlacedDate
            const etdHoursPT = equipPlacedDate.getHours();
            const etdMinutesPT = equipPlacedDate.getMinutes();
            const timeStringPT = etdHoursPT + ':' + (etdMinutesPT < 10 ? '0' + etdMinutesPT : etdMinutesPT);
            
            // Convertir milisegundos en horas y minutos
            const etdHours = Math.floor((etdTimeMillis / (1000 * 60 * 60)) % 24);
            const etdMinutes = Math.floor((etdTimeMillis / (1000 * 60)) % 60);
            const timeString = etdHours + ':' + (etdMinutes < 10 ? '0' + etdMinutes : etdMinutes);
            const [year, monthIndex, day] = dateString.split('-');
    
            // Crear una nueva instancia de Date con la fecha y hora especificadas
            const etdDate = new Date(year, monthIndex - 1, day, etdHours, etdMinutes);

            let circleClass = '';
    
            // Comparar solo las fechas (sin tener en cuenta la hora)
            const etdDateWithoutTime = new Date(etdDate.getFullYear(), etdDate.getMonth(), etdDate.getDate());
            const nowWithoutTime = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            if (etdDateWithoutTime < nowWithoutTime) {
                circleClass = 'circle black'; // Evento pasado
            } else if (etdDateWithoutTime > nowWithoutTime) {
                circleClass = 'circle green'; // Evento futuro
            } else {
                // Evento hoy, comparar los minutos
                const etdTotalMinutes = etdHours * 60 + etdMinutes;
                const nowTotalMinutes = now.getHours() * 60 + now.getMinutes();
                const differenceInMinutes = etdTotalMinutes - nowTotalMinutes;

                if (differenceInMinutes > 360) {
                    circleClass = 'circle green'; // Más de 6 horas
                } else if (differenceInMinutes >= 240) {
                    circleClass = 'circle yellow'; // Entre 4 y 6 horas
                } else if (differenceInMinutes >= 0) {
                    circleClass = 'circle red'; // Menos de 4 horas
                } else {
                    circleClass = 'circle black'; // Evento pasado
                }
            }
            showSemaforo = this.filterSemaforo(circleClass);
            return {
                ...account,
                circleClass: circleClass,
                Account_Shipment_Reference__c: timeString,
                Monitoreo_Recepci_n_Acuse__c:showSemaforo,
                Reason_for_declined__c:timeStringPT,
            };
        });
    }
    
///-------------------------secicon 3----------


handleStatusAndFechaChange(event){
    const value = event.target.value;
    this.status = value;
    this.updateColumns();
    this.refreshData();
}

handlezona(event){
    const value = event.target.value;
    this.zona = value;
    this.updateColumns();
    this.refreshData();
}

handleTipoServicio(event){
    const value = event.target.value;
    this.tipoServicio = value;
    this.updateColumns();
    this.refreshData();
}

refreshData() {
    seccion3({datos:[this.status,this.startDate,this.endDate,this.selectedRadio,this.searchValueIdAccount,this.searchValueIdCarrier,this.searchValueIdOpExecutive,this.tipoServicio,this.zona,this.searchValueEmail]})
        .then(result => {
            if (result && result.length > 0) {
                // Recorrer cada elemento de result
                result.forEach(account => {
                    const etdTimeMillis = account.ETD_Time_from_Point_of_Load__c;
                    // Convertir milisegundos en horas y minutos
                    const etdHours = Math.floor((etdTimeMillis / (1000 * 60 * 60)) % 24);
                    const etdMinutes = Math.floor((etdTimeMillis / (1000 * 60)) % 60);
                    const timeString = etdHours + ':' + (etdMinutes < 10 ? '0' + etdMinutes : etdMinutes);
                    account.Account_Shipment_Reference__c = timeString;
                });

                // Asignar el resultado modificado a seccion3Data
            }
            this.seccion3Data = result;
        })
        .catch(error => {
            console.error('Error al llamar a refreshData:', error);
        });
}

}