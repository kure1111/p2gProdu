public abstract class NEU_Controller_Comparable
{
	public NEU_Controller_Comparable()
	{
		addLists(1);
	}
	public NEU_Controller_Comparable(Integer listNumber)
	{
		addLists(listNumber);
	}
	private String tempCompareField;
	
	public List<String> compareFieldArray{get;set;}
	public List<String> compareLastFieldArray{get;set;}
	public List<Integer> compareResultArray{get;set;}
	public List<String> compareClassArray{get;set;}
	public void addLists(Integer newLists)
	{
		compareFieldArray=new List<String>();
		compareLastFieldArray=new List<String>();
		compareResultArray=new List<Integer>();
		compareClassArray=new List<String>();
		for(Integer c=0;c<newLists;c++)
		{
			compareFieldArray.add('');
			compareLastFieldArray.add('-');
			compareResultArray.add(1);
			compareClassArray.add(getCompareClass(1));
		}
	}
    public Integer listNumber{
    	get
    	{
    		if(listNumber==null)
    			listNumber=0;
    		return listNumber;
    	}
    	set;
    }
    public String compareField{
    	get{return compareFieldArray[listNumber];}
    	set{tempCompareField=value;}
    }
    public String compareClass{
    	get{return compareClassArray[listNumber];}
    	set{}
    }
    public Integer compareResult{
    	get{return compareResultArray[listNumber];}
    	set{}
    }
	private String getCompareClass(Integer compareResult)
	{
		return compareResult==1?'compare compareField compareDesc':'compare compareField compareAsc';
	}
	public void sorting(Integer listNumber,String compareField,Integer compareResult)
	{
		compareFieldArray[listNumber]=compareField;
    	compareLastFieldArray[listNumber]=compareField;
    	compareResultArray[listNumber]=compareResult;
    	compareClassArray[listNumber]=getCompareClass(compareResult);
    	this.listNumber=listNumber;
		sortList(listNumber);
	}
	public void sorting(Integer listNumber,String compareField)
	{
		tempCompareField=compareField;
		this.listNumber=listNumber;
		sorting();
	}
	public void sorting()
	{
		compareFieldArray[listNumber]=tempCompareField;
		if(compareLastFieldArray[listNumber]==tempCompareField)
		{
			compareResultArray[listNumber]=-compareResultArray[listNumber];
	    	compareClassArray[listNumber]=getCompareClass(compareResultArray[listNumber]);
		}
		else
		{
			compareLastFieldArray[listNumber]=tempCompareField;
			compareResultArray[listNumber]=1;
	    	compareClassArray[listNumber]=getCompareClass(1);
		}
		sortList(listNumber);
	}
    public abstract void sortList(Integer listNumber);
    public void notSorted()
    {
    	notSorted(0);
    }
    public void notSorted(Integer listNumber)
    {
    	compareFieldArray[listNumber]='';
    	compareLastFieldArray[listNumber]='-';
    }
    public void resorting()
    {
    	resorting(0);
    }
    public void resorting(Integer listNumber)
    {
    	if(compareLastFieldArray[listNumber]!='-')
    	{
	    	this.listNumber=listNumber;
			sortList(listNumber);
    	}
    }
}