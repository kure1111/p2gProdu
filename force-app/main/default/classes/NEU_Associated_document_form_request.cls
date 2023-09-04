public class NEU_Associated_document_form_request {

    public List<Associated_Document__c> document {get;set;}
    public string Document_Reference {get;set;}
    public string Document_Description {get;set;}
    public string Document_type {get;set;}
    public string Manual_Document_URL {get;set;}

    public transient Blob documento_asociado{get;set;}
    public transient String documento_asociadoName{get;set;}
    
    public List<SelectOption> gettypes() 
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Associated_Document__c.Document_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(),f.getValue()));
        }                
        return options;
    }

    public void get_Document()
    {
        document = [select Id, Name, Document_Type__c, Document_Reference__c, Document_Description__c, Account__c, Shopping_Cart__c, Supply_Project__c, Supplier_Request_RFP__c, Supplier_Quote__c, Import_Export_Quote__c, Shipment__c, Shipment_Packaging_Consolidation_Data__c, Shipment_Consolidation_Data__c, Claim__c from Associated_Document__c limit 1];
    }
    
    public PageReference Upload_Documents()
    {
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =: Document_type];//Document_type
        if(directorio.size()<1)
        {
            directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
            
        }
        
        //DOCUMENTO1
        Document document=new Document();
        if(documento_asociadoName != '' && documento_asociadoName != null)
        {
          
            document.Body=documento_asociado;
            document.Name=documento_asociadoName;
            document.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                document.FolderId = directorio[0].Id;
            document.IsPublic = true; 
        }
        
        try 
        {
            if(documento_asociadoName != '' && documento_asociadoName != null)
                insert document;
        }  
        catch (DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }
        
        List<Supplier_Quote__c> Supplier_Quote = [select Id, Name,Customer__c, Supplier__c,Supply_Project__c,Supplier_Request_RFP__c  from Supplier_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
    
        Associated_Document__c new_document= new Associated_Document__c();
        if(documento_asociadoName != '' && documento_asociadoName != null)
        {
            new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+document.Id+'&oid=' + UserInfo.getOrganizationId();
            string nombredeldocumento = documento_asociadoName;
            Integer indiceDePunto = nombredeldocumento.indexOf('.');
            new_document.Name=nombredeldocumento.substring(0, indiceDePunto);
        }
                
        if(Manual_Document_URL != null & Manual_Document_URL != '' )
        {
            new_document.Manual_Document_URL__c = Manual_Document_URL;
        }
        
        new_document.Document_Reference__c=Document_Reference;
        new_document.Document_Description__c = Document_Description;
        new_document.Document_Type__c=Document_type;
        
        if(Supplier_Quote.size() > 0)
        {
            new_document.Account__c = Supplier_Quote[0].Supplier__c;
            new_document.Supplier_Quote__c =Supplier_Quote[0].Id;
            new_document.Supplier_Request_RFP__c =Supplier_Quote[0].Supplier_Request_RFP__c;
            new_document.Supply_Project__c =Supplier_Quote[0].Supply_Project__c;
        }
        
        try
        {
            insert new_document;
            PageReference pgReturnPage;
            String returnUrl = Site.getBaseURL() +'/apex/NEU_Associated_document_form_request?redirec=true';
            pgReturnPage = new PageReference(returnUrl);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;

        }
        catch(Exception e){ return null;}
    }
}