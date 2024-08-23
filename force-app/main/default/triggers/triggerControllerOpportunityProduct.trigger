trigger triggerControllerOpportunityProduct on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete) {
	switch on Trigger.operationType {
        when before_update {
            for(OpportunityLineItem oli : trigger.new){
                // para convertir la moneda del buy price y del sales price.
                // La clase test de esta parte es la clase P2G_convertCurrencyOppoProductTest
                if(oli.CurrencyIsoCode != oli.Tipo_de_moneda__c && oli.Tipo_de_moneda__c != null){
                    if((oli.Buy_Price__c !=  trigger.oldMap.get(oli.Id).Buy_Price__c)){
                        OpportunityLineItem produc = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Buy Price', oli.Buy_Price__c, oli.Tipo_de_moneda__c, oli.CurrencyIsoCode);
                        oli.Buy_Price__c = produc.Buy_Price__c;
                        oli.Buy_Price_Converted__c = produc.Buy_Price_Converted__c;
                    }
                    if((oli.UnitPrice !=  trigger.oldMap.get(oli.Id).UnitPrice)){
                        OpportunityLineItem produc = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Sales Price', oli.UnitPrice, oli.Tipo_de_moneda__c, oli.CurrencyIsoCode);
                        oli.UnitPrice = produc.UnitPrice;
                        oli.Sales_Price_Converted__c = produc.Sales_Price_Converted__c;
                    } 
                }
            }
        }
    }
}