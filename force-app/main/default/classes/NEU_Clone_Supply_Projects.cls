public with sharing class NEU_Clone_Supply_Projects {


    public String resultado {get;set;}
    public Supply_Project__c record=null;
    
    public NEU_Clone_Supply_Projects(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest())stdController.AddFields(new String[]{'Id'});
        record=(Supply_Project__c)stdController.getRecord();
    }
    
    public PageReference duplicate_supply_projects()
    {
        try{
            String newsupplyprojectid=splitSupplyProject(record.Id);
            if(String.IsNotEmpty(newsupplyprojectid))
            {
                split_Item_to_Supply(record.Id,newsupplyprojectid);
                split_suppliers(record.Id,newsupplyprojectid);
                split_associated_document(record.Id,newsupplyprojectid);
                PageReference pgReturnPage = new PageReference('/' + newsupplyprojectid);
                pgReturnPage.setRedirect(true);
                return pgReturnPage;
            }
        }catch(Exception ex){resultado = ''+ex;}
        return null;
    }
    
    private String splitSupplyProject(String supplyprojectid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Supply_Project__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Supply_Project__c where Id=\''+supplyprojectid+'\'';
        List<Supply_Project__c>lines=database.query(query);
        if(lines.size()>0)
        {
            lines[0].Name = lines[0].Name+' (copy)';
            Supply_Project__c newline=lines[0].clone(false,true);
            try
            {
                insert newline;
                return newline.Id;
            }catch(Exception e){}
        }
        return null;
    }
    
    private List<Items_to_Supply__c> split_Item_to_Supply(String supplyproject_id,String new_supplyprojectid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Items_to_Supply__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Items_to_Supply__c where Supply_Project__c=\''+supplyproject_id+'\'';
        List<Items_to_Supply__c>lines=database.query(query);
        List<Items_to_Supply__c>newlines=new List<Items_to_Supply__c>();
        for(Items_to_Supply__c line:lines)
        {
            Items_to_Supply__c newline=line.clone(false,true);
            newLine.Supply_Project__c=new_supplyprojectid;
            newlines.add(newline);
        }
        if(newlines.size()>0)
            insert newlines;
        return newlines;
    }
    
    private void split_suppliers(String supplyproject_id,String new_supplyprojectid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Supplier_to_Invite__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Supplier_to_Invite__c where Supply_Project__c=\''+supplyproject_id+'\'';
        List<Supplier_to_Invite__c>lines=database.query(query);
        List<Supplier_to_Invite__c>newlines=new List<Supplier_to_Invite__c>();
        for(Supplier_to_Invite__c line:lines)
        {
            Supplier_to_Invite__c newline=line.clone(false,true);
            newLine.Supply_Project__c = new_supplyprojectid;
            newlines.add(newline);
        }
        if(newlines.size()>0)
            insert newlines;
    }
    
    private List<Associated_Document__c> split_associated_document(String supplyproject_id,String new_supplyprojectid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Associated_Document__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Associated_Document__c where Supply_Project__c=\''+supplyproject_id+'\'';
        List<Associated_Document__c>lines=database.query(query);
        List<Associated_Document__c>newlines=new List<Associated_Document__c>();
        for(Associated_Document__c line:lines)
        {
            Associated_Document__c newline = line.clone(false,true);
            newLine.Supply_Project__c=new_supplyprojectid;
            newlines.add(newline);
        }
        if(newlines.size()>0)
            insert newlines;
        return newlines;
    }
  
}