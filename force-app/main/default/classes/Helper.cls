public with sharing class Helper {
    public static Id createContactTestRecord() {
        // Create test record for Contact
        Contact contactTest = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test-contact@gmail.com',
            Phone = '+33 145327899',
            AccountId = createTestAccount()
        );
        insert contactTest;
        return contactTest.Id;
    }

    public static Id createContractTestRecord() {
        // Create test record for Contract
        Contract contractTest = new Contract(
            AccountId = createTestAccount(),
            Status = 'Draft',
            StartDate = Date.valueOf('2022-1-2 00:00:00'),
            ContractTerm = 12
        );
        insert contractTest;
        return contractTest.Id;
    }

    public static Boolean isContactEmail(String email) {
        // Check if contact with specified email exists
        List<Contact> contacts = [
            SELECT Email
            FROM Contact
            WHERE Email = :email
        ];
        return contacts.size() > 0;
    }

    public static Boolean isAccount(Id accountId) {
        // Check if contact with specified email exists
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        return accounts.size() > 0;
    }

    public static Id createTestAccount() {
        // Cteate test record for Account
        Account account = new Account(Name = 'Test Account');
        insert account;
        return account.Id;
    }
}
