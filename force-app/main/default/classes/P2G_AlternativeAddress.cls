public class P2G_AlternativeAddress {
    
    public class AddressWrapper {
        @AuraEnabled public String nombre { get; set; }
        @AuraEnabled public String calle { get; set; }
        @AuraEnabled public String numeroExt { get; set; }
        @AuraEnabled public String colonia { get; set; }
        @AuraEnabled public String codigoPostal { get; set; }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<AddressWrapper> getAddressDetails(String originId, String destinationId) {
        List<AddressWrapper> result = new List<AddressWrapper>();
        
        // ORIGEN
        Account_Address__c ori = getAddressLWC(originId);
        result.add(buildWrapper(ori));
        
        // DESTINO
        Account_Address__c dest = getAddressLWC(destinationId);
        result.add(buildWrapper(dest));
        
        return result;
    }
    
    private static AddressWrapper buildWrapper(Account_Address__c addr) {
        AddressWrapper wrapper = new AddressWrapper();
        if (addr == null){
            return wrapper;            
        } 
        
        wrapper.nombre = addr.Name != null ? addr.Name : '';
        wrapper.calle = addr.Calle_cat__c != null ? addr.Calle_cat__c : '';
        wrapper.numeroExt = addr.Numero_Ext_cp__c != null ? addr.Numero_Ext_cp__c : '';
        wrapper.colonia = addr.Colonia_cp__r?.Name != null ? addr.Colonia_cp__r.Name : '';
        wrapper.codigoPostal = addr.Codigo_Postal_CP__r?.Name != null ? addr.Codigo_Postal_CP__r.Name : '';
        
        return wrapper;
    }
    
    @AuraEnabled
    public static void updateDireccionAlternativa(String shipmentId, String nuevoValor) {
        try {
            update new Shipment__c(
                Id = shipmentId,
                Direccion_Alternativa__c = nuevoValor
            );
        } catch (Exception e) {
            throw new AuraHandledException('Error al actualizar: ' + e.getMessage());
        }
    }
    
    public static Account_Address__c getAddressById(String addressId) {
        if (String.isBlank(addressId)) return null;
        
        try {
            return [
                SELECT Id, Name, Address__c, Calle_cat__c, Numero_Ext_cp__c,
                       Codigo_Postal_CP__c, Codigo_Postal_CP__r.Name,
                       Colonia_cp__c, Colonia_cp__r.Name,
                       Localidad_Cp__c, Localidad_Cp__r.Name,
                       Estado_cat__c, Estado_cat__r.Name
                FROM Account_Address__c 
                WHERE Id = :addressId 
                LIMIT 1
            ];
        } catch (QueryException e) {
            System.debug('No se encontró dirección con ID ' + addressId);
            return null;
        }
    }
    
    public static Account_Address__c getAddressByName(Account_Address__c address) {
        if (address == null || String.isBlank(address.Name)) return null;
        
        try {            
            String originalName = address.Name;
            String searchName ='KIMBERLY '+ originalName;			
            
            System.debug('Buscando alternativa para: ' + originalName);
            System.debug('Nombre de búsqueda: ' + searchName);
            
            List<Account_Address__c> alternatives = [
                SELECT Id, Name, Address__c, Direcci_n__c, Calle_cat__c, Numero_Ext_cp__c,
                       Numero_Int_cat__c, Colonia_cp__c, Colonia_cp__r.Name, Colonia_cp__r.Clave_SAT__c,                                         	
                       Codigo_Postal_CP__r.Localidad_Ref_CP__c, 
                       Codigo_Postal_CP__r.Localidad_Ref_CP__r.Name, Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c, 
                       Codigo_Postal_CP__r.Municipio_Ref_CP__r.Name, Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                       Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                       Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                       Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Name, Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                       Codigo_Postal_CP__r.Pais_RefCP__r.Name, Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                       Codigo_Postal_CP__r.Pais_RefCP__c,                                             
                       Codigo_Postal_CP__c,
                       Codigo_Postal_CP__r.Name,
                       Referencia__c,
                       Folio_Origen_Destino2__c,
                       Address_Coordinates__latitude__s,
                       Address_Coordinates__longitude__s,
                       Localidad_Cp__c, Localidad_Cp__r.Name,
                       Estado_cat__c, Estado_cat__r.Name
                FROM Account_Address__c 
                WHERE Name LIKE : (searchName + '%')
                AND Status__c = 'Validado'
                AND CreatedDate > 2024-11-01T00:00:00Z 
                AND Id != :address.Id
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            
            System.debug('Alternativas encontradas: ' + alternatives.size());
            if (!alternatives.isEmpty()) {
                System.debug('Alternativa encontrada: ' + alternatives[0].Name);
                return alternatives[0];
            }
            
            return null;
        } catch (Exception e) {
            System.debug('Error buscando alternativa: ' + e.getMessage() + ' - ' + e.getStackTraceString());
            return null;
        }
    }
    
    @AuraEnabled
    public static Account_Address__c getAddressLWC(String addressId){
        if (String.isBlank(addressId)){
            return null;
        }
        
        Account_Address__c original = getAddressById(addressId);
        
        if (original == null){
            return null;
        }
        
        Account_Address__c alternative = getAddressByName(original);        
        return alternative != null ? alternative : original;
    }
    
    
    public static Map<String,String> updateAddresses(Shipment__c shipment, Boolean useAlternativeOrigin, Boolean useAlternativeDestination) {
        
        Map<String, String> addressUpdates = new Map<String, String>();
        
        // ORIGEN
        Account_Address__c origin = getAddressById(shipment.Account_Origin_Address__c);
                        
        if (useAlternativeOrigin && origin != null) {
            Account_Address__c altOrigin = getAddressByName(origin);
            addressUpdates.put('origen', altOrigin != null ? altOrigin.Id : origin.Id);
        } else {
            addressUpdates.put('origen', origin?.Id);
        }
                
        
        //Destino
		Account_Address__c destination = getAddressById(shipment.Account_Destination_Address__c);
                
        if (useAlternativeDestination && destination != null) {
            Account_Address__c altDest = getAddressByName(destination);
            addressUpdates.put('destino', altDest != null ? altDest.Id : destination.Id);
        } else {
            addressUpdates.put('destino', destination?.Id);
        }
        
        System.debug('Mapa de actualizaciones: ' + addressUpdates);
        return addressUpdates;
    }
}