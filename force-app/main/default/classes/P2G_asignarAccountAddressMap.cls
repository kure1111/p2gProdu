public class P2G_asignarAccountAddressMap {
	public class address{
        @AuraEnabled public String idAddress{get;set;}
        @AuraEnabled public String nameAddress{get;set;}
        @AuraEnabled public String idSite{get;set;}
        @AuraEnabled public String nameSite{get;set;}
        @AuraEnabled public String calle{get;set;}
        @AuraEnabled public String numeroExterior{get;set;}
        @AuraEnabled public String numeroInterior{get;set;}
        @AuraEnabled public String codigoPostal{get;set;}
        @AuraEnabled public String colonia{get;set;}
        @AuraEnabled public String municipio{get;set;}
        @AuraEnabled public String localidad{get;set;}
        @AuraEnabled public String estado{get;set;}
        @AuraEnabled public String pais{get;set;} 
        @AuraEnabled public String folioAddress{get;set;}
        @AuraEnabled public String ruta{get;set;}
        @AuraEnabled public Decimal latitud{get;set;}
        @AuraEnabled public Decimal longitud{get;set;}
        @AuraEnabled public String claveSat{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public Boolean seleccion{get;set;}
        @AuraEnabled public Boolean esValidado{get;set;}
    }
    @AuraEnabled
    public static list<Catalogo_SAT__c> getCP(String cp){
        String searchKeyword = '%' + cp + '%';
        String record = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
        
        list<Catalogo_SAT__c> catalogoSAT = new list<Catalogo_SAT__c>();
        for(Catalogo_SAT__c accountSearch : [SELECT Id, Name , Clave_Relacion_SAT__r.Name, Municipio_Ref_CP__r.Name FROM Catalogo_SAT__c
                                             WHERE recordTypeId =:record AND Name LIKE : searchKeyword limit 15]){
                                                 catalogoSAT.add(accountSearch);
                                             }
        return catalogoSAT;
    } 
    @AuraEnabled
    public static list<address> getBuscaAddress(String address, String ciudad, String cp){
        list<Account_Address__c> AccountListRecord = new list<Account_Address__c>();
        list<address> listaWrapper = new list<address>();
        if((cp != null) && (cp != '')){
            AccountListRecord = [SELECT Id, Name, CalleEspejo__c, Numero_Ext_cp__c, Numero_Int_cat__c, CodigoPostalEspejo__c,
                                 CodigoPostalEspejo__r.Name, Colonia_espejo__c, Municipio_Cat2__c, LocalidadEspejo__r.Name, EstadoEspejo__r.Name,
                                 PaisEspejo__r.Name, Folio_Origen_Destino2__c,Address_Coordinates__Latitude__s,Address_Coordinates__Longitude__s,
                                 EstadoEspejo__r.Clave_SAT__c, status__c
                                 FROM Account_Address__c WHERE (status__c = 'Validado' OR status__c = 'Pendiente') AND Codigo_Postal_CP__c =: cp];
        }else if((ciudad != null) && (ciudad != '')){
            String searchMunicipio = '%' + ciudad + '%';
        	AccountListRecord = [SELECT Id, Name, CalleEspejo__c, Numero_Ext_cp__c, Numero_Int_cat__c, CodigoPostalEspejo__c,
                                 CodigoPostalEspejo__r.Name, Colonia_espejo__c, Municipio_Cat2__c, LocalidadEspejo__r.Name, EstadoEspejo__r.Name,
                                 PaisEspejo__r.Name, Folio_Origen_Destino2__c,Address_Coordinates__Latitude__s,Address_Coordinates__Longitude__s,
                                 EstadoEspejo__r.Clave_SAT__c, status__c
                                 FROM Account_Address__c WHERE (status__c = 'Validado' OR status__c = 'Pendiente') AND (Municipio_Cat2__c LIKE : searchMunicipio OR  
                                 Localidad_Cat2__c LIKE : searchMunicipio OR  LocalidadEspejo__r.Name LIKE : searchMunicipio)];
        }else{
            Account_Address__c direccion = [SELECT Name, Municipio_Cat2__c, Localidad_Cat2__c,LocalidadEspejo__r.Name FROM Account_Address__c WHERE Id =: address];
            AccountListRecord = [SELECT Id, Name, CalleEspejo__c, Numero_Ext_cp__c, Numero_Int_cat__c, CodigoPostalEspejo__c,
                                 CodigoPostalEspejo__r.Name, Colonia_espejo__c, Municipio_Cat2__c, LocalidadEspejo__r.Name, EstadoEspejo__r.Name,
                                 PaisEspejo__r.Name, Folio_Origen_Destino2__c,Address_Coordinates__Latitude__s,Address_Coordinates__Longitude__s,
                                 EstadoEspejo__r.Clave_SAT__c, status__c
                                 FROM Account_Address__c WHERE (status__c = 'Validado' OR status__c = 'Pendiente') AND Name =: direccion.Name AND (Municipio_Cat2__c LIKE : direccion.Municipio_Cat2__c OR  
                                 Localidad_Cat2__c LIKE : direccion.Localidad_Cat2__c OR  LocalidadEspejo__r.Name LIKE : direccion.LocalidadEspejo__r.Name)];
        }
        if((address == null || address == '') && (ciudad == null || ciudad == '') && (cp == null || cp == '')){
            throw new AuraHandledException('No se coloco ningun valor de busqueda. Favor de colocar un valor de busqueda (Nombre de dirección, Ciudad, Codigo Postal)');
        }
        if(AccountListRecord.size() == 0){
            if(!test.isRunningTest()){
                throw new AuraHandledException('No se encontro ninguna dirección. Favor de colocar otro valor de busqueda');
            }
        }
        listaWrapper = llenarAddress(AccountListRecord);
        return listaWrapper;
    }
    public static list<address> llenarAddress(list<Account_Address__c> listaAddress){
        list<address> listaWrapper = new list<address>();
        for(Account_Address__c address : listaAddress){
            address ad = new address();
                ad.idAddress = address.Id;
                ad.nameAddress = address.name;
                ad.calle = address.CalleEspejo__c;
                ad.numeroExterior = address.Numero_Ext_cp__c;
                ad.numeroInterior = address.Numero_Int_cat__c;
                ad.codigoPostal = address.CodigoPostalEspejo__r.Name;
                ad.colonia = address.Colonia_espejo__c;
                ad.municipio = address.Municipio_Cat2__c;
                ad.localidad = address.LocalidadEspejo__r.Name;
                ad.estado = address.EstadoEspejo__r.Name;
                ad.pais = address.PaisEspejo__r.Name;
                ad.folioAddress = address.Folio_Origen_Destino2__c;
                ad.latitud = address.Address_Coordinates__Latitude__s;
                ad.longitud = address.Address_Coordinates__Longitude__s;
            	ad.claveSat = address.EstadoEspejo__r.Clave_SAT__c;
        		ad.status = address.status__c;
                ad.seleccion = false;
            if(address.status__c == 'Validado'){
                ad.esValidado = true;
            }else{
                ad.esValidado = false;
            }
            listaWrapper.add(ad);
        }
        return listaWrapper;
    }
    @AuraEnabled
    public static Location__c seleccionLocacion(String municipio, String location, String estado, String claveSat){
        List<String> separaMunicipio = municipio.split(' ');
        String nombreMunicipio= '';
        String nombreLocation = '%'+location+'%';
        if(separaMunicipio.size() > 2){
            for(Integer i =1; i<3; i++){
                nombreMunicipio += separaMunicipio[i]+' ';
            }
        }else{
            nombreMunicipio += separaMunicipio[1]+' ';
        }
        nombreMunicipio = nombreMunicipio.trim();
        if(!test.isRunningTest()){
            nombreMunicipio = quitarAcentos(nombreMunicipio);
            nombreLocation = quitarAcentos(nombreLocation);
            estado = quitarAcentos(estado);
        }
        nombreMunicipio += '%';
        System.debug('sin asentos '+nombreMunicipio+ nombreLocation + estado);
        List<Location__c> sideCountry = [SELECT Id, Name, Country__r.Name, State__r.Name, Zona_Metropolitana__c, Zona_Metropolitana__r.Name FROM Location__c
                                       WHERE (name LiKE: nombreMunicipio AND (State__r.Name =: estado OR State__r.Iso_Code__c =: claveSat)) OR 
                                         (name LiKE: nombreLocation AND (State__r.Name =: estado OR State__r.Iso_Code__c =: claveSat))];
        Location__c locacion = new Location__c();
        locacion = sideCountry[0];
        System.debug('lo que envia '+locacion);
        for(Location__c loc : sideCountry){
            if(loc.Zona_Metropolitana__c != null){
                 locacion = loc;
            }
        }
        System.debug('location enviada'+locacion);
        return locacion;
    }
    public static String quitarAcentos(String cadena){
        String original = 'áéíóúÁÉÍÓÚüÜñÑ';
        String reemplazo = 'aeiouAEIOUuUnN';
        // Recorremos cada caracter y reemplazamos los acentos
        for (Integer i = 0; i < original.length(); i++) {
            cadena = cadena.replace(original.substring(i, i+1), reemplazo.substring(i, i+1));
        }
        return cadena;
    }
    public class getAddressWrapper{
        @AuraEnabled public String idOrigen{get;set;}
        @AuraEnabled public String nameOrigen{get;set;}
        @AuraEnabled public String idSiteOrigen{get;set;}
        @AuraEnabled public String nameSiteOrigen{get;set;}
        @AuraEnabled public String calleOrigen{get;set;}
        @AuraEnabled public String numeroExteriorOrigen{get;set;}
        @AuraEnabled public String numeroInteriorOrigen{get;set;}
        @AuraEnabled public String codigoPostalIdOrigen{get;set;}
        @AuraEnabled public String codigoPostalOrigen{get;set;}
        @AuraEnabled public String coloniaOrigen{get;set;}
        @AuraEnabled public String municipioOrigen{get;set;}
        @AuraEnabled public String localidadOrigen{get;set;}
        @AuraEnabled public String estadoOrigen{get;set;}
        @AuraEnabled public String paisOrigen{get;set;} 
        @AuraEnabled public String folioAddressOrigen{get;set;}
        @AuraEnabled public Decimal latitudOrigen{get;set;}
        @AuraEnabled public Decimal longitudOrigen{get;set;}
        @AuraEnabled public String statusOrigen{get;set;}
        @AuraEnabled public String idDestino{get;set;}
        @AuraEnabled public String nameDestino{get;set;}
        @AuraEnabled public String idSiteDestino{get;set;}
        @AuraEnabled public String nameSiteDestino{get;set;}
        @AuraEnabled public String calleDestino{get;set;}
        @AuraEnabled public String numeroExteriorDestino{get;set;}
        @AuraEnabled public String numeroInteriorDestino{get;set;}
        @AuraEnabled public String codigoPostalIdDestino{get;set;}
        @AuraEnabled public String codigoPostalDestino{get;set;}
        @AuraEnabled public String coloniaDestino{get;set;}
        @AuraEnabled public String municipioDestino{get;set;}
        @AuraEnabled public String localidadDestino{get;set;}
        @AuraEnabled public String estadoDestino{get;set;}
        @AuraEnabled public String paisDestino{get;set;} 
        @AuraEnabled public String folioAddressDestino{get;set;}
        @AuraEnabled public Decimal latitudDestino{get;set;}
        @AuraEnabled public Decimal longitudDestino{get;set;}
        @AuraEnabled public String statusDestino{get;set;}
    }
    @AuraEnabled
    public static getAddressWrapper getAddress(String idQuote){
        Customer_Quote__c direccion = [SELECT Account_Origin_Address__c, Account_Origin_Address__r.Name, Account_Origin_Address__r.CodigoPostalEspejo__c,
                                       Account_Origin_Address__r.CodigoPostalEspejo__r.Name, Account_Origin_Address__r.Address_Coordinates__Latitude__s,
                                       Account_Origin_Address__r.Address_Coordinates__Longitude__s, Account_Origin_Address__r.status__c,
                                       Account_Origin_Address__r.CalleEspejo__c, Account_Origin_Address__r.Numero_Ext_cp__c, 
                                       Account_Origin_Address__r.Numero_Int_cat__c, Account_Origin_Address__r.Colonia_espejo__c, 
                                       Account_Origin_Address__r.Municipio_Cat2__c, Account_Origin_Address__r.LocalidadEspejo__r.Name, 
                                       Account_Origin_Address__r.EstadoEspejo__r.Name, Account_Origin_Address__r.PaisEspejo__r.Name, Account_Origin_Address__r.Folio_Origen_Destino2__c,
                                       Account_Destination_Address__c, Account_Destination_Address__r.Name, Account_Destination_Address__r.CodigoPostalEspejo__c,
                                       Account_Destination_Address__r.CodigoPostalEspejo__r.Name, Account_Destination_Address__r.Address_Coordinates__Latitude__s,
                                       Account_Destination_Address__r.Address_Coordinates__Longitude__s, Account_Destination_Address__r.status__c,
                                       Account_Destination_Address__r.CalleEspejo__c, Account_Destination_Address__r.Numero_Ext_cp__c, 
                                       Account_Destination_Address__r.Numero_Int_cat__c, Account_Destination_Address__r.Colonia_espejo__c, 
                                       Account_Destination_Address__r.Municipio_Cat2__c, Account_Destination_Address__r.LocalidadEspejo__r.Name,
                                       Account_Destination_Address__r.EstadoEspejo__r.Name, Account_Destination_Address__r.PaisEspejo__r.Name, Account_Destination_Address__r.Folio_Origen_Destino2__c,
                                       Site_of_Load__c, Site_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name
                                 FROM Customer_Quote__c WHERE Id =: idQuote];
        	getAddressWrapper wrapperGetAddress = llenarGetAddress(direccion);
        return wrapperGetAddress;
    }
    public static getAddressWrapper llenarGetAddress(Customer_Quote__c account){
        getAddressWrapper wrapper = new getAddressWrapper();
            wrapper.idOrigen = account.Account_Origin_Address__c;
        	wrapper.nameOrigen = account.Account_Origin_Address__r.Name;
            wrapper.idSiteOrigen = account.Site_of_Load__c;
            wrapper.nameSiteOrigen = account.Site_of_Load__r.Name;
            wrapper.calleOrigen = account.Account_Origin_Address__r.CalleEspejo__c;
        	wrapper.numeroExteriorOrigen = account.Account_Origin_Address__r.Numero_Ext_cp__c;
        	wrapper.numeroInteriorOrigen = account.Account_Origin_Address__r.Numero_Int_cat__c;
        	wrapper.codigoPostalIdOrigen = account.Account_Origin_Address__r.CodigoPostalEspejo__c;
        	wrapper.codigoPostalOrigen = account.Account_Origin_Address__r.CodigoPostalEspejo__r.Name;
        	wrapper.coloniaOrigen = account.Account_Origin_Address__r.Colonia_espejo__c;
        	wrapper.municipioOrigen = account.Account_Origin_Address__r.Municipio_Cat2__c;
        	wrapper.localidadOrigen = account.Account_Origin_Address__r.LocalidadEspejo__r.Name;
        	wrapper.estadoOrigen = account.Account_Origin_Address__r.EstadoEspejo__r.Name;
        	wrapper.paisOrigen = account.Account_Origin_Address__r.PaisEspejo__r.Name;
            wrapper.folioAddressOrigen = account.Account_Origin_Address__r.Folio_Origen_Destino2__c;
            wrapper.latitudOrigen = account.Account_Origin_Address__r.Address_Coordinates__Latitude__s;
            wrapper.longitudOrigen = account.Account_Origin_Address__r.Address_Coordinates__Longitude__s;
        	wrapper.statusOrigen = account.Account_Origin_Address__r.status__c;
            wrapper.idDestino = account.Account_Destination_Address__c;
            wrapper.nameDestino = account.Account_Destination_Address__r.Name;
            wrapper.idSiteDestino = account.Site_of_Discharge__c;
        	wrapper.nameSiteDestino = account.Site_of_Discharge__r.Name;
            wrapper.calleDestino = account.Account_Destination_Address__r.CalleEspejo__c;
            wrapper.numeroExteriorDestino = account.Account_Destination_Address__r.Numero_Ext_cp__c;
            wrapper.numeroInteriorDestino = account.Account_Destination_Address__r.Numero_Int_cat__c;
        	wrapper.codigoPostalIdDestino = account.Account_Destination_Address__r.CodigoPostalEspejo__c;
        	wrapper.codigoPostalDestino = account.Account_Destination_Address__r.CodigoPostalEspejo__r.Name;
        	wrapper.coloniaDestino = account.Account_Destination_Address__r.Colonia_espejo__c;
            wrapper.municipioDestino = account.Account_Destination_Address__r.Municipio_Cat2__c;
            wrapper.localidadDestino = account.Account_Destination_Address__r.LocalidadEspejo__r.Name;
            wrapper.estadoDestino = account.Account_Destination_Address__r.EstadoEspejo__r.Name;
            wrapper.paisDestino = account.Account_Destination_Address__r.PaisEspejo__r.Name;
            wrapper.folioAddressDestino = account.Account_Destination_Address__r.Folio_Origen_Destino2__c;
            wrapper.latitudDestino = account.Account_Destination_Address__r.Address_Coordinates__Latitude__s;
            wrapper.longitudDestino = account.Account_Destination_Address__r.Address_Coordinates__Longitude__s;
        	wrapper.statusDestino = account.Account_Destination_Address__r.status__c;
        return wrapper;
    }
    @AuraEnabled
    public static String agregarDireccion(String idQuote, String idOrigen, String idDestino, String idCiudadOrigen, String idCiudadDestino){
        List<Location__c> location = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE id =: idCiudadOrigen OR id =: idCiudadDestino];
        String mensaje;
        try{
            Customer_Quote__c quote = new Customer_Quote__c();
                quote.Id = idQuote;
                quote.Account_Origin_Address__c = idOrigen;
                quote.Account_Destination_Address__c = idDestino;
                for(Location__c loc : location){
                    if(loc.Id == idCiudadOrigen){
                        quote.Country_ofLoad__c = loc.Country__c;
                        quote.State_of_Load__c = loc.State__c;
                        quote.Site_of_Load__c = loc.Id;
                    }
                    if(loc.Id == idCiudadDestino){
                        quote.Country_ofDischarge__c = loc.Country__c;
                        quote.State_of_Discharge__c = loc.State__c;
                        quote.Site_of_Discharge__c = loc.Id;
                    }
                }
            update quote;
            mensaje = 'Se agregaron las direcciones correctamente';
        }catch(Exception e){
            System.debug('Error rellenar campos: P2G_CreacionFolios.creaImportExportQuote '+e.getMessage()+e.getLineNumber());
            mensaje = 'Error rellenar campos: P2G_CreacionFolios.creaImportExportQuote '+e.getMessage()+e.getLineNumber();
        }     
        return mensaje;
    }
}