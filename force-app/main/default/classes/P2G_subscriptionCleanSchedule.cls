global class P2G_subscriptionCleanSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        P2G_subscriptionClean.deleteSubscriptions();
    } 
}