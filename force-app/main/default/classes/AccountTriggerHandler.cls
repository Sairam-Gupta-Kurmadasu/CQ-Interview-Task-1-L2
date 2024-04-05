public class AccountTriggerHandler {
    
    //Creating Task When Account Created
    public static void insertTaskWhenAccountCreated(List<Account> AccList){
        
        List<Task> taskListToInsert = new List<Task>();
        
        for(Account accItem : AccList){
            Task accountTask = new Task();
            accountTask.Subject = 'Review Account- '+accItem.AccountNumber;
            accountTask.ActivityDate = system.today().addDays(7);
            accountTask.OwnerId = accItem.OwnerId;
            accountTask.Status = 'Not Started';
            accountTask.WhatId = accItem.Id;
            taskListToInsert.add(accountTask);
        }
        
        if(!taskListToInsert.isEmpty()){
            insert taskListToInsert;
        }
    }
    
    //Updating the related task of Account, when Account Activated
    public static void updateTaskWhenAccountActivated(Map<Id,Account> oldAccountMap, Map<Id,Account> newAccountMap){
        List<Account> UpdateAccounts = new List<Account>();
        List<Task> taskList = [Select id,Subject, Status,WhatId,Description from Task Where WhatId IN: oldAccountMap.keySet() AND Subject like 'Review Account-%'];
        List<Task> taskListToUpdate = new List<Task>();
        if(!taskList.isEmpty()){
            for(Task TaskItem : taskList){
                if(newAccountMap.get(TaskItem.WhatId).Active__c && newAccountMap.get(TaskItem.WhatId).Active__c != oldAccountMap.get(TaskItem.WhatId).Active__c){
                    TaskItem.Status = 'Completed';
                    taskListToUpdate.add(TaskItem);
                }
            }
            if(!taskListToUpdate.isEmpty()){
                Update taskListToUpdate;
            }
        }
    }
}