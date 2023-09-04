public with sharing class NEU_OM_UploadImageProductFamily {

    public Product_Family__c record;

    /*public Document documento1 
    {
        get 
        {
          if (documento1 == null)
            documento1 = new Document();
          return documento1;
        }
        set;
    }*/
    
    public transient Blob documento1{get;set;}
    public transient String documento1name{get;set;}
    
    public NEU_OM_UploadImageProductFamily(ApexPages.StandardController stdController) {

     if (!Test.isRunningTest()) {
        stdController.AddFields(new String[]
        {
            'Id',
            'Name',
            'Url_Image__c',
            'Image__c'
        });
     }
     record=(Product_Family__c)stdController.getRecord();
    }
    
     public PageReference return_family()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
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