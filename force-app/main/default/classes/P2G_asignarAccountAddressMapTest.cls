@isTest
public class P2G_asignarAccountAddressMapTest {
	@isTest(SeeAllData=true)
    static void claseTest(){
        List<Account_Address__c> ubicacion = [SELECT Id, Name, CalleEspejo__c, Numero_Ext_cp__c, Numero_Int_cat__c, CodigoPostalEspejo__c,
                                 CodigoPostalEspejo__r.Name, Colonia_espejo__c, Municipio_Cat2__c, LocalidadEspejo__r.Name, EstadoEspejo__r.Name,
                                 PaisEspejo__r.Name, Folio_Origen_Destino2__c,Address_Coordinates__Latitude__s,Address_Coordinates__Longitude__s,
                                 EstadoEspejo__r.Clave_SAT__c, status__c, Codigo_Postal_CP__c
                                 FROM Account_Address__c WHERE status__c = 'Validado' OR status__c = 'Pendiente'];
        Customer_Quote__c direccion = [SELECT id, Account_Origin_Address__c, Account_Origin_Address__r.Name, Account_Origin_Address__r.CodigoPostalEspejo__c,
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
                                 FROM Customer_Quote__c WHERE Account_for__r.Name LIKE: '%ejemplo%' LIMIT 1];
        P2G_asignarAccountAddressMap.address address = new P2G_asignarAccountAddressMap.address();
        list<Catalogo_SAT__c> getcp = P2G_asignarAccountAddressMap.getCP('93340');
        list<P2G_asignarAccountAddressMap.address> getBuscaAddress = P2G_asignarAccountAddressMap.getBuscaAddress(ubicacion[0].Name, '', '');
        list<P2G_asignarAccountAddressMap.address> getBuscaAddressSite = P2G_asignarAccountAddressMap.getBuscaAddress('','Monterrey', '');
        list<P2G_asignarAccountAddressMap.address> getBuscaAddressCP = P2G_asignarAccountAddressMap.getBuscaAddress('', '', ubicacion[0].Codigo_Postal_CP__c);
		list<P2G_asignarAccountAddressMap.address> llenarAddress = P2G_asignarAccountAddressMap.llenarAddress(ubicacion);
        Location__c seleccionLocacion = P2G_asignarAccountAddressMap.seleccionLocacion(ubicacion[0].Municipio_Cat2__c, 'Veracruz', 'Veracruz', ubicacion[0].EstadoEspejo__r.Clave_SAT__c);
        P2G_asignarAccountAddressMap.getAddressWrapper getAddress = P2G_asignarAccountAddressMap.getAddress(direccion.Id);
        P2G_asignarAccountAddressMap.getAddressWrapper llenarGetAddress = P2G_asignarAccountAddressMap.llenarGetAddress(direccion);
        String quitarAcentos = P2G_asignarAccountAddressMap.quitarAcentos('cadená');
    }
}