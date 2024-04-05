@isTest
public class AccountTriggerHandlerTest {
    @testSetup
    static void Setup(){
        List<Profile> profiles = [SELECT ID FROM Profile WHERE Name = 'Standard User'];
        
        User usrRec = new User();
        usrRec.username =  'testcustomusrRec1@usrRec.com';
        usrRec.Email = 'testcustomusrRec1@gmail.com';
        usrRec.FirstName =  'atest';
        usrRec.LastName = 'usrRec1';
        usrRec.CommunityNickname = 'tusrRec';
        usrRec.ProfileId = profiles[0].Id;
        
        usrRec.Alias =  'tusrRec';
        usrRec.EmailEncodingKey = 'UTF-8';
        usrRec.LanguageLocaleKey = 'en_US';
        usrRec.LocaleSidKey = 'en_US';
        usrRec.TimeZoneSidKey = 'America/Los_Angeles';
        
        insert usrRec;
    }
    //Check Task is created or not when account is Inserted.
    @isTest
    public static void checkTaskCreation(){
        User customusrRec = [select Id from User where UserName = 'testcustomusrRec1@usrRec.com'];
        system.runAs(customusrRec){
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            testAccount.AccountNumber = '12456788';
            testAccount.Active__c = false;
            insert testAccount;
            
            Task TaskList = [Select id,Subject,Status,WhatId from Task where WhatId =:testAccount.Id limit 1];
            system.Assert(TaskList != null,'Task should be created.');
            system.Assert(taskList.Subject.contains('Review Account-'+testAccount.AccountNumber) , 'Task Subject should be like "Review Account-<Account Number>');
            system.Assert(taskList.ActivityDate == System.today().addDays(7) , 'Task Due date should be After a week');
            system.Assert(taskList.Status == 'Not Started' , 'Task Status should be Not Started');
        }
    }
    
    //Check Task is updated or not when account activation is updated.
    @isTest
    public static void checkTaskUpdate(){
        
        User customusrRec = [select Id from User where UserName = 'testcustomusrRec1@usrRec.com'];
        
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin'];
        if(permissionSets.size() > 0){
            PermissionSetAssignment  assignPermission=   new PermissionSetAssignment(AssigneeId=customusrRec.Id, PermissionSetId=permissionSets[0].Id);
            insert assignPermission;
            
        }
        
        system.runAs(customusrRec){
            
            Account testAccount = new Account();
            testAccount.Name='Test Account';
            testAccount.AccountNumber = '12456788';
            testAccount.Active__c = false;
            insert testAccount;
            
            //Account Acc = [select Id,Name,Active__c from Account limit 1];
            testAccount.Active__c = true;
            update testAccount;
            
            
            List<Task> TaskList = [Select id,Status,WhatId from Task where WhatId =:testAccount.Id];
            system.Assert(TaskList[0].Status == 'Completed','Task status is not updated.');
        }
        
    }
}