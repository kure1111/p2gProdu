/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_See_Vessel_Shipments {

     static testMethod void test_See_Vessel_Shipment() {
          NEU_StaticVariableHelper.setBoolean1(true);
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');    
      Account a = list_accounts[0];
      insert a;
      Account sup = list_accounts[1];
      insert sup;
      Country__c country = new Country__c(ISO_Code__c='test');
      insert country;
      Location__c location = new Location__c(City__c='test city',Country__c=country.id,Subdivision__c='test subdivision', UNLOCODE__c='test');
      insert location;
      Carrier_Line_Load_Point__c ruta = new Carrier_Line_Load_Point__c(Name='test routa', Country_of_Discharge__c=country.Id,Country_of_Load__c=country.Id,Port_Airport_of_Discharge__c=location.Id,Port_Airport_of_Load__c=location.Id);
      insert ruta;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c = '9392561', Vessel_Information__c='information vessel' , Vessel_Activities__c= 'vessel activities', Country_of_Discharge__c= country.Id , Country_of_Load__c = country.Id, Port_Of_Loading__c ='test port of loading', Port_Of_Discharging__c='test port of discharging' , Route__c =ruta.Id, Only_Warehouse_Service__c = true);
      insert ship;
      List<Shipment__c> shipments = new List<Shipment__c>();
      shipments = [select Id, Name, Route__c, Country_of_Load__c, Truck_Vessel_Flight_ETD__c, Truck_Vessel_Flight_ETA__c,  ATAPOD__c , Last_Activity__c, 
      Country_of_Discharge__c, Route__r.Name, Date__c, Location__c, ETD__c,
      Truck_Vessel_Latitude__c, Truck_Vessel_Longitude__c, Vessel_Speed__c, Vessel_Course__c, Imo_Number__c, Vessel_Information__c, Vessel_Activities__c, Vessel_Name__c, MMSI__c, ETA_ATA__c, Port_Of_Loading__c, Port_Of_Discharging__c  from Shipment__c where id =: ship.Id ];
     
      ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(shipments);
      NEU_See_Vessel_Shipments uda = new NEU_See_Vessel_Shipments(stdController);
      uda.ship = shipments;
      uda.getTrackAndTrace();
      uda.getbyvessel();
      uda.Id_shipment_consulta = ship.Id;
      uda.getByIMO('9392561',0);
      uda.Id_shipment_consulta_activities = ship.Id;
      uda.getactivities();
      uda.guardar_cambios();
      uda.getinformation();
     }
  
}