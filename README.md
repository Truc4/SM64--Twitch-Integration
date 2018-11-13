# SM64 Twitch Integration
### Author: [Truce](https://www.twitch.tv/truc_e)

## Description
This adds Twitch integration to Super Mario 64. Meaning commands are added that change various things in Super Mario 64. Viewers of the stream can spend bits to get points and use points to use commands.

### Commands can be customized in the config, default commands are listed here:
- !mario | Returns Mario to his default state.
- !luigi | Turns Mario to become taller, skinnier, and floaty physics.
- ...

## Config
### Options
- username | Set this to the username of the account that will be sending and receiving messages. (The bot account)
- password | *NOT THE ACCOUNT PASSWORD!* This is the oauth password. This can be foung at http://twitchapps.com/tmi
- channel | The name of the channel the bot will be connecting to.
### Points
- startingPoints | How many points a new user starts with.
- subMultiplier | The multiplier of how many points a sub will get for each bit. **subMultiplier: 2** means subs will get 2 points for 1 bit.
- modMultiplier | The same as subMultiplier but for moderators instead.
- modCanManagePoints | Whether or not mods can give, take, and set point values for viewers.
### Commands
Each command has a name and a point value. i.e. **"luigi": 10** This means the command that turns Mario into Luigi is called !luigi and costs 10 points to use. These commands must be lowercase but using commands is not case sensitive.
argCommands are a little different instead of having a one time cost they cost the amount of points specified for each number. i.e. **"oof": 10** would mean that **!oof 1** would cost 10 points and **!oof 4** would cost 40 points

## Installation
