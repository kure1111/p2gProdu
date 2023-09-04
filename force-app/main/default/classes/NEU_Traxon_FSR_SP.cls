public with sharing class NEU_Traxon_FSR_SP extends NEU_Traxon_FSR{
	public static String[]usedFields=new String[]{
		'Id'
		,'MAWB_Number__c'
		};
		
	ApexPages.StandardController con;
	public Shipment_Program__c recordSP {get;set;}	
    public NEU_Traxon_FSR_SP(ApexPages.StandardController stdController) 
    {
    	if (!Test.isRunningTest()) {stdController.AddFields(usedFields);}
        con = stdController;
        recordSP=(Shipment_Program__c)con.getRecord();
    }
}