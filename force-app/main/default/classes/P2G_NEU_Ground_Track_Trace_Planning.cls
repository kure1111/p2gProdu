@isTest
public class P2G_NEU_Ground_Track_Trace_Planning {

     @isTest(SeeAllData=true)
    static void test_NEU_Ground_Track_Trace_Planning() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',Total_Gross_Volume_m3__c  = 10, Total_Gross_Weight_Kg__c  = 10, Number_of_Packages__c =10);
        insert ship_prog;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country2;
        Location__c localizacion3 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion3;
        
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Freight_Mode__c='Road',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address', Quotation_Status__c = 'Approved as Succesful');
        Customer_Quote__c importexportquote = [SELECT Id, Margen_Operativo__c, Pricing_Executive__c FROM Customer_Quote__c 
                                               WHERE Margen_Operativo__c !=null AND Pricing_Executive__c!=null AND Quotation_Status__c='Approved as Succesful' 
                                               AND Account_for__r.RecordType.DeveloperName='Customer' AND Account_for__r.OwnerId != '0054T000000ZZQ3QAO'  LIMIT 1];
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
        service_rate.Name = 'Sercie Rate Test';
        service_rate.Fee_Category__c = 'Disbursement';
        service_rate.Rate_Type__c = 'Per Kg';
        service_rate.Account_for__c = a.Id;
        insert service_rate;
        
        Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
        ie_service_line.Import_Export_Quote__c = importexportquote.Id;
        ie_service_line.Name = '001'; 
        ie_service_line.Service_Rate_Name__c = service_rate.Id; 
        ie_service_line.Extension_Service_Name__c = 'Test Name'; 
        ie_service_line.Discount__c = 10; 
        ie_service_line.Quote_Buy_Price__c = 10; 
        ie_service_line.Quote_Sell_Price__c = 10;
        ie_service_line.Units__c = 10;
        insert ie_service_line;
        
        //importexportquote.Quotation_Status__c ='Approved as Succesful';
        //update importexportquote;
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-001',
                                           Traslado_Ingreso__c = 'Traslado',
                                           Account_for__c = a.Id,
                                           Freight_Mode__c='Sea',
                                           Service_Mode__c ='Import',
                                           Inbound_Consolidation_Program__c = ship_prog.Id,
                                           Country_of_Load__c= Country.Id,
                                           Site_of_Load__c=localizacion.Id,
                                           Country_of_Discharge__c= Country.Id,
                                           Site_of_Discharge__c= localizacion.Id,
                                           Equip_Placed__c = system.today(),
                                           ETD_from_Point_of_Load__c = system.today(),
                                           ETA_Point_of_Discharge__c = system.today(),
                                           Equip_Unloaded__c = system.today(),
                                           Origin_Address__c ='test',
                                           Destination_Address__c='test',
                                           Only_Warehouse_Service__c = true);
        insert ship;
        
        
        // coordenadas_longitud
        // coordenadas_add
        
        Shipment__c ship2 = new Shipment__c(Name = 'SP-TS-002', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog.Id,  Country_of_Load__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_of_Discharge__c= Country.Id,Site_of_Discharge__c= localizacion.Id,Equip_Placed__c = system.today(),ETD_from_Point_of_Load__c = system.today(),ETA_Point_of_Discharge__c = system.today(),Equip_Unloaded__c = system.today(),Origin_Address__c ='test',Destination_Address__c='test', Only_Warehouse_Service__c = true);
        insert ship2;
        NEU_Shipment_Program_View_Route r=new NEU_Shipment_Program_View_Route(new ApexPages.StandardController( ship_prog ));
        for(NEU_Shipment_Program_View_Route.shipment_s s:r.list_shipment_related_load)
        {
            String st=s.Loading_Time;
            st=s.Unloading_Time;
            st=s.Transit_time;
            st=s.Transit_time_Discharge;
        }
        Test.startTest();
        NEU_Ground_Track_Trace_Planning gttp = new NEU_Ground_Track_Trace_Planning(new ApexPages.StandardController( ship_prog ));
        for(NEU_Ground_Track_Trace_Planning.shipment_s s:gttp.list_shipment_related_load)
        {
            String st=s.Loading_Time;
            st=s.Unloading_Time;
            st=s.Transit_time;
            st=s.Transit_time_Discharge;
        }
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_load_up();
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_load_down();
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_discharge_up();
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_discharge_down();
        
        gttp.save_coordenadas();
        gttp.save_changes_shipments();
        Test.stopTest();
        
    }
}