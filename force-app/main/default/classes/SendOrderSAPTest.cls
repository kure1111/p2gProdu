@isTest
public class SendOrderSAPTest {
    
    @testSetup
    static void SetUp(){
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Limit__c = 100000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        insert account_test;
        
        Account accCarrier2 = createAccount('Cuenta carrier', 'Supply Chain Partner');        
        insert accCarrier2;
        
        Account accCarrier = createAccount('Cuenta carrier', 'Supply Chain Partner');
        insert accCarrier;
        
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = accCarrier.Id;
        operador.Name = 'Operador test';
        operador.Cel_ope__c = '123456789';
        operador.Telfij_ope__c = '123123123';
        operador.Medprev_ope__c = '123123';
        operador.Proovedor_validado__c = true;
        operador.Validado__c = true;
        operador.Operador_Validado__c = true;
        operador.Codigo_Postal_Operador__c = cp.Id;
        operador.RFC_Operador__c = 'TestRFC';
        operador.Numlicvig_ope__c = '123135';
        insert operador;
        
        list<  Shipment_Fee_Line__c> lista = new list< Shipment_Fee_Line__c>();
        list<  Shipment_Fee_Line__c> updateLista = new list< Shipment_Fee_Line__c>();
        
        //catalogo 'Configuracion Autotrasporte tipo de registro en objeto catalogo es diferente enc ada org
        Catalogo_SAT__c trans1 = createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotransporte');//pord Autotransporte,uat Autotrasporte
        Catalogo_SAT__c trans2 = createCatalogoSat('Autotransporte Federal Test' , 'T3S172','Tipo de Permiso');
        
        Vehicle__c Vehicle = new Vehicle__c();
        Vehicle.Name = 'Vehiculo test';
        Vehicle.Account_for_SCP__c = accCarrier.Id;
        Vehicle.Marca__c = 'Mercedes';
        Vehicle.Color_Tracto__c ='Rojo';
        Vehicle.Modelo__c ='K77';
        Vehicle.Ano__c = 2021;
        Vehicle.Configuracion_Vehicularcat__c = trans1.Id;
        Vehicle.Account_Owner_Vehicle__c = accCarrier.Id ;
        Vehicle.Numero_Poliza_Seguro__c = '1234556';
        Vehicle.Asegura_Responsabilidad_Civil__c = 'AXXXA';
        Vehicle.Nombre_Aseguradora__c = 'AXXXA';
        Vehicle.Poliza_Responsabilidad_civil__c = '123456789';
        Vehicle.Prima_Seguro__c = '123456789';
        Vehicle.Numero_de_Permiso_SCT__c = '123456789';
        Vehicle.Tipo_de_Permiso__c = trans2.Id;
        Vehicle.Vehiculo_Validado__c = true;
        insert Vehicle;
        
        Shipment__c ship = new Shipment__c(Name= 'SP-FN-21-00345',Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true,Shipment_Status_Plann__c = 'Confirmed',National_Operator__c =operador.Id ,Traslado_Ingreso__c='Traslado',VERIFY_PAK_CONTROL__C=true, Vehicle__c = Vehicle.id);
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
        srn.SAP_Service_Type__c=SPST.id;
        srn.Account_for__c=account_test.id;
        insert srn;
        
        Shipment_Fee_Line__c spFL=new Shipment_Fee_Line__c(); 
        spfl.Shipment__c=ship.id;
        spfl.Service_Rate_Name__c=srn.id;
        insert spFL;
        
        Id stdPriceBook = Test.getStandardPricebookId();
        Product2 p;
        p = new Product2(Name=ship.Name, IsActive = true);
        insert p;
        
        PricebookEntry pbe;
        pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.UnitPrice = 1;
        pbe.Product2Id = p.Id;
        pbe.Pricebook2Id = stdPriceBook;
        insert pbe;
        
        Order order = new Order();
        order.AccountId = ship.Account_for__c;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = stdPriceBook;
        order.DefaultProduct__c = p.Id;
        order.DefaultPbe__c = pbe.Id;
        order.Shipment__c = ship.Id;
        insert order;
        
        Shipment__c ship2 = new Shipment__c(Account_for__c = account_test.Id, 
                                            name = 'SP-FN-20-107098',
                                            Freight_Mode__c='Road', 
                                            Service_Mode__c ='NATIONAL', 
                                            Only_Warehouse_Service__c = true,
                                            Shipment_Status__c= null,
                                            VERIFY_PAK_CONTROL__c = true,
                                            National_Operator__c = operador.id,
                                            Operation_Executive__c =userinfo.getUserId(),
                                            Vehicle__c = Vehicle.Id,
                                            ATA__c = Datetime.now(),
                                            ATD__c = Datetime.now(),
                                            Approved_date_time__c= Datetime.now()
                                           );
        insert ship2;
        
        Response__c r = new Response__c();
        r.Shipment__c = ship2.id;
        r.Message__c = 'Orden de Venta creada:4009208';
        insert r;
        
    }
    public static Account createAccount(String name, String recordType){
        
        Account accountT = new Account();
        accountT.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        accountT.name = name;    
        accountT.Segment__c = 'Nuevo';

        if(recordType == 'Supply Chain Partner'){
            accountT.Phone = '8311109798';
            accountT.Brand_Name__c = 'Cuenta carrier';
            accountT.NEU_Email__c = 'test@live.com';
            accountT.TAX_ID__c = 'TEST1106099H1';
            accountT.Ubicta_cta__c = 'Nacional';
            accountT.Grupo_SAP_PICK__c = 'FLETES TEST';
            accountT.SCPNombre_Acta_Constitutiva__c = 'N A';
            accountT.Bank_Name_Supplier_Form2__c = 'Banorte Test';
            accountT.Bank_Account_Number__c = '0720780101000000';
            accountT.Bank_Account_Name__c = 'Cuenta carrier';
            accountT.Credit_Limit__c = 500;
            accountT.Anticipo__c = 'No';
            accountT.Sujeto_a_retencion__c = 'Si';
            accountT.Factoraje__c = 'No';
            accountT.C_digo_IVA_Permitido__c = 'IRF';
            accountT.Indicador_de_impuestos__c = 'V2';
            accountT.Comgps_cta__c = 'Compañia ejemplo';
        
        }else{        
            accountT.AccountSource = 'Other';
            accountT.TAX_ID__c = 'TEST1106090000';
        }

        return accountT;            
    }
    
    public static Catalogo_SAT__c createCatalogoSat(String name, String claveSat, String RecordType){
        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = name;
        trans.Clave_SAT__c = claveSat;
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();     
        insert trans;   
        return trans;        
    }
    
    
    @isTest
    public static void setRequestFooterTest(){
        Order order = [SELECT Id, OrderNumber, TotalAmount, OrdenVenta__c, Shipment__c, Shipment__r.Name, Shipment__r.Account_for__r.Venta_Sap__c, 
                       Shipment__r.Shipment_Status_Plann__c, Shipment__r.Shipment_Status__c, Shipment__r.Freight_Mode__c, 
                       Shipment__r.Service_Mode__c, Shipment__r.Account_for__r.Owner.SalesEmployer__c, Shipment__r.Vendedor_Adicional__c,
                       Shipment__r.Carrier__r.Customer_Id__c, Shipment__r.Acuse_en_SAP__c, Shipment__r.Operation_Executive__r.Name,
                       Shipment__r.Operation_Executive_2__r.Name, Shipment__r.State_of_Load__c, Shipment__r.State_of_Load__r.Name, Shipment__r.Route__c,
                       Shipment__r.Route__r.Name, Shipment__r.State_of_Discharge__r.Name, Shipment__r.CurrencyIsoCode, Shipment__r.Orden_de_Compra__c,
                       Shipment__r.Account_for__r.Owner.Workplace__c,
                       Shipment__r.Profit__c,Shipment__r.Account_Shipment_Reference__c,
                       Shipment__r.Account_for__r.Customer_Id__c, Shipment__r.Plaza_Vendedor__c,
                       Shipment__r.ShipmentService__c, Shipment__r.State_of_Load__r.Zone__c, Shipment__r.Site_of_Load__r.State__r.Zone__c,
                       (SELECT Id, ServLine_Name__c, UnitPrice, Quantity, Service_Rate_Name__c, Std_Buy_Amount__c, Retention__c,
                        Group__c, VAT__c, CurrencyLine__c, ItemCode__c, ShipServLineId__c, ItemStatus_SAP__c, ItemStatus_Shipment__c 
                        FROM OrderItems) FROM Order WHERE Status='Draft' LIMIT 1];
        list<  Shipment_Fee_Line__c> lista = [SELECT Shipment__c,Units__c,Service_Rate_Name__r.SAP_Service_Type_Buy__r.Name, Service_Rate_Name__r.SAP_Service_Type__r.Group__c,Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.Tipo_RetencionClientes__c,
                                              CurrencyIsoCode,Service_Rate_Name__r.Carrier_Account__r.Customer_Id__c,Shipment_Buy_Price__c,SST_Orden_compra__c,SST_Estatus_orden_compra__c,Service_Rate_Name__r.P2G_SapDevolucion__c,Service_Rate_Name__r.Tipo_RetencionProveedores__c,Service_Rate_Name__r.SAP_Service_Type__r.Name,Shipment_Sell_Net_Price__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c FROM Shipment_Fee_Line__c LIMIT 10];
        Date d = Date.today();
        String fecha = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/yyyy'); 
        String orden = SendOrderSAP.setRequestHeader(order, fecha, fecha);
        String footer = SendOrderSAP.setRequestFooter(order,'Prod');
        List<OrderItem> listaORden= new List<OrderItem>();
        String shipLines = SendOrderSAP.setRequestLines(lista,lista[0].Id,listaORden);
    }
    
    @isTest
    static void calltest(){
        Order order = [SELECT Id, OrderNumber, TotalAmount, OrdenVenta__c, Shipment__c, Shipment__r.Name, Shipment__r.Account_for__r.Venta_Sap__c, 
                       Shipment__r.Shipment_Status_Plann__c, Shipment__r.Shipment_Status__c, Shipment__r.Freight_Mode__c, 
                       Shipment__r.Service_Mode__c, Shipment__r.Account_for__r.Owner.SalesEmployer__c, Shipment__r.Vendedor_Adicional__c,
                       Shipment__r.Carrier__r.Customer_Id__c, Shipment__r.Acuse_en_SAP__c, Shipment__r.Operation_Executive__r.Name,
                       Shipment__r.Operation_Executive_2__r.Name, Shipment__r.State_of_Load__c, Shipment__r.State_of_Load__r.Name, Shipment__r.Route__c,
                       Shipment__r.Route__r.Name, Shipment__r.State_of_Discharge__r.Name, Shipment__r.CurrencyIsoCode, Shipment__r.Orden_de_Compra__c,
                       Shipment__r.Account_for__r.Owner.Workplace__c,
                       Shipment__r.Profit__c,
                       Shipment__r.Account_for__r.Customer_Id__c, Shipment__r.Plaza_Vendedor__c,
                       Shipment__r.ShipmentService__c, Shipment__r.State_of_Load__r.Zone__c, Shipment__r.Site_of_Load__r.State__r.Zone__c,
                       (SELECT Id, ServLine_Name__c, UnitPrice, Quantity, Service_Rate_Name__c, Std_Buy_Amount__c, Retention__c,
                        Group__c, VAT__c, CurrencyLine__c, ItemCode__c, ShipServLineId__c, ItemStatus_SAP__c, ItemStatus_Shipment__c 
                        FROM OrderItems) FROM Order WHERE Status='Draft' LIMIT 1];
        String footer = SendOrderSAP.setRequestFooter(order,'Prod');
        List<Response__c> listaResponses= [SELECT Shipment__c, Message__c FROM Response__c LIMIT 5];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpSendOrderSAP());
        HttpResponse requestt = SendOrderSAP.sendRequest(footer);
        SendOrderSAP.processResponse(requestt, order.Id, listaResponses,'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:CreateInvoice><tem:datos><tem:Invoice><tem:currency>MXN</tem:currency><tem:WPAccOwner>GDL-Road-NATIONAL</tem:WPAccOwner><tem:CfdiNumber></tem:CfdiNumber><tem:DateReceiveSap>2023-02-14 18:06:31</tem:DateReceiveSap><tem:Fecha>14/02/2023</tem:Fecha><tem:IdInvoice>a1UDV0000028FN52AM</tem:IdInvoice><tem:CardCode>null</tem:CardCode><tem:Monto>0.00</tem:Monto><tem:InvoiceNumber>INV-23-000011</tem:InvoiceNumber><tem:Shipment>SP-FN-22-000149</tem:Shipment><tem:Enviado></tem:Enviado><tem:Respuesta></tem:Respuesta><tem:DetalleInvoice></tem:DetalleInvoice><tem:FolioFacturar>null</tem:FolioFacturar><tem:MBLNumber>null</tem:MBLNumber><tem:MAWBNumber>null</tem:MAWBNumber><tem:Json></tem:Json></tem:Invoice></tem:datos><tem:nombreUsuario>Alberto García</tem:nombreUsuario></tem:CreateInvoice></soapenv:Body></soapenv:Envelope>');
        Test.stopTest();  
    }
    
    @isTest
    static void callsendToSaptest(){
        Shipment__c ship= [SELECT Id FROM Shipment__c WHERE name='SP-FN-20-107098' LIMIT 1];
        Order order = [SELECT Id, Status FROM Order WHERE Status='Draft' LIMIT 1];
        set<Id> setShipmentIds = new set<Id>();
        setShipmentIds.add(order.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpSendOrderSAP());
        SendOrderSAP.sendToSap(setShipmentIds);
        Test.stopTest();  
    }
}