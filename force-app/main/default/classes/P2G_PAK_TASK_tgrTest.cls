@isTest
public class P2G_PAK_TASK_tgrTest {
    @isTest
    static void PAK_TASK_tgr(){
        Task Activadad = new Task(Priority = 'Normal',Subject = 'Test',Status = 'Scheduled', OwnerId = UserInfo.getUserId());
        insert Activadad;
    }

}