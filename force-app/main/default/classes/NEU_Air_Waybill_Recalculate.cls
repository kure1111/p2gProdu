public with sharing class NEU_Air_Waybill_Recalculate 
{
	public Air_Waybill__c record;
	public List<Air_Waybill_Line__c> lines=new List<Air_Waybill_Line__c>();
	public List<Waybill_Other_Charge__c> other_charge=new List<Waybill_Other_Charge__c>();
	ApexPages.StandardController con;
	
	public NEU_Air_Waybill_Recalculate(ApexPages.StandardController stdController) 
    {
    	con = stdController;
        //record=[select Id from Air_Waybill__c where Air_Waybill__c=:con.getRecord().Id];
        lines=[select Id, Chargeable_Weight__c from Air_Waybill_Line__c where Air_Waybill__c=:con.getRecord().Id];
        other_charge=[select Id, Charge_Amount__c, Other_Charge_Rate__c from Waybill_Other_Charge__c where Waybill__c=:con.getRecord().Id];        
    }
    
    public PageReference recalculate()
    {		
		for (Air_Waybill_Line__c line : lines)
			line.Chargeable_Weight__c = 1;
		
		for (Waybill_Other_Charge__c other : other_charge)
		{
			if(other.Other_Charge_Rate__c != 0)
				other.Charge_Amount__c = 1;
			else
				other.Charge_Amount__c = other.Charge_Amount__c;
		}						
    	update lines;
    	update other_charge; 
    	
    	PageReference pgReturnPage;
	    String returnUrl = '/' + con.getRecord().Id;
	    pgReturnPage = new PageReference(returnUrl);
	    pgReturnPage.setRedirect(true);
	    return pgReturnPage;
    }   
}