public class NEU_QR_Response {
    
    @AuraEnabled
    public static Warehouse_Exit_Order__c getWareHousesExit(string exitId)
    {
        Warehouse_Exit_Order__c record;
        
        try 
        {
            record = [select Id, Name, Account_for_Customer__c, Solicitud_de_Maniobras__c, Account_for_Customer__r.Name, Proveedor__c, Proveedor__r.Name,
                      Placas_de_Tracto__c, Placas_de_Caja__c, Nombre_Operador__c, Licencia_Operador__c
                      from Warehouse_Exit_Order__c where Id =: exitId];            
        } 
        catch(Exception ee){record = new Warehouse_Exit_Order__c();}    
        
        return record;        
    }
    
    @AuraEnabled
    public static Warehouse_Exit_Order__c getWareHousesExitByShipment(string shipId, String pallet)
    {
        Warehouse_Exit_Order__c record;
        List<Inventory_Exit__c> exits = new List<Inventory_Exit__c>();

        
        try 
        {
            exits = [select Id, Name, Item__c, Item__r.Name, Units_Picked__c, Shipment_Item_Line__c, Shipment_Item_Line__r.Pallet_Code__c,
                     Item__r.Sourcing_Item_Code__c, Item__r.Master_Box_Volume_m3__c, Item__r.Master_Box_Length_cm__c, Item__r.Master_Box_Width_cm__c,
                     Item__r.Master_Box_Height_cm__c, Item__r.Master_Box_Packing_Weight_kg__c, item__r.Item_Description__c, Warehouse_Exit_Order__c, Inventory_Entry__r.Remaining_Units__c
                     from Inventory_Exit__c where Shipment__c =: shipId
                     and Shipment_Item_Line__r.Pallet_Code__c =: pallet
                     order by Shipment_Item_Line__r.Pallet_Code__c];  
            
            record = [select Id, Name, Account_for_Customer__c, Solicitud_de_Maniobras__c, Account_for_Customer__r.Name, Proveedor__c, Proveedor__r.Name,
                      Placas_de_Tracto__c, Placas_de_Caja__c, Nombre_Operador__c, Licencia_Operador__c
                      from Warehouse_Exit_Order__c where Id =: exits[0].Warehouse_Exit_Order__c];            
        } 
        catch(Exception ee){record = new Warehouse_Exit_Order__c();}    
        
        return record;        
    }
    
    @AuraEnabled
    public static List<Inventory_Exit__c> getInventoryExits(string exitId, String pallet)
    {
        List<Inventory_Exit__c> exits = new List<Inventory_Exit__c>();
        try 
        {
            exits = [select Id, Name, Item__c, Item__r.Name, Units_Picked__c, Shipment_Item_Line__c, Shipment_Item_Line__r.Pallet_Code__c,
                     Item__r.Sourcing_Item_Code__c, Item__r.Master_Box_Volume_m3__c, Item__r.Master_Box_Length_cm__c, Item__r.Master_Box_Width_cm__c,
                     Item__r.Master_Box_Height_cm__c, Item__r.Master_Box_Packing_Weight_kg__c, item__r.Item_Description__c, Inventory_Entry__r.Remaining_Units__c
                     from Inventory_Exit__c where Warehouse_Exit_Order__c =: exitId
                     and Shipment_Item_Line__r.Pallet_Code__c =: pallet
                     order by Shipment_Item_Line__r.Pallet_Code__c];            
        } 
        catch(Exception ee){}    
        
        return exits;
        
    }
    
    @AuraEnabled
    public static List<Inventory_Exit__c> getInventoryExitsByShipment(string exitId, String pallet)
    {
        List<Inventory_Exit__c> exits = new List<Inventory_Exit__c>();
        try 
        {
            exits = [select Id, Name, Item__c, Item__r.Name, Units_Picked__c, Shipment_Item_Line__c, Shipment_Item_Line__r.Pallet_Code__c,
                     Item__r.Sourcing_Item_Code__c, Item__r.Master_Box_Volume_m3__c, Item__r.Master_Box_Length_cm__c, Item__r.Master_Box_Width_cm__c,
                     Item__r.Master_Box_Height_cm__c, Item__r.Master_Box_Packing_Weight_kg__c, item__r.Item_Description__c, Inventory_Entry__r.Remaining_Units__c
                     from Inventory_Exit__c where Warehouse_Exit_Order__c =: exitId
                     and Shipment_Item_Line__r.Pallet_Code__c =: pallet
                     order by Shipment_Item_Line__r.Pallet_Code__c];            
        } 
        catch(Exception ee){}    
        
        return exits;
        
    }
    
    @AuraEnabled
    public static decimal getTotalUnitsWarehouse(string exitId)
    {
        decimal total_units = 0;
        
        List<Inventory_Exit__c> exits = [select Id, Name, Item__c, Item__r.Name, Units_Picked__c, Shipment_Item_Line__c, Shipment_Item_Line__r.Pallet_Code__c,
                                         Item__r.Sourcing_Item_Code__c 
                                         from Inventory_Exit__c where Warehouse_Exit_Order__c =: exitId order by Shipment_Item_Line__r.Pallet_Code__c];
        for(Inventory_Exit__c e : exits)
        {
            total_units += (e.Units_Picked__c != null ? e.Units_Picked__c : 0);
        }
        return total_units;
    }
    
    @AuraEnabled
    public static List<Shipment_Line__c> getShipmentCargoLines(string shipId, String pallet)
    {
        try 
        {
            List<Shipment_Line__c> shipment_cargo_lines = [select Id, Name, Item_Name__c, Item_Name__r.Name, Units_Shipped__c, Pallet_Code__c,
			Item_Name__r.Sourcing_Item_Code__c, Item_Name__r.Master_Box_Volume_m3__c, Item_Name__r.Master_Box_Length_cm__c, Item_Name__r.Master_Box_Width_cm__c,
			Item_Name__r.Master_Box_Height_cm__c, Item_Name__r.Master_Box_Packing_Weight_kg__c, Item_Name__r.Item_Description__c, Warehouse_Location__c
            from Shipment_Line__c where Shipment__c =: shipId and Pallet_Code__c =: pallet order by Pallet_Code__c];  
            
            return shipment_cargo_lines;
        } 
        catch(Exception e){throw new AuraHandledException('Exception : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + '.');}         
    }
    
    @AuraEnabled
    public static List<Inventory_Entry__c> getInvetoryEntries(string shipId, String pallet)
    {
        try 
        {
            List<Inventory_Entry__c> inventory_entries = [select Id, Name, Item__c, Item__r.Name, Units_Picked__c, Shipment_Item_Line__c, Shipment_Item_Line__r.Pallet_Code__c,
                     Item__r.Sourcing_Item_Code__c, Item__r.Master_Box_Volume_m3__c, Item__r.Master_Box_Length_cm__c, Item__r.Master_Box_Width_cm__c,
                     Item__r.Master_Box_Height_cm__c, Item__r.Master_Box_Packing_Weight_kg__c, item__r.Item_Description__c, Remaining_Units__c, Shipment_Item_Line__r.Warehouse_Location__c
                     from Inventory_Entry__c where Shipment__c =: shipId
                     and Shipment_Item_Line__r.Pallet_Code__c =: pallet
                     order by Shipment_Item_Line__r.Pallet_Code__c];  
            
            return inventory_entries;
        } 
        catch(Exception e){throw new AuraHandledException('Exception : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + '.');}         
    }
    
}