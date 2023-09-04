public with sharing class NEU_Import_Export_Comparison_save_pdf {

	public Customer_Quote__c record;
	
	public Customer_Quote__c buscador {get;set;}
	
	public String id_quote {get;set;}
    public string language {get;set;}
    public Integer numberDocuments{get;set;}
	    
	public List<Customer_Quote__c> quotes_cc {get; set;}
	
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
    
    private List<SelectOption> newcategories=null;
    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            newcategories=new List<SelectOption>();
            newcategories.add(new SelectOption('EN','ENGLISH'));
            //newcategories.add(new SelectOption('ES','SPANISH'));
            language ='EN';
        }
        return newcategories;
    }
    
    public String querystring
    {
    	get
    	{
    		if(querystring==null)
    		{
		    	querystring='?id='+record.Id;
		    	querystring+='&services_charges=true';
		        if(language == 'EN' || Test.isRunningTest())
		        {
		            querystring+='&lang=en_US'; 
		        }
		        if(language == 'ES' || Test.isRunningTest())
		        {
		            querystring+='&lang=es_ES'; 
		        }
		   		String ids=getIdsOptions(); 
		        if(ids!='')
		            querystring+='&ids='+ids;
    		}
    		return querystring;
    	}
    	set;
    }
    
	ApexPages.StandardController con;
            
    public NEU_Import_Export_Comparison_save_pdf(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try 
        { 
        	record = [SELECT Id, Name, Account_for__c,  Quotation_Status__c, Approved_Date__c, 
        			  Account_Executive_User__c, Account_for__r.Name, Account_for_Billing_Address__c,
        			  Account_for_Shipping_Address__c, Contact__r.Name, SUM_Sell_Origin_Amount_number__c, 
        			  Supply_Project_Name__r.Name, Supply_Project_Name__c, Freight_Mode__c, Service_Mode__c,
        			  Route__c
        			  FROM Customer_Quote__c 
        			  WHERE id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Customer_Quote__c();
        }
        
        quotes_cc = new List<Customer_Quote__c>();
    	quotes_cc.add(record);
        
        try 
        { 
			List<Associated_Document__c> documentos = [SELECT Id FROM Associated_Document__c WHERE Import_Export_Quote__c =: record.Id];
			numberDocuments = documentos.size();
        } catch( Exception ee) { 
            numberDocuments = 0;
        }
        
        buscador = new Customer_Quote__c();
        
    }
    
    public void updateFilters()
    {
		querystring=null;
    }
    
    public string getIdsOptions()
    {
   		String ids=''; 
        for(Customer_Quote__c ie : quotes_cc)
       	{
			if(ie.Id!=null && ie.Id != record.Id)
			{
			    if(ids=='')
		        	ids+=ie.Id;
		   		else
		        	ids+=','+ie.Id;				
			}
       	}
        return ids;  	
    }
    
    public PageReference crear()
    {
		PageReference pdf = null;
        pdf = Page.NEU_IE_Comparison_PDF;
        
        pdf.getParameters().put('id',record.Id);
        
        if(language == 'EN' || Test.isRunningTest())
        {
            pdf.getParameters().put('services_charges','true');
            pdf.getParameters().put('lang','en_US'); 
        }
        if(language == 'ES' || Test.isRunningTest())
        {
            pdf.getParameters().put('services_charges','true');
            pdf.getParameters().put('lang','es_ES'); 
        }
         
   		String ids=getIdsOptions(); 
        if(ids!='')
            pdf.getParameters().put('ids',ids);
                                
        Blob body;
        
        try 
        {
        	body = pdf.getContent();
        } 
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
        documento_asociado.Body = body;
        documento_asociado.Name = record.name +'IEQ-Comparison.pdf';
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
        new_document.Name = record.Name +' IEQ-Comparison.pdf';
        new_document.Import_Export_Quote__c=record.Id;
        if(record.Supply_Project_Name__r.Name != null)
            new_document.Supply_Project__c =record.Supply_Project_Name__c;
            
        new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}
             
    }
    
	public void add_quote()
	{
		updateFilters();
		
		List<Customer_Quote__c> quotes = new List<Customer_Quote__c>();
		if(buscador.Comparison_Search__c != null)
		{
			String consulta = '';
			consulta += 'SELECT Id, Name, Freight_Mode__c, Service_Mode__c, Quotation_Status__c, Route__c, Account_for__c ';
			consulta += 'FROM Customer_Quote__c WHERE Id = \''+buscador.Comparison_Search__c+'\' AND Id NOT IN :quotes_cc';
			quotes = Database.query(consulta);
		}
					
		for(Customer_Quote__c ie : quotes)
		{
			if(record.Route__c != ie.Route__c)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The selected quote must have the same Route as main quote.'));
				break;
			}
			if(record.Account_for__c != ie.Account_for__c)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The selected quote must have the same Account as main quote.'));
				break;
			}
			quotes_cc.add(ie);
		}
	}
	
	public void remove_quote()
	{
		updateFilters();
		Integer i = 0;
		
		if(quotes_cc.size() > 0)
		{
			for(Customer_Quote__c ie : quotes_cc)
			{
				if(ie.Id == id_quote)
					break;
				
				i++;
			}
			quotes_cc.remove(i);
		}
	}
	    
}