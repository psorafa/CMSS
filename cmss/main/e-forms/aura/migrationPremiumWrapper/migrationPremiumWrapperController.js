/**
 * Created by stanislav.vyhlidal on 11.02.2021.
 */

({
    doInit: function(component) {
        var recordId;
        var migrationLabel;
        var migrationProcess;
        var templateCode;

        try {
            recordId = component.get("v.pageReference").state.c__recId;
            migrationLabel = component.get("v.pageReference").state.c__migrationLabel;
            migrationProcess = component.get("v.pageReference").state.c__migrationProcess;
        } catch (err) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;
            console.log(sURLVariables);
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                console.log(sParameterName);
                if (sParameterName[0] === 'c__recId') {
                    sParameterName[1] === undefined ? true : sParameterName[1];
                    recordId = sParameterName[1];
                }
                if (sParameterName[0] === 'c__migrationLabel') {
                    sParameterName[1] === undefined ? true : sParameterName[1];
                    migrationLabel = sParameterName[1];
                }
                if (sParameterName[0] === 'c__migrationProcess') {
                    sParameterName[1] === undefined ? true : sParameterName[1];
                    migrationProcess = sParameterName[1];
                }
                if (sParameterName[0] === 'c__template') {
                    sParameterName[1] === undefined ? true : sParameterName[1];
                    templateCode = sParameterName[1];
                }

            }
        }

        if (templateCode) {
            var migrationPremiumUrl = '/apex/renderAsPdf?caseId=' + recordId + '&template=' + templateCode;
        } else {
            var openTime = new Date().getTime();
            var migrationPremiumUrl = '/apex/MigrationPremium?migration_process=' + migrationProcess + '&open_time=' + openTime;
            var action = component.get("c.getRecord");
            action.setParams({
                recordId: recordId,
                objectName: recordId && recordId.startsWith('500') ? 'Case' : 'Asset'
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnedObject = response.getReturnValue();
                    console.log('returnedObject: ', returnedObject);
                    if (recordId.startsWith('500')) {
                        if (returnedObject.objectStatus === '10') {
                            migrationPremiumUrl += '&caseId=' + recordId + '&edit=1' + '&accountId=' + returnedObject.objectId;
                        } else {
                            migrationPremiumUrl += '&caseId=' + recordId + '&accountId=' + returnedObject.objectId;
                        }
                    } else {
                        migrationPremiumUrl += '&assetId=' + recordId + '&accountId=' + returnedObject.objectId;
                    }
                    console.log('test: ', migrationPremiumUrl);
                    component.set("v.migrationPremiumUrl", migrationPremiumUrl);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);


            component.set("v.openTime", openTime);
            //var workspaceAPI = component.find("workspace");
            /* workspaceAPI.getFocusedTabInfo().then(function(response) {
                let idOfRelevantTab = response.tabId;
                            //money
                            workspaceAPI.setTabLabel({
                                tabId: '',
                                label: ' ' + migrationLabel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: '',
                                icon: 'utility:currency',
                                iconAlt: migrationLabel
                            });

            })
            .catch(function(error) {
                console.log(error);
            });*/

            var activeListener = false;
            var messageCallback = $A.getCallback(function(event) {
                var openTime2 = new Date().getTime();
                component.set("v.openTime2", openTime2);
                var parsedData = JSON.parse(event.data);
                var actionName = parsedData.action;
                var targetUrl = parsedData.url;
                var subTabName = parsedData.subTabName;
                if (targetUrl && targetUrl.includes('quoteTemplate')) {
                    var pageReference = {
                        type: 'standard__webPage',
                        attributes: {
                            url: targetUrl
                        }
                    };
                } else {
                    var pageReference = {
                        type: "standard__recordPage",
                        attributes: {
                            "recordId": targetUrl,
                            "objectApiName": "Case",
                            "actionName": "view"
                        }
                    };
                }
                console.log('standa url ', targetUrl);
                /*let message = {
                    objectApiName: 'Quote',
                    source: "migrationPremiumWrapper"
                };
                if(component.find("recordChangedMessage")){
                    component.find("recordChangedMessage").publish(message);
                }*/
                switch (actionName) {
                    case "openSubTabAndCloseCurrentSubTab":
                        console.log('openSubTabAndCloseCurrentSubTab akce');
                        $A.enqueueAction(component.get('c.closeCurrentSubTab'));
                        navService.generateUrl(pageReference).then(function(cmpURL) {
                            workspaceAPI
                                .getEnclosingTabId()
                                .then(function(tabId) {
                                    return workspaceAPI.openSubtab({
                                        parentTabId: tabId,
                                        url: cmpURL,
                                        focus: true
                                    });
                                })
                        });
                        break;
                    case "closeCurrentSubTab":
                        console.log('closeCurrentSubTab akce');
                        $A.enqueueAction(component.get('c.closeCurrentSubTab'));
                        break;
                    case "openSubTabWithNewUrl":
                        console.log('openSubTabWithNewUrl akce');
                        var navService = component.find("navService");
                        //navService.navigate(pageReference);
                        navService.generateUrl(pageReference)
                            .then($A.getCallback(function(url) {
                                window.location.assign(url);
                            }));
                        break;
                    default:
                        console.log('NO ACTION AVAILABLE');
                }
            });
            window.addEventListener("message", function(evt) {
                try {
                    if (evt.data) {
                        var parsedData = JSON.parse(evt.data);
                        console.log('test: ', evt.data);
                        if (parsedData.openTime == openTime) {
                            messageCallback(evt);
                        }
                    }
                } catch (error) {
                    console.error('migrationPremiumWrapper error : ', error);
                }
            });

            window.addEventListener("IstsLoaded", function(evt) {

                var data = evt.detail;
                var openTime2 = component.get('v.openTime2');

                //todo posilat si url te stranky nejak z istsIframeGDPRPage
                var standaOrigin = data.hostName;
                if (data.open_time_wrapper == openTime2) {
                    var iframe = component.find("migrationIframe").getElement().contentWindow;
                    iframe.postMessage(JSON.stringify(data), standaOrigin);
                }
            });
        }
    },
    /* onRender : function(cmp,event){
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                })
                .catch(function(error) {
                    console.log(error);
                });
     },*/


    closeCurrentSubTab: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
                let idOfRelevantTab = response.tabId;
                let listOfSubTabs = response.subtabs;
                //                            window.dispatchEvent(new CustomEvent('ReloadPage'));
                workspaceAPI.closeTab(listOfSubTabs);
            })
            .catch(function(error) {
                console.log(error);
            });
    }
});