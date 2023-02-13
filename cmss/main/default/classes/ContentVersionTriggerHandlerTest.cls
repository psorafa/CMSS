@IsTest
public class ContentVersionTriggerHandlerTest {
	public static void createContentVersion(String title, String path, String data) {
		ContentVersion cv = new ContentVersion(
			Title = title,
			PathOnClient = path,
			VersionData = EncodingUtil.base64Decode(data)
		);
		insert cv;
	}

	@IsTest
	static void contentVersionGoodTest() {
		createContentVersion('good file', '/GoodFile.pdf', 'abc');
		ContentVersion cv = [SELECT Id, Title FROM ContentVersion WHERE Title = 'good file' LIMIT 1];
		System.assertEquals('good file', cv.Title);
	}

	@IsTest
	static void contentVersionWrongTest() {
		try {
			createContentVersion('wrong file', '/GoodFile.exe', 'abc');
		} catch (Exception e) {
			List<ContentVersion> cv = [SELECT Id, Title FROM ContentVersion WHERE Title = 'wrong file'];
			System.assertEquals(0, cv.size());
		}
	}
}
