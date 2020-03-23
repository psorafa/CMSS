/**
* Translating picklist value by user language. Called from lightning flows.
* Based on:
* https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_process_plugin.htm
* https://ipfs-sec.stackexchange.cloudflare-ipfs.com/salesforce/A/question/50782.html
* @author Robert Srna
*/
global class FlowHelperPicklist implements Process.Plugin { 

   global Process.PluginResult invoke(Process.PluginRequest request) { 
       String objectName = (String) request.inputParameters.get('ObjectName');
       String fieldName = (String) request.inputParameters.get('FieldName');
       String apiName = (String) request.inputParameters.get('ApiName');
       String itemValue;
       
       Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
       Schema.DescribeSObjectResult r = s.getDescribe() ;
       Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
       Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry pickListVal : ple){
           if(pickListVal.getValue()==apiName) {
               itemValue = pickListVal.getLabel();
               break;
           }
       }         
       
      Map<String,Object> result = new Map<String,Object>();
      result.put('ItemValue', itemValue);
      System.debug('result:' + result);
      return new Process.PluginResult(result);
   }
        
    
   global Process.PluginDescribeResult describe() { 
      Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
      result.Name = 'Get translated picklist item';
      result.Tag = 'Picklist values';
      result.inputParameters = new 
         List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter('ObjectName', 
            Process.PluginDescribeResult.ParameterType.STRING, true), 
            new Process.PluginDescribeResult.InputParameter('FieldName', 
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('ApiName', 
            Process.PluginDescribeResult.ParameterType.STRING, true)                
         }; 
      result.outputParameters = new 
         List<Process.PluginDescribeResult.OutputParameter>{              
            new Process.PluginDescribeResult.OutputParameter('ItemValue', 
            Process.PluginDescribeResult.ParameterType.STRING)
                }; 
      return result; 
   }
}