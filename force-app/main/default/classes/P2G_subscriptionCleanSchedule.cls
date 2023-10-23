global class P2G_subscriptionCleanSchedule {
    global void execute(SchedulableContext sc) {
        P2G_subscriptionClean.deleteSubscriptions();
    } 
}