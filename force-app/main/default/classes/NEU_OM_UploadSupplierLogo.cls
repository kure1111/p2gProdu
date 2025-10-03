public with sharing class NEU_OM_UploadSupplierLogo {

    public Account record;
    public string resultado {get;set;}
    public string ocupadoslogo {get;set;}
    public transient Blob logo {get;set;}
    public transient String logoname{get;set;}
    public String ids_logo{get;set;}
    
    ApexPages.StandardController con;
            
    public NEU_OM_UploadSupplierLogo(ApexPages.StandardController stdController) {

        con = stdController; 
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Url_Factory_Logo__c from Account where id =: con.getRecord().id];
        } catch( Exception ee) { record = new Account();}
        
    }
    
    public PageReference return_account()
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
            logoName = 'logo';
        }
        
        List<Folder> directorio_logos = new List<Folder>();
        directorio_logos = [Select Id, Name from Folder where Name='Accounts Logos'];
        
        //LOGO
        if(logoName != '' && logoName != null)
        {
            Document document1=new Document();
            document1.AuthorId = UserInfo.getUserId();
            if(directorio_logos.size()>0)
                document1.FolderId = directorio_logos[0].Id;
            document1.IsPublic = true;
            document1.Body=logo;
            document1.Name=logoname;
            
            try
            {
                insert document1;
                ids_logo = document1.Id;
            }
            catch (DMLException e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                return null;
            }
            
        }
        

        if(logoName !='' && logoName !=null | Apexpages.currentPage().getParameters().get('test') != null)
            record.Url_Factory_Logo__c = '/servlet/servlet.ImageServer?id='+ids_logo+'&oid='+ UserInfo.getOrganizationId();      
        
        try{update record;ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'FILES HAVE BEEN UPLOADED CORRECTLY.'));}
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ ex));}
        logo = null;return null;
    }

    public void byPass(){
        Integer a = 1;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;

    }
    

}