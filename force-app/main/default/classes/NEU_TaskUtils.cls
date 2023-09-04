public without sharing class NEU_TaskUtils {
    public static SObject newTaskRelation(Id TaskId,Boolean IsWhat,Id RelationId)
    {
        try{
        	Schema.SObjectType sObjType=Schema.getGlobalDescribe().get('TaskRelation');
        	if(sObjType!=null)
	        {
	        	sObject sObj = sObjType.newSObject();
	        	if(sObj!=null)
	        	{
	        		sObj.put('TaskId',TaskId);
	        		sObj.put('IsWhat',IsWhat);
	        		sObj.put('RelationId',RelationId);
		            return sObj;
	        	}
	        } 	
        }
        catch(Exception e){}
        return null;
    }
    public static Boolean withTaskRelation()
    {
        try{
        	Schema.SObjectType sObjType=Schema.getGlobalDescribe().get('TaskRelation');
        	if(sObjType!=null)
	        	return true;
        }
        catch(Exception e){}
        return false;
    }
}