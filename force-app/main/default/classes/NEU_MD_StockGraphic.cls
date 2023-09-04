public with sharing class NEU_MD_StockGraphic 
{
    public Sourcing_Item__c record;
    
    //GRÁFICO
    public List<Data> datos_grafico {get;set;}

    public class Data 
    {
        public String Periods {get;set;}
        public Decimal Units {get;set;}
        public Decimal AVG {get;set;}
        public Decimal AVG_with_Safety_Stock {get;set;}
        public Decimal AVG_Units_x_Order {get;set;}
        public Decimal AVG_without_Safety_Stock {get;set;}
        public Decimal Max_Units_x_Order {get;set;}
        public Decimal Reorder_Level {get;set;}
        public Data(String Periods, Decimal Units, Decimal AVG, Decimal AVG_with_Safety_Stock, Decimal AVG_without_Safety_Stock, Decimal AVG_Units_x_Order, Decimal Max_Units_x_Order, Decimal Reorder_Level) 
        {
            this.Periods = Periods;
            this.Units = Units;
            this.AVG = AVG;
            this.AVG_with_Safety_Stock = AVG_with_Safety_Stock;            
            this.AVG_without_Safety_Stock = AVG_without_Safety_Stock;
            this.AVG_Units_x_Order = AVG_Units_x_Order;
            this.Max_Units_x_Order = Max_Units_x_Order;
            this.Reorder_Level = Reorder_Level;
        }
    }
    
    ApexPages.StandardController con;
    
    public NEU_MD_StockGraphic(ApexPages.StandardController stdController) 
    {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Safety_Stock_Formula__c, Safety_Stock_Manual__c, Reorder_Level__c from Sourcing_Item__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Sourcing_Item__c();
        }
        
        List<Item_Historical_Data__c> item_historical_data = [select Id, Name, Item_Name__c, AVG__c, Units__c, Units_x_Weight__c, Use_for_Statistics__c, AVG_Units_Order__c, Max_Units_Order__c from Item_Historical_Data__c where Item_Name__c =: record.Id and Use_for_Statistics__c = true];
        
        List<Data> datos = new List<Data>();
        
        for(Item_Historical_Data__c ihd : item_historical_data)
        {
            datos.add(new Data(ihd.Name, ihd.Units__c, ihd.AVG__c, ihd.AVG__c + (record.Safety_Stock_Formula__c > 0 ? record.Safety_Stock_Formula__c : (record.Safety_Stock_Manual__c > 0 ? record.Safety_Stock_Manual__c : 0)), ihd.AVG__c - (record.Safety_Stock_Formula__c > 0 ? record.Safety_Stock_Formula__c : (record.Safety_Stock_Manual__c > 0 ? record.Safety_Stock_Manual__c : 0)), (ihd.AVG_Units_Order__c != null ? ihd.AVG_Units_Order__c : 0), (ihd.Max_Units_Order__c != null ? ihd.Max_Units_Order__c : 0), record.Reorder_Level__c));
        }
        
        datos_grafico = datos;
    }
}