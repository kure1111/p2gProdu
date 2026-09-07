import { LightningElement, track } from 'lwc';
import procesarCSV from '@salesforce/apex/P2G_FileUploaderController.procesarCSV';

export default class P2G_FileUpload extends LightningElement {
    @track selectVal = '';
    productOptions = [
        { label: 'Seleccione que tipo de operación deseas realizar:', value: '' },
        { label: 'Carga de tarifarios clientes', value: 'clientes' }
        //{ label: 'Carga de tarifarios proveedores', value: 'proveedores' }
    ];

    @track fileContent;
    @track fileName = '';
    @track fileValid = false;
    @track message = '';
    @track messageType = 'info';
    clearMessageTimer = null;

    get plantillaUrl() {
        if (this.selectVal === 'proveedores') {
            return 'https://pak2gopgl.sharepoint.com/:x:/s/Desarrollos/IQDIN0LFUvoMS5V8i4AzNKSuAWSwXqqqJjMbgYEJ5fx-sV0?e=rkQTGT&download=1';
        } else if (this.selectVal === 'clientes') {
            return 'https://pak2gopgl.sharepoint.com/:x:/s/Desarrollos/IQDLRZdPbQjJTJ9tR_bWUY7hAU5EPewjisavqmlqALjszqs?e=u7AvYK&download=1';
        }
        return '#';
    }

    get isDownloadDisabled() {
        return !this.selectVal || this.selectVal === '';
    }

    get isButtonDisabled() {
        return !this.fileValid || !this.selectVal || this.selectVal === '';
    }

    get messageClass() {
        let base = 'slds-notify slds-notify_toast slds-m-bottom_small';
        if (this.messageType === 'success') {
            return base + ' slds-theme_success';
        } else if (this.messageType === 'error') {
            return base + ' slds-theme_error';
        } else {
            return base + ' slds-theme_info';
        }
    }

    handleChange(event) {
        this.selectVal = event.detail.value;
        this.resetFileState();
        this.message = '';
        this.clearAutoDismissTimer();
    }

    descargarPlantilla() {
        if (!this.selectVal || this.selectVal === '') {
            this.showMessage('Por favor, selecciona un tipo de operación antes de descargar la plantilla.', 'error');
            return;
        }

        const url = this.plantillaUrl;
        if (url === '#') {
            this.showMessage('No se ha seleccionado una operación válida.', 'error');
            return;
        }

        window.location.href = url;
        
        this.showMessage('Se ha descargado la plantilla. En caso de no poder modificar el archivo favor de guardarlo como una copia', 'info');
    }

    handleFileChange(event) {
        const file = event.target.files[0];
        if (!file) {
            this.resetFileState();
            return;
        }

        if (!file.name.toLowerCase().endsWith('.csv')) {
            this.showMessage('Solo se permiten archivos CSV.', 'error');
            this.resetFileState();
            return;
        }

        const reader = new FileReader();
        reader.onload = (e) => {
            try {
                const content = e.target.result;
                if (!content || content.trim().length === 0) {
                    this.showMessage('El archivo está vacío.', 'error');
                    this.resetFileState();
                    return;
                }

                const lines = content.split(/\r?\n/);
                if (lines.length === 0) {
                    this.showMessage('El archivo no tiene contenido válido.', 'error');
                    this.resetFileState();
                    return;
                }

                const header = lines[0].split(',').map(h => h.trim());
                let requiredColumns;
                if (this.selectVal === 'proveedores') {
                    requiredColumns = [
                        'Nombre del Proveedor',
                        'Customer ID',
                        'Ruta',
                        'Sap service Type Sell',
                        'Sap service Type Buy',
                        'Sell Rate',
                        'Valid From dd/mm/yyyy',
                        'Valid Until dd/mm/yyyy',
                        'Container Type'
                    ];
                } else if (this.selectVal === 'clientes') {
                    requiredColumns = [
                        'Nombre del Cliente',
                        'Customer ID',
                        'Ruta',
                        'Sap service Type Sell',
                        'Sap service Type Buy',
                        'Sell Rate',
                        'Valid From dd/mm/yyyy',
                        'Valid Until dd/mm/yyyy',
                        'Container Type'
                    ];
                } else {
                    this.showMessage('Por favor, selecciona un tipo de operación antes de cargar un archivo.', 'error');
                    this.resetFileState();
                    return;
                }

                const missingColumns = requiredColumns.filter(col => !header.includes(col));
                if (missingColumns.length > 0) {
                    this.showMessage(
                        `El archivo no contiene las columnas requeridas: ${missingColumns.join(', ')}`,
                        'error'
                    );
                    this.resetFileState();
                    return;
                }

                this.fileContent = content;
                this.fileName = file.name;
                this.fileValid = true;
                this.showMessage(`Archivo "${file.name}" cargado correctamente.`, 'info');

            } catch (error) {
                this.showMessage('Error al leer el archivo: ' + error.message, 'error');
                this.resetFileState();
            }
        };
        reader.onerror = () => {
            this.showMessage('Error al leer el archivo.', 'error');
            this.resetFileState();
        };
        reader.readAsText(file, 'UTF-8');
    }

    handleSubirTarifarios() {
        if (!this.selectVal || this.selectVal === '') {
            this.showMessage('Por favor, selecciona un tipo de operación.', 'error');
            return;
        }

        if (!this.fileValid || !this.fileContent) {
            this.showMessage('No hay un archivo válido para procesar.', 'error');
            return;
        }

        this.showMessage('Procesando archivo...', 'info');

        procesarCSV({
            csvContent: this.fileContent,
            operacion: this.selectVal
        })
            .then(result => {
                this.showMessage(result, 'success');
                const input = this.template.querySelector('input[type="file"]');
                if (input) input.value = '';
                this.fileValid = false;
                this.fileName = '';
                this.fileContent = null;
            })
            .catch(error => {
                let errorMsg = 'Error al procesar el archivo.';
                if (error.body && error.body.message) {
                    errorMsg = error.body.message;
                } else if (typeof error === 'string') {
                    errorMsg = error;
                } else if (error.message) {
                    errorMsg = error.message;
                }
                this.showMessage(errorMsg, 'error');
            });
    }

    resetFileState() {
        this.fileValid = false;
        this.fileName = '';
        this.fileContent = null;
        this.clearAutoDismissTimer();
    }

    clearAutoDismissTimer() {
        if (this.clearMessageTimer) {
            clearTimeout(this.clearMessageTimer);
            this.clearMessageTimer = null;
        }
    }

    showMessage(msg, type) {
        this.clearAutoDismissTimer();
        this.message = msg;
        this.messageType = type;

    
        this.clearMessageTimer = setTimeout(() => {
            this.message = '';
            this.messageType = 'info';
            this.clearMessageTimer = null;
        }, 5000);
    }
}