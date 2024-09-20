import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAddress from '@salesforce/apex/P2G_AccountAddress.getAddress';
import getCP from '@salesforce/apex/P2G_AccountAddress.getCP';
import getMarkets from '@salesforce/apex/P2G_AccountAddress.getMapMarkers'; 
import getMarketsName from '@salesforce/apex/P2G_AccountAddress.getMapMarkersByName';
import getAddressGoogle from '@salesforce/apex/P2G_GeoLocationService.getAddress';
import getAddressGoogleCp from '@salesforce/apex/P2G_GeoLocationService.getAddressCp';
import addressOption from '@salesforce/apex/P2G_AccountAddress.createAddress';
import addressOptionD from '@salesforce/apex/P2G_AccountAddress.createAddressD';
import getResume from '@salesforce/apex/P2G_AccountAddress.getResume';
import getDuplicates from '@salesforce/apex/P2G_AccountAddress.getDuplicates';

export default class P2G_AccountAddresMap extends LightningElement {
    iframeSrc = '/apex/mapGoogle';

    @track nombre = '';
    @track calle = '';
    @track numero = '';
    @track colonia = '';
    @track codigoPostal = '';
    @track localidad = '';
    @track municipio='';
    @track estado = '';
    @track pais = '';
    @track address = ''; // Si necesitas manejar un campo general de dirección

    @track valor;

    @track lat;
    @track lng;
    @track mapMarkers = [
        {
            location: {
                Latitude: 25.6866,
                Longitude: -100.3161
            },
            title: 'Monterrey, México',
        }
    ];

    handleInputChange(event) {
        const fieldName = event.target.name;
        this[fieldName] = event.target.value;
    }

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
            this.mapMarkers = result.map(marker => {
                let rowClass = marker.status === 'Pendiente' ? 'yellow-background' : 'green-background';
                return { ...marker, rowClass }; // Añades la propiedad rowClass
            });
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
                    this.mapMarkers = result.map(marker => {
                        let rowClass = marker.status === 'Pendiente' ? 'yellow-background' : 'green-background';
                        return { ...marker, rowClass }; // Añades la propiedad rowClass
                    });
                })
                .catch(error => {
                    console.log('Error: ', error);
                    this.sideRecordsCp = null;
                });
    }
    

    // Para el modal principal
    isModalOpen = false;
    showInstructions = false;

    openModal() {
        this.isModalOpen = true;
        this.showInstructions = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.isModalOpenVerOp1 = false;
        this.isModalOpenVerOp2 = false;
        this.isModalOpenVerOp3 = false;

        this.showInstructions = false;

    }

    closeInstructions() {
        this.showInstructions = false; // Cierra solo el modal de instrucciones
    }

    // Manejo de los otros modales
    @track isModalOpenVerOp1 = false;
    @track isModalOpenVerOp2 = false;
    @track isModalOpenVerOp3 = false;

    createStringList() {
        const stringList = [
            this.pais,
            this.estado,
            this.municipio,
            this.localidad,
            this.colonia,
            this.calle,
            this.numero,
            this.codigoPostal,
            this.nombre,
            this.address,
            this.lat?.toString(),
            this.lng?.toString()
        ];

        return stringList;
    }

    handleNextOri() {
        const stringList = this.createStringList();
        let verOp;
        let valor;
        //this.showToast('Error', 'Error Al crear Direccion', 'Error');
        // Declarar la variable verOp y realizar los cálculos

        addressOption({ direccion: stringList })
        .then(result => {
            valor = result;
            console.log('valor: ',valor);
        })
        .catch(error => {
            console.log('Error: ', error);
            valor = 'no';
        });
        
        switch (valor) {
            case 'no':
                // Código para el caso 'no'
                verOp = 3;
                break;

            case 'duplicado':
                // Código para el caso 'duplicado'
                verOp = 2;
                break;

            default:
                // regreso el id
                verOp = 1;
                break;
        }

        // Lógica para mostrar el modal correspondiente
        this.isModalOpen = false; // Cerrar el modal principal

        if (verOp === 1) {
            this.isModalOpenVerOp1 = true;
        } else if (verOp === 2) {
            this.isModalOpenVerOp2 = true;
        } else if (verOp === 3) {
            this.isModalOpenVerOp3 = true;
        }
    }

    @track direccion;

    handleNext() {
        const stringList = this.createStringList();
    
        addressOption({ direccion: stringList })
        .then(result => {
            this.valor = result;
            console.log('valor: ', this.valor);
        })
        .catch(error => {
            console.log('Error: ', error);
            this.valor = 'no';
        })
        .finally(() => {
            this.isModalOpen = false; // Cerrar el modal principal
            switch (this.valor) {
                case 'no':
                    this.isModalOpenVerOp1 = false;
                    this.isModalOpenVerOp2 = false;
                    this.showToast('Error', 'Ocurrió un error al procesar la solicitud', 'error');
                    break;
                case 'duplicado':
                    this.getAddresDupli();
                    break;
                default:
                    this.getAddresNew();
                    break;
            }

        });
    }

    @track dire;
    @track direcciones;

    getAddresNew() {
        console.debug('Enrtra getAdreNew');
        getResume({ idAddress: this.valor })
        .then(result => {
            this.direccion = result;
            this.dire = this.direccion[0];
            console.log('direccion: ',this.direccion[0]);
            this.isModalOpenVerOp1 = true;
            this.isModalOpenVerOp2 = false;
            this.isModalOpenVerOp3 = false;
        })
        .catch(error => {
            console.log('Error: ', error);
            this.direccion = null;
        })
    }

    clickDupli() {
        const stringList = this.createStringList();
    
        addressOptionD({ direccion: stringList })
        .then(result => {
            this.valor = result;
            console.log('IdDupli: ', this.valor);
            this.getAddresNew();
        })
        .catch(error => {
            console.log('Error: ', error);
            this.showToast('Error', 'Ocurrió un error al crear Duplicado', 'error');

        })
        .finally(() => {

        });
    }

    getAddresDupli() {
        console.debug('Enrtra dupli');
        getDuplicates({ codigoPostal: this.codigoPostal, colonia: this.colonia})
        .then(result => {
            this.direcciones = result;
            this.isModalOpenVerOp1 = false;
            this.isModalOpenVerOp2 = true;
            this.isModalOpenVerOp3 = false;
        })
        .catch(error => {
            console.log('Error: ', error);
            this.direccion = null;
        })
    }

    connectedCallback() {
        // Agregar listener para recibir mensajes desde el iframe
        window.addEventListener('message', this.handleMessage.bind(this));
    }

    disconnectedCallback() {
        // Remover listener para evitar leaks de memoria
        window.removeEventListener('message', this.handleMessage.bind(this));
    }

    handleMessage(event) {
        // Validar origen del mensaje si es necesario
        // if (event.origin !== 'https://your-salesforce-domain.com') return;

        const { lat, lng } = event.data;

        // Verificar si los datos son válidos
        if (lat && lng) {
            this.lat = lat;
            this.lng = lng;
            console.debug(`Latitud recibida: ${lat}, Longitud recibida: ${lng}`);

            // Aquí puedes agregar lógica para guardar estos valores o usarlos como desees
        }
    }

    fijarPosicion() {
        getAddressGoogle({ latitude: this.lat ,longitude:this.lng, name:this.nombre})
        .then(result => {
            const { pais, estado, municipio, localidad, colonia, calle, numero, codigo_postal, address,name} = result;
            this.pais = pais;
            this.estado = estado;
            this.municipio = municipio;
            this.localidad = localidad;
            this.colonia = colonia;
            this.calle = calle;
            this.numero = numero;
            this.codigoPostal = codigo_postal;
            this.address = address;
            this.nombre = name;
        })
        .catch(error => {
            console.error('Error al obtener la dirección:', error);
        });
    }

    searchCodigoPostal() {
        console.log('Clickkk',this.codigoPostal);
        getAddressGoogleCp({postalCode:this.codigoPostal})
        .then(result => {
            const { pais, estado, municipio, localidad, colonia, calle, numero, codigo_postal, address, lat, lng} = result;
            this.pais = pais;
            this.estado = estado;
            this.municipio = municipio;
            this.localidad = localidad;
            this.colonia = colonia;
            this.calle = calle;
            this.numero = numero;
            this.codigoPostal = codigo_postal;
            this.address = address;
            this.lat = lat;
            this.lng = lng;
            this.sendCoordinatesToVFPage(parseFloat(lat), parseFloat(lng));
        })
        .catch(error => {
            console.error('Error al obtener la dirección:', error);
        });
    }

    sendCoordinatesToVFPage(lat, lng) {
        const vfWindow = this.template.querySelector('iframe').contentWindow; // Asegúrate de seleccionar correctamente el iframe
        vfWindow.postMessage({ lat, lng }, '*'); // Cambia '*' a tu dominio de Salesforce para mayor seguridad
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    handleRowClick(event) {
        const markerId = event.currentTarget.dataset.id;
        const baseUrl = window.location.origin;
        const recordUrl = `${baseUrl}/lightning/r/Account_Address__c/${markerId}/view`;
        console.log('URL: ',recordUrl);
        window.open(recordUrl, '_blank');
    }
}