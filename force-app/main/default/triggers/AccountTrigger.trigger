trigger AccountTrigger on Account (before insert,after insert,after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.insertTaskWhenAccountCreated(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.updateTaskWhenAccountActivated(Trigger.oldMap,Trigger.newMap);
    }
    

}