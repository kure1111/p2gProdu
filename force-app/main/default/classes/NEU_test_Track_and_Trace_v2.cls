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
private class NEU_test_Track_and_Trace_v2 {

  static testMethod void test_NEU_OM_Track_and_Trace() {
  	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');  
      Account a = list_accounts[0];
      insert a;
      Account sup = list_accounts[1];
      insert sup;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
      insert supplyproject;
      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
      insert suprequest;
      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
      insert supquote;
      Vessel_Flight__c v=new Vessel_Flight__c(Name='1202');
      insert v;
      Shipment_Program__c sp=new Shipment_Program__c();
      insert sp;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10',Truck_Vessel_Flight__c=v.id,Inbound_Consolidation_Program__c=sp.id, Only_Warehouse_Service__c = true);
      insert ship;
      ship.Truck_Vessel_Flight__r=v;
      Shipment__c ships = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10',Truck_Vessel_Flight__c=v.id,Inbound_Consolidation_Program__c=sp.id, Only_Warehouse_Service__c = true);
      insert ships;
      NEU_Track_and_Trace uda = new NEU_Track_and_Trace(new ApexPages.StandardController( ship ));
      uda.getoperators();
      uda.gettrackoptions_selected();
      uda.getTrackAndTrace();
      uda.gettrackoptions();
      uda.getoperators_selected();
      uda.registerOI();
      uda.settrackoptions_selected('b_id');
      uda.registerOI();
      uda.setoperators_selected('MAEU');
      uda.registerOI();
      uda.registerOI();
      List<NEU_Track_and_Trace.Milestone_s> m=uda.milestones;
      List<NEU_Track_and_Trace.Status_s> s=uda.processstatus;
      ship.Date__c=null;
      uda.registerOI();
      uda.updatevessel();
      uda.record.Truck_Vessel_Flight__r.IMO__c=null;
      uda.record.Truck_Vessel_Flight__r.MMSI__c='MMSI';
      uda.updatevessel();
      uda.record.Truck_Vessel_Flight__r.IMO__c='IMO';
      uda.updatevessel();
      uda.getByVesselFinder('IMO');
      uda.getByMarineTraffic('IMO');
      uda.showVesselInformation();
      //uda.updateGraph();
      NEU_Track_and_Trace.Milestone_s ttm = new NEU_Track_and_Trace.Milestone_s();
      ttm.dayLast = 100;
      ttm.dayFirst = 10;
      decimal dias = ttm.dayCount;
      string trasporte = uda.transportName;
      uda.Number_con_book='12345';
      uda.registerOI();
      uda.registerOI();
    }
    
  static testMethod void NEU_Track_and_Trace() {
  	NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer');
      Account a = list_accounts[0];
      insert a;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Only_Warehouse_Service__c = true);
      insert ship;
      NEU_Track_and_Trace uda = new NEU_Track_and_Trace(new ApexPages.StandardController( ship ));
      uda.updateOtherShipmentInfo();
    }

  static testMethod void NEU_Events_Edit() {
  	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');  
      Account a =list_accounts[0];
      insert a;
      Shipment_Program__c sp=new Shipment_Program__c();
      insert sp;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Inbound_Consolidation_Program__c = sp.Id, Only_Warehouse_Service__c = true);
      insert ship;  
      Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Inbound_Consolidation_Program__c = sp.Id, Only_Warehouse_Service__c = true);
      insert ship2;  
      ApexPages.currentPage().getParameters().put('Id', ship.Id);
      NEU_Events_Edit ee = new NEU_Events_Edit();
      string decimales = ee.decimalSep;
      string miles = ee.thousandSep;
      ee.sortList(0);
      string nombre_trasportista = ee.transportName;
      ee.transportName = nombre_trasportista+'2';
      integer tipo_de_transporte = ee.transportType;
      ee.transportType = tipo_de_transporte+2;
      Id shipment = ee.parentId;
      integer tipo_de_padre = ee.parentType;
      string nombre_del_padre = ee.parentName;
      string tipo_de_padre_name = ee.parentTypeName;
      string polname = ee.polname;
      string podname = ee.podname;
      string ts1 = ee.ts1;
      string ts2 = ee.ts2;
      string ts3 = ee.ts3;
      string vessel1 = ee.vessel1;
      string vessel2 = ee.vessel2;
      string vessel3 = ee.vessel3;
      string vessel4 = ee.vessel4;
      ee.cancel();
      ee.saveData();
      List<NEU_Events_Edit.Event_s> new_list_even = null;
      NEU_Events_Edit.Event_s new_even = null;
      ee.polname = polname+'2';
      ee.podname = podname+'2';
      ee.ts1 = ts1+'2';
      ee.ts2 = ts2+'2';
      ee.ts3 = ts3+'2';
      ee.vessel1 = vessel1+'2';
      ee.vessel2 = vessel2+'2';
      ee.vessel3 = vessel3+'2';
      ee.vessel4 = vessel4+'2';
      
  }
  
  static testMethod void NEU_Events_Edit2() {
  	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,'); 
      Account a = list_accounts[0];
      insert a;
      Shipment_Program__c sp=new Shipment_Program__c();
      insert sp;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Inbound_Consolidation_Program__c = sp.Id, Only_Warehouse_Service__c = true);
      insert ship;  
      Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Inbound_Consolidation_Program__c = sp.Id, Only_Warehouse_Service__c = true);
      insert ship2;  
      ApexPages.currentPage().getParameters().put('Id', sp.Id);
      NEU_Events_Edit ee = new NEU_Events_Edit();
      string decimales = ee.decimalSep;
      string miles = ee.thousandSep;
      ee.sortList(0);
      string nombre_trasportista = ee.transportName;
      ee.transportName = nombre_trasportista+'2';
      integer tipo_de_transporte = ee.transportType;
      ee.transportType = tipo_de_transporte+2;
      Id shipment = ee.parentId;
      integer tipo_de_padre = ee.parentType;
      string nombre_del_padre = ee.parentName;
      string tipo_de_padre_name = ee.parentTypeName;
      string polname = ee.polname;
      string podname = ee.podname;
      string ts1 = ee.ts1;
      string ts2 = ee.ts2;
      string ts3 = ee.ts3;
      string vessel1 = ee.vessel1;
      string vessel2 = ee.vessel2;
      string vessel3 = ee.vessel3;
      string vessel4 = ee.vessel4;
      ee.cancel();
      ee.saveData();
      List<NEU_Events_Edit.Event_s> new_list_even = null;
      NEU_Events_Edit.Event_s new_even = null;
      ee.polname = polname+'2';
      ee.podname = podname+'2';
      ee.ts1 = ts1+'2';
      ee.ts2 = ts2+'2';
      ee.ts3 = ts3+'2';
      ee.vessel1 = vessel1+'2';
      ee.vessel2 = vessel2+'2';
      ee.vessel3 = vessel3+'2';
      ee.vessel4 = vessel4+'2';
      
  }
    
  static testMethod void NEU_Track_and_Trace_Shipment_Programs() {
  	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');  
      Account a = list_accounts[0];
      insert a;
      Account sup = list_accounts[1];
      insert sup;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
      insert supplyproject;
      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
      insert suprequest;
      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
      insert supquote;
      Vessel_Flight__c v=new Vessel_Flight__c(Name='Test');
      insert v;
      Shipment_Program__c sp=new Shipment_Program__c();
      insert sp;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10',Truck_Vessel_Flight__c=v.id,Inbound_Consolidation_Program__c=sp.id, Only_Warehouse_Service__c = true);
      insert ship;
      sp.Vessel__c=v.id;
      sp.Vessel__r=v;
      Shipment__c ships = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10',Truck_Vessel_Flight__c=v.id,Inbound_Consolidation_Program__c=sp.id, Only_Warehouse_Service__c = true);
      insert ships;
      NEU_Track_and_Trace_Shipment_Programs uda = new NEU_Track_and_Trace_Shipment_Programs(new ApexPages.StandardController( sp ));
      uda.getoperators();
      uda.gettrackoptions_selected();
      uda.getTrackAndTrace();
      uda.gettrackoptions();
      uda.getoperators_selected();
      uda.registerOI();
      uda.settrackoptions_selected('b_id');
      uda.registerOI();
      uda.setoperators_selected('MAEU');
      uda.registerOI();
      uda.registerOI();
      List<NEU_Track_and_Trace_Shipment_Programs.Milestone_s> m=uda.milestones;
      List<NEU_Track_and_Trace_Shipment_Programs.Status_s> s=uda.processstatus;
      ship.Date__c=null;
      uda.registerOI();
      uda.updatevessel();
      uda.record.Vessel__r.IMO__c=null;
      uda.record.Vessel__r.MMSI__c='MMSI';
      uda.updatevessel();
      uda.record.Vessel__r.IMO__c='IMO';
      uda.updatevessel();
      uda.getByVesselFinder('IMO');
      uda.getByMarineTraffic('IMO');
      NEU_Track_and_Trace_Shipment_Programs.Milestone_s ttm = new NEU_Track_and_Trace_Shipment_Programs.Milestone_s();
      ttm.dayLast = 100;
      ttm.dayFirst = 10;
      decimal dias = ttm.dayCount;
      string trasporte = uda.transportName;
      uda.Number_con_book='12345';
      uda.registerOI();
      uda.registerOI();
    }
  static testMethod void NEU_Track_and_Trace_Shipment_Programs_2() {
  	NEU_StaticVariableHelper.setBoolean1(true);
      Shipment_Program__c sp=new Shipment_Program__c();
      sp.IMO_Number__c='10';
      insert sp;
      NEU_Track_and_Trace_Shipment_Programs uda = new NEU_Track_and_Trace_Shipment_Programs(new ApexPages.StandardController( sp ));
      uda.updateOtherShipmentInfo();
      uda.showVesselInformation();
    }
}