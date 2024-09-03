import { LightningElement, track } from 'lwc';
import getAddress from '@salesforce/apex/P2G_AccountAddress.getAddress';
import getCP from '@salesforce/apex/P2G_AccountAddress.getCP';
import getMarkets from '@salesforce/apex/P2G_AccountAddress.getMapMarkers'; 
import getMarketsName from '@salesforce/apex/P2G_AccountAddress.getMapMarkersByName';
export default class P2G_AccountAddresMap extends LightningElement {
    @track mapMarkers = [
        {
            location: {
                Latitude: 25.6866,
                Longitude: -100.3161
            },
            title: 'Monterrey, México',
        },
                {
            location: {
                Latitude: 25.6890,
                Longitude: -100.3161
            },
            title: 'Monterrey, México',
        }
    ];

    //@track mapMarkers;
    // addres busqueda
    @track searchValueAddress;
    @track searchValueIdAdress;
    @track sideRecordsAddress;
    searchKeyAddress(event) {
        this.searchValueAddress = event.target.value;
        this.searchValueIdAdress = '';
    
        if (this.searchValueAddress.length >= 3) {
            getAddress({ address: this.searchValueAddress })
                .then(result => {
                    this.sideRecordsAddress = result;
                })
                .catch(error => {
                    console.log('Error: ', error);
                    this.sideRecordsAddress = null;
                });
        } else {
            this.sideRecordsAddress = null;
        }
    }

    SideSelectAddress(event) {
        this.searchValueAddress = event.target.outerText;
        this.sideRecordsAddress = null;
        this.searchValueIdAdress = event.currentTarget.dataset.id;
        getMarketsName({ name: this.searchValueAddress })
        .then(result => {
            this.mapMarkers = result;
            console.log('mapMarkers: ',this.mapMarkers);
        })
        .catch(error => {
            console.log('Error: ', error);
            this.sideRecordsCp = null;
        });
    }

    // busqueda por cp
    @track searchValueCp;
    @track searchValueIdCp;
    @track sideRecordsCp;
    
    searchKeyCp(event) {
        this.searchValueCp = event.target.value;
        this.searchValueIdCp = '';
        
        if (this.searchValueCp.length >= 3) {
            getCP({ cp: this.searchValueCp })
                .then(result => {
                    this.sideRecordsCp = result;
                })
                .catch(error => {
                    console.log('Error: ', error);
                    this.sideRecordsCp = null;
                });
        } else {
            this.sideRecordsCp = null;
        }
    }
    
    SideSelectCp(event) {
        this.searchValueCp = event.target.outerText;
        this.sideRecordsCp = null;
        this.searchValueIdCp = event.currentTarget.dataset.id;
        getMarkets({ cp: this.searchValueCp })
                .then(result => {
                    this.mapMarkers = result;
                    console.log('mapMarkers: ',this.mapMarkers);
                })
                .catch(error => {
                    console.log('Error: ', error);
                    this.sideRecordsCp = null;
                });
    }
    

    // Para el modal principal
    isModalOpen = false;

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.isModalOpenVerOp1 = false;
        this.isModalOpenVerOp2 = false;
        this.isModalOpenVerOp3 = false;
    }

    // Manejo de los otros modales
    @track isModalOpenVerOp1 = false;
    @track isModalOpenVerOp2 = false;
    @track isModalOpenVerOp3 = false;

    handleNext() {
        // Declarar la variable verOp y realizar los cálculos
        let verOp;
        
        // Ejemplo de cálculo (puedes reemplazar esto con tu lógica real)
        const randomValue = Math.floor(Math.random() * 3) + 1; // Genera un valor entre 1 y 3
        verOp = `verOp${randomValue}`;

        // Lógica para mostrar el modal correspondiente
        this.isModalOpen = false; // Cerrar el modal principal

        if (verOp === 'verOp1') {
            this.isModalOpenVerOp1 = true;
        } else if (verOp === 'verOp2') {
            this.isModalOpenVerOp2 = true;
        } else if (verOp === 'verOp3') {
            this.isModalOpenVerOp3 = true;
        }
    }
}