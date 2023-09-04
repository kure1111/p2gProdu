@isTest
public class SendToSAPTest {
    @isTest
    public static void test(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        insert account_test;
        list<  Shipment_Fee_Line__c> lista = new list< Shipment_Fee_Line__c>();
        list<  Shipment_Fee_Line__c> updateLista = new list< Shipment_Fee_Line__c>();
        Shipment__c ship = new Shipment__c(Name= 'SP-FN-21-00345', Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true,Shipment_Status_Plann__c = 'Confirmed',Traslado_Ingreso__c='Traslado',VERIFY_PAK_CONTROL__C=true);
        insert ship;
        SAP_Service_Type__c SPST= new SAP_Service_Type__c();
        SPST.Group__c='SP-PTO-PUERTOS';
        SPST.Name='FLETE LOCAL (IC) (PTO)';
        SPST.Code__c='PTO-FLETE_LOCAL_(IC)';
        SPST.SST_Sociedad__c='PGL';
        SPST.Activo__c=true;
        insert SPST;
        Fee__c srn=new Fee__c();
        srn.Group__c='SP-PTO-PUERTOS';
        // srn.Route__c='Apodaca - Atlanta,GA';
        srn.SAP_Service_Type__c=SPST.id;
        srn.Account_for__c=account_test.id;
        insert srn;
        Shipment_Fee_Line__c spFL=new Shipment_Fee_Line__c(); 
        spfl.Shipment__c=ship.id;
        spfl.Service_Rate_Name__c=srn.id;
        insert spFL;
        
        Id stdPriceBook = Test.getStandardPricebookId();
        List<Product2> prods = [SELECT Id FROM Product2 WHERE Name = :ship.Name];
        Product2 p;
        PricebookEntry pbe;
        
        if(prods.size()>0){
            p = prods[0];
            pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id =:p.Id LIMIT 1];
        }else{
            p = new Product2(Name=ship.Name, IsActive = true);
            insert p;
            
            pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.UnitPrice = 1;
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = stdPriceBook;
            insert pbe;
        }               
        
        Order order = new Order();
        order.AccountId = ship.Account_for__c;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = stdPriceBook;
        order.DefaultProduct__c = p.Id;
        order.DefaultPbe__c = pbe.Id;
        order.Shipment__c = ship.Id;
        insert order;
        
        System.debug('ORDER: ' + order.Id);
        
        Status_Datetime__c statusdate =new Status_Datetime__c();
        statusdate.Shipment__c=ship.id;
        statusdate.Status_Value__c='Confirmed';
        insert statusdate;

        OrderItem line = new OrderItem();
        line.ShipServLineId__c = 'test';
        line.ServLine_Name__c = 'test';
        line.Service_Rate_Name__c = 'PSTest';
        line.Quantity = 1;
        line.UnitPrice = 1;
        line.VAT__c = '16';
        line.Group__c = 'terr';
        line.ItemCode__c = 'FTN';
        line.CurrencyLine__c = 'MXN';
        line.Std_Buy_Amount__c = 100;
        line.Product2Id = p.Id;
        line.PricebookEntryId = pbe.Id;
        line.OrderId = order.Id;        
        insert line;
        
        line = new OrderItem();
        line.ShipServLineId__c = 'test';
        line.ServLine_Name__c = 'test';
        line.Service_Rate_Name__c = 'test';
        line.Quantity = 1;
        line.UnitPrice = 1;
        line.VAT__c = '16';
        line.Group__c = 'terr';
        line.ItemCode__c = 'FTN';
        line.CurrencyLine__c = 'MXN';
        line.Std_Buy_Amount__c = 100;
        line.Product2Id = p.Id;
        line.PricebookEntryId = pbe.Id;
        line.OrderId = order.Id;
        insert line;
        
        delete line;
    }
}