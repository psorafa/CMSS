(function (window, document, undefined) {
    "use strict";
    if (typeof CONFIG === "undefined") {
        var CONFIG = window.csobAdamRicky;
    }
    let user_uuid = "None_" + Date.now();
    let INITIAL_INTENT = CONFIG.initialIntent;
    let RESTART_INTENT = CONFIG.restartIntent;
    const linkRegex = /\[([^\[\]]+?)\]\(((?:ftp|http|https):\/\/(?:\w+:{0,1}\w*@)?(?:\S+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:.?+=&%@!\-\/]))?)\)/g;
    const linkRegexGroup = /(\[(?:[^\[\]]+?)\]\((?:(?:ftp|http|https):\/\/(?:\w+:{0,1}\w*@)?(?:\S+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:.?+=&%@!\-\/]))?)\))/g;
    const mailtoRegex = /\[([^\[\]]+?)\]\((mailto:(?:[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+))\)/g;
    const mailtoRegexGroup = /(\[(?:[^\[\]]+?)\]\((?:mailto:(?:[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+))\))/g;
    const telephoneRegex = /\[([^\[\]]+?)\]\((tel:(?:[0-9+-]+))\)/g;
    const telephoneRegexGroup = /(\[(?:[^\[\]]+?)\]\((?:tel:(?:[0-9+-]+))\))/g;
    const imageRegex = /\[\[((?:ftp|http|https):\/\/(?:\w+:{0,1}\w*@)?(?:\S+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:.?+=&%@!\-\/]))?)\]\]/g;
    const imageRegexGroup = /(\[\[(?:ftp|http|https):\/\/(?:\w+:{0,1}\w*@)?(?:\S+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:.?+=&%@!\-\/]))?\]\])/g;
    const videoRegex = /\(\(((?:ftp|http|https):\/\/(?:\w+:{0,1}\w*@)?(?:\S+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:.?+=&%@!\-\/]))?)\)\)/g;
    const videoRegexGroup = /(\(\((?:ftp|http|https):\/\/(?:\w+:{0,1}\w*@)?(?:\S+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:.?+=&%@!\-\/]))?\)\))/g;
    let msgTypes = [{TYPE: "LINK", RGX: linkRegex, RGX_GROUP: linkRegexGroup, KEYS: ["text", "url"]}, {
        TYPE: "MAIL",
        RGX: mailtoRegex,
        RGX_GROUP: mailtoRegexGroup,
        KEYS: ["text", "url"]
    }, {TYPE: "PHONE", RGX: telephoneRegex, RGX_GROUP: telephoneRegexGroup, KEYS: ["text", "url"]}, {
        TYPE: "IMAGE",
        RGX: imageRegex,
        RGX_GROUP: imageRegexGroup,
        KEYS: ["url"]
    }, {TYPE: "VIDEO", RGX: videoRegex, RGX_GROUP: videoRegexGroup, KEYS: ["url"]},];

    function uuidv4() {
        return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
            let r = Math.random() * 16 | 0, v = c == "x" ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    function randomElement(arr) {
        return arr[Math.floor(Math.random() * arr.length)];
    }

    function sendMessage(text, isInit) {
        let data = JSON.stringify({"sender": user_uuid, "message": text});
        let xhr = new XMLHttpRequest();
        xhr.addEventListener("readystatechange", function () {
            if (this.readyState == 4) {
                let responses = [];
                if (this.status == 200) {
                    let response = JSON.parse(this.responseText);
                    response.forEach(function (r) {
                        let texts = r.text.split("##");
                        let h = null;
                        for (var j = 0; j < texts.length - 1; j++) {
                            h = handleResponse({"recipient_id": r.recipient_id, "text": texts[j]}, 200, isInit);
                            responses.push(h);
                        }
                        if (texts[texts.length - 1] !== undefined) {
                            if (r.buttons !== undefined) {
                                h = handleResponse({
                                    "recipient_id": r.recipient_id,
                                    "text": texts[texts.length - 1],
                                    "buttons": r.buttons
                                }, 200, isInit);
                            } else {
                                h = handleResponse({
                                    "recipient_id": r.recipient_id,
                                    "text": texts[texts.length - 1]
                                }, 200, isInit);
                            }
                            responses.push(h);
                        }
                    });
                } else {
                    let h = handleResponse(null, this.status, isInit);
                    responses.push(h);
                    CONFIG.renderMsg(h);
                }
                const flattenResponses = responses.reduce(function (a, b) {
                    return a.concat(b);
                });
                CONFIG.renderMsg(flattenResponses);
            }
        });
        xhr.open("POST", CONFIG.chatUrl);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.send(data);
    }

    function restartChat() {
        sendMessage(RESTART_INTENT, false);
        sendMessage(INITIAL_INTENT, true);
    }

    function handleResponse(response, status, isInit) {
        let preparedResp = {
            "status": status,
            "recepient_id": user_uuid,
            "message": [{type: "TEXT", text: randomElement(CONFIG.responseOffline)}],
            "buttons": [],
            "isInitMessage": isInit,
        };
        if (status === 200) {
            let parsedMsgs = [];
            let msgs = [response.text];
            for (var i = 0; i < msgTypes.length; i++) {
                let newMsgs = [];
                for (var j = 0; j < msgs.length; j++) {
                    newMsgs.push(msgs[j].split(msgTypes[i].RGX_GROUP));
                }
                msgs = newMsgs.reduce(function (a, b) {
                    return a.concat(b);
                });
            }
            for (var i = 0; i < msgs.length; i++) {
                let newMsg = {type: "TEXT", text: msgs[i]};
                for (var j = 0; j < msgTypes.length; j++) {
                    let match = msgTypes[j].RGX.exec(msgs[i]);
                    if (match) {
                        newMsg = {type: msgTypes[j].TYPE}
                        for (var k = 0; k < msgTypes[j].KEYS.length; k++) {
                            newMsg[msgTypes[j].KEYS[k]] = match[k + 1];
                        }
                    }
                }
                if (newMsg.type === "TEXT") {
                    let texts = newMsg.text.split("##");
                    for (var j = 0; j < texts.length; j++) {
                        if (texts[j].trim().length === 0) continue;
                        parsedMsgs.push({type: "TEXT", text: texts[j]});
                    }
                } else {
                    parsedMsgs.push(newMsg);
                }
            }
            let buttons = [];
            if ("buttons" in response) {
                response.buttons.forEach(function (element) {
                    let BUTTONLINK_REGEX = /^#(.+?)#$/;
                    let buttonLinkMatch = BUTTONLINK_REGEX.exec(element.payload);
                    if (buttonLinkMatch) {
                        buttons.push({type: "LINK", payload: buttonLinkMatch[1], label: element.title});
                    } else {
                        buttons.push({type: "BUTTON", payload: element.payload, label: element.title});
                    }
                });
            }
            let parsedResponses = [];
            let continuousMessage = [];
            for (var i = 0; i < parsedMsgs.length - 1; i++) {
                continuousMessage.push(parsedMsgs[i]);
                if (parsedMsgs[i].type === "TEXT" && parsedMsgs[i + 1].type === "TEXT") {
                    parsedResponses.push({
                        "buttons": null,
                        "recepient_id": response.recipient_id,
                        "message": [].concat(continuousMessage),
                        "status": status,
                        "isInitMessage": isInit,
                    });
                    continuousMessage = [];
                } else if (parsedMsgs[i + 1].type === "VIDEO" || parsedMsgs[i + 1].type === "IMAGE") {
                    parsedResponses.push({
                        "buttons": null,
                        "recepient_id": response.recipient_id,
                        "message": [].concat(continuousMessage),
                        "status": status,
                        "isInitMessage": isInit,
                    });
                    continuousMessage = [];
                } else if (parsedMsgs[i].type === "VIDEO" || parsedMsgs[i].type === "IMAGE") {
                    parsedResponses.push({
                        "buttons": null,
                        "recepient_id": response.recipient_id,
                        "message": [].concat(continuousMessage),
                        "status": status,
                        "isInitMessage": isInit,
                    });
                    continuousMessage = [];
                }
            }
            if (continuousMessage.length > 0) {
                continuousMessage.push(parsedMsgs[parsedMsgs.length - 1]);
                parsedResponses.push({
                    "buttons": buttons,
                    "recepient_id": response.recipient_id,
                    "message": continuousMessage,
                    "status": status,
                    "isInitMessage": isInit
                });
            } else {
                parsedResponses.push({
                    "buttons": buttons,
                    "recepient_id": response.recipient_id,
                    "message": [parsedMsgs[parsedMsgs.length - 1]],
                    "status": status,
                    "isInitMessage": isInit
                });
            }
            return parsedResponses;
        } else if (status === 429) {
            preparedResp = {
                "status": status,
                "recepient_id": response.recipient_id,
                "message": [{type: "TEXT", text: randomElement(CONFIG.response429)}],
                "isInitMessage": false,
                "buttons": [],
            };
        }
        return [preparedResp];
    }

    function init() {
        CONFIG.sendMsg = sendMessage;
        CONFIG.restartChat = restartChat;
        user_uuid = uuidv4();
        sendMessage(INITIAL_INTENT, true);
    }

    CONFIG.initController = init;

    function ready(fn) {
        if(CONFIG.initChatbot) {
            if (document.readyState !== 'loading') {
                fn();
            } else if (document.addEventListener) {
                document.addEventListener('DOMContentLoaded', fn);
            } else {
                document.attachEvent('onreadystatechange', function () {
                    if (document.readyState !== 'loading')
                        fn();
                });
            }
        }
    }
    ready(init);
})(window, document);