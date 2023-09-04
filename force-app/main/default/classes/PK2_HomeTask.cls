public class PK2_HomeTask {
    public List<Task> lsTask {get;set;}
    public PK2_HomeTask(){
        Id UserId = UserInfo.getUserId();
        lsTask = new list<Task>();
        lsTask = [Select Id,ActivityDate,Status,Subject,What.Name,Who.Name From Task Where CreatedById=:UserId and Status !='Completed' and Subject=:'Meeting'];
    }
}