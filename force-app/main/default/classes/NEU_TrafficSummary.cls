public with sharing class NEU_TrafficSummary 
{
	public Traffic__c record;
	public Integer current_year {get;set;}
	public Integer last_year {get;set;}

	//GRAFICO 1
    public List<Data_1> datos_grafico_1 {get;set;}
    public class Data_1 
    {
        public String MONTH {get;set;}
        public Decimal REVENUE_OP {get;set;}
        public Decimal PROFIT_OP {get;set;}
        public Decimal REVENUE_PROYECTION {get;set;}
        public Decimal PROFIT_PROYECTION {get;set;}
        public Decimal REVENUE_OC {get;set;}
        public Decimal PROFIT_OC {get;set;}
        public Data_1(String MONTH, Decimal REVENUE_OP, Decimal PROFIT_OP, Decimal REVENUE_PROYECTION, Decimal PROFIT_PROYECTION, Decimal REVENUE_OC, Decimal PROFIT_OC) 
        {
            this.MONTH = MONTH;
            this.REVENUE_OP = REVENUE_OP;
            this.PROFIT_OP = PROFIT_OP;
            this.REVENUE_PROYECTION = REVENUE_PROYECTION;
            this.PROFIT_PROYECTION = PROFIT_PROYECTION;
            this.REVENUE_OC = REVENUE_OC;
            this.PROFIT_OC = PROFIT_OC;
        }
    }
    
    //GRAFICO 2
    public List<Data_2> datos_grafico_2 {get;set;}
    public class Data_2 
    {
        public String MONTH {get;set;}
        public Decimal REVENUE_OP {get;set;}
        public Decimal PROFIT_OP {get;set;}
        public Decimal REVENUE_PROYECTION {get;set;}
        public Decimal PROFIT_PROYECTION {get;set;}
        public Decimal REVENUE_OC {get;set;}
        public Decimal PROFIT_OC {get;set;}
        public Data_2(String MONTH, Decimal REVENUE_OP, Decimal PROFIT_OP, Decimal REVENUE_PROYECTION, Decimal PROFIT_PROYECTION, Decimal REVENUE_OC, Decimal PROFIT_OC) 
        {
            this.MONTH = MONTH;
            this.REVENUE_OP = REVENUE_OP;
            this.PROFIT_OP = PROFIT_OP;
            this.REVENUE_PROYECTION = REVENUE_PROYECTION;
            this.PROFIT_PROYECTION = PROFIT_PROYECTION;
            this.REVENUE_OC = REVENUE_OC;
            this.PROFIT_OC = PROFIT_OC;
        }
    }
    
    ApexPages.StandardController con;
	
	public NEU_TrafficSummary(ApexPages.StandardController stdController) 
	{
   		con = stdController;

		try 
		{ 
			record = [select Id, Name, Revenue_Proyection__c, Profit_Proyection__c, Account__c, CurrencyIsoCode 
			from Traffic__c where id = :con.getRecord().id];
		} 
		catch(Exception ee){record = new Traffic__c();}
		
		current_year = system.today().year();
		last_year = system.today().year()-1;
		
		current_year();
		last_year();
	}
	
	public void current_year()
	{
		List<Data_1> datos_1 = new List<Data_1>();
		
		List<Customer_Quote__c> quotes = [select Id, Name, Order_in_Progress_Date__c, Order_Closed_Date__c, Total_Services_Sell_Amount__c, Services_Profit__c,
		Quotation_Status__c, CurrencyIsoCode, Conversion_Rate_Date__c
		from Customer_Quote__c where Account_for__c =: record.Account__c
		and RecordType.Name = 'Import-Export Order'
		and Traffic__c =: record.Id
		and (Quotation_Status__c =: 'Approved as Succesful' or Quotation_Status__c =: 'Partially Shipped' or Quotation_Status__c =: 'Shipped' or
		Quotation_Status__c =: 'Delivered' or Quotation_Status__c =: 'Closed') 
		and (CALENDAR_YEAR(Order_in_Progress_Date__c) =: system.today().year()
		or CALENDAR_YEAR(Order_Closed_Date__c) =: system.today().year())];
		
		Decimal revenue_proyection = (record.Revenue_Proyection__c != null ? record.Revenue_Proyection__c / 12 : 0);
		Decimal profit_proyection = (record.Profit_Proyection__c != null ? record.Profit_Proyection__c / 12 : 0);
		
		Decimal[] revenue_op = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		Decimal[] profit_op = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		Decimal[] revenue_oc = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		Decimal[] profit_oc = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		
		for(Customer_Quote__c q : quotes)
		{
			decimal total_revenue_op = (q.Total_Services_Sell_Amount__c != null ? q.Total_Services_Sell_Amount__c : 0);
        	decimal total_profit_op = (q.Services_Profit__c != null ? q.Services_Profit__c : 0);
        	decimal total_revenue_oc = (q.Total_Services_Sell_Amount__c != null ? q.Total_Services_Sell_Amount__c : 0);
        	decimal total_profit_oc = (q.Services_Profit__c != null ? q.Services_Profit__c : 0);
        	
        	date minDate=null;
        	date maxDate=null;
        	
        	date current = q.Conversion_Rate_Date__c;
			if(minDate == null || minDate > current)
				minDate = current;
			if(maxDate == null || maxDate < current)
				maxDate = current;
	        
	        if(record.CurrencyIsoCode != q.CurrencyIsoCode)
        	{
	        	List<DatedConversionRate> conversion = [select ConversionRate, IsoCode, startDate, nextstartdate from DatedConversionRate where startDate <=: maxDate and nextstartdate >: minDate];
	        	for(DatedConversionRate c : conversion)
	        	{
	        		if(c.startDate <= q.Conversion_Rate_Date__c && c.nextstartdate > q.Conversion_Rate_Date__c)
	        		{
		        		if(c.IsoCode == record.CurrencyIsoCode)
		        		{
				        	total_revenue_op = total_revenue_op * c.ConversionRate;
				        	total_profit_op = total_profit_op * c.ConversionRate;
				        	total_revenue_oc = total_revenue_oc * c.ConversionRate;
				        	total_profit_oc = total_profit_oc * c.ConversionRate;
		        		}
						else if(c.IsoCode == q.CurrencyIsoCode)
						{
				        	total_revenue_op = total_revenue_op / c.ConversionRate;
				        	total_profit_op = total_profit_op / c.ConversionRate;
				        	total_revenue_oc = total_revenue_oc / c.ConversionRate;
				        	total_profit_oc = total_profit_oc / c.ConversionRate;
						}
	        		}
	        	}
        	}	
			
			if(q.Quotation_Status__c == 'Approved as Succesful' || q.Quotation_Status__c == 'Partially Shipped' || q.Quotation_Status__c == 'Shipped'  || q.Quotation_Status__c == 'Delivered')
			{
				revenue_op[q.Order_in_Progress_Date__c.month()-1] += total_revenue_op;
				profit_op[q.Order_in_Progress_Date__c.month()-1] += total_profit_op;
			}
			if(q.Quotation_Status__c == 'Closed')
			{
				revenue_oc[q.Order_Closed_Date__c.month()-1] += total_revenue_oc;
				profit_oc[q.Order_Closed_Date__c.month()-1] += total_profit_oc;
			}
		}

		Decimal revenue_op_sum = 0;
		Decimal profit_op_sum = 0;
		Decimal revenue_proyection_sum = 0;
		Decimal profit_proyection_sum = 0;
		Decimal revenue_oc_sum = 0;
		Decimal profit_oc_sum = 0;
		
		revenue_op_sum += revenue_op[0];
		profit_op_sum += profit_op[0];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[0];
		profit_oc_sum += profit_oc[0];
		datos_1.add(new Data_1('January', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[1];
		profit_op_sum += profit_op[1];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[1];
		profit_oc_sum += profit_oc[1];
		datos_1.add(new Data_1('February', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[2];
		profit_op_sum += profit_op[2];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[2];
		profit_oc_sum += profit_oc[2];
		datos_1.add(new Data_1('March', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[3];
		profit_op_sum += profit_op[3];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[3];
		profit_oc_sum += profit_oc[3];
		datos_1.add(new Data_1('April', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[4];
		profit_op_sum += profit_op[4];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[4];
		profit_oc_sum += profit_oc[4];
		datos_1.add(new Data_1('May', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[5];
		profit_op_sum += profit_op[5];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[5];
		profit_oc_sum += profit_oc[5];
		datos_1.add(new Data_1('June', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[6];
		profit_op_sum += profit_op[6];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[6];
		profit_oc_sum += profit_oc[6];
		datos_1.add(new Data_1('July', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[7];
		profit_op_sum += profit_op[7];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[7];
		profit_oc_sum += profit_oc[7];
		datos_1.add(new Data_1('August', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[8];
		profit_op_sum += profit_op[8];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[8];
		profit_oc_sum += profit_oc[8];
		datos_1.add(new Data_1('September', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[9];
		profit_op_sum += profit_op[9];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[9];
		profit_oc_sum += profit_oc[9];
		datos_1.add(new Data_1('October', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[10];
		profit_op_sum += profit_op[10];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[10];
		profit_oc_sum += profit_oc[10];
		datos_1.add(new Data_1('November', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[11];
		profit_op_sum += profit_op[11];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[11];
		profit_oc_sum += profit_oc[11];
		datos_1.add(new Data_1('December', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		datos_grafico_1 = datos_1;
	}
	
	public void last_year()
	{
		List<Data_2> datos_2 = new List<Data_2>();
		
		List<Customer_Quote__c> quotes = [select Id, Name, Order_in_Progress_Date__c, Order_Closed_Date__c, Total_Services_Sell_Amount__c, Services_Profit__c,
		Quotation_Status__c, CurrencyIsoCode, Conversion_Rate_Date__c 
		from Customer_Quote__c where Account_for__c =: record.Account__c
		and RecordType.Name = 'Import-Export Order'
		and Traffic__c =: record.Id
		and (Quotation_Status__c =: 'Approved as Succesful' or Quotation_Status__c =: 'Partially Shipped' or Quotation_Status__c =: 'Shipped' or
		Quotation_Status__c =: 'Delivered' or Quotation_Status__c =: 'Closed') 
		and (CALENDAR_YEAR(Order_in_Progress_Date__c) =: system.today().year()-1
		or CALENDAR_YEAR(Order_Closed_Date__c) =: system.today().year()-1)];
		
		Decimal revenue_proyection = (record.Revenue_Proyection__c != null ? record.Revenue_Proyection__c / 12 : 0);
		Decimal profit_proyection = (record.Profit_Proyection__c != null ? record.Profit_Proyection__c / 12 : 0);
		
		Decimal[] revenue_op = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		Decimal[] profit_op = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		Decimal[] revenue_oc = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		Decimal[] profit_oc = new Decimal[]{0,0,0,0,0,0,0,0,0,0,0,0};
		
		for(Customer_Quote__c q : quotes)
		{
			decimal total_revenue_op = (q.Total_Services_Sell_Amount__c != null ? q.Total_Services_Sell_Amount__c : 0);
        	decimal total_profit_op = (q.Services_Profit__c != null ? q.Services_Profit__c : 0);
        	decimal total_revenue_oc = (q.Total_Services_Sell_Amount__c != null ? q.Total_Services_Sell_Amount__c : 0);
        	decimal total_profit_oc = (q.Services_Profit__c != null ? q.Services_Profit__c : 0);
        	
        	date minDate=null;
        	date maxDate=null;
        	
        	date current = q.Conversion_Rate_Date__c;
			if(minDate == null || minDate > current)
				minDate = current;
			if(maxDate == null || maxDate < current)
				maxDate = current;
	        
	        if(record.CurrencyIsoCode != q.CurrencyIsoCode)
        	{
	        	List<DatedConversionRate> conversion = [select ConversionRate, IsoCode, startDate, nextstartdate from DatedConversionRate where startDate <=: maxDate and nextstartdate >: minDate];
	        	for(DatedConversionRate c : conversion)
	        	{
	        		if(c.startDate <= q.Conversion_Rate_Date__c && c.nextstartdate > q.Conversion_Rate_Date__c)
	        		{
		        		if(c.IsoCode == record.CurrencyIsoCode)
		        		{
				        	total_revenue_op = total_revenue_op * c.ConversionRate;
				        	total_profit_op = total_profit_op * c.ConversionRate;
				        	total_revenue_oc = total_revenue_oc * c.ConversionRate;
				        	total_profit_oc = total_profit_oc * c.ConversionRate;
		        		}
						else if(c.IsoCode == q.CurrencyIsoCode)
						{
				        	total_revenue_op = total_revenue_op / c.ConversionRate;
				        	total_profit_op = total_profit_op / c.ConversionRate;
				        	total_revenue_oc = total_revenue_oc / c.ConversionRate;
				        	total_profit_oc = total_profit_oc / c.ConversionRate;
						}
	        		}
	        	}
        	}
			
			if(q.Quotation_Status__c == 'Approved as Succesful' || q.Quotation_Status__c == 'Partially Shipped' || q.Quotation_Status__c == 'Shipped'  || q.Quotation_Status__c == 'Delivered')
			{
				revenue_op[q.Order_in_Progress_Date__c.month()-1] += (q.Total_Services_Sell_Amount__c != null ? q.Total_Services_Sell_Amount__c : 0);
				profit_op[q.Order_in_Progress_Date__c.month()-1] += (q.Services_Profit__c != null ? q.Services_Profit__c : 0);
			}
			if(q.Quotation_Status__c == 'Closed')
			{
				revenue_oc[q.Order_Closed_Date__c.month()-1] += (q.Total_Services_Sell_Amount__c != null ? q.Total_Services_Sell_Amount__c : 0);
				profit_oc[q.Order_Closed_Date__c.month()-1] += (q.Services_Profit__c != null ? q.Services_Profit__c : 0);
			}
		}

		Decimal revenue_op_sum = 0;
		Decimal profit_op_sum = 0;
		Decimal revenue_proyection_sum = 0;
		Decimal profit_proyection_sum = 0;
		Decimal revenue_oc_sum = 0;
		Decimal profit_oc_sum = 0;
		
		revenue_op_sum += revenue_op[0];
		profit_op_sum += profit_op[0];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[0];
		profit_oc_sum += profit_oc[0];
		datos_2.add(new Data_2('January', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[1];
		profit_op_sum += profit_op[1];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[1];
		profit_oc_sum += profit_oc[1];
		datos_2.add(new Data_2('February', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[2];
		profit_op_sum += profit_op[2];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[2];
		profit_oc_sum += profit_oc[2];
		datos_2.add(new Data_2('March', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[3];
		profit_op_sum += profit_op[3];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[3];
		profit_oc_sum += profit_oc[3];
		datos_2.add(new Data_2('April', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[4];
		profit_op_sum += profit_op[4];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[4];
		profit_oc_sum += profit_oc[4];
		datos_2.add(new Data_2('May', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[5];
		profit_op_sum += profit_op[5];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[5];
		profit_oc_sum += profit_oc[5];
		datos_2.add(new Data_2('June', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[6];
		profit_op_sum += profit_op[6];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[6];
		profit_oc_sum += profit_oc[6];
		datos_2.add(new Data_2('July', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[7];
		profit_op_sum += profit_op[7];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[7];
		profit_oc_sum += profit_oc[7];
		datos_2.add(new Data_2('August', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[8];
		profit_op_sum += profit_op[8];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[8];
		profit_oc_sum += profit_oc[8];
		datos_2.add(new Data_2('September', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[9];
		profit_op_sum += profit_op[9];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[9];
		profit_oc_sum += profit_oc[9];
		datos_2.add(new Data_2('October', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[10];
		profit_op_sum += profit_op[10];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[10];
		profit_oc_sum += profit_oc[10];
		datos_2.add(new Data_2('November', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		revenue_op_sum += revenue_op[11];
		profit_op_sum += profit_op[11];
		revenue_proyection_sum += revenue_proyection;
		profit_proyection_sum += profit_proyection;	
		revenue_oc_sum += revenue_oc[11];
		profit_oc_sum += profit_oc[11];
		datos_2.add(new Data_2('December', revenue_op_sum, profit_op_sum, revenue_proyection_sum.setScale(0), profit_proyection_sum.setScale(0), revenue_oc_sum, profit_oc_sum));
		
		datos_grafico_2 = datos_2;
	}
}