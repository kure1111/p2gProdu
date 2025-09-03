@IsTest
public class P2G_reporteSACTest {
    @IsTest(SeeAllData=true)
    public static void test(){
            String jobName = 'P2G_ShipmentReportSchedulerJob';
			String cronExp = '0 0 0/3 * * ?'; // Ejecutar cada 3 horas
			System.schedule(jobName, cronExp, new P2G_ShipmentReportScheduler());
    }
}