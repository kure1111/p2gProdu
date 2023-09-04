trigger NEU_Quote_Item_Line_copy on Quote_Item_Line__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id>itemids=new Set<Id>();
    Set<Id>linesids = new Set<Id>();
    Set<Id>contIds = new Set<Id>();

    for(Quote_Item_Line__c line:trigger.new)
    {
        if(line.Container_Type__c != null)
        {
            contIds.add(line.Container_Type__c);
        }

        Quote_Item_Line__c oldline=null;
       if(trigger.oldMap!=null)
         oldline=trigger.oldMap.get(line.Id);
         
       
         
       if(oldline!=null)
       {
         if(oldline.Total_Shipping_Volume_m3__c == line.Total_Shipping_Volume_m3__c)
         {
             if(line.Supplier_Quote_Line__c != null)
                 linesids.add(line.Supplier_Quote_Line__c);
              else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
         } 
           
         if(oldline.Total_Shipping_Weight_Kgs__c == line.Total_Shipping_Weight_Kgs__c)
         {
             if(line.Supplier_Quote_Line__c != null)
               linesids.add(line.Supplier_Quote_Line__c);
             else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
         }  
             
            
       }
      else
       {
           if(NEU_Utils.safeDecimal(line.Total_Shipping_Volume_m3__c )==0)
           {
            if(line.Supplier_Quote_Line__c != null)
                linesids.add(line.Supplier_Quote_Line__c);
            else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
          }
          
           if(NEU_Utils.safeDecimal(line.Total_Shipping_Weight_Kgs__c)==0)
           {
            if(line.Supplier_Quote_Line__c != null)
                linesids.add(line.Supplier_Quote_Line__c);
            else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
          }
          
       }
       if(line.Unit_Origin_Buy_Price__c == null) 
            if(line.Supplier_Quote_Line__c != null)
                linesids.add(line.Supplier_Quote_Line__c);

        
    }
    
     if(linesids.size()>0)
    {
        NEU_CurrencyUtils currencyUtils=new NEU_CurrencyUtils();
        String lista_lineas_id = '';
        for(String s : linesids)
        {
            lista_lineas_id += '\''+s+'\''+',';
        }
        string query_string_supplier_quote_line = '';
        query_string_supplier_quote_line  += 'select Id,Supplier_Total_Weight_kg__c,Supplier_Total_Volume_m3__c,Unit_Origin_Price__c,Total_Weight_Kg__c,Total_Volume_m3__c ';
        if(UserInfo.isMultiCurrencyOrganization()== true)
            query_string_supplier_quote_line  +=',CurrencyIsoCode';     
        query_string_supplier_quote_line  +=' from Supplier_Quote_Line__c where id IN ('+lista_lineas_id.subString(0,lista_lineas_id.length()-1)+')';
        List<sObject> query_supplier_quote_line = Database.query(query_string_supplier_quote_line);
        List<Supplier_Quote_Line__c> list_sup_quote_line = query_supplier_quote_line;
        Map<Id,Supplier_Quote_Line__c>sqls=new Map<Id,Supplier_Quote_Line__c>(list_sup_quote_line );
        
        for(Quote_Item_Line__c line:trigger.new)
        {
               if(line.Supplier_Quote_Line__c !=null)
                 {
                     Supplier_Quote_Line__c  sql=sqls.get(line.Supplier_Quote_Line__c);
                     if(sql != null)
                     {
                        if(trigger.isUpdate)
                        {
                             Quote_Item_Line__c oldline=trigger.oldMap.get(line.Id);
                             if(oldline.Total_Shipping_Weight_Kgs__c == line.Total_Shipping_Weight_Kgs__c)
                                if(NEU_Utils.safeDecimal(sql.Total_Weight_Kg__c)!=0 && NEU_Utils.safeDecimal(line.Total_Shipping_Weight_Kgs__c) == 0)  
                                     line.Total_Shipping_Weight_Kgs__c = sql.Total_Weight_Kg__c; 
                             if(oldline.Total_Shipping_Volume_m3__c == line.Total_Shipping_Volume_m3__c)
                                if(NEU_Utils.safeDecimal(sql.Total_Volume_m3__c)!=0 && NEU_Utils.safeDecimal(line.Total_Shipping_Volume_m3__c)==0)  
                                     line.Total_Shipping_Volume_m3__c=sql.Total_Volume_m3__c;  
                        }
                        else
                        {
                             if(NEU_Utils.safeDecimal(sql.Total_Weight_Kg__c)!=0 && NEU_Utils.safeDecimal(line.Total_Shipping_Weight_Kgs__c) == 0)  
                                     line.Total_Shipping_Weight_Kgs__c = sql.Total_Weight_Kg__c; 
                             if(NEU_Utils.safeDecimal(sql.Total_Volume_m3__c)!=0 && NEU_Utils.safeDecimal(line.Total_Shipping_Volume_m3__c)==0)  
                                     line.Total_Shipping_Volume_m3__c=sql.Total_Volume_m3__c;  
                        }             
                        if(line.Unit_Origin_Buy_Price__c == null && NEU_Utils.safeDecimal(sql.Unit_Origin_Price__c)!=0)                
                            line.Unit_Origin_Buy_Price__c = currencyUtils.changeCurrency(sql.Unit_Origin_Price__c, NEU_CurrencyUtils.getCurrencyIsoCode(sql), NEU_CurrencyUtils.getCurrencyIsoCode(line)).setScale(4);
                     }
                }
        }
    }
    
    if(itemids.size()>0)
    {
      Map<Id,Sourcing_Item__c>items=new Map<Id,Sourcing_Item__c>([select Id,Master_Box_Gross_Weight_kg__c,Units_x_Master_Box__c,Weight_Kgs__c, Master_Box_Volume_m3__c from Sourcing_Item__c where Id IN:itemids]);
        for(Quote_Item_Line__c line:trigger.new)
        {
            
             if(NEU_Utils.safeDecimal(line.Total_Shipping_Volume_m3__c)==0)
                  if(line.Item_Name__c!=null)
                   {
                     Sourcing_Item__c item=items.get(line.Item_Name__c);
                     if(item != null)
                     {
                         Decimal itemvolume;
                      
                          
                         if(NEU_Utils.safeDecimal(item.Master_Box_Volume_m3__c)!=0 &&(NEU_Utils.safeDecimal(item.Units_x_Master_Box__c)!=0))  
                           itemvolume = item.Master_Box_Volume_m3__c/item.Units_x_Master_Box__c;
                           
                         if(NEU_Utils.safeDecimal(itemvolume)!=0)
                           line.Total_Shipping_Volume_m3__c=NEU_Utils.safeDecimal(line.Units__c)*itemvolume;
                     }
                   }
                   
                   
                if(NEU_Utils.safeDecimal(line.Total_Shipping_Weight_Kgs__c )==0)
                      if(line.Item_Name__c!=null)  
                      {
                          Sourcing_Item__c item=items.get(line.Item_Name__c);
                          if(item != null)
                          {
                              Decimal itemweight;
                              
                             if((NEU_Utils.safeDecimal(item.Master_Box_Gross_Weight_kg__c)!=0)&&(NEU_Utils.safeDecimal(item.Units_x_Master_Box__c)!=0))
                               itemweight=item.Master_Box_Gross_Weight_kg__c/item.Units_x_Master_Box__c;
                             else
                               itemweight=item.Weight_Kgs__c;
                          
                              if(NEU_Utils.safeDecimal(itemweight)!=0)
                               line.Total_Shipping_Weight_Kgs__c =NEU_Utils.safeDecimal(line.Units__c)*itemweight;
                          }
                      }
                         
                   
        }
    }

    if(contIds.size() > 0)
    {
        Map<Id,Container_Type__c>containers=new Map<Id,Container_Type__c>([SELECT Id, TEUS__c FROM Container_Type__c WHERE Id IN: contIds]);
        for(Quote_Item_Line__c line:trigger.new)
        {
            if(line.Container_Type__c != null) {
                Container_Type__c contain=containers.get(line.Container_Type__c);
                line.TEUS__c = contain.TEUS__c;
            }
        }
    }
    
}