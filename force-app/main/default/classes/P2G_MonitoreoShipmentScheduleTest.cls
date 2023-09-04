@isTest
public class P2G_MonitoreoShipmentScheduleTest {
    @isTest
    static void MonitoreoRC(){
        Test.startTest();
        P2G_MonitoreoShipmentSchedule exe = new P2G_MonitoreoShipmentSchedule();
        exe.execute(null);
        Test.stopTest(); 
    } 
}