global class PAK_PagoContado {
    global class status{
        webservice String code {get; set;}
        webservice String message {get; set;}
    }
    
    global class pago{
        webservice String shipmentId {get;set;}
        webservice String montoPago {get;set;}
        webservice String currencyIsoCode {get;set;}
    }
    
    webservice static status pagoContado(pago p){
        Response__c r = new Response__c();
        status s = new status();
        r.Type__c = 'CONFIRM';
        try{
            List<Shipment__c> shipment = [SELECT Id, Pago_Contado_SAP__c FROM Shipment__c WHERE Id =:p.shipmentId];
            if(shipment.size() > 0){
                r.Shipment__c = shipment[0].Id;
                r.Object__c = 'Shipment';
                
                Decimal pagoSap = shipment[0].Pago_Contado_SAP__c != null ? shipment[0].Pago_Contado_SAP__c : 0;
                System.debug('Monto actual: ' + pagoSap);
                shipment[0].Pago_Contado_SAP__c = pagoSap + Decimal.valueOf(p.montoPago);
                
                if(!string.isBlank(p.currencyIsoCode))
                      shipment[0].CurrencyIsoCode = p.currencyIsoCode;
                
                update shipment[0];
                
                s.code = '1';
                s.message = 'Pago contado - Pago realizado por la cantidad de $' + p.montoPago; 
                r.Message__c = 'Pago contado - Pago realizado por la cantidad de $' + p.montoPago;    
                insert r;
            }else{s.code = '0';s.message = 'Pago contado - No existe el shipmentId proporcionado';}            
            
            return s;
        }catch(Exception e){s.code = '0';s.message = 'Error pago contado;' + e.getCause()+' - '+e.getMessage() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();return s;}
    }
}