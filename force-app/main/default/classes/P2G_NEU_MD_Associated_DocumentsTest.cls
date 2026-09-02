@IsTest(SeeAllData=true)
private class P2G_NEU_MD_Associated_DocumentsTest {
    
    private static void ejecutarController(Id recordId) {

        if (recordId == null) {
            return;
        }

        Test.setCurrentPage(
            new PageReference('/apex/NEU_MD_Associated_Documents')
        );

        ApexPages.currentPage().getParameters().put(
            'id',
            recordId
        );

        ApexPages.currentPage().getParameters().put(
            'id_obj',
            recordId
        );

        ApexPages.currentPage().getParameters().put(
            'url_int',
            '/test'
        );

        Test.startTest();

        NEU_MD_Associated_Documents controller =
            new NEU_MD_Associated_Documents();

        controller.getList_personal_documents();
        controller.getList_others_documents();

        Test.stopTest();
    }


    /*
     * ============================================================
     * ACCOUNT
     * ============================================================
     */
    @IsTest
    static void testAccountCoverage() {

        List<Account> records = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SHIPMENT
     * ============================================================
     */
    @IsTest
    static void testShipmentCoverage() {

        List<Shipment__c> records = [
            SELECT Id
            FROM Shipment__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * CLAIM
     * ============================================================
     */
    @IsTest
    static void testClaimCoverage() {

        List<Claim__c> records = [
            SELECT Id
            FROM Claim__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SHIPMENT CONSOLIDATION DATA
     * ============================================================
     */
    @IsTest
    static void testShipmentConsolidationDataCoverage() {

        List<Shipment_Consolidation_Data__c> records = [
            SELECT Id
            FROM Shipment_Consolidation_Data__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * TRANSPORT PACKAGING DATA
     * ============================================================
     */
    @IsTest
    static void testTransportPackagingCoverage() {

        List<Transport_Packaging_Data__c> records = [
            SELECT Id
            FROM Transport_Packaging_Data__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SUPPLY PROJECT
     * ============================================================
     */
    @IsTest
    static void testSupplyProjectCoverage() {

        List<Supply_Project__c> records = [
            SELECT Id
            FROM Supply_Project__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SHOPPING CART
     * ============================================================
     */
    @IsTest
    static void testShoppingCartCoverage() {

        List<Shopping_Cart__c> records = [
            SELECT Id
            FROM Shopping_Cart__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SUPPLIER QUOTE
     * ============================================================
     */
    @IsTest
    static void testSupplierQuoteCoverage() {

        List<Supplier_Quote__c> records = [
            SELECT Id
            FROM Supplier_Quote__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * CUSTOMER QUOTE
     * ============================================================
     */
    @IsTest
    static void testCustomerQuoteCoverage() {

        List<Customer_Quote__c> records = [
            SELECT Id
            FROM Customer_Quote__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SHIPMENT PROGRAM
     * ============================================================
     */
    @IsTest
    static void testShipmentProgramCoverage() {

        List<Shipment_Program__c> records = [
            SELECT Id
            FROM Shipment_Program__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * INVOICE
     * ============================================================
     */
    @IsTest
    static void testInvoiceCoverage() {

        List<Invoice__c> records = [
            SELECT Id
            FROM Invoice__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * SHIPMENT DISBURSEMENT
     * ============================================================
     */
    @IsTest
    static void testShipmentDisbursementCoverage() {

        List<Shipment_Disbursement__c> records = [
            SELECT Id
            FROM Shipment_Disbursement__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }


    /*
     * ============================================================
     * OPERADORES
     * ============================================================
     */
    @IsTest
    static void testOperadoresCoverage() {

        List<Operadores__c> records = [
            SELECT Id
            FROM Operadores__c
            LIMIT 1
        ];

        if (!records.isEmpty()) {
            ejecutarController(records[0].Id);
        }
    }
    
    private static Shipment__c getShipment() { List<Shipment__c> shipments = [ SELECT Id, Name, Account_for__c, Supplier_Account__c, Nature_Merchandise__c, Container_Type__c, Account_Shipment_Reference__c, CreatedBy.Email, LastModifiedBy.Email FROM Shipment__c LIMIT 1 ]; if (shipments.isEmpty()) { return null; } return shipments[0]; } /* * ============================================================ * CONSTRUCTOR * ============================================================ */ @IsTest static void testConstructor() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); ApexPages.currentPage().getParameters().put( 'id_obj', shipment.Id ); ApexPages.currentPage().getParameters().put( 'url_int', '/test/url' ); Test.startTest(); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); Test.stopTest(); String idCabecera = controller.id_cabecera; String urlBase = controller.url_base; String tipoObjeto = controller.tipo_objeto; String bucket = controller.Bucket_Name; String keyAmazon = controller.key; } /* * ============================================================ * GET LIST PERSONAL DOCUMENTS * * Incluye: * - Barras Logisticas * - Vale de Resguardo * ============================================================ */ @IsTest static void testGetListPersonalDocuments() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); ApexPages.currentPage().getParameters().put( 'id_obj', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); Test.startTest(); List<NEU_MD_Associated_Documents.others_document_s> documents = controller.getList_personal_documents(); Test.stopTest(); /* * Se recorren los documentos para ejecutar completamente * la construcción de others_document_s. */ if (documents != null) { for ( NEU_MD_Associated_Documents.others_document_s document : documents ) { String documentType = document.Document_Type; String documentDescription = document.Document_Description; String documentReference = document.Document_Reference; String documentTypeId = document.Document_Type_Id; Boolean alreadyExists = document.ya_hay_uno_del_mismo_tipo; } } } /* * ============================================================ * LISTA DE OTROS DOCUMENTOS * ============================================================ */ @IsTest static void testGetListOthersDocuments() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); Test.startTest(); List<NEU_MD_Associated_Documents.others_document_s> documents = controller.getList_others_documents(); Test.stopTest(); if (documents != null) { for ( NEU_MD_Associated_Documents.others_document_s document : documents ) { String type = document.Document_Type; String clase = document.clase_documento; String clase2 = document.clase_documento2; String typeId = document.Document_Type_Id; } } } /* * ============================================================ * CHECK NAMES - SIN ARCHIVO * ============================================================ */ @IsTest static void testCheckNamesWithoutFiles() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); controller.getList_personal_documents(); /* * checkNames() hace JSON.deserializeUntyped(), * por lo que debemos proporcionar JSON válido. */ controller.documentos_subir_name = '{}'; Test.startTest(); Boolean resultado = controller.checkNames(); Test.stopTest(); String resultadoTexto = String.valueOf(resultado); } /* * ============================================================ * CHECK NAMES - ARCHIVO * ============================================================ */ @IsTest static void testCheckNamesWithFile() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); controller.getList_personal_documents(); String tipoDocumento = null; for ( NEU_MD_Associated_Documents.others_document_s document : controller.List_personal_documents ) { if ( document.Document_Type == 'Barras Logisticas' || document.Document_Type == 'Vale de Resguardo' ) { document.documento_asociadoName = 'documento_prueba.pdf'; document.documento_asociado = Blob.valueOf('contenido'); tipoDocumento = document.Document_Type; break; } } if (tipoDocumento != null) { controller.documentos_subir_name = '{"' + tipoDocumento + '":"https://test.amazon.com/documento.pdf"}'; Test.startTest(); Boolean resultado = controller.checkNames(); Test.stopTest(); String resultadoTexto = String.valueOf(resultado); } } /* * ============================================================ * UPLOAD DOCUMENT * ============================================================ */ @IsTest static void testUploadDocument() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); ApexPages.currentPage().getParameters().put( 'id_obj', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); controller.getList_personal_documents(); String tipoDocumento = null; for ( NEU_MD_Associated_Documents.others_document_s document : controller.List_personal_documents ) { if ( document.Document_Type == 'Barras Logisticas' ) { document.documento_asociado = Blob.valueOf('contenido de prueba'); document.documento_asociadoName = 'barras_logisticas.pdf'; document.Document_Description = 'Documento de prueba'; document.Document_Reference = 'REF-001'; tipoDocumento = document.Document_Type; break; } } if (tipoDocumento != null) { controller.tipo_documento_id = tipoDocumento; controller.documentos_subir_name = '{"Barras Logisticas":"https://test.amazon.com/barra.pdf"}'; Test.startTest(); controller.Upload_Document(); Test.stopTest(); String tipoFinal = controller.tipo_documento_id; } } /* * ============================================================ * UPLOAD DOCUMENTS * ============================================================ */ @IsTest static void testUploadDocuments() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); ApexPages.currentPage().getParameters().put( 'id_obj', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); controller.getList_personal_documents(); controller.getList_others_documents(); String tipoDocumento = null; /* * Documento personal. */ for ( NEU_MD_Associated_Documents.others_document_s document : controller.List_personal_documents ) { if ( document.Document_Type == 'Barras Logisticas' ) { document.documento_asociado = Blob.valueOf('contenido de prueba'); document.documento_asociadoName = 'barra_logistica.pdf'; document.Document_Description = 'Barra logistica'; document.Document_Reference = 'REF-BARRA'; tipoDocumento = document.Document_Type; break; } } /* * Documento Other. */ if ( controller.List_others_documents != null && !controller.List_others_documents.isEmpty() ) { NEU_MD_Associated_Documents.others_document_s otherDoc = controller.List_others_documents[0]; otherDoc.documento_asociado = Blob.valueOf('otro documento'); otherDoc.documento_asociadoName = 'otro_documento.pdf'; otherDoc.Document_Description = 'Otro documento'; otherDoc.Document_Reference = 'REF-OTHER'; } if (tipoDocumento != null) { controller.documentos_subir_name = '{"Barras Logisticas":"https://test.amazon.com/barra.pdf",' + '"Other":"https://test.amazon.com/other.pdf"}'; } else { controller.documentos_subir_name = '{}'; } Test.startTest(); controller.Upload_Documents(); Test.stopTest(); String documentos = controller.documentos_subir_name; } /* * ============================================================ * CANCEL DOCUMENT * ============================================================ */ @IsTest static void testCancelDocument() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); Test.startTest(); PageReference page = controller.cancel_document(); Test.stopTest(); String url = page.getUrl(); Boolean redirect = page.getRedirect(); } /* * ============================================================ * POLICY * ============================================================ */ @IsTest static void testPolicies() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); Test.startTest(); String policy = controller.getPolicy(); String signedPolicy = controller.getSignedPolicy(); Test.stopTest(); String policyLength = String.valueOf(policy.length()); String signedPolicyLength = String.valueOf(signedPolicy.length()); } /* * ============================================================ * PROPIEDADES DISPLAY BUTTONS * ============================================================ */ @IsTest static void testDisplayButtons() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); String button1 = controller.display_buttons1; String button2 = controller.display_buttons2; controller.display_buttons1 = 'block'; controller.display_buttons2 = 'block'; String newButton1 = controller.display_buttons1; String newButton2 = controller.display_buttons2; } /* * ============================================================ * TEST CON DOCUMENTO EXISTENTE * * Busca un Associated_Document__c existente relacionado * con el Shipment seleccionado. * ============================================================ */ @IsTest static void testExistingAssociatedDocument() { Shipment__c shipment = getShipment(); if (shipment == null) { return; } List<Associated_Document__c> existingDocuments = [ SELECT Id, Name, Document_Type__c, Document_Description__c, Document_Reference__c, Shipment__c FROM Associated_Document__c WHERE Shipment__c = :shipment.Id LIMIT 1 ]; if (existingDocuments.isEmpty()) { return; } Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', shipment.Id ); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); Test.startTest(); controller.getList_personal_documents(); Test.stopTest(); if (controller.List_personal_documents != null) { for ( NEU_MD_Associated_Documents.others_document_s document : controller.List_personal_documents ) { String type = document.Document_Type; Boolean alreadyExists = document.ya_hay_uno_del_mismo_tipo; } } } /* * ============================================================ * ACCOUNT * * Cubre la rama Account de getList_personal_documents(). * ============================================================ */ @IsTest static void testAccount() { List<Account> accounts = [ SELECT Id, Name FROM Account LIMIT 1 ]; if (accounts.isEmpty()) { return; } Account account = accounts[0]; Test.setCurrentPage( new PageReference('/apex/NEU_MD_Associated_Documents') ); ApexPages.currentPage().getParameters().put( 'id', account.Id ); ApexPages.currentPage().getParameters().put( 'id_obj', account.Id ); Test.startTest(); NEU_MD_Associated_Documents controller = new NEU_MD_Associated_Documents(); controller.getList_personal_documents(); Test.stopTest(); if (controller.List_personal_documents != null) { for ( NEU_MD_Associated_Documents.others_document_s document : controller.List_personal_documents ) { String type = document.Document_Type; String description = document.Document_Description; } } }
}