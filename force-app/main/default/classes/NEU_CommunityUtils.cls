public without sharing class NEU_CommunityUtils {
    public static Id getNetworkId(SObject someObject)
    {
        try{
            return (Id) someObject.get('NetworkId');
        }
        catch(Exception e){}
        return null;
    }
    public static Id setNetworkId(SObject someObject,Id NetworkId)
    {
        try{
            return (Id) someObject.put('NetworkId',NetworkId);
        }
        catch(Exception e){}
        return null;
    }

}