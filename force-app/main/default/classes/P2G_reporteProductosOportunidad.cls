public class P2G_reporteProductosOportunidad {
	@AuraEnabled
    public static List<OpportunityLineItem> getProducts(){
        List<OpportunityLineItem> listaOli = [SELECT Id, Name, OpportunityId, Opportunity.Name, Opportunity.Usuario_IC__c, Opportunity.Usuario_IC__r.Name,
                                              Opportunity.OwnerId, Opportunity.Owner.Name, Product2Id, Product2.Name, Target__c, Status__c, Buy_Price__c,
                                              Tipo_de_moneda__c, Moneda_Oportunidad__c, Opportunity.AccountId, Opportunity.Account.Name, Fecha_y_hora_Solicitud__c,
                                              Fecha_y_Hora_Respuesta_Pricing__c FROM OpportunityLineItem
                                              WHERE Status__c != null AND Buy_Price__c = null AND Status__c = 'Pendiente por Cotizar' AND Opportunity.Group__c != 'SP-PQ-PAQUETERIA'
                                              AND Opportunity.Group__c != 'SP-WH-ALMACENAJE' AND Opportunity.Group__c != 'SP-T-CONSOLIDADO' AND Opportunity.RecordType.Name != 'Standar Opportunity'
                                              AND Opportunity.StageName != 'Perdida' ORDER BY LastModifiedDate DESC LIMIT 50];
        return listaOli;
    }
    @AuraEnabled
    public static List<Subproducto__c> getSubProductos(){
        List<Subproducto__c> listaSub = [SELECT Id, Name, SubProduct_Opportunity_Product__c,SubProduct_Opportunity__c,  SubProduct_Opportunity__r.Name,
                                         SubProduct_Opportunity__r.Usuario_IC__c, SubProduct_Opportunity__r.Usuario_IC__r.Name,
                                         SubProduct_Opportunity__r.OwnerId, SubProduct_Opportunity__r.Owner.Name, Status__c,
                                         SubProduct_Opportunity_Product__r.Product2Id, SubProduct_Opportunity_Product__r.Product2.Name,
                                         SubProduct_Opportunity__r.AccountId, SubProduct_Opportunity__r.Account.Name FROM Subproducto__c
                                         WHERE Status__c != null AND SubProduct_Buy_Price__c = 0 AND Status__c != 'No Cotizada'  AND SubProduct_Opportunity__r.RecordType.Name != 'Standar Opportunity'
                                         AND SubProduct_Opportunity__r.Group__c != 'SP-PQ-PAQUETERIA' AND SubProduct_Opportunity__r.Group__c != 'SP-WH-ALMACENAJE' AND SubProduct_Opportunity__r.Group__c != 'SP-T-CONSOLIDADO'
                                         AND SubProduct_Opportunity__c != null AND SubProduct_Opportunity_Product__c != null
                                         AND SubProduct_Opportunity__r.StageName != 'Perdida' ORDER BY LastModifiedDate DESC LIMIT 50 ];
        return listaSub;
    }
    public class ComboboxOption {
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        public ComboboxOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<ComboboxOption> getAccountOptions() {
        List<ComboboxOption> options = new List<ComboboxOption>();
        // Usa AggregateResult para agrupar por AccountId y Account.Name
        List<AggregateResult> results = [
            SELECT Opportunity.AccountId accId, Opportunity.Account.Name accName
            FROM OpportunityLineItem
            WHERE Buy_Price__c = null AND Status__c != null AND Status__c != 'No Cotizada'
            GROUP BY Opportunity.AccountId, Opportunity.Account.Name ORDER BY Opportunity.Account.Name ASC
        ];
        // Recorre los resultados agregados y crea opciones para el combobox
        for (AggregateResult ar : results) {
            String accountId = (String) ar.get('accId');
            String accountName = (String) ar.get('accName');
            if (accountId != null && accountName != null) {
                options.add(new ComboboxOption(accountId, accountName));
            }
        }
        return options;
    }
    @AuraEnabled(cacheable=true)
    public static List<ComboboxOption> getOwnerOppoOptions() {
        List<ComboboxOption> options = new List<ComboboxOption>();
        List<AggregateResult> results = [
            SELECT Opportunity.OwnerId ownerId, Opportunity.Owner.Name ownerName
            FROM OpportunityLineItem
            WHERE Buy_Price__c = null AND Status__c != null AND Status__c != 'No Cotizada'
            GROUP BY Opportunity.OwnerId, Opportunity.Owner.Name ORDER BY Opportunity.Owner.Name ASC
        ];
        // Recorre los resultados agregados y crea opciones para el combobox
        for (AggregateResult ar : results) {
            String ownerOppoId = (String) ar.get('ownerId');
            String ownerOppoName = (String) ar.get('ownerName');
            if (ownerOppoId != null && ownerOppoName != null) {
                options.add(new ComboboxOption(ownerOppoId, ownerOppoName));
            }
        }
        return options;
    }
    @AuraEnabled(cacheable=true)
    public static List<ComboboxOption> getIcOptions() {
        List<ComboboxOption> options = new List<ComboboxOption>();
        List<AggregateResult> results = [
            SELECT Opportunity.Usuario_IC__c icId, Opportunity.Usuario_IC__r.Name icName
            FROM OpportunityLineItem
            WHERE Buy_Price__c = null AND Status__c != null AND Status__c != 'No Cotizada'
            GROUP BY Opportunity.Usuario_IC__c, Opportunity.Usuario_IC__r.Name ORDER BY Opportunity.Usuario_IC__r.Name ASC
        ];
        // Recorre los resultados agregados y crea opciones para el combobox
        for (AggregateResult ar : results) {
            String userIcId = (String) ar.get('icId');
            String userIcName = (String) ar.get('icName');
            if (userIcId != null && userIcName != null) {
                options.add(new ComboboxOption(userIcId, userIcName));
            }
        }
        return options;
    }
    @AuraEnabled
    public static List<OpportunityLineItem> buscaProductosPendientes(String status, String servicio, String ownerOppo, String userIc, String cliente){
        List<OpportunityLineItem> listaOli = queryFiltered(status, servicio, ownerOppo, userIc, cliente);
        return listaOli;
    }
    @AuraEnabled
    public static List<Subproducto__c> buscaSubProductosPendientes(String status, String servicio, String ownerOppo, String userIc, String cliente){
        List<Subproducto__c> listaSub = queryFilteredSubProduct(status, servicio, ownerOppo, userIc, cliente);
        return listaSub;
    }
    @AuraEnabled
    public static List<OpportunityLineItem> buscaProductosCotizados(String status, String servicio, String ownerOppo, String userIc, String cliente){
        List<OpportunityLineItem> listaOli = queryFilteredCotizados(status, servicio, ownerOppo, userIc, cliente);
        return listaOli;
    }
    @AuraEnabled
    public static List<Subproducto__c> buscaSubProductosCotizados(String status, String servicio, String ownerOppo, String userIc, String cliente){
        List<Subproducto__c> listaSub = queryFilteredSubProductCotizados(status, servicio, ownerOppo, userIc, cliente);
        return listaSub;
    }
    @AuraEnabled
    public static List<OpportunityLineItem> buscaProductosAceptados(String status, String servicio, String ownerOppo, String userIc, String cliente){
        List<OpportunityLineItem> listaOli = queryFilteredAceptados(status, servicio, ownerOppo, userIc, cliente);
        return listaOli;
    }
    @AuraEnabled
    public static List<Subproducto__c> buscaSubProductosAceptados(String status, String servicio, String ownerOppo, String userIc, String cliente){
        List<Subproducto__c> listaSub = queryFilteredSubProductAceptados(status, servicio, ownerOppo, userIc, cliente);
        return listaSub;
    }
    public static List<SObject> queryFiltered(String status, String servicio, String ownerOppo, String userIc, String cliente) {
        // Construimos la consulta base
        String query = 'SELECT Id, Name, OpportunityId, Opportunity.Name, Opportunity.Usuario_IC__c, Opportunity.Usuario_IC__r.Name, Fecha_y_hora_Solicitud__c,'; 
               query += 'Opportunity.OwnerId, Opportunity.Owner.Name, Product2Id, Product2.Name, Target__c, Status__c, Buy_Price__c, Fecha_y_Hora_Respuesta_Pricing__c,';
               query += 'Tipo_de_moneda__c, Moneda_Oportunidad__c, Opportunity.AccountId, Opportunity.Account.Name FROM OpportunityLineItem';
        List<String> conditions = new List<String>();
		conditions.add('Buy_Price__c = NULL');
		conditions.add('Status__c != NULL');
		conditions.add('Opportunity.StageName != \'' + String.escapeSingleQuotes('Perdida') + '\'');
		conditions.add('Opportunity.RecordType.Name != \'' + String.escapeSingleQuotes('Standar Opportunity') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(status)) {
            conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
        }else{
			conditions.add('Status__c = \'' + String.escapeSingleQuotes('Pendiente por Cotizar') + '\'');
        }
        if (!String.isBlank(servicio)) {
            conditions.add('Opportunity.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) + '\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('Opportunity.OwnerId = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('Opportunity.Usuario_IC__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('Opportunity.AccountId = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC';
        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        return results;
    }
    public static List<SObject> queryFilteredSubProduct(String status, String servicio, String ownerOppo, String userIc, String cliente) {
        String query = 'SELECT Id, Name, SubProduct_Opportunity_Product__c,SubProduct_Opportunity__c,  SubProduct_Opportunity__r.Name,';
        	query += 'SubProduct_Opportunity__r.Usuario_IC__c, SubProduct_Opportunity__r.Usuario_IC__r.Name,';
            query += 'SubProduct_Opportunity__r.OwnerId, SubProduct_Opportunity__r.Owner.Name,';
            query += 'SubProduct_Opportunity_Product__r.Product2Id, SubProduct_Opportunity_Product__r.Product2.Name,';
            query += 'Tipo_de_moneda__c, SubProduct_Opportunity_Product__r.Moneda_Oportunidad__c, Status__c, SubProduct_Buy_Price__c,';
            query += 'SubProduct_Opportunity__r.AccountId, SubProduct_Opportunity__r.Account.Name FROM Subproducto__c';
        List<String> conditions = new List<String>();
		conditions.add('SubProduct_Buy_Price__c = 0');
		conditions.add('Status__c != NULL');
		conditions.add('SubProduct_Opportunity__c != NULL');
		conditions.add('SubProduct_Opportunity_Product__c != NULL');
		conditions.add('SubProduct_Opportunity__r.StageName != \'' + String.escapeSingleQuotes('Perdida') + '\'');
		conditions.add('SubProduct_Opportunity__r.RecordType.Name != \'' + String.escapeSingleQuotes('Standar Opportunity') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(status)) {
            conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
        }else{
			conditions.add('Status__c = \'' + String.escapeSingleQuotes('Pendiente por Cotizar') + '\'');
        }
        if (!String.isBlank(servicio)) {
            conditions.add('SubProduct_Opportunity__r.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) + '\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('SubProduct_Opportunity__r.OwnerId = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('SubProduct_Opportunity__r.Usuario_IC__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('SubProduct_Opportunity__r.AccountId = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC';
        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        return results;
    }
    public static List<SObject> queryFilteredCotizados(String status, String servicio, String ownerOppo, String userIc, String cliente) {
        // Construimos la consulta base
        String query = 'SELECT Id, Name, OpportunityId, Opportunity.Name, Opportunity.Usuario_IC__c, Opportunity.Usuario_IC__r.Name, Fecha_y_hora_Solicitud__c,'; 
               query += 'Opportunity.OwnerId, Opportunity.Owner.Name, Product2Id, Product2.Name, Target__c, Status__c, Buy_Price__c, Fecha_y_Hora_Respuesta_Pricing__c,';
               query += 'Tipo_de_moneda__c, Moneda_Oportunidad__c, Opportunity.AccountId, Opportunity.Account.Name FROM OpportunityLineItem';
        List<String> conditions = new List<String>();
		conditions.add('Status__c = \'' + String.escapeSingleQuotes('Cotizada') + '\'');
		conditions.add('Opportunity.StageName != \'' + String.escapeSingleQuotes('Perdida') + '\'');
		conditions.add('Opportunity.RecordType.Name != \'' + String.escapeSingleQuotes('Standar Opportunity') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(status)) {
            conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
        }
        if (!String.isBlank(servicio)) {
            conditions.add('Opportunity.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) + '\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('Opportunity.OwnerId = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('Opportunity.Usuario_IC__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('Opportunity.AccountId = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC LIMIT 50';

        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        return results;
    }
    public static List<SObject> queryFilteredSubProductCotizados(String status, String servicio, String ownerOppo, String userIc, String cliente) {
        String query = 'SELECT Id, Name, SubProduct_Opportunity_Product__c,SubProduct_Opportunity__c,  SubProduct_Opportunity__r.Name,';
        	query += 'SubProduct_Opportunity__r.Usuario_IC__c, SubProduct_Opportunity__r.Usuario_IC__r.Name,';
            query += 'SubProduct_Opportunity__r.OwnerId, SubProduct_Opportunity__r.Owner.Name,';
            query += 'SubProduct_Opportunity_Product__r.Product2Id, SubProduct_Opportunity_Product__r.Product2.Name,';
            query += 'Tipo_de_moneda__c, SubProduct_Opportunity_Product__r.Moneda_Oportunidad__c, Status__c, SubProduct_Buy_Price__c,';
            query += 'SubProduct_Opportunity__r.AccountId, SubProduct_Opportunity__r.Account.Name FROM Subproducto__c';
        List<String> conditions = new List<String>();
		conditions.add('Status__c = \'' + String.escapeSingleQuotes('Cotizada') + '\'');
		conditions.add('SubProduct_Opportunity__c != NULL');
		conditions.add('SubProduct_Opportunity_Product__c != NULL');
		conditions.add('SubProduct_Opportunity__r.StageName != \'' + String.escapeSingleQuotes('Perdida') + '\'');
		conditions.add('SubProduct_Opportunity__r.RecordType.Name != \'' + String.escapeSingleQuotes('Standar Opportunity') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(status)) {
            conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
        }
        if (!String.isBlank(servicio)) {
            conditions.add('SubProduct_Opportunity__r.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) + '\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('SubProduct_Opportunity__r.OwnerId = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('SubProduct_Opportunity__r.Usuario_IC__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('SubProduct_Opportunity__r.AccountId = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC LIMIT 50';

        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        return results;
    }
    public static List<SObject> queryFilteredAceptados(String status, String servicio, String ownerOppo, String userIc, String cliente) {
        // Construimos la consulta base
        String query = 'SELECT Id, Name, OpportunityId, Opportunity.Name, Opportunity.Usuario_IC__c, Opportunity.Usuario_IC__r.Name, Fecha_y_hora_Solicitud__c,'; 
               query += 'Opportunity.OwnerId, Opportunity.Owner.Name, Product2Id, Product2.Name, Target__c, Status__c, Buy_Price__c, Fecha_y_Hora_Respuesta_Pricing__c,';
               query += 'Tipo_de_moneda__c, Moneda_Oportunidad__c, Opportunity.AccountId, Opportunity.Account.Name FROM OpportunityLineItem';
        List<String> conditions = new List<String>();
		conditions.add('Status__c = \'' + String.escapeSingleQuotes('Aceptada') + '\'');
		conditions.add('Opportunity.StageName != \'' + String.escapeSingleQuotes('Perdida') + '\'');
		conditions.add('Opportunity.RecordType.Name != \'' + String.escapeSingleQuotes('Standar Opportunity') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(status)) {
            conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
        }
        if (!String.isBlank(servicio)) {
            conditions.add('Opportunity.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) +'\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('Opportunity.OwnerId = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('Opportunity.Usuario_IC__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('Opportunity.AccountId = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC LIMIT 50';

        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        return results;
    }
    public static List<SObject> queryFilteredSubProductAceptados(String status, String servicio, String ownerOppo, String userIc, String cliente) {
        String query = 'SELECT Id, Name, SubProduct_Opportunity_Product__c,SubProduct_Opportunity__c,  SubProduct_Opportunity__r.Name,';
        	query += 'SubProduct_Opportunity__r.Usuario_IC__c, SubProduct_Opportunity__r.Usuario_IC__r.Name,';
            query += 'SubProduct_Opportunity__r.OwnerId, SubProduct_Opportunity__r.Owner.Name,';
            query += 'SubProduct_Opportunity_Product__r.Product2Id, SubProduct_Opportunity_Product__r.Product2.Name,';
            query += 'Tipo_de_moneda__c, SubProduct_Opportunity_Product__r.Moneda_Oportunidad__c, Status__c, SubProduct_Buy_Price__c,';
            query += 'SubProduct_Opportunity__r.AccountId, SubProduct_Opportunity__r.Account.Name FROM Subproducto__c';
        List<String> conditions = new List<String>();
		conditions.add('Status__c = \'' + String.escapeSingleQuotes('Aceptada') + '\'');
		conditions.add('SubProduct_Opportunity__c != NULL');
		conditions.add('SubProduct_Opportunity_Product__c != NULL');
		conditions.add('SubProduct_Opportunity__r.StageName != \'' + String.escapeSingleQuotes('Perdida') + '\'');
		conditions.add('SubProduct_Opportunity__r.RecordType.Name != \'' + String.escapeSingleQuotes('Standar Opportunity') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(status)) {
            conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
        }
        if (!String.isBlank(servicio)) {
            conditions.add('SubProduct_Opportunity__r.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) + '\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('SubProduct_Opportunity__r.OwnerId = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('SubProduct_Opportunity__r.Usuario_IC__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('SubProduct_Opportunity__r.AccountId = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC LIMIT 50';

        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        return results;
    }
    //para el LWC de Busqueda de cuenta por productos aceptados
	@AuraEnabled
    public static List<p2G_FoliosEnOportunidades.wrapperProduct> getProductsAceptados(){
        List<OpportunityLineItem> listaOli = [SELECT Id,Name,Product2.Name,OpportunityId,Opportunity.Name,Buy_Price__c,UnitPrice,Opportunity.Group__c,
                                         CurrencyIsoCode,Opportunity.AccountId,Opportunity.Account.Name,PROJ_Modalidad__c,PROJ_Peso_de_carga__c, Incoterm__c,
                                         Quantity,PROJ_Tipo_de_mercancia__c,Product2.PROJ_Site_of_load__c,Product2.PROJ_Site_of_discharge__c,Tipo_de_servicio__c,
                                         Tipo_de_moneda__c, Buy_Price_Converted__c, Sales_Price_Converted__c, Tipo_de_ruta__c, Customs__c, Border__c,
                                         Opportunity.OwnerId, Opportunity.Owner.Name, Product2Id, Vigencia_hasta__c
                                         FROM OpportunityLineItem WHERE Status__c = 'Aceptada' AND Buy_Price__c != 0 AND Buy_Price__c != null AND UnitPrice != 0
                                         AND Opportunity.Account.Record_Type_Name__c = 'Customer'];
            System.debug('Las ruta: '+listaOli);
        List<p2G_FoliosEnOportunidades.wrapperProduct> listProduct = getWrapperProduct(listaOli);
        return listProduct;
    }
    public static List<p2G_FoliosEnOportunidades.wrapperProduct> getWrapperProduct(List<OpportunityLineItem> listaOli){
        List<p2G_FoliosEnOportunidades.wrapperProduct> listProduct = new List<p2G_FoliosEnOportunidades.wrapperProduct>();
            String[] buyPriceConverted;
            String[] salesPriceConverted;
        for(OpportunityLineItem route : listaOli){
            if(route.Buy_Price_Converted__c != null && route.Buy_Price_Converted__c != ''){
                buyPriceConverted = route.Buy_Price_Converted__c.split(' ');}
            if(route.Sales_Price_Converted__c != null && route.Sales_Price_Converted__c != ''){
                salesPriceConverted = route.Sales_Price_Converted__c.split(' ');}
        	p2G_FoliosEnOportunidades.wrapperProduct product = new p2G_FoliosEnOportunidades.wrapperProduct();
                product.id = route.Id;
                product.grupo = route.Opportunity.Group__c;
                product.idOpportunity = route.OpportunityId;
                product.nameOpportunity = route.Opportunity.Name;
                product.nameRoute= route.Product2.Name;
                product.idAccount = route.Opportunity.AccountId;
                product.nameAccount = route.Opportunity.Account.Name;
                product.nameConteinerType = route.PROJ_Modalidad__c;
                product.currencyIsoCode = route.CurrencyIsoCode;
                product.pesoBruto = route.PROJ_Peso_de_carga__c;
                product.units = route.Quantity;
                product.extencionItemName = route.PROJ_Tipo_de_mercancia__c;
                product.loadSite = route.Product2.PROJ_Site_of_load__c;
                product.dischargeSite = route.Product2.PROJ_Site_of_discharge__c;
                product.idAddressOrigen = '';
                product.idAddressDestino = '';
            	product.seCrea = false;
            	product.existeDireccion = '';
                product.serviceMode = route.Opportunity.Owner.Name;
        		product.servicetype = String.ValueOF(route.Vigencia_hasta__c);
            if((route.Tipo_de_moneda__c != null && route.Tipo_de_moneda__c != route.CurrencyIsoCode) && (route.Buy_Price_Converted__c != null && route.Buy_Price_Converted__c != '') && (route.Sales_Price_Converted__c != null && route.Sales_Price_Converted__c != '')){
                product.currencyLine = route.Tipo_de_moneda__c;
                product.buyPrice = Decimal.ValueOF(buyPriceConverted[1]);
                product.sellPrice = Decimal.ValueOF(salesPriceConverted[1]);
            }else{
            	product.currencyLine = route.CurrencyIsoCode;
                product.buyPrice = route.Buy_Price__c;
                product.sellPrice = route.UnitPrice;
            }
                                          listProduct.add(product);  
            System.debug('Se agrego la ruta: '+listProduct);
        }
            System.debug('numero de rutas: '+listaOli.size()+' las lineas: '+listaOli);
        return listProduct;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountAceptados(String cuenta) {
        String buscaCuenta = '%'+cuenta+'%';
        Set<id> setCuentas = new Set<id>();
        List<OpportunityLineItem> listaCuentas = [SELECT Opportunity.AccountId
                                            FROM OpportunityLineItem WHERE  Status__c = 'Aceptada' AND Opportunity.Account.Record_Type_Name__c = 'Customer'
                                            AND Opportunity.Account.Name LIKE: buscaCuenta];
        for(OpportunityLineItem idCuentas : listaCuentas){
            setCuentas.add(idCuentas.Opportunity.AccountId);
        }
        List<Account> cuentas = [SELECT Id, Name, Customer_Id__c
                                            FROM Account WHERE Id IN:setCuentas AND Record_Type_Name__c = 'Customer'];
        if(cuentas.size() == 0){
            throw new AuraHandledException('No se encontraron productos aprobados asignados a la cuenta o la cuenta no esta como (Customer)'); 
        }
        return cuentas;
    }
	@AuraEnabled
    public static List<p2G_FoliosEnOportunidades.wrapperProduct> getProductsEnCuentas(String idCuentas, String servicio){
        String query = 'SELECT Id,Name,Product2.Name,OpportunityId,Opportunity.Name,Buy_Price__c,UnitPrice,Opportunity.Group__c,';
               query += 'CurrencyIsoCode,Opportunity.AccountId,Opportunity.Account.Name,PROJ_Modalidad__c,PROJ_Peso_de_carga__c, Incoterm__c,';
               query += 'Quantity,PROJ_Tipo_de_mercancia__c,Product2.PROJ_Site_of_load__c,Product2.PROJ_Site_of_discharge__c,Tipo_de_servicio__c,';
               query += 'Tipo_de_moneda__c, Buy_Price_Converted__c, Sales_Price_Converted__c, Tipo_de_ruta__c, Customs__c, Border__c,';
               query += 'Opportunity.OwnerId, Opportunity.Owner.Name, Product2Id, Vigencia_hasta__c FROM OpportunityLineItem';
        List<String> conditions = new List<String>();
		conditions.add('Buy_Price__c != NULL');
		conditions.add('Buy_Price__c != 0');
		conditions.add('UnitPrice != 0');
		conditions.add('Status__c = \'' + String.escapeSingleQuotes('Aceptada') + '\'');
		conditions.add('Opportunity.Account.Record_Type_Name__c = \'' + String.escapeSingleQuotes('Customer') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(servicio)) {
            conditions.add('Opportunity.Service_Type__c = \'' + String.escapeSingleQuotes(servicio) + '\'');
        }
        if (!String.isBlank(idCuentas)) {
            conditions.add('Opportunity.AccountId = \'' + String.escapeSingleQuotes(idCuentas) + '\'');
        }
        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC';
        System.debug('la query es: '+ query);
        // Ejecutamos la consulta dinámica
        List<OpportunityLineItem> results = Database.query(query);
        
        List<p2G_FoliosEnOportunidades.wrapperProduct> listProduct = getWrapperProduct(results);
        return listProduct;
    }
    @AuraEnabled
    public static List<Import_Export_Fee_Line__c> getServiceLineIEQO(){
        List<Import_Export_Fee_Line__c> listaOli = [SELECT Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name, Import_Export_Quote__r.FolioResume__c,
                                              Quote_Buy_Price__c, Service_Rate_Name__c, Service_Rate_Name__r.Name, Buy_Rate__c, Import_Export_Quote__r.Date_Send_Request__c,
                                              Import_Export_Quote__r.Date_Pricing_responded__c, Import_Export_Quote__r.Pricing_Executive__c, Import_Export_Quote__r.CreatedById,
                                              Import_Export_Quote__r.CreatedBy.Name, Import_Export_Quote__r.Quotation_Status__c, Import_Export_Quote__r.Account_for__c, CurrencyIsoCode,
                                              Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Pricing_Executive__r.Name, Import_Export_Quote__r.CurrencyIsoCode FROM Import_Export_Fee_Line__c 
                                              WHERE Import_Export_Quote__r.Quotation_Status__c ='Awaiting costs suppliers' OR Import_Export_Quote__r.Quotation_Status__c ='Sent awaiting response'
                                              ORDER BY LastModifiedDate DESC LIMIT 50];
        return listaOli;
    }
    public static List<SObject> queryFilteredIEQO(String servicio, String ownerOppo, String userIc, String cliente) {
        // Construimos la consulta base
        String query = 'SELECT Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name, Import_Export_Quote__r.FolioResume__c, CurrencyIsoCode,';
               query += 'Quote_Buy_Price__c, Service_Rate_Name__c, Service_Rate_Name__r.Name, Buy_Rate__c, Import_Export_Quote__r.Date_Send_Request__c,';
               query += 'Import_Export_Quote__r.Date_Pricing_responded__c, Import_Export_Quote__r.Pricing_Executive__c, Import_Export_Quote__r.CreatedById,';
               query += 'Import_Export_Quote__r.CreatedBy.Name, Import_Export_Quote__r.Quotation_Status__c, Import_Export_Quote__r.Account_for__c,';
               query += 'Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Pricing_Executive__r.Name, Import_Export_Quote__r.CurrencyIsoCode FROM Import_Export_Fee_Line__c';
        List<String> conditions = new List<String>();
		conditions.add('Import_Export_Quote__r.Quotation_Status__c != \'' + String.escapeSingleQuotes('Quote being prepared') + '\'');
		conditions.add('Import_Export_Quote__r.Quotation_Status__c != \'' + String.escapeSingleQuotes('Approved as Succesful') + '\'');
        conditions.add('Import_Export_Quote__r.Quotation_Status__c != \'' + String.escapeSingleQuotes('Shipped') + '\'');
		conditions.add('Import_Export_Quote__r.Quotation_Status__c != \'' + String.escapeSingleQuotes('Quote Declined') + '\'');
        // Agregamos condiciones solo para las variables que no están vacías
        if (!String.isBlank(servicio)) {
            servicio = modificarServicio(servicio);
            conditions.add('Import_Export_Quote__r.Name LIKE \'' + String.escapeSingleQuotes(servicio) + '-%' + '\'');
        }
        if (!String.isBlank(ownerOppo)) {
            conditions.add('Import_Export_Quote__r.CreatedById = \'' + String.escapeSingleQuotes(ownerOppo) + '\'');
        }
        if (!String.isBlank(userIc)) {
            conditions.add('Import_Export_Quote__r.Pricing_Executive__c = \'' + String.escapeSingleQuotes(userIc) + '\'');
        }
        if (!String.isBlank(cliente)) {
            conditions.add('Import_Export_Quote__r.Account_for__c = \'' + String.escapeSingleQuotes(cliente) + '\'');
        }

        // Verificamos si hay al menos una condición
        if (conditions.isEmpty()) {
            // Si no hay condiciones, lanzamos una excepción o retornamos una lista vacía
            throw new IllegalArgumentException('At least one variable must have a value');
        }

        // Solo agregamos el WHERE si hay al menos una condición
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
		query += ' ORDER BY LastModifiedDate DESC LIMIT 50';
        // Ejecutamos la consulta dinámica
        List<SObject> results = Database.query(query);
        System.debug('la query '+query);
        return results;
    }
    public static String modificarServicio(String servicio){
        String nuevoServicio;
			switch on servicio{
            when 'CE - Aduanas'{
                nuevoServicio = 'CE';
            }
            when 'PTO - Puerto'{
                nuevoServicio = 'PTO';
            }
            when 'R - Global Routing'{
                nuevoServicio = 'R';
            }
            when 'EX-Seguros'{
                nuevoServicio = 'EX';
            }
            when else {
                nuevoServicio = servicio;
            }
        }  
        return nuevoServicio;
    }
    @AuraEnabled
    public static List<Import_Export_Fee_Line__c> buscaIEQOPendientes(String servicio, String ownerOppo, String userIc, String cliente){
        System.debug('lo que llega '+servicio+ ownerOppo+ userIc+ cliente);
        List<Import_Export_Fee_Line__c> listaSL = queryFilteredIEQO(servicio, ownerOppo, userIc, cliente);
        System.debug('la lista '+listaSL);
        return listaSL;
    }
    @AuraEnabled
    public static list<User> getUser(string name){
        string searchKeyword = '%' + name + '%';
        List<User> ListUser = [SELECT Id, Name FROM User where Name LIKE : searchKeyword AND IsActive = True limit 20];
        if(ListUser.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListUser;
    }
}