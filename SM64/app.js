//Shoutouts to SimpleFlips

//Initialize
const tmi = require("tmi.js");
const config = require("./config.json");
const points = require("./points.json");
const fs = require('fs');
var signature = 0;

//Writes info the command.txt for the lua script
function writeTextFile(username, command, amount = 0) {
    fs.writeFile("command.txt", username + " " + command + " " + amount + " " + signature, function (err) {
        if (err) console.log(err);
    });
    signature++;
}

//Saves points.json
function savePoints() {
    fs.writeFile("./points.json", JSON.stringify(points), (err) => {
        if (err) {
            console.error(err);
            return;
        }
        console.log("Points have been saved");
    });
}

//Login options
const options = {
    options: {
        debug: false
    },
    connection: {
        reconnect: true
    },
    identity: {
        username: config.options.username,
        password: config.options.password
    },
    channels: ["#" + config.options.channel]
}

//Connect
const client = new tmi.client(options);
client.connect();

//Run this if a chat message is recieved
client.on("chat", (channel, user, message, self) => {

    if (self) return;

    //console.log(user);

    if (message.startsWith("!")) {
        //Seperate arguments and make everything lowercase
        command = message.substring(1).toLowerCase().split(" ");

        //If not in database add to database gives free points from config.startingPoints
        if (points[user['username']] == null) {
            console.log("New user " + user['username'])
            points[user['username']] = config.startingPoints;
        }

        //Tells user how many points they have
        if (command[0] == 'points') {
            client.say(channel, user['display-name'] + " has " + points[user['username']].toString() + " points.");
        }
        //Admin commands
        if (user['badges'].broadcaster == 1 || ( config.modCanManagePoints == true && user['badges'].moderator == 1 )) { 
            if (command[0] == 'give') {
                if (Number(command[2]) > 0) {
                    points[command[1]] += Number(command[2]);
                    client.say(channel, user['display-name'] + " gave " + command[1] + " " + command[2] + " points. " + command[1] + " now has " + points[command[1]] + " points.");
                }
                else {
                    client.say(channel, user['display-name'] + "Invalid arguments.");
                }
            }
            else if (command[0] == 'set') {
                if (Number(command[2]) > 0) {
                    points[command[1]] = Number(command[2]);
                    client.say(channel, user['display-name'] + " set " + command[1] + " to " + command[2] + " points. ");
                }
                else {
                    client.say(channel, user['display-name'] + "Invalid arguments.");
                }
            }
        }

        //Checks for commands from config.commands, assigns them a number and writes the data to command.txt
        var i = 0;
        for (const [key, value] of Object.entries(config.commands)) {
            if (command[0] == key.toLowerCase()) {
                if (points[user['username']] >= value) {
                    //if (!user['username'] == "truc_e") {
                        points[user['username']] += -value;
                    //}
                    client.say(channel, user['display-name'] + " has " + points[user['username']].toString() + " points remaining.");
                    writeTextFile(user['display-name'], i);
                }
                else {
                    client.say(channel, "Insufficient points. " + user['display-name'] + " has " + points[user['username']].toString() + " points." + value + " points are needed.");
                }
            }
            i++;
        }

        //Checks for commands from config.argCommands, assigns them a number and writes the data to command.txt
        //argCommands need arguments and charge different amounts of points depending of the arguments
        for (const [key, value] of Object.entries(config.argCommands)) {
            if (command[0] == key.toLowerCase()) {
                if (command[1] == null) command[1] = 0;
                if (points[user['username']] >= value * command[1]) {
                    if (command[1] > 0) {
                        //if (!user['username'] == "truc_e") {
                            points[user['username']] += -value * command[1];
                        //}
                        client.say(channel, user['display-name'] + " has " + points[user['username']].toString() + " points remaining.");
                        writeTextFile(user['display-name'], i, command[1]);
                    }
                    else {
                        client.say(channel, "Invalid arguments");
                    }
                }
                else {
                    client.say(channel, "Insufficient points. " + user['display-name'] + " has " + points[user['username']].toString() + " points. " + value * command[1] + " points are needed.");
                }
            }
            i++;
        }


        //Save points
        savePoints();
    }
});

//Gives points for bits
client.on("cheer", function (channel, user, message) {
    var multiplier = 1;

    //If user is a mod multiply their points recieved by config.mod_multiplier
    if (user['mod']) {
        multiplier = config.mod_multiplier;
    }
    //If user is a sub multiply their points recieved by config.sub_multiplier
    if (user['subscriber']) {
        multiplier = config.sub_multiplier;
    }
    //If user is a sub and a mod multiply points by which one is bigger value
    if (user['mod'] && user['sub']) {
        if (config.mod_discount > config.sub_multiplier) {
            multiplier = config.mod_multiplier;
        }
        else {
            multiplier = config.sub_multiplier;
        }
    }
    //Add points
    points[user['username']] += multiplier * user.bits;
    //Tell user how many points they have
    client.say(channel, user['username'] + " added " + multiplier * user.bits + " points. " + points[user['username']].toString() + " total points.");

    //Save points
    savePoints();
});