@isTest
public class TaskTriggerHandlerTest {
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
    
    @isTest
    public static void checkAccountUpdate(){
        User customusrRec = [select Id from User where UserName = 'testcustomusrRec1@usrRec.com'];
        
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin'];
        if(permissionSets.size() > 0){
            PermissionSetAssignment  assignPermission=   new PermissionSetAssignment(AssigneeId=customusrRec.Id, PermissionSetId=permissionSets[0].Id);
            insert assignPermission;
            
        }
        
        system.runAs(customusrRec){
            
            Account testAccount = new Account(Name='Test Account',AccountNumber = '12456788',Active__c = false);
            insert testAccount;
            
            Task taskList = [select Id,WhatId,Status,Description from Task where WhatId=:testAccount.Id limit 1];
            
            
            taskList.Status = 'Completed';
            update taskList;
            Account accountItem = [Select id,Active__c,Description from Account Where Id =: taskList.WhatId];
            system.Assert(accountItem.Active__c , 'Account should be Active');
            system.Assert(accountItem.Description == taskList.Description , 'Account Description is not updated');
        }
    }
    
}