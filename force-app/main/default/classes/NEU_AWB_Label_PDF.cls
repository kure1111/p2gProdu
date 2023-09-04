public with sharing class NEU_AWB_Label_PDF {

    public Air_Waybill__c record {get;set;}
    public String id_waybill {get;set;}
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
    
    public string awb_type 
    {
        get 
        {
          if (awb_type == null)
          	awb_type=ApexPages.currentPage().getParameters().get('type');
          return awb_type;
        }
        set;
    }    
    
    
    ApexPages.StandardController con;
            
    public NEU_AWB_Label_PDF(ApexPages.StandardController stdController) 
    {

        con = stdController;
        
        try { 
        	record = [select Id, Name, Carrier_Account__c, Shipments_Program__c, Weight_Charge_House__c, 
        				Valuation_Charge_House__c, Total_Other_Charges_Due_House__c, Hide_House_Totals__c, 
        				Total_Other_Charges_Due_Agent_House__c, Tax_House__c, Other_Charges_House__c, 
        				Weight_Charge_Master__c, Valuation_Charge_Master__c, Total_Other_Charges_Due_Master__c, 
        				Total_Other_Charges_Due_Agent_Master__c, Tax_Master__c, Other_Charges_Master__c, 
        				House_Reference__c, Alternative_Fligtht_1__c, Alternative_Fligtht_2__c, Airline_Code_Number__c 
        				from Air_Waybill__c where Id =: con.getRecord().Id];
        } catch( Exception ee) { 
            record = new Air_Waybill__c();
        }
       			
		id_waybill = record.Id;               
    }
    
    
    public PageReference refrescar_pdf()
    {
    	try 
    	{
    	

    	} catch( Exception ee) {}
    	
    	PageReference pdf = null;
	    pdf = Page.NEU_AWB_Label_PDF;
	    pdf.getParameters().put('type',awb_type);
	    pdf.getParameters().put('id',record.Id);
	   
	          	    
	    return pdf;
    }
    
    public PageReference return_page()
    {
        return con.view();
    }   
    
    public PageReference crear()
    {
        PageReference pdf = null;
        pdf = Page.NEU_AWB_Label_PDF_iframe;
        pdf.getParameters().put('id',record.Id);
        Blob body;
        
        try 
        {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
       
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Air Waybill'];
        documento_asociado.Body = body;
        documento_asociado.Name = 'Master Label '+record.Name +'.pdf';
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
        new_document.Account__c = record.Carrier_Account__c;
        new_document.Name = 'Master Label '+record.Name +'.pdf';
        new_document.Air_Waybill__c = record.Id;
        new_document.Document_Type__c = 'Waybill';
        new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;} 
    }
}