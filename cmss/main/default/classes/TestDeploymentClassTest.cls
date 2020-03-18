@IsTest
private class TestDeploymentClassTest {
    @IsTest
    static void testTestDeploymentClass() {
        TestDeploymentClass cls = new TestDeploymentClass();
        System.debug(LoggingLevel.DEBUG, 'TEST3');
        System.debug(LoggingLevel.DEBUG, 'TEST4');
    }
}
