public with sharing class NEU_Upload_Associated_Photos 
{
	public Blob document_photo{get;set;}
    public String document_photoName{get;set;}
    
    public String Bucket_Name{get;set;}
    public string key {get;set;}
    public string policy_hidden {get;set;}
    public string signedPolicy {get;set;}
    
    public Boolean upload_correct{get;set;}
    public List<Associated_Photo__c> new_list_associated_photo = null;
    
    public string documents_names {get;set;}
    public string documents_names_dates {get;set;}
    public string id_org {get;set;}
    public string id_shipment_shipment_program {get;set;}
    public boolean errores {get;set;}
    public boolean falta_cuenta_shipments_program {get;set;}
    
    public string id_object {get;set;}
    public string name_object {get;set;}
    public id type_object = null;
    List<Shipment__c> query_shipment = null;
    List<Shipment_Program__c> query_shipment_program = null;
    
    private String AWSCredentialName = 'S3Credential'; //Modify this string variable to be the name of the AWS Credential record that contains the proper AWS keys and secret
    
    
    private string key_amazon = 'AKIAJYSTT4P2WPGMPW5A';//Modify this string variable to be the name of the AWS Credential record that contains the proper AWS keys and secret
	private string secret_amazon = '1bTBNzKXFW4o9QmwtegenmIpBI/ga1k+qq5Sfan5';//Modify this string variable to be the name of the AWS Credential record that contains the proper AWS keys and secret
    
    
    public S3.AmazonS3 as3 { get; private set; }
    
    public void get_credentials_to_conect_amazon()
    {
    	try
    	{
			as3 = new S3.AmazonS3(key_amazon,secret_amazon);
		}
		catch(Exception ex)
		{
		     System.debug('Caught exception in AWS_S3: ' + ex);
		     ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage());
			 ApexPages.addMessage(errorMsg);
		}
		
    }
    
    datetime expire = system.now().addDays(1);
	String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
	expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';
	
	string access = 'public-read';	
	
    string policy { get {return 
		'{ "expiration": "'+formattedexpire+'","conditions": [ {"bucket": "'+
    	Bucket_Name +'" } ,{ "acl": "'+
    	access +'" },'+
    	'["starts-with", "$key", ""] ]}'; 	} } 
    
    public String getPolicy() 
    {
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
    }
    
    public String getSignedPolicy() 
    {    
        return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policy)));        
    }
    
    //method that will sign
    private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret_amazon));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(secret_amazon)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
	
	
	public NEU_Upload_Associated_Photos()
    {
    	signedPolicy = '';
    	policy_hidden = '';
    	key = '';
		key = key_amazon;
    	document_photoName = '';
    	Bucket_Name = 'neurored-s3';
    	id_org = UserInfo.getOrganizationId();
    	id_shipment_shipment_program = ApexPages.currentPage().getParameters().get('id');
    	documents_names = '';
    	documents_names_dates = '';
    	policy_hidden = getpolicy();
    	signedPolicy = getSignedPolicy();
    	falta_cuenta_shipments_program = false;
    	
    	id_object = ApexPages.currentPage().getParameters().get('id');
    	id type_object = ApexPages.currentPage().getParameters().get('id');  
        string type_object_string = string.valueof(type_object.getSobjectType());
        type_object_string = type_object_string.replace('NEUEBUSCM__',''); 
        if(type_object_string == 'Shipment__c')
        {
        	query_shipment = [select Id, Name, Account_for__c,Account_for__r.name from Shipment__c where id =: ApexPages.currentPage().getParameters().get('id')];
        	name_object = query_shipment[0].Name;
        }
        else if(type_object_string == 'Shipment_Program__c')
        {
        	query_shipment_program = [select Id, Name, Files_Account_Owner__c from Shipment_Program__c where id=: ApexPages.currentPage().getParameters().get('id')];
        	name_object = query_shipment_program[0].Name;
        	if(query_shipment_program[0].Files_Account_Owner__c == null)
        	{
        		falta_cuenta_shipments_program = true;
        	}
        }
        
    	upload_correct = true;
    	errores = false;
    }
    
    public void save_associated_photo()
    {
    	new_list_associated_photo = new List<Associated_Photo__c>();
    	
    	upload_correct = true;
    	errores = false;
     	
     	id type_object = ApexPages.currentPage().getParameters().get('id'); 
        string type_object_string = string.valueof(type_object.getSobjectType());
        type_object_string = type_object_string.replace('NEUEBUSCM__','');
        
        if(string.isnotempty(documents_names))
        {
	        List<String> List_documents_Names = new List<String>();	
	        documents_names = documents_names.subString(0,documents_names.length() -3);
	        List_documents_Names = documents_names.split('_&_'); 	
	        	
	        List<String> List_documents_Names_Completos = new List<String>();	
	        if(string.isnotempty(documents_names_dates))
	        {
	        	documents_names_dates = documents_names_dates.subString(0,documents_names_dates.length() -3);
	        	List_documents_Names_Completos = documents_names_dates.split('_&_'); 	
	        }
	        integer contador_posicion = 0;
	        if(List_documents_Names_Completos.size() == List_documents_Names.size())	
	        for(String name_document:List_documents_Names)
	        {
	        	
	        	
	        	
	        	Associated_Photo__c new_associated_photo = new Associated_Photo__c();
	        	new_associated_photo.Name = name_document;
	        	
	        	
		        if(type_object_string == 'Shipment__c')
		        {
		        	new_associated_photo.Account__c =  query_shipment[0].Account_for__c;
	    			new_associated_photo.Shipment__c = query_shipment[0].Id;
	    					

		        }
		        else if(type_object_string == 'Shipment_Program__c')
		        {
					new_associated_photo.Account__c = query_shipment_program[0].Files_Account_Owner__c;
					new_associated_photo.Shipments_Program__c = query_shipment_program[0].Id;
		        }
	
				new_associated_photo.Photo_URL__c = 'https://s3-us-west-2.amazonaws.com/'+Bucket_Name+'/'+ List_documents_Names_Completos[contador_posicion];
				new_list_associated_photo.add(new_associated_photo);
		        
		    	contador_posicion ++; 
	        }
	        //insertar registro de referencia del documento
	        try
		    {
		    	insert new_list_associated_photo;
		    }
		    catch(exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'+ ex));upload_correct = false;errores=true;}
	        	
        }

    }
    
    public PageReference return_to_object()
    {
    	PageReference pgReturnPage;
    	String returnUrl = '/' + ApexPages.currentPage().getParameters().get('id');
      	pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
    	return pgReturnPage;			
    } 
}