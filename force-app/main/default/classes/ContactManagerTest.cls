@IsTest
private class ContactManagerTest {
    static String URI = 'https://empathetic-hawk-424pxk-dev-ed.my.salesforce.com/services/apexrest/Contacts/';
    @isTest
    static void testDeactivateContact() {
        Id recordId = Helper.createContactTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = URI + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        ContactManager.deactivateContact();
        // Verify Contact record is deactivated
        Contact thisContact = [
            SELECT Active__c
            FROM Contact
            WHERE Id = :recordId
        ];
        System.assert(thisContact.Active__c == false);
    }

    @isTest
    static void testCreateContact() {
        // Create related account record
        Id accountId = Helper.createTestAccount();
        // 1. Verify that new contact email doesn't exist in Salesforce
        System.assertEquals(
            false,
            Helper.isContactEmail('test-contact@gmail.com'),
            'A contact with the same email address exists.'
        );
        // Insert new contact record
        ID contactId = ContactManager.createContact(
            'Test',
            'Contact',
            'test-contact@gmail.com',
            '+33 145327811',
            accountId
        );
        // Verify new record was created
        System.assert(contactId != null);
        Contact contact1 = [
            SELECT Name, Email, Phone, AccountId
            FROM Contact
            WHERE Id = :contactId
        ];
        System.assert(contact1 != null);
        System.assertEquals('Test Contact', contact1.Name);
        System.assertEquals('test-contact@gmail.com', contact1.Email);
        System.assertEquals('+33 145327811', contact1.Phone);
        System.assertEquals(accountId, contact1.AccountId);
        // 2. Verify that Contact email already exists in Salesforce
        System.assertEquals(
            true,
            Helper.isContactEmail('test-contact@gmail.com'),
            'There should be a contact with the same email address.'
        );
        // Insert Contact record with existing email address and new phone number
        ID contact2Id = ContactManager.createContact(
            'Test',
            'Contact',
            'test-contact@gmail.com',
            '+33 145327822',
            accountId
        );
        // Verify that Contact takes the Id of the existing record
        System.assertEquals(contactId, contact2Id);
        // Verify Contact record keeps initial phone number
        Contact contact2 = [SELECT Phone FROM Contact WHERE Id = :contact2Id];
        System.assert(contact2 != null);
        System.assertNotEquals('+33 145327822', contact2.Phone);
        System.assertEquals(contact1.Phone, contact2.Phone);
    }
    @isTest
    static void testUpdateContactFields() {
        Id recordId = Helper.createContactTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri = URI + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone": "+33 145327800"}');
        RestContext.request = request;
        // Update phone number of existing record to new value
        ID thisContactId = ContactManager.updateContactFields();
        // Verify record was updated
        System.assert(thisContactId != null);
        Contact thisContact = [
            SELECT Phone
            FROM Contact
            WHERE Id = :thisContactId
        ];
        System.assert(thisContact != null);
        System.assertEquals('+33 145327800', thisContact.Phone);
    }
}
