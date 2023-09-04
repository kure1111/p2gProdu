public with sharing class NEU_Shipment_Entry {

  private List<Line_s> Lines=null;
  public  List<Warehouse_s> Warehouse = null;
  public String idItem{get;set;}
  public List<Shipment_Line__c> listado_shipments_insert = null;
  public List<Shipment_Line__c> listado_shipments_update = null;
  public String idLineItem{get;set;}
  public String updidLineItem{get;set;}
  public String idLine{get;set;}
  public decimal totalunits{get;set;}
  public decimal pendingunits{get;set;}
  public boolean fullline{get;set;}
  public String nombreitem{get;set;}
  public String linea_modificada{get;set;}
  
  public String alertuser{get;set;}
  
    private ApexPages.StandardController con;
    public NEU_Shipment_Entry(ApexPages.StandardController stdController) 
    {
        if(!Test.isRunningTest()){stdController.AddFields(new String[]{'Id','Name'});}
        con=stdController;
    }

    public static String getCurrencyIsoCode(SObject someObject)
    {
        return UserInfo.isMultiCurrencyOrganization() ? (String) someObject.get('CurrencyIsoCode') : UserInfo.getDefaultCurrency();
    }
    
  public PageReference applyLines()
  {
    Integer counter=0;
    if(getLines()!=null)
      for (line_s lines:lines)
        if(lines.selected)
        {
          if(lines.units==0)
          {
              alertuser='There are lines without units.';
              return null;
          }
          counter=1;
        }
    if(counter==0)
    {
      alertuser='You must select one or more lines.';
      return null;
    }
    integer nombre_ship_conso_data = 0;
    List<Inventory_Entry__c> listadostockentrys = null;
    List<Warehouse_Storage_Bin__c> listawarehouse = null;
    List<Quote_Item_Line__c>ImpExpLineToUpdate=new  List<Quote_Item_Line__c>();
    
    String ItemId;
    
    if(Lines!=null)
    {
      Inventory_Exit__c shippick;
      Boolean selected=false;
      
      for (Line_s lines:getLines())
      {
        if(lines.getId()!=null )//change
        {
          selected=lines.selected; //remember selected to use in additional lines
          if(selected)
          {
            ItemId=lines.getItemId();//remember ItemId to use in additional lines
            if(!lines.isOK)
                splitShipmentLine(lines.getId(),lines.nounits);
            else if(!lines.shipment_line.Received__c)
            {
                lines.shipment_line.Received__c=true;
                if(listado_shipments_update  == null)
                    listado_shipments_update  = new List<Shipment_Line__c>();    
                listado_shipments_update.add(lines.shipment_line);
            }
            if(lines.shipment_line.Quote_Item_Line__c!=null)
                if(lines.shipment_line.Quote_Item_Line__r.Received__c!=true)
                {
                    lines.shipment_line.Quote_Item_Line__r.Received__c=true;
                    ImpExpLineToUpdate.add(lines.shipment_line.Quote_Item_Line__r);
                }
            
            if((lines.getItemType()==0)&&(lines.stockentry!=null))
            if((lines.stockentry.getStorage_Bin()!=null)&&(lines.units>=0))
            {
                  //trace
                  Inventory_Entry__c entry=new Inventory_Entry__c();
                  entry.Item__c=ItemId;
                  entry.Shipment_Item_Line__c=lines.shipment_line.Id;
                  entry.Warehouse_Storage_Bin__c=lines.stockentry.getStorage_Bin();
                  entry.Units_Entry__c=lines.units;
				  entry.Status__c=lines.entry.Status__c;
                  insert entry;
            }
          }
        }
        else if(selected) //additional lines
        {
          if((lines.getItemType()==0)&&(lines.stockentry!=null))
          if((lines.stockentry.getStorage_Bin()!=null)&&(lines.units>0))
          {
                Inventory_Entry__c entry=new Inventory_Entry__c();
                entry.Item__c=ItemId;
                entry.Shipment_Item_Line__c=lines.idPrincipal;
                entry.Warehouse_Storage_Bin__c=lines.stockentry.getStorage_Bin();
                entry.Units_Entry__c=lines.units;
                entry.Status__c=lines.entry.Status__c;
                insert entry;
          }
        }
      }
    }
    if(listado_shipments_insert != null && listado_shipments_insert.size()>0)
        insert listado_shipments_insert;
    if(listado_shipments_update  != null && listado_shipments_update .size()>0)
        update listado_shipments_update ;
    if(ImpExpLineToUpdate.size()>0)
        update ImpExpLineToUpdate;
    return con.cancel();
  }
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
  public PageReference cancelLines()
  {
    return con.cancel();
  }  
  public class Line_s
  {
      public Shipment_Line__c shipment_line {get; set;}
      public boolean selected {get; set;}
      public string extension {get; set;}
      public Decimal units{get;set;}
      public Decimal factor{get;set;}
      public Warehouse_Storage_Bin_s stockentry {get; set;}
      public Boolean isOK{get;set;}
      public string IdPrincipal{get;set;}
      public Decimal nounits{get;set;}
      public Boolean fullline{get;set;}
      public Inventory_Entry__c entry{get;set;}

     public String unitsSep
     {
      get
      {
        if(units!=null)
          return units.format();
        return null;
      }
      set
      {
        decimal myvalue=NEU_Utils.toDecimal(value);
        if(myvalue!=null)
          units=myvalue;
      }
    }
      
      public Decimal getFinalUnits()
      {
        if(shipment_line!=null)
        {
          if(shipment_line.Units_Shipped__c!=null)
            return shipment_line.Units_Shipped__c;
        }
        return 0;
      }
      public Decimal getFinalStock()
      {
        if(shipment_line!=null)
        {
          if(shipment_line.Item_Name__r!=null)
          	return 0;
            //return shipment_line.Item_Name__r.Stock__c;
        }
        return 0;
      }
      public String getId()
      {
        if(shipment_line!=null)
          return shipment_line.Id;
        return null;
      }
      
      public String getHeaderId()
      {
        if(shipment_line!=null)
          return shipment_line.Shipment__r.Id;
        return null;
      }

      public String getItemId()
      {
        if(shipment_line!=null)
        {
          if(shipment_line.Item_Name__r!=null)
            return shipment_line.Item_Name__r.Id;
        }
        return null;
      }
      public Integer getItemType()
      {
        String DeveloperName=getItemTypeString();
        if(DeveloperName=='SKU_Product')
          return 0;
        else if(DeveloperName=='Service')
          return 1;
        else if(DeveloperName=='Sourcing_Product')
          return 2;
        return 0;
      }
      private String getItemTypeString()
      {
        if(shipment_line!=null)
        {
          if(shipment_line.Item_Name__r!=null)
            return shipment_line.Item_Name__r.RecordType.DeveloperName;
        }
        return null;
      }
      public String getItemName()
      {
        if(shipment_line!=null)
        {
          if(shipment_line.Item_Name__r!=null)
            return shipment_line.Item_Name__r.Name;
        }
        return null;
      }
      public String getFamilyName()
      {
        if(shipment_line!=null)
        {
          if(shipment_line.Family__c!=null)
            return shipment_line.Family__r.Name;
        }
        return null;
      }
      public Line_s(Shipment_Line__c shipment_line, boolean selected, string extension,decimal units,Warehouse_Storage_Bin_s stockentry, string idPrincipal)
      {
        this.shipment_line=shipment_line;
        this.selected=selected;
        this.extension=extension;
        this.units=units;
        this.stockentry=stockentry;
        this.nounits=0;
        this.isOK=false;
        this.idPrincipal=idPrincipal;
        this.factor=0;
        this.fullline=false;
        this.entry=new Inventory_Entry__c();
		for(Schema.PicklistEntry pv:Inventory_Entry__c.Status__c.getDescribe().getPicklistValues())
		{
		    if(pv.isDefaultValue())
		    {
		        this.entry.Status__c=pv.getValue();
		        break;
		    }    
		}
      }
  }
  public List<Line_s> getLines()
  {    
    if(Lines==null)
    {
      Lines=new List<Line_s>();
          List<Shipment_Line__c> lineas_items =[select Id,Name,Family__r.Name,Item_Name__r.Id,Unit_Destination_Price__c,Destination_Amount__c,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name,Item_Name__r.Picking_Rule__c,Unit_Origin_Sell_Price__c,Units_Shipped__c,Shipment__r.Id,Received__c,Quote_Item_Line__c,Quote_Item_Line__r.Id,Quote_Item_Line__r.Received__c from Shipment_Line__c where Shipment__c=:con.getId() order by Name]; //Item_Name__r.Stock__c
          if(lineas_items !=null)
            for(Shipment_Line__c l:lineas_items)
              Lines.add(new Line_s(l,false,'',0,null,l.Id));
    }
        return Lines;
}
    
  public void newItemSelected()
  {
    if(String.isNotEmpty(idLine) || ApexPages.currentPage().getParameters().get('test') != null)
    {
      Boolean myLine=false;
      for(Integer counter=0;counter<Lines.size();counter++)
      {
        Line_s l=Lines.get(counter);
        if(l.getId()!=null)
        {
          if(l.getId()==idLine)
          {
            myLine=true;
            if((l.selected)&&(l.stockentry==null))
            {
	          	List<Warehouse_Storage_Bin_s> ss=privateStockEntries(l.getItemId());
	          	if(ss.size()>0)
	          	{
	              	l.stockentry=ss[0];
	                l.units=l.getFinalUnits();
	                l.isOK=true;
	                l.nounits=0;
	          	}
	            else
	            	l.selected=false;
            }
            else if((!l.selected)&&(l.stockentry!=null))
            {
              l.units=0;
              l.stockEntry=null;
            }
          }
          else if(myLine)
            break;
        }
      }
    }
  }
  private List<Warehouse_Storage_Bin_s> getstoragebin(String idItem)
  {
    List<Warehouse_Storage_Bin_s> WarehouseStorageBin=new List<Warehouse_Storage_Bin_s>();
        if(String.isNotEmpty(idItem))
        {
          List<Sourcing_Item__c>items=[select Picking_Rule__c,Sourcing_Family__c,Subfamily__c,ABC_Classification__c,RecordType.DeveloperName from Sourcing_Item__c where Id=:idItem];
          if(items.size()>0)
          {
            if(items[0].RecordType.DeveloperName!='SKU_Product')
            {
              WarehouseStorageBin.add(new Warehouse_Storage_Bin_s(null));
            }
            else
            {
                List<Warehouse_Storage_Bin__c> lines=null;
                
                if((items[0].ABC_Classification__c==null)&&(items[0].Sourcing_Family__c==null))
                  lines=[select Id,Warehouse__r.Name,Name,Type__c, ABC_Classification__c,Level_Z__c,Stack_Y__c,Row_X__c from Warehouse_Storage_Bin__c
                  order by ABC_Classification__c desc nulls first,
                  Family__c desc nulls first,
                  Subfamily__c desc nulls first,
                  Priority__c asc nulls last];
                  
                else if((items[0].ABC_Classification__c==null)&&(items[0].Sourcing_Family__c!=null)&&(items[0].Subfamily__c==null))
                  lines=[select Id,Warehouse__r.Name,Name,Type__c, ABC_Classification__c,Level_Z__c,Stack_Y__c,Row_X__c from Warehouse_Storage_Bin__c
                  where (Family__c=null or Family__c=:items[0].Sourcing_Family__c)
                  order by ABC_Classification__c desc nulls first,
                  Family__c desc nulls last,
                  Subfamily__c desc nulls first,
                  Priority__c asc nulls last];
  
                else if((items[0].ABC_Classification__c==null)&&(items[0].Sourcing_Family__c!=null)&&(items[0].Subfamily__c!=null))
                  lines=[select Id,Warehouse__r.Name,Name,Type__c, ABC_Classification__c,Level_Z__c,Stack_Y__c,Row_X__c from Warehouse_Storage_Bin__c
                  where (Family__c=null or Family__c=:items[0].Sourcing_Family__c)
                  and (Subfamily__c=null or Subfamily__c=:items[0].Subfamily__c)
                  order by ABC_Classification__c desc nulls first,
                  Family__c desc nulls last,
                  Subfamily__c desc nulls last,
                  Priority__c asc nulls last];
  
                else if((items[0].ABC_Classification__c!=null)&&(items[0].Sourcing_Family__c==null))
                  lines=[select Id,Warehouse__r.Name,Name,Type__c, ABC_Classification__c,Level_Z__c,Stack_Y__c,Row_X__c from Warehouse_Storage_Bin__c
                  where (ABC_Classification__c=null or ABC_Classification__c=:items[0].ABC_Classification__c)
                  order by ABC_Classification__c desc nulls last,
                  Family__c desc nulls first,
                  Subfamily__c desc nulls first,
                  Priority__c asc nulls last];
                  
                else if((items[0].ABC_Classification__c!=null)&&(items[0].Sourcing_Family__c!=null)&&(items[0].Subfamily__c==null))
                  lines=[select Id,Warehouse__r.Name,Name,Type__c, ABC_Classification__c,Level_Z__c,Stack_Y__c,Row_X__c from Warehouse_Storage_Bin__c
                  where (ABC_Classification__c=null or ABC_Classification__c=:items[0].ABC_Classification__c)
                  and (Family__c=null or Family__c=:items[0].Sourcing_Family__c)
                  order by ABC_Classification__c desc nulls last,
                  Family__c desc nulls last,
                  Subfamily__c desc nulls first,
                  Priority__c asc nulls last];
  
                else if((items[0].ABC_Classification__c!=null)&&(items[0].Sourcing_Family__c!=null)&&(items[0].Subfamily__c!=null))
                  lines=[select Id,Warehouse__r.Name,Name,Type__c, ABC_Classification__c,Level_Z__c,Stack_Y__c,Row_X__c from Warehouse_Storage_Bin__c
                  where (ABC_Classification__c=null or ABC_Classification__c=:items[0].ABC_Classification__c)
                  and (Family__c=null or Family__c=:items[0].Sourcing_Family__c)
                  and (Subfamily__c=null or Subfamily__c=:items[0].Subfamily__c)
                  order by ABC_Classification__c desc nulls last,
                  Family__c desc nulls last,
                  Subfamily__c desc nulls last,
                  Priority__c asc nulls last];
  
                if(lines!=null)
                  for(Warehouse_Storage_Bin__c l:lines)
                    WarehouseStorageBin.add(new Warehouse_Storage_Bin_s(l));
            }
          }
        }
        return WarehouseStorageBin;
  }
  
  private List<Warehouse_Storage_Bin_s> privateStockEntries(String myIdItem)
  {
    if(Warehouse==null)
      Warehouse=new List<Warehouse_s>();
    
    List<Warehouse_Storage_Bin_s>ret=null;
    
    if(String.isNotEmpty(myIdItem))
    {
      for(Warehouse_s myitem:Warehouse)
        if(myitem.iditem==myIdItem)
          ret=myitem.mylist;
      if(ret==null)
      {
        ret=getstoragebin(myIdItem);
        Warehouse_s myitem=new Warehouse_s();
        myitem.iditem=myIdItem;
        myitem.mylist=ret;
        Warehouse.add(myitem);
      }
    }
    else
      ret=new List<Warehouse_Storage_Bin_s>();
    return ret;
  }
  public void updateStockEntries()
  {
    List<Warehouse_Storage_Bin_s>ret=privateStockEntries(idItem);
    if((getLines()!=null)&&(ret!=null))
    {
      if(String.isNotEmpty(updidLineItem))
      {
        Line_s myLine=null;
        Integer counter=0;
        for(;counter<Lines.size();counter++)
        {
          Line_s l=Lines.get(counter);
          if(l.getId()!=null)
          {
            if(myLine!=null)
              break;
            if(l.getId()==updidLineItem)
              myLine=l;
          }
          if(myLine!=null)
          {
            if(l.stockentry!=null)
            {
              if(l.getId()!=null)
                l.stockEntry=null;
            }
            if(l.getId()!=null)
            {
              l.stockEntry=null;
              l.units=0;
            }
            else
            {
              Lines.remove(counter);
              counter--;
            }
          }
        }
        if(myLine!=null)
        {
          Line_s l=Lines.get(counter-1);
          decimal Units=l.getFinalUnits();
          Boolean firstLine=true;
          if(l.getItemType()!=0)
          {
            decimal myUnits=0;
            l.stockentry=null;
            if(ret.size()>0)
            {
              l.stockentry=ret[0];
              try{
                myUnits=ret[0].newUnits;
              }
              catch(Exception e){}
              if(myUnits>Units)
                myUnits=Units;
              if(myUnits<0)
                myUnits=0;
              Units-=myUnits;
            }
            l.units=myUnits;
            l.isOK=(Units==0);
            l.nounits=Units;
          }
          else
          {
            for(Warehouse_Storage_Bin_s s:ret)
            {
              if(Units==0)
                break;
              decimal myUnits=0;
              try{
                myUnits=s.newUnits;
              }
              catch(Exception e){}
              if(myUnits<=0)
                continue;
              decimal currentUnits;
                currentUnits=myUnits;
              if(currentUnits>Units)
                currentUnits=Units;
              Units=Units-currentUnits;
              if(firstLine)
              {
                firstLine=false;
                l.stockentry=s;
                l.units=currentUnits;
                l.fullline=fullline;
              }
              else
              {
                if(counter>=Lines.size())
                  Lines.add(new Line_s(null,false,null,currentUnits,s,updidLineItem));
                else
                  Lines.add(counter,new Line_s(null,false,null,currentUnits,s,updidLineItem));
                counter=counter+1;
              }
            }
            l.isOK=(Units==0);
            l.nounits=Units;
          }
          for(;counter<Lines.size();counter++)
          {
            l=Lines.get(counter);
            if(l.getId()!=null)
              break;
          }
        }
        linea_modificada = updidLineItem;
        updidLineItem=null;
      }
    }
  }
    public List<Warehouse_Storage_Bin_s> getStockEntries()
  {
    List<Warehouse_Storage_Bin_s>ret=privateStockEntries(idItem);
    if((getLines()!=null)&&(ret!=null))
    {
      if(String.isNotEmpty(idLineItem))
      {
	  	fullline=false;
        for(Warehouse_Storage_Bin_s mybin:ret)
        {
          mybin.units=0;
          mybin.newUnits=0;
        }
        Boolean myLine=false;
        for(Line_s line:Lines)
        {
          if(line.getId()!=null)
          {
            if(myLine)
              break;
            if(line.getId()==idLineItem)
              myLine=true;
          }
          if(myLine)
          {
          	if(line.fullline)
	      		fullline=true;
            if(line.stockentry!=null)
            {
              for(Warehouse_Storage_Bin_s mybin:ret)
              {
                if(mybin.getId()==line.stockentry.getId())
                {
                  mybin.units=line.units;
                  mybin.newUnits=line.units;
                }
              }
            }
          }
        }
        updidLineItem=idLineItem;
        idLineItem=null;
      }
    }
    return ret;
  }
  
  public class Warehouse_s
  {
    public List<Warehouse_Storage_Bin_s>mylist=null;
    public string iditem = '';
  }
  
  public class Warehouse_Storage_Bin_s
  {
    public Warehouse_Storage_Bin__c bin {get; set;}
    public Decimal units{get;set;}
    public Decimal newUnits{get;set;}
    
    public String unitsSep
    {
      get
      {
        if(units !=null)
          return units.format();
        return null;
      }
      set
      {
        units=NEU_Utils.toDecimal(value);
	      if(units==null)
    	  	units=0;
      }
    }
    
     public String newUnitsSep
        {
          get
          {
            if(newUnits !=null)
              return newUnits.format();
            return null;
          }
          set
          {
              newUnits=NEU_Utils.toDecimal(value);
              if(newUnits==null)
              	newUnits=0;
          }
        }
    

    public String getId()
    {
      if(bin!=null)
        return bin.Id;
      return null;
    }
      public Warehouse_Storage_Bin_s(Warehouse_Storage_Bin__c bin)
      {
        this.bin=bin;
        units=0;
        newunits=0;
      }
      public string getWharehouse_Id()
      {
        if(bin!=null)
          return bin.Warehouse__c;
        return null;
      }
      public string getWharehouse_Name()
      {
        if(bin!=null)
          return bin.Warehouse__r.Name;
        return null;
      }
      
      public string getStorage_Bin()
      {
        if(bin!=null)
          return bin.Id;
        return null;
      }
      public string getName()
      {
        string Name_Storage_Bin ='';
		if(bin != null)
        {
          Name_Storage_Bin = bin.Name;
          if(bin.Row_X__c != null)
          {
            Name_Storage_Bin += ' ('+bin.Row_X__c;
            if(bin.Stack_Y__c != null)
              Name_Storage_Bin += ','+bin.Stack_Y__c;
            if(bin.Level_Z__c != null)
              Name_Storage_Bin += ','+bin.Level_Z__c;
            Name_Storage_Bin += ')';
          }
        }
        return Name_Storage_Bin;
      }
  }
  private void splitShipmentLine(String lineid,decimal units)
  {
    String query='select Id,Name';
    Boolean firstField=true;
    decimal cantidad = 0;
    Map<String,Schema.SObjectField>objectFields=Shipment_Line__c.getSobjectType().getDescribe().fields.getMap();
    for(String s:objectFields.keySet())
    {
      if((s!='Id')&&(s!='Name'))
        query+=','+s;
    }
    query+=' from Shipment_Line__c where Id=\''+lineid+'\'';
    List<Shipment_Line__c>lines=database.query(query);
    if((units<0)||(units==null))
        units=0;
    else if(units>lines[0].Units_Shipped__c)
        units=lines[0].Units_Shipped__c;
    if(lines.size()>0)
    {
        Shipment_Line__c newline=lines[0].clone(false,true);//--revisar esto
        cantidad = lines[0].Units_Shipped__c;
        newline.Units_Shipped__c =  units;
        newLine.Shipping_Weight_Kg__c =  (NEU_Utils.safeDecimal(lines[0].Shipping_Weight_Kg__c) != 0 ? (lines[0].Shipping_Weight_Kg__c/cantidad)*( units) : 0);
        newLine.Shipping_Volume_m3__c = (NEU_Utils.safeDecimal(lines[0].Shipping_Volume_m3__c) != 0 ?  (lines[0].Shipping_Volume_m3__c/cantidad)*( units) : 0);
        newLine.Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/cantidad)*(units)  : 0);
        newLine.Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/cantidad)*(units) : 0);
        newLine.Percent_Duty__c = (NEU_Utils.safeDecimal(newLine.Duty__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Duty__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        newLine.Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/cantidad)*(units) : 0);
        newLine.Percent_Taxes__c = (NEU_Utils.safeDecimal(newLine.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Sales_Tax__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        newLine.Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/cantidad)*( units) : 0);
        if(listado_shipments_insert == null)
            listado_shipments_insert = new List<Shipment_Line__c>();
       listado_shipments_insert.add(newLine);
 
        lines[0].Shipping_Weight_Kg__c =  (NEU_Utils.safeDecimal(lines[0].Shipping_Weight_Kg__c) != 0 ? (lines[0].Shipping_Weight_Kg__c/cantidad)*(cantidad - units):0);
        lines[0].Shipping_Volume_m3__c = (NEU_Utils.safeDecimal(lines[0].Shipping_Volume_m3__c) != 0 ? (lines[0].Shipping_Volume_m3__c/cantidad)*(cantidad - units) : 0);
        lines[0].Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/cantidad)*(cantidad - units) : 0);
        lines[0].Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/cantidad)*(cantidad - units) : 0);
        lines[0].Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/cantidad)*(cantidad - units) : 0);
        lines[0].Percent_Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 && NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(lines[0].Duty__c)/NEU_Utils.safeDecimal(lines[0].Customs_Value__c)*100 : 0);
        lines[0].Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/cantidad)*(cantidad - units) : 0);
        lines[0].Percent_Taxes__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(lines[0].Sales_Tax__c)/NEU_Utils.safeDecimal(lines[0].Customs_Value__c)*100 : 0);
        lines[0].Units_Shipped__c = cantidad - units;    
        lines[0].Received__c = true;       
        if(listado_shipments_update  == null)
            listado_shipments_update  = new List<Shipment_Line__c>();    
        listado_shipments_update.add(lines[0]);
      
        lines.add(newline);
        //upsert lines;
    }
  }
 }