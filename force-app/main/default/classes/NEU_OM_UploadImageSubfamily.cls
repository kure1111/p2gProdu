public with sharing class NEU_OM_UploadImageSubfamily {

    public Subfamily__c record;
    
    public transient Blob documento1{get;set;}
    public transient String documento1name{get;set;}
    
    public NEU_OM_UploadImageSubfamily(ApexPages.StandardController stdController) {
     if (!Test.isRunningTest()) {
        stdController.AddFields(new String[]
        {
            'Id',
            'Name',
            'Url_Image__c',
            'Image__c'
        });
     }
     record=(Subfamily__c)stdController.getRecord();
    }
    
    public Pagereference upload()
    {
        if(ApexPages.currentPage().getParameters().get('test') != null)
        {
            documento1Name = 'doc1';
        }
        
        List<Folder> directorio_photos = new List<Folder>();
        directorio_photos = [Select Id, Name from Folder where Name='Families - Subfamilies'];
        
        //DOCUMENTO1
        Document document=new Document();
        if(documento1Name != '' && documento1Name != null)
        {
          
            document.Body=documento1;
            document.Name=documento1Name;
            document.AuthorId = UserInfo.getUserId();
            if(directorio_photos.size()>0)
                document.FolderId = directorio_photos[0].Id;
            document.IsPublic = true; 
        }

        try 
        {
            if(documento1Name != '' && documento1Name != null)
            {
                insert document;
                record.Url_Image__c = '/servlet/servlet.ImageServer?id='+document.Id+'&oid=' + UserInfo.getOrganizationId();
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