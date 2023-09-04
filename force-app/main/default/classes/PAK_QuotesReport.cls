public class PAK_QuotesReport {
    public Date startDate {get;set;}
    public Date endDate {get;set;}
    public String servicio {get;set;}
    
    public PAK_QuotesReport(){
        startDate = Date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        endDate = Date.newInstance(Date.Today().Year(), Date.Today().Month(), Date.daysInMonth(Date.Today().Year(), Date.Today().Month()));
    }
}