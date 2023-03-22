window.csobAdamRicky = window.csobAdamRicky || {
    initialIntent: "/init",
    restartIntent: "/restart",
    chatUrl: "https://internal.chatbot.csob.cz/ondra/api/chat",
    assetDirectoryUrl: "https://internal.chatbot.csob.cz/ondra/",
    response429: ['Ne tak rychle, zavaříte mi obvody.'],
    responseOffline: ['Ajaj, zřejmě zlobí připojení, proto jsem momentálně offline. Zkuste to prosím znovu nebo za chvilku.'],
    startInHiddenState: true,
    ignoreShowHideCookie: false,
    buildChatbotWindow: true,
    initChatbot: true,
    sendMsg: null,
    renderMsg: null,
    restartChat: null,
    initView: null,
    initController: null,
    qa: {name: "Chatbot Brik", placeholder: "Sem zadejte zprávu...", placeholders: ['Sem zadejte zprávu...']}
}