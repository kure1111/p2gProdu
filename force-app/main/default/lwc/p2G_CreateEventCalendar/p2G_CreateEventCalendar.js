import { LightningElement, api, track, wire } from 'lwc';
import getRecordName from '@salesforce/apex/P2G_EventMeeting.getRecordName';
import createEvent from '@salesforce/apex/P2G_EventMeeting.createEvent';
import getOpportunitiesForAccount from '@salesforce/apex/P2G_EventMeeting.getOpportunitiesForAccount';
import searchAccounts from '@salesforce/apex/P2G_EventMeeting.searchAccounts';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
 
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { refreshApex } from '@salesforce/apex';
import { CurrentPageReference } from 'lightning/navigation';
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Customer ID', fieldName: 'Customer_Id__c' },
    { label: 'Service Type', fieldName: 'Tipo_de_Servicio_TNA__r.Name' }
];
export default class P2G_CreateEventCalendar extends LightningElement {
    @track searchKey = '';
    @track accounts;
    @track error;
    columns = columns;

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.searchAccounts();
    }

    searchAccounts() {
        getAccount({ account: this.searchKey })
            .then(result => {
                this.accounts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.accounts = undefined;
                this.error = error.body.message;
            });
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            const selectedAccount = selectedRows[0];
            console.log('Selected Account Object:', selectedAccount); 
            console.log('Selected Account ID:', selectedAccount.Id);  
            console.log('Selected Account Name:', selectedAccount.Name);  
    
            // Asigna el ID de la cuenta seleccionada a selectedAccountId
            this.selectedAccountId = selectedAccount.Id;
            
            // Llama a loadOpportunities con el ID de la cuenta seleccionada
            this.loadOpportunities(this.selectedAccountId);
            this.loadRecordName();
        }
    }
    
    

    isQuickAction = false;
    isRecordPage = false;

    @wire(CurrentPageReference)
    pageRef;

    @api recordId;
    @track recordName = ''; 
    @track userName = '';
    @track subject = '';
    @track meetingType = '';
    @track reason = '';
    @track frequency = '';
    @track startDateTime = '';
    @track endDateTime = '';
    @track showMeetingType = false;
    @track isLoading = false; 
    @track showButtons = false;
    @track showInicio = true;
    @track showFormCreateEvent = false;
    @track showButtonsExistentClients = false;
    @track showOpps = false;
    @track opportunities = [];
    @track selectedOpportunityId = '';
    @track opportunityColumns = [
        { label: 'Nombre', fieldName: 'Name' },
        { label: 'Fecha de Cierre', fieldName: 'CloseDate' },
        { label: 'Etapa', fieldName: 'StageName' }
    ];
    

    subjectOptions = [
        { label: 'Email', value: 'Email' },
        { label: 'Call', value: 'Call' },
        { label: 'Meeting', value: 'Meeting' }
    ];

    meetingTypeOptions = [
        { label: 'Presencial', value: 'Presencial' },
        { label: 'Videoconferencia', value: 'Videoconferencia' }
    ];

    frequencyOptions = [
        { label: 'Primera vista', value: 'Primera vista' },
        { label: 'Segunda vista', value: 'Segunda vista' },
        { label: 'Re vista', value: 'Re vista' }
    ];
    

    connectedCallback() {
        // this.loadRecordName();
        if (!this.showInicio) {
            this.loadOpportunities();
        }
        
        if (this.pageRef && this.pageRef.type === 'standard__quickAction') {
            this.isQuickAction = true;
        }
    }

    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
    loadUserName({ error, data }) {
        if (data) {
            this.userName = data.fields.Name.value;
        } else if (error) {
            console.error('Error fetching user name: ', error);
        }
    }

    loadRecordName() {
        getRecordName({ recordId: this.selectedAccountId })
            .then(result => {
                this.recordName = result.Name;
                this.recordTypeName = result.RecordTypeName;
                console.log('recordTypeName desde LoadRecordName---> ' + this.recordTypeName);
                console.log('this.showInicio::: ' + this.showInicio);
                
                if (!this.showInicio) {
                    console.log('this.showInicio Dentro del IF::: ' + this.showInicio);
                    console.log('En donde ando?  ' + this.recordId);
                    
                    if (this.recordId.startsWith('001')) {
                        console.log('Cuentas::::');
                        
                        if (this.recordTypeName === 'Prospect' || this.recordTypeName === 'Prospect Mkt') {
                            this.showButtons = true;
                            console.log('RecordType es Prospect');
                        } else {
                            this.showButtonsExistentClients = true;
                            console.log('RecordType es diferente');
                        }
                    } else if (this.recordId.startsWith('006')) {
                        console.log('Oportunidades::::');
                        this.showButtonsExistentClients = false;
                        this.showButtons = true;
                    }
                    
                }
                

                this.loadOpportunities();
            })
            .catch(error => {
                console.error('Error fetching record details: ', error);
            });
    }
    

    loadOpportunities(selectedAccountId) {
        console.log('RecordId desde Table Opp---> ' + selectedAccountId);
        console.log('RecordTypeName---> ' + this.recordTypeName);
        console.log('Reason---> ' + this.reason); 

        if(this.reason == 'Seguimiento' || this.reason == 'Ejecución' || this.reason == 'Desarrollo Comercial'
            || this.reason == 'Desempeño de Servicio' || this.reason == 'Revisión de Negocio' || this.reason == 'Gestión Administrativa') {
            this.showOpps = true;
        } else {
            this.showOpps = false;
        }
    
    
        if (!selectedAccountId) {
            console.error('selectedAccountId no está definido. No se pueden cargar oportunidades.');
            return;  
        }
    
        if (!this.reason) {
            console.error('Reason no está definido. Asigna un valor antes de continuar.');
            return;  
        }
    
        getOpportunitiesForAccount({ 
            accountId: selectedAccountId, 
            recordTypeName: this.recordTypeName, 
            reason: this.reason 
        })
        .then(result => {
            this.opportunities = result;
            console.log('Opportunidades::: ' + this.opportunities);
            
        })
        .catch(error => {
            console.error('Error fetching opportunities: ', error);
        });
    }
    

    handleAccountSearch(event) {
        const searchTerm = event.target.value;
        if (searchTerm.length >= 3) {
            searchAccounts({ searchKey: searchTerm })
                .then(result => {
                    this.selectedAccountId = result[0].Id;
                    this.selectedAccountName = result[0].Name;
                })
                .catch(error => {
                    console.error('Error fetching account: ', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Error buscando la cuenta.',
                            variant: 'error'
                        })
                    );
                });
        }
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
        this.showMeetingType = (this.subject === 'Meeting');
    }

    handleMeetingTypeChange(event) {
        this.meetingType = event.target.value;
    }

    handleFrequencyChange(event) {
        this.frequency = event.target.value;
    }

    handleStartDateChange(event) {
        this.startDateTime = event.target.value;
    }

    handleEndDateChange(event) {
        this.endDateTime = event.target.value;
    }

    handleProspeccionClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Prospección';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }
    
    handleSeguimientoClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Seguimiento';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }

    handleEjecucionClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Ejecución';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }

    handleDesarolloComercialClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Desarrollo Comercial';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }

    handleDesempeñoServicioClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Desempeño de Servicio';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }

    handleRevisiónNegocioClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Revisión de Negocio';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }

    handleGestionAdministrativaClick() {
        if (this.subject === 'Meeting') {
            this.reason = 'Gestión Administrativa';
        } else {
            this.reason = '';
        }
        this.showFormCreateEvent = true;
        this.loadOpportunities(this.selectedAccountId);
        this.showButtons = false;
        this.showButtonsExistentClients = false;
    }

    handleReturn() {
        this.showFormCreateEvent = false;
        if (this.recordTypeName === 'Prospect' || this.recordTypeName === 'Prospect Mkt') {
            this.showButtons = true;
            this.showButtonsExistentClients = false;
        } else {
            this.showButtons = false;
            this.showButtonsExistentClients = true;
        }
        // this.loadRecordName();
    }

    handleNext() {
        if (!this.selectedAccountId) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'La "Cuenta" es requerida.',
                    variant: 'error'
                })
            );
            return;
        }
        
        
        this.showInicio = false;
        console.log('showInicio actualizado a:', this.showInicio);
    
        if (this.recordTypeName === 'Prospect' || this.recordTypeName === 'Prospect Mkt') {
            this.showButtons = true;
            this.showButtonsExistentClients = false;
        } else {
            this.showButtons = false;
            this.showButtonsExistentClients = true;
        }
        this.loadRecordName();
    }
    

    handleOpportunitySelect(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedOpportunityId = selectedRows.length > 0 ? selectedRows[0].Id : '';
        console.log('Oportunidad seleccionada: ' + this.selectedOpportunityId);
    }

    handleSubmit() {
    
        let eventDetails = {
            subject: this.subject,
            motivoMinuta: this.reason,
            tipoMeeting: this.meetingType,
            ownerId: USER_ID,
            tipoVisita: this.frequency,
            startDateTime: this.startDateTime,
            endDateTime: this.endDateTime,
            whatId: this.selectedAccountId
        };
        
        if (!this.selectedOpportunityId) {
            eventDetails.whatId = this.selectedAccountId;
        } else {
            eventDetails.whatId = this.selectedOpportunityId;
        }
            console.log('eventDetails:::::: ',eventDetails);
            
    
            createEvent(eventDetails)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Éxito',
                        message: 'El evento ha sido creado exitosamente.',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error al crear el evento: ' + error.body.message,
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false; 
                this.clearFields(); 
                refreshApex(this.recordId);
                if (this.isQuickAction) {
                    this.dispatchEvent(new CloseActionScreenEvent());
                } else {
                    setTimeout(() => {
                        window.location.reload();
                    }, 2000);
                }              
            });
        
    }
    clearFields() {
        this.subject = '';
        this.meetingType = '';
        this.reason = '';
        this.frequency = '';
        this.startDateTime = '';
        this.endDateTime = '';
        this.showMeetingType = false;
    }
}