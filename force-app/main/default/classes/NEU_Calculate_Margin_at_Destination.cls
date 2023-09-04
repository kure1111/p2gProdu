public with sharing class NEU_Calculate_Margin_at_Destination{

   public Customer_Quote__c record = null;
   private List<Line_s> Lines=null;
   public decimal margin_general  {get;set;}
   public String[] ordenacion_quotes;
   public String orden_quotes {get;set;}
   public String decimalSep
   {
       get
       {
         if(decimalSep==null)
           decimalSep=NEU_Utils.getDecimalSep();
         return decimalSep;
       }
       set
       {
         decimalSep=value;
       }
   }
   public String thousandSep
   {
       get
       {
         if(thousandSep==null)
           thousandSep=NEU_Utils.getThousandSep();
         return thousandSep;
       }
       set
       {
         thousandSep=value;
       }
   }
   public NEU_Calculate_Margin_at_Destination(ApexPages.StandardController stdController) {
         
            if (!Test.isRunningTest()) {stdController.AddFields(new String[]{'Id','Name','Route__c', 'Site_of_Discharge__c', 'Site_of_Load__c','Pickup_Cartage__c', 'Supplier_Account__c','Purchase_Incoterm__c','Sales_Incoterm__c', 'Country_ofLoad__c', 'Country_ofDischarge__c','Total_Weight_Kg2__c', 'Total_Volume_m3_2__c' });}
            record=(Customer_Quote__c)stdController.getRecord();
     }
     
    public Boolean getShowImportExportItemLines()
    {
        if(getLines()!=null)
            return Lines.size()>0;
        return false;
    }
     
     
    public class Line_s implements Comparable
    {
        public Quote_Item_Line__c quote_line {get; set;}
        public decimal precio_unidad{get;set;} 
        public decimal margin{get;set;} 
        public String precio_margin{get;set;} 
        public string totalsellamount{get;set;} 
        public decimal unitoriginprice{get;set;} 
        public String moneda_origen_linea{get;set;}
        public decimal unitoriginpricedestino{get;set;}
        public string campo_compare{get;set;}
        public string orden_de_comparacion{get;set;}
        
        public String getId()
        {
            if(quote_line!=null)
                return quote_line.Id;
            return null;
        }
        
        public Line_s(Quote_Item_Line__c quote_line, decimal precio_unidad, decimal margin, decimal precio_margin, decimal totalsellamount, decimal unitoriginprice, String moneda_origen_linea, decimal unitoriginpricedestino)
        {
            this.quote_line=quote_line;
            this.precio_unidad = precio_unidad;
            this.margin = margin; 
            this.precio_margin = precio_margin.format();
            this.totalsellamount= NEU_Utils.safeDecimal(totalsellamount).format(); //NEU_Utils.safeDecimal(conversion_factor).format();
            this.unitoriginprice= unitoriginprice;
            this.moneda_origen_linea= moneda_origen_linea;
            this.unitoriginpricedestino = unitoriginpricedestino;
        }
        
          // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
                    Line_s compareToEmp = (Line_s)compareTo;
     
                    if(campo_compare  == 'totalsellamount' )
                    {
                        if (totalsellamount  == compareToEmp.totalsellamount) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (totalsellamount > compareToEmp.totalsellamount) return 1;
                        }
                        else
                            if (totalsellamount < compareToEmp.totalsellamount) return 1;
                
                    }
                    
                    if(campo_compare  == 'precio_margin' )
                    {
                        if (precio_margin  == compareToEmp.precio_margin) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (precio_margin > compareToEmp.precio_margin) return 1;
                        }
                        else
                            if (precio_margin < compareToEmp.precio_margin) return 1;
                    
                    }
                    if(campo_compare  == 'unitoriginprice' )
                    {
                        if (unitoriginprice  == compareToEmp.unitoriginprice) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (unitoriginprice > compareToEmp.unitoriginprice) return 1;
                        }
                        else
                            if (unitoriginprice < compareToEmp.unitoriginprice) return 1;
                    
                    }
                      if(campo_compare  == 'quote_line.Units__c' )
                    {
                        if (quote_line.Units__c == compareToEmp.quote_line.Units__c) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (quote_line.Units__c> compareToEmp.quote_line.Units__c) return 1;
                        }
                        else
                            if (quote_line.Units__c< compareToEmp.quote_line.Units__c) return 1;
                    
                    }
                    
                    if(campo_compare  == 'quote_line.Import_Export_Quote__r.Name' )
                    {
                        if (quote_line.Import_Export_Quote__r.Name == compareToEmp.quote_line.Import_Export_Quote__r.Name) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (quote_line.Import_Export_Quote__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Name) return 1;
                        }
                        else
                            if (quote_line.Import_Export_Quote__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Name) return 1;
                    
                    }
                    
                    if(campo_compare  == 'quote_line.Delivery_Number__c' )
                    {
                        if (quote_line.Delivery_Number__c == compareToEmp.quote_line.Delivery_Number__c) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (quote_line.Delivery_Number__c  > compareToEmp.quote_line.Delivery_Number__c) return 1;
                        }
                        else
                            if (quote_line.Delivery_Number__c < compareToEmp.quote_line.Delivery_Number__c) return 1;
                    
                    }
                    
                      if(campo_compare  == 'quote_line.Delivery_Date__c' )
                    {
                        if (quote_line.Delivery_Date__c== compareToEmp.quote_line.Delivery_Date__c) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (quote_line.Delivery_Date__c > compareToEmp.quote_line.Delivery_Date__c) return 1;
                        }
                        else
                            if (quote_line.Delivery_Date__c < compareToEmp.quote_line.Delivery_Date__c) return 1;
                    
                    }
                    
                      if(campo_compare  == 'quote_line.Item_Name__r.Name' )
                    {
                        if (quote_line.Item_Name__r.Name== compareToEmp.quote_line.Item_Name__r.Name) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (quote_line.Item_Name__r.Name> compareToEmp.quote_line.Item_Name__r.Name) return 1;
                        }
                        else
                            if (quote_line.Item_Name__r.Name< compareToEmp.quote_line.Item_Name__r.Name) return 1;
                    
                    }
                    
                      if(campo_compare  == 'quote_line.Extension_Item_Name__c' )
                    {
                        if (quote_line.Extension_Item_Name__c == compareToEmp.quote_line.Extension_Item_Name__c) return 0;
                        if(orden_de_comparacion == 'asc')
                        {
                            if (quote_line.Extension_Item_Name__c > compareToEmp.quote_line.Extension_Item_Name__c) return 1;
                        }
                        else
                            if (quote_line.Extension_Item_Name__c < compareToEmp.quote_line.Extension_Item_Name__c) return 1;
                    
                    }
                    
                    
                  return -1;
        }
        
     }
     
       public void go_compare()
    {
        
        ordenacion_quotes = new String[]{};
        if(orden_quotes != null)
        {
            ordenacion_quotes = orden_quotes.split('-'); 
            for(Line_s li: getLines())
            {
                li.campo_compare = ordenacion_quotes[0];
                li.orden_de_comparacion = ordenacion_quotes[1];
            }   
            Lines.sort();
        }
                
    }
    
    public PageReference save_margin()
    {
        if(Lines != null)
        {
            List<Quote_Item_Line__c> lista_quote_lines = new List<Quote_Item_Line__c>();
            for(Line_s li: getLines())
            {
                if(NEU_Utils.safeDecimal(li.quote_line.Margin_at_Destination__c)!= 0)
                {
                    li.quote_line.Margin_at_Destination__c = li.quote_line.Margin_at_Destination__c;
                    lista_quote_lines.add(li.quote_line);
                }
            }
            
            if(lista_quote_lines != null && lista_quote_lines.size()>0)
            {
                try
                {
                    update lista_quote_lines;
                }
                catch(Exception ex){return null;}
                
            }
        }
         return new PageReference('/'+record.Id);
    }
     
     public List<Line_s> getLines()
    {
            if(Lines==null)
            {
                 Lines=new List<Line_s>();
                 
                 List<Quote_Item_Line__c> lineas_items = Database.query('select Id'+NEU_CurrencyUtils.CurrencyIsoCode()+',Imp_Exp_Fees_assigned__c,Duty__c,Name, Import_Export_Quote__c, Unit_Destination_Price__c,Unit_Destination_Buy_Price__c, Units__c , Total_Destination_Amount__c, Consolidated__c , Margin_at_Destination__c, Unit_Origin_Buy_Price__c, Import_Export_Quote__r.Name, Delivery_Number__c, Delivery_Date__c, Item_Name__r.Name, Extension_Item_Name__c,  Origin_Buy_Amount__c from Quote_Item_Line__c where Import_Export_Quote__c =\''+record.Id+'\'');
     
                 for(Quote_Item_Line__c qil: lineas_items)
                 {
                     Lines.add(new Line_s(qil, NEU_Utils.safeDecimal(qil.Unit_Destination_Price__c), NEU_Utils.safeDecimal(qil.Margin_at_Destination__c) , NEU_Utils.safeDecimal(qil.Unit_Destination_Price__c), NEU_Utils.safeDecimal(qil.Total_Destination_Amount__c),NEU_Utils.safeDecimal(qil.Unit_Destination_Buy_Price__c),  NEU_CurrencyUtils.getCurrencyIsoCode(qil), NEU_Utils.safeDecimal(qil.Unit_Destination_Price__c)));
                 }
                 
            }
            return Lines;
    }
}