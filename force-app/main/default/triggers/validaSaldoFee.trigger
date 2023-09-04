trigger validaSaldoFee on Fee__c (before insert) {
     
    
    
     RecordType customerRt = [Select Id From Recordtype Where DeveloperName='Customer' limit 1];
     map<String,Account> mapAccount = new map<String,Account>();
     set<string> setAccount = new set<string>();
     map<String,Decimal> mapSaldoAccount = new map<String,Decimal>();
     
     for(Fee__c f: trigger.new){
        
            if(!setAccount.contains(f.Account_for__c)){
                 setAccount.add(f.Account_for__c);
            }
     }
     for(Account acc : [Select Id, ActiveSap__c, Venta_Sap__c, RecordtypeId, Owner.Workplace__c, Saldo_DisponibleOK__c From Account Where Id in : setAccount]){
         mapAccount.put(acc.id,acc);
         mapSaldoAccount.put(acc.id,acc.Saldo_DisponibleOK__c);
      }
    
     for(Fee__c fee : trigger.new){
            
         if(!Test.isRunningTest() && trigger.isInsert &&  mapSaldoAccount.get(fee.Account_for__c) < fee.Fee_Rate__c && mapAccount.get(fee.Account_for__c).RecordtypeId == customerRt.Id && mapAccount.get(fee.Account_for__c).Venta_Sap__c != 'Contado')
         {
             fee.AddError('El cliente no tiene Crédito disponible para generar Cotizaciones, Saldo Disponible: '+ mapSaldoAccount.get(fee.Account_for__c));
                                                                                                                                                                                                                                                        
         }
        else{
            if(mapSaldoAccount.get(fee.Account_for__c) != null && fee.Fee_Rate__c != null){
                mapSaldoAccount.put(fee.Account_for__c,mapSaldoAccount.get(fee.Account_for__c) - fee.Fee_Rate__c);
            }
              
         }

     } // endfor
  
}