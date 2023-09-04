/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_Comparable {
	class Line_Comparable extends NEU_Line_Comparable
	{
		public Line_Comparable(Controller_Comparable p)
		{
			super(p);
		}
		public Location__c l;
		public Boolean b;
		public Integer i;
		public Decimal d;
		public Date da;
		public DateTime dt;
		public String s;
		public lineInfo i1=new lineInfo(1);
		public lineInfo i2=new lineInfo(1,2);
	    public override Object getValue(String compareField)
	    {
	    	if(compareField=='i1')
	    		return i1;
	    	else if(compareField=='b')
    			return b;
	    	else if(compareField=='i')
    			return i;
	    	else if(compareField=='d')
    			return d;
	    	else if(compareField=='da')
    			return da;
	    	else if(compareField=='dt')
    			return dt;
	    	if(compareField=='s')
    			return s;
	    	return getValue(l,compareField);
	    }
	}
   	class Controller_Comparable extends NEU_Controller_Comparable
   	{
   		public Controller_Comparable(Integer listnumber)
   		{
   			super(listnumber);
   		}
   		List<Line_Comparable>mylist;
   		public Controller_Comparable()
   		{
   			mylist=new List<Line_Comparable>();
   			Line_Comparable l=new Line_Comparable(this);
   			myList.add(l);
   			l=new Line_Comparable(this);
   			myList.add(l);
   			l=new Line_Comparable(this);
   			l.b=false;
   			l.i=0;
   			l.d=0;
   			Date d1=Date.today();
   			l.da=d1;
   			DateTime dt1=DateTime.now();
   			l.dt=dt1;
   			l.s='';
   			l.l=new Location__c();
   			myList.add(l);
   			l=new Line_Comparable(this);
   			l.b=false;
   			l.i=0;
   			l.d=0;
   			l.da=d1;
   			l.dt=dt1;
   			l.s='';
   			l.l=new Location__c();
   			l.l.Country__r=new Country__c();
   			myList.add(l);
   			l=new Line_Comparable(this);
   			l.b=true;
   			l.i=1;
   			l.d=1;
   			l.da=d1+1;
   			l.dt=dt1+1;
   			l.s='a';
   			l.l=new Location__c();
   			l.l.Country__r=new Country__c();
   			myList.add(l);
   			l=new Line_Comparable(this);
   			l.i1.principal=1;
   			myList.add(l);
   			l=new Line_Comparable(this);
   			l.i1.principal=2;
   			myList.add(l);
   		}
	    public override void sortList(Integer listNumber)
	    {
	    	myList.sort();
	    }
   	}

    static testMethod void test_NEU_Controller_Comparable() {
		NEU_StaticVariableHelper.setBoolean1(true);

		Controller_Comparable mytest=new Controller_Comparable(1);
        mytest=new Controller_Comparable();
        mytest.notSorted(0);
        mytest.compareClass='';
        mytest.compareField='b';
        mytest.sorting();
        mytest.compareClass=mytest.compareClass;
        mytest.compareField='b';
        mytest.sorting();
        mytest.compareClass=mytest.compareClass;
        mytest.compareField='b';
        mytest.sorting();
        mytest.compareField='i';
        mytest.sorting();
        mytest.compareField='i';
        mytest.sorting();
        mytest.compareField='i';
        mytest.sorting();
        mytest.compareField='d';
        mytest.sorting();
        mytest.compareField='d';
        mytest.sorting();
        mytest.compareField='d';
        mytest.sorting();
        mytest.compareField='da';
        mytest.sorting();
        mytest.compareField='da';
        mytest.sorting();
        mytest.compareField='da';
        mytest.sorting();
        mytest.compareField='dt';
        mytest.sorting();
        mytest.compareField='dt';
        mytest.sorting();
        mytest.compareField='dt';
        mytest.sorting();
        mytest.compareField='s';
        mytest.sorting();
        mytest.compareField='s';
        mytest.sorting();
        mytest.compareField='s';
        mytest.sorting();
        mytest.compareField='Name';
        mytest.sorting();
        mytest.compareField='Name';
        mytest.sorting();
        mytest.compareField='Name';
        mytest.sorting();
        mytest.compareField='Country__r.Name';
        mytest.sorting();
        mytest.compareField='Country__r.Name';
        mytest.sorting();
        mytest.compareField='Country__r.Name';
        mytest.sorting();
        mytest.compareField='i1';
        mytest.sorting();
        mytest.sorting(0,'Name',1);
        mytest.sorting(0,'Name');
        mytest.resorting();
        mytest.notSorted();
    }
}