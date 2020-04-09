/**
 * Created by tadeas on 24.03.2020.
 */
@IsTest
private class FlowHelperPicklistTest {
	@IsTest
	static void testBehavior() {
		Map<String, Object> inputParameters = new Map<String, Object>{
			'ObjectName' => 'Event',
			'FieldName' => 'Type',
			'ApiName' => 'test'
		};
		Process.PluginRequest request = new Process.PluginRequest(inputParameters);
		new FlowHelperPicklist().invoke(request);
	}

	@IsTest
	static void testDescribe() {
		Process.PluginDescribeResult result = new FlowHelperPicklist().describe();
		System.assertEquals(result.inputParameters.get(0).name, 'ObjectName');
		System.assertEquals(
			result.inputParameters.get(0).parameterType,
			Process.PluginDescribeResult.ParameterType.STRING
		);
		System.assertEquals(result.inputParameters.get(0).required, true);
		System.assertEquals(result.inputParameters.get(1).name, 'FieldName');
		System.assertEquals(
			result.inputParameters.get(1).parameterType,
			Process.PluginDescribeResult.ParameterType.STRING
		);
		System.assertEquals(result.inputParameters.get(1).required, true);
		System.assertEquals(result.inputParameters.get(2).name, 'ApiName');
		System.assertEquals(
			result.inputParameters.get(2).parameterType,
			Process.PluginDescribeResult.ParameterType.STRING
		);
		System.assertEquals(result.inputParameters.get(2).required, true);
		System.assertEquals(result.outputParameters.get(0).name, 'ItemValue');
		System.assertEquals(
			result.outputParameters.get(0).parameterType,
			Process.PluginDescribeResult.ParameterType.STRING
		);
	}
}
