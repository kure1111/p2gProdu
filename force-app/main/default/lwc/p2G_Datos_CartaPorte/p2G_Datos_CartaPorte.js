import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';

import getAccountByShipment from '@salesforce/apex/P2G_Validacion_Datos_CartaPorte.getAccountByShipment';
import updateShipmentData from '@salesforce/apex/P2G_Validacion_Datos_CartaPorte.updateShipmentData';
import getDatosCartaPorte from '@salesforce/apex/P2G_Validacion_Datos_CartaPorte.getDatosCartaPorte';

export default class P2G_Datos_CartaPorte extends LightningElement {
    @track rfcValue = '';
    @track destinatarioValue = '';
    @track isGeneratingPDF = false;
    @track isContinueDisabled = true;
    @track isLoading = true;
    @track showContent = false;
    @track isAccountEnabled = false;

    get isButtonDisabled() {
        
        return this.isContinueDisabled || this.isLoading;
    }

    get buttonLabel() {
        return this.isLoading ? 'Procesando...' : 'Continuar';
    }

    _recordId;

    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
        if (value) {
            this.checkAccount();
        } else {
            getRecordNotifyChange([{ recordId: this.recordId }]);
        }
    }

    // RFCs genericos comunes
    genericRFCs = [
        'XAXX010101000',
        'XEXX010101000',
        'XEXE010101000',
        'XXX010101XXX',
        'XXX010101XXA',
        'XXX010101XX9'
    ];

    checkAccount() {
        if (!this.recordId) {
            this.showToast('Error', 'No se encontró el ID del envío', 'error');
            return;
        }

        this.isLoading = true;
        this.showContent = true;

        getAccountByShipment({ shipmentId: this.recordId })
            .then(result => {
                this.isAccountEnabled = result; // true si está habilitada, false si no

                if (this.isAccountEnabled) {
                    this.checkDatosCartaPorte();
                } else {
                    this.isLoading = false;
                }
                this.validateFields();
            })
            .catch(error => {
                console.error('Error en validación:', error);
                this.showToast('Error', error.body?.message || error.message, 'error');
                this.isLoading = false;
                this.isContinueDisabled = true;
                this.isAccountEnabled = false;
            });
    }



    // Método validateRFC actualizado
    validateRFC(rfc) {
        if (!rfc) return { isValid: false, message: 'El RFC es requerido' };

        rfc = rfc.trim().toUpperCase();

        // Validar longitud
        if (rfc.length !== 12 && rfc.length !== 13) {
            return { isValid: false, message: 'El RFC debe tener 12 caracteres (moral) o 13 (física)' };
        }

        // Validar RFC genérico (sin mostrar toast aquí)
        if (this.isGenericRFC(rfc)) {
            return { isValid: false, message: 'No se permiten RFCs genéricos' };
        }

        // Patrones corregidos
        const moralPattern = /^[A-ZÑ&]{3}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z0-9]{3})$/;
        const fisicaPattern = /^[A-ZÑ&]{4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z0-9]{3})$/;

        if (rfc.length === 12 && !moralPattern.test(rfc)) {
            return { isValid: false, message: 'RFC de persona moral inválido' };
        }

        if (rfc.length === 13 && !fisicaPattern.test(rfc)) {
            return { isValid: false, message: 'RFC de persona física inválido' };
        }

        return { isValid: true, message: '' };
    }

    // Nuevo método mejorado para validar fecha del RFC
    validateRFCDate(dateStr) {
        try {
            if (!dateStr || dateStr.length !== 6) {
                return { isValid: false, message: 'Formato de fecha inválido en el RFC' };
            }

            const year = parseInt(dateStr.substring(0, 2), 10);
            const month = parseInt(dateStr.substring(2, 4), 10);
            const day = parseInt(dateStr.substring(4, 6), 10);

            if (isNaN(year) || isNaN(month) || isNaN(day)) {
                return { isValid: false, message: 'La fecha contiene caracteres no numéricos' };
            }

            if (month < 1 || month > 12) {
                return { isValid: false, message: 'Mes inválido en el RFC' };
            }

            const fullYear = year < 50 ? 2000 + year : 1900 + year;
            const daysInMonth = new Date(fullYear, month, 0).getDate();

            if (day < 1 || day > daysInMonth) {
                return { isValid: false, message: 'Día inválido para el mes en el RFC' };
            }

            return { isValid: true, message: '' };
        } catch (error) {
            console.error('Error en validateRFCDate:', error);
            return { isValid: false, message: 'Error al validar fecha del RFC' };
        }
    }

    isGenericRFC(rfc) {
        if (!rfc || rfc.length < 12) return false;

        rfc = rfc.trim().toUpperCase();

        // Lista exacta de RFCs genéricos
        const exactGenericRFCs = [
            'XAXX010101000',
            'XEXX010101000',
            'XEXE010101000',
            'XXX010101XXX',
            'XXX010101XXA',
            'XXX010101XX9'
        ];

        // Verificar coincidencia exacta
        if (exactGenericRFCs.includes(rfc)) {
            return true;
        }

        // Patrones para variantes genéricas
        const genericPattern1 = /^X{3}[0-9]{6}X{3}$/;
        const genericPattern2 = /^[A-ZÑ&]{3,4}010101/;

        return genericPattern1.test(rfc) || genericPattern2.test(rfc);
    }

    validateFields() {
        if (!this.isAccountEnabled) {
            this.isContinueDisabled = true;
            return;
        }

        try {
            const rfcValid = this.validateRFC(this.rfcValue).isValid;
            const destinatarioValid = this.destinatarioValue && this.destinatarioValue.length >= 5;            

            const allFilled = rfcValid && destinatarioValid;
            const allEmpty = !this.rfcValue && !this.destinatarioValue;

            this.isContinueDisabled = !(allFilled || allEmpty);
        } catch (error) {
            console.error('Error en validateFields:', error);
            this.isContinueDisabled = true;
        }
    }

    handleInputChange(event) {
        const fieldName = event.target.name;
        const value = event.target.value;

        try {
            if (fieldName === 'rfc') {
                this.rfcValue = value.toUpperCase().trim();

                // Primero verificar si es genérico
                const isGeneric = this.isGenericRFC(this.rfcValue);

                // Hacer validación completa
                const validation = this.validateRFC(this.rfcValue);
                const rfcInput = this.template.querySelector('[name="rfc"]');

                if (rfcInput) {
                    rfcInput.setCustomValidity(validation.isValid ? '' : validation.message);
                    rfcInput.reportValidity();

                    // Mostrar toast SOLO si es genérico
                    if (isGeneric) {
                        this.showToast('RFC no permitido', 'No se aceptan RFCs genéricos. Por favor ingrese un RFC válido.', 'error');
                    }
                }
            }
            else if (fieldName === 'destinatario') {
                this.destinatarioValue = value.trim();
                const destInput = this.template.querySelector('[name="destinatario"]');
                if (destInput) {
                    const isValid = this.destinatarioValue.length >= 5;
                    destInput.setCustomValidity(isValid ? '' : 'El nombre del destinatario debe tener al menos 5 caracteres');
                    destInput.reportValidity();
                }
            }

            this.validateFields();
        } catch (error) {
            console.error('Error en handleInputChange:', error);
            this.showToast('Error', 'Ocurrió un error al validar los datos', 'error');
        }
    }


    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
        this.showContent = false;
    }

    handleCreateRequest() {
        // Validar RFC nuevamente por si acaso
        const rfcValidation = this.validateRFC(this.rfcValue);
        if (!rfcValidation.isValid) {
            this.showToast('RFC inválido', rfcValidation.message, 'error');
            return;
        }

        if (this.isContinueDisabled) {
            this.showToast('Error', 'Debes llenar todos los campos o dejarlos todos vacíos', 'error');
            return;
        }

        this.isLoading = true;

        updateShipmentData({
            shipmentId: this.recordId,
            datos: [this.rfcValue, this.destinatarioValue]
        })
            .then(() => {
                this.showToast('Éxito', 'Datos actualizados correctamente', 'success');
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('Error', error.body?.message || error.message, 'error');
            });
    }

    checkDatosCartaPorte() {
        getDatosCartaPorte({ shipmentId: this.recordId })
            .then(result => {
                if (result && result.startsWith('RFC DESTINATARIO:') && result.includes(',DESTINATARIO:')) {
                    const inicioRFC = 'RFC DESTINATARIO:'.length;
                    const finRFC = result.indexOf(',DESTINATARIO:');
                    const rfc = result.substring(inicioRFC, finRFC).trim();

                    const inicioNombre = finRFC + ',DESTINATARIO:'.length;
                    const nombre = result.substring(inicioNombre).trim();

                    this.rfcValue = rfc;
                    this.destinatarioValue = nombre;
                }
                this.isLoading = false;
                this.validateFields();
            })
            .catch(error => {
                this.isLoading = false;
                console.error(error);
            });
    }

    showToast(title, message, variant, duration = 3000) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant,
            mode: 'dismissable',
            duration: duration
        }));
    }
}