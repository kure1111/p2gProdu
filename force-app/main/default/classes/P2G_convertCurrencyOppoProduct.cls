public class P2G_convertCurrencyOppoProduct {
	public static OpportunityLineItem actualizarBuyPriceCurrency(String tipo, Decimal buyPrice, String tipoCurrency, String opCurrency){
        OpportunityLineItem oli = new OpportunityLineItem();
        List<CurrencyType> tasaDeCambio = [SELECT ConversionRate,IsoCode,LastModifiedDate FROM CurrencyType WHERE IsoCode = :opCurrency or IsoCode = :tipoCurrency ORDER BY LastModifiedDate desc LIMIT 2];
        Decimal cantidadModificada;
        Decimal cantidad;
        If(opCurrency == 'MXN'){
        System.debug('entra al if buy price: '+buyPrice);
            cantidadModificada = tazaDeCambio(tasaDeCambio,buyPrice,tipoCurrency,True);
        }else If((tipoCurrency != 'MXN')&&(opCurrency != 'MXN')){
        System.debug('entra al else if buy price: '+buyPrice);
            cantidad = tazaDeCambio(tasaDeCambio,buyPrice,tipoCurrency,True);
            cantidadModificada = tazaDeCambio(tasaDeCambio,cantidad,opCurrency,False);
        }else{
        System.debug('entra al else buy price: '+buyPrice);
            cantidadModificada = tazaDeCambio(tasaDeCambio,buyPrice,opCurrency,False);
        }
        System.debug('cantidad Modificada: '+cantidadModificada+' buy price: '+buyPrice);
        if(tipo == 'Buy Price'){
            oli.Buy_Price__c = cantidadModificada;
            oli.Buy_Price_Converted__c = tipoCurrency+' '+buyPrice;
        }else{
            oli.UnitPrice = cantidadModificada;
            oli.Sales_Price_Converted__c = tipoCurrency+' '+buyPrice;
        }
        return oli;
    }

    Public static Decimal tazaDeCambio(List<CurrencyType> tasaDeCambio,Decimal buyPrice, String currencyTipo, Boolean mxn){
        Decimal cantidad;
        Decimal cantidadRound;
        for(CurrencyType tasa : tasaDeCambio){
            if((currencyTipo == tasa.IsoCode) && (mxn == False)){
                cantidad = buyPrice * tasa.ConversionRate;
            }else if((currencyTipo == tasa.IsoCode) && (mxn == True)){
                cantidad = buyPrice / tasa.ConversionRate;
            }
        }
        cantidadRound = cantidad.setScale(2, System.RoundingMode.HALF_UP);
        return cantidadRound;
    }
}