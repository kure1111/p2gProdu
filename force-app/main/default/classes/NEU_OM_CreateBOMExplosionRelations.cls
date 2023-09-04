public with sharing class NEU_OM_CreateBOMExplosionRelations {

public Sourcing_Item__c record;

private List<BOM_Relation__c> bom_relation=null;
public  List<Lista_items_h> Item_List = null;


private List<Product_Family__c> family =null; 

public string accountpricelist {get;set;}
public string listado_familias {get;set;}
public string listado_accountpricelist {get;set;}
public string field_accountpricelist {get;set;}
public string listado_pricelist {get;set;}
public string field_pricelist {get;set;}
public string listadodecheck {get;set;}
public string nombrepricelist {get;set;}
public string bloqueolookup {get;set;}
public string idaccountpricelist{get;set;}
private string subfamily_field='';
private string variador='';
public boolean chekeados{get;set;}

public String getsubfamily_field(){
    return subfamily_field;
}
public void setsubfamily_field(String value){
    if(subfamily_field!=value)
    {
        subfamily_field=value;
    }
}

ApexPages.StandardController con;
    
    public NEU_OM_CreateBOMExplosionRelations(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Business_Area__c, Sourcing_Family__c, Subfamily__c, Sum_Price_Imputation__c from Sourcing_Item__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Sourcing_Item__c();
        }
    
        accountpricelist = '';
        subfamily_field = '';
        listado_familias= '';
        listado_accountpricelist = '';
        listado_pricelist = '';
        field_accountpricelist = '';
        field_pricelist = '';
        listadodecheck = '';
        nombrepricelist = '';
        bloqueolookup = '';
        chekeados =false;
        //botones familias
        List<Subfamily__c> lista_subfamilias = new List<Subfamily__c>();
        List<Sourcing_Item__c> lista_articulos_con_familia = new List<Sourcing_Item__c>();
        if(record.Business_Area__c != null)
        {
             lista_subfamilias = [SELECT Name, Id, Product_Family__r.Business_Area__c, Product_Family__r.Name FROM Subfamily__c where Product_Family__r.Business_Area__c =: record.Business_Area__c order by Name];
             lista_articulos_con_familia = [SELECT Id, Name, Subfamily__c from Sourcing_Item__c where Consolidate_by_BOM__c =: false ];
        }
        integer contador = 0;
        for(Subfamily__c pf : lista_subfamilias)
        {
            for(Sourcing_Item__c items : lista_articulos_con_familia)
            {
                if(pf.Id== items.Subfamily__c)
                {
                    if(contador == 0)
                    {
                        listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio" checked="checked"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-left-radius: 0px;" title="'+pf.Product_Family__r.Name+'">'+pf.Name+'</label>';
                        subfamily_field = pf.Name;
                    }
                    else
                    {
                        if(lista_subfamilias.size() == lista_subfamilias.size())
                            listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-right-radius: 0px;" title="'+pf.Product_Family__r.Name+'">'+pf.Name+'</label>';
                        else
                            listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" title="'+pf.Product_Family__r.Name+'">'+pf.Name+'</label>';
                    }
                    contador ++;
                    break;
                }
            }
        }
        
    }
    
    //Consultar las lineas insertadas
    public List<BOM_Relation__c> getbom_relation()
    {
        
        if(subfamily_field != '')
            bom_relation = [select Id,Output_Item__r.Name, Input_Item__r.Current_Supplier__c, Input_Item__r.Weight_Kgs__c,Input_Item__r.Unit_of_measure__c,Input_Item__r.Item_Price__c,  Rejection__c, Input_Item__r.Name, Input_Item__r.Sourcing_Item_Code__c,  Current_Supplier_Input__c,Input_Item__c,Item_Owner_Input__c,Item_Owner_Output__c,Item_Price_Input__c,Item_Price_Output__c,Output_Item__c,Price_Imputation__c,Uds_Input_Ud_Output__c,Unit_of_measure_Input__c,Unit_of_measure_Output__c, Output_Item__r.Subfamily__r.Name, Input_Item__r.Subfamily__r.Name from BOM_Relation__c where Input_Item__r.Subfamily__r.Name  =: subfamily_field and Output_Item__c =: record.Id order by Name]; 
        else
            bom_relation = [select Id,Output_Item__r.Name, Input_Item__r.Current_Supplier__c, Input_Item__r.Weight_Kgs__c,Input_Item__r.Unit_of_measure__c,Input_Item__r.Item_Price__c,  Rejection__c, Input_Item__r.Name, Input_Item__r.Sourcing_Item_Code__c,  Current_Supplier_Input__c,Input_Item__c,Item_Owner_Input__c,Item_Owner_Output__c,Item_Price_Input__c,Item_Price_Output__c,Output_Item__c,Price_Imputation__c,Uds_Input_Ud_Output__c,Unit_of_measure_Input__c,Unit_of_measure_Output__c, Output_Item__r.Subfamily__r.Name  from BOM_Relation__c where Output_Item__c =: record.Id order by Name]; 
    
        return bom_relation;
    }

    private List<nuevos_items_s> getFamilyList(String subfamily)
    {
            
            List<nuevos_items_s> Family_Item_List_Price=new List<nuevos_items_s>();
            List<Sourcing_Item__c> lista_sourcingitems = null;
            if(subfamily != '')
            {
                lista_sourcingitems = [select Id, Name,Business_Area__c,Current_Supplier__c,Item_Price__c,Account_Owner__c,Account_Owner__r.Name,Weight_Kgs__c,Unit_of_measure__c,Sourcing_Family__r.Name,  Subfamily__r.Name, Consolidate_by_BOM__c from Sourcing_Item__c where Subfamily__r.Name  =: subfamily and Id !=: record.Id and Consolidate_by_BOM__c =:false order by Name];
            }
            else
            {
                lista_sourcingitems = [select Id, Name, Business_Area__c,Current_Supplier__c,Item_Price__c,Account_Owner__c,Account_Owner__r.Name,Weight_Kgs__c,Unit_of_measure__c, Consolidate_by_BOM__c from Sourcing_Item__c where Id !=: record.Id and Consolidate_by_BOM__c =: false order by Name];
            }
            List<BOM_Relation__c> bom_relation_items = null;
            if(subfamily != '')
                bom_relation_items = [select Id, Input_Item__r.Weight_Kgs__c,Input_Item__r.Unit_of_measure__c,Input_Item__r.Item_Price__c,  Rejection__c, Input_Item__r.Name, Input_Item__r.Sourcing_Item_Code__c,  Current_Supplier_Input__c,Input_Item__c,Item_Owner_Input__c,Item_Owner_Output__c,Item_Price_Input__c,Item_Price_Output__c,Output_Item__c,Price_Imputation__c,Uds_Input_Ud_Output__c,Unit_of_measure_Input__c,Unit_of_measure_Output__c, Output_Item__r.Subfamily__r.Name, Input_Item__r.Subfamily__r.Name from BOM_Relation__c where Input_Item__r.Subfamily__r.Name  =: subfamily_field and Output_Item__c =: record.Id order by Name];
            else
                bom_relation_items = [select Id,  Input_Item__r.Weight_Kgs__c,Input_Item__r.Unit_of_measure__c,Input_Item__r.Item_Price__c,  Rejection__c, Input_Item__r.Name, Input_Item__r.Sourcing_Item_Code__c,  Current_Supplier_Input__c,Input_Item__c,Item_Owner_Input__c,Item_Owner_Output__c,Item_Price_Input__c,Item_Price_Output__c,Output_Item__c,Price_Imputation__c,Uds_Input_Ud_Output__c,Unit_of_measure_Input__c,Unit_of_measure_Output__c, Output_Item__r.Subfamily__r.Name  from BOM_Relation__c where Output_Item__c =: record.Id order by Name];
        
            boolean insertar = true;
            for(Sourcing_Item__c lp: lista_sourcingitems)
            {
            
                for(BOM_Relation__c qi: bom_relation_items)
                {
                    if(lp.Id == qi.Input_Item__c)
                    {
                        insertar = false;
                        break;
                    }
                }
                if(insertar)
                    Family_Item_List_Price.add(new nuevos_items_s(lp,false, '', '1', '1', string.valueof(lp.Item_Price__c),'0'));
                insertar = true;
            }
            return Family_Item_List_Price;
    }
    
    // rellenar la lista y Sacar los items no insertados
    public List<nuevos_items_s> getItem_List()
    {
        
        if(Item_List==null)
            Item_List=new List<Lista_items_h>();
        
        List<nuevos_items_s>ret=null;
        
        for(Lista_items_h myitem:Item_List)
            if(myitem.family==subfamily_field)
                ret=myitem.mylist;
        if(ret==null)
        {
            ret=getFamilyList(subfamily_field);
            Lista_items_h myitem=new Lista_items_h();
            myitem.family=subfamily_field;
            myitem.mylist=ret;
            Item_List.add(myitem);
        }
        
        return ret;
    }
    
    public class Lista_items_h
    {
        public List<nuevos_items_s>mylist=null;
        public String family=''; 
    }
    
    //clase nuevo objeto
    public class nuevos_items_s
    {
        public Sourcing_Item__c line {get; set;}
        public boolean selected {get; set;}
        public String extensionitemname {get; set;}
        public String units {get; set;}
        public String shippingweight {get; set;}
        public String price {get; set;}
        public String Rejection {get; set;}
        
        public nuevos_items_s(Sourcing_Item__c line,boolean selected, String extensionitemname, String shippingweight, String units, String price, String Rejection)
        {
            this.line=line;
            this.selected=selected;
            this.extensionitemname=extensionitemname;
            this.shippingweight=shippingweight;
            this.units=units;
            this.price= price;
            this.Rejection=Rejection;
        }
        
    }   
    //Consultar las insertadas nuevo objet    
   public void crearrelationbom()
    {   
        if(Item_List!=null)
        {
            List<BOM_Relation__c> bom_rela = null;
                bom_rela = [select Id, Name, Item_Price_Output__c, Output_Item__c from BOM_Relation__c where Output_Item__c =: record.Id  order by Name];
            
            integer contadordelineas = 0;
            contadordelineas =bom_rela.size();
            string name_bom_relation='';
            for(Lista_items_h myitem:Item_List)
            {
                for (nuevos_items_s lines:myitem.mylist)
                {
                    
                    if(lines.selected)
                    {
                        chekeados =true;
                        contadordelineas ++;
                        BOM_Relation__c myLine= new BOM_Relation__c();
                        myline.Output_Item__c=record.Id;
                        name_bom_relation = record.Name+'-'+ lines.line.Name;
                        myline.Name = (name_bom_relation.length() < 80 ? name_bom_relation: name_bom_relation.substring(0,79) );
                        myline.Input_Item__c=lines.line.Id;
                        myline.Rejection__c = decimal.valueOf(lines.Rejection);
                        myline.Uds_Input_Ud_Output__c = decimal.valueof(lines.units);
                        try
                        {
                            insert myLine;
                
                        }
                        catch(Exception e){
                            
                        }
                        name_bom_relation='';
                        contadordelineas ++;
                    }
                }
            }
            Item_List=null;
        }
        List<BOM_Relation__c> bom_rela2 = null;
        bom_rela2 = [select Id, Name, Item_Price_Output__c, Output_Item__c, Input_Item__c, Price_Imputation__c from BOM_Relation__c where Output_Item__c =: record.Id  order by Name];
        decimal total = 0;
        for(BOM_Relation__c bom:bom_rela2)
        {
            if(bom.Price_Imputation__c != null)
                total +=bom.Price_Imputation__c;
        }
        try
        {
            record.Sum_Price_Imputation__c = total;
            update record;
        }
        catch(Exception ex){}
    
    }
    

}