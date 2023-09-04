public with sharing class NEU_Generate_Supplier_Orders {

   public Customer_Quote__c record = null;
   ApexPages.StandardController con;
   public NEU_Generate_Supplier_Orders(ApexPages.StandardController stdController) {
         
            if(!Test.isRunningTest()){stdController.AddFields(new String[]{'Id','Name','Account_for__c'});}
            con=stdController;
            record=(Customer_Quote__c)stdController.getRecord();
     }
    public PageReference generate()
    {
    	List<Quote_Item_Line__c>lines=[select Id,Name,Item_Supplier_Owner__c,Item_Name__c,Item_Price__c,Family__c,Subfamily__c,Total_Shipping_Weight_Kgs__c,Total_Shipping_Volume_m3__c,Units__c from Quote_Item_Line__c where Import_Export_Quote__c=:record.Id];
    	List<Supplier_Quote__c>orders=new List<Supplier_Quote__c>();
    	List<Supplier_Quote_Line__c>orderlines=new List<Supplier_Quote_Line__c>();
    	for(Quote_Item_Line__c line:lines)
    	{
    		Supplier_Quote__c sorder=null;
    		for(Supplier_Quote__c so:orders)
    			if(so.Supplier__c==line.Item_Supplier_Owner__c)
    			{
    				sorder=so;
    				break;
    			}
    		if(sorder==null)
    		{
    			sorder=new Supplier_Quote__c();
    			sorder.Supplier__c=line.Item_Supplier_Owner__c;
    			orders.add(sorder);
    			sorder.Supplier_Quote_Order_Ref_Number__c=record.Name+'-'+String.valueOf(orders.size());
    			sorder.Import_Export_Quote_Order__c=record.Id;
    			sorder.Supplier_Quote_Status__c='Draft';
    			sorder.Customer__c=record.Account_for__c;
    		}
    		Supplier_Quote_Line__c sorderline=new Supplier_Quote_Line__c();
    		sorderline.Supplier_Quote__r=sorder;
    		sorderline.Price__c=line.Item_Price__c;
    		sorderline.Family__c=line.Family__c;
    		sorderline.Subfamily__c=line.Subfamily__c;
    		sorderline.Total_Weight_Kg__c=line.Total_Shipping_Weight_Kgs__c;
    		sorderline.Total_Volume_m3__c=line.Total_Shipping_Volume_m3__c;
    		sorderline.Quantity__c=line.Units__c;
    		sorderline.Import_Export_Item_Line__c=line.Id;
    		sorderline.Item__c=line.Item_Name__c;
    		Integer counter=1;
    		for(Supplier_Quote_Line__c l:orderlines)
    			if(l.Supplier_Quote__r==sorder)
    				counter++;
    		sorderline.Name=String.valueOf(counter);
    		while(sorderline.Name.length()<3)
    			sorderline.Name='0'+sorderline.Name;
    		orderlines.add(sorderline);
    	}
    	if(orders.size()>0)
    	{
    		insert orders;
    		if(orderlines.size()>0)
    		{
    			for(Supplier_Quote_Line__c line:orderlines)
    				line.Supplier_Quote__c=line.Supplier_Quote__r.Id;
    			insert orderlines;
    		}
    	} 
        return con.view();
    }
}