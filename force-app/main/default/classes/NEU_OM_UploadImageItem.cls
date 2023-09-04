public with sharing class NEU_OM_UploadImageItem {

    public Sourcing_Item__c record;
    
    public transient Blob photo1{get;set;}
    public transient String photo1Name{get;set;}
    public transient Blob Technical_Data{get;set;}
    public transient String Technical_DataName{get;set;}
    public transient Blob Packaging_Image{get;set;}
    public transient String Packaging_ImageName{get;set;}
    public transient Blob Sizes{get;set;}
    public transient String SizesName{get;set;}
    
    public NEU_OM_UploadImageItem(ApexPages.StandardController stdController) {

     if (!Test.isRunningTest()) {stdController.AddFields(new String[]{'Id','Name','Url_Photo_1__c','Url_Sizes__c','Url_Technical_Data__c','URL_Packaging_Image__c'});}
     record=(Sourcing_Item__c)stdController.getRecord();
    }
    
    public PageReference return_item()
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
            photo1Name = 'doc1';
            Technical_DataName = 'doc2';
            Packaging_ImageName = 'doc3';
            SizesName = 'doc4';
        }
        
        ApexPages.getMessages().clear();
        
        List<Folder> directorio_photos = new List<Folder>();
        directorio_photos = [Select Id, Name from Folder where Name='Items'];
        
        //DOCUMENTO1
        if(photo1Name != '' && photo1Name != null)
        {
        	Document document1=new Document();
		    document1.Body=photo1;
		    document1.Name=photo1Name;
            document1.AuthorId = UserInfo.getUserId();
            if(directorio_photos.size()>0)
                document1.FolderId = directorio_photos[0].Id;
            document1.IsPublic = true; 
            
            try 
	        {
	            if(photo1Name != '' && photo1Name != null)
	            {
	                insert document1;
	                record.Url_Photo_1__c = '/servlet/servlet.ImageServer?id='+document1.Id+'&oid=' + UserInfo.getOrganizationId();
	                update record;
	                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'FILE HAVE BEEN UPLOADED CORRECTLY.'));
	                photo1=null;
	            }
	        }  
	        catch (DMLException e)
	        {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
	        }
            
        }
        
        if(Technical_DataName != '' && Technical_DataName != null)
        {
        	Document document1=new Document();
		    document1.Body=Technical_Data;
		    document1.Name=Technical_DataName;
            document1.AuthorId = UserInfo.getUserId();
            if(directorio_photos.size()>0)
                document1.FolderId = directorio_photos[0].Id;
            document1.IsPublic = true; 
            
             try 
	        {
	            if(Technical_DataName != '' && Technical_DataName != null)
	            {
	                insert document1;
	                record.Url_Technical_Data__c = '/servlet/servlet.ImageServer?id='+document1.Id+'&oid=' + UserInfo.getOrganizationId();
	                update record;
	                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'FILE HAVE BEEN UPLOADED CORRECTLY.'));
	                Technical_Data=null;
	            }
	        }  
	        catch (DMLException e)
	        {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
	        }
        }
        
        if(Packaging_ImageName != '' && Packaging_ImageName != null)
        {
        	Document document1=new Document();
		    document1.Body=Packaging_Image;
		    document1.Name=Packaging_ImageName;
            document1.AuthorId = UserInfo.getUserId();
            if(directorio_photos.size()>0)
                document1.FolderId = directorio_photos[0].Id;
            document1.IsPublic = true;  
            
            try 
	        {
	            if(Packaging_ImageName != '' && Packaging_ImageName != null)
	            {
	                insert document1;
	                record.URL_Packaging_Image__c = '/servlet/servlet.ImageServer?id='+document1.Id+'&oid=' + UserInfo.getOrganizationId();
	                update record;
	                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'FILE HAVE BEEN UPLOADED CORRECTLY.'));
	                Packaging_Image=null;
	            }
	        }  
	        catch (DMLException e)
	        {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
	        }  
        }
        
        if(SizesName != '' && SizesName != null)
        {
        	Document document1=new Document();
		    document1.Body=Sizes;
		    document1.Name=SizesName;
            document1.AuthorId = UserInfo.getUserId();
            if(directorio_photos.size()>0)
                document1.FolderId = directorio_photos[0].Id;
            document1.IsPublic = true;  
            try 
	        {
	            if(SizesName != '' && SizesName != null)
	            {
	                insert document1;
	                record.Url_Sizes__c = '/servlet/servlet.ImageServer?id='+document1.Id+'&oid=' + UserInfo.getOrganizationId();
	                update record;
	                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'FILE HAVE BEEN UPLOADED CORRECTLY.'));
	                Sizes=null;
	            }
	        } 
	         catch (DMLException e)
	        {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
	        } 
        }
        
       
      
      
       
        return null;
    }

}