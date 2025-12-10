@isTest
public class Test_PAK {
	@isTest
    public static void ACCTest(){
        PAK_ShipmentBLOQ BLOQ = new PAK_ShipmentBLOQ(null);
        BLOQ.Bandera =false;
        PAK_UAccount_Service WS = new PAK_UAccount_Service();
        PAK_DISWS WSDISB = new PAK_DISWS();
        PAK_CANCEL_INV_SERVICE WS2 = new PAK_CANCEL_INV_SERVICE();
        PAK_TOTAL_FACT_SERVICE WS3 = new PAK_TOTAL_FACT_SERVICE();
        PAK_Update_ACC.UAccount ACC = new PAK_Update_ACC.UAccount();
        PAK_Update_ACC.CANCEL_INV INV = new PAK_Update_ACC.CANCEL_INV();
        PAK_Update_ACC.TOTAL_FACT TF = new PAK_Update_ACC.TOTAL_FACT();
        PAK_SLPCODE SLP = new PAK_SLPCODE();
        PAK_WS_ACUSE ACUSE = new PAK_WS_ACUSE();
        PAK_NCREDITO_SERVICE NC = new PAK_NCREDITO_SERVICE();
        PAK_ReporteVentas REP = new PAK_ReporteVentas();
        PAK_ReporteVentas.Response RES = new PAK_ReporteVentas.Response();
        PAK_Attachment ATT = new PAK_Attachment(null);
        PAK_AttachmentSHIP ATTS = new PAK_AttachmentSHIP(null);
        PAK_WSMESSAGES ME = new PAK_WSMESSAGES();
        PAK_CUSTOMERID PCU = new PAK_CUSTOMERID();
        PAK_CUSTOMERID.CUSTOMER CUSTO = new PAK_CUSTOMERID.CUSTOMER();
        PAK_QuoteBigFreight PAKQ = new PAK_QuoteBigFreight(null);
        Invoice__c I = new Invoice__c();
        PAK_AlinearCreditoSAP ALINEAR = new PAK_AlinearCreditoSAP();
        PAK_AlinearCreditoSAP.CREDITODISPONIBLE CREDITO = new PAK_AlinearCreditoSAP.CREDITODISPONIBLE();

        PAK_AcuseAttach PAKATTACH = new PAK_AcuseAttach();
        PAK_AcuseAttach.AttachmentAcuse PAcuse = new PAK_AcuseAttach.AttachmentAcuse();
        PAK_CreateLeads PAKCL = new PAK_CreateLeads();
        PAK_CreateLeads.Lead LEAD = new PAK_CreateLeads.Lead();
        PAK_CreateLeads.DetalleIEQ DetalleIEQ  = new PAK_CreateLeads.DetalleIEQ();
        PAK_CreateLeads.status LEADST = new PAK_CreateLeads.status();
        
        Test.startTest();
        
        Account account_test=new Account();
        account_test.Name='TESTCustomer';
        account_test.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //Prod
        account_test.OwnerId='0054T0000025ew3QAA';        
        account_test.Segment__c = 'Nuevo';
        insert account_test; 
        //Account account_test=[SELECT Id, Segment__c,Owner.isActive FROM Account WHERE Segment__c ='Nuevo' AND Owner.IsActive = true limit 1];       
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.name = 'SP-FN-21-909090';
        insert shipment_test;
    	List<Shipment_Fee_Line__c> lstUpd = new List<Shipment_Fee_Line__c>();
        
        Shipment_Fee_Line__c sfl = new Shipment_Fee_Line__c();
        sfl.Shipment__c = shipment_test.Id;
        sfl.Name = '001';
        lstUpd.add(sfl);
        
        
        
        insert lstUpd;
        LEAD.AccountName='Test Name';
        DetalleIEQ.ContainerType='40H';
        LEAD.CountryOfDis='Mexico';
        LEAD.CountryOfLoad='Mexico';
        LEAD.Email='test@test.com';
        LEAD.FreightMode='Sea';
        DetalleIEQ.Height='100';
        DetalleIEQ.ItemUnits='1';
        DetalleIEQ.Length='100';
        LEAD.SalesIncoterm='test';
        LEAD.ServiceMode='Import';
        LEAD.ServiceType='FCL';
        LEAD.SiteOfDis='Monterrey';
        LEAD.SiteOfLoad='Monterrey';
        LEAD.StateOfDis='Nuevo Leon';
        LEAD.StateOfLoad='Nuevo Leon';
        DetalleIEQ.TotalShippingWeight='200';
        DetalleIEQ.TotalUnitWeight='200';
        DetalleIEQ.Width='100';
        
        LEADST.code='';
        LEADST.message='';
        
        list<PAK_CreateLeads.DetalleIEQ> lsDetalle = new list<PAK_CreateLeads.DetalleIEQ>();
        lsDetalle.add(DetalleIEQ);
        PAK_CreateLeads.Detalle Detalles = new PAK_CreateLeads.Detalle();
        Detalles.DetalleIEQ = lsDetalle;
        LEAD.DetalleIEQ = Detalles;
        
        list<PAK_CreateLeads.Lead> lsLEAD = new list<PAK_CreateLeads.Lead>();
        lsLEAD.add(LEAD);  
        PAK_CreateLeads.CREATELEAD(lsLEAD);
        
        LEAD.ServiceType = 'LCL';
        list<PAK_CreateLeads.Lead> lsLEAD2 = new list<PAK_CreateLeads.Lead>();
        lsLEAD2.add(LEAD);  
        PAK_CreateLeads.CREATELEAD(lsLEAD2);
        
        LEAD.ServiceType = 'PAQUETERIA';
        list<PAK_CreateLeads.Lead> lsLEAD3 = new list<PAK_CreateLeads.Lead>();
        lsLEAD3.add(LEAD);  
        PAK_CreateLeads.CREATELEAD(lsLEAD3);
        
        PAcuse.CustomerID = 'CMTY2247';
        PAcuse.Documento = 'Test0';
        PAcuse.NameDocumento = 'Test0';
        list<PAK_AcuseAttach.AttachmentAcuse> lsAcuses = new list<PAK_AcuseAttach.AttachmentAcuse>();
        lsAcuses.add(PAcuse);
        PAK_AcuseAttach.AcuseDocumento(lsAcuses);
        PAK_AcuseAttach.status AcusesStatus = new PAK_AcuseAttach.status();
        AcusesStatus.code='1';
        AcusesStatus.message ='Test0';
        
        CREDITO.CustomerID = 'CCUU0658';
        CREDITO.Credito = null;
        CREDITO.OVAbiertas = null;
        list<PAK_AlinearCreditoSAP.CREDITODISPONIBLE> ls2 = new  list<PAK_AlinearCreditoSAP.CREDITODISPONIBLE>();
        ls2.add(CREDITO);
        PAK_AlinearCreditoSAP.SFCREDITO(ls2);
        PAK_AlinearCreditoSAP.status ST2 = new PAK_AlinearCreditoSAP.status();
        ST2.code = '01';
        ST2.message = 'test01';
        ST2.registry = CREDITO;
        Task Activadad = new Task(Priority = 'Normal',Subject = 'Test',Status = 'Scheduled', OwnerId = UserInfo.getUserId());
        insert Activadad;
        //Visita.Tarea = Activadad;
        //Visita.Guardar();
        Event Activadad2 = new Event(DurationInMinutes = 1,ActivityDateTime= Datetime.now(), Subject = 'Test', OwnerId = UserInfo.getUserId());
        insert Activadad2;
        ACC.Customer_id= 'test01';
        ACC.Status_Account= 'test01';
        ACC.Name= 'test01';
        ACC.Brand_Name= 'test01';
        ACC.Tax_id= 'test01';
        ACC.Phone= 'test01';
        ACC.Email= 'test01';
        ACC.Tipo_de_pago= 'test01';
        ACC.Forma_de_pago= 'test01';
        ACC.Credits_terms= 'test01';
        ACC.SalesEmployer = 'test01';
        ACC.Direccion = 'test01';
        ACC.Credit_Limit = '100';
        ACC.Acuse= 'test01';
        INV.IdInovice= 'test01';
        INV.Cancel= 'test01';
        INV.Tipo= 'PEDIDO';
        TF.IdInovice= 'test01';
        TF.TotalFacturado= 'test01';
        TF.Tipo= 'PEDIDO';
        TF.FechaFactura= '09/03/2018';
        TF.UI= 'test01';

        PCU.TestMetodo();
        list<PAK_Update_ACC.UAccount> ls = new list<PAK_Update_ACC.UAccount>();
        ls.add(ACC);
        PAK_UAccount_Service.UAccount(ls);
        PAK_UAccount_Service.status ST = new PAK_UAccount_Service.status();
        ST.code = '01';
        ST.message = 'test01';
        ST.registry = ACC;
        
        list<PAK_Update_ACC.CANCEL_INV> lsC = new list<PAK_Update_ACC.CANCEL_INV>();
        lsC.add(INV);
        PAK_CANCEL_INV_SERVICE.CANCEL(lsC);
        PAK_CANCEL_INV_SERVICE.status STC = new PAK_CANCEL_INV_SERVICE.status();
        STC.code = '01';
        STC.message = 'test01';
        STC.registry = INV;
        
        list<PAK_Update_ACC.TOTAL_FACT> lsT = new list<PAK_Update_ACC.TOTAL_FACT>();
        lsT.add(TF);
        PAK_TOTAL_FACT_SERVICE.FACT(lsT);
        PAK_TOTAL_FACT_SERVICE.status STT = new PAK_TOTAL_FACT_SERVICE.status();
        STT.code = '01';
        STT.message = 'test01';
        STT.registry = TF;
        WS2.TestMetodo();
        WS3.TestMetodo();
        //SLP.TestMetodo();
        //ACUSE.TestMetodo();
        //NC.TestMetodo();
        REP.TestMetodo();
        ME.TestMetodo();
        //COB.TestMetodo();
        //FACT.TestMetodo();
        ATT.TestMetodo();
        ATTS.TestMetodo();
        //WSDISB.TestMetodo();
        Associated_Document__c Doc = new Associated_Document__c(Name='Test',Account__c=account_test.Id,Document_Type__c='Bill of Lading');
        insert Doc;
        Test.stopTest();   
    }
    @isTest
    public static void IMPKQuoteTest(){
        PAK_CreateQuoteImpak PAKCL = new PAK_CreateQuoteImpak();
        PAK_CreateQuoteImpak.Quote LEAD = new PAK_CreateQuoteImpak.Quote();
        PAK_CreateQuoteImpak.DetalleQuote DetalleIEQ  = new PAK_CreateQuoteImpak.DetalleQuote();
        PAK_CreateQuoteImpak.estatus LEADST = new PAK_CreateQuoteImpak.estatus();
        
        Test.startTest();
        
        DetalleIEQ.ContainerType='40H';
        LEAD.CountryOfDis='Mexico';
        LEAD.CountryOfLoad='Mexico';
        LEAD.FreightMode='Sea';
        DetalleIEQ.Height='100';
        DetalleIEQ.ItemUnits='1';
        DetalleIEQ.Length='100';
        LEAD.SalesIncoterm='test';
        LEAD.ServiceMode='Import';
        LEAD.ServiceType='FCL';
        LEAD.SiteOfDis='Monterrey';
        LEAD.SiteOfLoad='Monterrey';
        LEAD.StateOfDis='Nuevo Leon';
        LEAD.StateOfLoad='Nuevo Leon';
        LEAD.ETA = '2018/01/01';
        LEAD.ETD  = '2018/01/01';
        DetalleIEQ.TotalShippingWeight='200';
        DetalleIEQ.TotalUnitWeight='200';
        DetalleIEQ.Width='100';
        
        LEADST.code='';
        LEADST.message='';
        
        list<PAK_CreateQuoteImpak.DetalleQuote> lsDetalle = new list<PAK_CreateQuoteImpak.DetalleQuote>();
        lsDetalle.add(DetalleIEQ);
        LEAD.DetalleQuote = lsDetalle;
         
        PAK_CreateQuoteImpak.createQuote(LEAD);
        
        LEAD.ServiceType = 'LCL';
        PAK_CreateQuoteImpak.createQuote(LEAD);
        
        LEAD.ServiceType = 'PAQUETERIA';
        PAK_CreateQuoteImpak.createQuote(LEAD);
       
        Test.stopTest();
    }
    
    @isTest
    public static void PK2_FN_TABLE_Test(){
       	Test.startTest();
        PK2_FN_TABLE tableInstance = new PK2_FN_TABLE();
        PK2_FN_TABLE.limitWrapper[] blocks = tableInstance.getThousandBlocks();
        Test.stopTest();
    }
    
    @isTest
    public static void FN_TABLE(){
        PK2_FN_TABLE FNTABLE = new PK2_FN_TABLE();
        PK2_GRAL_DAHBOARD PAK2 = new PK2_GRAL_DAHBOARD();
        PK2_Utils PK2 = new PK2_Utils();
        Test.startTest();
        PAK2.getHistoria();
        PK2.getHistoriaFeeline();
        System.debug('----------'+PAK2.ls);  
        Test.stopTest();   
        
    }
    @isTest
    public static void FN_TABLE2(){
        PK2_GRAL_DAHBOARD PAK2 = new PK2_GRAL_DAHBOARD();
        PK2_Utils_2 PK2 = new PK2_Utils_2();
        Test.startTest();
        PAK2.getHistoria();
        PK2.getHistoriaFeeline();
        System.debug('----------'+PAK2.ls);  
        Test.stopTest(); 
    }
    @isTest
    public static void PEDIDOS()
    {
        PAK_SalesOrder SO = new PAK_SalesOrder(null);
       
        Test.startTest();
       
        SO.TestMetodo();
       
        Test.stopTest();   
        
    }
    
    @isTest
    public static void PAKHOME(){
        Test.startTest();
        PK2_HomeTask c = new PK2_HomeTask();
        System.debug('----------'+c.lsTask);  
        Test.stopTest(); 
    }
    @isTest
    public static void PK2_FI_TABLE_STATES(){
        Test.startTest();
        PK2_FI_TABLE_STATES c = new PK2_FI_TABLE_STATES();  
        Test.stopTest(); 
    }
    @isTest
    public static void PK2_FN_TABLE_STATES(){
        Test.startTest();
        PK2_FN_TABLE_STATES c = new PK2_FN_TABLE_STATES();  
        Test.stopTest(); 
    }
    @isTest
    public static void PK2_TABLE_MONITOREO_FI(){
        Test.startTest();
        PK2_TABLE_MONITOREO_FI c = new PK2_TABLE_MONITOREO_FI();  
        Test.stopTest();
    }
    @isTest
    public static void PK2_FI_IEQ(){
        Test.startTest();
        PK2_FI_IEQ c = new PK2_FI_IEQ();  
        Test.stopTest();
    }
    @isTest
    public static void QualityAssurance(){        
        Test.startTest();
        PAK_QuotesReport vf = new PAK_QuotesReport();
        ApexPages.currentPage().getParameters().put('service', 'FN');
        ApexPages.currentPage().getParameters().put('startDate', string.valueOf(Date.newInstance(Date.Today().Year(), Date.Today().Month(), 1)));
        ApexPages.currentPage().getParameters().put('endDate', string.valueOf(Date.newInstance(Date.Today().Year(), Date.Today().Month(), Date.daysInMonth(Date.Today().Year(), Date.Today().Month()))));
        exportXLSController rep = new exportXLSController();
        //rep.tstMethod();
        System.debug('Query: ' + rep.obRep);
        Test.stopTest();
    } 
    @isTest
    public static void PAK_TotalFacMesTst(){
        List<PAK_TotFacMes.Plaza> lstPlazas = new List<PAK_TotFacMes.Plaza>();
        PAK_TotFacMes.Plaza plaza = new PAK_TotFacMes.Plaza();
        plaza.plazaYear = 'MTY-2019';
        plaza.totalEne = '1';
        plaza.totalFeb = '2';
        plaza.totalMar = '3';
        plaza.totalAbr = '4';
        plaza.totalMay = '5';
        plaza.totalJun = '6';
        plaza.totalJul = '7';
        plaza.totalAgo = '8';
        plaza.totalSep = '9';
        plaza.totalOct = '10';
        plaza.totalNov = '11';
        plaza.totalDic = '12';
        lstPlazas.add(plaza);
        
        PAK_TotFacMes.updateTotalFacturadoMes(lstPlazas);
        
        lstPlazas = new List<PAK_TotFacMes.Plaza>();
        plaza = new PAK_TotFacMes.Plaza();
        plaza.plazaYear = 'MTY-2019';
        plaza.totalEne = '11';
        plaza.totalFeb = '22';
        plaza.totalMar = '33';
        plaza.totalAbr = '44';
        plaza.totalMay = '55';
        plaza.totalJun = '66';
        plaza.totalJul = '77';
        plaza.totalAgo = '88';
        plaza.totalSep = '99';
        plaza.totalOct = '100';
        plaza.totalNov = '110';
        plaza.totalDic = '120';
        lstPlazas.add(plaza);
        
        PAK_TotFacMes.updateTotalFacturadoMes(lstPlazas);
    }
    
    @isTest
    public static void testSendToOrdr(){
        PAK_SendToOrder.TestMetodo();
    }
    
}