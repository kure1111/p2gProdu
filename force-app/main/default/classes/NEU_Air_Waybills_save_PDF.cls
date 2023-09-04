public with sharing class NEU_Air_Waybills_save_PDF 
{
    public Air_Waybill__c record {get;set;}
    public string language {get;set;}
    public String errores {get;set;}
    public String id_waybill {get;set;}
    public List<Air_Waybill_Line__c> lines {get;set;}
    public List<Air_Waybill_Line__c> lines_house {get;set;} 
    
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
    
    public boolean displayBackground
	{
		get 
		{
			if (displayBackground == null)
				displayBackground = true;
			return displayBackground;
		}
		set;
	}
	
    public void updateFilters()
    {
    }
    
    ApexPages.StandardController con;
            
    public NEU_Air_Waybills_save_PDF(ApexPages.StandardController stdController) 
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
        
       lines = [SELECT Id, Name, Description__c, Rate_Charge_Master__c, Rate_Charge__c, Chargeable_Weight_Master__c, 
       			Min_Amount_Master__c, House_Reference__c FROM Air_Waybill_Line__c WHERE Air_Waybill__c =: record.Id
       			order by Name];
       
       lines_house = [SELECT Id, Name, Description__c ,Rate_Charge_House__c, Rate_Charge__c, Chargeable_Weight_House__c, 
       				Min_Amount_House__c, House_Reference__c FROM Air_Waybill_Line__c WHERE Air_Waybill__c =: record.Id 
       				and House_Reference__c=:record.House_Reference__c order by Name];
       			
		id_waybill = record.Id;               
    }
    
    public PageReference clear_values()
    {
    	try 
    	{
    		//HOUSE
    		if(awb_type == 'house') 
    		{
    			record.Weight_Charge_House__c = null;
    			record.Valuation_Charge_House__c = null;
    			record.Tax_House__c = null;
    			record.Total_Other_Charges_Due_Agent_House__c = null;
    			record.Total_Other_Charges_Due_House__c = null;
    		}
    		//MASTER
    		if(awb_type == 'master') 
    		{
    			record.Weight_Charge_Master__c = null;
    			record.Valuation_Charge_Master__c = null;
    			record.Tax_Master__c = null;
    			record.Total_Other_Charges_Due_Agent_Master__c = null;
    			record.Total_Other_Charges_Due_Master__c = null;
    		}
    		update record; 
    		
    	} catch( Exception ee) {}
    	
    	PageReference pdf = null;
	    pdf = Page.NEU_Air_Waybills_save_PDF;
	    pdf.getParameters().put('type',awb_type);
	    pdf.getParameters().put('id',record.Id);
	    if(displayBackground)
        {
        	pdf.getParameters().put('background','true'); 
        }
        else
        {
        	pdf.getParameters().put('background','false');
        }	       	    
	    return pdf;
    }
    
    public PageReference refrescar_pdf()
    {
    	try 
    	{
    		//HOUSE
    		if(record.Weight_Charge_House__c != null || record.Valuation_Charge_House__c != null || record.Tax_House__c != null 
    		|| record.Total_Other_Charges_Due_Agent_House__c != null || record.Total_Other_Charges_Due_House__c != null) 
    		{
    			record.Weight_Charge_House__c=(record.Weight_Charge_House__c != null ? NEU_Utils.safeDecimal(record.Weight_Charge_House__c) : 0);
    			record.Valuation_Charge_House__c=(record.Valuation_Charge_House__c != null ? NEU_Utils.safeDecimal(record.Valuation_Charge_House__c) : 0);
    			record.Tax_House__c=(record.Tax_House__c != null ? NEU_Utils.safeDecimal(record.Tax_House__c) : 0);
    			record.Total_Other_Charges_Due_Agent_House__c=(record.Total_Other_Charges_Due_Agent_House__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent_House__c) : 0);
    			record.Total_Other_Charges_Due_House__c=(record.Total_Other_Charges_Due_House__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_House__c) : 0);
    		}
    		//MASTER
    		if(record.Weight_Charge_Master__c != null || record.Valuation_Charge_Master__c != null || record.Tax_Master__c != null 
    		|| record.Total_Other_Charges_Due_Agent_Master__c != null || record.Total_Other_Charges_Due_Master__c != null) 
    		{
    			record.Weight_Charge_Master__c=(record.Weight_Charge_Master__c != null ? NEU_Utils.safeDecimal(record.Weight_Charge_Master__c) : 0);
    			record.Valuation_Charge_Master__c=(record.Valuation_Charge_Master__c != null ? NEU_Utils.safeDecimal(record.Valuation_Charge_Master__c) : 0);
    			record.Tax_Master__c=(record.Tax_Master__c != null ? NEU_Utils.safeDecimal(record.Tax_Master__c) : 0);
    			record.Total_Other_Charges_Due_Agent_Master__c=(record.Total_Other_Charges_Due_Agent_Master__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent_Master__c) : 0);
    			record.Total_Other_Charges_Due_Master__c=(record.Total_Other_Charges_Due_Master__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Master__c) : 0);
    		}
    		//Alternative_Fligtht
    		if(record.Alternative_Fligtht_1__c != null || record.Alternative_Fligtht_2__c != null)
    		{
    			record.Alternative_Fligtht_1__c = (record.Alternative_Fligtht_1__c != null ? NEU_Utils.safeString(record.Alternative_Fligtht_1__c) : '');
    			record.Alternative_Fligtht_2__c = (record.Alternative_Fligtht_2__c != null ? NEU_Utils.safeString(record.Alternative_Fligtht_2__c) : '');
    		} 
    		update record; 
    		if(awb_type == 'house') 
    			update lines_house;
    		if(awb_type == 'master') 
    			update lines;
    		
    	} catch( Exception ee) {}
    	
    	PageReference pdf = null;
	    pdf = Page.NEU_Air_Waybills_save_PDF;
	    pdf.getParameters().put('type',awb_type);
	    pdf.getParameters().put('id',record.Id);
	    if(displayBackground)
        {
        	pdf.getParameters().put('background','true'); 
        }
        else
        {
        	pdf.getParameters().put('background','false');
        }	       	    
	    return pdf;
    }
    
    public PageReference return_page()
    {
        return con.view();
    }
    
    public PageReference crear()
    {
        PageReference pdf = null;
        pdf = Page.NEU_Air_Waybills_PDF;
        pdf.getParameters().put('id',record.Id);        
        pdf.getParameters().put('type',awb_type);
        
        if(displayBackground)
        {
        	pdf.getParameters().put('background','true'); 
        }
        else
        {
        	pdf.getParameters().put('background','false');
        }
        
        Blob body;
        
        try 
        {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Air Waybill'];
        documento_asociado.Body = body;
        documento_asociado.Name = 'Waybill_'+record.name +'.pdf';
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
        new_document.Name = (awb_type == 'house' ? 'House ' : 'Master ') + 'Waybill '+record.Name +'.pdf';
        new_document.Air_Waybill__c =record.Id;
        new_document.Document_Type__c = 'Waybill';
        if(record.Shipments_Program__c != null || Test.isRunningTest())
            new_document.Consolidation_Program__c =record.Shipments_Program__c;
            
        new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}
             
    }
    
    public void fail()
    { 
    	if(record.House_Reference__c==null)
		{
			errores='House Reference is null in the Waybill.';
			id_waybill = '';
			return;	
		}
    	for(Air_Waybill_Line__c awl: lines)
		{
			if(awl.Rate_Charge__c==null)
			{
				errores='Rate/Charge is null in Line '+awl.Name+'.';
				id_waybill = '';
				return;	
			}
			if(awl.House_Reference__c==null)
			{
				errores='House Reference is null in Line '+awl.Name+'.';
				id_waybill = '';
				return;	
			}
		}		
    }
}