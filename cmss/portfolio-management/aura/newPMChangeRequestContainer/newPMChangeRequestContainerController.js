/**
 * Created by tadeas on 03.01.2023.
 */

({
    onRender: function(cmp) {
       console.log('render');
       cmp.find('modal').open();
    },
    onClose : function(cmp) {
       console.log('close');
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