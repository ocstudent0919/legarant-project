@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {
    @HttpPost
    global static ID createContract(
        String accountId,
        String status,
        Date startDate,
        Integer contractTerm
    ) {
        // Create new contract instance
        Contract newContract = new Contract(
            AccountId = accountId,
            Status = status,
            StartDate = startDate,
            ContractTerm = contractTerm
        );
        // Insert contract to database
        insert newContract;
        return newContract.Id;
    }
    @HttpPatch
    global static ID updateContractFields() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1
        );
        Contract thisContract = [
            SELECT Id
            FROM Contract
            WHERE Id = :contractId
        ];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
            request.requestbody.tostring()
        );
        // Iterate through each parameter field and value
        for (String fieldName : params.keySet()) {
            // Set the value for 'StartDate' field on the Contract sObject
            if (fieldName == 'StartDate') {
                String startDate = (String) params.get(fieldName);
                thisContract.put(fieldName, Date.valueOf(startDate));
            } else {
                // Set the value for other fields on the Contract sObject
                thisContract.put(fieldName, params.get(fieldName));
            }
        }
        update thisContract;
        return thisContract.Id;
    }
}
