import { LightningElement, wire, track, api } from 'lwc';
import getUnlockedLines from '@salesforce/apex/P2G_newInvoiceLine.getUnlockedLines';
import processSelectedLines from '@salesforce/apex/P2G_newInvoiceLine.processSelectedLines';

export default class VstaInvoce extends LightningElement {
    @api recordId;
    
    @track lines = [];
    @track isLoading = true;
    @track message = '';
    @track messageVariant = 'success';
    
    dataLoaded = false;
    selectedCount = 0;

    // Wire service para cargar los datos
    @wire(getUnlockedLines)
    wiredLines({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.lines = data.map(line => ({
                ...line,
                selected: false
            }));
            this.dataLoaded = true;
        } else if (error) {
            console.error('Error loading lines:', error);
            this.showMessage('Error cargando las líneas: ' + error.body.message, 'error');
        }
    }

    // Manejar cambio de checkbox individual
    handleCheckboxChange(event) {
        const lineId = event.target.dataset.id;
        const isChecked = event.target.checked;
        
        this.lines = this.lines.map(line => {
            if (line.Id === lineId) {
                return { ...line, selected: isChecked };
            }
            return line;
        });
        
        this.updateSelectedCount();
    }

    // Manejar seleccionar todos
    handleSelectAll(event) {
        const isChecked = event.target.checked;
        
        this.lines = this.lines.map(line => ({
            ...line,
            selected: isChecked
        }));
        
        this.updateSelectedCount();
    }

    // Actualizar contador de seleccionados
    updateSelectedCount() {
        this.selectedCount = this.lines.filter(line => line.selected).length;
    }

    // Botón Crear
    async handleCreate() {
        const selectedLines = this.lines.filter(line => line.selected);
        
        if (selectedLines.length === 0) {
            this.showMessage('Por favor selecciona al menos una línea', 'warning');
            return;
        }

        this.isLoading = true;
        
        try {
            const selectedIds = selectedLines.map(line => line.Id);
            const result = await processSelectedLines({ 
                selectedIds: selectedIds 
            });
            
            this.showMessage(result, 'success');
            
            // Refrescar los datos
            await this.refreshData();
            
        } catch (error) {
            console.error('Error:', error);
            this.showMessage('Error al procesar: ' + error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // Refrescar datos después de crear
    async refreshData() {
        try {
            this.isLoading = true;
            const freshData = await getUnlockedLines();
            this.lines = freshData.map(line => ({
                ...line,
                selected: false
            }));
            this.selectedCount = 0;
            this.dataLoaded = true;
        } catch (error) {
            console.error('Error refreshing data:', error);
            this.showMessage('Error al refrescar datos: ' + error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // Mostrar mensajes
    showMessage(message, variant) {
        this.message = message;
        this.messageVariant = variant;
        
        // Auto-ocultar mensaje después de 5 segundos
        setTimeout(() => {
            this.message = '';
        }, 5000);
    }

    // Getter para deshabilitar botón Crear
    get isCreateDisabled() {
        return this.selectedCount === 0 || this.isLoading;
    }
}