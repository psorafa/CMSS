({
    onRender: function(cmp) {
       cmp.find('modal').open();
    },
    onClose : function(cmp) {
        var navigation = cmp.find("navigation");
        navigation.navigate({
            "type": "standard__objectPage",
            "attributes": {
                "objectApiName": "Case",
                "actionName": "home",
            }
        });
    }
});