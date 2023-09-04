public class NEU_OM_FollowersLaborProgram {

    public Labor_Program__c record;
    public  List<follower_s> follower = null;
    public  List<followersin_s> followersin = null;
    public List<User> users;
    public List<EntitySubscription> subscriptions;
    List<Contact> contactos=null;   
    public string idlinea {get;set;}
    
    public class follower_s
    {
        public User line {get; set;}
        public boolean selected {get; set;}
        public Boolean max_subcripciones_superado {get;set;}
        public Boolean community_user {get;set;}
        
        public follower_s(User line,boolean selected, Boolean max_subcripciones_superado, Boolean community_user)
        {
            this.line=line;
            this.selected=selected;
            this.max_subcripciones_superado = max_subcripciones_superado;
            this.community_user = community_user;
        }
    }  
      
    ApexPages.StandardController con;
    
    public NEU_OM_FollowersLaborProgram(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, CreatedById,Factory_Line__r.Account_Owner__c, LastModifiedById, Factory_Line__r.Account_Owner__r.OwnerId,Factory_Line__r.Account_Owner__r.Account_Executive_User__c, Factory_Line__r.Account_Owner__r.Account_External_Follower_User__c from Labor_Program__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Labor_Program__c();
        }
    }
    public List<follower_s> getfollower()
    {
        if(follower == null)
        {
            follower=new List<follower_s>();
            List<EntitySubscription> new_subscriptions = new List<EntitySubscription>();
            new_subscriptions = [select Id, parentId, SubscriberId from EntitySubscription where parentId =: record.Id order by SubscriberId limit 100];
            
            users = [select Id, Name, FullPhotoUrl, IsActive, UserRoleId, ContactId, UserRole.Name  from User where IsActive =: true  order by ContactId desc];
            contactos = [select Id, Name, AccountId from Contact where AccountId =: record.Factory_Line__r.Account_Owner__c order by Name];
            boolean encontrados=false;
            
            Map<id,decimal> maps_users_subcription = new Map<id,decimal>();
            List<AggregateResult> query_entitysubscription = [select COUNT(Id) total, SubscriberId from EntitySubscription where SubscriberId IN: users group by SubscriberId];
            for(AggregateResult qi: query_entitysubscription)
            {
                  maps_users_subcription.put((string)qi.get('SubscriberId'),(decimal)qi.get('total'));               
            }
            
            for(User qi: users)
            {
                for(EntitySubscription ns :new_subscriptions)
                {
                    if(qi.Id == ns.SubscriberId)
                    {
                        for(Contact con :contactos)
                        {
                            if(con.id==qi.ContactId)
                            {
                                encontrados=true;
                                break;
                            }
                        }
                        if(encontrados==false)
                        {
                            if(record.Factory_Line__r.Account_Owner__r.Account_External_Follower_User__c != qi.Id)
                            {
                                //Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+qi.Id+'\' limit 500');
                                follower.add(new follower_s(qi,false,(maps_users_subcription.get(qi.Id) >= 500 ? true : false),(qi.ContactId != null ? true : false)));
                            }
                        }
                        else
                        {
                            //Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+qi.Id+'\' limit 500');
                            follower.add(new follower_s(qi,true,(maps_users_subcription.get(qi.Id) >= 500 ? true : false),(qi.ContactId != null ? true : false)));
                        }
                        encontrados=false;
                        break;
                    }
                }
            }
            for(User qi: users)
            {
                for(EntitySubscription ns :new_subscriptions)
                {
                    if(qi.Id == ns.SubscriberId)
                    {
                        if(record.Factory_Line__r.Account_Owner__r.Account_External_Follower_User__c == qi.Id)
                        {
                            //Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+qi.Id+'\' limit 500');
                            follower.add(new follower_s(qi,true,(maps_users_subcription.get(qi.Id) >= 500 ? true : false),(qi.ContactId != null ? true : false)));
                            break;
                        }
                    }
                }
            } 
        }
        return follower;
    }
    
    public class followersin_s
    {
        public User line {get; set;}
        public boolean selected {get; set;}
        public Boolean max_subcripciones_superado {get;set;}
        public Boolean community_user {get;set;}
        
        public followersin_s(User line,boolean selected,Boolean max_subcripciones_superado, Boolean community_user)
        {
            this.line=line;
            this.selected=selected;
            this.max_subcripciones_superado=max_subcripciones_superado;
            this.community_user = community_user;
        }
        
    }   
    
    public List<followersin_s> getfollowersin()
    {
        if(followersin == null)
        {
            followersin=new List<followersin_s>();
            users = [select Id, Name, FullPhotoUrl, IsActive, UserRoleId, ContactId, UserRole.Name  from User where IsActive =: true and  (NOT Name  like '%Guest User%') order by Name,ContactId asc limit 1000];
            contactos = [select Id, Name, AccountId from Contact where AccountId =: record.Factory_Line__r.Account_Owner__c order by Id];
            boolean encontrado =false;
            boolean encontrados2=false;
            
            Map<id,decimal> maps_users_subcription = new Map<id,decimal>();
            List<AggregateResult> query_entitysubscription = [select COUNT(Id) total, SubscriberId from EntitySubscription where SubscriberId IN: users group by SubscriberId];
            for(AggregateResult qi: query_entitysubscription)
            {
                  maps_users_subcription.put((string)qi.get('SubscriberId'),(decimal)qi.get('total'));               
            }
            
            for(User qi: users)
            {
                if(follower != null)
                {
                    for(follower_s us:getfollower())
                    {
                        if(us.line.Id==qi.Id)
                        {
                            encontrado =true;
                            break;
                        }
                    }
                }
                if(encontrado ==false)
                {
                    for(Contact con :contactos)
                    {
                        if(con.id == qi.ContactId)
                        {
                            encontrados2=true;
                            break;
                        }
                    }
                    
                    if(encontrados2==true)
                    {
                       // Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+qi.Id+'\' limit 500');
                        followersin.add(new followersin_s(qi,true,(maps_users_subcription.get(qi.Id) >= 500 ? true : false),(qi.ContactId != null ? true : false)));
                    }
                    else
                    {
                        if(record.Factory_Line__r.Account_Owner__r.Account_External_Follower_User__c != qi.Id)
                        {
                            //Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+qi.Id+'\' limit 500');
                            followersin.add(new followersin_s(qi,false,(maps_users_subcription.get(qi.Id) >= 500 ? true : false),(qi.ContactId != null ? true : false)));
                        }
                    }
                }
                encontrado =false;
                encontrados2=false;
            }
            encontrado=false;
            for(User qi: users)
            {
                    for(follower_s us:getfollower())
                    {
                        if(us.line.Id==qi.Id)
                        {
                            encontrado =true;
                            break;
                        }
                    }
                if(encontrado == false)
                {   
                    if(record.Factory_Line__r.Account_Owner__r.Account_External_Follower_User__c == qi.Id)
                    {
                        //Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+qi.Id+'\' limit 500');
                        followersin.add(new followersin_s(qi,true,(maps_users_subcription.get(qi.Id) >= 500 ? true : false),(qi.ContactId != null ? true : false)));
                        break;
                    }
                }
                encontrado=false;
            }
        }
        return followersin;
    }
    
    public void nuevalinea()
    {
        integer contador= 0;
        for(followersin_s fs: getfollowersin())
        {
            if((fs.line.Id == idlinea)|| ApexPages.currentPage().getParameters().get('test') != null )
            {
                //Si supera el límite de suscripciones se elimina la última.
                Integer total_suscripciones = Database.countQuery('SELECT COUNT() FROM EntitySubscription where SubscriberId = \''+fs.line.Id+'\' limit 500');
                if(total_suscripciones >= 500)
                {
                    List<EntitySubscription> last_subscription = [select Id, parentId, SubscriberId, CreatedDate
                    from EntitySubscription where SubscriberId =: fs.line.Id order by CreatedDate desc limit 1];
    
                    try
                    {   
                        delete last_subscription;
                    }
                    catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'+ex)); }
                }
                
                //INSERT SUBSCRIPTION
                EntitySubscription new_subscription = new EntitySubscription();
                new_subscription.parentId = record.Id;
                new_subscription.SubscriberId = fs.line.Id;
                
                if(fs.community_user)
                {
                    CSH_Community__c commId = CSH_Community__c.getOrgDefaults();
                    if(commId != null)
                        NEU_CommunityUtils.setNetworkId(new_subscription,commId.Community_Id__c);
                }

                try
                {   
                    insert new_subscription;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'+ex));}
                //--------------------
                
                if(fs.selected==true)
                    follower.add(new follower_s(fs.line,fs.selected,fs.max_subcripciones_superado,fs.community_user));
                else
                {
                    if(follower.size()>0)
                        follower.add(0,new follower_s(fs.line,fs.selected,fs.max_subcripciones_superado,fs.community_user));
                    else
                        follower.add(new follower_s(fs.line,fs.selected,fs.max_subcripciones_superado,fs.community_user));
                }
                followersin.remove(contador);
                break;
            }
            contador ++;
        }
        
    }
    
    public void quitarlinea()
    {
         integer contador= 0;
        for(follower_s fs: getfollower())
        {
            if((fs.line.Id == idlinea) || ApexPages.currentPage().getParameters().get('test') != null )
            {
                //DELETE SUBSCRIPTION
                List<EntitySubscription> del_subscriptions = [select Id, parentId, SubscriberId 
                from EntitySubscription where parentId =: record.Id and SubscriberId =: fs.line.Id limit 1];

                try
                {   
                    delete del_subscriptions;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'+ex)); }
                //--------------------
                
                if(fs.selected==true)
                {
                    followersin.add(new followersin_s(fs.line,fs.selected,false,fs.community_user));
                }
                else
                {
                    if(followersin.size()>0)
                        followersin.add(0,new followersin_s(fs.line,fs.selected,false,fs.community_user));
                    else
                        followersin.add(new followersin_s(fs.line,fs.selected,false,fs.community_user));
                }
                follower.remove(contador);
                break;
            }
            contador ++;
        }
    }
}