public with sharing class NEU_MD_Select_Families_Supplied
{
    public Account record;
    public List<families_s> familias {get;set;}
    public String id_family {get;set;}
    public String id_org {get;set;}

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
            this.created = created;
        }
    }

    ApexPages.StandardController con;
    
    public NEU_MD_Select_Families_Supplied(ApexPages.StandardController stdController) 
    {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Business_Area__c from Account where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Account();
        }
        
        id_org = UserInfo.getOrganizationId();

        List<families_s> family_list = new List<families_s>();

        Boolean creado = false;

        List<Family_Supplied__c> families_asociated = [select Id, Name, Family__c, Supplier_Account__c from Family_Supplied__c where Supplier_Account__c =: record.Id];
        
        //bussines area array para consulta
        String consulta_bussiness_area = (record.Business_Area__c != null ? record.Business_Area__c : '') ;
        String[] bussiness_area = new String[]{};
        bussiness_area = consulta_bussiness_area.split(';');
          
        List<Product_Family__c> families = new List<Product_Family__c>();
       if(record.Business_Area__c != null)
            families = [select Id, Name, Business_Area__c, Description__c, Url_Image__c from Product_Family__c where Business_Area__c IN: bussiness_area order by Business_Area__c, Name asc];
        else
            families = [select Id, Name, Business_Area__c, Description__c, Url_Image__c from Product_Family__c order by Business_Area__c, Name asc];
        
        
        for(Product_Family__c fa : families)
        {
            for(Family_Supplied__c fs : families_asociated)
            {
                if(fs.Family__c == fa.Id)
                {
                    creado = true;
                    break;
                }
                else
                    creado = false;
            }

            family_list.add(new families_s(fa.Id, (fa.Name != null ? fa.Name : ''), (fa.Url_Image__c != null ? fa.Url_Image__c.substringBetween('?id=', '&oid=') : ''), (fa.Business_Area__c != null ? fa.Business_Area__c : ''), (fa.Description__c != null ? fa.Description__c : ''), false, creado));
            
            creado = false;
        }
        
        familias = family_list;
    }
    
    public PageReference allocate_families()
    {
        List<Family_Supplied__c> families_supplied = new List<Family_Supplied__c>();
        
        for(families_s f : familias)
        {
            if(f.selected)
            {
                Family_Supplied__c new_family_supplied = new Family_Supplied__c();
                new_family_supplied.Family__c = f.id;
                new_family_supplied.Supplier_Account__c = record.Id;
                families_supplied.add(new_family_supplied);
                
                f.created = true;
                f.selected = false;
            }
        }
        
        try
        {
            insert families_supplied;
        }
        catch(Exception ex){}
        
        return null;
    }
    
    public PageReference remove_family()
    {
        List<Family_Supplied__c> family_to_delete = [select Id, Name, Family__c from Family_Supplied__c where Family__c =: id_family];
        
        try
        {
            delete family_to_delete;
            
            for(families_s f : familias)
            {
                if(f.id == id_family)
                {
                    f.created = false;
                    f.selected = false;
                    break;
                }
            }
        }
        catch(Exception ex){}
        
        return null;    
    }
    
    public PageReference return_account()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
}