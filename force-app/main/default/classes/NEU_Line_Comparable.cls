public abstract class NEU_Line_Comparable implements Comparable{
    public class lineInfo
    {
        public lineInfo(Integer priority,Object principal)
        {
            this.priority=priority;
            this.principal=principal;
        }
        public lineInfo(Integer priority)
        {
            this.priority=priority;
            this.principal=null;
        }
        public Integer priority;
        public Object principal;
    }
    public NEU_Controller_Comparable parent;
    public NEU_Line_Comparable(NEU_Controller_Comparable parent)
    {
        this.parent=parent;
    }
    public Object getValue(SObject myobject,String fieldName)
    {
        if(myobject==null)
            return null;
        while(fieldName.indexOf('__r.')>=0)
        {
            myobject=myobject.getSobject(fieldName.substringBefore('__r.')+'__r');
            if(myobject==null)
                return null;
            fieldName=fieldName.substringAfter('__r.');
        }
        return myobject.get(fieldName);
    }
    public abstract Object getValue(String compareField);
    public Integer compareTo(Object compareTo)
    {
        Object one=getValue(parent.compareField);
        Object two=((NEU_Line_Comparable)compareTo).getValue(parent.compareField);
        if(one instanceof lineInfo)
        {
            if(two instanceof lineInfo)
            {
                if(((lineInfo)one).priority>((lineInfo)two).priority)
                    return -1;
                if(((lineInfo)one).priority<((lineInfo)two).priority)
                    return 1;
                two=((lineInfo)two).principal;
            }
            else
            {
                if(((lineInfo)one).priority>0)
                    return -1;
                if(((lineInfo)one).priority<0)
                    return 1;
            }
            one=((lineInfo)one).principal;
        }
        else if(two instanceof lineInfo)
        {
            if(((lineInfo)two).priority>0)
                return 1;
            if(((lineInfo)two).priority<0)
                return -1;
            two=((lineInfo)two).principal;
        }
        if(one==null)
        {
            if(two==null)
                return 0;
            return -parent.compareResult;
        }
        else if(two==null)
            return parent.compareResult;
        else if(one instanceof Boolean)
        {
            if(((Boolean)one)==((Boolean)two))
                return 0;
            if(((Boolean)one))
                return parent.compareResult;
        }
        else if(one instanceof Integer)
        {
            if(((Integer)one)==((Integer)two))
                return 0;
            if(((Integer)one)>((Integer)two))
                return parent.compareResult;
        }
        else if(one instanceof Decimal)
        {
            if(((Decimal)one)==((Decimal)two))
                return 0;
            if(((Decimal)one)>((Decimal)two))
                return parent.compareResult;
        }
        else if(one instanceof Date)
        {
            if(((Date)one)==((Date)two))
                return 0;
            if(((Date)one)>((Date)two))
                return parent.compareResult;
        }
        else if(one instanceof DateTime)
        {
            if(((DateTime)one)==((DateTime)two))
                return 0;
            if(((DateTime)one)>((DateTime)two))
                return parent.compareResult;
        }
        else if(one instanceof String)
        {
            if(((String)one)==((String)two))
                return 0;
            if(((String)one)>((String)two))
                return parent.compareResult;
        }
        return -parent.compareResult;
    }
}