public with sharing class NEU_Shipment_View_Route extends NEU_Shipment_Program_View_Route{
	public static String[]usedFieldsShipment=new String[]{
		'Id'
		,'Name'
		};
    public NEU_Shipment_View_Route(ApexPages.StandardController stdController) 
    {
    	if (!Test.isRunningTest()) {stdController.AddFields(usedFieldsShipment);}
    	readSP(stdController.getId());
    }
}