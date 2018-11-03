const tmi = require("tmi.js");

const options = {
    options: {
        debug: true
    },
    connection: {
        reconnect: true
    },
    identity: {
        username: "truc_e",
        password: "oauth:u4cttsvtlloongb5hvux03q1sfn156"
    },
    channels: ["#truc_e"]
}

const client = new tmi.client(options);

client.connect();

client.on("chat", (channel, user, message, self) => {

    if (self) return;

    if (message.startsWith("!")) {
        command = message.substring(1);
        console.log(command);
    }

});
