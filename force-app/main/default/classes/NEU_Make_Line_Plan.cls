public with sharing class NEU_Make_Line_Plan {
    public List<Data> graphData {
    	set
    	{
    		if(graphData!=value)
	    		graphData=value;
    	}
    	get
    	{
    		if(graphData==null)
    		{
		        graphData=new List<Data>();
		        Data d=new Data();
		        d.DName='Demand';
		        d.Demand=10;
		        graphData.add(d);
		        d=new Data();
		        d.DName='Demand Allocated';
		        d.Demand=0;
		        graphData.add(d);
			}
    		getprogram();
    		if(program==null)
    			return null;
    		return graphData;
    	}
    }
    public class Data
    {
        public String DName {get;set;}
        public Decimal Demand {get;set;}
    }
	
	public static Integer periods=12;
	
	private Company_Plan__c record;
	
	public Integer[] nperiods{
		get{
			if(nperiods==null)
			{
				nperiods=new Integer[periods];
				for(Integer f=0;f<periods;f++)
					nperiods[f]=f;
			}
			return nperiods;
		}
		set{
			nperiods=value;
		}
	}
	public List<SelectOption> years{
		get{
			if(years==null)
			{
				years=new List<SelectOption>();
				for(Integer y=Valid_From.year();y<=Valid_To.year();y++)
					years.add(new SelectOption(String.valueOf(y),String.valueOf(y)));
			}
			return years;
		}
		set{
			if(years!=value)
				years=value;			
		}
	}

	public Integer year{
		get{
			if(year==null)
			{
				year=Integer.valueOf(years[0].getValue());
			}
			return year;
		}
		set{
			if(year!=value)
			{
				year=value;
				headers=null;
				items=null;
				currentitem=null;
				currentsubfamily=null;
				currentfamily=null;
				program=null;
			}
		}
	}

	public String datatype{
		get{
			if(datatype==null)
				datatype='families';
			return datatype;
		}
		set{
			if(datatype!=value)
			{
				datatype=value;
				items=null;
				currentitem=null;
				currentsubfamily=null;
				currentfamily=null;
				program=null;
			}
		}
	}
	public String[]headers{
		get{
			if(headers==null)
			{
				headers=new String[periods];
				for(Integer f=0;f<periods;f++)
				{
					Datetime d=Datetime.newInstance(year,f+1,1);
					headers[f]=d.format('MMM yyyy');
				}
			}
			return headers;
		}
		set{headers=value;}
		}
		
	private Date Valid_From;
	private Date Valid_To;
	
	public NEU_Make_Line_Plan(ApexPages.StandardController stdController)
	{
		if (!Test.isRunningTest())
        	stdController.AddFields(new String[]{'Id','Name','Valid_From__c','Valid_To__c'});
        record=(Company_Plan__c)stdController.getRecord();
		if(record.Valid_From__c!=null)
	        Valid_From=record.Valid_From__c;
	    else
	    	Valid_From=Date.newInstance(Date.today().year(),1,1);
        Valid_To=record.Valid_To__c;
        if((Valid_To==null)||(Valid_To<Valid_From))
        	Valid_To=Date.newInstance(Valid_From.year(),12,31);
	}

	private Integer notConsolidatedNumber=0;

	private List<SelectOption> familyList=null;
	private List<string> selected = null;

	private List<Product_Family__c> families=null;

	private	List<Sourcing_Item_s> Items = null;

	public String id_supply_project{get; set;}
	
	private String familyname=null;
	
	public String currentItem{
		get{
			return currentItem;
		}
		set{
			if(value!=currentItem)
			{
				currentItem=value;
				program=null;
				currentItemName=null;
			}
		}
	}

	public String currentSubfamily{
		get{
			return currentSubfamily;
		}
		set{
			if(value!=currentSubfamily)
			{
				currentSubfamily=value;
				program=null;
				currentItemName=null;
			}
		}
	}

	public String currentFamily{
		get{
			return currentFamily;
		}
		set{
			if(value!=currentFamily)
			{
				currentFamily=value;
				program=null;
				currentItemName=null;
			}
		}
	}

	public String currentItemName{get;set;}

	private List<Production_Order__c> program=null;
	public List<Production_Order__c> getprogram()
	{
		if(program==null)
		{
		if(String.isNotEmpty(currentItem))
		{
			List<Sourcing_Item__c>i=[select Id,Name,Sourcing_Family__c,Subfamily__c from Sourcing_Item__c where Id=:currentItem];
			if(i.size()>0)
			{
				program=[select Labor_Program__r.Factory_Line__r.Id,Labor_Program__r.Factory_Line__r.Name,Id,Name,Labor_Program__r.Id,Labor_Program__r.Name,Labor_Program__r.Unconstrained_Capacity_Utilisation__c,Labor_Program__r.Constrained_Capacity_Utilisation__c,Output_Units__c,Demand_Allocation__c,Equivalent_Product_Item_Units__c,Product_Mix__c,Nominal_Speed_units_h__c,Value_Operating_Time__c,OEE__c,Loading_Time__c,Item__r.Subfamily__c from Production_Order__c where Item__c=:currentItem and Labor_Program__r.Company_Plan__c=:record.id and CALENDAR_YEAR(Labor_Program__r.Valid_From__c)=:year order by Output_Units__c desc];
				currentItemName=i[0].Name;
				graphData[0].Demand=0;
				graphData[1].Demand=0;
				for(Production_Order__c p:program)
				{
					if(((p.Demand_Allocation__c==null)||(p.Demand_Allocation__c==0))&&(p.Output_Units__c!=null)&&(p.Equivalent_Product_Item_Units__c!=null))
						p.Demand_Allocation__c=p.Output_Units__c/p.Equivalent_Product_Item_Units__c;
					if(p.Demand_Allocation__c!=null)
						graphData[1].Demand+=p.Demand_Allocation__c;
				}		
				List<Item_Program__c>m=[select Id,Factory_Line__c,OEE__c,Nominal_Speed_units_min__c from Item_Program__c where (Subfamily__c!=null and Subfamily__c=:i[0].Subfamily__c) or (Item__c!=null and Item__c=:currentitem)];
				List<Id>mid=new List<Id>();
				for(Item_Program__c m1:m)
					mid.add(m1.Factory_Line__c);
				List<Labor_Program__c> pre=[select Factory_Line__r.Id,Factory_Line__r.Name,Id,Name,Unconstrained_Capacity_Utilisation__c,Constrained_Capacity_Utilisation__c from Labor_Program__c where Factory_Line__c IN:mid and Company_Plan__c=:record.id and CALENDAR_YEAR(Valid_From__c)=:year order by Valid_From__c desc];
				for(Labor_Program__c p:pre)
				{
					boolean toAdd=true;
					for(Production_Order__c o:program)
						if(o.Labor_Program__c==p.Id)
						{
							toAdd=false;
							break;
						}
					if(!toAdd)
						continue;
					Production_Order__c myp=new Production_Order__c();
					myp.Item__c=currentItem;
					myp.Labor_Program__c=p.id;
					myp.Labor_Program__r=p;
					for(Item_Program__c m1:m)
						if(m1.Factory_Line__c==p.Factory_Line__c)
						{
							myp.Nominal_Speed__c=m1.Nominal_Speed_units_min__c;
							if(myp.Nominal_Speed__c==null)
								myp.Nominal_Speed__c=1;
							myp.OEE__c=m1.OEE__c;
							if(myp.OEE__c==null)
								myp.OEE__c=100;
						}
					program.add(myp);
				}
				for(Sourcing_Item_s s:getItems())
					if(s.item!=null)
						if(s.item.Id==currentItem)
						{
							graphData[0].Demand=s.Total;
							break;
						}
			}
		}
		else if(String.isNotEmpty(currentSubfamily))
		{
			List<Subfamily__c>i=[select Id,Name from Subfamily__c where Id=:currentSubfamily];
			if(i.size()>0)
			{
				program=new List<Production_Order__c>();
				currentItemName=i[0].Name;
				graphData[0].Demand=0;
				graphData[1].Demand=0;
				List<Production_Order__c> totalprogram=[select Labor_Program__r.Factory_Line__r.Id,Labor_Program__r.Factory_Line__r.Name,Labor_Program__r.Id,Labor_Program__r.Name,Labor_Program__r.Unconstrained_Capacity_Utilisation__c,Labor_Program__r.Constrained_Capacity_Utilisation__c,Demand_Allocation__c from Production_Order__c where Item__r.Subfamily__c=:currentSubfamily and Labor_Program__r.Company_Plan__c=:record.id and CALENDAR_YEAR(Labor_Program__r.Valid_From__c)=:year order by Output_Units__c desc];
				for(Production_Order__c t:totalprogram)
				{
					boolean toAdd=true;
					for(Production_Order__c p:program)
					{
						if(t.Labor_Program__c==p.Labor_Program__c)
						{
							if(t.Demand_Allocation__c!=null)
							{
								p.Demand_Allocation__c+=t.Demand_Allocation__c;
								graphData[1].Demand+=t.Demand_Allocation__c;
							}
							toAdd=false;
							break;
						}
					}
					if(!toAdd)
						continue;
					Production_Order__c p=new Production_Order__c();
					p.Labor_Program__c=t.Labor_Program__c;
					p.Labor_Program__r=t.Labor_Program__r;
					if(t.Demand_Allocation__c!=null)
					{
						p.Demand_Allocation__c=t.Demand_Allocation__c;
						graphData[1].Demand+=t.Demand_Allocation__c;
					}
					else
						p.Demand_Allocation__c=0;
					program.add(p);
				}
				for(Sourcing_Item_s s:getItems())
					if(s.subfamily!=null)
						if(s.subfamily.Id==currentSubfamily)
						{
							graphData[0].Demand=s.Total;
							break;
						}
			}
		}
		else if(String.isNotEmpty(currentFamily))
		{
			List<Product_Family__c>i=[select Id,Name from Product_Family__c where Id=:currentFamily];
			if(i.size()>0)
			{
				program=new List<Production_Order__c>();
				currentItemName=i[0].Name;
				graphData[0].Demand=0;
				graphData[1].Demand=0;
				List<Production_Order__c> totalprogram=[select Labor_Program__r.Factory_Line__r.Id,Labor_Program__r.Factory_Line__r.Name,Labor_Program__r.Id,Labor_Program__r.Name,Labor_Program__r.Unconstrained_Capacity_Utilisation__c,Labor_Program__r.Constrained_Capacity_Utilisation__c,Demand_Allocation__c from Production_Order__c where Item__r.Sourcing_Family__c=:currentFamily and Labor_Program__r.Company_Plan__c=:record.id and CALENDAR_YEAR(Labor_Program__r.Valid_From__c)=:year order by Output_Units__c desc];
				for(Production_Order__c t:totalprogram)
				{
					boolean toAdd=true;
					for(Production_Order__c p:program)
					{
						if(t.Labor_Program__c==p.Labor_Program__c)
						{
							if(t.Demand_Allocation__c!=null)
							{
								p.Demand_Allocation__c+=t.Demand_Allocation__c;
								graphData[1].Demand+=t.Demand_Allocation__c;
							}
							toAdd=false;
							break;
						}
					}
					if(!toAdd)
						continue;
					Production_Order__c p=new Production_Order__c();
					p.Labor_Program__c=t.Labor_Program__c;
					p.Labor_Program__r=t.Labor_Program__r;
					if(t.Demand_Allocation__c!=null)
					{
						p.Demand_Allocation__c=t.Demand_Allocation__c;
						graphData[1].Demand+=t.Demand_Allocation__c;
					}
					else
						p.Demand_Allocation__c=0;
					program.add(p);
				}
				for(Sourcing_Item_s s:getItems())
					if(s.family!=null)
						if(s.family.Id==currentFamily)
						{
							graphData[0].Demand=s.Total;
							break;
						}
			}
		}
		}
		return program;
	}	
	public class Demand_s
	{
		public Sourcing_Item__c item {get; set;}
		public Decimal oldDemand{get;set;}
		public Decimal newDemand{get;set;}
    	
    	public Demand_s(Sourcing_Item__c item)
		{
			this.item=item;
			this.oldDemand=0;
			this.newDemand=0;
		}
	}
	public void automaticPlan()
	{
		if(Valid_From.year()==year)
			return;
		Integer oldyear=year-1;
		Map<Id,Demand_s> demands=new Map<Id,Demand_s>();
		List<Item_Historical_Data__c>hlist=[select Id,Item_Name__c,Item_Name__r.Id,Units__c from Item_Historical_Data__c where Item_Name__r.Sourcing_Family__c IN: getfamilies() and CALENDAR_YEAR(From__c)=:oldyear ];
		for(Item_Historical_Data__c h:hlist)
		{
			Demand_s value=demands.get(h.Item_Name__c);
			if(value==null)
			{
				value=new Demand_s(h.Item_Name__r);
				demands.put(h.Item_Name__c,value);
			}
			value.olddemand+=h.Units__c;
		}
		hlist=[select Id,Item_Name__c,Item_Name__r.Id,Units__c from Item_Historical_Data__c where Item_Name__r.Sourcing_Family__c IN: getfamilies() and CALENDAR_YEAR(From__c)=:year ];
		for(Item_Historical_Data__c h:hlist)
		{
			Demand_s value=demands.get(h.Item_Name__c);
			if(value==null)
			{
				value=new Demand_s(h.Item_Name__r);
				demands.put(h.Item_Name__c,value);
			}
			value.newdemand+=h.Units__c;
		}
		Integer years=year-oldyear;
		String query='select Id,Name';
		Map<String,Schema.SObjectField>objectFields=Labor_Program__c.getSobjectType().getDescribe().fields.getMap();
		for(String s:objectFields.keySet())
		{
			if((s!='Id')&&(s!='Name'))
				query+=','+s;
		}
		query+=' from Labor_Program__c where Company_Plan__c=\''+record.id+'\' and CALENDAR_YEAR(Valid_From__c)='+String.valueOf(oldyear);
		List<Labor_Program__c>olds=database.query(query);
		List<Labor_Program__c> currents=[select Id,Factory_Line__c from Labor_Program__c where Company_Plan__c=:record.id and CALENDAR_YEAR(Valid_From__c)=:year];
		List<Labor_Program__c> news=new List<Labor_Program__c>();
		for(Labor_Program__c old:olds)
		{
			Boolean toAdd=true;
			for(Labor_Program__c current:currents)
			{
				if(old.Factory_Line__c==current.Factory_Line__c)
				{
					toAdd=false;
					break;
				}
			}
			if(toAdd)
			{
				Labor_Program__c l=old.clone(false,true);
				l.Valid_From__c=l.Valid_From__c.addYears(years); 
				l.Valid_To__c=l.Valid_To__c.addYears(years); 
				news.add(l);
			}
		}
		if(news.size()>0)
		{
			insert news;
			currents.addAll(news);
		}
		query='select Labor_Program__r.Factory_Line__c,Id,Name';
		objectFields=Production_Order__c.getSobjectType().getDescribe().fields.getMap();
		for(String s:objectFields.keySet())
		{
			if((s!='Id')&&(s!='Name'))
				query+=','+s;
		}
		query+=' from Production_Order__c where Labor_Program__r.Company_Plan__c=\''+record.id+'\' and CALENDAR_YEAR(Labor_Program__r.Valid_From__c)='+String.valueOf(oldyear);
		List<Production_Order__c>oldps=database.query(query);
		List<Production_Order__c>newps=[select Id,Output_Units__c,Demand_Allocation__c,Equivalent_Product_Item_Units__c,Labor_Program__r.Factory_Line__c,Item__c from Production_Order__c where Labor_Program__r.Company_Plan__c=:record.id  and CALENDAR_YEAR(Labor_Program__r.Valid_From__c)=:year];
		List<Production_Order__c>ptoupsert=new List<Production_Order__c>();
		for(Production_Order__c po:oldps)
		{
			Demand_s value=demands.get(po.Item__c);
			if(value==null)
				continue;
			if((value.olddemand==0)||(value.newdemand==0))
				continue;
			Production_Order__c p=null;
			for(Production_Order__c pn:newps)
			{
				if((po.Labor_Program__r.Factory_Line__c==pn.Labor_Program__r.Factory_Line__c)&&(po.Item__c==pn.Item__c))
				{
					p=pn;
					break;
				}
			}
			if(p==null)
			{
				Labor_Program__c cu=null;
				for(Labor_Program__c c:currents)
					if(c.Factory_Line__c==po.Labor_Program__r.Factory_Line__c)
					{
						p=po.clone(false,true);
						p.Labor_Program__c=c.Id;
						break;
					}
			}
			if(p!=null)
			{
				p.Demand_Allocation__c=((po.Demand_Allocation__c*value.newdemand)/value.olddemand).round();
				if((p.Equivalent_Product_Item_Units__c!=null))
					p.Output_Units__c=p.Demand_Allocation__c*p.Equivalent_Product_Item_Units__c;
				else
					p.Output_Units__c=p.Demand_Allocation__c;
				ptoupsert.add(p);
			}
		}
		if(ptoupsert.size()>0)
			upsert ptoupsert;
		program=null;
		Items=null;
	}
	public void updatePlan()
	{
		if(String.isEmpty(currentItem))
			return;
		List<Production_Order__c> toupdate=new List<Production_Order__c>();
		List<Production_Order__c> todelete=new List<Production_Order__c>();
		for(Production_Order__c p:getprogram())
			if((p.Demand_Allocation__c!=null)&&(p.Demand_Allocation__c!=0))
			{
				if(p.Equivalent_Product_Item_Units__c!=null)
					p.Output_Units__c=p.Demand_Allocation__c*p.Equivalent_Product_Item_Units__c;
				toupdate.add(p);
			}
			else if(p.Id!=null)
				todelete.add(p);
		if(toupdate.size()>0)
			upsert toupdate;
		if(todelete.size()>0)
			delete todelete;
		program=null;
		Items=null;
		toupdate=new List<Production_Order__c>();
		for(Production_Order__c p:getprogram())
			if((p.Demand_Allocation__c!=null)&&(p.Equivalent_Product_Item_Units__c!=null))
			{
				if(p.Output_Units__c!=p.Demand_Allocation__c*p.Equivalent_Product_Item_Units__c)
				{
					p.Output_Units__c=p.Demand_Allocation__c*p.Equivalent_Product_Item_Units__c;
					toupdate.add(p);
				}
			}
		if(toupdate.size()>0)
		{
			update toupdate;
			program=null;
			Items=null;
		}
	}
	public List<Product_Family__c>getfamilies()
	{
		if(families==null)
		{
			if(selected==null)
				families = new List<Product_Family__c>();
			else
				families = [select Id,Name from Product_Family__c where Id IN: selected];			
		}
		return families;
	}
	public String getfamilyname()
	{
		if(String.IsEmpty(familyname))
		{
			familyname=null;
			for(Product_Family__c a:getfamilies())
				if(familyname==null)
					familyname=a.Name;
				else
					familyname=familyname+', '+a.Name;
		}
		return familyname;
	}
	public void setfamilies(List<Product_Family__c>value)
	{
	}

	public List<string> getselected()
    {
    	return selected;
    }
   
    public void setselected(List<string> value)
    {
    	if(value!=selected)
    	{
   			selected=value;
   			families=null;
   			familyname=null;
    		Items=null;
			currentitem=null;
			currentsubfamily=null;
			currentfamily=null;
			program=null;
    	}
    }
    
 	public List<SelectOption> getfamilyList()
	{
		if(familyList==null)
		{
	        familyList = new List<SelectOption>();
			List<Product_Family__c> families=[select Id,Name from Product_Family__c order by Name];
			for(Product_Family__c a:families)
				familyList.add(new SelectOption(a.Id,a.Name));
		}
        return familyList;
    }
    
    public class Sourcing_Item_s
	{
		public Sourcing_Item__c item {get; set;}
		public Product_Family__c family{get;set;}
		public Subfamily__c subfamily{get;set;}
		public Integer[] Units{get;set;}
		public Integer Total{get;set;}
		public Integer Assigned{get;set;}
    	
    	public Sourcing_Item_s(Sourcing_Item__c item,Subfamily__c subfamily,Product_Family__c family)
		{
			this.Units=new Integer[NEU_Make_Line_Plan.periods];
			for(Integer f=0;f<NEU_Make_Line_Plan.periods;f++)
				this.Units[f]=0;
			this.Total=0;
			this.Assigned=0;
			this.item=item;
			if(item!=null)
			{
				this.family=item.Sourcing_Family__r;
				this.subfamily=item.Subfamily__r;
			}
			else if(subfamily!=null)
			{
				this.family=subfamily.Product_Family__r;
				this.subfamily=subfamily;
			}
			else
				this.family=family;
		}
 		
	}	
	
    public List<Sourcing_Item_s> getItems()
	{
		if(Items==null)
		{
			Items=new List<Sourcing_Item_s>();
			List<Sourcing_Item__c> listaintems = [select Id,Name,Sourcing_Family__r.Id,Sourcing_Family__r.Name,Subfamily__r.Id,Subfamily__r.Name,Subfamily__r.Product_Family__r.Id,Subfamily__r.Product_Family__r.Name from Sourcing_Item__c where Sourcing_Family__c IN :getfamilies() ];
			for(Sourcing_Item__c li : listaintems)
			{
				if(Items.size()>=500)
					break;
				Sourcing_Item_s l=null;
				if(datatype=='families')
				{
					for(Sourcing_Item_s i:Items)
						if(i.family!=null)
							if(i.family.Id==li.Sourcing_Family__r.Id)
							{
								l=i;
								break;
							}
				}
				else if(datatype=='subfamilies')
				{
					for(Sourcing_Item_s i:Items)
						if(i.subfamily!=null)
							if(i.subfamily.Id==li.Subfamily__r.Id)
							{
								l=i;
								break;
							}
				}
				if(l==null)
				{
					if(datatype=='families')
					{
						if(li.Sourcing_Family__r==null)
							continue;
						l=new Sourcing_Item_s(null,null,li.Sourcing_Family__r);
					}
					else if(datatype=='subfamilies')
					{
						if(li.Subfamily__r==null)
							continue;
						l=new Sourcing_Item_s(null,li.Subfamily__r,null);
					}
					else
						l=new Sourcing_Item_s(li,null,null);
					
					Items.add(l);
				}
			}
			List<Item_Historical_Data__c>hlist=[select Id,Item_Name__c,Item_Name__r.Sourcing_Family__c,Item_Name__r.Subfamily__c,Family__c,Subfamily__c,Subfamily__r.Product_Family__c,Units__c,From__c from Item_Historical_Data__c where (Family__c IN: getfamilies() OR Subfamily__r.Product_Family__c IN: getfamilies() OR Item_Name__r.Sourcing_Family__c IN: getfamilies()) and CALENDAR_YEAR(From__c)=:year ];
			for(Item_Historical_Data__c h:hlist)
			{
				Sourcing_Item_s myi=null;
				for(Sourcing_Item_s i:Items)
				{
					if(datatype=='families')
					{
						if(i.family!=null)
							if((i.family.id==h.Item_Name__r.Sourcing_Family__c)||(i.family.id==h.Subfamily__r.Product_Family__c)||(i.family.id==h.Family__c))
							{
								myi=i;
								break;
							}
					}
					else if(datatype=='subfamilies')
					{
						if(i.subfamily!=null)
							if((i.subfamily.id==h.Item_Name__r.Subfamily__c)||(i.subfamily.id==h.Subfamily__c))
							{
								myi=i;
								break;
							}
					}
					else
					{
						if(i.item!=null)
							if(i.item.id==h.Item_Name__c)
							{
								myi=i;
								break;
							}
					}
				}
				if(myi==null)
					continue;
				myi.Units[h.From__c.month()-1]+=Integer.valueOf(h.Units__c);
				myi.Total+=Integer.valueOf(h.Units__c);
			}
			List<Production_Order__c>plist=[select Id,Item__c,Item__r.Sourcing_Family__c,Item__r.Subfamily__c,Demand_Allocation__c,Equivalent_Product_Item_Units__c,Output_Units__c from Production_Order__c where (Item__r.Sourcing_Family__c IN: getfamilies() OR Item__r.Subfamily__r.Product_Family__c IN: getfamilies()) and Labor_Program__r.Company_Plan__c=:record.id and CALENDAR_YEAR(Labor_Program__r.Valid_From__c)=:year ];
			for(Production_Order__c p:plist)
			{
				Sourcing_Item_s myi=null;
				for(Sourcing_Item_s i:Items)
				{
					if(datatype=='families')
					{
						if(i.family!=null)
							if(i.family.id==p.Item__r.Sourcing_Family__c)
							{
								myi=i;
								break;
							}
					}
					else if(datatype=='subfamilies')
					{
						if(i.subfamily!=null)
							if(i.subfamily.id==p.Item__r.Subfamily__c)
							{
								myi=i;
								break;
							}
					}
					else
					{
						if(i.item!=null)
							if(i.item.id==p.Item__c)
							{
								myi=i;
								break;
							}
					}
				}
				if(myi==null)
					continue;
				if(((p.Demand_Allocation__c==null)||(p.Demand_Allocation__c==0))&&(p.Output_Units__c!=null)&&(p.Equivalent_Product_Item_Units__c!=null))
					p.Demand_Allocation__c=p.Output_Units__c/p.Equivalent_Product_Item_Units__c;
				if(p.Demand_Allocation__c!=null)
					myi.Assigned+=Integer.valueOf(p.Demand_Allocation__c);
			}
		}
		
        return Items;
	}
}