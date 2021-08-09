@IsTest
private class SearchControllerTest {
	@IsTest
	static void testBehavior() {
		SearchController.search('User', new List<String>{ 'Name', 'Email'}, 'test');
	}
}