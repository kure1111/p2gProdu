import { LightningElement, api, track } from 'lwc';
import getUpcomingEvents from '@salesforce/apex/P2G_ShowEvents.getUpcomingEvents';
import FullCalendarJS from '@salesforce/resourceUrl/fullCalendar';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import P2G_CreateEventCalendar from 'c/p2G_CreateEventCalendar';

export default class Calender extends LightningElement {
    jsInitialised = false;
    @track _events = [];
    @track calendarInitialized = false;
    @track showLWC = false;
    @api recordId;

    // Método para obtener los eventos del servidor
    connectedCallback() {
        getUpcomingEvents()
            .then(result => {
                console.log('Eventos cargados:', result);
                this._events = result.map(event => ({
                    id: event.id,
                    title: event.title,
                    propietario: event.propietario,
                    start: this.convertToISOFormat(event.start),
                    end: this.convertToISOFormat(event.end)
                }));
                if (this.jsInitialised) {
                    this.initialiseCalendarJs();
                }
            })
            .catch(error => {
                console.error('Error cargando eventos:', error);
                this.showNotification('Error', error.body.message, 'error');
            });
    }

    // Convierte fechas al formato ISO-8601
    convertToISOFormat(dateString) {
        return new Date(dateString).toISOString();
    }

    renderedCallback() {
        if (this.jsInitialised) {
            return;
        }
        this.jsInitialised = true;

        Promise.all([
            loadScript(this, FullCalendarJS + '/FullCalenderV3/jquery.min.js'),
            loadScript(this, FullCalendarJS + '/FullCalenderV3/moment.min.js'),
            loadScript(this, FullCalendarJS + '/FullCalenderV3/fullcalendar.min.js'),
            loadStyle(this, FullCalendarJS + '/FullCalenderV3/fullcalendar.min.css')
        ])
        .then(() => {
            if (this._events.length > 0) {
                this.initialiseCalendarJs();
            }
        })
        .catch(error => {
            console.error('Error loading scripts:', error);
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    initialiseCalendarJs() {
        if (this.calendarInitialized) {
            return;
        }
        this.calendarInitialized = true;

        const ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            defaultDate: new Date(),
            navLinks: true,
            editable: true,
            eventLimit: true,
            events: this._events,
            dragScroll: true,
            droppable: true,
            weekNumbers: true,
            selectable: true,
            eventClick: (info) => {
                const event = this._events.find(e => e.id === info.id);
                if (event) {
                    const message = `Evento: ${event.title}\nPropietario: ${event.propietario}`;
                    alert(message);  // Muestra un alert con el detalle del evento
                }
                const selectedEvent = new CustomEvent('eventclicked', { detail: info.id });
                this.dispatchEvent(selectedEvent);
            }
        });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    handleShowLWC() {
        this.showLWC = true;
    }
}