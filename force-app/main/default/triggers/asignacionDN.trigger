trigger asignacionDN on Customer_Quote__c (after Update) {
    if(!Test.isRunningTest()){APX_Debit_Note.asignacionDNaFolio(Trigger.Old, Trigger.New);}else{system.debug('isrunningtestXD');}
    // APX_Debit_Note.asignacionDNaFolio(Trigger.New);
}