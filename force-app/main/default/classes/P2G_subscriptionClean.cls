public class P2G_subscriptionClean {
    public static void deleteSubscriptions() {
        List<EntitySubscription> subscriptionsToDelete = [SELECT Id FROM  EntitySubscription limit 9500];
        
        if (!subscriptionsToDelete.isEmpty()) {
            delete subscriptionsToDelete;
        }
    }
    
}