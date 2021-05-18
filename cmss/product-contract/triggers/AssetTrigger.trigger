trigger AssetTrigger on Asset (after insert) {
    new AssetTriggerHandler().run();
}