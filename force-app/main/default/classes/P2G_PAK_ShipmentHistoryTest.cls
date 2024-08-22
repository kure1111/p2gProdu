@IsTest
public class P2G_PAK_ShipmentHistoryTest {
    @IsTest(SeeAllData=true)
    public static void testCargaCsv(){
        Shipment__c ship = [SELECT Id,Account_for__c FROM Shipment__c limit 1];
        ship.Acuse_en_SAP__c = True;
        ship.VERIFY_ACUSE_SAP__c = True;
        ship.Sell_Amount_Bloq__c = True;
        ship.AUTORIZADO_FP_FO__c = True;
        ship.AUTORIZAR_GASTO_EXTRA__c = True;
        ship.Cargo_insurance__c = True;
        ship.Cliente_con_cita2__c= True;
        ship.N_Containers__c = 2;
        ship.Conversion_Rate_Date__c = System.today()+1;
        ship.Customs_Broker__c = True;
        //ship.Date_Planner_Confirmed__c = System.now()+1;
        
        ship.Date_Receive_from_SAP__c = System.now()+1;
        ship.Devolucion__c = True;
        ship.Email_Sales_ExecutiveSP__c = 'testship@pak2go.com';
        //ship.Enable_Route_Options__c = True;
        ship.Enviado_Sap__c = True;
        ship.ETA_Point_of_Discharge__c = System.today();
        ship.ETD_from_Point_of_Load__c = System.today();
        ship.Hazardous__c = True;
        ship.Order_Margen_Operativo__c = 30;
        ship.Monitoreo_Recepci_n_Acuse__c = True;
        ship.NotificarGastoExtra__c = True;
        ship.OK_FACTURAR_FI__c = True;
        ship.Only_Warehouse_Service__c = True;
        ship.Placas_Validadas__c = True;
        ship.Reparto__c = True;
        ship.SAP_Invoiced__c = True;
        ship.Sell_Price_Modified__c = True;
        ship.Shipment_Customer_Evaluate__c = 'www.google.com';
        //ship.Name = '.';
        ship.Shipment_Status_Mon__c = 'In Progress';
        ship.Solicitud_de_Maniobras__c = True;
        ship.SP_Evaluated__c = True;
        ship.Status_Acuse_SAP__c = 'Enviado';
        ship.VERIFY_PAK_CONTROL__c = True;
        ship.VoBo_Acuse_SAP__c = True;
        //Account carrier = [SELECT Id FROM Account LIMIT 1];
        //ship.Carrier__c = [Select Id from Carrier__c limit 1].Id;        
        //ship.Country_of_Load__c = [Select Id from Country__c  where Name = 'Mexico T'].Id;
        //ship.State_of_Load__c = [Select Id from State__c   where Name = 'Sonora T'].Id;
        ship.Site_of_Load__c = 'a034T000004F9RiQAK';//[Select Id from Location__c    where Name LIKE 'Hermosillo T'].Id;
        ship.Country_of_Discharge__c = 'a004T0000028AZOQA2';//[Select Id from Country__c  where Name = 'Mexico T'].Id;
        ship.State_of_Discharge__c = 'a044T000003SdLoQAK';//[Select Id from State__c   where Name = 'Sonora T'].Id;
        ship.Site_of_Discharge__c = 'a034T000004FHWMQA4';//[Select Id from Location__c    where Name = 'Hermosillo T'].Id;        
        //ship.Operation_Executive__c = [SELECT Id FROM User WHERE Alias = 'TestL'].Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'EXPORT';
        ship.Service_Type__c = 'FCL';
        ship.Status_Shipment__c = 'Active';
        ship.Destination_Address__c = 'En alguna parte de Xalapa, Veracruz';
        ship.Documentos_de_Cruce__c = True;
        ship.Email_Sales_ExecutiveSP__c = '';
        ship.Name_Cliente__c = 'Cliente de Prueba';
        ship.Marketplace_Auction__c = True;
        ship.National_Operator__c = [SELECT Id FROM Operadores__c limit 1].Id;
        ship.Traslado_Ingreso__c = 'Ingreso';
        //ship.Shipment_Status_Plann__c = 'In Progress';
        ship.Equip_Placed__c = System.Today();
        ship.CurrencyIsoCode = 'USD';
        ship.Email_Sales_ExecutiveSP__c ='pruebas@gmail.com';
        ship.Routing_Operation_Status__c = 'Finalizado';
        ship.Air_Shipment_Status__c = 'Closed';
        //ship.Date_time_FN_Finished__c = System.Today();
        ship.Vehicle__c = 'a2O4T0000000O94UAE';
        test.startTest();
	        update ship;
        test.stopTest();
        
    }  
    
    
}