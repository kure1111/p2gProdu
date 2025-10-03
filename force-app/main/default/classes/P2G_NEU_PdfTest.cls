/*Clase test con cobertura para las siguientes clases:
NEU_AWB_Label_House_PDF
NEU_AWB_Label_PDF_iframe
NEU_Air_Manifest_pdf_ES
NEU_Manifest_PDF
NEU_Air_Waybills_save_PDF
NEU_BL_save_pdf
NEU_Carta_Instrucciones_save_pdf
NEU_Customer_Order_Confirmation_pdf
NEU_DO_save_pdf
NEU_IE_Comparison_PDF
NEU_IE_Notifications_PDF
NEU_Import_Export_Quote_save_pdf
NEU_Order_Confirmation_Shipment_save_pdf
NEU_Purchase_Order_save_pdf
NEU_SP_Notifications_save_PDF
*/
@IsTest
public class P2G_NEU_PdfTest {
    //Metodo para las 5 clases
    //NEU_AWB_Label_House_PDF, NEU_AWB_Label_PDF_iframe, NEU_Air_Manifest_pdf_ES, NEU_Air_Waybills_save_PDF, NEU_Manifest_PDF
	@IsTest
    public static void NEU_Air_Waybill_test(){
        test.startTest();
        Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';
        air_waybill_test.Name = 'Test AWB';
        air_waybill_test.Accounting_Information__c = 'Test Accounting Info';
        air_waybill_test.Serial_Number__c = '12345';
        air_waybill_test.Weight_Charge_House__c = 4;
        air_waybill_test.Valuation_Charge_House__c = 4; 
        air_waybill_test.Tax_House__c = 4; 
    	air_waybill_test.Total_Other_Charges_Due_Agent_House__c = 4;
		air_waybill_test.Total_Other_Charges_Due_House__c = 4;
		air_waybill_test.Weight_Charge_Master__c = 4;
		air_waybill_test.Valuation_Charge_Master__c = 4; 
		air_waybill_test.Tax_Master__c = 4; 
    	air_waybill_test.Total_Other_Charges_Due_Agent_Master__c = 4; 
		air_waybill_test.Total_Other_Charges_Due_Master__c = 4;
        insert air_waybill_test;
        
        Waybill_Consolidation__c consolidation = new Waybill_Consolidation__c();
        consolidation.Name = 'Test Consolidation';
        consolidation.Waybill__c = air_waybill_test.Id;
        insert consolidation;
        
        Air_Waybill_Line__c awbLine = new Air_Waybill_Line__c();
        awbLine.Name = 'Test Line';
        awbLine.No_of_Pieces__c = 4;
        awbLine.Air_Waybill__c = air_waybill_test.Id;
        awbLine.House_Reference__c = consolidation.Id;
        insert awbLine;
        //Inicia Clase NEU_AWB_Label_House_PDF
        PageReference pageRef = Page.NEU_AWB_Label_House_PDF;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('name', consolidation.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(air_waybill_test);
        NEU_AWB_Label_House_PDF controllerHouse = new NEU_AWB_Label_House_PDF(stdController);
        //Fin Clase NEU_AWB_Label_House_PDF
        //Inicia Clase NEU_AWB_Label_PDF_iframe
        NEU_AWB_Label_PDF_iframe controllerIframe = new NEU_AWB_Label_PDF_iframe(stdController);
        //Fin Clase NEU_AWB_Label_PDF_iframe
        //Inicia Clase NEU_Air_Manifest_pdf_ES
        NEU_Air_Manifest_pdf_ES controllerManifestEs = new NEU_Air_Manifest_pdf_ES(stdController);
            controllerManifestEs.record = air_waybill_test;
            controllerManifestEs.manifest = 'Test';
            List<Air_Waybill_Line__c> listAwbLine = new List<Air_Waybill_Line__c>();
            listAwbLine.add(awbLine);
            controllerManifestEs.lineas = listAwbLine;
        //Fin Clase NEU_AWB_Label_House_PDF
        //Inicia Clase NEU_AWB_Label_PDF_iframe
        NEU_Manifest_PDF controllerManifest = new NEU_Manifest_PDF(stdController);
        PageReference pageRefSave = Page.NEU_Air_Waybills_save_PDF;
            Test.setCurrentPage(pageRefSave);
            ApexPages.currentPage().getParameters().put('type', 'house');
            ApexPages.currentPage().getParameters().put('id', air_waybill_test.Id);
        NEU_Air_Waybills_save_PDF controllerSave = new NEU_Air_Waybills_save_PDF(stdController);
            Document d = controllerSave.documento_asociado;
            String l = controllerSave.language;
            controllerSave.return_page();
            controllerSave.crear();
            controllerSave.errores = 'Test';
            controllerSave.updateFilters();
            PageReference clear_values = controllerSave.clear_values();
            PageReference refrescar_pdf = controllerSave.refrescar_pdf();
            controllerSave.fail();
        	controllerSave.awb_type = 'master';
        //Fin Clase NEU_Air_Waybills_save_PDF
        test.stopTest();
    }
    //Metodo para las 3 clases 
    //NEU_BL_save_pdf, NEU_Carta_Instrucciones_save_pdf, NEU_Order_Confirmation_Shipment_save_pdf
	@IsTest(SeeAllData=true)
    public static void NEU_Shipment_test(){
        Shipment__c ship = [SELECT Id, Account_for__c, Freight_Mode__c, Service_Mode__c, Only_Warehouse_Service__c 
                            FROM Shipment__c WHERE Freight_Mode__c = 'Sea' LIMIT 1];
        test.startTest();
        //Inicia Clase NEU_BL_save_pdf
        PageReference pageRef = Page.NEU_BL_save_pdf;
            Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(ship);
        NEU_BL_save_pdf BLsave = new NEU_BL_save_pdf(stdController);
            Blob b = Blob.valueOf('Test Data');
            BLsave.documento_asociado.Name='Test document.test';
            BLsave.documento_asociado.AuthorId = UserInfo.getUserId();
            BLsave.documento_asociado.IsPublic=true;
            BLsave.documento_asociado.Body = b;
            BLsave.crear();
            BLsave.refresh_data();
            BLsave.getnewcategories();
        //Fin Clase NEU_BL_save_pdf
        //Inicia Clase NEU_Carta_Instrucciones_save_pdf
        NEU_Carta_Instrucciones_save_pdf CartaInstrucciones = new NEU_Carta_Instrucciones_save_pdf(stdController);
        	CartaInstrucciones.language = 'Test';
        	CartaInstrucciones.getnewcategories();
        	CartaInstrucciones.refresh_data();
        	CartaInstrucciones.crear();
        //Fin Clase NEU_Carta_Instrucciones_save_pdf
        //Inicia Clase NEU_Order_Confirmation_Shipment_save_pdf
        NEU_Order_Confirmation_Shipment_save_pdf OrderConfirmation = new NEU_Order_Confirmation_Shipment_save_pdf(stdController);
            OrderConfirmation.documento_asociado.Name='Test document.test';
           	OrderConfirmation.documento_asociado.AuthorId = UserInfo.getUserId();
           	OrderConfirmation.documento_asociado.IsPublic=true;
           	OrderConfirmation.documento_asociado.Body = b;
           	OrderConfirmation.crear();
        //Fin Clase NEU_Order_Confirmation_Shipment_save_pdf
        test.stopTest();
    }
    //Metodo para las 5 clases NEU_Customer_Order_Confirmation_pdf,
    //NEU_DO_save_pdf, NEU_IE_Comparison_PDF, NEU_IE_Notifications_PDF,NEU_Import_Export_Quote_save_pdf
	@IsTest(SeeAllData=true)
    public static void NEU_IEQO_test(){
    	NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c ieqo = [SELECT Id, Account_for__c, Freight_Mode__c, Service_Mode__c,Service_Type__c 
                                  FROM Customer_Quote__c WHERE Quotation_Status__c != 'Quote Declined' AND Freight_Mode__c = 'Air' 
                                  AND Pricing_Executive__c != null and Customer_Reference__c = null LIMIT 1];
        test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(ieqo);
        Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
        insert family;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id,
                                                     Account_Owner__c= ieqo.Account_for__c ,  HS_Code_Text__c='56489');
        insert item;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = ieqo.id,Name = 'lineas items', 
                                                          Item_Name__c = item.Id);
        insert quote;
        //Inicia Clase NEU_Customer_Order_Confirmation_pdf
        PageReference pdf = Page.NEU_Customer_Order_Confirmation_pdf;
            pdf.getParameters().put('id',ieqo.Id);
        NEU_Customer_Order_Confirmation_pdf OrderConfirmation = new NEU_Customer_Order_Confirmation_pdf(stdController);
        ieqo.B_L_Status__c = 'Original';
        update ieqo;
        //Fin Clase NEU_Customer_Order_Confirmation_pdf
        //Inicia Clase NEU_DO_save_pdf
        PageReference pageRefDoSave = Page.NEU_DO_save_pdf;
            Test.setCurrentPage(pageRefDoSave);
        NEU_DO_save_pdf DoSave = new NEU_DO_save_pdf(stdController);
            DoSave.return_page();
            DoSave.crear();
            DoSave.generar_pdf();
        	DoSave.language = 'Test';
			DoSave.date_release = 'Test';
			DoSave.date_valid_to = 'Test';
        //Fin Clase NEU_DO_save_pdf
        //Inicia Clase NEU_IE_Comparison_PDF
        PageReference pageRefIeComparison = Page.NEU_IE_Comparison_PDF;
            Test.setCurrentPage(pageRefIeComparison);
        	ApexPages.currentPage().getParameters().put('services_charges', 'true');
		NEU_IE_Comparison_PDF IeComparison = new NEU_IE_Comparison_PDF(stdController);
        	IeComparison.moneda = 'Test';
        //Fin Clase NEU_IE_Comparison_PDF
        //Inicia Clase NEU_IE_Notifications_PDF
		NEU_IE_Notifications_PDF IeNotifications = new NEU_IE_Notifications_PDF(stdController);
            IeNotifications.load_template();
            IeNotifications.load_template_booking_english();
            IeNotifications.load_template_booking_spanish();
        //Fin Clase NEU_IE_Notifications_PDF
        //Inicia Clase NEU_Import_Export_Quote_save_pdf
        NEU_Import_Export_Quote_save_pdf uda = new NEU_Import_Export_Quote_save_pdf(new ApexPages.StandardController( ieqo ));
            Blob b = Blob.valueOf('Test Data');
            uda.documento_asociado.Name='Test document.test';
            uda.documento_asociado.AuthorId = UserInfo.getUserId();
            uda.documento_asociado.IsPublic=true;
            uda.documento_asociado.Body = b;
            uda.crear();
        	uda.getnewcategories();
        	uda.refresh_data();
        //Fin Clase NEU_Import_Export_Quote_save_pdf
        test.stopTest();
    }
    //Metodo para la clase NEU_Purchase_Order_save_pdf
    @IsTest
    public static void NEU_Purchase_Order_save_pdf_test(){
        test.startTest();
          List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
          Account a = list_accounts[0];
          insert a;  
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
          insert supquote;
          NEU_Purchase_Order_save_pdf uda = new NEU_Purchase_Order_save_pdf(new ApexPages.StandardController( supquote ));
          Blob b = Blob.valueOf('Test Data');
          uda.documento_asociado.Name='Test document.test';
          uda.documento_asociado.AuthorId = UserInfo.getUserId();
          uda.documento_asociado.IsPublic=true;
          uda.documento_asociado.Body = b;
          uda.crear();
        test.stopTest();
    }
    //Metodo para la clase NEU_SP_Notifications_save_PDF
    @IsTest
    public static void NEU_SP_Notifications_save_PDF_test(){
        test.startTest();
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',
                                                                Total_Gross_Volume_m3__c  = 10, Total_Gross_Weight_Kg__c  = 10,
                                                                Number_of_Packages__c =10);
        insert ship_prog;
        NEU_SP_Notifications_save_PDF spg_t=new NEU_SP_Notifications_save_PDF(new ApexPages.StandardController( ship_prog ));
        Blob b = Blob.valueOf('Test Data');
        spg_t.documento_asociado.Name='Test document.test';
        spg_t.documento_asociado.AuthorId = UserInfo.getUserId();
        spg_t.documento_asociado.IsPublic=true;
        spg_t.documento_asociado.Body = b;
        spg_t.crear();
        spg_t.return_page();
        test.stopTest();
    }
}