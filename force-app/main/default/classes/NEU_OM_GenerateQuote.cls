public with sharing class NEU_OM_GenerateQuote {

    public Customer_Quote__c record;
    public List<Import_Export_Fee_Line__c> revefeelines {get;set;}
    public List<Import_Export_Fee_Line__c> disburfeelines {get;set;}
    public List<Import_Export_Fee_Line__c> Transportfeelines {get;set;}
    public List<Quote_Item_Line__c> itemslines {get;set;}
    public String cotizacion_completa {get;set;}
    public decimal total_lineas {get;set;}
    public Decimal total_lineas_items {get;set;}
    public Decimal total_disburfee {get;set;}
    public Decimal total_refee {get;set;}
    public Decimal total_transfee {get;set;}
    public Decimal total_fees {get;set;}
    public Decimal total_document {get;set;}
    public String resultado {get;set;}
    public boolean hay_fees_disbur {get;set;}
    public boolean hay_fees_reve {get;set;}
    public boolean hay_fees_trans {get;set;}
    public boolean hay_items {get;set;}
    public decimal totaltaxes {get;set;}
    public string totalestrans {get;set;}
    public string totalrefee {get;set;}
    public string totallineasitems {get;set;}
    public string totaldisburfee {get;set;}
    public string totaldocumentos {get;set;}
    public string totalfees {get;set;}
    public string totaltaxesstring {get;set;}
    
    public string currency_customer_quote {get;set;}
    
    ApexPages.StandardController con;
            
    public NEU_OM_GenerateQuote(ApexPages.StandardController stdController) {

        con = stdController;
        
        try { 
        record = [select Id, Name, Account_for__c,  Quotation_Status__c, Approved_Date__c, Account_Executive_User__c,Account_for__r.Name,Account_for_Billing_Address__c,Account_for_Shipping_Address__c,Contact__r.Name,SUM_Buy_Origin_Amount_number__c from Customer_Quote__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Customer_Quote__c();
        }
        total_lineas_items =0;
        total_disburfee =0;
        total_refee =0;
        total_fees = 0;
        total_document = 0;
        totaltaxes = 0;
        total_transfee = 0;
        hay_fees_disbur =false;
        currency_customer_quote = NEU_CurrencyUtils.getCurrencyIsoCode(record);
            disburfeelines = [select Id, Name, Import_Export_Quote__c, Units__c, Extension_Service_Name__c, Service_Rate_Name__r.Name, Rate_Type__c, Quote_Sell_Price__c,Sell_Amount__c, Quote_Buy_Price__c, Buy_Amount__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id and Service_Rate_Name__r.Fee_Category__c =: 'Disbursement']; 
            for(Import_Export_Fee_Line__c lines:disburfeelines)
            {
                total_disburfee +=lines.Sell_Amount__c;
                hay_fees_disbur = true;
            }
        hay_fees_reve = false;
        revefeelines = [select Id, Name, Import_Export_Quote__c, Units__c, Extension_Service_Name__c,Service_Rate_Name__r.Name, Rate_Type__c, Quote_Sell_Price__c,Sell_Amount__c, Quote_Buy_Price__c, Buy_Amount__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id and Service_Rate_Name__r.Fee_Category__c =: 'Clearing Costs']; 
         for(Import_Export_Fee_Line__c lines:revefeelines)
          {
                total_refee +=lines.Sell_Amount__c;
                hay_fees_reve = true;
          }
        hay_fees_trans =false; 
        Transportfeelines = [select Id, Name,Extension_Service_Name__c, Units__c, Import_Export_Quote__c,Service_Rate_Name__r.Name, Rate_Type__c, Quote_Sell_Price__c,Sell_Amount__c, Quote_Buy_Price__c, Buy_Amount__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id and Service_Rate_Name__r.Fee_Category__c =: 'Transport & Freights']; 
         for(Import_Export_Fee_Line__c lines:Transportfeelines)
          {
                total_transfee +=lines.Sell_Amount__c;
                hay_fees_trans = true;
                
          }
          hay_items = false;
         itemslines = [select Id, Name,Item_Name__r.Name, Extension_Item_Name__c, Duty__c,Price__c, Item_Supplier_Owner__c, Item_Supplier_Owner__r.Name, Units__c, Amount__c,Product_Item_DC__c,Total_Taxes_Form__c, Family__c  from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Family__c]; 
         for(Quote_Item_Line__c lines:itemslines)
         {
                total_lineas_items +=lines.Amount__c;
                if(lines.Total_Taxes_Form__c!= null)
                    totaltaxes += lines.Total_Taxes_Form__c;
                hay_items = true;
         }
            
        total_document = total_lineas_items+total_refee+total_disburfee+total_transfee+totaltaxes;
        total_fees = total_refee +total_disburfee+total_transfee;
        
        Decimal rA2 = total_transfee;
        List<String> args2 = new String[]{'0','number','###,###,##0.00'};
        String s2 = String.format(rA2.format(), args2);
        totalestrans = s2;
        
        rA2 = total_refee;
        s2 = String.format(rA2.format(), args2);
        totalrefee  = s2;
        
        rA2 = total_lineas_items;
        s2 = String.format(rA2.format(), args2);
        totallineasitems  = s2;
        
        rA2 = total_disburfee;
        s2 = String.format(rA2.format(), args2);
        totaldisburfee = s2;
        
        rA2 = total_document;
        s2 = String.format(rA2.format(), args2);
        totaldocumentos = s2;
        
        rA2 = total_fees;
        s2 = String.format(rA2.format(), args2);
        totalfees = s2;
        
        rA2 = totaltaxes;
        s2 = String.format(rA2.format(), args2);
        totaltaxesstring = s2;  
     
    }
    
}