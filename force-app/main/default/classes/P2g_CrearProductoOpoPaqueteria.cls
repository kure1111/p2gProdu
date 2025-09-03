public class P2g_CrearProductoOpoPaqueteria {
    @AuraEnabled
    public static List<PricebookEntry> getProductos(){
        List<PricebookEntry> producto = [SELECT Id, Name, UnitPrice, PROJ_Buy_Price__c, Product2Id, Product2.CurrencyIsoCode,
                                         Pricebook2Id, Pricebook2.Name FROM PricebookEntry 
                                         WHERE Name LIKE: '%General%' AND Pricebook2.Name LIKE: '%Paqueteria%'];
        return producto;
    }
    public class csvProduct {
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String opportunityId { get; set; }
        @AuraEnabled public String PricebookEntryId { get; set; }
        @AuraEnabled public String Product2Id { get; set; }
        @AuraEnabled public String idProduct2 { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String cantidad { get; set; }
        @AuraEnabled public String precioVenta { get; set; }
        @AuraEnabled public String frecuencia { get; set; }
        @AuraEnabled public String comentarios { get; set; }
        @AuraEnabled public String currencyOli { get; set; }
    }
    @AuraEnabled
    public static csvProduct getCsv(){
        csvProduct csv = new csvProduct();
        return csv;
    }
    @AuraEnabled
    public static String cargarProducto(string jsonProduct){
        String mensaje = '';
        System.debug('jsonProduct: '+jsonProduct);
        try{
        	P2g_CrearProductoOpoPaqueteria.csvProduct productInfo = (P2g_CrearProductoOpoPaqueteria.csvProduct)JSON.deserialize(jsonProduct, P2g_CrearProductoOpoPaqueteria.csvProduct.class);
        	OpportunityLineItem newOpportunityLineItem = llenarProducto(productInfo);
            if (newOpportunityLineItem != null) {
                insert newOpportunityLineItem;
                System.debug('Se creó un OpportunityLineItem: ' + newOpportunityLineItem.Id + newOpportunityLineItem.Name);
            }
            mensaje = 'Exito';
        }catch(Exception e){
            mensaje = 'Error al cargar producto: '+e.getMessage()+e.getLineNumber();
            System.debug(mensaje);     
        }
        return mensaje;
    }
    public static OpportunityLineItem llenarProducto(P2g_CrearProductoOpoPaqueteria.csvProduct productInfo){
        User nameUser = [SELECT Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = productInfo.opportunityId;
        oli.Product2Id = productInfo.product2Id;
        oli.PricebookEntryId = productInfo.pricebookEntryId;
        
        oli.Quantity = Decimal.valueOf(productInfo.cantidad);
        oli.PROJ_Frecuencia__c = productInfo.frecuencia; 
        oli.Notas__c = !String.isBlank(productInfo.comentarios) ? productInfo.comentarios : null;
        oli.Tipo_de_moneda__c = productInfo.currencyOli;
        oli.Status__c = productInfo.status;
        oli.UnitPrice = Decimal.valueOf(productInfo.precioVenta);
        return oli;
    }

}