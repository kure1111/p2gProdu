@isTest
public class P2G_PAK_UAccount_ServiceTest {
    
    
    @isTest(seeAllData=true)
    static void testUAccountCrearNuevoCliente() {
        // Obtener IDs de RecordType
        String clienteRTId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' LIMIT 1].Id;
        String ownerId = [SELECT Id FROM User WHERE IsActive = true AND SalesEmployer__c != null LIMIT 1].Id;
        User testUser = [SELECT Id, SalesEmployer__c FROM User WHERE Id = :ownerId LIMIT 1];
        
        // Crear UAccount para nuevo cliente
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'TEST-CLI-';
        uacc.idSFField = null; // Nuevo registro
        uacc.Status_Account = '1'; // Activo
        uacc.Name = 'Cliente Test Creación';
        uacc.Brand_Name = 'Marca Test';
        uacc.Tax_id = 'TAX123456789';
        uacc.Phone = '5555555555';
        uacc.Email = 'cliente.test@test.com';
        uacc.Tipo_de_pago = 'Crédito';
        uacc.Forma_de_pago = 'Transferencia';
        uacc.Credits_terms = '30 días';
        uacc.Acuse = 'Si';
        uacc.ReqOrdenCompra = '1'; // Requiere OC
        uacc.SalesEmployer = testUser.SalesEmployer__c;
        uacc.Credit_Limit = '100000.00';
        uacc.Direccion = 'Calle Principal #123, Colonia Centro';
        uacc.Anticipo = 'No';
        uacc.Authorized_credit = '1'; // Autorizado
        uacc.Tipo_Acuse = 'Asignar';
        uacc.Venta = 'Si';
        uacc.RecordType = 'CLIENTE';
        uacc.Source_Account = 'SAP';
        uacc.UserNameSAP = 'USER001';
        uacc.MotivoInactivo = '';
        uacc.CodigoPostal = '12345';
        uacc.Ciudad = 'Ciudad de México';
        uacc.Estado = 'CDMX';
        uacc.Pais = 'México';
        uacc.Street = 'Calle Principal #123';
        uacc.SolicitadoPor = 'Juan Pérez';
        uacc.CarrierEmail = 'carrier@test.com';
        uacc.WorkPlace = 'Oficinas Centrales';
        uacc.Banco = 'Banco Test';
        uacc.Clabe = '123456789012345678';
        uacc.PaisBanco = 'México';
        uacc.BancoSup = 'Banco Superior';
        uacc.CuentaBanco = '1234567890';
        uacc.Comentarios = 'Comentarios de prueba';
        uacc.Unidades = 'Unidad 1;Unidad 2';
        uacc.GrupoSap = 'GRP-001';
        uacc.CuentaEspejo = '1'; // True
        uacc.Gps = '1'; // True
        uacc.Vetado = '0'; // False
        uacc.ReportaVetado = 'No';
        uacc.Estatus = 'En Proceso';
        uacc.currencyIsoCode = 'MXN';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountCrearNuevoCliente: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountCrearNuevoProveedor() {
        // Obtener IDs de RecordType
        String proveedorRTId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Transporter' LIMIT 1].Id;
        String ownerId = [SELECT Id FROM User WHERE IsActive = true AND SalesEmployer__c != null LIMIT 1].Id;
        User testUser = [SELECT Id, SalesEmployer__c FROM User WHERE Id = :ownerId LIMIT 1];
        
        // Crear UAccount para nuevo proveedor
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'TEST-PROV';
        uacc.idSFField = null; // Nuevo registro
        uacc.Status_Account = '1'; // Activo
        uacc.Name = 'Proveedor Test Creación';
        uacc.Brand_Name = 'Marca Proveedor';
        uacc.Tax_id = 'TAX987654321';
        uacc.Phone = '5555555555';
        uacc.Email = 'proveedor.test@test.com';
        uacc.Tipo_de_pago = 'Contado';
        uacc.Forma_de_pago = 'Cheque';
        uacc.Credits_terms = '15 días';
        uacc.Acuse = 'No';
        uacc.ReqOrdenCompra = '0'; // No requiere OC
        uacc.SalesEmployer = testUser.SalesEmployer__c;
        uacc.Credit_Limit = '50000.00';
        uacc.Direccion = 'Avenida Principal #456, Colonia Industrial';
        uacc.Anticipo = 'Si';
        uacc.Authorized_credit = '0'; // No autorizado
        uacc.Tipo_Acuse = 'Si';
        uacc.Venta = 'No';
        uacc.RecordType = 'PROVEEDOR';
        uacc.Source_Account = 'Manual';
        uacc.UserNameSAP = 'USER002';
        uacc.MotivoInactivo = '';
        uacc.CodigoPostal = '67890';
        uacc.Ciudad = 'Guadalajara';
        uacc.Estado = 'Jalisco';
        uacc.Pais = 'México';
        uacc.Street = 'Avenida Principal #456';
        uacc.SolicitadoPor = 'María García';
        uacc.CarrierEmail = 'proveedor.carrier@test.com';
        uacc.WorkPlace = 'Planta Guadalajara';
        uacc.Banco = 'Banco Provincial';
        uacc.Clabe = '987654321098765432';
        uacc.PaisBanco = 'México';
        uacc.BancoSup = 'Banco Nacional';
        uacc.CuentaBanco = '9876543210';
        uacc.Comentarios = 'Proveedor de servicios logísticos';
        uacc.Unidades = 'Unidad A;Unidad B;Unidad C';
        uacc.GrupoSap = 'GRP-002';
        uacc.CuentaEspejo = '0'; // False
        uacc.Gps = '0'; // False
        uacc.Vetado = '0'; // False
        uacc.ReportaVetado = 'No';
        uacc.Estatus = 'Aprobado';
        uacc.currencyIsoCode = 'USD';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountCrearNuevoProveedor: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountActualizarClienteExistente() {
        // Crear una cuenta primero para luego actualizarla
        Account testAccount = new Account(
            Name = 'Cliente Original',
            Customer_id__c = 'UPD-CLI-',
            ActiveSap__c = true,
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' LIMIT 1].Id
        );
        insert testAccount;
        
        String ownerId = [SELECT Id FROM User WHERE IsActive = true AND SalesEmployer__c != null LIMIT 1].Id;
        User testUser = [SELECT Id, SalesEmployer__c FROM User WHERE Id = :ownerId LIMIT 1];
        
        // Crear UAccount para actualizar
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = testAccount.Customer_id__c;
        uacc.idSFField = testAccount.Id;
        uacc.Status_Account = '0'; // Inactivo
        uacc.Name = 'Cliente Actualizado';
        uacc.Brand_Name = 'Marca Actualizada';
        uacc.Tax_id = 'TAX-UPD-123';
        uacc.Phone = '5555555555';
        uacc.Email = 'actualizado@test.com';
        uacc.Tipo_de_pago = 'Contado';
        uacc.Forma_de_pago = 'Efectivo';
        uacc.Credits_terms = '60 días';
        uacc.Acuse = 'No';
        uacc.ReqOrdenCompra = '0';
        uacc.SalesEmployer = testUser.SalesEmployer__c;
        uacc.Credit_Limit = '200000.00';
        uacc.Direccion = 'Nueva Dirección #789';
        uacc.Anticipo = 'Si';
        uacc.Authorized_credit = '1';
        uacc.Tipo_Acuse = 'No';
        uacc.Venta = 'Asignar';
        uacc.RecordType = 'CLIENTE';
        uacc.UserNameSAP = 'USER-UPD';
        uacc.MotivoInactivo = 'Cambio de razón social';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountActualizarClienteExistente: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountActualizarProveedorExistente() {
        // Crear un proveedor primero para luego actualizarlo
        Account testProvider = new Account(
            Name = 'Proveedor Original',
            Customer_id__c = 'UPD-PROV-',
            ActiveSap__c = true,
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Transporter' LIMIT 1].Id
        );
        insert testProvider;
        
        String ownerId = [SELECT Id FROM User WHERE IsActive = true AND SalesEmployer__c != null LIMIT 1].Id;
        User testUser = [SELECT Id, SalesEmployer__c FROM User WHERE Id = :ownerId LIMIT 1];
        
        // Crear UAccount para actualizar
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = testProvider.Customer_id__c;
        uacc.idSFField = testProvider.Id;
        uacc.Status_Account = '0'; // Inactivo
        uacc.Name = 'Proveedor Actualizado';
        uacc.Brand_Name = 'Marca Prov Actualizada';
        uacc.Tax_id = 'TAX-PROV-789';
        uacc.Phone = '5555555555';
        uacc.Email = 'proveedor.act@test.com';
        uacc.Tipo_de_pago = 'Crédito';
        uacc.Forma_de_pago = 'Transferencia';
        uacc.Credits_terms = '30 días';
        uacc.SalesEmployer = testUser.SalesEmployer__c;
        uacc.Credit_Limit = '150000.00';
        uacc.Banco = 'Banco Nuevo';
        uacc.Clabe = '123450987654321098';
        uacc.CuentaBanco = '1122334455';
        uacc.Comentarios = 'Proveedor actualizado';
        uacc.Estatus = 'Modificado';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountActualizarProveedorExistente: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountConCamposMinimos() {
        // Probar con campos mínimos
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'MIN-';
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente Campos Mínimos';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConCamposMinimos: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountConCamposNulos() {
        // Probar con campos nulos (solo campos obligatorios)
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'NULL-';
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente Campos Nulos';
        uacc.SalesEmployer = null;
        uacc.Credit_Limit = null;
        uacc.Direccion = null;
        uacc.CodigoPostal = null;
        uacc.Ciudad = null;
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConCamposNulos: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountConSalesEmployerInvalido() {
        // Probar con SalesEmployer que no existe
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'INV-SALES-';
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente SalesEmployer Inválido';
        uacc.SalesEmployer = 'EMP-NO-EXISTE-12345';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConSalesEmployerInvalido: ' + results);
    }
    /*
    @isTest(seeAllData=true)
    static void testUAccountConRecordTypeInvalido() {
        // Probar con RecordType inválido
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'INV-RT-' + System.currentTimeMillis();
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente RT Inválido';
        uacc.RecordType = 'INVALIDO'; // No es CLIENTE ni PROVEEDOR
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConRecordTypeInvalido: ' + results);
    }
    */
    @isTest(seeAllData=true)
    static void testUAccountMultiplesRegistros() {
        // Probar con múltiples registros
        String ownerId = [SELECT Id FROM User WHERE IsActive = true AND SalesEmployer__c != null LIMIT 1].Id;
        User testUser = [SELECT Id, SalesEmployer__c FROM User WHERE Id = :ownerId LIMIT 1];
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>();
        
        // Primer registro - Cliente
        PAK_Update_ACC.UAccount uacc1 = new PAK_Update_ACC.UAccount();
        uacc1.Customer_id = 'MULTI-1-';
        uacc1.Status_Account = '1';
        uacc1.Name = 'Cliente Multi 1';
        uacc1.RecordType = 'CLIENTE';
        uacc1.SalesEmployer = testUser.SalesEmployer__c;
        uacc1.Email = 'cliente1@test.com';
        uaccList.add(uacc1);
        
        // Segundo registro - Proveedor
        PAK_Update_ACC.UAccount uacc2 = new PAK_Update_ACC.UAccount();
        uacc2.Customer_id = 'MULTI-2-';
        uacc2.Status_Account = '1';
        uacc2.Name = 'Proveedor Multi 2';
        uacc2.RecordType = 'PROVEEDOR';
        uacc2.SalesEmployer = testUser.SalesEmployer__c;
        uacc2.Email = 'proveedor2@test.com';
        uacc2.Banco = 'Banco Multi';
        uacc2.Clabe = '1111222233334444';
        uaccList.add(uacc2);
        
        // Tercer registro - Otro cliente
        PAK_Update_ACC.UAccount uacc3 = new PAK_Update_ACC.UAccount();
        uacc3.Customer_id = 'MULTI-3-' + System.currentTimeMillis();
        uacc3.Status_Account = '0'; // Inactivo
        uacc3.Name = 'Cliente Multi 3 Inactivo';
        uacc3.RecordType = 'CLIENTE';
        uacc3.SalesEmployer = testUser.SalesEmployer__c;
        uacc3.MotivoInactivo = 'Cliente inactivo por prueba';
        uaccList.add(uacc3);
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountMultiplesRegistros: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountConValoresExtremos() {
        // Probar con valores extremos
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'EXTREME-';
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente con nombre extremadamente largo para probar los límites del campo de nombre ' +
                    'que debe ser bastante extenso y superar los límites normales';
        uacc.Brand_Name = 'Marca con nombre muy largo para probar límites de campo';
        uacc.Email = 'correo.muy.largo@dominioextremadamenteextenso.com.mx';
        uacc.Credit_Limit = '999999999.99';
        uacc.Direccion = 'Calle Extremadamente Larga #9999, Colonia Super Larga, ' +
                         'Delegación Muy Extensa, Código Postal 123456, Ciudad de México, México';
        uacc.Comentarios = 'Este es un comentario extremadamente largo que se utiliza para probar los límites ' +
                          'del campo de comentarios en el objeto UAccount. '.repeat(5);
        uacc.Clabe = '12345678901234567890'; // CLABE larga
        uacc.Unidades = 'Unidad 1;Unidad 2;Unidad 3;Unidad 4;Unidad 5;Unidad 6;Unidad 7;Unidad 8;Unidad 9;Unidad 10';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConValoresExtremos: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountConCaracteresEspeciales() {
        // Probar con caracteres especiales
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = 'SPECIAL-';
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente con ñ & áéíóú ü ¡¿?';
        uacc.Brand_Name = 'Marca # $ % & @';
        uacc.Tax_id = 'RFC-&-123-Ñ';
        uacc.Email = 'cliente+test@correo.com.mx';
        uacc.Direccion = 'Calle #123, Colonia "Las Rosas" - Fracc. Los Pinos';
        uacc.Comentarios = 'Comentarios con caracteres especiales: ¡Hola! ¿Cómo estás? #$%&/()=';
        uacc.ReportaVetado = 'SÍ'; // Con acento
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConCaracteresEspeciales: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testUAccountListaVacia() {
        // Probar con lista vacía
        List<PAK_Update_ACC.UAccount> emptyList = new List<PAK_Update_ACC.UAccount>();
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(emptyList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountListaVacia: ' + results);
    }
    /*
    @isTest(seeAllData=true)
    static void testUAccountConCustomerIdDuplicado() {
        // Crear una cuenta primero
        String customerId = 'DUP-' + System.currentTimeMillis();
        
        Account testAccount = new Account(
            Name = 'Cliente Original',
            Customer_id__c = customerId,
            ActiveSap__c = true
        );
        insert testAccount;
        
        // Intentar crear otra cuenta con el mismo Customer_id (debería hacer upsert)
        PAK_Update_ACC.UAccount uacc = new PAK_Update_ACC.UAccount();
        uacc.Customer_id = customerId; // Mismo ID
        uacc.Status_Account = '1';
        uacc.Name = 'Cliente con ID Duplicado';
        
        List<PAK_Update_ACC.UAccount> uaccList = new List<PAK_Update_ACC.UAccount>{uacc};
        
        Test.startTest();
        List<PAK_UAccount_Service.status> results = PAK_UAccount_Service.UAccount(uaccList);
        Test.stopTest();
        
        System.debug('Resultados testUAccountConCustomerIdDuplicado: ' + results);
    }
*/
    
}