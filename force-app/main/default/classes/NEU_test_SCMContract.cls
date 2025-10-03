@isTest
private class NEU_test_SCMContract {

  @isTest(SeeAllData=true)
  public static void testNEU_OM_FollowersSCMContract() {

      NEU_StaticVariableHelper.setBoolean1(true);

      ApexPages.currentPage().getParameters().put('test', 'test');
    List<String> validRecordTypes = new List<String>{'Supplier', 'Customer', 'Supply Chain Partner'};
    Account existingAccount = [
        SELECT Id, RecordType.Name 
        FROM Account 
        WHERE RecordType.Name IN :validRecordTypes 
        LIMIT 1
    ];
      SCM_Contract__c scmContract = new SCM_Contract__c(
          Name = 'SCM Contract Test',
          Account_for__c = existingAccount.Id
      );
      insert scmContract;
  
      NEU_OM_FollowersSCMContract uda = new NEU_OM_FollowersSCMContract(new ApexPages.StandardController(scmContract));
  
      uda.getfollower();
      uda.getfollowersin();
      uda.nuevalinea();
      uda.quitarlinea();
      uda.byPass();
  }
  

}