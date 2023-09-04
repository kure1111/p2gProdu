@isTest
public class CheckRecursive_Test {
                
    public static testMethod void Test_CheckRecursive(){        
        CheckRecursive.firstCallUpdateShipmentCustomerQuote = false; 
        CheckRecursive.firstCallNEU_RecalculateTraffic= false;
        CheckRecursive.firstCallNEU_ActualizaFolioIE= false;
        CheckRecursive.firstCallUpdateOppAmmount = false;
        CheckRecursive.firstCallPAK_PlannerEmail= false;
        CheckRecursive.PAK_ShipmentHistory= false;
        CheckRecursive.PAK_ShipmentSL_History = false;
    }
    
    
}