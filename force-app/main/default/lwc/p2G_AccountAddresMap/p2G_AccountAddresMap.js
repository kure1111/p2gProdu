import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAddress from '@salesforce/apex/P2G_AccountAddress.getAddress';
import getCP from '@salesforce/apex/P2G_AccountAddress.getCP';
import getMarkets from '@salesforce/apex/P2G_AccountAddress.getMapMarkers'; 
import getMarketsName from '@salesforce/apex/P2G_AccountAddress.getMapMarkersByName';
import getMapMarkersByUser from '@salesforce/apex/P2G_AccountAddress.getMapMarkersByUser';
import getAddressGoogle from '@salesforce/apex/P2G_GeoLocationService.getAddress';
import getAddressGoogleCp from '@salesforce/apex/P2G_GeoLocationService.getAddressCp';
import addressOption from '@salesforce/apex/P2G_AccountAddress.createAddress';
import addressOptionD from '@salesforce/apex/P2G_AccountAddress.createAddressD';
import getResume from '@salesforce/apex/P2G_AccountAddress.getResume';
import getDuplicates from '@salesforce/apex/P2G_AccountAddress.getDuplicates';
import addressEdit from '@salesforce/apex/P2G_AccountAddress.addressEdit';


export default class P2G_AccountAddresMap extends LightningElement {
    iframeSrc = '/apex/mapGoogle';
    valorrr = 6;
    @track nombre = '';
    @track calle = '';
    @track numero = '';
    @track colonia = '';
    @track codigoPostal = '';
    @track localidad = '';
    //@track municipio='';
    @track estado = '';
    @track pais = '';
    @track address = ''; // Si necesitas manejar un campo general de dirección

    @track valor;

    @track lat;
    @track lng;
    latProvisional = 25.6866;
    lonProvisional = -100.3161;
    @track mapMarkers = [
        {
            location: {
                Latitude: this.latProvisional,
                Longitude: this.lonProvisional
            },
            title: 'Monterrey, México',
        }
    ];

    @track showResumen = false;
    @track showResumenEdit = false;

    handleInputChange(event) {
        const fieldName = event.target.name;
        this[fieldName] = event.target.value;
    }

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
                    if(this.sideRecordsAddress.length === 0){
                        this.showToast('Error', 'Sin registros validados encontrados', 'error');
                    }
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
    isModalOpenEdit = false;

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.isModalOpenVerOp1 = false;
        this.isModalOpenVerOp2 = false;
        this.location2User();
        this.resetFields();
    }

    closeModalEdit() {
        this.isModalOpenEdit = false;
        this.modalEdit = false;
        this.location2User();
        this.resetFields();
    }

    // Manejo de los otros modales
    @track isModalOpenVerOp1 = false;
    @track isModalOpenVerOp2 = false;

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

    @track direccion;

    handleNext() {

        if(!this.lat){
            this.showToast('Fijar', 'Por favor, lee las instrucciones, Fijar ubicacion es necesario', 'warning');
            return;
        }

        if (this.validateFields()) {
            this.showToast('Datos necesarios', 'Por favor, lee las instrucciones, faltan datos necesarios', 'warning');
            return;
        }
        this.showResumen = true;
        //this.isModalOpen = false;
    }

    handleNextEdit() {

        if(!this.lat){
            this.showToast('Mover', 'Para editar es necesario mover el marker y fijar de nuevo', 'warning');
            return;
        }

        if (this.validateFields()) {
            this.showToast('Datos necesarios', 'Por favor, lee las instrucciones, faltan datos necesarios', 'warning');
            return;
        }
        this.showResumenEdit = true;
    }

    handleCancel() {
        // Lógica para cerrar el modal o cancelar
        this.showResumen = false;
        this.showResumenEdit = false;
        //this.isModalOpen = true;
    }

    handleAccept() {
        this.showResumen = false;
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

    handleEdit() {
        this.showResumenEdit = false;
        const stringList = this.createStringList();
        stringList.push(this.idEdit);
        addressEdit({ direccion: stringList })
        .then(result => {
            this.valor = result;
            this.getAddresEdit();
            this.modalEdit = true;
        })
        .catch(error => {
            console.log('Error: ', error);
            this.modalEdit = false;
            this.showToast('Error', 'Ocurrió un error al editar', 'error');

        })
        .finally(() => {
            this.location2User();
        });

    }

    // Función para validar los campos obligatorios
    validateFields() {
        const inputGroups = this.template.querySelectorAll('.input-group');
        let hasError = false;

        inputGroups.forEach(group => {
            const input = group.querySelector('lightning-input');
            if (input && (input.name === 'nombre' || input.name === 'calle' || input.name === 'numero' || input.name === 'colonia')) {
                // Comprobar si el valor está vacío o solo contiene espacios
                if (!input.value || input.value.trim() === '') {
                    // Añadir clase de error al contenedor
                    group.classList.add('input-error');  
                    hasError = true;
                } else {
                    // Remover clase de error si el campo está lleno
                    group.classList.remove('input-error');  
                }
            }
        });

        return hasError;
    }

    @track dire;
    @track direcciones;

    getAddresNew() {
        console.debug('Enrtra getAdreNew');
        getResume({ idAddress: this.valor })
        .then(result => {
            this.direccion = result;
            this.dire = this.direccion[0];
            this.isModalOpenEdit = false;
            this.isModalOpenVerOp1 = true;
            this.isModalOpenVerOp2 =false;
            this.showResumen = false;

        })
        .catch(error => {
            console.log('Error: ', error);
            this.direccion = null;
            this.modalEdit = false;
        })
    }

    getAddresEdit() {
        getResume({ idAddress: this.valor })
        .then(result => {
            this.direccion = result;
            this.dire = this.direccion[0];
            this.isModalOpenEdit = false;
            this.modalEdit = true;
            this.showResumenEdit = false;

        })
        .catch(error => {
            console.log('Error: ', error);
            this.direccion = null;
            this.modalEdit = false;
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
        })
        .catch(error => {
            console.log('Error: ', error);
            this.direccion = null;
            this.isModalOpenVerOp2 = false;
        })
    }

    connectedCallback() {
        // Agregar listener para recibir mensajes desde el iframe
        window.addEventListener('message', this.handleMessage.bind(this));
        this.location2User();
    }

    disconnectedCallback() {
        // Remover listener para evitar leaks de memoria
        window.removeEventListener('message', this.handleMessage.bind(this));
    }

    handleMessage(event) {
        const { lat, lng } = event.data;

        // Verificar si los datos son válidos
        if (lat && lng) {
            this.lat = lat;
            this.lng = lng;
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
    @track idEdit = '';

    handleButtonClick(event) {
        this.isModalOpenEdit = true;
        const markerId = event.currentTarget.dataset.id;
        console.log('clickkk ',markerId);
        this.idEdit = markerId;
        getResume({ idAddress: markerId })
            .then(result => {
                this.direccion = result;
                this.dire = this.direccion[0];
                // Obtener latitud y longitud desde el campo 'location'
                const lat = this.dire.location.Latitude;
                const lon = this.dire.location.Longitude;
                this.nombre = this.dire.title;
                this.calle = this.dire.calle;
                this.numero = this.dire.numero;
                this.colonia = this.dire.colonia;
                this.codigoPostal = this.dire.codigoPostal;
                this.localidad = this.dire.localidad;
                this.estado = this.dire.estado;
                this.pais = this.dire.pais;
                this.address = this.dire.description; 
                // Esperar un pequeño tiempo para asegurarse de que el iframe está cargado
                setTimeout(() => {
                    const iframe = this.template.querySelector('iframe');
                    if (iframe) {
                        iframe.contentWindow.postMessage({
                            lat: lat,
                            lng: lon
                        }, '*');  // Puedes ajustar '*' por el dominio seguro de Salesforce
                    }
                }, 3000); // Ajusta el tiempo si es necesario
            })
            .catch(error => {
                console.log('Error edicion: ', error);
                this.direccion = null;
                this.idEdit = '';
            });
    }
    

    resetFields() {
        this.nombre = '';
        this.calle = '';
        this.numero = '';
        this.colonia = '';
        this.codigoPostal = '';
        this.localidad = '';
        this.municipio = '';
        this.estado = '';
        this.pais = '';
        this.address = ''; // Campo general de dirección
        this.valor = null; // Valor puede ser null o '' según el uso
        this.lat = null; // Puedes dejar lat y lng como null o '' dependiendo de tus validaciones
        this.lng = null;
        this.idEdit = '';
    }

    @track mapMarkerperUser;
    @track selectedStatus = 'Todos';
    
    location2User() {
        getMapMarkersByUser()
        .then(result => {
            // Filtrar los resultados si el filtro no es "todos"
            let filteredMarkers = result;
            if (this.selectedStatus !== 'Todos') {
                filteredMarkers = result.filter(marker => marker.status === this.selectedStatus);
            }
    
            // Mapear los resultados para agregar las clases de color según el estado
            this.mapMarkerperUser = filteredMarkers.map(marker => {
                let rowClass;
                let isRechazado = false;  // Nueva propiedad para indicar si el estado es 'Rechazado'
    
                if (marker.status === 'Pendiente') {
                    rowClass = 'yellow-background';
                } else if (marker.status === 'Validado') {
                    rowClass = 'green-background';
                } else if (marker.status === 'Rechazado') {
                    rowClass = 'red-background';
                    isRechazado = true; // Si es Rechazado, esta propiedad será true
                }
    
                return { 
                    ...marker, 
                    rowClass,  // Añadir la clase CSS
                    isRechazado // Añadir la propiedad booleana
                };
            });
        })
        .catch(error => {
            console.error('Error location2User: ', error);
            this.mapMarkerperUser = null;
        });
    }
    

    @track statusOptions = [
        { label: 'Todos', value: 'Todos' },
        { label: 'Validado', value: 'Validado' },
        { label: 'Pendiente', value: 'Pendiente' },
        { label: 'Rechazado', value: 'Rechazado' }
    ];

    // Maneja el cambio en el picklist
    handlePicklistChange(event) {
        this.selectedStatus = event.detail.value;
        this.location2User();
    }
    
    
}