trigger NEU_OM_Update_Account_Authorized_Credit on Account (after update) {

  if(NEU_StaticVariableHelper.getBoolean1())
    return;

  	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_OM_Update_Account_Authorized_Credit')){
        RecursiveCheck.triggerMonitor.add('NEU_OM_Update_Account_Authorized_Credit');
        List<Customer_Quote__c> lista_import_export=null;
        for(Account cu : trigger.new)
        {
          Account oldaccount = Trigger.oldMap.get(cu.Id);
          if(cu.Authorized_Credit__c != oldaccount.Authorized_Credit__c)
          {
            lista_import_export = [select Id, Name, Authorized_Credit__c, Quotation_Status__c  from Customer_Quote__c where Account_for__c =: cu.Id and (Quotation_Status__c =:'Approved as Succesful' or Quotation_Status__c=:'Partially Shipped')];
            for(Customer_Quote__c cq:lista_import_export)
            {
              cq.Authorized_Credit__c=cu.Authorized_Credit__c;
            }
            
            try
            {
              update lista_import_export;
            }
            catch(Exception ex)
            {
              
            }
          }
    }
    }        
}