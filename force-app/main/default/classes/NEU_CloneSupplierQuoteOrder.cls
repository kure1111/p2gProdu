public with sharing class NEU_CloneSupplierQuoteOrder 
{
    public String resultado {get;set;}
    public Supplier_Quote__c record=null;
    
    public NEU_CloneSupplierQuoteOrder(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest())stdController.AddFields(new String[]{'Id'});
        record=(Supplier_Quote__c)stdController.getRecord();
    }
    
    public PageReference duplicate_order()
    {
        try{
            String newquoteid=splitQuote(record.Id);
            if(String.IsNotEmpty(newquoteid))
            {
                splitQuoteLine(record.Id,newquoteid);
                PageReference pgReturnPage = new PageReference('/' + newquoteId);
                pgReturnPage.setRedirect(true);
                return pgReturnPage;
            }
        }catch(Exception ex){resultado = ''+ex;}
        return null;
    }
    private void splitQuoteLine(String quoteid,String newquoteid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Supplier_Quote_Line__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Supplier_Quote_Line__c where Supplier_Quote__c=\''+quoteid+'\'';
        List<Supplier_Quote_Line__c>lines=database.query(query);
        List<Supplier_Quote_Line__c>newlines=new List<Supplier_Quote_Line__c>();
        for(Supplier_Quote_Line__c line:lines)
        {
            Supplier_Quote_Line__c newline=line.clone(false,true);
            newLine.Supplier_Quote__c=newquoteid;
            newLine.Consolidated__c=false;
            newlines.add(newline);
        }
        if(newlines.size()>0)
            insert newlines;
    }
    private String splitQuote(String quoteid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Supplier_Quote__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Supplier_Quote__c where Id=\''+quoteid+'\'';
        List<Supplier_Quote__c>lines=database.query(query);
        if(lines.size()>0)
        {
            Supplier_Quote__c newline=lines[0].clone(false,true);
            try{
                if(newline.Supplier_Quote_Status__c=='Consolidated')
                    newline.Supplier_Quote_Status__c='Approved';
                insert newline;
                return newline.Id;
            }catch(Exception e){}
        }
        return null;
    }
}