/**
 * Created by jamarin on 06/03/2019.
 */

public class NEU_MD_Create_EventIssue{

    public Event_Issues__c event_issue {get;set;}
    public String id;
    public String idEvent_issue;
    public Datetime dateAux {get;set;}


    public NEU_MD_Create_EventIssue() 
    {

        id = ApexPages.currentPage().getParameters().get('id');

        try{
            idEvent_issue = ApexPages.currentPage().getParameters().get('idEvent_issue');
            event_issue = [SELECT Name, Date__c, User__c, Situation__c, Topic__c, CurrencyIsoCode from Event_issues__c where id = :idEvent_issue];

           
        }catch(Exception ex){
            event_issue = new Event_issues__c();
        }

    }

    public PageReference save(){
        Datetime dt = event_issue.Date__c;
        Integer offset = UserInfo.getTimezone().getOffset(dt);
        Datetime local = dt.addSeconds(offset/1000);

        event_issue.Id_Calendar_Event__c =  id;
        event_issue.Date__c = local;

        try{
            insert event_issue;
        }catch(Exception ex){
            update event_issue;
        }

        PageReference tempPage = new PageReference('/apex/NEU_EventIssues?id=' + id);        
        tempPage.setRedirect(true);
        return tempPage;
    }

    public PageReference back(){

        PageReference tempPage = new PageReference('/apex/NEU_EventIssues?id=' + id);        
        tempPage.setRedirect(true);
        return tempPage;
    }
    

    

}