public with sharing class NEU_Capture_Catalog_Price_List extends NEU_Controller_Comparable{
	public Price_List__c record = null;
	ApexPages.StandardController con;
	public NEU_Capture_Catalog_Price_List(ApexPages.StandardController stdController)
	{
		if(!Test.isRunningTest()){stdController.AddFields(new String[]{'Id','Items_Account_Owner__c'});}
    	con=stdController;
		record=(Price_List__c)stdController.getRecord();
	}
    public PageReference cancel()
    {
		return con.view();
    }
    public void resetData()
    {
    	myList=null;
    }
    public PageReference saveData()
    {
    	List<Sourcing_Item__c>items=new List<Sourcing_Item__c>();
    	List<Item_List_Price__c>ilps=new List<Item_List_Price__c>();
    	for(Item_List_Price_s ilp:myList)
    	{
    		if(String.IsNotEmpty(ilp.ilp.Item_Name__r.Name))
    		{
	    		ilps.add(ilp.ilp);
	   			items.add(ilp.ilp.Item_Name__r);
    		}
    	}
    	if(items.size()>0)
    		upsert items;
    	if(ilps.size()>0)
    	{
			for(Item_List_Price__c ilp:ilps)
				if(ilp.Item_Name__c==null)
					ilp.Item_Name__c=ilp.Item_Name__r.Id;
			upsert ilps;
    	}
		return con.view();
    }
    public List<Item_List_Price_s> myList{
    	get
    	{
    		if(myList==null)
    		{
    			myList=new List<Item_List_Price_s>();
				ID recordId=record.Id;    			
    			String query='select Id,Item_Name__c,Item_Name__r.Id,Item_Name__r.Name,Item_Name__r.Sourcing_Item_Code__c,Item_Name__r.Item_Description__c,Item_Name__r.Unit_of_measure__c,List_Price__c,JIT_MOQ__c from Item_List_Price__c where Price_List__c=:recordId';
    			List<Item_List_Price__c>ilps=(List<Item_List_Price__c>)DataBase.query(query);
    			for(Item_List_Price__c ilp:ilps)
    			{
    				Item_List_Price_s myItem=new Item_List_Price_s(this);
	    			myItem.ilp=ilp;
    				myList.add(myItem);
    			}
/*				Item_List_Price_s myItem=new Item_List_Price_s(this);
    			myItem.ilp=new Item_List_Price__c();
	    		myItem.ilp.Price_List__c=record.id;
	    		myItem.ilp.Item_Name__r=new Sourcing_Item__c();
	    		myItem.ilp.Item_Name__r.Account_Owner__c=record.Items_Account_Owner__c;
				myList.add(myItem);*/
    		}
    		return myList;
    	}
    	set
    	{
    		if(myList!=value)
    			myList=value;
    	}
    }
    public override void sortList(Integer sortList)
    {
    	myList.sort();
    }
    public Integer numLines{get;set;}
    public void addLines()
    {
    	for(Integer counter=0;counter<numlines;counter++)
    	{
    		Item_List_Price_s myItem=new Item_List_Price_s(this);
    		myItem.ilp=new Item_List_Price__c();
    		myItem.ilp.Price_List__c=record.id;
    		myItem.ilp.Item_Name__r=new Sourcing_Item__c();
    		myItem.ilp.Item_Name__r.Account_Owner__c=record.Items_Account_Owner__c;
    		myList.add(myItem);
    	}
    }
    public void addLine()
    {
		Item_List_Price_s myItem=new Item_List_Price_s(this);
		myItem.ilp=new Item_List_Price__c();
		myItem.ilp.Price_List__c=record.id;
		myItem.ilp.Item_Name__r=new Sourcing_Item__c();
		myItem.ilp.Item_Name__r.Account_Owner__c=record.Items_Account_Owner__c;
		myList.add(myItem);
    }
    public String idLines{get;set;}
    public Integer firstLine{get;set;}
    public void orderLines()
    {
    	List<String>pasteids=idLines.split('_\\|_');
    	Integer pasteCounter=firstLine;
    	for(String pasteid:pasteIds)
    	{
    		Item_List_Price_s myItem=null;
    		Integer myLine=pasteCounter;
    		for(;myLine<myList.size();myLine++)
    			if(myList[myLine].ilp.Item_Name__r.Name==pasteid)
    			{
    				myItem=myList[myLine];
    				break;
    			}
    		if(myItem!=null)
    		{
    			if(pasteCounter!=myLine)
    				myList.add(pasteCounter,myList.remove(myLine));
				pasteCounter++;
				continue;
    		}
			myItem=new Item_List_Price_s(this);
			myItem.ilp=new Item_List_Price__c();
			myItem.ilp.Price_List__c=record.id;
			myItem.ilp.Item_Name__r=new Sourcing_Item__c();
			myItem.ilp.Item_Name__r.Name=pasteid;
			myItem.ilp.Item_Name__r.Account_Owner__c=record.Items_Account_Owner__c;
   			myList.add(pasteCounter,myItem);
    		pasteCounter++;
    	}
    }
    public class Item_List_Price_s extends NEU_Line_Comparable
    {
		public Item_List_Price_s(NEU_Controller_Comparable parent)
        {
        	super(parent);
        }
        public override Object getValue(String compareField)
    	{
	        return getValue(ilp,compareField);
    	}
        public Item_List_Price__c ilp{get;set;}
    }
}