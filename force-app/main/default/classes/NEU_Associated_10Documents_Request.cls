public with sharing class NEU_Associated_10Documents_Request {

     public List<Associated_Document__c> document {get;set;}
     public String Document_type {get;set;}
     public string Document_Description {get;set;}
      
     public string type_document = null;
     
     public string gettype_document()
     {
        List<Supplier_Quote__c> Supplier_Quote = [select Id, Name,Customer__c, Supplier__c,Supply_Project__c,
        Supplier_Request_RFP__c, Supply_Project__r.Supply_Project_Number__c,
        Supplier_Request_RFP__r.Document_1_Type__c, Supplier_Request_RFP__r.Document_2_Type__c, 
        Supplier_Request_RFP__r.Document_3_Type__c, Supplier_Request_RFP__r.Document_4_Type__c, 
        Supplier_Request_RFP__r.Document_5_Type__c, Supplier_Request_RFP__r.Document_6_Type__c, 
        Supplier_Request_RFP__r.Document_7_Type__c, Supplier_Request_RFP__r.Document_8_Type__c, 
        Supplier_Request_RFP__r.Document_9_Type__c, Supplier_Request_RFP__r.Document_10_Type__c, 
        Supply_Project_Number__c  from Supplier_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
        if(Supplier_Quote.size() > 0)
        {
            if(ApexPages.currentPage().getParameters().get('docu') != null)
            {
                if(ApexPages.currentPage().getParameters().get('docu') == '1')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_1_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '2')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_2_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '3')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_3_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '4')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_4_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '5')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_5_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '6')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_6_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '7')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_7_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '8')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_8_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '9')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_9_Type__c;
                if(ApexPages.currentPage().getParameters().get('docu') == '10')
                    Document_type = Supplier_Quote[0].Supplier_Request_RFP__r.Document_10_Type__c;
            }
        }
        this.type_document = Document_type;
        return type_document;
     }
     
     /*public Document documento_asociado 
    {
        get 
        {
          if (documento_asociado == null)
            documento_asociado = new Document();
          return documento_asociado;
        }
        set;
    }*/
    public transient Blob documento_asociado{get;set;}
    public transient String documento_asociadoName{get;set;}
    
     public PageReference Upload_Documents()
    {
        List<Supplier_Quote__c> Supplier_Quote = [select Id, Name,Customer__c, Supplier__c,Supply_Project__c,
        Supplier_Request_RFP__c, Supply_Project__r.Supply_Project_Number__c,
        Supplier_Request_RFP__r.Document_1_Type__c, Supplier_Request_RFP__r.Document_2_Type__c, 
        Supplier_Request_RFP__r.Document_3_Type__c, Supplier_Request_RFP__r.Document_4_Type__c, 
        Supplier_Request_RFP__r.Document_5_Type__c, Supplier_Request_RFP__r.Document_6_Type__c, 
        Supplier_Request_RFP__r.Document_7_Type__c, Supplier_Request_RFP__r.Document_8_Type__c, 
        Supplier_Request_RFP__r.Document_9_Type__c, Supplier_Request_RFP__r.Document_10_Type__c, 
        Supply_Project_Number__c  from Supplier_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];

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
            if(directorio.size() > 0){
                document.FolderId = directorio[0].Id;
            }
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
        
    
        Associated_Document__c new_document= new Associated_Document__c();
        if(documento_asociadoName != '' && documento_asociadoName != null)
        {
            new_document.Document_URL__c = Site.getBaseURL()+'/servlet/servlet.ImageServer?id='+document.Id+'&oid=' + UserInfo.getOrganizationId();
            string nombredeldocumento = documento_asociadoName;
            Integer indiceDePunto = nombredeldocumento.indexOf('.');
            new_document.Name=nombredeldocumento.substring(0, indiceDePunto);
        }
        
        new_document.Document_Reference__c=(Supplier_Quote.size() > 0 ? Supplier_Quote[0].Supply_Project_Number__c + ' - ':'')+'Document '+ApexPages.currentPage().getParameters().get('docu');//poner documento 10 
        new_document.Document_Description__c = Document_Description;
        new_document.Document_Type__c=Document_type;// poner mismo que supply porject 
        
        if(Supplier_Quote.size() > 0)
        {
            new_document.Account__c = Supplier_Quote[0].Supplier__c; 
            new_document.Supplier_Quote__c =Supplier_Quote[0].Id;
            new_document.Supplier_Request_RFP__c =Supplier_Quote[0].Supplier_Request_RFP__c;
          //  new_document.Supply_Project__c =Supplier_Quote[0].Supply_Project__c;
        }
        
        try
        {
            insert new_document;
            PageReference pgReturnPage;
            String returnUrl = Site.getBaseURL() +'/apex/NEU_Associated_10Documents_Request?redirec=true';
            pgReturnPage = new PageReference(returnUrl);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;

        }
        catch(Exception e){ return null;}
    }
    
}