public class TaskTriggerHandler {
    
    //Update Active checkbox in Account to true, when related task is completed.
    public static void activateAccountWhenTaskIsCompleted(List<Task>TaskList,Map<Id,Task> OldTasksMap){
        
        List<Account> accountListToUpdate = new List<Account>(); 
        Set<Id> AccIds = new Set<Id>();
        for(Task taskItem : TaskList){
            if(taskItem.Status == 'Completed' && OldTasksMap.get(taskItem.Id).Status != taskItem.Status){
                Schema.SObjectType sobjectType = (taskItem.WhatId).getSObjectType();
                String sobjectName = sobjectType.getDescribe().getName();
                if(sobjectName == 'Account'){
                    Account taskAccount = new Account();
                    taskAccount.Id = taskItem.WhatId;
                    taskAccount.Description = taskItem.Description;
                    taskAccount.Active__c = true;
                    if(!AccIds.contains(taskItem.WhatId)){
                        AccIds.add(taskItem.WhatId);
                        accountListToUpdate.add(taskAccount);
                    }
                }
            }
        }
        if(!accountListToUpdate.isEmpty()){
            update accountListToUpdate;
        }
    }
    
}