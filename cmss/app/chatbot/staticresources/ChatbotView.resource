(function (window, document, undefined) {
    "use strict";
    if (typeof CONFIG === "undefined") {
        var CONFIG = window.csobAdamRicky;
    }
    let STATES = {avatarDrawn: false}
    var rickyHTMLObject = null;
    let CLASSES = {
        chatWrapper: "ricky-main",
        chatWrapperShown: "ricky-shown",
        chatWrapperHidden: "ricky-hidden",
        chatContent: "ricky-chatlog",
        chatRestart: "ricky-restart",
        animated: "ricky-animated",
        chatMessage: "run-slide ricky-msg",
        botMessage: "ricky-bparty",
        userMessage: "ricky-aparty",
        typingDots: "ricky-typing-dots",
        buttonsWrapper: "ricky-buttons",
        buttonOuter: "ricky-button-wrap",
        buttonLink: "ricky-button-link",
        buttonInner: "ricky-button",
        buttonTitle: "ricky-button-text",
    };
    if (CONFIG.buildChatbotWindow) {
        let RICKY_IDS = {rickyModal: "the-ricky-modal",};
        let RICKY_CLASSES = {
            rickyHeader: "ricky-header",
            rickyHeaderMinimize: "ricky-header-minimize",
            rickyName: "ricky-bot-name",
            rickyHeaderButton: "ricky-show-hide",
            rickyShowButton: "ricky-show",
            rickyHideButton: "ricky-hide",
            rickyBody: "ricky-body",
            rickyChatform: "ricky-chatform",
            rickyInput: "ricky-text",
            modal: "ricky-modal",
            modalHeader: "ricky-modal-header",
            modalHeaderClose: "ricky-modal-close",
            modalContent: "ricky-modal-content",
        };
        let startInHiddenState = CONFIG.startInHiddenState;
        if (!CONFIG.ignoreShowHideCookie) {
            if (getCookie("ricky_visible") === "false") {
                startInHiddenState = true;
            }
            if (getCookie("ricky_visible") === "true") {
                startInHiddenState = false;
            }
        }
        var documentHead = document.getElementsByTagName("head")[0];
        var rickyCss = document.createElement("link");
        rickyCss.type = "text/css";
        rickyCss.rel = "stylesheet";
        rickyCss.href = CONFIG.assetDirectoryUrl + "css/ricky.css";
        documentHead.appendChild(rickyCss);
        var rickyMain = document.createElement("div");
        rickyMain.classList.add(CLASSES.chatWrapper);
        if (startInHiddenState) {
            rickyMain.classList.add(CLASSES.chatWrapperHidden);
        } else {
            rickyMain.classList.add(CLASSES.chatWrapperShown);
        }
        var rickyHeader = document.createElement("div");
        rickyHeader.setAttribute("class", RICKY_CLASSES.rickyHeader);
        rickyHeader.style.backgroundColor = CONFIG.qa.color;
        var rickyHeaderMinimize = document.createElement("div");
        rickyHeaderMinimize.className = RICKY_CLASSES.rickyHeaderMinimize;
        var rickyNameSpan = document.createElement("span");
        rickyNameSpan.setAttribute("class", RICKY_CLASSES.rickyName);
        rickyNameSpan.appendChild(document.createTextNode(CONFIG.qa.name));
        rickyHeaderMinimize.appendChild(rickyNameSpan);
        rickyHeader.appendChild(rickyHeaderMinimize);
        let rickyShowButton = document.createElement("a");
        rickyShowButton.setAttribute("class", RICKY_CLASSES.rickyHeaderButton);
        if (startInHiddenState) {
            rickyShowButton.classList.add(RICKY_CLASSES.rickyShowButton);
            rickyShowButton.appendChild(document.createTextNode("+"));
        } else {
            rickyShowButton.classList.add(RICKY_CLASSES.rickyHideButton);
            rickyShowButton.appendChild(document.createTextNode("-"));
        }
        rickyHeader.appendChild(rickyShowButton);
        let rickyRestartButton = document.createElement("a");
        rickyRestartButton.setAttribute("class", CLASSES.chatRestart);
        rickyRestartButton.appendChild(document.createTextNode("R"));
        rickyHeader.appendChild(rickyRestartButton);
        rickyMain.appendChild(rickyHeader);
        let rickyBody = document.createElement("div");
        rickyBody.setAttribute("class", RICKY_CLASSES.rickyBody);
        let rickyChatlog = document.createElement("div");
        rickyChatlog.setAttribute("class", CLASSES.chatContent);
        rickyBody.appendChild(rickyChatlog);
        let rickyChatform = document.createElement("div");
        rickyChatform.setAttribute("class", RICKY_CLASSES.rickyChatform);
        let rickyInput = document.createElement("input");
        rickyInput.setAttribute("class", RICKY_CLASSES.rickyInput);
        rickyInput.type = "text";
        rickyInput.placeholder = CONFIG.qa.placeholder;
        rickyChatform.appendChild(rickyInput);
        rickyBody.appendChild(rickyChatform);
        rickyMain.appendChild(rickyBody);
        rickyHTMLObject = rickyMain;
        let rickyModalWrapper = document.createElement("div");
        let rickyModal = document.createElement("div");
        rickyModal.setAttribute("id", RICKY_IDS.rickyModal);
        rickyModal.className = RICKY_CLASSES.modal;
        rickyModal.tabIndex = -1;
        let rickyModalHeader = document.createElement("div");
        rickyModalHeader.className = RICKY_CLASSES.modalHeader;
        let rickyModalClose = document.createElement("span");
        rickyModalClose.className = RICKY_CLASSES.modalHeaderClose;
        rickyModalClose.appendChild(document.createTextNode("x"));
        rickyModalHeader.appendChild(rickyModalClose);
        rickyModal.appendChild(rickyModalHeader);
        let rickyModalContent = document.createElement("div");
        rickyModalContent.className = RICKY_CLASSES.modalContent;
        rickyModal.appendChild(rickyModalContent);
        rickyModalWrapper.appendChild(rickyModal);
        document.body.appendChild(rickyModalWrapper);
        rickyModalClose.addEventListener("click", function () {
            rickyModal.style.display = "none";
        });
        window.onclick = function (event) {
            if (event.target == rickyModal) {
                rickyModal.style.display = "none";
            }
        }

        function getCookie(cname) {
            var name = cname + "=";
            var decodedCookie = decodeURIComponent(document.cookie);
            var ca = decodedCookie.split(";");
            for (var i = 0; i != ca.length; ++i) {
                var c = ca[i];
                while (c.charAt(0) == " ") {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return null;
        }

        function setCookie(cname, cvalue, days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 86400 * 1000));
            document.cookie = cname + "=" + cvalue
                + "; expires=" + date.toUTCString()
                + "; path=/";
        }

        function justShow() {
            rickyMain.classList.remove(CLASSES.chatWrapperHidden);
            void rickyMain.offsetWidth;
            rickyMain.classList.add(CLASSES.chatWrapperShown);
            rickyMain.classList.add(CLASSES.animated);
            rickyChatform.style.position = "absolute";
            rickyShowButton.innerText = "-";
            rickyShowButton.classList.remove(RICKY_CLASSES.rickyShowButton);
            void rickyShowButton.offsetWidth;
            rickyShowButton.classList.add(CLASSES.animated);
            rickyShowButton.classList.add(RICKY_CLASSES.rickyHideButton);
            setCookie("ricky_visible", "true", 30);
        }

        function justHide() {
            rickyMain.classList.remove(CLASSES.chatWrapperShown);
            void rickyMain.offsetWidth;
            rickyMain.classList.add(CLASSES.chatWrapperHidden);
            rickyMain.classList.add(CLASSES.animated);
            rickyChatform.style.position = "relative";
            rickyShowButton.innerText = "+";
            rickyShowButton.classList.remove(RICKY_CLASSES.rickyHideButton);
            void rickyShowButton.offsetWidth;
            rickyShowButton.classList.add(RICKY_CLASSES.rickyShowButton);
            rickyShowButton.classList.add(CLASSES.animated);
            setCookie("ricky_visible", "false", 30);
        }

        function showHide() {
            if (rickyShowButton.innerText == "-") {
                justHide();
            } else {
                justShow();
            }
            return false;
        }

        function inputListener(event) {
            if (event.keyCode == 13 && rickyInput.value.length > 0) {
                let msg = rickyInput.value;
                addUserBubble(msg);
                addTyping();
                CONFIG.sendMsg(msg, false);
                rickyInput.value = "";
                rickyInput.focus();
            }
        }

        rickyShowButton.addEventListener("click", showHide);
        rickyHeaderMinimize.addEventListener("click", showHide);
        rickyInput.addEventListener("keydown", inputListener);
    }

    function showModal(element) {
        let rickyModalContent = document.getElementsByClassName("ricky-modal-content")[0]
        let rickyModal = document.getElementsByClassName("ricky-modal")[0]
        while (rickyModalContent.firstChild) {
            rickyModalContent.removeChild(rickyModalContent.firstChild);
        }
        var copy = element.cloneNode();
        copy.width = "1000";
        copy.classList.remove("ricky-media");
        rickyModalContent.appendChild(copy);
        rickyModal.style.display = "block";
    }

    let chatContent = rickyHTMLObject.getElementsByClassName(CLASSES.chatContent)[0];
    let chatRestart = rickyHTMLObject.getElementsByClassName(CLASSES.chatRestart)[0];

    function createAvatarImage(imageSrc, isOffline) {
        var avatarElement = document.createElement("div");
        var avatarImageElement = document.createElement("img");
        avatarElement.id = "ricky-avatar";
        avatarImageElement.src = imageSrc;
        if (isOffline) {
            avatarImageElement.classList.add("grayscale");
        }
        avatarElement.appendChild(avatarImageElement);
        return avatarElement;
    }

    function addTyping() {
        let dots = document.createElement("div");
        dots.className = CLASSES.typingDots;
        setTimeout(function () {
            if (isTyping()) return;
            addBubble([dots], false);
        }, 200);
    }

    function isTyping() {
        return getTyping().length >= 1;
    }

    function getTyping() {
        return document.getElementsByClassName(CLASSES.typingDots);
    }

    function removeTyping() {
        if (!isTyping()) return;
        let dots = getTyping()[0];
        let msgNode = dots.parentNode;
        msgNode.parentNode.removeChild(msgNode);
    }

    function renderResponses(responses) {
        if (responses.length === 0) {
            removeTyping();
            return;
        }
        addTyping();
        let r = responses.shift();
        let payload = renderResponse(r);
        let delay = 500;
        let typingSpeed = 13;
        let textLength = 0;
        r.message.forEach(function (msg) {
            if (msg.type == "TEXT") textLength += msg.text.length;
        });
        setTimeout(function () {
            removeTyping();
            addBubble(payload, false);
            addButtons(r.buttons);
            if (responses.length > 0 && !isTyping()) {
                addTyping();
            }
            handleBubbleStyles();
            renderResponses(responses);
        }, delay + Math.min((textLength * typingSpeed), 1000));
    }

    function addUrlParam(url, key, value) {
        var newParam = key + "=" + value;
        var result = url.replace(new RegExp("(&|\\?)" + key + "=[^\&|#]*"), '$1' + newParam);
        if (result === url) {
            result = (url.indexOf("?") != -1 ? url.split("?")[0] + "?" + newParam + "&" + url.split("?")[1] : (url.indexOf("#") != -1 ? url.split("#")[0] + "?" + newParam + "#" + url.split("#")[1] : url + '?' + newParam));
        }
        return result;
    }

    function renderResponse(response) {
        let status = response.status;
        let msg = response.message;
        let recepient_id = response.recepient_id;
        let buttons = response.buttons;
        let isInit = response.isInitMessage;
        let payload = [];
        if (isInit && !STATES.avatarDrawn) {
            let avatar = createAvatarImage(CONFIG.assetDirectoryUrl + "img/avatar.png", status !== 200);
            chatContent.appendChild(avatar);
            chatContent.scrollTop = avatar.offsetTop;
            STATES.avatarDrawn = true;
        }
        msg.forEach(function (element) {
            let nodeLink;
            switch (element.type) {
                case "LINK":
                    nodeLink = document.createElement("a");
                    nodeLink.href = addUrlParam(element.url, CONFIG.trackingId, CONFIG.trackingCode);
                    nodeLink.setAttribute("target", "_blank");
                    nodeLink.appendChild(document.createTextNode(element.text));
                    payload.push(nodeLink);
                    break;
                case "TEXT":
                    payload.push(document.createTextNode(element.text));
                    break;
                case "MAIL":
                    nodeLink = document.createElement("a");
                    nodeLink.href = element.url;
                    nodeLink.appendChild(document.createTextNode(element.text));
                    payload.push(nodeLink);
                    break;
                case "PHONE":
                    nodeLink = document.createElement("a");
                    nodeLink.href = element.url;
                    nodeLink.appendChild(document.createTextNode(element.text));
                    payload.push(nodeLink);
                    break;
                case "IMAGE":
                    let nodeImg = document.createElement("img");
                    nodeImg.src = element.url;
                    nodeImg.className = "ricky-media";
                    nodeImg.style = "max-width: 100%; border-radius: 8px;";
                    payload.push(nodeImg);
                    if (CONFIG.buildChatbotWindow) {
                        nodeImg.addEventListener("click", function (ev) {
                            showModal(ev.srcElement);
                        });
                    }
                    break;
                case "VIDEO":
                    let nodeVideo;
                    if (element.url.indexOf(".mp4") != -1 || element.url.indexOf(".ogg") != -1 || element.url.indexOf(".webm") != -1) {
                        nodeVideo = document.createElement("video");
                        nodeVideo.style = "max-width: 100%; border-radius: 8px;";
                        nodeVideo.src = element.url;
                        nodeVideo.controls = true;
                        nodeVideo.appendChild(document.createTextNode("video nelze zobrazit na Vašem prohlížeči, zkuste tento "));
                        let errLinkNode = document.createElement("a");
                        errLinkNode.href = element.url;
                        nodeVideo.appendChild(errLinkNode);
                    } else {
                        nodeVideo = document.createElement("iframe");
                        nodeVideo.style = "max-width: 100%; border-radius: 8px;";
                        nodeVideo.src = element.url;
                    }
                    payload.push(nodeVideo);
                    break;
                default:
                    break;
            }
        });
        return payload;
    }

    function handleBubbleStyles() {
        let msgs = document.getElementsByClassName(CLASSES.chatContent)[0].children;
        for (let i = 0; i < msgs.length - 1; i++) {
            if (msgs[i].classList.contains(CLASSES.botMessage) && msgs[i + 1].classList.contains(CLASSES.buttonsWrapper) && !msgs[i].classList.contains("ricky-over")) {
                msgs[i].className += " ricky-over";
            }
        }
    }

    function addBubble(payload, me) {
        let node = document.createElement("div");
        node.className = CLASSES.chatMessage;
        node.classList.add(me ? CLASSES.userMessage : CLASSES.botMessage);
        if (CONFIG.buildChatbotWindow) {
            let lastBubble = document.querySelector(".ricky-chatlog > :last-child");
            if (lastBubble && me != lastBubble.classList.contains(CLASSES.userMessage)) {
                lastBubble.classList.add("ricky-over");
            }
        }
        if (me && CONFIG.buildChatbotWindow) {
            node.classList.add("ricky-over");
            node.style.backgroundColor = CONFIG.qa.color;
        }
        payload.forEach(function (p) {
            node.appendChild(p);
        });
        chatContent.appendChild(node);
        chatContent.scrollTop = node.offsetTop;
    }

    function addUserBubble(text) {
        let payload = [];
        payload.push(document.createTextNode(text));
        addBubble(payload, true);
    }

    function addButtons(btns) {
        if (!Array.isArray(btns) || btns.length === 0) {
            return;
        }
        let wrapper = document.createElement("div");
        wrapper.className = CLASSES.buttonsWrapper;
        btns.forEach(function (button) {
            if (button.type == "LINK") {
                let buttonOuter = document.createElement("a");
                buttonOuter.className = CLASSES.buttonLink;
                buttonOuter.setAttribute("href", button.payload);
                buttonOuter.setAttribute("target", "_blank");
                let buttonTitle = document.createElement("span");
                buttonTitle.className = CLASSES.buttonTitle;
                buttonTitle.appendChild(document.createTextNode(button.label));
                buttonOuter.appendChild(buttonTitle);
                wrapper.appendChild(buttonOuter);
            } else {
                let buttonOuter = document.createElement("div");
                buttonOuter.className = CLASSES.buttonOuter;
                let buttonInner = document.createElement("button");
                buttonInner.className = CLASSES.buttonInner;
                let buttonTitle = document.createElement("span");
                buttonTitle.className = CLASSES.buttonTitle;
                buttonTitle.appendChild(document.createTextNode(button.label));
                buttonInner.appendChild(buttonTitle);
                buttonInner.addEventListener("click", function (ev) {
                    chatContent.removeChild(buttonOuter.parentElement);
                    addUserBubble(button.label);
                    CONFIG.sendMsg(button.payload, false);
                });
                buttonOuter.appendChild(buttonInner);
                wrapper.appendChild(buttonOuter);
            }
        });
        chatContent.appendChild(wrapper);
        chatContent.scrollTop = wrapper.offsetTop;
    }

    function restartChat() {
        while (chatContent.hasChildNodes()) {
            chatContent.removeChild(chatContent.lastChild);
        }
        CONFIG.restartChat();
    }

    function init() {
        if (CONFIG.buildChatbotWindow) {
            document.body.appendChild(rickyHTMLObject);
        }
        CONFIG.renderMsg = renderResponses;
        chatRestart.addEventListener("click", function () {
            const restartClass = this.classList.item(0);
            this.classList.remove(restartClass);
            void this.offsetWidth;
            this.classList.add(CLASSES.animated);
            this.classList.add(restartClass);
            STATES.avatarDrawn = false;
            while (chatContent.hasChildNodes()) {
                chatContent.removeChild(chatContent.lastChild);
            }
            CONFIG.restartChat();
        });
    }

    CONFIG.initView = init;

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
