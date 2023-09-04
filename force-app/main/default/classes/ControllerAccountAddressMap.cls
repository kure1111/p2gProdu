public class ControllerAccountAddressMap {


    @AuraEnabled
    public static string getDomain() 
    {
       return String.valueof(System.URL.getSalesforceBaseURL().gethost());
    }
    

}