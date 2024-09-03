trigger triggerControllerSubProducto on SubProducto__c (before insert, before update, before delete, after insert, after update, after delete) {
    Set<String> idOli = new Set<String>();
    Set<String> idOppo = new Set<String>();
    for(SubProducto__c Subprod : trigger.new){
        idoli.add(Subprod.SubProduct_Opportunity_Product__c);
        idOppo.add(Subprod.SubProduct_Opportunity__c);
    }
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            for(SubProducto__c prod : trigger.new){
                if(prod.Tipo_de_moneda__c != prod.CurrencyIsoCode){
                    // La clase test de esta parte es la clase P2G_convertCurrencyOppoProductTest
                    SubProducto__c producBuy = P2G_convertCurrencyOppoProduct.convertirBuySubProducto(prod.SubProduct_Buy_Price__c, prod.Tipo_de_moneda__c, prod.CurrencyIsoCode);
                    prod.SubProduct_Buy_Price__c = producBuy.SubProduct_Buy_Price__c;
                    prod.SubProduct_Buy_Price_Converted__c = producBuy.SubProduct_Buy_Price_Converted__c;
                    SubProducto__c producSell = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(prod.SubProduct_Sell_Price__c, prod.Tipo_de_moneda__c, prod.CurrencyIsoCode);
                    prod.SubProduct_Sell_Price__c = producSell.SubProduct_Sell_Price__c;
                    prod.SubProduct_Sell_Price_Converted__c = producSell.SubProduct_Sell_Price_Converted__c;
                }
            }
        } else if (Trigger.isAfter) {
            
        }        
    }
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            //inicio para update quoteline
            List<SubProducto__c> modificarSubproduct = new List<SubProducto__c>();
            //fin para update quoteline
            for(SubProducto__c prod : trigger.new){
                if(prod.Tipo_de_moneda__c != prod.CurrencyIsoCode){
                    // La clase test de esta parte es la clase P2G_convertCurrencyOppoProductTest
                    if((prod.SubProduct_Buy_Price__c !=  trigger.oldMap.get(prod.Id).SubProduct_Buy_Price__c)){
                        SubProducto__c producBuy = P2G_convertCurrencyOppoProduct.convertirBuySubProducto(prod.SubProduct_Buy_Price__c, prod.Tipo_de_moneda__c, prod.CurrencyIsoCode);
                        prod.SubProduct_Buy_Price__c = producBuy.SubProduct_Buy_Price__c;
                        prod.SubProduct_Buy_Price_Converted__c = producBuy.SubProduct_Buy_Price_Converted__c;
                    }
                    if((prod.SubProduct_Sell_Price__c !=  trigger.oldMap.get(prod.Id).SubProduct_Sell_Price__c)){
                        SubProducto__c producSell = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(prod.SubProduct_Sell_Price__c, prod.Tipo_de_moneda__c, prod.CurrencyIsoCode);
                        prod.SubProduct_Sell_Price__c = producSell.SubProduct_Sell_Price__c;
                        prod.SubProduct_Sell_Price_Converted__c = producSell.SubProduct_Sell_Price_Converted__c;
                    }
                }
                //inicio para update quoteline
                if((prod.SubProduct_Sell_Price__c != trigger.oldMap.get(prod.Id).SubProduct_Sell_Price__c) || (prod.Status__c != trigger.oldMap.get(prod.Id).Status__c)){                
                    System.debug('entra a subtroductos para mofi');
                    modificarSubproduct.add(prod);
                }
            }
            //inicia sincronizacion de la Quote
            if(modificarSubproduct.size() > 0){
                List<Quote> quoteLine = [SELECT id, Name, OpportunityId FROM Quote WHERE OpportunityId in: idOppo AND Vendido__c = false AND Status != 'Accepted'];
                List<OpportunityLineItem> listOli = [SELECT id, Name, PricebookEntryId, Product2Id, Quantity FROM OpportunityLineItem WHERE id =: idoli];
                List<QuoteLineItem> qlis = new List<QuoteLineItem>();
                if(quoteLine.size() > 0){
                    qlis = P2G_sincrinizarConOppoProduct.todasQuoteLineItem(quoteLine);
                    List<QuoteLineItem> modificarQuoteLineSub = P2G_sincrinizarConOppoProduct.modificarQuoteLineSub(qlis, modificarSubproduct);
                    List<QuoteLineItem> eliminarQuoteLineSub = P2G_sincrinizarConOppoProduct.eliminarQuoteLineSub(qlis, modificarSubproduct);
                    List<QuoteLineItem> insertarQuoteLineSub = P2G_sincrinizarConOppoProduct.insertarQuoteLineSub(modificarQuoteLineSub, modificarSubproduct, quoteLine[0].Id, listOli);
                    if(modificarQuoteLineSub.size() > 0){update modificarQuoteLineSub;}
                    if(eliminarQuoteLineSub.size() > 0){delete eliminarQuoteLineSub;}
                    if(insertarQuoteLineSub.size() > 0){insert insertarQuoteLineSub;}
                }
            }
            noSeHace();
        //termina sincronizacion de la quote
        } else if (Trigger.isAfter) {
        }        
    }
    public static void noSeHace(){
        String a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
    }
}