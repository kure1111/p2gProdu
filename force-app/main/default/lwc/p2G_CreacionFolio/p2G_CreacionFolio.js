import { LightningElement,track, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSide from '@salesforce/apex/P2G_CreacionCargoLines.getSideCountry';
import getAccount from '@salesforce/apex/P2G_CreacionCargoLines.getAccount';
import getCustomer from '@salesforce/apex/P2G_CreacionCargoLines.getCustomerQuote';
import getWrapper from '@salesforce/apex/P2G_CreacionFolios.getwrapper';
import getCargolineWraper from '@salesforce/apex/P2G_CreacionFolios.getCargoline';
import creaFolios from '@salesforce/apex/P2G_CreacionFolios.creaFolios';
import getIdFolio from '@salesforce/apex/P2G_CreacionFolios.getIdFolio';
import getClaveSAT from '@salesforce/apex/P2G_CreacionCargoLines.getClaveSAT';
import getContainerType from '@salesforce/apex/P2G_CreacionCargoLines.getContainerType';
import creaCargoLine from '@salesforce/apex/P2G_CreacionFolios.creaCargoLine';
import getServiceLine from '@salesforce/apex/P2G_CreacionCargoLines.getServiceLine';
import getCargoLine from '@salesforce/apex/P2G_CreacionCargoLines.getCargoLine';
import updatePrice from '@salesforce/apex/P2G_CreacionCargoLines.updatePrice';
import updatePriceList from '@salesforce/apex/P2G_CreacionCargoLines.updatePriceList';
import condicionesTarifario from '@salesforce/apex/P2G_CreacionFolios.condicionesTarifario';
import { refreshApex } from '@salesforce/apex';
import fileProcess from '@salesforce/apex/P2G_convertCsv.fileProcess';
import getSapServiceType from '@salesforce/apex/P2G_CreacionCargoLines.getSapServiceType';

export default class P2G_CreacionFolio extends LightningElement {
    //lista de cargo line
    quote ;
        @wire(getCargoLine,{listaFolio: '$quote'})
        listCargoLine;
        //idQuote; = IdFolios[0].Id;'a0IDV000007FNoy2AG';
        @wire(getServiceLine) 
        listServiceLine;
    // fin lista cargo line
    value = 'No';
    @track isF_NACIONAL = false;
    @track isGeneFolio = false;
    @track isCargoLine = false;
    @track wrapperFolio;
    @track wrapperCargoLine;
    @track crearFolios;
    @track sideRecordsLoad;
    @track listaFolios;
    @track listServiceLine;
    @track creaCargoLine;
    @track Tarifario;
    @track undatetarifario;
    @track updatePriceList;
    nfolios = 1;
    searchValueLoad ='';
    searchValueIdLoad ='';
    showSideLoad = false;
    numfolios = 1;
    ItemPrice = true;
    precio;
    quoteSellPrice = 0;
    esTarifario = false;
    
    @track sideRecordsDischarge;
    searchValueDischarge ='';
    searchValueIdDischarge ='';
    showSideDischarge = false;

    @track sideRecordsAccount;
    searchValueAccount ='';
    searchValueIdAccount ='';
    showSideAccount = false;
    customerId = false;

    @track sideRecordsCustomer;
    searchValueCustomer ='';
    searchValueIdCustomer ='';
    showSideCustomer = false;

    //inicio var Cargo Lines
    @track sideRecordsClaveServicio;
    searchValueClaveServicio ='';
    searchValueIdClaveServicio ='';
    showSideClaveServicio = false;
    
    @track sideRecordsMaterialPeligroso;
    searchValueMaterialPeligroso ='';
    searchValueIdMaterialPeligroso ='';
    showSideMaterialPeligroso = false;
    
    @track sideRecordsEmbalaje;
    searchValueEmbalaje ='';
    searchValueIdEmbalaje ='';
    showSideEmbalaje = false;
    
    @track sideRecordsContainerType;
    searchValueContainerType ='';
    searchValueIdContainerType ='';
    showSideContainerType = false;

    @track sideRecordsClaveUnidadPeso;
    searchValueClaveUnidadPeso ='';
    searchValueIdClaveUnidadPeso ='';
    showSideClaveUnidadPeso = false;

    Descripcionproducto = '';
    units = '';
    pesoBruto = 1;
    pesoNeto = 1;
    currency = 'MXN';
    totalShipping = 1;
    //fin var Cargo Lines

    @track IdFolios;
    folioname ='';
    folioId = '';
    idQuote = '';
    varurl = '';
    rateName = '';

    ComercioEx = 'No';
    team = 'P2G';
    Custumer = '';
    ETA = '';
    ETD = '';
    loadtime = '';
    unloadtime ='';

    @track carga = false;
    @track csvFile;
    fileName = '';

    @track recordSST;
    showSST=false;
    searchSST='FLETE NACIONAL (IC) (FN)';
    searchKeyIdSST='';

//valores Comercio Exterior
    get options() {
        return [
            { label: 'Si', value: 'Si' },
            { label: 'No', value: 'No' },
        ];
    }
pushMessage(title, variant, message){
    const event = new ShowToastEvent({
        title: title,
        variant: variant,
        message: message,
    });
    this.dispatchEvent(event);
}
// buscador Site of Load
    SideSelectLoad(event){
        this.searchValueLoad = event.target.outerText;
        this.showSideLoad = false;
        this.searchValueIdLoad = event.currentTarget.dataset.id;
        this.wrapperFolio.idSideLoad = event.currentTarget.dataset.id;
    }
    searchKeyLoad(event){
        this.searchValueLoad = event.target.value;
        this.searchValueIdLoad='';
        if (this.searchValueLoad.length >= 3) {
            this.showSideLoad = true;
            getSide({country: this.searchValueLoad})
                .then(result => {
                    this.sideRecordsLoad = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsLoad = null;
                });
        }
        else{
            this.showSideLoad = false;
        }
    }

// buscador Site of Discharge
    SideSelectDischarge(event){
        this.searchValueDischarge = event.target.outerText;
        this.showSideDischarge = false;
        this.searchValueIdDischarge = event.currentTarget.dataset.id;
        this.wrapperFolio.idSideDischarged = event.currentTarget.dataset.id;
        //console.log(event.currentTarget.dataset.id);
    }
    searchKeyDischarge(event){
        this.searchValueDischarge = event.target.value;
        this.searchValueIdDischarge='';
        if (this.searchValueDischarge.length >= 3) {
            this.showSideDischarge = true;
            getSide({country: this.searchValueDischarge})
                .then(result => {
                    this.sideRecordsDischarge = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsDischarge = null;
                });
        }
        else{
            this.showSideDischarge = false;
        }
    }
    
// buscador Account
    SideSelectAccount(event){
        this.searchValueAccount = event.target.outerText;
        this.showSideAccount = false;
        this.searchValueIdAccount = event.currentTarget.dataset.id;
        this.wrapperFolio.idAccount = event.currentTarget.dataset.id;
        this.wrapperCargoLine.idItemSuplienerOwner = event.currentTarget.dataset.id;
        this.wrapperFolio.idReferenceForm='';
    }
    searchKeyAccount(event){
        this.searchValueAccount = event.target.value;
        this.searchValueIdAccount='';
        if (this.searchValueAccount.length >= 3) {
            this.showSideAccount = true;
            getAccount({account: this.searchValueAccount})
                .then(result => {
                    this.sideRecordsAccount = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.sideRecordsAccount = null;
                });
        }
        else{
            this.showSideAccount = false;
        }
    }
    //buscado sap service type
    SideSelectSST(event){
        this.searchSST = event.target.outerText;
        this.showSST = false;
        this.searchKeyIdSST = event.currentTarget.dataset.id;
    }
    searchKeyAccount2(event){
        this.searchSST = event.target.value;
        this.searchKeyIdSST='';
        if (this.searchSST.length >= 3) {
            this.showSST = true;
            getSapServiceType({sapServiceT: this.searchSST})
                .then(result => {
                    this.recordSST = result;
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.recordSST = null;
                });
        }
        else{
            this.showSST = false;
        }
    }
        
// buscador Customer
SideSelectCustomer(event){
    this.searchValueCustomer = event.target.outerText;
    this.showSideCustomer = false;
    this.searchValueIdCustomer = event.currentTarget.dataset.id;
    this.wrapperFolio.idReferenceForm = event.currentTarget.dataset.id;
    //console.log(event.currentTarget.dataset.id);
}
searchKeyCustomer(event){
    this.searchValueCustomer = event.target.value;
    this.searchValueIdCustomer='';
    this.wrapperFolio.idReferenceForm = '';
    if (this.searchValueCustomer.length >= 3) {
        this.showSideCustomer = true;
        getCustomer({folio: this.searchValueCustomer,Customer: this.searchValueIdAccount})
            .then(result => {
                this.sideRecordsCustomer = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsCustomer = null;
            });
    }
    else{
        this.showSideCustomer = false;
    }
}

registroTeam(event){
    this.wrapperFolio.team = event.target.value;
}
registroCustomer(event){
    this.wrapperFolio.reference = event.target.value;
}
registroETD(event){
    this.wrapperFolio.ETD = event.target.value;
}
registroETA(event){
    this.wrapperFolio.ETA = event.target.value;
}
numFoliosCrear(event){
    this.wrapperFolio.numFoliosCrear = event.target.value;
    this.nfolios = event.target.value;
    if(event.target.value > 1000){
        this.wrapperFolio.numFoliosCrear = 1000;
        this.numfolios = 1000;
    }
    if(this.wrapperFolio.numFoliosCrear <= 0){
        this.wrapperFolio.numFoliosCrear = 1;
        this.numfolios = 1;
    }
}
registroloadtime(event){
    this.wrapperFolio.Awaitingloadtime = event.target.value;
}
registrounloadtime(event){
    this.wrapperFolio.Awaitingunloadtime = event.target.value;
}

//Abril Modal Pop flete nacional
OpenF_NACIONAL(){
    this.isF_NACIONAL = true;
    this.searchKeySST='FLETE NACIONAL (IC) (FN)';
    getWrapper()
            .then(result => {
                this.wrapperFolio = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.wrapperFolio = null;
            });
            getCargolineWraper()
            .then(result => {
                this.wrapperCargoLine = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.wrapperCargoLine = null;
            });
    
}
closeF_NACIONAL() {
    //this.isGeneFolio = true;
    this.isF_NACIONAL = false;
    this.carga = false;
    this.csvFile = null;
    this.fileName = null;
}
RegistrItemPrice(event){
    this.precio = event.target.value;
    this.quoteSellPrice = event.target.value;
}
AgregarItemPrice(){
    if(this.Tarifario !== null){
    updatePrice({listaFolio: this.IdFolios, price: this.precio, sapType: this.searchSST})
    .then(result => {
        this.undatetarifario = result;
        this.precio = null;
        this.pushMessage('Exitoso!','success','Se actualizo el precio con exito!');
    })
    .catch(error => {
        this.pushMessage('Error','error', error.body.message);
        this.undatetarifario = null;
    });
    }else{
    updatePriceList({listaFolio: this.IdFolios, price: this.precio, sapType: this.searchSST})
    .then(result => {
        this.updatePriceList = result;
        this.precio = null;
        this.pushMessage('Exitoso!', 'success', 'Se actualizo el precio con exito!');
    })
    .catch(error => {
        this.pushMessage('Error','error', error.body.message);
        this.updatePriceList = null;
    });
    }
}

cleanClaveUnidadPeso(){
    this.searchValueClaveUnidadPeso = '';
    this.showSideClaveUnidadPeso = false;
    this.searchValueIdClaveUnidadPeso = '';
    this.wrapperFolio.recordTypeUnidad = '';
}

GeF_NACIONAL(){
    //id por defecto en uat para clave de unidad de peso a3n0R000000ETiqQAG
    //id por defecto en produccion para clave de unidad de peso a3K4T000000SNdIUAW

    this.wrapperFolio['recordTypeUnidad'] = this.wrapperFolio.recordTypeUnidad && this.wrapperFolio.recordTypeUnidad.length > 0 ? this.wrapperFolio.recordTypeUnidad : 'a3K4T000000SNdIUAW';
    creaFolios({fleteNacional: this.wrapperFolio, cargoLine: this.wrapperCargoLine})   
    .then(result => {
        this.listaFolios = result;
        if(result!==null){
            this.pushMessage('Exitoso!', 'success', 'Folio/s Generado Con exito!');
            this.isGeneFolio = true;
            this.cleanClaveUnidadPeso();
            if(this.searchKeyIdSST.length<3){
                this.searchKeyIdSST='a1n4T000001XXYCQA4'; //prod a1n4T000001XXYCQA4 UAT:a1n0R000001lZceQAE
            }
            getIdFolio({listaFolio: this.listaFolios,divisa: this.currency,idConteinerType: this.searchValueIdContainerType,account: this.searchValueIdAccount,idSST:this.searchKeyIdSST})
                .then(result => {
                    this.IdFolios = result;
                    this.idQuote = this.IdFolios[0].Id;
                    this.quote = this.IdFolios;
                    if (this.IdFolios[0].Account_for__r.Customer_Id__c == null){
                        this.customerId = true;
                    }
                    console.log(this.idQuote +'----' +this.IdFolios[0].Account_for__r.Customer_Id__c);
                getServiceLine({idQuote: this.idQuote})
                    .then(result => {
                        this.listServiceLine = result;
                        this.rateName = this.listServiceLine.Service_Rate_Name__r.Name;
                        //this.quoteSellPrice = result[0].Quote_Sell_Price__c;
                    })
                    .catch(error => {
                        this.isGeneFolio = true;
                        this.pushMessage('Error','error', error.body.message);
                        this.listServiceLine = null;
                    });
                condicionesTarifario({idAccount: this.wrapperFolio.idAccount, idServiceType: this.searchKeyIdSST, 
                    idContainerType: this.wrapperCargoLine.idConteinerType, IdRoute: this.IdFolios[0].Route__c})
                .then(result => {
                this.Tarifario = result;
                if(result !== null){
                    this.esTarifario=true;
                    this.quoteSellPrice = result.Fee_Rate__c;
                }else{
                    this.esTarifario=false;
                }
                })
                .catch(error => {
                    this.pushMessage('Error','error', error.body.message);
                    this.Tarifario = null;
                });
                })
                .catch(error => {
                    this.isGeneFolio = true;
                    this.pushMessage('Error','error', error.body.message);
                    this.IdFolios = null;
                });
                    return refreshApex(this.listCargoLine);
        }
        else{
            this.isGeneFolio = false;
            this.pushMessage('Error', 'error', 'Error al Crear Folio, Consulte a su Administrador');
            this.isF_NACIONAL = true;
            return refreshApex(this.listCargoLine);
        }
    })
    this.dispatchEvent('close');
                //*/
}
    closeResumen(){
        this.isGeneFolio = false;
        this.isF_NACIONAL = false;
        this.searchValueAccount = null;
        this.Custumer = null;
        this.searchValueCustomer = null;
        this.searchValueLoad = null;
        this.searchValueDischarge = null;
        this.loadtime = null;
        this.unloadtime = null;
        this.searchValueContainerType = null;
        this.searchValueEmbalaje = null;
        this.searchValueMaterialPeligroso = null;
        this.searchValueClaveServicio = null;
        this.quoteSellPrice = 0;
        this.nfolios = 1;
        this.searchKeyIdSST='a1n4T000001XXYCQA4'; //prod a1n4T000001XXYCQA4 UAT:a1n0R000001lZceQAE
    }
    abrirFolio(event){
            this.folioname = event.target.outerText;
            this.folioId = event.currentTarget.dataset.id;
            //produccion https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/
            //uat https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/
            this.varurl = "https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/"+this.folioId+"/view";
            var win = window.open(this.varurl, '_blank');
            win.focus();
    }
    
    // busquedad y valor de var de la cargo line
    
// buscador ClaveServicio
SideSelectClaveServicio(event){
    this.searchValueClaveServicio = event.target.outerText;
    this.showSideClaveServicio = false;
    this.searchValueIdClaveServicio = event.currentTarget.dataset.id;
    this.wrapperCargoLine.idClaveSat = event.currentTarget.dataset.id;
    this.wrapperCargoLine.extencionItemName = event.target.outerText;
}
searchKeyClaveServicio(event){
    this.searchValueClaveServicio = event.target.value;
    this.searchValueIdClaveServicio='';
    if (this.searchValueClaveServicio.length >= 3) {
        this.showSideClaveServicio = true;
        getClaveSAT({sat: this.searchValueClaveServicio,record: '1'})
            .then(result => {
                this.sideRecordsClaveServicio = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsClaveServicio = null;
            });
    }
    else{
        this.showSideClaveServicio = false;
    }
}
    
// buscador Material Peligroso
SideSelectMaterialPeligroso(event){
    this.searchValueMaterialPeligroso = event.target.outerText;
    this.showSideMaterialPeligroso = false;
    this.searchValueIdMaterialPeligroso = event.currentTarget.dataset.id;
    this.wrapperCargoLine.MaterialPeligroso = event.currentTarget.dataset.id;
}
searchKeyMaterialPeligroso(event){
    this.searchValueMaterialPeligroso = event.target.value;
    this.searchValueIdMaterialPeligroso='';
    if (this.searchValueMaterialPeligroso.length >= 3) {
        this.showSideMaterialPeligroso = true;
        getClaveSAT({sat: this.searchValueMaterialPeligroso,record: '2'})
            .then(result => {
                this.sideRecordsMaterialPeligroso = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsMaterialPeligroso = null;
            });
    }
    else{
        this.showSideMaterialPeligroso = false;
    }
}
   
// buscador Embalaje
SideSelectEmbalaje(event){
    this.searchValueEmbalaje = event.target.outerText;
    this.showSideEmbalaje = false;
    this.searchValueIdEmbalaje = event.currentTarget.dataset.id;
    this.wrapperCargoLine.Embalaje = event.currentTarget.dataset.id;
}
searchKeyEmbalaje(event){
    this.searchValueEmbalaje = event.target.value;
    this.searchValueIdEmbalaje='';
    if (this.searchValueEmbalaje.length >= 3) {
        this.showSideEmbalaje = true;
        getClaveSAT({sat: this.searchValueEmbalaje,record: '3'})
            .then(result => {
                this.sideRecordsEmbalaje = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsEmbalaje = null;
            });
    }
    else{
        this.showSideEmbalaje = false;
    }
}
   
// buscador Container Type
SideSelectContainerType(event){
    this.searchValueContainerType = event.target.outerText;
    this.showSideContainerType = false;
    this.searchValueIdContainerType = event.currentTarget.dataset.id;
    this.wrapperCargoLine.idConteinerType = event.currentTarget.dataset.id;
}
searchKeyContainerType(event){
    this.searchValueContainerType = event.target.value;
    this.searchValueIdContainerType='';
    if (this.searchValueContainerType.length >= 3) {
        this.showSideContainerType = true;
        getContainerType({Container: this.searchValueContainerType})
            .then(result => {
                this.sideRecordsContainerType = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsContainerType = null;
            });
    }
    else{
        this.showSideContainerType = false;
    }
}

// buscador Clave de unidad de peso
SideSelectClaveUnidadPeso(event){
    this.searchValueClaveUnidadPeso = event.target.outerText;
    this.showSideClaveUnidadPeso = false;
    this.searchValueIdClaveUnidadPeso = event.currentTarget.dataset.id
    this.wrapperFolio.recordTypeUnidad = event.currentTarget.dataset.id
}

handleCleanClaveUnidadPeso(event){
    if (!event.target.value.length) {
        this.cleanClaveUnidadPeso()
    }
}



searchKeyClaveUnidadPeso(event){
    this.searchValueClaveUnidadPeso = event.target.value;
    this.searchValueIdClaveUnidadPeso='';
    if (this.searchValueClaveUnidadPeso.length >= 3) {
        this.showSideClaveUnidadPeso = true;
        getClaveSAT({sat: this.searchValueClaveUnidadPeso,record: '4'})
            .then(result => {
                this.sideRecordsClaveUnidadPeso = result;
            })
            .catch(error => {
                this.pushMessage('Error','error', error.body.message);
                this.sideRecordsClaveUnidadPeso = null;
            });
    }
    else{
        this.showSideClaveUnidadPeso = false;
    }
}  

registroDescripcionProducto(event){
    this.wrapperCargoLine.description = event.target.value;
    this.Descripcionproducto = event.target.value;
}
registroUnits(event){
    this.wrapperCargoLine.units = event.target.value;
    this.units = event.target.value;
}
registroPesoBruto(event){
    this.wrapperCargoLine.pesoBruto = event.target.value;
    this.pesoBruto = event.target.value;
}
registroPesoNeto(event){
    this.wrapperCargoLine.pesoNeto = event.target.value;
    this.pesoNeto = event.target.value;
} 
registroCurrency(event){
    this.wrapperCargoLine.currencyIsoCode = event.target.value;
    this.currency = event.target.value;
}
registroItemPrice(event){
    this.wrapperCargoLine.itemPrice = event.target.value;
    this.itemPrice = event.target.value;
}
registroTotalShippingVolume(event){
    this.wrapperCargoLine.totalShipping = event.target.value;
    this.totalShipping = event.target.value;
}
abrirCargoLine(){
    this.isGeneFolio = false;
    this.isCargoLine = true;
    
    this.searchValueEmbalaje = null;
    this.searchValueMaterialPeligroso = null;
    this.searchValueClaveServicio = null;
}
Regresar(){
    this.isGeneFolio = true;
    this.isCargoLine = false;
}
agregarCargoLine(){
    this.isCargoLine = false;
    this.isGeneFolio = true;
    creaCargoLine({listaFolio: this.listaFolios, cargoLine: this.wrapperCargoLine})
    this.cleanClaveUnidadPeso()
    .then(result => {
        this.creaCargoLine = result;
        if(result!==null){
            this.pushMessage('Exitoso!', 'success', 'Cargo line agregada con exito!');
            return refreshApex(this.listCargoLine);
        }
        else{
            this.pushMessage('Error', 'error', 'Error al Crear Cargo Line, Consulte a su Administrador');
            this.isF_NACIONAL = true;
        }
    })
}
openCargaMasiva(){
    this.carga = true;
}

    handleFileChange(event) {
        this.csvFile = event.target.files[0];
        this.fileName = event.target.files[0].name;
    }

    get showUploadButton() {
        return this.csvFile != null;
    }

    handleUploadClick() {
        let reader = new FileReader();
        reader.onload = (event) => {
            let fileContents = event.target.result;
            fileProcess({ csvFileBody: fileContents })
                .then((result) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'CSV file processed successfully.',
                            variant: 'success'
                        })
                    );
                    this.csvFile = null;
                })
                .catch((error) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        };
        reader.readAsText(this.csvFile);
    }
}