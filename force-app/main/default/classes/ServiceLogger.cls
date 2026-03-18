public class ServiceLogger {
    public static void log(String serviceName) {
        Service_Usage__c registro = new Service_Usage__c(
            Name = serviceName,
            OwnerId = UserInfo.getUserId()
        );
        insert registro;
    }
}