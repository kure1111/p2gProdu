public with sharing class NEU_Allocate_Account_Items {

    private Account record;
        
    public NEU_Allocate_Account_Items(ApexPages.StandardController stdController)
    {
        if(!Test.isRunningTest()) stdController.AddFields(new String[]{'Id','Name','Business_Area__c'});
        record = (Account)stdController.getRecord();
        family=new List<String>();
        for(Family_Supplied__c s:[select Family__c from Family_Supplied__c where Item__c=null and Subfamily__c=null and Supplier_Account__c=:record.Id])
            family.add(s.Family__c);
    }
    
    private boolean refreshsubfamily=true;
    private boolean refreshitems=true;

    public List<String> family{
        get;
        set
        {
            if(family!=value)
            {
                family=value;
                refreshsubfamily=true;
                subfamilies=null;
            }
        }
    }
    
    public List<SelectOption> families
    {
        get
        {
            if(families==null)
            {
                families=new List<SelectOption>();
                List<Product_Family__c>fam;
                List<String>ba=new List<String>();
                if(record.Business_Area__c!=null)
                    ba=record.Business_Area__c.split(';');
                if(ba.size()>0)
                    fam=[select Id,Name from Product_Family__c where Business_Area__c IN :ba order by Name];
                else
                    fam=[select Id,Name from Product_Family__c order by Name];
                for(Product_Family__c f:fam)
                if(f.Name.length()>40)
                    families.add(new SelectOption(f.Id,f.Name.Substring(0,40)));
                else
                    families.add(new SelectOption(f.Id,f.Name));
            }
            return families;
        }
        set;
    }

    public List<String> subfamily
    {
        get
        {
            if(refreshsubfamily)
            {
                subfamily=new List<String>();
                List<Id>ids=new List<Id>();
                for(SelectOption i:subfamilies)
                    ids.add(i.getValue());
                for(Family_Supplied__c s:[select Subfamily__c from Family_Supplied__c where Item__c=null and Subfamily__c IN:ids and Supplier_Account__c=:record.Id])
                    subfamily.add(s.Subfamily__c);
                refreshsubfamily=false;
            }
            else if(subfamily==null)
                subfamily=new List<String>();
            return subfamily;
        }
        set
        {
            if(subfamily!=value)
            {
                subfamily=value;
                refreshitems=true;
                items=null;
            }
        }
    }
    
    public List<SelectOption> subfamilies
    {
        get
        {
            if(subfamilies==null)
            {
                subfamilies=new List<SelectOption>();
                List<Subfamily__c>is;
                if(family.size()>0)
                    is=[select Id,Name from Subfamily__c where Product_Family__c IN:family order by Name];
                else
                {
                    List<Id>ids=new List<Id>();
                    for(SelectOption i:families)
                        ids.add(i.getValue());
                    is=[select Id,Name from Subfamily__c where Product_Family__c IN:ids order by Name];
                }
                for(Subfamily__c f:is)
                if(f.Name.length()>40)
                    subfamilies.add(new SelectOption(f.Id,f.Name.Substring(0,40)));
                else
                    subfamilies.add(new SelectOption(f.Id,f.Name));
            }
            return subfamilies;
        }
        set
        {
            if(subfamilies!=value)
            {
                subfamilies=value;
                subfamily=null;
            }
        }
    }

    public List<Item_s> items
    {
        get
        {
            if(items==null)
            {
                items=new List<Item_s>();
                List<Sourcing_Item__c>is;
                if(subfamily.size()>0)
                    is=[select Id,Name,Subfamily__r.Id,Subfamily__r.Name,Sourcing_Family__r.Id,Sourcing_Family__r.Name,Item_Description__c,Sourcing_Item_Code__c from Sourcing_Item__c where Subfamily__c IN:subfamily order by Name];
                else if(family.size()>0)
                    is=[select Id,Name,Subfamily__r.Id,Subfamily__r.Name,Sourcing_Family__r.Id,Sourcing_Family__r.Name,Item_Description__c,Sourcing_Item_Code__c from Sourcing_Item__c where Sourcing_Family__c IN:family order by Name];
                else
                {
                    List<Id>ids=new List<Id>();
                    for(SelectOption i:families)
                        ids.add(i.getValue());
                    is=[select Id,Name,Subfamily__r.Id,Subfamily__r.Name,Sourcing_Family__r.Id,Sourcing_Family__r.Name,Item_Description__c,Sourcing_Item_Code__c from Sourcing_Item__c where Sourcing_Family__c IN:ids order by Name];
                }
                for(Sourcing_Item__c i:is)
                {
                    Item_s newitem=new Item_s();
                    newitem.item=i;
                    newitem.selected=false;
                    items.add(newitem);
                    if(items.size()>=1000) break;
                }
                if(refreshitems)
                {
                    for(Family_Supplied__c s:[select Item__c from Family_Supplied__c where Item__c IN:is and Supplier_Account__c=:record.Id])
                        for(Item_s i:items)
                            if(s.Item__c==i.item.Id)
                            {
                                i.selected=true;
                                break;
                            }
                    refreshitems=false;
                }
            }
            return items;
        }
        set;
    }
    public class Item_s
    {
        public Sourcing_Item__c item{get;set;}
        public boolean selected{get;set;}
    }
    public void allocatesubfamily()
    {
        List<Family_Supplied__c>toadd=new List<Family_Supplied__c>();
        List<Family_Supplied__c>todelete=new List<Family_Supplied__c>();
        List<Subfamily__c>listsubfamilies=[select Id,Product_Family__c from Subfamily__c where Id IN:subfamily];
        
        List<Id>ids=new List<Id>();
        for(SelectOption i:subfamilies)
            ids.add(i.getValue());
        List<Family_Supplied__c> olds=[select Subfamily__c from Family_Supplied__c where Item__c=null and Subfamily__c IN:ids and Supplier_Account__c=:record.Id];
        for(Family_Supplied__c old:olds)
        {
            boolean exists=false;
            for(Subfamily__c s:listsubfamilies)
                if(s.Id==old.Subfamily__c)
                {
                    exists=true;
                    break;
                }
            if(!exists)
                todelete.add(old);
        }
        for(Subfamily__c s:listsubfamilies)
        {
            boolean exists=false;
            for(Family_Supplied__c old:olds)
                if(s.Id==old.Subfamily__c)
                {
                    exists=true;
                    break;
                }
            if(!exists)
            {
                Family_Supplied__c f=new Family_Supplied__c();
                f.Family__c=s.Product_Family__c;
                f.Supplier_Account__c=record.Id;
                f.Subfamily__c=s.Id;
                toadd.add(f);
            }
        }
        if(todelete.size()>0)
            delete todelete;
        if(toadd.size()>0)
            insert toadd;
    }
    public void allocatefamily()
    {
        List<Family_Supplied__c>toadd=new List<Family_Supplied__c>();
        List<Family_Supplied__c>todelete=new List<Family_Supplied__c>();

        List<Id>ids=new List<Id>();
        for(SelectOption i:families)
            ids.add(i.getValue());
        List<Family_Supplied__c> olds=[select Family__c from Family_Supplied__c where Item__c=null and Subfamily__c=null and Family__c IN:ids and Supplier_Account__c=:record.Id];
        for(Family_Supplied__c old:olds)
        {
            boolean exists=false;
            for(String s:family)
                if(s==old.Family__c)
                {
                    exists=true;
                    break;
                }
            if(!exists)
                todelete.add(old);
        }
        for(String s:family)
        {
            boolean exists=false;
            for(Family_Supplied__c old:olds)
                if(s==old.Family__c)
                {
                    exists=true;
                    break;
                }
            if(!exists)
            {
                Family_Supplied__c f=new Family_Supplied__c();
                f.Family__c=s;
                f.Supplier_Account__c=record.Id;
                toadd.add(f);
            }
        }
        if(todelete.size()>0)
            delete todelete;
        if(toadd.size()>0)
            insert toadd;
    }
    public void allocateitem()
    {
        List<Family_Supplied__c>toadd=new List<Family_Supplied__c>();
        List<Family_Supplied__c>todelete=new List<Family_Supplied__c>();

        List<Id>ids=new List<Id>();
        for(Item_s i:items)
            ids.add(i.item.id);
        List<Family_Supplied__c>olds=[select Item__c from Family_Supplied__c where Item__c IN:ids and Supplier_Account__c=:record.Id];
        for(Family_Supplied__c old:olds)
        {
            boolean exists=false;
            for(Item_s i:items)
                if((i.item.id==old.Item__c)&&(i.selected))
                {
                    exists=true;
                    break;
                }
            if(!exists)
                todelete.add(old);
        }
        for(Item_s i:items)
        if(i.selected)
        {
            boolean exists=false;
            for(Family_Supplied__c old:olds)
                if(i.item.id==old.Item__c)
                {
                    exists=true;
                    break;
                }
            if(!exists)
            {
                Family_Supplied__c f=new Family_Supplied__c();
                f.Family__c=i.item.Sourcing_Family__c;
                f.Supplier_Account__c=record.Id;
                f.Subfamily__c=i.item.Subfamily__c;
                f.Item__c=i.item.Id;
                toadd.add(f);
            }
        }
        if(todelete.size()>0)
            delete todelete;
        if(toadd.size()>0)
            insert toadd;
    }
}