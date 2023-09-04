public with sharing class NEU_OM_Save_Generate_Quote_Order_pdf {
    
    public Supplier_Quote__c record;
    public List<Supplier_Quote_Line__c> itemslines {get;set;}
    public String cotizacion_completa {get;set;}
    public decimal total_lineas {get;set;}
    public Decimal total_lineas_items {get;set;}
    public Decimal total_document {get;set;}
    public String resultado {get;set;}
    public boolean hay_items {get;set;}
    public string totallineasitems {get;set;}
    public string totaldocumentos {get;set;}
    
    public string currency_supplier_quote {get;set;}
    ApexPages.StandardController con;
            
    public NEU_OM_Save_Generate_Quote_Order_pdf(ApexPages.StandardController stdController) {

        con = stdController;
        
        try { 
        record = Database.query('select Id, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Name from Supplier_Quote__c where id = \''+ con.getRecord().id+'\'');
        } catch( Exception ee) { 
            record = new Supplier_Quote__c();
        }
        
        total_lineas_items =0;
        total_document = 0;
        currency_supplier_quote = NEU_CurrencyUtils.getCurrencyIsoCode(record); 
         hay_items = false;
         itemslines = [select Id, Name, Supplier_Quote__c, Total_Amount__c, Unit_Origin_Price__c, Quantity__c, Item__c, Item__r.Name  from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id order by Family__c]; 
         for(Supplier_Quote_Line__c lines:itemslines)
         {
                total_lineas_items +=lines.Total_Amount__c;
                hay_items = true;
         }
            
        total_document = total_lineas_items;

        List<String> args2 = new String[]{'0','number','###,###,##0.00'};

        Decimal rA2 = total_lineas_items;
        String s2 = String.format(rA2.format(), args2);
        totallineasitems  = s2;
        
        
        rA2 = total_document;
        s2 = String.format(rA2.format(), args2);
        totaldocumentos = s2;
        
    
     
    }
    
}