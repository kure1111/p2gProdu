public without sharing class NEU_JE_RFP_quote_ranking {
    public static Integer getRanking(String quoteId,String projectId)
    {
        if(String.isNotEmpty(quoteId)&&String.isNotEmpty(projectId))
        {
            Integer Res=1;
            List<Supplier_Quote__c> quotes=[select Id, CreatedById from Supplier_Quote__c where Supply_Project__c=:projectId and (Supplier_Quote_Status__c='Sent Bid' or Supplier_Quote_Status__c='Sent Final Bid') and Valid_for_Auction__c=true order by Total_Amount__c asc nulls last];
            for(Supplier_Quote__c q:quotes)
            {
                if(String.valueOf(q.Id)==quoteId)
                    return Res;
                Res++;
            }
        }
        return 0;
    }
    public static Supplier_Quote__c insertQuote(Supplier_Quote__c quote)
    {
        try
        {
            insert quote;
            return quote;
        }
        catch(exception ex){}
        
        return null;
    }
    public static List<Supplier_Quote_Line__c> insertQuoteLines(List<Supplier_Quote_Line__c> lines)
    {
        insert lines;
        return lines;
    }
    public static Supplier_Quote_Line__c insertQuoteLine(Supplier_Quote_Line__c line)
    {
        insert line;
        return line;
    }
    public static void updateLastBid(String projectId)
    {
        if(String.isNotEmpty(projectId))
        {
            List<Supply_Project__c> quotes=[select Id,Last_Bid__c from Supply_Project__c where Dynamic_Auction_Status__c='Started' and Id=:projectId];
            if(quotes.size()>0)
            {
                quotes[0].Last_Bid__c=DateTime.now();
                update quotes[0];
            }
        }
    }
    public static void updateStartingBid(String projectId,Decimal total)
    {
        if(String.isNotEmpty(projectId))
        {
            List<Supply_Project__c> quotes=[select Id,Calculated_Starting_Bid__c from Supply_Project__c where (Calculated_Starting_Bid__c>:total or Calculated_Starting_Bid__c=null) and Dynamic_Auction_Status__c='Not Started' and Id=:projectId];
            if(quotes.size()>0)
            {
                quotes[0].Calculated_Starting_Bid__c=total;
                update quotes[0];
            }
        }
    }
    public static Boolean validPassword(String password)
    {
        if(String.IsEmpty(password))
            return false;
        Integer leng=password.length();
        if(leng<8)
            return false;
        Boolean isnumeric=false;
        Boolean isalpha=false;
        for(Integer d:password.toUpperCase().getChars())
        {
            if((d>=65)&&(d<=90))
                isalpha=true;
            else if((d>=48)&&(d<=57))
                isnumeric=true;
            if((isalpha)&&(isnumeric))
                return true;
        }
        return false;
    }
    public static String getSecret(Integer paswdLeng,String key)
    {
        String pswd = '';
        Integer keylength=key.length();
        for (Integer i = 0; i < paswdLeng; i++) {
            Integer pos=Integer.valueOf(Math.random() * keylength);
            pswd+=key.substring(pos,pos+1);
        }
        return pswd;
    }
    public static String newPassword(Boolean complex)
    {
        if(!complex)
            return getSecret(4,'0123456789');
        return getSecret(4,'ABCDEFGHJKMNPQRSTUVWXYZ')+getSecret(4,'0123456789');
    }
    public static String newPassword(Boolean complex,String pre)
    {
        if(pre!=null)
            return pre+newPassword(complex);
        return newPassword(complex);
    }
}