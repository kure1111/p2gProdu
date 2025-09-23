@isTest(SeeAllData=true)
private class Cifid_Test {
    
    @isTest static void testSendWithOperation3() {
        // Crea un set con IDs existentes (asumimos que los datos existen ya que usamos SeeAllData=true)
        Set<Id> existingIds = new Set<Id>{
            [SELECT Id FROM Quote_Item_Line__c LIMIT 1].Id
        };
        
        // Llama al método future con operación 3
        Test.startTest();
        PAK_SendCargoLines.send(existingIds, 3);
        PAK_SendCargoLines.Test();
        Test.stopTest();
    }

    @isTest static void testSendWithOtherOperation() {
        // Busca un ID válido de Quote_Item_Line__c
        Quote_Item_Line__c line = [
            SELECT Id FROM Quote_Item_Line__c 
            WHERE Container_Type__r.Name != null 
              AND Item_Name__r.Name != null 
              AND Import_Export_Quote__r.Name != null
              AND Units__c != null
              AND Total_Shipping_Weight_Kgs__c != null
              AND Total_Shipping_Volume_m3__c != null
            LIMIT 1
        ];

        Set<Id> lineIds = new Set<Id>{ line.Id };
        
        // Llama al método con operación diferente de 3
        Test.startTest();
        PAK_SendCargoLines.send(lineIds, 1);
        Test.stopTest();
    }
}