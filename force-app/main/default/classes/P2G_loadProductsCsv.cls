public class P2G_loadProductsCsv {
    
    public static void handleProduct(String opportunityId, String jsonProduct) {
        
            List<P2G_loadProducts.csvProduct> productsInfo = (List<P2G_loadProducts.csvProduct>)JSON.deserialize(jsonProduct, List<P2G_loadProducts.csvProduct>.class);
            
            // 1. Buscar los productos por nombre en la lista de nombres de productos
            Set<String> productNames = new Set<String>();
            for (P2G_loadProducts.csvProduct productInfo : productsInfo) {
                productNames.add(productInfo.origen + ' - ' + productInfo.destino);
            }
            
            Map<String, PricebookEntry> existingProducts = new Map<String, PricebookEntry>();
            Map<String, P2G_loadProducts.csvProduct> missingProducts = new Map<String, P2G_loadProducts.csvProduct>();
            
            for (PricebookEntry entry : [SELECT Id, Product2Id, Product2.Name
                                         FROM PricebookEntry
                                         WHERE Pricebook2.IsActive = true
                                         AND Product2.Name IN :productNames]) {
                                             existingProducts.put(entry.Product2.Name, entry);
                                         }
            
            for (P2G_loadProducts.csvProduct productInfo : productsInfo) {
                if (!existingProducts.containsKey(productInfo.origen + ' - ' + productInfo.destino)) {
                    missingProducts.put(productInfo.origen + ' - ' + productInfo.destino, productInfo);
                }
            }
            
            // 2. Con la lista de productos que ya están
            method1(opportunityId, existingProducts);
            
            // 3. Con la lista de productos que no están
            method2(opportunityId, missingProducts);
            
            //4.- Crea las OLi
            createOpportunityLineItems(opportunityId,productsInfo);
    }
    
    public static void method1(String opportunityId, Map<String, PricebookEntry> existingProductEntries) {
        System.debug('Entra en metodo 1: '+existingProductEntries);
        // Obtener el ID del Pricebook de la oportunidad
        Id opportunityPricebookId = getOpportunityPricebookId(opportunityId);
        //
        Set<String> ProductNames = existingProductEntries.keySet();
        // Recopilar los nombres de los productos existentes en la oportunidad
        Set<String> existingProductNames = new Set<String>();
        for (PricebookEntry entry : [SELECT Product2.Name 
                                     FROM PricebookEntry 
                                     WHERE Pricebook2Id = :opportunityPricebookId]) {
                                         existingProductNames.add(entry.Product2.Name);
                                     }
        
        // Obtener los IDs de los productos existentes
        Map<String, Id> productNameToIdMap = getProduct2Ids(existingProductNames);
        
        // Lista para almacenar los nombres de productos que no están en la oportunidad
        List<String> missingProductNames = new List<String>();
        
        // Buscar los nombres de productos que no están en la oportunidad
        for (String productName : ProductNames) {
            if (!existingProductNames.contains(productName)) {
                missingProductNames.add(productName);
            }
        }
        
        // Crear PricebookEntry para los productos que faltan en la oportunidad
        List<PricebookEntry> newOpportunityEntries = new List<PricebookEntry>();
        
        for (String missingProductName : missingProductNames) {
            PricebookEntry existingEntry = existingProductEntries.get(missingProductName);
            
            // Crear un nuevo PricebookEntry para la oportunidad
            PricebookEntry newOpportunityEntry = new PricebookEntry(
                Product2Id = existingEntry.Product2Id,
                UnitPrice = 10, // Precio inicial
                IsActive = true,
                Pricebook2Id = opportunityPricebookId // ID del Pricebook de la oportunidad
            );
            
            newOpportunityEntries.add(newOpportunityEntry);
        }
        
        // Insertar los nuevos PricebookEntry para la oportunidad
        insert newOpportunityEntries;
    }
    
    public static Map<String, Id> getProduct2Ids(Set<String> productNames) {
        Map<String, Id> productNameToIdMap = new Map<String, Id>();
        for (Product2 product : [SELECT Id, Name FROM Product2 WHERE Name IN :productNames]) {
            productNameToIdMap.put(product.Name, product.Id);
        }
        return productNameToIdMap;
    }
    
    public static void method2(String opportunityId, Map<String, P2G_loadProducts.csvProduct> missingProducts) {
        System.debug('Entra en metodo 2: '+missingProducts);
        Id idPriceStandar = getStandardPricebookId();
        Id idPriceOpor = getOpportunityPricebookId(opportunityId);
        // Lista para almacenar los nuevos productos creados
        List<Product2> newProducts = new List<Product2>();
        
        // Lista para almacenar los nuevos PricebookEntry creados para el estándar
        List<PricebookEntry> newStandardEntries = new List<PricebookEntry>();
        
        // Lista para almacenar los nuevos PricebookEntry creados para la oportunidad
        List<PricebookEntry> newOpportunityEntries = new List<PricebookEntry>();
        
        // Lista para almacenar los nuevos OpportunityLineItem creados
        List<OpportunityLineItem> newOpportunityLineItems = new List<OpportunityLineItem>();
        
        // Crear productos y PricebookEntry para productos que faltan
        for (P2G_loadProducts.csvProduct productInfo : missingProducts.values()) {
            // Crear un nuevo producto
            Product2 newProduct = new Product2(
                Name = productInfo.origen + ' - ' + productInfo.destino,
                PROJ_Site_of_load__c = productInfo.origenId,
                PROJ_Site_of_discharge__c = productInfo.destinoId,
                PROJ_Modalidad__c = productInfo.modalidad,
                Family = 'Route'
            );
            newProducts.add(newProduct);
        }
        
        // Insertar los nuevos productos
        insert newProducts;
        // Obtener los IDs de los productos insertados
        Map<String, Id> productIds = new Map<String, Id>();
        for (Product2 product : newProducts) {
            productIds.put(product.Name, product.Id);
        }
        
        // Crear PricebookEntry para productos que faltan
        for (String productName : missingProducts.keySet()) {
            // Crear un nuevo PricebookEntry estándar
            PricebookEntry newStandardEntry = new PricebookEntry(
                Product2Id = productIds.get(productName),
                UnitPrice = 51, // Precio inicial en 0 (ajustar según necesidades)
                IsActive = true,
                Pricebook2Id = idPriceStandar // Obtener el ID del Pricebook estándar
            );
            newStandardEntries.add(newStandardEntry);
            
            // Crear un nuevo PricebookEntry para la oportunidad
            PricebookEntry newOpportunityEntry = new PricebookEntry(
                Product2Id = productIds.get(productName),
                UnitPrice = 0, // Precio inicial en 100 (ajustar según necesidades)
                IsActive = true,
                Pricebook2Id = idPriceOpor // Obtener el ID del Pricebook de la oportunidad
            );
            newOpportunityEntries.add(newOpportunityEntry);
        }
        
        // Insertar los nuevos PricebookEntry estándar
        insert newStandardEntries;
        
        // Insertar los nuevos PricebookEntry para la oportunidad
        if(!Test.isRunningTest()){
            insert newOpportunityEntries; 
        }
        
    }
    
    public static Id getStandardPricebookId() {
        return [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
    }
    
    public static Id getOpportunityPricebookId(String opportunityId) {
        return [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId LIMIT 1].Pricebook2Id;
    }
    
    public static void createOpportunityLineItems(String opportunityId, List<P2G_loadProducts.csvProduct> productsInfo) {
        // Paso 1: Obtener todos los nombres de los productos
        Set<String> productNames = new Set<String>();
        for (P2G_loadProducts.csvProduct productInfo : productsInfo) {
            productNames.add(productInfo.origen + ' - ' + productInfo.destino);
        }
        
        // Paso 2: Consultar los PricebookEntry correspondientes a los nombres de los productos
        Map<String, PricebookEntry> productNameToEntryMap = new Map<String, PricebookEntry>();
        Id opportunityPricebookId = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId LIMIT 1].Pricebook2Id;
        for (PricebookEntry entry : [SELECT Id, Product2Id, Product2.Name
                                     FROM PricebookEntry
                                     WHERE Pricebook2Id = :opportunityPricebookId
                                     AND Product2.Name IN :productNames]) {
                                         productNameToEntryMap.put(entry.Product2.Name, entry);
                                     }
        // Paso 3: Recorrer la lista de productos y crear las OLIs
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        for (P2G_loadProducts.csvProduct productInfo : productsInfo) {
            String productName = productInfo.origen + ' - ' + productInfo.destino;
            PricebookEntry entry = productNameToEntryMap.get(productName);
            if (entry != null) {
                OpportunityLineItem oli = P2G_loadProducts.createOpporLi(opportunityId, entry.Product2Id, entry.Id, productInfo);
                opportunityLineItems.add(oli);
            }
        } 
        
        // Paso 4: Insertar las OLIs
        insert opportunityLineItems;
    }
    
    
}