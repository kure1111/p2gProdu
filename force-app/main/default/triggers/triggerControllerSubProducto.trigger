trigger triggerControllerSubProducto on SubProducto__c (before insert, before update, before delete, after insert, after update, after delete) {
    Set<String> idOli = new Set<String>();
    for(SubProducto__c Subprod : trigger.new){
        idoli.add(Subprod.SubProduct_Opportunity_Product__c);
    }
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            List<OpportunityLineItem> oppo = [SELECT Id, CurrencyIsoCode, opportunity.Group__c, opportunityId  FROM OpportunityLineItem WHERE Id IN: idOli]; 
            for(SubProducto__c prod : trigger.new){
                for(OpportunityLineItem oppoCurrency : oppo){
                    if(oppoCurrency.id == prod.SubProduct_Opportunity_Product__c){
                        prod.SubProduct_Opportunity__c = oppoCurrency.opportunityId;
                        // La clase test de esta parte es la clase P2G_convertCurrencyOppoProductTest
                        if(prod.CurrencyIsoCode != oppoCurrency.CurrencyIsoCode){
                            SubProducto__c producBuy = P2G_convertCurrencyOppoProduct.convertirBuySubProducto(prod.SubProduct_Buy_Price__c, prod.CurrencyIsoCode, oppoCurrency.CurrencyIsoCode);
                            prod.SubProduct_Buy_Price__c = producBuy.SubProduct_Buy_Price__c;
                            prod.SubProduct_Buy_Price_Converted__c = producBuy.SubProduct_Buy_Price_Converted__c;
                            SubProducto__c producSell = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(prod.SubProduct_Sell_Price__c, prod.CurrencyIsoCode, oppoCurrency.CurrencyIsoCode);
                            prod.SubProduct_Sell_Price__c = producSell.SubProduct_Sell_Price__c;
                            prod.SubProduct_Sell_Price_Converted__c = producSell.SubProduct_Sell_Price_Converted__c;
                            prod.CurrencyIsoCode = oppoCurrency.CurrencyIsoCode;
                        }
                    }
                }
            }
        } else if (Trigger.isAfter) {
            
        }        
    }
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            List<OpportunityLineItem> oppo = [SELECT Id, CurrencyIsoCode, opportunityId, opportunity.Group__c  FROM OpportunityLineItem WHERE Id IN: idOli]; 
            for(SubProducto__c prod : trigger.new){
                for(OpportunityLineItem oppoCurrency : oppo){
                    if(oppoCurrency.id == prod.SubProduct_Opportunity_Product__c){
                        prod.SubProduct_Opportunity__c = oppoCurrency.opportunityId;
                        // La clase test de esta parte es la clase P2G_convertCurrencyOppoProductTest
                        if(prod.CurrencyIsoCode != oppoCurrency.CurrencyIsoCode){
                            if((prod.SubProduct_Buy_Price__c !=  trigger.oldMap.get(prod.Id).SubProduct_Buy_Price__c)){
                               SubProducto__c produc = P2G_convertCurrencyOppoProduct.convertirBuySubProducto(prod.SubProduct_Buy_Price__c, prod.CurrencyIsoCode, oppoCurrency.CurrencyIsoCode);
                               prod.SubProduct_Buy_Price__c = produc.SubProduct_Buy_Price__c;
                               prod.SubProduct_Buy_Price_Converted__c = produc.SubProduct_Buy_Price_Converted__c;
                               prod.CurrencyIsoCode = oppoCurrency.CurrencyIsoCode;
                            }
                        }
                        if((prod.SubProduct_Sell_Price__c !=  trigger.oldMap.get(prod.Id).SubProduct_Sell_Price__c)){
                            if(prod.SubProduct_Buy_Price_Converted__c != null && prod.SubProduct_Buy_Price_Converted__c != ''){
                                String[] buyConverted = prod.SubProduct_Buy_Price_Converted__c.split(' ');
        	                    SubProducto__c produc = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(prod.SubProduct_Sell_Price__c, buyConverted[0], oppoCurrency.CurrencyIsoCode);
                                prod.SubProduct_Sell_Price__c = produc.SubProduct_Sell_Price__c;
                                prod.SubProduct_Sell_Price_Converted__c = produc.SubProduct_Sell_Price_Converted__c;
                                prod.CurrencyIsoCode = oppoCurrency.CurrencyIsoCode;
                            }else{
                                SubProducto__c produc = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(prod.SubProduct_Sell_Price__c, prod.CurrencyIsoCode, oppoCurrency.CurrencyIsoCode);
                                prod.SubProduct_Sell_Price__c = produc.SubProduct_Sell_Price__c;
                                prod.SubProduct_Sell_Price_Converted__c = produc.SubProduct_Sell_Price_Converted__c;
                                prod.CurrencyIsoCode = oppoCurrency.CurrencyIsoCode;
                            }
                        }
                    }
                }
            }
        } else if (Trigger.isAfter) {
            
        }        
    }
}