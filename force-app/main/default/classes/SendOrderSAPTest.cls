@isTest
public class SendOrderSAPTest {
    
    @isTest(seeAllData=true)
    static void testTriggerOnUpdate() {
        // Buscar OrderItem cuyo Order NO esté activado
        List<OrderItem> existingItem = [SELECT Id, OrderId, Quantity, UnitPrice 
                                        FROM OrderItem 
                                        WHERE OrderId != null 
                                        AND Order.Status NOT IN ('Activated', 'Activated', 'Submitted', 'Approved', 'Completed')
                                        LIMIT 1];
        
        if(!existingItem.isEmpty()) {
            // Simplemente actualizar el campo Quantity
            existingItem[0].Quantity = existingItem[0].Quantity + 1;
            
            // Ejecutar el test - esto disparará el trigger
            Test.startTest();
            update existingItem[0];
            Test.stopTest();
            
            // No asserts, solo verificar que se ejecutó
            System.debug('Test completado: Trigger se ejecutó al actualizar OrderItem');
        } else {
            System.debug('No se encontró OrderItem para probar');
        }
    }
    
    @isTest(seeAllData=true)
    static void testTriggerOnInsert() {
        // Consultar un Order que NO esté activado
        List<Order> existingOrder = [SELECT Id FROM Order 
                                     WHERE Status NOT IN ('Activated', 'Activated', 'Submitted', 'Approved', 'Completed')
                                     LIMIT 1];
        List<PricebookEntry> pbe = [SELECT Id FROM PricebookEntry LIMIT 1];
        
        if(!existingOrder.isEmpty() && !pbe.isEmpty()) {
            // Crear un nuevo OrderItem
            OrderItem newItem = new OrderItem(
                OrderId = existingOrder[0].Id,
                PricebookEntryId = pbe[0].Id,
                Quantity = 1,
                UnitPrice = 100
            );
            
            // Ejecutar el test - esto disparará el trigger
            Test.startTest();
            insert newItem;
            Test.stopTest();
            
            System.debug('Test completado: Trigger se ejecutó al insertar OrderItem');
        } else {
            System.debug('No se encontró Order válido para insertar OrderItem');
        }
    }
    
    @isTest(seeAllData=true)
    static void testTriggerOnDelete() {
        // Consultar un OrderItem cuyo Order NO esté activado
        List<OrderItem> existingItem = [SELECT Id, OrderId 
                                        FROM OrderItem 
                                        WHERE OrderId != null 
                                        AND Order.Status NOT IN ('Activated', 'Activated', 'Submitted', 'Approved', 'Completed')
                                        LIMIT 1];
        
        if(!existingItem.isEmpty()) {
            // Ejecutar el test - esto disparará el trigger
            Test.startTest();
            delete existingItem[0];
            Test.stopTest();
            
            System.debug('Test completado: Trigger se ejecutó al eliminar OrderItem');
        } else {
            System.debug('No se encontró OrderItem para eliminar');
        }
    }
    
    @isTest(seeAllData=true)
    static void testTriggerBulkUpdate() {
        // Buscar varios OrderItems con Orders no activados
        List<OrderItem> existingItems = [SELECT Id, OrderId, Quantity 
                                         FROM OrderItem 
                                         WHERE OrderId != null 
                                         AND Order.Status NOT IN ('Activated', 'Activated', 'Submitted', 'Approved', 'Completed')
                                         LIMIT 5];
        
        if(!existingItems.isEmpty()) {
            // Actualizar todos los items
            for(OrderItem item : existingItems) {
                item.Quantity = item.Quantity + 1;
            }
            
            // Ejecutar el test
            Test.startTest();
            update existingItems;
            Test.stopTest();
            
            System.debug('Test bulk completado: ' + existingItems.size() + ' items actualizados');
        }
    }
}