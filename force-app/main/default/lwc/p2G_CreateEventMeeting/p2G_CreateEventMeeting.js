import { LightningElement, api, track, wire } from 'lwc';
import getRecordName from '@salesforce/apex/P2G_EventMeeting.getRecordName';
import createEvent from '@salesforce/apex/P2G_EventMeeting.createEvent';
import getOpportunitiesForAccount from '@salesforce/apex/P2G_EventMeeting.getOpportunitiesForAccount';
import { getRecord } from 'lightning/uiRecordApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import SERVICIO_FIELD from '@salesforce/schema/Event.Servicio__c';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { refreshApex } from '@salesforce/apex';
import { CurrentPageReference } from 'lightning/navigation';



export default class EventCreator extends LightningElement {
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
@track servicio = [];
@track servicioOptions = [];
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
    this.loadRecordName();
    console.log('this.showInicio desde connectCallback ' + this.showInicio);
    
    if (!this.showInicio) {
        console.log('Se mostraran las oportinidades');
        
        this.loadOpportunities();
    }
    
    if (this.pageRef && this.pageRef.type === 'standard__quickAction') {
        this.isQuickAction = true;
    }
}

// opciones de Event.Servicio__c desde la picklist real (sin hardcodear valores)
@wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: SERVICIO_FIELD })
loadServicioOptions({ error, data }) {
    if (data) {
        this.servicioOptions = data.values.map(v => ({ label: v.label, value: v.value }));
    } else if (error) {
        console.error('Error fetching Servicio picklist: ', error);
    }
}

handleServicioChange(event) {
    this.servicio = event.detail.value;
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
    getRecordName({ recordId: this.recordId })
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
                        this.showButtons = false;
                        this.showButtonsExistentClients = false;
                    if (this.recordTypeName === 'Prospect' || this.recordTypeName === 'Prospect Mkt') {
                        this.showButtons = true;
                        this.showButtonsExistentClients = false;
                        console.log('RecordType es Prospect');
                    } else {
                        this.showButtons = false;
                        this.showButtonsExistentClients = true;
                        console.log('RecordType es diferente');
                    }
                } else if (this.recordId.startsWith('006')) {
                    console.log('Oportunidades::::');
                    this.showButtonsExistentClients = false;
                    this.showButtons = true;
                }
                
            }
            
           // this.loadOpportunities();
        })
        .catch(error => {
            console.error('Error fetching record details: ', error);
            if (!this.isQuickAction) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error al obtener los detalles del registro.',
                        variant: 'error'
                    })
                );
            }
        });
}


loadOpportunities() {
    console.log('RecordId desde Table Opp---> ' + this.recordId);
    console.log('RecordTypeName---> ' + this.recordTypeName);
    console.log('Reason---> ' + this.reason); 

    if(this.recordId.startsWith('001') && (this.reason == 'Seguimiento' || this.reason == 'Ejecución' || this.reason == 'Desarrollo Comercial'
        || this.reason == 'Desempeño de Servicio' || this.reason == 'Revisión de Negocio' || this.reason == 'Gestión Administrativa'
    )) {
        this.showOpps = true;
    } else {
        this.showOpps = false
    }

    if (!this.reason) {
        console.error('El Motivo no está definido. Asigna un valor antes de continuar.');
        return;  
    }

    getOpportunitiesForAccount({ 
        accountId: this.recordId, 
        recordTypeName: this.recordTypeName, 
        reason: this.reason 
    })
    .then(result => {
        console.log('info get oportunity::::: ' + this.recordId + ' ' + this.recordTypeName + ' ' + this.reason);
        
        this.opportunities = result;
    })
    .catch(error => {
        console.error('Error fetching opportunities: ', error);
    });
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
    if (this.subject == 'Meeting') {
        this.reason = 'Prospección';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
    this.showButtons = false;
    this.showButtonsExistentClients = false;
}

handleSeguimientoClick() {
    if (this.subject == 'Meeting') {
        this.reason = 'Seguimiento';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
    this.showButtons = false;
    this.showButtonsExistentClients = false;
}

handleEjecucionClick() {
    if (this.subject == 'Meeting') {
        this.reason = 'Ejecución';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
    this.showButtons = false;
    this.showButtonsExistentClients = false;
}

handleDesarolloComercialClick() {
    if (this.subject == 'Meeting') {
        this.reason = 'Desarrollo Comercial';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
    this.showButtons = false;
    this.showButtonsExistentClients = false;
}

handleDesempeñoServicioClick() {
    if (this.subject == 'Meeting') {
        this.reason = 'Desempeño de Servicio';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
    this.showButtons = false;
    this.showButtonsExistentClients = false;
}

handleRevisiónNegocioClick() {
    if (this.subject == 'Meeting') {
        this.reason = 'Revisión de Negocio';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
    this.showButtons = false;
    this.showButtonsExistentClients = false;
}

handleGestionAdministrativaClick() {
    if (this.subject == 'Meeting') {
        this.reason = 'Gestión Administrativa';
    } else {
        this.reason = '';
    }
    this.showFormCreateEvent = true;
    this.loadOpportunities();
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
    this.loadRecordName();
}

handleNext() {
    if (!this.subject) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'El campo "Tipo Evento" es requerido.',
                variant: 'error'
            })
        );
        return; // Detener el flujo si no hay valor
    }
    this.showInicio = false;
    console.log('showInicio actualizado a:', this.showInicio);
    console.log('this.recordTypeName:::::> ' + this.recordTypeName);
    this.loadRecordName();
   
    
    
}


handleOpportunitySelect(event) {
    const selectedRows = event.detail.selectedRows;
    this.selectedOpportunityId = selectedRows.length > 0 ? selectedRows[0].Id : '';
    console.log('Oportunidad seleccionada: ' + this.selectedOpportunityId);
}

handleSubmit() {
    /*if (this.recordId.startsWith('001') && !this.selectedOpportunityId) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Por favor selecciona una oportunidad.',
                variant: 'error'
            })
        );
        return;
    }*/

    if (!this.servicio || this.servicio.length === 0) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'El campo "Servicio" es requerido.',
                variant: 'error'
            })
        );
        return;
    }

    let eventDetails = {
        subject: this.subject,
        motivoMinuta: this.reason,
        tipoMeeting: this.meetingType,
        ownerId: USER_ID,
        tipoVisita: this.frequency,
        servicio: this.servicio.join(';'),
        startDateTime: this.startDateTime,
        endDateTime: this.endDateTime
    };
    console.log('Id de la Opp en Handle::: ' + this.selectedOpportunityId);
    
    if (this.recordId.startsWith('001')) {
        if (!this.selectedOpportunityId) {
            eventDetails.whatId = this.recordId;
        } else {
            eventDetails.whatId = this.selectedOpportunityId;
        }
        
    } else {
        eventDetails.whatId = this.recordId;
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
            } 
                setTimeout(() => {
                    window.location.reload();
                }, 2000);
                          
        });
    
}
clearFields() {
    this.subject = '';
    this.meetingType = '';
    this.reason = '';
    this.servicio = [];
    this.frequency = '';
    this.startDateTime = '';
    this.endDateTime = '';
    this.showMeetingType = false;
}
}