@IsTest
private class DmlUtilTest {
	@IsTest
	static void cover() {
        DmlUtil dml = new DmlUtil();
        List<Account> listData = new List<Account>{
            TestDataFactory.getAccount()
        };
        Account singleRecord = TestDataFactory.getAccount();

        dml.insertData(listData);
        dml.insertData(singleRecord);
        dml.updateData(listData);
        dml.updateData(singleRecord);
        dml.deleteData(listData);
        dml.deleteData(singleRecord);
	}
}