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
private class NEU_test_Vessel {

    
    static testMethod void test_NEU_OM_Track_and_Trace_Vessel() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Transporter,');   
      Account a = list_accounts[0];
      insert a;
      Account sup = list_accounts[1];
      insert sup;
      Account transporter = list_accounts[2];
      insert transporter;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
      insert supplyproject;
      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
      insert suprequest;
      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
      insert supquote;
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Only_Warehouse_Service__c = true);
      insert ship;
      Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route');
      insert route;
      Vessel_Flight__c vessel = new Vessel_Flight__c(Name='test vessel', Carrier_Account__c = transporter.Id, Route__c =route.Id, IMO__c='548648');
      insert vessel;
      NEU_Track_and_Trace_Vessel uda = new NEU_Track_and_Trace_Vessel(new ApexPages.StandardController( vessel ));
      uda.getbyvessel();
   
    }
    
    static testMethod void test_NEU_OM_Track_and_Trace_Vessel2() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
          ApexPages.currentPage().getParameters().put('test', 'test');
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Transporter,');    
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Account transporter = list_accounts[2];
          insert transporter;
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
          insert supquote;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Only_Warehouse_Service__c = true);
          insert ship;
          Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route');
          insert route;
          Vessel_Flight__c vessel = new Vessel_Flight__c(Name='test vessel', Carrier_Account__c = transporter.Id, Route__c =route.Id);
          insert vessel;
          NEU_Track_and_Trace_Vessel uda = new NEU_Track_and_Trace_Vessel(new ApexPages.StandardController( vessel ));
          uda.Vessel_Name='Name';
          uda.getbyvessel();
          uda.MMSI='MMSI';
          uda.getbyvessel();
          uda.Imo_Number='IMO';
          uda.getbyvessel();
          uda.no_encontrado=uda.no_encontrado;
          uda.Booking_no=uda.Booking_no;
          uda.Container_no=uda.Container_no;
          uda.Container_type=uda.Container_type;
          uda.Operator=uda.Operator;
          uda.SCAC_Carrier_Code=uda.SCAC_Carrier_Code;
          uda.Source=uda.Source;
          uda.Weight=uda.Weight;
          uda.Bl_no=uda.Bl_no;
   
    }
    
    public static testMethod void testNEU_Updated_Position_of_Ship_Vessel() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,'); 
        Account a = list_accounts[0];
        insert a;
        Account transporter = list_accounts[1];
        insert transporter;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route');
        insert route;
        Vessel_Flight__c vessel = new Vessel_Flight__c(Name='test vessel', Carrier_Account__c = transporter.Id, Route__c =route.Id);
        insert vessel;  
        NEU_Updated_Position_of_Ship_Vessel upsv = new NEU_Updated_Position_of_Ship_Vessel(new ApexPages.StandardController( vessel ));
        upsv.create_feed();
    }
    
    static testMethod void NEU_Update_Vessel() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Transporter,'); 
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Account transporter = list_accounts[2];
        insert transporter;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
        insert suprequest;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
        insert supquote;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Only_Warehouse_Service__c = true);
        insert ship;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route');
        insert route;
        Vessel_Flight__c vessel = new Vessel_Flight__c(Name='test vessel', Carrier_Account__c = transporter.Id, Route__c =route.Id);
        insert vessel;
        NEU_Update_Vessel uda = new NEU_Update_Vessel(new ApexPages.StandardController( vessel ));
        uda.updatevessel();
        uda.record.IMO__c=null;
        uda.record.MMSI__c='MMSI';
        uda.updatevessel();
        uda.record.IMO__c='IMO';
        uda.updatevessel();
    }
    
    public static testMethod void testNEU_OM_FollowersVessel() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        Vessel_Flight__c new_vessel = new Vessel_Flight__c();
        new_vessel.Name = 'Vessel Test';
        insert new_vessel;

        NEU_OM_FollowersVessel fv = new NEU_OM_FollowersVessel(new ApexPages.StandardController(new_vessel));
        fv.getfollower();
        fv.getfollowersin();
        fv.nuevalinea();
        fv.quitarlinea();
    }
      
    public static testMethod void testNEU_OM_FollowersSupplyProject2()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
      
        Vessel_Flight__c new_vessel = new Vessel_Flight__c();
        new_vessel.Name = 'Vessel Test';
        insert new_vessel;
        
        NEU_OM_FollowersVessel fv = new NEU_OM_FollowersVessel(new ApexPages.StandardController(new_vessel));
        
        List<NEU_OM_FollowersVessel.follower_s> lista_de_followers = new List<NEU_OM_FollowersVessel.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersVessel.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersVessel.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersVessel.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersVessel.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersVessel.followersin_s(listauser[0],true,false,false));
        fv.follower =lista_de_followers;
        fv.getfollowersin();
        fv.followersin =lista_de_followersin;
        fv.nuevalinea();
        fv.quitarlinea();
    }
}