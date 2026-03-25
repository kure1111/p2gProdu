global class P2G_AccountUsageScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        P2G_AccountUsageService batch = new P2G_AccountUsageService();
        Database.executeBatch(batch, 50);
    }
}