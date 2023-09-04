public with sharing class NEU_Upload_Capacity_Plan {
    private String planId;
    
    public NEU_Upload_Capacity_Plan(ApexPages.StandardController stdController)
    {
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]{'Id'});
        SObject o=stdController.getRecord();
        if(o!=null)
            planId=o.Id;
        else
            planId='';
    }
    public transient Blob documento1{get;set;}
    public transient String documento1Name{get;set;}
    public Pagereference upload()
    {
        List<Folder> capacitydirectory = new List<Folder>();
        capacitydirectory = [Select Id, Name from Folder where Name='Capacity Tool'];
        
        if(String.IsNotEmpty(documento1Name))
        {
            if(documento1Name.tolowerCase().endsWith('.xlsx'))
            {
              Document document=new Document();
              document.Body=documento1;
              document.Name=documento1Name;
                document.AuthorId = UserInfo.getUserId();
                if(capacitydirectory.size()>0)
                    document.FolderId = capacitydirectory[0].Id;
                document.IsPublic = true;  
                try{
                    insert document;
                    return new PageReference('/apex/NEU_Extract_Capacity_Plan?Id='+document.Id+'&planId='+planId);
                }
                catch (Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                }
            }
            else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The file must be an xlsx file'));
        }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select an Excel document'));
        documento1=null;
        return null;
    }
}