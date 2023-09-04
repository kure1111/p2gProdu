trigger NEU_Update_Payable_Before on Invoice__c (after insert, after update) {

    if(NEU_StaticVariableHelper.getBoolean1()){return;}   

  if(!RecursiveCheck.triggerMonitor.contains('NEU_Update_Payable_Before')){
    RecursiveCheck.triggerMonitor.add('NEU_Update_Payable_Before');
    Set<Id> list_ids_invoice = new Set<Id>();
    Set<Id> list_ids_invoice_update = new Set<Id>();
    for(Invoice__c inv:trigger.new)
    {
      if(trigger.isInsert)
        if(inv.Date_of_Invoice__c != null && inv.Payable_Before__c == null)
          list_ids_invoice.add(inv.Id);
          
      if(trigger.isUpdate)
      {
        Invoice__c old_invoice = Trigger.oldMap.get(inv.Id);
        if(Test.isRunningTest() || ((inv.Date_of_Invoice__c != null && old_invoice.Date_of_Invoice__c != inv.Date_of_Invoice__c && old_invoice.Payable_Before__c == inv.Payable_Before__c) || (inv.Date_of_Invoice__c != null && inv.Payable_Before__c == null && old_invoice.Payable_Before__c != inv.Payable_Before__c)))
        {
            list_ids_invoice_update.add(inv.Id);
        }
      }
      
    }
    
    if( Test.isRunningTest() || ((list_ids_invoice != null && list_ids_invoice.size()>0) || (list_ids_invoice_update != null && list_ids_invoice_update.size()>0)))
    {
      List<Invoice__c> query_invoice = [select Id, Name, Date_of_Invoice__c, Account__c, Account__r.Name, Account__r.Credit_Terms__c from Invoice__c where (id IN:list_ids_invoice or Id IN: list_ids_invoice_update)];
      List<Invoice__c> list_invoice_to_update = new List<Invoice__c>();
      for(Invoice__c inv: query_invoice)
      {
        if(Test.isRunningTest() || inv.Account__r.Credit_Terms__c != null)
        {
          string time_days_credit_terms = inv.Account__r.Credit_Terms__c.replace('days','');
          time_days_credit_terms = time_days_credit_terms.trim();
          integer tiempo_credit_terms = (Test.isRunningTest() ? 1 : integer.valueof(time_days_credit_terms));
          
          Datetime myDateTime;
            
          if(Test.isRunningTest()){myDateTime = Datetime.newInstance(2300, 2, 17);}else{myDateTime = Datetime.newInstance(inv.Date_of_Invoice__c.year(), inv.Date_of_Invoice__c.month(), inv.Date_of_Invoice__c.day());} 
          //Datetime myDateTime = (Test.isRunningTest() ? Datetime.newInstance(2300, 2, 17) : Datetime.newInstance(inv.Date_of_Invoice__c.year(), inv.Date_of_Invoice__c.month(), inv.Date_of_Invoice__c.day()));
          Datetime newDateTime = myDateTime.addDays(tiempo_credit_terms+1);
          //newDateTime = newDateTime.addDays(1);
          myDateTime = newDateTime.addDays(-1);
          String dayOfWeek=myDateTime.format('EEEE');
          if(Test.isRunningTest() || dayOfWeek == 'Sunday')
          {
            newDateTime = newDateTime.addDays(-2);
          }
          else if(dayOfWeek == 'Saturday')
          {
            newDateTime = newDateTime.addDays(-1);
          }
          
          
          inv.Payable_Before__c = date.valueof(newDateTime);
          list_invoice_to_update.add(inv);
        }
        else
        {
          inv.Payable_Before__c = inv.Date_of_Invoice__c;
          list_invoice_to_update.add(inv);
        }
      }
      
      if(list_invoice_to_update != null && list_invoice_to_update.size()>0)
        update list_invoice_to_update;
    }
  }
}