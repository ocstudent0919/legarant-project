@IsTest
    private class ContractManagerTest {
        static String URI = 'https://empathetic-hawk-424pxk-dev-ed.my.salesforce.com/services/apexrest/Contracts/';    
        @isTest static void testCreateContract() {
            // Create related account record
            Id accountId = Helper.createTestAccount();
            // Insert new contract record
            ID contractId = ContractManager.createContract(accountId, 'Draft', Date.valueOf('2022-1-2 00:00:00'), 12);
            // Verify new record was created
            System.assert(contractId != null);
            Contract contract = [SELECT AccountId,Status,StartDate,ContractTerm FROM Contract WHERE Id=:contractId];
            System.assert(contract != null);
            System.assertEquals(accountId, contract.AccountId);
            System.assertEquals('Draft', contract.Status);
            System.assertEquals('2022-01-02', String.valueOf(contract.StartDate));
            System.assertEquals(12, contract.ContractTerm);
        }    
        @isTest static void testUpdateContractFields() {
            Id recordId = Helper.createContractTestRecord();
            RestRequest request = new RestRequest();
            request.requestUri = URI + recordId;
            request.httpMethod = 'PATCH';
            request.addHeader('Content-Type', 'application/json');
            request.requestBody = Blob.valueOf('{"Status": "Activated", "StartDate" : "2022-2-1 00:00:00"}');
            RestContext.request = request;
            // Update phone number of existing record to new value
            ID thisContractId = ContractManager.updateContractFields();
            // Verify record was updated
            System.assert(thisContractId != null);
            Contract thisContract = [SELECT Status,StartDate FROM Contract WHERE Id=:thisContractId];
            System.assert(thisContract != null);
            System.assertEquals('Activated', thisContract.Status);
            System.assertEquals('2022-02-01', String.valueOf(thisContract.StartDate));
        }  
}
