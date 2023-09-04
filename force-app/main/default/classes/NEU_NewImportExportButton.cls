public class NEU_NewImportExportButton 
{
	@AuraEnabled
    public static string getAccount() 
    {
        List<User> user = [select Id, ContactId from User where Id =: UserInfo.getUserId()];
        
        if(user.size() > 0)
        {
        	List<Contact> contact = [select Id, Name, AccountId from Contact where Id =: user[0].ContactId];
            if(contact.size() > 0)
                return contact[0].AccountId;
            else
                return null;
		}
        else
            return null;
    }
}