public with sharing class NEU_Upload_LOT_Service_Rate {

    public Fee__c record;

    public transient Blob documento1{get;set;}
    public transient String documento1name{get;set;}
    
    public NEU_Upload_LOT_Service_Rate(ApexPages.StandardController stdController) {

     if (!Test.isRunningTest()) {
        stdController.AddFields(new String[]
        {
            'Id',
            'Name',
            'LOT__c',
            'LOT_Url__c'
        });
     }
     record=(Fee__c)stdController.getRecord();
    }
    
    public Pagereference upload()
    {
        if(ApexPages.currentPage().getParameters().get('test') != null)
        {
            documento1Name = 'doc1';
        }
        
        List<Folder> directorio_photos = new List<Folder>();
        directorio_photos = [Select Id, Name from Folder where Name='Services Rates'];
        
        //DOCUMENTO1
        Document document=new Document();
        if(documento1Name != '' && documento1Name != null)
        {
            
            document.AuthorId = UserInfo.getUserId();
            if(directorio_photos.size()>0)
                document.FolderId = directorio_photos[0].Id;
            document.IsPublic = true; 
            document.Body=documento1;
            document.Name=documento1Name;
        }

        try 
        {
            if(documento1Name != '' && documento1Name != null)
            {
                insert document;
                record.LOT_Url__c = '/servlet/servlet.FileDownload?file='+document.Id+'&oid=' + UserInfo.getOrganizationId(); 
                update record;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'FILE HAVE BEEN UPLOADED CORRECTLY.'));
                documento1=null;
            }
        }  
        catch (DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }
        return null;
    }
}