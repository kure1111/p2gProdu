trigger PAK_TASK_tgr on Task (After insert, before insert, before update, After update) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    if(trigger.isAfter && trigger.isInsert){
      	list<Customer_Quote__c> ls = new list<Customer_Quote__c>();
    	ls = [Select Id,Date_Send_Quote__c From Customer_Quote__c Where Id=:trigger.new[0].WhatId];
    	if(!ls.isEmpty()){ls[0].Date_Send_Quote__c = Datetime.now();Update ls[0];}  
    }
    if(trigger.isBefore){
        list<Contact> contacto = new list<Contact>();
        contacto = [Select Id,MailingAddress,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode From Contact Where Id=:trigger.new[0].WhoId];
        System.debug('--'+contacto.size());
        if(!contacto.isEmpty()){String Address = '';if(contacto[0].MailingAddress != null){Address = contacto[0].MailingStreet+' '+contacto[0].MailingCity+' '+contacto[0].MailingPostalCode+' '+contacto[0].MailingState+' '+contacto[0].MailingCountry;System.debug('--'+Address);}for(Task A: trigger.new){A.Contact_Address__c=Address;}}  
    }
 	*/
}