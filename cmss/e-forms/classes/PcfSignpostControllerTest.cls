/**
 * Created by lukas.krbec on 08.06.2022.
 */

@IsTest
private class PcfSignpostControllerTest {
    @TestSetup
    static void testSetup() {
    }
    @IsTest
    static void getRelatedMigrationProcessesTest() {
        Test.startTest();
        List<PcfSignpostController.WrapedProcess> returnedProcesses = PcfSignpostController.getRelatedMigrationProcesses('');
        Test.stopTest();
        List<Migration_Process__mdt> processes = [SELECT Id FROM Migration_Process__mdt];
        System.assertEquals(processes.size(),returnedProcesses.size());
    }
}