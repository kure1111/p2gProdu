@isTest(SeeAllData=true)
public class PAK_INV_Ctr_Test {
    
    private static Invoice__c getExistingInvoice() {
        return [SELECT Id, Account__c, Account__r.Customer_id__c, Account__r.Owner.Workplace__c,
                       Account__r.Requiere_Acuse_Sap__c, Shipment__c, Shipment__r.Name,
                       Shipment__r.Service_Type__c, Shipment__r.Service_Mode__c,
                       Shipment__r.Freight_Mode__c, Shipment__r.Folios_para_Facturar__c,
                       Shipment__r.MBL_Number__c, Shipment__r.MAWB_Number__c,
                       Shipment__r.Traslado_Ingreso__c, Shipment__r.Shipment_Type__c,
                       CurrencyIsoCode, Total_Excl_VAT__c, Total_Incl_VAT__c,
                       Cfdi_Number__c, Invoice_Status__c
                FROM Invoice__c 
                WHERE Account__c != null AND Shipment__c != null 
                AND Invoice_Status__c != null
                LIMIT 1];
    }
    
    private static Invoice_Line__c getExistingInvoiceLine(Id invoiceId) {
        List<Invoice_Line__c> lines = [SELECT Id, Units__c, Unit_Price__c, Unit_Price_SAP__c,
                                      VAT__c, Sujeto_a_Ret__c, Total_Incl_VAT__c,
                                      Concept__c, SAP_Service_Type__c, IL_SapServiceType_Code__c,
                                      Numero_Linea__c, Shipment_Service_Line__c
                                      FROM Invoice_Line__c 
                                      WHERE Invoice__c = :invoiceId LIMIT 1];
        return lines.isEmpty() ? null : lines[0];
    }
    
    @isTest
    static void testConstructor() {
        Invoice__c inv = getExistingInvoice();
        ApexPages.StandardController std = new ApexPages.StandardController(inv);
        PAK_INV_Ctr ctr = new PAK_INV_Ctr(std);
    }
    
    @isTest
    static void testCancelar() {
        Invoice__c inv = getExistingInvoice();
        ApexPages.StandardController std = new ApexPages.StandardController(inv);
        PAK_INV_Ctr ctr = new PAK_INV_Ctr(std);
        PageReference result = ctr.Cancelar();
    }
    
    @isTest
    static void testSendShipment() {
        Invoice__c inv = getExistingInvoice();
        ApexPages.StandardController std = new ApexPages.StandardController(inv);
        PAK_INV_Ctr ctr = new PAK_INV_Ctr(std);
        PageReference result = ctr.SendShipment();
    }
    
    @isTest
    static void testSend() {
        Invoice__c inv = getExistingInvoice();
        Invoice_Line__c line = getExistingInvoiceLine(inv.Id);
        
        if (line != null) {
            ApexPages.StandardController std = new ApexPages.StandardController(inv);
            PAK_INV_Ctr ctr = new PAK_INV_Ctr(std);
            PageReference result = ctr.Send();
        }
    }
    
    @isTest
    static void testSendSPtoSAPFromTrigger() {
        Invoice__c inv = getExistingInvoice();
        PAK_INV_Ctr ctr = new PAK_INV_Ctr(new ApexPages.StandardController(inv));
        ctr.SendSPtoSAPFromTrigger(inv.Id);
    }
    
    @isTest
    static void testSendInvoiceToSAPFromTrigger() {
        Invoice__c inv = getExistingInvoice();
        Test.startTest();
        PAK_INV_Ctr.SendInvoiceToSAPFromTrigger(inv.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testGetInvoiceByID() {
        Invoice__c inv = getExistingInvoice();
        Invoice__c result = PAK_INV_Ctr.getInvoiceByID(inv.Id);
    }
    
    @isTest
    static void testBuildBodyInvoiceToSAP() {
        Invoice__c inv = getExistingInvoice();
        String body = PAK_INV_Ctr.buildBODyInvoiceToSAP(inv, inv.Id);
    }
    
    @isTest
    static void testValidacion() {
        Invoice__c inv = getExistingInvoice();
        String result = PAK_INV_Ctr.validacion(inv.Id);
    }
    
    @isTest
    static void testCallInvoiceSendToSAPService() {
        Invoice__c inv = getExistingInvoice();
        String body = PAK_INV_Ctr.buildBODyInvoiceToSAP(inv, inv.Id);
        if (body != null) {
            HttpResponse response = PAK_INV_Ctr.callInvoiceSendToSAPService(body);
        }
        PAK_INV_Ctr.byPass();
    }
}