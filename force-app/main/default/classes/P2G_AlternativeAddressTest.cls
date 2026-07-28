@isTest
public class P2G_AlternativeAddressTest {
    
    @isTest(SeeAllData=true)
    private static void getAddressByIdTest(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null ORDER BY CreatedDate DESC LIMIT 1];  
        Account_Address__c addressOrigen = P2G_AlternativeAddress.getAddressById(shipment.Account_Origin_Address__c);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByIdTest_NullId(){
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressById(null);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByIdTest_EmptyId(){
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressById('');
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByIdTest_InvalidId(){
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressById('001XXXXXXXXXXXXXXX');
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest(){        
        Shipment__c shipment = [SELECT Id, Name, Account_Origin_Address__c, Account_Origin_Address__r.Name,
                              Account_Destination_Address__c, Account_Destination_Address__r.Name FROM Shipment__c 
                              WHERE Account_Origin_Address__r.Name like '%Kimberly%' 
                              OR Account_Destination_Address__r.Name like '%Kimberly%' LIMIT 1]; 
        
        if(shipment.Account_Origin_Address__r.Name.contains('Kimberly')){
            Account_Address__c addressOrigen = [SELECT Id, Name FROM Account_Address__c WHERE Id = :shipment.Account_Origin_Address__c];
            Account_Address__c newAddressOrigen = P2G_AlternativeAddress.getAddressByName(addressOrigen);   
        }
        if(shipment.Account_Destination_Address__r.Name.contains('Kimberly')){
            Account_Address__c addressDestination = [SELECT Id, Name FROM Account_Address__c WHERE Id = :shipment.Account_Destination_Address__c];
            Account_Address__c newAddressDestination = P2G_AlternativeAddress.getAddressByName(addressDestination);   
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_NullAddress(){
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(null);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_AddressWithNullName(){
        Account_Address__c testAddress = new Account_Address__c(Name = null);
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(testAddress);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_AddressWithEmptyName(){
        Account_Address__c testAddress = new Account_Address__c(Name = '');
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(testAddress);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_NonExistingAddress(){
        Account_Address__c testAddress = new Account_Address__c(Name = 'NonExistingAddress12345');
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(testAddress);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_ValidAddressWithoutKimberly(){
        List<Account_Address__c> addresses = [SELECT Id, Name FROM Account_Address__c 
                                            WHERE Name != null AND Name != '' 
                                            AND  (NOT NAME  LIKE '%KIMBERLY%') 
                                            LIMIT 1];
        
        if(!addresses.isEmpty()){
            Account_Address__c testAddress = addresses[0];
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(testAddress);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_AddressWithKimberlyPrefix(){
        List<Account_Address__c> addresses = [SELECT Id, Name FROM Account_Address__c 
                                            WHERE Name LIKE 'KIMBERLY%' 
                                            LIMIT 1];
        
        if(!addresses.isEmpty()){
            Account_Address__c testAddress = addresses[0];
            Account_Address__c addressWithoutKimberly = new Account_Address__c(
                Id = testAddress.Id,
                Name = testAddress.Name.remove('KIMBERLY ')
            );
            
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(addressWithoutKimberly);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByIdTest_VerifyAllFields(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Origin_Address__r.Calle_cat__c != null
                              AND Account_Origin_Address__r.Numero_Ext_cp__c != null
                              AND Account_Origin_Address__r.Codigo_Postal_CP__c != null
                              AND Account_Origin_Address__r.Colonia_cp__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        if(shipment != null){
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressById(shipment.Account_Origin_Address__c);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_VerifyAllFields(){
        List<Account_Address__c> addresses = [SELECT Id, Name FROM Account_Address__c 
                                            WHERE Name LIKE 'KIMBERLY%' 
                                            AND Calle_cat__c != null
                                            AND Numero_Ext_cp__c != null
                                            AND Codigo_Postal_CP__c != null
                                            AND Colonia_cp__c != null
                                            LIMIT 1];
        
        if(!addresses.isEmpty()){
            Account_Address__c testAddress = addresses[0];
            Account_Address__c addressWithoutKimberly = new Account_Address__c(
                Id = testAddress.Id,
                Name = testAddress.Name.remove('KIMBERLY ')
            );
            
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(addressWithoutKimberly);
        }
    }
    
    // NUEVOS MÉTODOS DE TEST PARA CUBRIR ESCENARIOS FALTANTES
    
    @isTest(SeeAllData=true)
    private static void getAddressLWC_Test(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null ORDER BY CreatedDate DESC LIMIT 1];  
        Account_Address__c result = P2G_AlternativeAddress.getAddressLWC(shipment.Account_Origin_Address__c);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressLWC_Test_NullId(){
        Account_Address__c result = P2G_AlternativeAddress.getAddressLWC(null);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressLWC_Test_EmptyId(){
        Account_Address__c result = P2G_AlternativeAddress.getAddressLWC('');
    }
    
    
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_OriginOnly(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, false, true);
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_DestinationOnly(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, true, false);
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_BothAddresses(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, false, false);
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_ValidAddresses(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, true, true);
    }
    /*
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_OriginAddressNotFound(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        // Forzar escenario donde no se encuentra dirección de origen
        shipment.Account_Origin_Address__c = 'a0BXXXXXXXXXXXXXXX';
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, false, true);
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_DestinationAddressNotFound(){
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        // Forzar escenario donde no se encuentra dirección de destino
        shipment.Account_Destination_Address__c = 'a0BXXXXXXXXXXXXXXX';
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, true, false);
    }
    */
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_WithCreatedDateFilter(){
        List<Account_Address__c> addresses = [SELECT Id, Name FROM Account_Address__c 
                                            WHERE Name != null AND Name != '' 
                                            AND CreatedDate > 2024-11-01T00:00:00Z
                                            LIMIT 1];
        
        if(!addresses.isEmpty()){
            Account_Address__c testAddress = addresses[0];
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(testAddress);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_WithStatusAndActiveConditions(){
        List<Account_Address__c> addresses = [SELECT Id, Name FROM Account_Address__c 
                                            WHERE Name LIKE 'KIMBERLY%' 
                                            AND status__c = 'Validado'
                                            AND Active__c = true
                                            LIMIT 1];
        
        if(!addresses.isEmpty()){
            Account_Address__c testAddress = addresses[0];
            Account_Address__c addressWithoutKimberly = new Account_Address__c(
                Id = testAddress.Id,
                Name = testAddress.Name.remove('KIMBERLY ')
            );
            
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(addressWithoutKimberly);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_QueryExceptionScenario(){
        // Este test cubre el escenario donde ocurre una QueryException
        Account_Address__c testAddress = new Account_Address__c(Name = 'Test Address');
        Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(testAddress);
    }
    /*
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_BothAddressesNotFound(){
        Shipment__c shipment = [SELECT Id FROM Shipment__c ORDER BY CreatedDate DESC LIMIT 1];  
        
        // Forzar escenario donde ambas direcciones no existen
        shipment.Account_Origin_Address__c = 'a0BXXXXXXXXXXXXXXX';
        shipment.Account_Destination_Address__c = 'a0BYYYYYYYYYYYYYY';
        
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, false, false);
    }
    */
    @isTest(SeeAllData=true)
    private static void getAddressLWC_Test_WithValidKimberlyAddress(){
        List<Account_Address__c> addresses = [SELECT Id FROM Account_Address__c 
                                            WHERE Name LIKE 'KIMBERLY%' 
                                            AND status__c = 'Validado'
                                            AND Active__c = true
                                            LIMIT 1];
        
        if(!addresses.isEmpty()){
            Account_Address__c result = P2G_AlternativeAddress.getAddressLWC(addresses[0].Id);
        }
    }
    
     @isTest(SeeAllData=true)
    private static void getAddressDetails_Test_BothAddresses() {
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                              FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              AND Account_Destination_Address__c != null
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        List<P2G_AlternativeAddress.AddressWrapper> result = 
            P2G_AlternativeAddress.getAddressDetails(shipment.Account_Origin_Address__c, shipment.Account_Destination_Address__c);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressDetails_Test_OriginOnly() {
        Shipment__c shipment = [SELECT Id, Account_Origin_Address__c FROM Shipment__c 
                              WHERE Account_Origin_Address__c != null 
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        List<P2G_AlternativeAddress.AddressWrapper> result = 
            P2G_AlternativeAddress.getAddressDetails(shipment.Account_Origin_Address__c, null);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressDetails_Test_DestinationOnly() {
        Shipment__c shipment = [SELECT Id, Account_Destination_Address__c FROM Shipment__c 
                              WHERE Account_Destination_Address__c != null 
                              ORDER BY CreatedDate DESC LIMIT 1];  
        
        List<P2G_AlternativeAddress.AddressWrapper> result = 
            P2G_AlternativeAddress.getAddressDetails(null, shipment.Account_Destination_Address__c);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressDetails_Test_BothNull() {
        List<P2G_AlternativeAddress.AddressWrapper> result = 
            P2G_AlternativeAddress.getAddressDetails(null, null);
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressDetails_Test_WithInvalidAddresses() {
        List<P2G_AlternativeAddress.AddressWrapper> result = 
            P2G_AlternativeAddress.getAddressDetails('001XXXXXXXXXXXXXXX', '001YYYYYYYYYYYYYYY');
    }
    
    @isTest(SeeAllData=true)
    private static void updateDireccionAlternativa_Test_Success() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c ORDER BY CreatedDate DESC LIMIT 1];  
        
        Test.startTest();
        P2G_AlternativeAddress.updateDireccionAlternativa(shipment.Id, 'Nuevo Valor');
        Test.stopTest();
        
        // Verificar que se actualizó correctamente
        Shipment__c updatedShipment = [SELECT Id, Direccion_Alternativa__c FROM Shipment__c WHERE Id = :shipment.Id];
        System.assertEquals('Nuevo Valor', updatedShipment.Direccion_Alternativa__c);
    }
    
    @isTest(SeeAllData=true)
    private static void updateDireccionAlternativa_Test_Exception() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            P2G_AlternativeAddress.updateDireccionAlternativa('invalid_id', 'Nuevo Valor');
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'Se esperaba una excepción AuraHandledException');
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_OriginAlternativeFound() {
        // Buscar un shipment donde exista una alternativa para la dirección de origen
        List<Shipment__c> shipments = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                                     FROM Shipment__c 
                                     WHERE Account_Origin_Address__c != null 
                                     AND Account_Destination_Address__c != null
                                     ORDER BY CreatedDate DESC LIMIT 1];  
        
        if(!shipments.isEmpty()) {
            Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipments[0], false, true);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_DestinationAlternativeFound() {
        // Buscar un shipment donde exista una alternativa para la dirección de destino
        List<Shipment__c> shipments = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                                     FROM Shipment__c 
                                     WHERE Account_Origin_Address__c != null 
                                     AND Account_Destination_Address__c != null
                                     ORDER BY CreatedDate DESC LIMIT 1];  
        
        if(!shipments.isEmpty()) {
            Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipments[0], true, false);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_BothAlternativesFound() {
        // Buscar un shipment donde existan alternativas para ambas direcciones
        List<Shipment__c> shipments = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c 
                                     FROM Shipment__c 
                                     WHERE Account_Origin_Address__c != null 
                                     AND Account_Destination_Address__c != null
                                     ORDER BY CreatedDate DESC LIMIT 1];  
        
        if(!shipments.isEmpty()) {
            Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipments[0], false, false);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressLWC_Test_WithAlternativeAddress() {
        // Buscar una dirección que tenga una alternativa válida
        List<Account_Address__c> addresses = [SELECT Id FROM Account_Address__c 
                                            WHERE Name != null 
                                            AND Name != ''
                                            AND Id IN (SELECT Account_Origin_Address__c FROM Shipment__c)
                                            LIMIT 1];
        
        if(!addresses.isEmpty()) {
            Account_Address__c result = P2G_AlternativeAddress.getAddressLWC(addresses[0].Id);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressLWC_Test_WithoutAlternativeAddress() {
        // Buscar una dirección que NO tenga alternativa
        List<Account_Address__c> addresses = [SELECT Id FROM Account_Address__c 
                                            WHERE Name != null 
                                            AND Name != ''
                                            AND (NOT Name LIKE 'KIMBERLY%')
                                            LIMIT 1];
        
        if(!addresses.isEmpty()) {
            Account_Address__c result = P2G_AlternativeAddress.getAddressLWC(addresses[0].Id);
        }
    }
    
    @isTest(SeeAllData=true)
    private static void getAddressByNameTest_WithAllRelationshipFields() {
        // Buscar una dirección Kimberly que tenga todos los campos de relación poblados
        List<Account_Address__c> addresses = [SELECT Id, Name FROM Account_Address__c 
                                            WHERE Name LIKE 'KIMBERLY%' 
                                            AND Colonia_cp__r.Clave_SAT__c != null
                                            AND Codigo_Postal_CP__r.Localidad_Ref_CP__c != null
                                            AND Codigo_Postal_CP__r.Municipio_Ref_CP__c != null
                                            AND Codigo_Postal_CP__r.Pais_RefCP__c != null
                                            LIMIT 1];
        
        if(!addresses.isEmpty()) {
            Account_Address__c testAddress = addresses[0];
            Account_Address__c addressWithoutKimberly = new Account_Address__c(
                Id = testAddress.Id,
                Name = testAddress.Name.remove('KIMBERLY ')
            );
            
            Account_Address__c addressResult = P2G_AlternativeAddress.getAddressByName(addressWithoutKimberly);
        }
    }
    /*
    @isTest(SeeAllData=true)
    private static void updateAddresses_Test_WithApexPagesMessages() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c ORDER BY CreatedDate DESC LIMIT 1];  
        
        // Forzar escenario donde no se encuentran alternativas para ninguna dirección
        shipment.Account_Origin_Address__c = 'a0BXXXXXXXXXXXXXXX';
        shipment.Account_Destination_Address__c = 'a0BYYYYYYYYYYYYYY';
        
        Map<String, String> result = P2G_AlternativeAddress.updateAddresses(shipment, false, false);
        
        // Verificar que se agregaron mensajes ApexPages (aunque en test no se pueden verificar directamente)
        System.assert(result != null);
    }
    */
    
}