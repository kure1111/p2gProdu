public with sharing class NEU_Catalog_Price_List_Steps {

      public Price_List__c record;
      public string step {get;set;}
      public String step_2_url {get;set;}
      public boolean interno_externo {get;set;}
      public String step_1 {get;set;}
      public String step_2 {get;set;}
      public String step_3 {get;set;}
      public String step_4 {get;set;}
  
      ApexPages.StandardController con;
       
      public NEU_Catalog_Price_List_Steps(ApexPages.StandardController stdController) 
      {
            con = stdController;
            system.debug( con.getRecord() );
            try { 
            record = [select Id, Name from Price_List__c where Id =: con.getRecord().id];
            } catch( Exception ee) { 
              record = new Price_List__c();
          }
          step_1 = 'step_active';
          step_2 = 'step_active';
          step_3 = 'step_active';
          step_4 = 'step_active';
          
          List<User> query_user = [select Id from user where id=:UserInfo.getUserId()];
          if(query_user.size()==0)
          {
            step_2_url = 'NEU_OM_Allocated_Items';
            interno_externo = false;
          }
          else
          {
            step_2_url = 'NEU_Allocated_Items_Community';   
            interno_externo = true;
          }
          
          List<Catalog_Family__c> listado_familias = [select Id, Name from Catalog_Family__c where Catalog_Price_List__c =: record.Id];
          if(listado_familias.size()>0)
          {
            step_1 = 'step_inactive';
          }
          
          List<Item_List_Price__c> listado_items = [select Id, Name, Price_List__c from Item_List_Price__c where Price_List__c =: record.Id];
          if(listado_items.size()>0)
          {
              step_2 = 'step_inactive';
          }
          
          List<Customer_Price_List__c> listado_cuentas = [select Id, Name from Customer_Price_List__c where Price_List__c =: record.Id];
          if(listado_cuentas.size()>0)
            step_3 = 'step_inactive';
            
          List<Task> tareas = [select Id, WhatId from Task where WhatId =: record.Id and Send_Emails__c =: true];
          if(tareas.size() > 0)
              step_4 = 'step_inactive';
      
      }
}