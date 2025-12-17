import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getCasosRelacionados from '@salesforce/apex/P2G_CreateCaseForNoShow.getRelatedCases';

export default class CaseValidationWarning extends LightningElement {
    @track showWarning = false;
    @api recordId;

    @wire(CurrentPageReference)
    setCurrentPageReference(pageRef) {
        if (!this.recordId) {
            this.recordId = pageRef?.state?.c__recordId || pageRef?.attributes?.recordId || null;
        }
        if (this.recordId) {
            this.validarCasos();
        }
    }

    async validarCasos() {
        try {
            const casos = await getCasosRelacionados({ recordId: this.recordId });
            console.log('Casos recibidos:', casos);

            if (casos && casos.length > 0) {
                // Verificar si todas las descripciones están correctamente rellenadas
                this.showWarning = casos.some(caso => {
                    const descripcion = caso.Description ? caso.Description.trim() : '';
                    console.log('Descripción del caso:', descripcion);
                    return descripcion === '';
                });
            } else {
                this.showWarning = false;
            }

            console.log('¿Mostrar advertencia?', this.showWarning);
        } catch (error) {
            console.error('Error al obtener casos relacionados: ', error);
        }
    }
}