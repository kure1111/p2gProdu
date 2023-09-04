global class P2G_sheduleGetToken implements Schedulable{
    global void execute(SchedulableContext SC) {
        P2G_getToken.callout();
    }
}