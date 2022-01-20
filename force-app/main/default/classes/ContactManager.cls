@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {
    @HttpPost
    global static ID createContact(
        String firstName,
        String lastName,
        String email,
        String phone,
        String accountId
    ) {
        Contact newContact = new Contact();
        // Find existing Salesforce contact by email, if present
        List<Contact> contacts = [
            SELECT Email
            FROM Contact
            WHERE Email = :email
        ];
        if (contacts.size() > 0) {
            // Set the contact Id to the Id of the existing record
            newContact.Id = contacts[0].Id;
        } else {
            // Otherwise, create new contact.
            newContact.FirstName = firstName;
            newContact.LastName = lastName;
            newContact.Email = email;
            newContact.Phone = phone;
            if (Helper.isAccount(accountId)) {
                newContact.AccountId = accountId;
            }
            insert newContact;
        }
        // Return the contact ID.
        return newContact.Id;
    }

    @HttpPatch
    global static ID updateContactFields() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1
        );
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
            request.requestbody.tostring()
        );
        // Iterate through each parameter field and value
        for (String fieldName : params.keySet()) {
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }

    @HttpDelete
    global static String deactivateContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1
        );
        Contact thisContact = [
            SELECT Id, Active__c
            FROM Contact
            WHERE Id = :contactId
        ];
        thisContact.Active__c = false;
        update thisContact;
        return 'The Contact ' +
            thisContact.Id +
            ' has been successfully deactivated.';
    }
}
