@isTest
public class P2G_crearQuotePDFTest {

	@testSetup
	public static void setup() {
        Account acc = new Account(
                Name = 'Cliente de Prueba',
                //Tipo_de_Servicio_TNA__c = servicioSAP.Id,
                Inerep_cta__c = true,
                Acta_Constitutiva_Poder_Rep_Legal__c = true,
                Evidencia_de_Visita_del_Vendedor__c = true,
                Phone = '1231234123',
                TAX_ID__c = 'CMTY12345678',
                Workplace__c = 'MTY',
                WCA_ID__c = '1234',
                Requiere_Evidencia__c = 'No',
                NEU_Email__c = 'emailprueba@test.com',
                Tipo_de_Servicio_Prospecto__c = 'FN - Flete Nacional',
                Requiere_Acuse_Sap__c = 'Si',
                Tipo_de_Acuse_Sap__c = 'Fisico',
                Grupo_SAP__c = 'Fletes P',
                Requiere_Orden_de_Compra__c = true,
                Credit_Terms__c = '30 Días',
                Monto_Credito_Solicitado__c = 1000.00,
                Credit_Limit__c = 100000.00,
                Tippag_cta__c = 'Credito',
                Forpag_cta__c = '99 - OTROS',
                Uso_CFDI__c = 'Por Definir',
                Bank_Name_Supplier_Form2__c = 'BancoTest',
                Bank_Account_Number__c = '123456789012345678',
                Uso_Portal__c = true,
                Periodo_de_Facturacion__c = 'Todo el mes',
                Fecha_Recepcion_Factura__c = Date.newInstance(2024, 2, 7),
                Payment_Method__c = 'PPD- PAGO EN PARCIALIDADES',
                Venta_Sap__c = 'Credito',
                Type = 'Customer',
                CurrencyIsoCode = 'MXN',
                RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
                BillingCountry = 'MX',
                BillingState = 'Jalisco',
                BillingCity = 'Tlaquepaque',
                BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
                BillingPostalCode = '45615',
                ShippingStreet = 'Shipping Street Prueba',
                ShippingCity = 'Shipping City Prueba',
                ShippingPostalCode = '12341',
                ShippingState = 'Shipping State Prueba',
                ShippingCountry = 'Mexico',
                Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
                Plaz_cta__c = 'Guadalajara',
                Requerimientos_Especiales__c = 'Sin servicio especial',
                Giro_Comercial__c = 'OTROS',
                Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
                Cliente_internacional__c = false,
                Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
                TipSocNeg_SAP__c = 'Privado',
                EjecCob_SAP__c = 'Test',
                //Obsycom_cta__c = 'a1',
                Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
                CPNumero_Registro_de_ID__c = '990019',
                Website = 'www.salesforce.com',
                //Usuario__c = 'testusuario123',
                Portal_de_Proveedores__c = 'www.salesforce.com',
                Contrasena__c = 'test123test'
    	);
		insert acc;

    Contact con = new Contact(
        FirstName = 'Contacto',
        LastName = 'Prueba',
        Email = 'contacto@test.com',
        Phone = '5555555555',
        AccountId = acc.Id
    );
    insert con;

    Id standardPricebookId = Test.getStandardPricebookId();

    Product2 product = new Product2(
        Name = 'Guadalajara - Mexico',
        Family = 'Route',
        PROJ_Modalidad__c = 'Caja 53 FT',
        IsActive = true
    );
    insert product;

    PricebookEntry standardPbe = new PricebookEntry(
        Product2Id = product.Id,
        Pricebook2Id = standardPricebookId,
        UseStandardPrice = false,
        UnitPrice = 2222,
        IsActive = true
    );
    insert standardPbe;

    String typeOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standar Opportunity').getRecordTypeId();

    Opportunity opp = new Opportunity(
        RecordTypeId = typeOpp,
        Name = 'Oportunidad test',
        AccountId = acc.Id,
        Service_Type__c = 'FN',
        Group__c = 'SP-FN-FLETE NACIONAL',
        StageName = 'Potencial',
        CloseDate = Date.today().addDays(30),
        CurrencyIsoCode = 'MXN',
        Pricebook2Id = standardPricebookId
    );
    insert opp;

    Quote quote = new Quote(
        Name = 'Prueba',
        OpportunityId = opp.Id,
        Pricebook2Id = standardPricebookId,
        ContactId = con.Id,
        Status = 'Accepted',
        PDF_Enviado__c = true,
        Vendido__c = true
    );
    insert quote;

    QuoteLineItem qli = new QuoteLineItem(
        QuoteId = quote.Id,
        PricebookEntryId = standardPbe.Id,
        Quantity = 1,
        UnitPrice = 2222
    );
    insert qli;
}

@isTest
public static void main() {

    Quote quote = [SELECT Id, Name, Status, PDF_Enviado__c, Vendido__c FROM Quote WHERE Name = 'Prueba' LIMIT 1];

    PageReference pageRef = Page.P2G_crearQuotePDF;

    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc =new ApexPages.StandardController(quote);

    Test.startTest();

    P2G_crearQuotePDF crearQuotePDF = new P2G_crearQuotePDF(sc);

    Test.stopTest();
	}
}