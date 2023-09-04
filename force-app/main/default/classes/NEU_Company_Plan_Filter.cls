public with sharing class NEU_Company_Plan_Filter {

    //GRAFICO
    public List<Data> datos_grafico {get;set;}
    public class Data
    {
        public String labor_program {get;set;}
        public Decimal Available_Time {get;set;}
        public Decimal Available_Loading_Time {get;set;}
        public Decimal Loading_Time {get;set;}
        public Data(String labor_program, Decimal Available_Time, Decimal Available_Loading_Time, Decimal Loading_Time) 
        {
            this.labor_program = labor_program;
            this.Available_Time = Available_Time;
            this.Available_Loading_Time = Available_Loading_Time;
            this.Loading_Time = Loading_Time;
        }
    }

    Company_Plan__c record=null;
    
    private List<Labor_Program__c>lb=null;

    private List<Labor_Program__c>lbc=null;
    
    private List<SelectOption> c=null; 
    public String country{
        get
        {
            getcountries();
            return country;
        }
        set
        {
            if(value!=country)
            {
                country=value;
                l=null;
                st=null;
                fl=null;
                lb=null;
            }
        }
    }
    
    private List<SelectOption> st=null; 
    public String state{
        get
        {
            getstates();
            return state;
        }
        set
        {
            if(value!=state)
            {
                state=value;
                l=null;
                fl=null;
                lb=null;
            }
        }
    }
    private List<SelectOption> l=null; 
    public String location{
        get
        {
            getlocations();
            return location;
        }
        set
        {
            if(location!=value)
            {
                location=value;
                fl=null;
                lb=null;
            }
        }
        }
    private List<SelectOption> fl=null; 
    public String factory{
        get
            {
                getfactories();
                return factory;
            }
        set
            {
                if(factory!=value)
                {
                    factory=value;
                    lb=null;
                }
            }
        }
    private List<SelectOption> f=null; 
    public String family{
        get
            {
                getfamilies();
                return family;
            }
        set
            {
                if(family!=value)
                {
                    family=value;
                    s=null;
                    lb=null;
                }
            }
        }
    private List<SelectOption> s=null; 
    public String subfamily{
        get
            {
                getsubfamilies();
                return subfamily;
            }
        set
            {
                if(subfamily!=value)
                {
                    subfamily=value;
                    lb=null;
                }
            }
        }
        
    private List<SelectOption> vf=null; 
    public String valid_from{
        get
            {
                getvalids_froms();
                return valid_from;
            }
        set
            {
                if(valid_from!=value)
                {
                    valid_from=value;
                    lb=null;
                }
            }
        }
    
    public NEU_Company_Plan_Filter(ApexPages.StandardController stdController)
    {
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]{'Id'});
        record=(Company_Plan__c)stdController.getRecord();
    }
    public List<Labor_Program__c> getPrograms()
    {
        if(lb==null)
        {
            String query='select Valid_From__c,Valid_To__c,Available_Time__c,Available_Loading_Time__c,Idle_Time__c,Loading_Time__c,Unconstrained_Capacity_Utilisation__c,Constrained_Capacity_Utilisation__c,id,Name,Factory_Line__r.Country__c,Factory_Line__r.Country__r.Name,Factory_Line__r.State__c,Factory_Line__r.State__r.Name,Factory_Line__r.Location__c,Factory_Line__r.Location__r.Name,Factory_Line__c,Factory_Line__r.Name,Factory_Line__r.Family__c,Factory_Line__r.Family__r.Name,Factory_Line__r.Subfamily__c,Factory_Line__r.Subfamily__r.Name from Labor_Program__c where Company_Plan__c=\''+record.id+'\'';
            if(country=='0')
                query+=' and Factory_Line__r.Country__c=null';
            else if(country!='all')
                query+=' and Factory_Line__r.Country__c=\''+country+'\'';
            if(state=='0')
                query+=' and Factory_Line__r.State__c=null';
            else if(state!='all')
                query+=' and Factory_Line__r.State__c=\''+state+'\'';
            if(location=='0')
                query+=' and Factory_Line__r.Location__c=null';
            else if(location!='all')
                query+=' and Factory_Line__r.Location__c=\''+location+'\'';
            if(factory=='0')
                query+=' and Factory_Line__c=null';
            else if(factory!='all')
                query+=' and Factory_Line__c=\''+factory+'\'';
            if(family=='0')
                query+=' and Factory_Line__r.Family__c=null';
            else if(family!='all')
                query+=' and Factory_Line__r.Family__c=\''+family+'\'';
            if(subfamily=='0')
                query+=' and Factory_Line__r.Subfamily__c=null';
            else if(subfamily!='all')
                query+=' and Factory_Line__r.Subfamily__c=\''+subfamily+'\'';
            if(valid_from=='0')
                query+=' and Valid_From__c=null';
            else if(valid_from!='all')
                query+=' and Valid_From__c='+valid_from;
            lb=database.query(query);
        }

        return lb;
    }
    
    public void pintar_grafico()
    {
        String query='select Valid_From__c,Valid_To__c,Available_Time__c,Available_Loading_Time__c,Idle_Time__c,Loading_Time__c,Unconstrained_Capacity_Utilisation__c,Constrained_Capacity_Utilisation__c,id,Name,Factory_Line__r.Country__c,Factory_Line__r.Country__r.Name,Factory_Line__r.State__c,Factory_Line__r.State__r.Name,Factory_Line__r.Location__c,Factory_Line__r.Location__r.Name,Factory_Line__c,Factory_Line__r.Name,Factory_Line__r.Family__c,Factory_Line__r.Family__r.Name,Factory_Line__r.Subfamily__c,Factory_Line__r.Subfamily__r.Name from Labor_Program__c where Company_Plan__c=\''+record.id+'\'';
        if(country=='0')
            query+=' and Factory_Line__r.Country__c=null';
        else if(country!='all')
            query+=' and Factory_Line__r.Country__c=\''+country+'\'';
        if(state=='0')
            query+=' and Factory_Line__r.State__c=null';
        else if(state!='all')
            query+=' and Factory_Line__r.State__c=\''+state+'\'';
        if(location=='0')
            query+=' and Factory_Line__r.Location__c=null';
        else if(location!='all')
            query+=' and Factory_Line__r.Location__c=\''+location+'\'';
        if(factory=='0')
            query+=' and Factory_Line__c=null';
        else if(factory!='all')
            query+=' and Factory_Line__c=\''+factory+'\'';
        if(family=='0')
            query+=' and Factory_Line__r.Family__c=null';
        else if(family!='all')
            query+=' and Factory_Line__r.Family__c=\''+family+'\'';
        if(subfamily=='0')
            query+=' and Factory_Line__r.Subfamily__c=null';
        else if(subfamily!='all')
            query+=' and Factory_Line__r.Subfamily__c=\''+subfamily+'\'';
        
        if(valid_from=='0')
            query+=' and Valid_From__c=null';
        else if(valid_from !='all')
            query+=' and Valid_From__c='+valid_from;
        system.debug('company_plan_filter'+query);
            
        List<Labor_Program__c> labor_program = database.query(query);
        
        //GRAFICO
        List<Data> datos = new List<Data>();
        for(Labor_Program__c lp : labor_program)
        {
            datos.add(new Data(lp.Factory_Line__r.Name+' - '+lp.Valid_From__c.year(), (lp.Available_Time__c != null ? lp.Available_Time__c : 0), (lp.Available_Loading_Time__c != null ? lp.Available_Loading_Time__c : 0), (lp.Loading_Time__c != null ? lp.Loading_Time__c : 0)));
        }
        datos_grafico = datos;
    }
    
    private List<Labor_Program__c> getlbc()
    {
        if(lbc==null)
        {
            lbc=[select id,Name,Factory_Line__r.Country__c,Factory_Line__r.Country__r.Name,Factory_Line__r.State__c,Factory_Line__r.State__r.Name,Factory_Line__r.Location__c,Factory_Line__r.Location__r.Name,Factory_Line__c,Factory_Line__r.Name,Factory_Line__r.Family__c,Factory_Line__r.Family__r.Name,Factory_Line__r.Subfamily__c,Factory_Line__r.Subfamily__r.Name, Valid_From__c from Labor_Program__c where Company_Plan__c=:record.id];
        }
        return lbc;
    }

    public List<SelectOption> getcountries()
    {
        if(c==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<Id,SelectOption>options=new Map<Id,SelectOption>();
            for(Labor_Program__c l:lbc)
                if(l.Factory_Line__r.Country__c==null)
                {
                    if(!options.containsKey(null))
                        options.put(null,new SelectOption('0',''));
                }
                else if(!options.containsKey(l.Factory_Line__r.Country__c))
                    options.put(l.Factory_Line__r.Country__c,new SelectOption(l.Factory_Line__r.Country__c,l.Factory_Line__r.Country__r.Name));
            c = new List<SelectOption>();
            if(options.size()==1)
            {
                c.add(options.values()[0]);
                country=options.values()[0].getValue();
            }
            else
            {
                c.add(new SelectOption('all','All Countries'));
                c.addAll(options.values());
                country='all';
            }
        }
        return c;
    }
    public List<SelectOption> getstates()
    {
        if(st==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<Id,SelectOption>options=new Map<Id,SelectOption>();
            for(Labor_Program__c l:lbc)
                if(l.Factory_Line__r.State__c==null)
                {
                    if(!options.containsKey(null))
                        options.put(null,new SelectOption('0',''));
                }
                else if((!options.containsKey(l.Factory_Line__r.State__c))&&((country==String.valueOf(l.Factory_Line__r.Country__c))||(country=='all')))
                    options.put(l.Factory_Line__r.State__c,new SelectOption(l.Factory_Line__r.State__c,l.Factory_Line__r.State__r.Name));
            st = new List<SelectOption>();
            if(options.size()==1)
            {
                st.add(options.values()[0]);
                state=options.values()[0].getValue();
            }
            else
            {
                st.add(new SelectOption('all','All States'));
                st.addAll(options.values());
                state='all';
            }
        }
        return st;
    }
    public List<SelectOption> getlocations()
    {
        if(l==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<Id,SelectOption>options=new Map<Id,SelectOption>();
            for(Labor_Program__c l:lbc)
                if(l.Factory_Line__r.Location__c==null)
                {
                    if(!options.containsKey(null))
                        options.put(null,new SelectOption('0',''));
                }
                else if((!options.containsKey(l.Factory_Line__r.Location__c))&&((country==String.valueOf(l.Factory_Line__r.Country__c))||(country=='all'))&&((state==String.valueOf(l.Factory_Line__r.State__c))||(state=='all')))
                    options.put(l.Factory_Line__r.Location__c,new SelectOption(l.Factory_Line__r.location__c,l.Factory_Line__r.Location__r.Name));
            l = new List<SelectOption>();
            if(options.size()==1)
            {
                l.add(options.values()[0]);
                location=options.values()[0].getValue();
            }
            else
            {
                l.add(new SelectOption('all','All Locations'));
                l.addAll(options.values());
                location='all';
            }
        }
        return l;
    }
    public List<SelectOption> getfactories()
    {
        if(fl==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<Id,SelectOption>options=new Map<Id,SelectOption>();
            for(Labor_Program__c l:lbc)
                if((!options.containsKey(l.Factory_Line__c))&&((country==String.valueOf(l.Factory_Line__r.Country__c))||(country=='all'))&&((state==String.valueOf(l.Factory_Line__r.State__c))||(state=='all'))&&((location==String.valueOf(l.Factory_Line__r.Location__c))||(location=='all')))
                    options.put(l.Factory_Line__c,new SelectOption(l.Factory_Line__c,l.Factory_Line__r.Name));
            fl = new List<SelectOption>();
            if(options.size()==1)
            {
                fl.add(options.values()[0]);
                factory=options.values()[0].getValue();
            }
            else
            {
                fl.add(new SelectOption('all','All Lines'));
                fl.addAll(options.values());
                factory='all';
            }
        }
        return fl;
    }
    public List<SelectOption> getfamilies()
    {
        if(f==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<Id,SelectOption>options=new Map<Id,SelectOption>();
            for(Labor_Program__c l:lbc)
                if(l.Factory_Line__r.Family__r==null)
                {
                    if(!options.containsKey(null))
                        options.put(null,new SelectOption('0',''));
                }
                else if(!options.containsKey(l.Factory_Line__r.Family__c))
                    options.put(l.Factory_Line__r.Family__c,new SelectOption(l.Factory_Line__r.Family__c,l.Factory_Line__r.Family__r.Name));
            f = new List<SelectOption>();
            if(options.size()==1)
            {
                f.add(options.values()[0]);
                family=options.values()[0].getValue();
            }
            else
            {
                f.add(new SelectOption('all','All Families'));
                f.addAll(options.values());
                family='all';
            }
        }
        return f;
    }
    public List<SelectOption> getsubfamilies()
    {
        if(s==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<Id,SelectOption>options=new Map<Id,SelectOption>();
            for(Labor_Program__c l:lbc)
                if(l.Factory_Line__r.Subfamily__r==null)
                {
                    if(!options.containsKey(null))
                        options.put(null,new SelectOption('0',''));
                }
                else if((!options.containsKey(l.Factory_Line__r.Subfamily__c))&&((family==String.valueOf(l.Factory_Line__r.Family__c))||(family=='all')))
                    options.put(l.Factory_Line__r.Subfamily__c,new SelectOption(l.Factory_Line__r.Subfamily__c,l.Factory_Line__r.Subfamily__r.Name));
            s = new List<SelectOption>();
            if(options.size()==1)
            {
                s.add(options.values()[0]);
                subfamily=options.values()[0].getValue();
            }
            else
            {
                s.add(new SelectOption('all','All Subfamilies'));
                s.addAll(options.values());
                subfamily='all';
            }
        }
        return s;
    }
    
    public List<SelectOption> getvalids_froms()
    {
        if(vf==null)
        {
            List<Labor_Program__c>lbc=getlbc();
            Map<string,SelectOption>options=new Map<string,SelectOption>();
            for(Labor_Program__c l:lbc)
                if(l.Valid_From__c == null)
                {
                    if(!options.containsKey(null))
                        options.put(null,new SelectOption('0',''));
                }
                else
                {
                    String my_date=((DateTime)l.Valid_From__c).format('yyyy-MM-dd');
                    if(!options.containsKey(my_date))
                        options.put(my_date,new SelectOption(my_date,l.Valid_From__c.format()));
                }
            vf = new List<SelectOption>();
            if(options.size()==1)
            {
                vf.add(options.values()[0]);
                valid_from=options.values()[0].getValue();
            }
            else
            {
                vf.add(new SelectOption('all','All Valid From'));
                vf.addAll(options.values());
                valid_from='all';
            }
            
        }
        return vf;
    }
}