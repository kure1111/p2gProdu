@isTest()
public class NEU_CartaPortePDF_Test {
   
     @isTest
    public static void runTestPDF()
    {
        Test.startTest();
        NEU_CartaPortePDF  aws = new NEU_CartaPortePDF();
        aws.test();
        Test.stopTest(); 
    }
     @isTest
    public static void runTestPDFSAVE()
    {
        Test.startTest();
        
        NEU_CartaPortePDF  aws = new NEU_CartaPortePDF();
        aws.test();
        Test.stopTest(); 
    }

}