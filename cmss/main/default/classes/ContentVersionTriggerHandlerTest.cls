@IsTest
public class ContentVersionTriggerHandlerTest {
	public static void createContentVersion(String title, String path, String data) {
		ContentVersion cv = new ContentVersion(
			Title = title,
			PathOnClient = path,
			VersionData = EncodingUtil.convertFromHex(data)
		);
		insert cv;
	}

	@IsTest
	static void contentVersionGoodTest() {
		createContentVersion('good file', '/GoodFile.pdf', '255044462dbbbbbbbbbbbbbbbbbbbbbbba');
		ContentVersion cv = [SELECT Id, Title FROM ContentVersion WHERE Title = 'good file' LIMIT 1];
		System.assertEquals('good file', cv.Title);
	}

	@IsTest
	static void contentVersionWrongExtensionTest() {
		try {
			createContentVersion('wrong file', '/GoodFile.exe', 'abcdddddddddddddddddddddddddddddda');
		} catch (Exception e) {
			List<ContentVersion> cv = [SELECT Id, Title FROM ContentVersion WHERE Title = 'wrong file'];
			System.assertEquals(0, cv.size());
		}
	}

	@IsTest
	static void contentVersionWrongSignatureTest() {
		try {
			createContentVersion('wrong file', '/GoodFile.doc', 'abcdddddddddddddddddddddddddddddda');
		} catch (Exception e) {
			List<ContentVersion> cv = [SELECT Id, Title FROM ContentVersion WHERE Title = 'wrong file'];
			System.assertEquals(0, cv.size());
		}
	}
}
