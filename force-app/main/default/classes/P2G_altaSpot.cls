public class P2G_altaSpot {
    public static void processMessage(String message) {
        System.debug('Message__c: ' + message);
        message = message.replaceAll('\\s', ''); // Elimina espacios en blanco
        String searchString = 'LeadCreadoNo.:';
        try {
            if (message.contains(searchString)) {
                Integer startIndex = message.indexOf(searchString) + searchString.length();
                String leadNumber = message.substring(startIndex);            
                leadNumber = leadNumber.replaceAll('[^a-zA-Z0-9_]*$', '');
                System.debug('leadNumber: ' + leadNumber);
                List<Customer_Quote__c> quotesToUpdate = [SELECT Id, Quotation_Status__c
                                                          FROM Customer_Quote__c
                                                          WHERE Account_for__r.Customer_Id__c = :leadNumber LIMIT 1];
                if (!quotesToUpdate.isEmpty()) {
                    quotesToUpdate[0].Quotation_Status__c = 'Approved as Succesful';
                    update quotesToUpdate[0];
                }
            }
        } catch (Exception e) {
            System.debug('Error ' + e.getLineNumber());
        }
    }
}