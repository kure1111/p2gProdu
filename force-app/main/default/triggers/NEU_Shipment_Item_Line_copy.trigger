trigger NEU_Shipment_Item_Line_copy on Shipment_Line__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id>itemids=new Set<Id>();
    Set<Id>linesids_ie = new Set<Id>();
    Set<Id>linesids_sqo = new Set<Id>();
    Set<Id>contIds = new Set<Id>();

    for(Shipment_Line__c line:Trigger.new)
    {
        if(line.Container_Type__c != null)
        {
            contIds.add(line.Container_Type__c);
        }

       Shipment_Line__c oldline=null;
       if(trigger.oldMap!=null)
         oldline=trigger.oldMap.get(line.Id);
         
       if(oldline!=null)
       {
         if(oldline.Shipping_Volume_m3__c == line.Shipping_Volume_m3__c)
         {
             if(line.Quote_Item_Line__c != null)
                 linesids_ie.add(line.Quote_Item_Line__c);
              else if(line.Supplier_Quote_Line__c != null)
                  linesids_sqo.add(line.Supplier_Quote_Line__c );
              else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
         }
             
         if(oldline.Shipping_Weight_Kg__c == line.Shipping_Weight_Kg__c)
         {
             if(line.Quote_Item_Line__c != null)
               linesids_ie.add(line.Quote_Item_Line__c );
             else if(line.Supplier_Quote_Line__c != null)
                  linesids_sqo.add(line.Supplier_Quote_Line__c );
             else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
          }   
          
           if(oldline.Units_Shipped__c == line.Units_Shipped__c   )
           {
             if(line.Quote_Item_Line__c != null)
               linesids_ie.add(line.Quote_Item_Line__c );
             else if(line.Supplier_Quote_Line__c != null)
                  linesids_sqo.add(line.Supplier_Quote_Line__c );
             else if(line.Item_Name__c!=null)
                itemids.add(line.Item_Name__c);
           }
               
           if(oldline.Unit_Origin_Sell_Price__c== line.Unit_Origin_Sell_Price__c)
           {
             if(line.Quote_Item_Line__c != null)
               linesids_ie.add(line.Quote_Item_Line__c );
             else if(line.Supplier_Quote_Line__c != null)
                  linesids_sqo.add(line.Supplier_Quote_Line__c );
           }
               //---------------------falta el de customer order  
                  
            if(oldline.Unit_Origin_Buy_Price__c== line.Unit_Origin_Buy_Price__c)//-----------?? solo viene de la import-export quote
               if(line.Quote_Item_Line__c != null)
                   linesids_ie.add(line.Quote_Item_Line__c );
               
                  
            
       }
       else
       {
           if(NEU_Utils.safeDecimal(line.Shipping_Volume_m3__c)==0)
           {
              if(line.Quote_Item_Line__c != null)
                  linesids_ie.add(line.Quote_Item_Line__c);
              else if(line.Supplier_Quote_Line__c != null)
                  linesids_sqo.add(line.Supplier_Quote_Line__c );
              else if(line.Item_Name__c!=null)
                  itemids.add(line.Item_Name__c);
          }
          
           if(NEU_Utils.safeDecimal(line.Shipping_Weight_Kg__c)==0)
           {
              if(line.Quote_Item_Line__c != null)
                 linesids_ie.add(line.Quote_Item_Line__c);
              else if(line.Supplier_Quote_Line__c != null)
                 linesids_sqo.add(line.Supplier_Quote_Line__c );
              else if(line.Item_Name__c!=null)
                 itemids.add(line.Item_Name__c);
          }
          
            if(NEU_Utils.safeDecimal(line.Units_Shipped__c)==0)
            {
             if(line.Quote_Item_Line__c != null)
               linesids_ie.add(line.Quote_Item_Line__c );
             else if(line.Supplier_Quote_Line__c != null)
                  linesids_sqo.add(line.Supplier_Quote_Line__c );
            }
            
             
             if(NEU_Utils.safeDecimal(line.Unit_Origin_Sell_Price__c)==0)
             {
                 if(line.Quote_Item_Line__c != null)
                   linesids_ie.add(line.Quote_Item_Line__c );
                 else if(line.Supplier_Quote_Line__c != null)
                      linesids_sqo.add(line.Supplier_Quote_Line__c );
             }
                  
              if(NEU_Utils.safeDecimal(line.Unit_Origin_Buy_Price__c)==0)//-----------?? solo viene de la import-export quote
               if(line.Quote_Item_Line__c != null)
                   linesids_ie.add(line.Quote_Item_Line__c );
          
       }   
    }
    
    
    
    if(itemids.size()>0)
    {
      Map<Id,Sourcing_Item__c>items=new Map<Id,Sourcing_Item__c>([select Id,Master_Box_Gross_Weight_kg__c,Units_x_Master_Box__c,Weight_Kgs__c, Master_Box_Volume_m3__c from Sourcing_Item__c where Id IN:itemids]);
        for(Shipment_Line__c line:trigger.new)
        {
             if(NEU_Utils.safeDecimal(line.Shipping_Volume_m3__c)==0)
                  if(line.Item_Name__c!=null)
                   {
                     Sourcing_Item__c item=items.get(line.Item_Name__c);
                     
                     Decimal itemvolume;
                  
                      
                     if(NEU_Utils.safeDecimal(item.Master_Box_Volume_m3__c)!=0 &&(NEU_Utils.safeDecimal(item.Units_x_Master_Box__c)!=0))  
                       itemvolume = item.Master_Box_Volume_m3__c/item.Units_x_Master_Box__c;
                       
                     if(NEU_Utils.safeDecimal(itemvolume)!=0)
                       line.Shipping_Volume_m3__c=NEU_Utils.safeDecimal(line.Units_Shipped__c)*itemvolume;
                   }
                   
                   
                if(NEU_Utils.safeDecimal(line.Shipping_Weight_Kg__c )==0)
                      if(line.Item_Name__c!=null)  
                      {
                          Sourcing_Item__c item=items.get(line.Item_Name__c);
                          Decimal itemweight;
                          
                         if((NEU_Utils.safeDecimal(item.Master_Box_Gross_Weight_kg__c)!=0)&&(NEU_Utils.safeDecimal(item.Units_x_Master_Box__c)!=0))
                           itemweight=item.Master_Box_Gross_Weight_kg__c/item.Units_x_Master_Box__c;
                         else
                           itemweight=item.Weight_Kgs__c;
                      
                          if(NEU_Utils.safeDecimal(itemweight)!=0)
                           line.Shipping_Weight_Kg__c =NEU_Utils.safeDecimal(line.Units_Shipped__c)*itemweight;
                      }
        }
    }
    
    
    if(linesids_sqo.size()>0)
    {
        Map<Id,Supplier_Quote_Line__c>sqls=new Map<Id,Supplier_Quote_Line__c>([select Id,Supplier_Total_Weight_kg__c,Supplier_Total_Volume_m3__c,Unit_Origin_Price__c,Total_Weight_Kg__c,Total_Volume_m3__c, Quantity__c, Net_Price__c, Expense_Amount__c from Supplier_Quote_Line__c where Id IN:linesids_sqo]);
        for(Shipment_Line__c line:trigger.new)
        {
             if(line.Supplier_Quote_Line__c !=null)
             {
                 Supplier_Quote_Line__c  sql=sqls.get(line.Supplier_Quote_Line__c);
                 if(NEU_Utils.safeDecimal(sql.Total_Weight_Kg__c)!=0 && NEU_Utils.safeDecimal(line.Shipping_Weight_Kg__c)==0) 
                     line.Shipping_Weight_Kg__c = sql.Total_Weight_Kg__c; 
                 if(NEU_Utils.safeDecimal(sql.Total_Volume_m3__c)!=0 && NEU_Utils.safeDecimal(line.Shipping_Volume_m3__c)==0)  
                     line.Shipping_Volume_m3__c =sql.Total_Volume_m3__c; 
                 if(NEU_Utils.safeDecimal(sql.Quantity__c )!=0 && NEU_Utils.safeDecimal(line.Units_Shipped__c)==0)
                     line.Units_Shipped__c = sql.Quantity__c; 
                 if(NEU_Utils.safeDecimal(sql.Net_Price__c )!=0) 
                     line.Unit_Origin_Sell_Price__c = sql.Net_Price__c; 
                // if(NEU_Utils.safeDecimal(sql.Expense_Amount__c)!=0 && NEU_Utils.safeDecimal(line.Conversion_Rate_to_Currency_Header__c)!=0) 
                //     line.Expense_Amount__c= sql.Expense_Amount__c * line.Conversion_Rate_to_Currency_Header__c;

             }
                   
        }
    }
    
    if(linesids_ie.size()>0)
    {
        Map<Id,Quote_Item_Line__c>sqls=new Map<Id,Quote_Item_Line__c>([select Id,Total_Shipping_Volume_m3__c, Total_Shipping_Weight_Kgs__c, Units__c, Price__c, Unit_Origin_Buy_Price__c from Quote_Item_Line__c where Id IN:linesids_ie]);
        for(Shipment_Line__c line:trigger.new)
        {
             if(line.Quote_Item_Line__c !=null)
             {
                 Quote_Item_Line__c sql = sqls.get(line.Quote_Item_Line__c);
                 if(NEU_Utils.safeDecimal(sql.Total_Shipping_Weight_Kgs__c)!=0 && NEU_Utils.safeDecimal(line.Shipping_Weight_Kg__c)==0)   
                     line.Shipping_Weight_Kg__c = sql.Total_Shipping_Weight_Kgs__c; 
                 if(NEU_Utils.safeDecimal(sql.Total_Shipping_Volume_m3__c)!=0 && NEU_Utils.safeDecimal(line.Shipping_Volume_m3__c)==0)   
                     line.Shipping_Volume_m3__c =sql.Total_Shipping_Volume_m3__c; 
                 if(NEU_Utils.safeDecimal(sql.Units__c)!=0 && NEU_Utils.safeDecimal(line.Units_Shipped__c)==0)
                     line.Units_Shipped__c = sql.Units__c;  
                  if(NEU_Utils.safeDecimal(sql.Price__c)!=0)    
                     line.Unit_Origin_Sell_Price__c = sql.Price__c;   
                  if(NEU_Utils.safeDecimal(sql.Unit_Origin_Buy_Price__c )!=0)  
                     line.Unit_Origin_Buy_Price__c  =sql.Unit_Origin_Buy_Price__c;
             }
                   
        }
    }

    if(contIds.size() > 0)
    {
        Map<Id,Container_Type__c>containers=new Map<Id,Container_Type__c>([SELECT Id, TEUS__c FROM Container_Type__c WHERE Id IN: contIds]);
        for(Shipment_Line__c line:trigger.new)
        {
            if(line.Container_Type__c != null) {
                Container_Type__c contain=containers.get(line.Container_Type__c);
                line.TEUS__c = contain.TEUS__c;
            }
        }
    }
    
}