global class P2G_AccountRouteByStatus_Schedule implements Schedulable {
	
	global void execute(SchedulableContext sc) {
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        Database.executeBatch(batch, 50);
    }    
}