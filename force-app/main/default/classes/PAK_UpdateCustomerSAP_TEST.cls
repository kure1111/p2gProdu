@isTest
public class PAK_UpdateCustomerSAP_TEST {

    // Clase interna para simular respuesta HTTP
    class PAK_MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"SUCCESS","message":"Mock response"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    
	@testSetup
    static void setupValidAccount() {
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        // Obtener un Account existente y válido
        Account acc = new Account(
        	Name = 'Prueba123',
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
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
            type = 'Prospect',
            CurrencyIsoCode = 'MXN',
            RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
            BillingCountry = 'MX',
            BillingState = 'Jalisco',
            BillingCity = 'Tlaquepaque',
            BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
            BillingPostalCode = '45615',
            Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
            Plaz_cta__c = 'Guadalajara',
            Requerimientos_Especiales__c = 'Sin servicio especial',
            Giro_Comercial__c = 'OTROS',
            Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
            Cliente_internacional__c = false,
            Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
            TipSocNeg_SAP__c = 'Privado',
            EjecCob_SAP__c = 'Test',
            Obsycom_cta__c = 'a1',
            Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
            CPNumero_Registro_de_ID__c = '990019',
            Website = 'www.salesforce.com',
            Usuario__c = 'testusuario123',
            Portal_de_Proveedores__c = 'www.salesforce.com',
            Contrasena__c = 'test123test'            
        );
		insert acc;
    }
    
    @isTest
    static void testSendWS_validAccount() {
        // Registrar el mock
        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
        Account getAcc = [SELECT Name, Tipo_de_Servicio_TNA__c, Inerep_cta__c, Acta_Constitutiva_Poder_Rep_Legal__c, Evidencia_de_Visita_del_Vendedor__c, Phone, Workplace__c, WCA_ID__c, 
                          Requiere_Evidencia__c, Tipo_de_Servicio_Prospecto__c, Requiere_Acuse_Sap__c, Tipo_de_Acuse_Sap__c, Grupo_SAP__c, Requiere_Orden_de_Compra__c, Credit_Terms__c, 
                          Monto_Credito_Solicitado__c, Credit_Limit__c, Tippag_cta__c, Forpag_cta__c, Uso_CFDI__c, Bank_Name_Supplier_Form2__c,Bank_Account_Number__c, Uso_Portal__c, 
                          Periodo_de_Facturacion__c, Fecha_Recepcion_Factura__c, Payment_Method__c, Venta_Sap__c, type, CurrencyIsoCode, RegFiscal_SAP__c, BillingCountry, BillingState,
                          BillingCity, BillingStreet, BillingPostalCode, Nombre_Contacto_Comercial__c, Plaz_cta__c, Requerimientos_Especiales__c, Giro_Comercial__c, Seguimiento_de_Pedido__c,
                          Cliente_internacional__c, Address_in_Sap__c, TipSocNeg_SAP__c, EjecCob_SAP__c, Obsycom_cta__c, Tipo_de_Servicio_Prospecto2__c, CPNumero_Registro_de_ID__c, Workplace_AccOwner__c 
                          FROM Account LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(getAcc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
    }
    
    @isTest
    static void testAccount_noEmail() {
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        // Obtener un Account sin email
        Account acc = new Account(
        	Name = 'PruebaCuentaContado',
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            Inerep_cta__c = true,
            Acta_Constitutiva_Poder_Rep_Legal__c = true,
            Evidencia_de_Visita_del_Vendedor__c = true,
            Phone = null,
            TAX_ID__c = null,
            Workplace__c = 'MTY',
            WCA_ID__c = '1234',
            Requiere_Evidencia__c = 'No',
            NEU_Email__c = null,
            Tipo_de_Servicio_Prospecto__c = 'FN - Flete Nacional',
            Requiere_Acuse_Sap__c = 'Si',
            Tipo_de_Acuse_Sap__c = 'Fisico',
            Grupo_SAP__c = 'Fletes P',
            Requiere_Orden_de_Compra__c = true,
            Credit_Terms__c = '30 Días',
            //Monto_Credito_Solicitado__c = 1000.00,
            //Credit_Limit__c = 100000.00,
            Tippag_cta__c = 'Contado',
            Forpag_cta__c = null,
            Uso_CFDI__c = null,
            //Bank_Name_Supplier_Form2__c = 'BancoTest',
            //Bank_Account_Number__c = '123456789012345678',
            Uso_Portal__c = true,
            Periodo_de_Facturacion__c = 'Todo el mes',
            Fecha_Recepcion_Factura__c = Date.newInstance(2024, 2, 7),
            Payment_Method__c = null, 
            Venta_Sap__c = 'Contado',
            type = 'Prospect',
            CurrencyIsoCode = 'MXN',
            RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
            BillingCountry = 'MX',
            BillingState = 'Jalisco',
            BillingCity = 'Tlaquepaque',
            BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
            BillingPostalCode = '45615',
            Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
            Plaz_cta__c = 'Guadalajara',
            Requerimientos_Especiales__c = 'Sin servicio especial',
            Giro_Comercial__c = 'OTROS',
            Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
            Cliente_internacional__c = false,
            Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
            TipSocNeg_SAP__c = 'Privado',
            EjecCob_SAP__c = 'Test',
            Obsycom_cta__c = 'a1',
            Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
            CPNumero_Registro_de_ID__c = '990019',
            Website = 'www.salesforce.com',
            Usuario__c = 'testusuario123',
            Portal_de_Proveedores__c = 'www.salesforce.com',
            Contrasena__c = 'test123test'            
        );
		insert acc;
        
        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }
    
    @isTest
    static void testSetup_noTaxId() {
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        // Obtener un Account sin TAX_ID__c
        Account acc = new Account(
        	Name = 'PruebaSinTaxId',
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            Inerep_cta__c = true,
            Acta_Constitutiva_Poder_Rep_Legal__c = true,
            Evidencia_de_Visita_del_Vendedor__c = true,
            Phone = null,
            //TAX_ID__c = 'CMTY12345678',
            Workplace__c = 'MTY',
            WCA_ID__c = '1234',
            Requiere_Evidencia__c = 'No',
            NEU_Email__c = 'emailprueba@test.com',
            //Tipo_de_Servicio_Prospecto__c = 'FN - Flete Nacional',
            Requiere_Acuse_Sap__c = 'Si',
            Tipo_de_Acuse_Sap__c = 'Fisico',
            Grupo_SAP__c = 'Fletes P',
            Requiere_Orden_de_Compra__c = true,
            //Credit_Terms__c = '30 Días',
            //Monto_Credito_Solicitado__c = 1000.00,
            Credit_Limit__c = 100000.00,
            //Tippag_cta__c = 'Credito',
            Forpag_cta__c = '',
            //Uso_CFDI__c = 'Por Definir',
            //Bank_Name_Supplier_Form2__c = 'BancoTest',
            //Bank_Account_Number__c = '123456789012345678',
            Uso_Portal__c = true,
            Periodo_de_Facturacion__c = 'Todo el mes',
            Fecha_Recepcion_Factura__c = Date.newInstance(2024, 2, 7),
            //Payment_Method__c = 'PPD- PAGO EN PARCIALIDADES', 
            Venta_Sap__c = 'Credito',
            type = 'Prospect',
            CurrencyIsoCode = 'MXN',
            RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
            //BillingCountry = 'MX',
            //BillingState = 'Jalisco',
            //BillingCity = 'Tlaquepaque',
            //BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
            //BillingPostalCode = '45615',
            Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
            Plaz_cta__c = 'Guadalajara',
            Requerimientos_Especiales__c = 'Sin servicio especial',
            Giro_Comercial__c = 'OTROS',
            Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
            Cliente_internacional__c = false,
            Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
            TipSocNeg_SAP__c = 'Privado',
            EjecCob_SAP__c = 'Test',
            Obsycom_cta__c = 'a1',
            //Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
            CPNumero_Registro_de_ID__c = '990019',
            //Website = 'www.salesforce.com',
            Usuario__c = 'testusuario123',
            Portal_de_Proveedores__c = 'www.salesforce.com',
            Contrasena__c = 'test123test'            
        );
		insert acc;
        
        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }
    
    @isTest
    static void testAccountContado_WcaNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'CuentaGlobalContado',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            Inerep_cta__c = true,
            Acta_Constitutiva_Poder_Rep_Legal__c = true,
            Evidencia_de_Visita_del_Vendedor__c = true,
            //Phone = null,
            //TAX_ID__c = 'CMTY12345678',
            Workplace__c = 'GLOBAL',
            //WCA_ID__c = '1234',
            Requiere_Evidencia__c = 'No',
            //NEU_Email__c = 'emailprueba@test.com',
            Tipo_de_Servicio_Prospecto__c = 'FN - Flete Nacional',
            Requiere_Acuse_Sap__c = 'Si',
            Tipo_de_Acuse_Sap__c = 'Fisico',
            Grupo_SAP__c = 'Fletes P',
            Requiere_Orden_de_Compra__c = true,
            Credit_Terms__c = '30 Días',
            Monto_Credito_Solicitado__c = 1000.00,
            Credit_Limit__c = 100000.00,
            Tippag_cta__c = 'Contado',
            //Forpag_cta__c = '99 - OTROS',
            //Uso_CFDI__c = 'Por Definir',
            //Bank_Name_Supplier_Form2__c = 'BancoTest',
            //Bank_Account_Number__c = '123456789012345678',
            Uso_Portal__c = true,
            Periodo_de_Facturacion__c = 'Todo el mes',
            Fecha_Recepcion_Factura__c = Date.newInstance(2024, 2, 7),
            //Payment_Method__c = 'PPD- PAGO EN PARCIALIDADES', 
            Venta_Sap__c = 'Credito',
            type = 'Prospect',
            CurrencyIsoCode = 'MXN',
            RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
            BillingCountry = 'MX',
            BillingState = 'Jalisco',
            BillingCity = 'Tlaquepaque',
            BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
            BillingPostalCode = '45615',
            Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
            Plaz_cta__c = 'Guadalajara',
            Requerimientos_Especiales__c = 'Sin servicio especial',
            Giro_Comercial__c = 'OTROS',
            Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
            Cliente_internacional__c = false,
            Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
            TipSocNeg_SAP__c = 'Privado',
            EjecCob_SAP__c = 'Test',
            Obsycom_cta__c = 'a1',
            Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
            CPNumero_Registro_de_ID__c = '990019',
            Website = 'www.salesforce.com',
            Usuario__c = 'testusuario123',
            Portal_de_Proveedores__c = 'www.salesforce.com',
            Contrasena__c = 'test123test'            
        );
		insert acc;
        
        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }

    @isTest
    static void testAccountCredito_WcaNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'PruebaCuentaWcaNullCredito',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            Inerep_cta__c = true,
            Acta_Constitutiva_Poder_Rep_Legal__c = true,
            Evidencia_de_Visita_del_Vendedor__c = true,
            //Phone = null,
            TAX_ID__c = '123',
            Workplace__c = 'GLOBAL',
            //WCA_ID__c = '1234',
            Requiere_Evidencia__c = 'No',
            //NEU_Email__c = 'emailprueba@test.com',
            Tipo_de_Servicio_Prospecto__c = 'FN - Flete Nacional',
            Requiere_Acuse_Sap__c = 'Si',
            Tipo_de_Acuse_Sap__c = 'Fisico',
            Grupo_SAP__c = 'Fletes P',
            Requiere_Orden_de_Compra__c = true,
            Credit_Terms__c = '30 Días',
            Monto_Credito_Solicitado__c = 1000.00,
            Credit_Limit__c = 100000.00,
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = null,
            //Uso_CFDI__c = 'Por Definir',
            //Bank_Name_Supplier_Form2__c = 'BancoTest',
            //Bank_Account_Number__c = '123456789012345678',
            Uso_Portal__c = true,
            Periodo_de_Facturacion__c = 'Todo el mes',
            Fecha_Recepcion_Factura__c = Date.newInstance(2024, 2, 7),
            Payment_Method__c = null, 
            Venta_Sap__c = 'Credito',
            type = 'Prospect',
            CurrencyIsoCode = 'MXN',
            RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
            BillingCountry = 'MX',
            BillingState = 'Jalisco',
            BillingCity = 'Tlaquepaque',
            BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
            BillingPostalCode = '45615',
            Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
            Plaz_cta__c = 'Guadalajara',
            Requerimientos_Especiales__c = 'Sin servicio especial',
            Giro_Comercial__c = 'OTROS',
            Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
            Cliente_internacional__c = false,
            Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
            TipSocNeg_SAP__c = 'Privado',
            EjecCob_SAP__c = 'Test',
            Obsycom_cta__c = 'a1',
            Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
            CPNumero_Registro_de_ID__c = '990019',
            Website = 'www.salesforce.com',
            Usuario__c = 'testusuario123',
            Portal_de_Proveedores__c = 'www.salesforce.com',
            Contrasena__c = 'test123test'            
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
		System.debug(acc);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }

    @isTest
    static void TestAccountCredito_ForPagNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'AccountPaymentNull',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            TAX_ID__c = null,
            Workplace__c = 'GLOBAL',
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = null,
            Payment_Method__c = null, 
            Venta_Sap__c = 'Credito',
            type = 'Prospect'          
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
		System.debug(acc);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }

    @isTest
    static void TestAccountCredito_PaymentNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'PruebaCuentaWcaNullCredito',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            TAX_ID__c = '123',
            Workplace__c = 'GLOBAL',
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = 'Credito',
            Payment_Method__c = null, 
            Venta_Sap__c = 'Credito',
            Uso_CFDI__c = null,
            type = 'Prospect'          
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }

    @isTest
    static void TestAccountCredito_CfdiNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'PruebaCuentaCfdiNull',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            TAX_ID__c = '123',
            Workplace__c = 'GLOBAL',
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = 'Credito',
            Payment_Method__c = 'Plazos', 
            Venta_Sap__c = 'Credito',
            Uso_CFDI__c = null,
            type = 'Prospect'          
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }    
    
    @isTest
    static void TestAccountCredito_BankSuppNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'PruebaCuentaBankSuppNull',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            TAX_ID__c = '123',
            Workplace__c = 'GLOBAL',
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = 'Credito',
            Payment_Method__c = 'Plazos', 
            Venta_Sap__c = 'Credito',
            Uso_CFDI__c = 'No',
            type = 'Prospect',
            Bank_Name_Supplier_Form2__c = null
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
		System.debug(acc);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }    

    @isTest
    static void TestAccountCredito_PhoneNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'PruebaCuentaPhoneNull',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            TAX_ID__c = '123',
            Workplace__c = 'GLOBAL',
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = 'Credito',
            Payment_Method__c = 'Plazos', 
            Venta_Sap__c = 'Credito',
            Uso_CFDI__c = 'No',
            type = 'Prospect',
            Bank_Name_Supplier_Form2__c = 'testBank',
            Phone = null            
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
		System.debug(acc);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }        

    @isTest
    static void TestAccountCredito_EmailNull() {
        // Usuario owner con workplace GLOBAL
        User u = [SELECT Id, Workplace__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Workplace__c = 'GLOBAL';
        update u;
        // Obtener service type
    	SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        //Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert servicioSAP;
        Account acc = new Account(
        	Name = 'PruebaCuentaPhoneNull',
            OwnerId = u.Id,
            Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            TAX_ID__c = '123',
            Workplace__c = 'GLOBAL',
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = 'Credito',
            Payment_Method__c = 'Plazos', 
            Venta_Sap__c = 'Credito',
            Uso_CFDI__c = 'No',
            type = 'Prospect',
            Bank_Name_Supplier_Form2__c = 'testBank',
            Phone = '123',
            NEU_Email__c = null			            
        );
		insert acc;

        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse()); 
		System.debug(acc);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        //controller.byPass();
        Test.stopTest();
        
    }        

}