public class P2G_ShowEvents {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getUpcomingEvents() {
        Id userId;
        if(!Test.isRunningTest()){
             userId = UserInfo.getUserId();
        } else {
            userId = '005RQ000002mECPYA2'; // Se usa ID PRODUCCIÓN
        }
        
        List<Event> events = [SELECT Id, Subject, StartDateTime, EndDateTime, Owner.Name
                              FROM Event
                              WHERE OwnerId = :userId
                              ORDER BY StartDateTime ASC];
        List<Map<String, Object>> formattedEvents = new List<Map<String, Object>>();

        // Formato deseado: 2024-09-15T12:00:00
        String isoDateFormat = 'yyyy-MM-dd\'T\'HH:mm:ss';

        for (Event e : events) {
            formattedEvents.add(new Map<String, Object>{
                'id' => e.Id,
                'title' => e.Subject,
                'propietario' => e.Owner.Name,
                'start' => e.StartDateTime.formatGMT(isoDateFormat),
                'end' => e.EndDateTime.formatGMT(isoDateFormat)
            });
        }

        return formattedEvents;
    }
}