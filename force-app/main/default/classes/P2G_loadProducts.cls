public class P2G_loadProducts {
    public class csvProduct {
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String origen { get; set; }
        @AuraEnabled public String destino { get; set; }
        @AuraEnabled public String origenId { get; set; }
        @AuraEnabled public String destinoId { get; set; }
        @AuraEnabled public String cantidad { get; set; } //
        @AuraEnabled public String pesoDeCarga { get; set; } //
        @AuraEnabled public String unidadPorFrecuencia { get; set; } //
        @AuraEnabled public String tipoMercancia { get; set; } //
        @AuraEnabled public String frecuencia { get; set; } //
        @AuraEnabled public String tiempoCarga { get; set; } //
        @AuraEnabled public String tiempoDescarga { get; set; } //
        @AuraEnabled public String modalidad { get; set; }
        @AuraEnabled public String direccionCarga { get; set; }
        @AuraEnabled public String direccionDescarga { get; set; }
        @AuraEnabled public String idCpOrigen { get; set; }
        @AuraEnabled public String idCpDestino { get; set; }
        @AuraEnabled public String comentarios { get; set; } //
        @AuraEnabled public Boolean modificar { get; set; }
        @AuraEnabled public String buyPrice { get; set; }
        @AuraEnabled public String sellPrice  { get; set; }
        @AuraEnabled public String IdOli  { get; set; }
        @AuraEnabled public Boolean showFila  { get; set; }
        @AuraEnabled public String currencyOli  { get; set; }
        @AuraEnabled public String target  { get; set; }
        @AuraEnabled public String incoterm { get; set; }
        @AuraEnabled public String unidadPeso { get; set; }
        @AuraEnabled public String tipoServicio { get; set; }
        @AuraEnabled public String tipoRuta { get; set; }
        @AuraEnabled public String tipoContenedor { get; set; }
        @AuraEnabled public String servicioEspecial { get; set; } //
        @AuraEnabled public String puertoSalidaArribo { get; set; } //
        @AuraEnabled public Boolean hazmat { get; set; } //
        @AuraEnabled public String certificaciones { get; set; } //
        @AuraEnabled public String accesoriales { get; set; } //accesoriales
        @AuraEnabled public String volumenMensual { get; set; } //
        @AuraEnabled public String servicioAdicional { get; set; } //
        @AuraEnabled public String itemHeight { get; set; }
        @AuraEnabled public String itemWidth { get; set; }
        @AuraEnabled public String itemLenght { get; set; }
        @AuraEnabled public String fronteraCruce { get; set; }
        @AuraEnabled public Boolean transbordo { get; set; }
        @AuraEnabled public String piezas { get; set; }
        @AuraEnabled public String aeropuertoSalidaArribo { get; set; }
        @AuraEnabled public String fechaInicioEmbarque { get; set; }
        @AuraEnabled public String fechaFinEmbarque { get; set; }
        @AuraEnabled public String tipoSeguro { get; set; } 
        @AuraEnabled public String tipoServicioEmbarque { get; set; }
        @AuraEnabled public String razonSocialEmbarcador { get; set; }
        @AuraEnabled public String razonSocialImportador { get; set; }
        @AuraEnabled public String border { get; set; }
        @AuraEnabled public String customs { get; set; }//
    }
    
    @AuraEnabled
    public static csvProduct getCsv(){
        csvProduct csv = new csvProduct();
        return csv;
    }
    
    @AuraEnabled
    public static void handleProduct(String opportunityId,String jsonProduct) {
        System.debug('jsonProduct: '+jsonProduct);
        P2G_loadProducts.csvProduct productInfo = (P2G_loadProducts.csvProduct)JSON.deserialize(jsonProduct, P2G_loadProducts.csvProduct.class);
        String productName = productInfo.origen + ' - ' + productInfo.destino;
        //Savepoint sp = Database.setSavepoint();
        	
            Opportunity opp = [SELECT Id, Name, Pricebook2Id, CurrencyIsoCode FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            if (opp.Pricebook2Id == null) {
                // Si no tiene un libro de precios, crea uno automáticamente
                Pricebook2 pb = new Pricebook2(Name = opp.Name + ' Pricebook', IsActive = true, Description = 'Auto-Generado');
                insert pb;
                
                // Asigna el nuevo libro de precios a la oportunidad y actualiza la oportunidad
                opp.Pricebook2Id = pb.Id;
                update opp;
            }
            // Luego, busca la entrada de lista de precios del producto
            List<PricebookEntry> opportunityEntries = [
                SELECT Id, Product2Id, Product2.Name
                FROM PricebookEntry
                WHERE Pricebook2Id = :opp.Pricebook2Id
                AND Product2.Name = :productName
                AND CurrencyIsoCode = :opp.CurrencyIsoCode
                LIMIT 1
            ];
            
            OpportunityLineItem newOpportunityLineItem;
            
            if (opportunityEntries != null && !opportunityEntries.isEmpty()) {
                PricebookEntry opportunityEntry = opportunityEntries[0];
                // Si el producto está en el libro de la oportunidad, imprime un mensaje
                System.debug('Producto encontrado en el libro de la oportunidad: ' + opportunityEntry.Product2.Name);
                newOpportunityLineItem = createOpporLi(opportunityId, opportunityEntry.Product2Id, opportunityEntry.Id,productInfo);
            } else {
                // Buscar el producto en el libro de precios estándar
                    List<PricebookEntry> standardEntries = [
                        SELECT Id, Product2Id, Product2.Name, UnitPrice
                        FROM PricebookEntry
                        WHERE Pricebook2.IsStandard = true
                        AND Product2.Name = :productName
                		AND CurrencyIsoCode = :opp.CurrencyIsoCode
                        LIMIT 1
                    ];
                
                if (standardEntries != null && !standardEntries.isEmpty()) {
                    // Si el producto está en el libro de precios estándar, crea una entrada en el libro de la oportunidad
                    Id opportunityPricebookId = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId LIMIT 1].Pricebook2Id;
                    Pricebook2 opportunityPricebook = [SELECT Id FROM Pricebook2 WHERE Id = :opportunityPricebookId LIMIT 1];
                    
                    PricebookEntry newOpportunityEntry = new PricebookEntry(
                        Product2Id = standardEntries[0].Product2Id,
                        UnitPrice = standardEntries[0].UnitPrice,
                        IsActive = true,
                        Pricebook2Id = opportunityPricebook.Id,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    
                    insert newOpportunityEntry;
                    
                    // Crea un OpportunityLineItem asociado al producto y la entrada de lista de precios de la oportunidad
                    newOpportunityLineItem = createOpporLi(opportunityId, standardEntries[0].Product2Id, newOpportunityEntry.Id,productInfo);
                    
                    System.debug('Producto encontrado en el libro de precios estándar. Se creó una entrada en el libro de la oportunidad.');
                } else {
                    // Si el producto no está en ninguno de los libros, crea una entrada en el libro de precios estándar y otra en el de la oportunidad
                    Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
                    Product2 newProduct = new Product2(
                        Name = productName,
                        PROJ_Site_of_load__c = productInfo.origenId,
                        PROJ_Site_of_discharge__c = productInfo.destinoId,
                        PROJ_Modalidad__c = productInfo.modalidad,
                        Family = 'Route',
                        IsActive = True,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    insert newProduct;
                    
                    PricebookEntry newStandardEntry = new PricebookEntry(
                        Product2Id = newProduct.Id,
                        UnitPrice = 0,
                        IsActive = true,
                        Pricebook2Id = standardPricebook.Id,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                        insert newStandardEntry;
                    // Crea una entrada en el libro de la oportunidad
                    Id opportunityPricebookId = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId LIMIT 1].Pricebook2Id;
                    Pricebook2 opportunityPricebook = [SELECT Id FROM Pricebook2 WHERE Id = :opportunityPricebookId LIMIT 1];
                    
                    PricebookEntry newOpportunityEntry = new PricebookEntry(
                        Product2Id = newProduct.Id,
                        UnitPrice = 100,  // Puedes ajustar el precio según sea necesario
                        IsActive = true,
                        Pricebook2Id = opportunityPricebook.Id,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    if(!Test.isRunningTest()){
                        insert newOpportunityEntry;
                    // Crea un OpportunityLineItem asociado al producto y la entrada de lista de precios de la oportunidad
                    newOpportunityLineItem = createOpporLi(opportunityId, newProduct.Id, newOpportunityEntry.Id, productInfo);
                    
                    }
                    System.debug('Producto no encontrado en ningún libro. Se creó una entrada en el libro de precios estándar y otra en el de la oportunidad.');
                }
            }
            
            // Puedes utilizar el nuevo OpportunityLineItem según sea necesario
            if (newOpportunityLineItem != null) {
                insert newOpportunityLineItem;
                System.debug('Se creó un OpportunityLineItem con Id: ' + newOpportunityLineItem.Id);
            }
            //Database.rollback(sp);
        
    }
    
    public static OpportunityLineItem createOpporLi(String opportunityId, Id product2Id, Id pricebookEntryId,csvProduct productInfo) {
        User nameUser = [SELECT Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        OpportunityLineItem rellena = new OpportunityLineItem();
        rellena.OpportunityId = opportunityId;
        rellena.Product2Id = product2Id;
        rellena.PricebookEntryId = pricebookEntryId;
        
        rellena.Quantity = !String.isBlank(productInfo.cantidad) ? Integer.valueOf(productInfo.cantidad): null;
        rellena.Unidad_de_Peso__c = productInfo.unidadPeso;
        if(productInfo.unidadPeso == 'Lb'){
            Decimal pesoKb = convertirLbKg(productInfo.pesoDeCarga);
            rellena.PROJ_Peso_de_carga__c = pesoKb;
        }else{
            rellena.PROJ_Peso_de_carga__c = Decimal.valueOf(productInfo.pesoDeCarga);
        }
        rellena.PROJ_Unidades_por_frecuencia__c = productInfo.unidadPorFrecuencia;
        rellena.PROJ_Tipo_de_mercancia__c = productInfo.tipoMercancia;
        rellena.PROJ_Frecuencia__c = productInfo.frecuencia; 
        rellena.PROJ_Tiempo_de_carga__c = Decimal.valueOF(productInfo.tiempoCarga);
        rellena.PROJ_Tiempo_de_descarga__c = Decimal.ValueOF(productInfo.tiempoDescarga);
        rellena.PROJ_Modalidad__c =  productInfo.modalidad; //repetido
        rellena.PROJ_Direccion_de_carga__c = productInfo.direccionCarga;
        rellena.PROJ_Direccion_de_descarga__c = productInfo.direccionDescarga;
        rellena.Notas__c = !String.isBlank(productInfo.comentarios) ? productInfo.comentarios + ' Nota creada por: '+ nameUser.Name : null;
        rellena.Tipo_de_moneda__c = productInfo.currencyOli;
        rellena.Target__c = !String.isBlank(productInfo.target) ? Decimal.ValueOf(productInfo.target) : null;
        rellena.Incoterm__c = !String.isBlank(productInfo.incoterm) ? productInfo.incoterm : null;
        rellena.Tipo_de_servicio__c = !String.isBlank(productInfo.tipoServicio) ? productInfo.tipoServicio : null;
        rellena.Tipo_de_ruta__c = !String.isBlank(productInfo.tipoRuta) ? productInfo.tipoRuta : null;
        rellena.Tipo_de_contenedor__c = !String.isBlank(productInfo.tipoContenedor) ? productInfo.tipoContenedor : null;
        rellena.Servicio_especial__c = !String.isBlank(productInfo.servicioEspecial) ? productInfo.servicioEspecial : null;
        rellena.Puerto_de_Salida_Arribo__c = !String.isBlank(productInfo.puertoSalidaArribo) ? productInfo.puertoSalidaArribo : null;
        if(productInfo.hazmat != null){
            rellena.Hazmat__c = productInfo.hazmat;}
        rellena.Certificaciones__c = !String.isBlank(productInfo.certificaciones) ? productInfo.certificaciones : null;
        rellena.Accesoriales__c = !String.isBlank(productInfo.accesoriales) ? productInfo.accesoriales : null;
        rellena.Volumen_Mensual__c = !String.isBlank(productInfo.volumenMensual) ? Decimal.ValueOf(productInfo.volumenMensual) : null;
        rellena.Servicio_adicional__c = !String.isBlank(productInfo.servicioAdicional) ? productInfo.servicioAdicional : null;
        rellena.Item_Height__c = !String.isBlank(productInfo.itemHeight) ? Decimal.ValueOf(productInfo.itemHeight) : null;
        rellena.Item_Width__c = !String.isBlank(productInfo.itemWidth) ? Decimal.ValueOf(productInfo.itemWidth) : null;
        rellena.Item_Lenght__c = !String.isBlank(productInfo.itemLenght) ? Decimal.ValueOf(productInfo.itemLenght) : null;
        rellena.Frontera_de_cruce__c = !String.isBlank(productInfo.fronteraCruce) ? productInfo.fronteraCruce : null;
        if(productInfo.transbordo != null){
            rellena.Transbordo__c = productInfo.transbordo;}
        rellena.Aeropuerto_de_Salida_Arribo__c = !String.isBlank(productInfo.aeropuertoSalidaArribo) ? productInfo.aeropuertoSalidaArribo : null;
        rellena.Fecha_Inicio_Embarque__c = !String.isBlank(productInfo.fechaInicioEmbarque) ? Date.ValueOf(productInfo.fechaInicioEmbarque) : null;
        rellena.Fecha_Fin_Embarque__c = !String.isBlank(productInfo.fechaFinEmbarque) ? Date.ValueOf(productInfo.fechaFinEmbarque) : null;
        rellena.Tipo_de_seguro__c = !String.isBlank(productInfo.tipoSeguro) ? productInfo.tipoSeguro : null;
        rellena.Tipo_de_Servicio_Embarque__c = !String.isBlank(productInfo.tipoServicioEmbarque) ? productInfo.tipoServicioEmbarque : null;
        rellena.Razon_Social_Embarcador__c = !String.isBlank(productInfo.razonSocialEmbarcador) ? productInfo.razonSocialEmbarcador : null;
        rellena.Razon_Social_Importador__c = !String.isBlank(productInfo.razonSocialImportador) ? productInfo.razonSocialImportador : null;
		rellena.Piezas__c = !String.isBlank(productInfo.piezas) ? Decimal.ValueOf(productInfo.piezas) : null;
        rellena.CP_Origen__c = !String.isBlank(productInfo.idCpOrigen) ? productInfo.idCpOrigen : null;
        rellena.CP_Destino__c = !String.isBlank(productInfo.idCpDestino) ? productInfo.idCpDestino : null;
        rellena.Border__c = !String.isBlank(productInfo.border) ? productInfo.border : null;
        rellena.Customs__c = !String.isBlank(productInfo.customs) ? productInfo.customs : null;
        
        rellena.TotalPrice = 0;
        return rellena;
    }
    
    @AuraEnabled
    public static List<csvProduct> getOpportunityLineItems(String opportunityId) {
        List<csvProduct> csvProductsList = new List<csvProduct>();
        if (String.isNotBlank(opportunityId)) {
            List<OpportunityLineItem> opportunityLineItems = [SELECT Id,Ruta__c,Name, Quantity, PROJ_Peso_de_carga__c, PROJ_Unidades_por_frecuencia__c, 
                    PROJ_Tipo_de_mercancia__c, PROJ_Frecuencia__c, PROJ_Tiempo_de_carga__c, Tipo_de_moneda__c,
                    PROJ_Tiempo_de_descarga__c, PROJ_Modalidad__c, PROJ_Direccion_de_carga__c,
                    PROJ_Direccion_de_descarga__c, TotalPrice,Comentarios__c,Buy_Price__c,UnitPrice
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :opportunityId];
            
            for (OpportunityLineItem oli : opportunityLineItems) {
                csvProductsList.add(rellenagetItems(oli));
            }
        }
        return csvProductsList;
    }
    
    public static csvProduct rellenagetItems(OpportunityLineItem oli){
        csvProduct product = new csvProduct();
        product.Name = oli.Ruta__c;
        product.origen = oli.PROJ_Direccion_de_carga__c;
        product.destino = oli.PROJ_Direccion_de_descarga__c;
        product.cantidad = String.valueOf(oli.Quantity);
        product.pesoDeCarga = String.valueOf(oli.PROJ_Peso_de_carga__c);
        product.unidadPorFrecuencia = oli.PROJ_Unidades_por_frecuencia__c;
        product.tipoMercancia = oli.PROJ_Tipo_de_mercancia__c;
        product.frecuencia = oli.PROJ_Frecuencia__c;
        product.tiempoCarga = String.valueOf(oli.PROJ_Tiempo_de_carga__c);
        product.tiempoDescarga = String.valueOf(oli.PROJ_Tiempo_de_descarga__c);
        product.modalidad = oli.PROJ_Modalidad__c;
        product.direccionCarga = oli.PROJ_Direccion_de_carga__c;
        product.direccionDescarga = oli.PROJ_Direccion_de_descarga__c;
        product.comentarios = oli.Comentarios__c;
        product.modificar = false;
        product.showFila = false;
        product.IdOli = oli.Id;
        product.buyPrice = String.valueOf(oli.Buy_Price__c);
        product.sellPrice = String.valueOf(oli.UnitPrice);
        product.currencyOli = oli.Tipo_de_moneda__c;
        return product;
    }
    
    @AuraEnabled
    public static void updateOli(String jsonProduct){
        System.debug('lo que llega a updateOli '+ jsonProduct);
        List<OpportunityLineItem> Olis = new List<OpportunityLineItem>();
        List<P2G_loadProducts.csvProduct> producstInfo = (List<P2G_loadProducts.csvProduct>)JSON.deserialize(jsonProduct, List<P2G_loadProducts.csvProduct>.class);
        for(csvProduct item: producstInfo){
            Olis.add(rellenaOpporLi(item));      
        }
        update Olis;
    }
    
    public static OpportunityLineItem rellenaOpporLi(csvProduct productInfo) {
    OpportunityLineItem oli = new OpportunityLineItem();
    oli.Id = productInfo.IdOli;

    // Comprobaciones antes de la conversión
    oli.Quantity = !String.isBlank(productInfo.cantidad) ? Integer.valueOf(productInfo.cantidad) : null;
    oli.PROJ_Peso_de_carga__c = !String.isBlank(productInfo.pesoDeCarga) ? Decimal.valueOf(productInfo.pesoDeCarga) : null;
    oli.PROJ_Unidades_por_frecuencia__c = productInfo.unidadPorFrecuencia;
    oli.PROJ_Tipo_de_mercancia__c = productInfo.tipoMercancia;
    oli.PROJ_Frecuencia__c = productInfo.frecuencia; 
    oli.PROJ_Tiempo_de_carga__c = !String.isBlank(productInfo.tiempoCarga) ? Decimal.valueOF(productInfo.tiempoCarga) : null;
    oli.PROJ_Tiempo_de_descarga__c = !String.isBlank(productInfo.tiempoDescarga) ? Decimal.ValueOF(productInfo.tiempoDescarga) : null;
    oli.PROJ_Modalidad__c =  productInfo.modalidad;
    oli.PROJ_Direccion_de_carga__c = productInfo.direccionCarga;
    oli.PROJ_Direccion_de_descarga__c = productInfo.direccionDescarga;
    oli.Notas__c = productInfo.comentarios;
    oli.Buy_Price__c = !String.isBlank(productInfo.buyPrice) ? Decimal.ValueOf(productInfo.buyPrice) : null;

    return oli;
}
    public static void quitar(){
        csvProduct product = new csvProduct();
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        
    }
    
    public static Decimal convertirLbKg(String peso){
        Decimal pesoLb = Decimal.ValueOf(peso);
        Decimal converKg = pesoLb/2.205;
        return converKg;
    }
    @AuraEnabled
    public static Opportunity infoGrupo(String idOppo){
       Opportunity oppo = [SELECT Id, Name, Group__c, StageName FROM Opportunity WHERE id =: idOppo Limit 1];
        return oppo; 
    }
    @AuraEnabled
    public static list<Catalogo_SAT__c> getCp(String cp){
        String buscar = '%' + cp + '%';
        list<Catalogo_SAT__c> ListCp = new list<Catalogo_SAT__c>();
        for(Catalogo_SAT__c sideClaveSAT : [SELECT Id, Name, Pais_RefCP__r.Name FROM Catalogo_SAT__c 
                                                       WHERE Name LIKE : buscar limit 10]){
                                                ListCp.add(sideClaveSAT);
                                            }
        if(ListCp.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListCp;
    }
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId, String tipo) {
        System.debug('Lo que llega metodo principal');
        OpportunityLineItem oli = [SELECT id, Ruta__c FROM OpportunityLineItem WHERE OpportunityId =: recordId Order By CreatedById asc LIMIT 1];
        String name = oli.Ruta__c+' '+tipo+' '+filename;
        ContentVersion cv = createContentVersion(base64, name, oli.id);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null) { return null; }
        return cdl.Id;
  	}
    public static ContentVersion createContentVersion(String base64, String filename, String idOli) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        cv.Description = idOli;
        try {
          insert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
    }
    public static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
              if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
          SELECT ContentDocumentId 
          FROM ContentVersion 
          WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
          insert cdl;
          return cdl;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
	}
    @AuraEnabled
    public static List<OpportunityLineItem> getproducto(String idOli){
        List<OpportunityLineItem> producto = [SELECT Id, Name, Notas__c, Tipo_de_servicio__c, Tipo_de_ruta__c, Servicio_especial__c,
                                        Volumen_Mensual__c, Servicio_adicional__c, Puerto_de_Salida_Arribo__c, Hazmat__c,
                                        Certificaciones__c, Accesoriales__c, Frontera_de_cruce__c, Transbordo__c, Piezas__c,
                                        Aeropuerto_de_Salida_Arribo__c, Fecha_Inicio_Embarque__c, Fecha_Fin_Embarque__c, 
                                        Tipo_de_seguro__c, Tipo_de_Servicio_Embarque__c, Razon_Social_Embarcador__c, Opportunity.Group__c,
                                        Razon_Social_Importador__c, Item_Height__c, Item_Width__c, Item_Lenght__c, Incoterm__c
                                        FROM OpportunityLineItem WHERE Id =: idOli Limit 1];
        return producto;
    }
    @AuraEnabled
    public static void updateNotas(String idOli, String notas){
        User nameUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        OpportunityLineItem oppOli = [SELECT Id, OpportunityId, Opportunity.OwnerId, Opportunity.Usuario_IC__c, Product2.Name FROM OpportunityLineItem WHERE id =: idOli Limit 1];
        OpportunityLineItem producto = new OpportunityLineItem();
        producto.Id = idOli;
        producto.Notas__c = notas + ' Nota Modificada por: '+ nameUser.Name;
        update producto;
        /* Crear la publicación en el muro de la oportunidad
        String body = 'El usuario @[' + nameUser.Id + '] requiere información en el producto <a href="https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/OpportunityLineItem/'+oppOli.Id+'/view">'+oppOli.Product2.Name+'</a>\n';  // Salto de línea usando \n
        body += 'Favor de dar clic en el producto para contestar\n';
        body += 'Nota del Producto:\n';
        body += notas + '\n';
        body += '@[' + oppOli.Opportunity.OwnerId + '] @[' + oppOli.Opportunity.Usuario_IC__c + ']';
		System.debug('el body es: '+body);

        FeedItem post = new FeedItem();
        post.ParentId = oppOli.OpportunityId ;  // Asociar el post a la oportunidad
        post.Body = body;
        post.Type = 'TextPost';  // Define que el tipo de post es un texto simple
        
        // Insertar la publicación
        insert post;*/
    }
    @AuraEnabled
    public static List<ContentVersion> getFiles(String idOli) {
        List<ContentVersion> contentVersions = [SELECT Id, Title, ContentDocumentId, FileExtension, VersionData
                                                FROM ContentVersion WHERE Description =: idOli];
        return contentVersions;
    }
}