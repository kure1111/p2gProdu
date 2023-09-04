@isTest()
public class PAK_Test {
    @isTest
    public static void GenerateDateLoad(){
        Time HorarioEntrada = Time.newInstance(8, 0, 0, 0);
        Time HorarioSalida = Time.newInstance(20, 0, 0, 0);
        datetime Fecha = datetime.newInstance(date.today() ,Time.newInstance(8, 0, 0, 0));
        Test.startTest();
        GenerateDateLoad.tiempoTranscurrido(fecha.addDays(1),HorarioEntrada,HorarioSalida,4);
        Test.stopTest();    
    }
    @isTest
    public static void ACCTest(){
        /*PAK_TotalesShipment TOSHIP = new PAK_TotalesShipment();
PAK_TotalesShipment.Totales TOSHIP2 = new PAK_TotalesShipment.Totales();*/
        PAK_ShipmentBLOQ BLOQ = new PAK_ShipmentBLOQ(null);
        //PAK_DISWS DIS = new PAK_DISWS();
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
        //PAK_ReporteCobranza COB = new PAK_ReporteCobranza();
        //PAK_ReporteFactura FACT = new PAK_ReporteFactura();
        //PAK_BOTSWS BOTWS = new PAK_BOTSWS(null);
        PAK_Attachment ATT = new PAK_Attachment(null);
        PAK_AttachmentSHIP ATTS = new PAK_AttachmentSHIP(null);
        PAK_WSMESSAGES ME = new PAK_WSMESSAGES();
        PAK_CUSTOMERID PCU = new PAK_CUSTOMERID();
        PAK_CUSTOMERID.CUSTOMER CUSTO = new PAK_CUSTOMERID.CUSTOMER();
        PAK_QuoteBigFreight PAKQ = new PAK_QuoteBigFreight(null);
        Invoice__c I = new Invoice__c();
        PAK_AlinearCreditoSAP ALINEAR = new PAK_AlinearCreditoSAP();
        PAK_AlinearCreditoSAP.CREDITODISPONIBLE CREDITO = new PAK_AlinearCreditoSAP.CREDITODISPONIBLE();
        
        //PAK_VALIDCOSTO PAKV = new PAK_VALIDCOSTO();
        //PAK_VALIDCOSTO.Costos PCOSTO = new PAK_VALIDCOSTO.Costos();
        
        PAK_AcuseAttach PAKATTACH = new PAK_AcuseAttach();
        PAK_AcuseAttach.AttachmentAcuse PAcuse = new PAK_AcuseAttach.AttachmentAcuse();
        //PAK_MAPVisita Visita = new PAK_MAPVisita(null);
        PAK_CreateLeads PAKCL = new PAK_CreateLeads();
        PAK_CreateLeads.Lead LEAD = new PAK_CreateLeads.Lead();
        PAK_CreateLeads.DetalleIEQ DetalleIEQ  = new PAK_CreateLeads.DetalleIEQ();
        PAK_CreateLeads.status LEADST = new PAK_CreateLeads.status();
        
        /*PAK_DISWS.Detalle DisDe = new PAK_DISWS.Detalle();
PAK_DISWS.DetalleDisbursement DisDis = new PAK_DISWS.DetalleDisbursement();
PAK_DISWS.Disbursement DisDisb = new PAK_DISWS.Disbursement();
PAK_DISWS.status DisStatus = new PAK_DISWS.status();*/
        Test.startTest();
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
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
        
        /*TOSHIP2.OC ='0';
TOSHIP2.OV = '0';
TOSHIP2.ShipmentId = shipment_test.Id;
list<PAK_TotalesShipment.Totales> ls4 = new list<PAK_TotalesShipment.Totales>();
ls4.add(TOSHIP2);
PAK_TotalesShipment.ShipmentTOTALES(ls4);
PAK_TotalesShipment.status ST4 = new PAK_TotalesShipment.status();
ST4.code = '01';
ST4.message = 'test01';
ST4.registry = TOSHIP2;

PCOSTO.ShipmentId = shipment_test.Name;       
list<PAK_VALIDCOSTO.Costos> lsCostos = new list<PAK_VALIDCOSTO.Costos>();
lsCostos.add(PCOSTO);
PAK_VALIDCOSTO.ShipmentCosto(lsCostos);
PAK_VALIDCOSTO.status COSTOStatus = new PAK_VALIDCOSTO.status();
COSTOStatus.code='1';
COSTOStatus.Moneda='MXN';
COSTOStatus.message='';
COSTOStatus.PrecioMXN='0';
COSTOStatus.PrecioUSD='0';
COSTOStatus.CostoMXN='0';
COSTOStatus.CostoUSD='0';*/
        
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
        /*CUSTO.Acta= 'test01';
CUSTO.Acuse= 'test01';
CUSTO.Anticipo= 'test01';
CUSTO.Authorized_credit= '100';
CUSTO.Banco= 'test01';
CUSTO.Brand_Name= 'test01';
CUSTO.CiudadEstado= 'test01';
CUSTO.Contrasena= 'test01';
CUSTO.Credit_Limit= '';
CUSTO.Credits_terms= '';
CUSTO.CuentaBancaria= '';
CUSTO.CUSTOMER_ID= '';
CUSTO.Direccion= '';
CUSTO.Email= '';
CUSTO.Especificaciones= '';
CUSTO.Evidencia= '';
CUSTO.FechaRecepcionFacturacion= '';
CUSTO.Forma_de_pago= '';
CUSTO.GiroComercial= '';
CUSTO.IDSFCLIENTE= account_test.Id;
CUSTO.IFE= '';
CUSTO.MontoCreditoSolicitado= '';
CUSTO.Name= 'test01';
CUSTO.PaginaWeb= 'test01';
CUSTO.PeriodoFacturacion= 'test01';
CUSTO.Phone= 'test01';
CUSTO.Plaza= 'test01';
CUSTO.PortalProveedores= 'test01';
CUSTO.RecordType= 'test01';
CUSTO.RequiereOrdenCompra= 'test01';
CUSTO.RFC= 'test01';
CUSTO.Tax_id= 'test01';
CUSTO.Tipo_Acuse= 'test01';
CUSTO.Tipo_de_pago= 'test01';
CUSTO.TipoServicio= 'test01';
CUSTO.SalesEmployer= 'test01';
CUSTO.SlpCode= '';
CUSTO.SlpCodeOwner= '';
CUSTO.Source_Account= 'test01';
CUSTO.Status_Account= 'test01';
CUSTO.UsoCFDI= 'test01';
CUSTO.UsoPortal= 'test01';
CUSTO.Usuario= 'test01';
CUSTO.Venta= 'test01';
list<PAK_CUSTOMERID.CUSTOMER> lsCUSTO = new list<PAK_CUSTOMERID.CUSTOMER>();
lsCUSTO.add(CUSTO);
PAK_CUSTOMERID.SFCUSTOMER(lsCUSTO);*/
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
        SLP.TestMetodo();
        ACUSE.TestMetodo();
        NC.TestMetodo();
        REP.TestMetodo();
        ME.TestMetodo();
        //COB.TestMetodo();
        //FACT.TestMetodo();
        ATT.TestMetodo();
        ATTS.TestMetodo();
        WSDISB.TestMetodo();
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
        rep.tstMethod();
        System.debug('Query: ' + rep.obRep);
        Test.stopTest();
    } 
    @isTest
    public static void PAK_SR_Prom(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Limit__c = 1000000;
        insert account_test;
        
        Shipment__c ship = new Shipment__c( name = 'SP-FN-21-909091', Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        Fee__c rate = new Fee__c();
        rate.Fee_Category__c = 'Road Freights';
        rate.Group__c = 'Consolidado';
        rate.Name = 'Test';
        rate.Account_for__c = account_test.Id;
        insert rate;

    Shipment_Fee_Line__c line = new Shipment_Fee_Line__c();
    line.Name = 'Line test 1';
        line.Service_Rate_Name__c = rate.Id;
        line.Shipment__c = ship.Id;
        line.Shipment_Buy_Price__c = 100;
        line.Shipment_Sell_Price__c = 100;
        insert line;
        
        Shipment_Fee_Line__c line2 = new Shipment_Fee_Line__c();
        line2.Name = 'Line test 1';
        line2.Service_Rate_Name__c = rate.Id;
        line2.Shipment__c = ship.Id;
        line2.Shipment_Buy_Price__c = 100;
        line2.Shipment_Sell_Price__c = 100;
        insert line2;
        
        Test.stopTest();
    }
  @isTest
    public static void PAK_ClienteContado(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Tippag_cta__c = 'Contado';
        insert account_test;
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
         shipment_test.name = 'SP-FN-21-909092';
        insert shipment_test;
        
        PAK_PagoContado.pago p = new PAK_PagoContado.pago();
        p.shipmentId = shipment_test.Id;
        p.montoPago = '1000';
        PAK_PagoContado.pagoContado(p);
    }
    @isTest
    public static void PAK_ClienteRecuperado(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        account_test.Recuperado__c = true;
        update account_test;
        
        account_test.Reasign_Dir__c = true;
        update account_test;
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
    public static void ProveedorWs(){
        Id rtProveedor = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Transporter'][0].Id;
        
        Account prov = new Account();
        prov.RecordTypeId = rtProveedor;
        prov.Name = 'Test';
        prov.Phone = '1243';
        prov.Brand_Name__c = 'tst';
        prov.NEU_Email__c = 'asasda@asdsa.com';
        prov.Ubicta_cta__c = 'Nacional';
        insert prov;
        
        prov.Name = 'Test mod';                
        update prov;
        prov.Phone = '123123';
        update prov;
        prov.Grupo_SAP__c = 'adasd';
        update prov;
        prov.Bank_Name_Supplier_Form__c = 'adsasd';
        update prov;
        prov.Swift_Number__c = '2323';
        update prov;
        prov.Anticipo__c = 'No';
        update prov;
            
        
        Contact c = new Contact();
        c.AccountId = prov.Id;
        c.FirstName = 'juan';
        c.LastName = 'sanchez';
        c.Phone = '323223';
        c.MobilePhone = '2323';
        c.Email = 'asdasd@asdad.com';
        c.Tipcon_cont__c = 'Representante Administrativo';
        insert c;
        
        c.Phone = '2323';
        update c;
        c.Email = 'asdasda@asadsadsa.com';
        update c;
        c.FirstName = 'asdasd';
        update c;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(prov);
        PAK_AcctProvWs vf = new PAK_AcctProvWs(sc);
        vf.sendWs();
    }
    
    @isTest
    public static void ShipmentEstMon(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Shipment__c ship = new Shipment__c( name = 'SP-FN-21-909093', Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        ship.Shipment_Status_Mon__c = 'Finished_M';
        update ship;
        
        Test.stopTest();
    }
    
    /*@isTest
    public static void ShipmentEstSAP(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Shipment__c ship = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Road', Service_Mode__c ='NATIONAL', Only_Warehouse_Service__c = true);
        insert ship;
        
       	Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Shipment_Status_Plann__c = 'Confirmed';
        update ship;
        
        Shipment__c shipIm = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert shipIm;
        
        Response__c resp2 = new Response__c ();
        resp2.Shipment__c = shipIm.id;
        resp2.Type__c = 'CONFIRM';
        resp2.Message__c = 'Orden de Venta creada:4009208';
        insert resp2;
        
        shipIm.Ocean_Shipment_Status__c = 'Confirmed';
        update shipIm;
        
         Shipment__c shipEXP = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Export', Only_Warehouse_Service__c = true);
        insert shipEXP;
        
         Response__c resp3 = new Response__c ();
        resp3.Shipment__c = shipEXP.id;
        resp3.Type__c = 'CONFIRM';
        resp3.Message__c = 'Orden de Venta creada:4009208';
        insert resp3;
        
        shipEXP.Shipment_Status__c = 'Confirmed';
        update shipEXP;
        
        
        Shipment__c shipAir = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Air', Service_Mode__c ='Export', Only_Warehouse_Service__c = true);
        insert shipAir;

 		Response__c resp4 = new Response__c ();
        resp4.Shipment__c = shipAir.id;
        resp4.Type__c = 'CONFIRM';
        resp4.Message__c = 'Orden de Venta creada:4009208';
        insert resp4;
        
        shipAir.Air_Shipment_Status__c = 'Confirmed';
        update shipAir;
        
        
        Test.stopTest();
    }*/
    static testMethod void NEU_ActualizaFolioIE()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.ByPass__c = true;
        insert quote_test;
        quote_test.Service_Mode__c = 'Export';
        update quote_test;
    }
    /* @isTest
    public static void TestShipment(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Limit__c = 1000000;
        insert account_test;
        list<  Shipment_Fee_Line__c> lista = new list< Shipment_Fee_Line__c>();
        list<  Shipment_Fee_Line__c> updateLista = new list< Shipment_Fee_Line__c>();
        Shipment__c ship = new Shipment__c( name = 'SP-FN-21-909095',Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        Shipment__c ship2 = new Shipment__c(name = 'SP-FN-21-909096',Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship2;
        Fee__c rate = new Fee__c();
        rate.Fee_Category__c = 'Road Freights';
        rate.Group__c = 'Consolidado';
        rate.Name = 'Test';
        rate.Account_for__c = account_test.Id;
        insert rate;
            
        Shipment_Fee_Line__c line = new Shipment_Fee_Line__c();
    	line.Name = 'Line test 1';
        line.Service_Rate_Name__c = rate.Id;
        line.Shipment__c = ship.Id;
        line.Shipment_Buy_Price__c = 100;
        line.Shipment_Sell_Price__c = 100;
        lista.add(line);
        
        Shipment_Fee_Line__c line2 = new Shipment_Fee_Line__c();
        line2.Name = 'Line test 1';
        line2.Service_Rate_Name__c = rate.Id;
        line2.Shipment__c = ship.Id;
        line2.Shipment_Buy_Price__c = 100;
        line2.Shipment_Sell_Price__c = -1100;
        lista.add(line2);
        
        Shipment_Fee_Line__c line3 = new Shipment_Fee_Line__c();
        line3.Name = 'Line test 1';
        line3.Service_Rate_Name__c = rate.Id;
        line3.Shipment__c = ship2.Id;
        line3.Shipment_Buy_Price__c = 100;
        line3.Shipment_Sell_Price__c = 100;
        lista.add(line3);
         Shipment_Fee_Line__c line4 = new Shipment_Fee_Line__c();
        line4.Name = 'Line test 1';
        line4.Service_Rate_Name__c = rate.Id;
        line4.Shipment__c = ship2.Id;
        line4.Shipment_Buy_Price__c = 100;
        line4.Shipment_Sell_Price__c = -1100;
        lista.add(line4);
        insert lista;
        
        line.Shipment_Sell_Price__c = 120;
        line3.Shipment_Sell_Price__c = 120;
        updateLista.add(line);
        updateLista.add(line3);
        update updateLista;
        
        delete line4;
    }*/
    
    @isTest
    public static void testSendToOrdr(){
        PAK_SendToOrder.TestMetodo();
    }
}