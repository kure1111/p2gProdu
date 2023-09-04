public with sharing class NEU_Import_Export_Quote_save_pdf 
{
    public Customer_Quote__c record {get;set;}
    public string language {get;set;}
    public Document documento_asociado 
    {
        get 
        {
          if (documento_asociado == null)
            documento_asociado = new Document();
          return documento_asociado;
        }
        set;
    }
    
    ApexPages.StandardController con;
            
    public NEU_Import_Export_Quote_save_pdf(ApexPages.StandardController stdController) 
    {
        con = stdController;


        
        try 
        { 
        	record = [select Id, Name, Account_for__c, Quotation_Status__c, Approved_Date__c, Account_Executive_User__c, Account_for__r.Name, Account_for_Billing_Address__c,
        	Account_for_Shipping_Address__c, Contact__r.Name,SUM_Sell_Origin_Amount_number__c, Supply_Project_Name__r.Name, Supply_Project_Name__c, PDF_Notes__c, PDF_Notes_EN__c
        	from Customer_Quote__c where id =: con.getRecord().id];
            System.debug('id---->' + con.getRecord().id);

        } 
        catch(Exception ee){record = new Customer_Quote__c();}
    }
    
    private List<SelectOption> newcategories=null;
    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            newcategories=new List<SelectOption>();
            newcategories.add(new SelectOption('EN','EN'));
            newcategories.add(new SelectOption('ES','ES'));
            //newcategories.add(new SelectOption('FFWD','FFWD EN'));
            //newcategories.add(new SelectOption('FFWD2','FFWD EN WITH DETAILS'));
            language ='EN';
        }
        return newcategories;
    }
    
	public void refresh_data()
	{
		try
		{
			update record;
		}
		catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex+' ('+ex.getLineNumber()+')'));}
	}
    
    public PageReference crear()
    {
        PageReference pdf = null;
        if(language != 'FFWD' && language != 'FFWD2'){
        	if(language == 'ES'){
            	pdf = Page.NEU_Import_Export_Quote_pdf_ES;
        	}else{
        		pdf = Page.NEU_Import_Export_Quote_pdf;
        	}
        }else if(language == 'FFWD')
        {
            pdf = Page.NEU_Order_Confirmation_IE_pdf;
            pdf.getParameters().put('services_charges','true'); 
        }
        else
        {
            pdf = Page.NEU_Order_Confirmation_IE_details_pdf;
            pdf.getParameters().put('services_charges','true'); 
        }
        
        pdf.getParameters().put('id',record.Id);
            
        Blob body;
        
        try 
        {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
            documento_asociado.Body = body;
            documento_asociado.Name = record.name +'IEQ.pdf';
            documento_asociado.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                documento_asociado.FolderId = directorio[0].Id;
            documento_asociado.IsPublic = true; 

        
        try 
        {
            if(documento_asociado.Name != '' && documento_asociado.Name != null)
                insert documento_asociado;
        }  
        catch (DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }
    
        
        Associated_Document__c new_document = new Associated_Document__c();
        
        new_document.Account__c = record.Account_for__c;
        new_document.Available_for_Community__c = true;
        new_document.Name = 'IEQ_'+ record.Name +'.pdf';
        new_document.Import_Export_Quote__c=record.Id;
        if(record.Supply_Project_Name__r.Name != null)
            new_document.Supply_Project__c =record.Supply_Project_Name__c;
            
        new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}
             
    }
}