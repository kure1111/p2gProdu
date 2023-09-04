public class NEU_New_Client {

    public Account record{get;set;}
    public Contact customercontact{get;set;}
    public string currency_selected{get;set;}
    public List<SelectOption> currencys {get; set;}
    private List<families_s> families=null;
    
    public List<families_s> getfamilies()
    {
        if(families==null)
        {
            families = new List<families_s>();
            
            
            List<Product_Family__c> query_family = null;
            
            if(query_family==null)
            {
                CSL_Self_Registration__c mc = CSL_Self_Registration__c.getValues('Customer');
                list<string> lista_de_business_area = null;
                if(mc != null)
                    if(mc.Business_Areas__c != null)
                        lista_de_business_area = mc.Business_Areas__c.split(';');
                if(mc != null)
                {      
                    if(mc.Business_Areas__c != null)
                        query_family = [select Id, Name, Business_Area__c, Description__c, Url_Image__c from Product_Family__c where Business_Area__c IN:lista_de_business_area order by Business_Area__c, Name asc];
                    else
                        query_family = [select Id, Name, Business_Area__c, Description__c, Url_Image__c from Product_Family__c order by Business_Area__c, Name asc];
                }
                else
                    query_family = [select Id, Name, Business_Area__c, Description__c, Url_Image__c from Product_Family__c order by Business_Area__c, Name asc];
            }    
            for(Product_Family__c fa : query_family)
                families.add(new families_s(fa.Id, (fa.Name != null ? fa.Name : ''), (fa.Url_Image__c != null ? fa.Url_Image__c : ''), (fa.Business_Area__c != null ? fa.Business_Area__c : ''), (fa.Description__c != null ? fa.Description__c : ''), false, false));
        }
        return families;
    }

    public class families_s
    {
        public String id {get;set;}
        public String name {get;set;}
        public String id_image {get;set;}
        public String business_area {get;set;}
        public String description {get;set;}
        public Boolean selected {get;set;}
        public Boolean created {get;set;}
        
        public families_s(String id, String name, String id_image, String business_area, String description, Boolean selected, Boolean created)
        {
            this.id = id;
            this.name = name;
            this.id_image = id_image;
            this.business_area = business_area;
            this.description = description;
            this.selected = selected;
        }
    }
    public Document logo
    {
        get 
        {
          if (logo == null)
            logo = new Document();
          return logo;
        }
        set;
    }
    
    public NEU_New_Client(ApexPages.StandardController stdController) {    
        
        record = new Account();
        record.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        customercontact=new Contact();
        
        currencys  = new List<SelectOption>(); 
        for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
        {
               currencys.add(new SelectOption(lu,lu));
        }
        
    }
    public PageReference send_form()
    {
        Integer counter=0;
        for(families_s f:getfamilies())
            if(f.selected)
                counter++;
        if(counter==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Families supplied: You must select one or more families'));
            return null;        
        }
        Boolean updaterecord=false;
        if(record.Id==null)
        {
            NEU_CurrencyUtils.setCurrencyIsoCode(record, currency_selected);
            insert record;
        }
        else
            updaterecord=true;
           
        if(customercontact.Id!=null)
            update customercontact;
        else
        {
            customercontact.AccountId=record.Id;
            insert customercontact;
        }
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name='Customers Logos'];
        
        if(String.IsNotEmpty(logo.Name))
        {
            logo.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                logo.FolderId = directorio[0].Id;
            logo.IsPublic = true;   
            insert logo;
            record.Url_Factory_Logo__c = '/servlet/servlet.ImageServer?id='+logo.Id+'&oid='+ UserInfo.getOrganizationId();
            updaterecord=true;
        }
        
        List<Family_Supplied__c> currentfamilies_supplied = [select Family__c from Family_Supplied__c where Supplier_Account__c=:record.Id];
        List<Family_Supplied__c> families_supplied = new List<Family_Supplied__c>();
        List<Family_Supplied__c> families_notsupplied = new List<Family_Supplied__c>();
        
        String bussiness_area='';
        for(families_s f:getfamilies())
        {
            if(f.selected)
            {
                Boolean found=false;
                for(Family_Supplied__c cfam:currentfamilies_supplied)
                    if(cfam.Family__c==f.id)
                    {
                        found=true;
                        break;
                    }
                if(!found)
                {
                    Family_Supplied__c new_family_supplied = new Family_Supplied__c();
                    new_family_supplied.Family__c = f.id;
                    new_family_supplied.Supplier_Account__c = record.Id;
                    families_supplied.add(new_family_supplied);
                }
                if(!bussiness_area.contains(f.business_area))
                    bussiness_area += f.business_area+';'; 
            }
            else
            {
                for(Family_Supplied__c cfam:currentfamilies_supplied)
                    if(cfam.Family__c==f.id)
                        families_notsupplied.add(cfam);
            }
        }
        
        if(bussiness_area!=record.Business_Area__c)
        {
            record.Business_Area__c = bussiness_area;
            updaterecord=true;
        }
        
        if(updaterecord)
        {
            NEU_CurrencyUtils.setCurrencyIsoCode(record,currency_selected);
            update record;
        }
        
        if(families_supplied.size()>0)
            insert families_supplied;
        if(families_notsupplied.size()>0)
            delete families_notsupplied;
            
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Data has been received successfully'));
         
        return null;
    }
}