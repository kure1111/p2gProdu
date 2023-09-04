public class CheckRecursive {
	Public static Boolean firstCallNEU_RecalculateTraffic= false;    
    Public static Boolean firstCallUpdateShipmentCustomerQuote= false;
    Public static Boolean firstCallNEU_ActualizaFolioIE= false;
    Public static Boolean firstCallUpdateOppAmmount= false;
    Public static Boolean firstCallPAK_PlannerEmail= false;
    
    /*---------- TRIGGERS PARA EL HISTÓRICO DE CAMPOS ----------*/
    //Esta bandera se va a utilizar en el trigger: PAK_ShipmentHistory  
	Public static Boolean PAK_ShipmentHistory= false;
    //Esta bandera se va a utilizar en el trigger: PAK_AccountHistory    
    Public static Boolean PAK_AccountHistory = false;
    //Esta bandera se va a utilizar en el trigger: PAK_ShipmentSL_History
    Public static Boolean PAK_ShipmentSL_History = false;
}