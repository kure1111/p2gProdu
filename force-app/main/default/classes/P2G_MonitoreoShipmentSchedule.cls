public class P2G_MonitoreoShipmentSchedule implements Schedulable {
   public static String CRON_EXP = '0 30 * * * ?';
   public void execute(SchedulableContext ctx) {
       P2G_MonitoreoShipment.start();
    }
}