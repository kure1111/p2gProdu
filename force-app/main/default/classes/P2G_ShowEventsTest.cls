@isTest(SeeAllData=true)
public class P2G_ShowEventsTest {
    @isTest
    static void testGetUpcomingEvents() {
        List<Map<String, Object>> events = P2G_ShowEvents.getUpcomingEvents();
        Map<String, Object> firstEvent = events[0];
        Map<String, Object> secondEvent = events[1];
    }
}