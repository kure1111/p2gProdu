trigger NEU_OM_Update_Authorized_Credit_ImportExport on Customer_Quote__c (before insert) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    Set<Id>aids=new Set<Id>();
    for(Customer_Quote__c cq : trigger.new)
        if(cq.Account_for__c!=null)
            aids.add(cq.Account_for__c);
    Map<Id,Boolean>acs=new Map<Id,Boolean>();
    for(Account a:[select Id,Authorized_Credit__c from Account where Id IN:aids])
        acs.put(a.Id,a.Authorized_Credit__c);
    for(Customer_Quote__c cq : trigger.new)
        if(cq.Account_for__c!=null)
        {
            Boolean c=acs.get(cq.Account_for__c);
            if(c!=null)
                cq.Authorized_Credit__c = c;
        }
}