DTSD
====

StarMade Daemon

This BASH project was born out of the need to access console commands from SSH. After a little searching I was
able to adapt a existing script to fit my needs and perhaps the needs of many others. Over time it has grown 
into a versatile way to manage and server-side modify StarMade. Without further ado, I present Doomsider and 
Titansmasher Starmade Daemon (DTSD).

All of these commands come at the end of starmaded.sh  (IE: ./stamaded.sh start)
start - Starts the server
stop - Stops the server with a server message and countdown approx 2 mins
ebrake - Stop the server without a server message approx 30 seconds
destroy - Deletes Server no recovery
install - Download a new starter and do a install
reinstall - Destroys current server and installs new fresh one
smrestore filename - Selected file unzips into the parent folder of starmade
smdo command - Issues a server command.  Use quotes if there are spaces
smsay words - Say something as the server.  Use quotes if there are spaces
backup - backs up current Starmade directory as zip
backupstar - Stops cron and server, makes backup, restarts cron and server
status - See if server is running
cronstop - Removes all cronjobs
cronrestore - Restores all cronjobs
cronbackup - Backs up your cron file
upgrade - Runs the starters upgrade routine
upgradestar - Stops cron and server, runs upgrade, restarts cron and server
restart - Stops and starts server
smplayermaxset number - Change max players to this setting.  Helpful to set to 0 for maintenance
log - Logs admin, chat, player, and kills
screenlog - Starts a screen which starts the log function
check - Checks for new version.  If found send message, stop server, backup, download and install new verion
precheck - Checks for new PRE version. if found send message, stop server, backup, download and install new verion
ban - Bans a player by their names and IP address
detect - Detects if the server is frozen by sending Unix time and then checking the outputlog to see if server received.

Logging creates a logs, playerfiles, and gatewhitelist directory to store files in.   Logging is conducted by sending the output of the server to output.log and then searching that log for certain output.  Playerfiles stores every player on the server and basic information about them.  Gatewhitelist contains the people that are allowed on your personal jump network.  Mail contains all the mail for players.  A basic vote counting system that must be configured with a key at www.starmade-servers.com in the configuration file to work.
Below are a list of files found in the logs directory:
output.log - the main output for the server.  On server restart this file is saved with a timpestamp.
screen.log - the output for the logging system
ship.log - a list of all the ships, their locations, and who last owned them
planet.log - All the planets players have built onto
station.log - list of all the known stations players have created
chat.log - a record of all the chat on the server
gate.log - contains all the jump gates
kill.log - has all the kills that happen
admin.log - A list of who what and when for admin commands
guestbook.log - All the players who have visited and left the server
bank.log - List of all the banking transactions
shipbuy.log - List of all the ships that have been bought
rankcommands.log - List of the ranks and what commands they may use
threaddump.log - You will see this file with a timestamp if you have done any java dumps for debugging
Logging is ran in a separate screen and is terminated if the server stops.  The screen name for logging can be found in your configuration file.

The Ranking system allows the admin to set user ranks and choose what commands player can have access to.  Rankcommands.log list ranks followed by the commands they are allowed to use.  You can change the name of ranks but keep in mind you must be sure to set the default player rank in the configuration file..
The basic ranks are
Ensign - Normal player
Lieutenant - Player with a few extra perks
Commander - Low level Admin
Captain - Mid level Admin with some restrictions
Admiral - Full Admin

Scripting
[SPOILER="Scripting for Starmaded"]
Due to the way Starmaded is coded, it is very easy to adapt and expand upon. There are a number of places you can insert code to be run at specific times with little to no editing of existing code
[SPOILER="Adding new commands"]
All chat commands are handled by the log_chatcommands function, and It does this in a rather clever way.
To add in new chat commands, all you need to do is create a new function called COMMAND_<CommandName> and then every time someone enters the new command name into the chat, preceded by an ! your new function will be called.
e.g. if you created a function COMMAND_TEST then if anyone entered !TEST into chat then your function would be called
Following on from this then, any parameters players give the command will also be passed as parameters to your function, in the following way;
$1 = Players name (The person who used the command)
$2+ = The parameters the player passed, seperated by spaces.
$# = The number of parameters passed (Including the players name)
$@ = every single parameter passed (Including the players name)
Using $# then, you can limit the number of parameters allowed to be passed to that command. In the default script, the following format is used to limit the number of parameters passed;
[QUOTE]if [ "$#" -ne "NumberOfParameters+1" ]
then
   as_user "screen -p 0 -S $SCREENID -X stuff $'/pm $1 ParameterErrorMessage\n'"
else
   Function workings
fi[/QUOTE]
However you can do it any way you like.
There is also integration into the help system for functions too. To use this, all you have to do is make the first two lines of your command be comments with info on how to use the command.
To see this in the actual script, there is an example command located on line 1604 of the daemon, showing you how to use this


The Starmaded script uses a variety of files and folders to store and use data, and you can access these too.
Inside the config file that is created at startup is a list of variables directing you to different files, each of which has a unique use

$PLAYERFILE
This is a folder containing a player file for every single player that has ever logged in.
The files are formatted following the format on line 837 and also on line 1422. If you make any edits, you must edit both these places

Made on date = The date the playerfile was created
Rank = The rank of the player, determining the commnds the player is allowed to use
CreditsInBank = The number of credits stored in the players bank
VotingPoints = The number of voting points the player has saved up from voting for the server
CurrentVotes = The number of votes the player has currently made this month (Used to prevent counting the same vote twice)
Bounty = The bounty placed on this players head
WarpTeir = Unused for now, but will be used to speed up the !FOLD command in the future
JumpDisabled = The time (unix time) when the player will be allowed to use !JUMP again. Acts as the !JUMP cooldown
CommandConfirm = Set to 1 for 20 seconds when the player enters !CONFIRM. Can be used to confirm player actions. Unused at the moment
CurrentIP = The last known IP address that the player used
CurrentCredits = The number of credits the player has on them at the last playerfile update (performed by log_playerinfo)
PlayerFaction = The faction ID that the player is in at the last playerfile update (performed by log_playerinfo)
PlayerControllingType = The type of entity the player is controlling (Spacesuit, Ship, SpaceStation or Planet)
PlayerControllingObject = The name of the entity the player is currently controlling
PlayerLastLogin = The date and time of when the player last logged in
PlayerLastCore = The time (unix time) of when the player last used !CORE. acts like a cooldown
PlayerLastFold = The time (unix time) of when the player last used !FOLD. acts like a cooldown
PlayerLastUpdate = The time the playerfile was last updated by log_playerinfo
PlayerLastKilled = Who the player last killed and the time of the kill (unix time)
PlayerKilledBy = Who last killed the player
PlayerLoggedIn = Whether the player is logged in or not (Yes or No)
PlayerNeedsUpdating = Tells log_playerfile that the player needs to be updated (after login or death) and so when the player spawns in they will be updated
ChatCount = The number of messages sent in the last $SPAMTIMER seconds
SpamWarning = Whether they have been warned about spamming already this login. (Yes or No)
SpamKicks = The number of times the player has been kicked from the server for spam

$MAILFILE
This folder contains all the mailfiles which contain all messages sent from player to player
A mailfile will be created whenever someone logs in or dies.

The first line contains the number of unread messages and the current MailID, to stop there being multiple ID's
Every line after that follows this pattern
MessageID: (The ID of this message) Unread: (Yes or No saying if the message is unread) Sender: (Who sent this message) Time: (The date and time the message was sent) Message: (The actual message)

$GATEWHITELIST
This folder contains individual player files that contain who is and isnt allowed to use jump gates belonging to that player

The logs folder contains all the important files to the core running of the daemon.
output.log is the copy of the log files produced by starmade. Editing this file will break the entire daemon untill a server restart, so it is advised you leave this file as it is
$RANKCOMMANDS
This file contains all the ranks available on the server, and what commands can be used
Format: Rank Command Command Command
For access to all commands, enter -ALL- as the command
e.g. Ensign RANKME RANKLIST RANKUSER RANKCOMMAND KILL WHITEADD
$ADMINLOG
This file contains a record of every single admin command used on the server, and who used them
Formatting is the same as the default starmade logging
$GUESTBOOK
This file contains a list of every log on and log off along with times
Format: Name logged on/off at Date server time
e.g. Titansmasher logged on at May_26_2014_19.03.59 server time
$SHIPBUYLOG
This file contains a record of every ship bought on the server, and who bought it
Formatting is the same as the default starmade logging
$CHATLOG
This file contains every single global message and PM that has been sent
Format: Date - (Sender) Message
e.g. May_26_2014_19.04.24 - (Titansmasher) help
$SHIPLOG
This contains every single ship ever entered that still exists on the server
Ships are saved in the format {ShipName} [LastUserName] (LastKnownSector)
e.g. {Thunderclap_v1_1401126601055} [Titansmasher] (9,2,9)
$STATIONLOG
This contains every single station ever entered that still exists on the server
Stations are saved in the format {StationName} [LastUserName] (LastKnownSector)
e.g. {StationOfDeath} [Titansmasher] (9,2,9)
$PLANETLOG
This contains every single planet ever entered that still exists on the server
Planets are saved in the format {PlanetName} [LastUserName] (LastKnownSector)
e.g. 231 [Titansmasher] (9,2,9)
$BOUNTYLOG
This log contains all claimed bounties
-NeedsFinishing-
$GATELOG
This log contains all information about Jump Gates that exist
Format: Name: JumpName Sector: X,Y,Z Level: Number Creator: Player TotalCost: Number LinkedEntity: StationName

Name = The name of the jump gate
Sector = The sector the jump gate exists in
Level = The level of the gate, that determines the warm up and cooldown of the jumping
Creator = Who made the jump gate; Who it belongs to
TotalCost = How many voting points the gate has cost to make, used for refunds
LinkedEntity = The entity that the gate is bound to. Destroy the entity and you destroy the gate

e.g. Name: Spawn Sector: 2,2,2 Level: 9 Creator: Titansmasher TotalCost: 300 LinkedEntity: Spawn_Station
$KILLLOG
This log contains a record of all kills, and the cause of them
Format: Killer killed Victim without predujice
Format: Victim was killed by AI Ships
Format: Victim was killed by an AI character
e.g. Titansmasher killed Doomsider without predujice
$BANKLOG
This log contains a record of all bank transactions made
Format: Player deposited/withdrew Amount
Format: Player transfered Amount to Player
e.g. Titansmasher transfered 300000 to Doomsider

From the logs StarMade produces, there are a lot of trigger lines that indicate certain actions have been performed.
Using these as triggers then, the sm_log function can trigger different functions and pass these trigger lines to those functions
log_playerinfo
This function is triggered whenever a playerfile needs updating.
It sends the command /player_info Player to the server, and then reads the output from the logs.
Using this then, it can be used to generate on-demand and up to date data for any player online, it just needs you to pass the player name as a parameter
log_chatlogging
This function decodes any inputted log line and writes it to $CHATLOG
This also calls the spam_prevention function and passes the name of the player to it
log_chatcommands
This function is the core of the chat commands feature of the daemon.
It takes the inputted chat string, decodes it, checks a function by the name of the command exists, and if so then it runs the command function
Using this then, all you need to do to create new chat commands is to add in a new function called COMMAND_CommandName
It passes the playername as $1 and all other parameters as $2, $3 ect to the called command function
log_kill
This function is triggered whenever someone dies on the server, and then writes it to a log file, and if it was a player kill then it adds the kill information to the playerfile
The playerfile is then marked as needing an update when the player spawns in
log_admincommand
This function is triggered whenever an admin command is used by a player, and writes it to $ADMINLOG
log_shipbuy
This function is triggered whenever a ship is bought from the catalogue and writes it to $SHIPBUYLOG
log_playerlogout
This function is triggered whenever a player logs out, and writes to $GUESTLOG aswell as setting the player to offline in the playerfile
log_boarding
This function is triggered whenever a player changes the entity they are controlling.
Using this then, the currently controlled object and type can be kept 100% up to date in the playerfile
Also, if the player has just logged in or died this function calls the log_playerinfo function when they spawn in
log_sectorchange
This function is triggered whenever a player changes sectors.
Using that, the playerfile is update, and the file for any entity that the player was controling is updated too
Then the log_universeboarder function is triggered and passed the players coordinates and name
log_destroystring
This function is triggered whenever an entity is destroyed.
The destroyed entity is searched for inside the relevant log ($SHIPLOG , $STATIONLOG or $PLANETLOG) and is then removed
If the destroyed entity is a station, it also looks for a Jump Gate linked to that entity and removes the gate
log_on_login
This function is triggered as soon as a player successfully connects to the server.
The player is then written to the $GUESTLOG and their playerfile is marked as needing an update when the player spawns in
log_universeboarder
This function teleports the player to the opposite side of the universe if they have gone outside the universe limit
The limit is measured in sectors from the specified center and is configurable
log_initstring
This function is called whenever a player spawns in, at the moment their inventory is initialised
-Needs finishing-
spam_prevention
This function is called every time a player sends a chat message or a PM
It adds 1 to the players message count, and then reduces it back by one $SPAMTIMER seconds later
This effectively counts the number of messages sent in the past $SPAMTIMER seconds
If the number of messgaes sent is too high, they are warned. If they continue then they are kicked.
If they are kicked too many times, they will be banned
autovoteretrieval
This function is started at the same time as the sm_log function, and runs for as long as sm_log is
It downloads the vote list from starmade-servers.com using the server key and then checks to see if any players have voted since the last check
It does this by comparing the CurrentVotes field in the player log to the number of votes starmade-servers.com is saying.
If it is more or less (less indicates a new month) then the number of votes is added and the CurrentVotes count is adjusted
This loops once every 10 seconds by default

Command Examples

The players guide to starmaded:
There are a variety of features in starmaded aimed at the players, such as player commands, voting rewards, and more
This is all done through the use of the chat, both PM's and public chat, and the command character '!'
Any and all text that you type into the chat or a PM that starts with an ! will be interpreted as a command.
Commands in chat:
!<COMMAND> <ARGUMENTS>
e.g. !HELP JUMP
(Note: Commands are not case sensitive, however arguments are)
Commands in PM's:
/pm <AnyoneOnline> !<COMMAND> <ARGUMENTS>
e.g. /pm Titansmasher !HELP JUMP
(Note: Commands are not case sensitive, however arguments are)
Both the above examples will trigger the HELP command and return you help for the JUMP command
There is also a ranking system incorperated into the daemon, meaning you may not have access to all the commands listed.
Voting points are automatically collected from the servers page at starmade-servers.com, using the servers serverkey
Command List:

These commands are designed to help you out when stuck
   !HELP <COMMAND>
   The most important command for getting used to the daemon. Type !HELP on its own and you will recieve a list of all commands that are available to you, and typing !HELP followed by one of those commands will tell you what the command does and how to use it.
   e.g. !HELP JUMP
   !CORE
   If you are out in the middle of nowhere, no ship and stranded, type !CORE and you will recieve one free ship core to let you fly back to saftey. (one use per 10 minutes)
   e.g. !CORE

This set of commands allows you to send messages to other players, even if they are offline!
   !MAIL <SEND/READ/LIST/DELETE>
   A very versatile command, used to send messages to players even if they are offline! There are multiple branches to the MAIL command, and have their own syntax.
     !MAIL SEND <Player> <Message>
     Sends a message to the specified player. They will be notified that they have an unread mail when they log in.
     e.g. !MAIL SEND Titansmasher Your base is being invaded!
     !MAIL LIST <All/Unread>
     Shows you the mail in your inbox by mail ID
     e.g. !MAIL LIST Unread
     !MAIL READ <MailID>
     Shows you the specified mail. MailID is found from using !MAIL LIST <All/Unread>
     e.g. !MAIL READ 0
     !MAIL DELETE <MailID>
     Deletes the specified message from your mail box.
     e.g. !MAIL DELETE 0
     !MAIL HELP
     Gives you more indepth help than the help system does on the !MAIL command.
     e.g. !MAIL HELP
   When you first join a server running the daemon, you will recieve a mail from MailBoxPro. Use !MAIL READ 0 to view this message for ingame help
   !MAILALL <Message>
   <AdminCommand> Sends a message to everyone with a mailbox file.
   e.g. !MAILALL Server event tomorrow! Reply if you want to join in.

This set of commands allows you to set up and modify Jump Gates that allow you to teleport around the universe, aswell as giving your ship a 'warp drive' like function
   !FOLD <X> <Y> <X>
   Teleports you and your ship to a specified sector. It has a range limit of 30 sectors by default, and a very long warmup and cooldown compared to !JUMP, but can be used anywhere to anywhere.
   e.g. !FOLD 2 2 2
   !ADDJUMP <JumpName>
   Currently the only command that utilises voting points (must be set up on the server). Simply enter a stations build block and type !ADDJUMP <NameOfJump> and you will be charged some voting points (50 by default) and a jump gate bound to your station will be made. !!WARNING!! IF THAT STATION IS DESTROYED, THE JUMP GATE WILL BE TOO AND YOU WILL GET NO REFUND!! PROTECT YOUR GATES!
   e.g. !ADDJUMP Spawn
   !JUMPLIST
   Lists all the jumps that exist on the map, and the sectors they are in
   e.g. !JUMPLIST
   !JUMP <JumpName>
   Teleports you from the current jump gate to the gate specified. Has a shorter cooldown and warmup than !FOLD and unlimited range, but is limited to sectors with JumpGates (!ADDJUMP). Also, you can jump to any gate, but you can only jump from gates you are permitted to use.
   e.g. !JUMP Spawn
   !UPGRADEJUMP <JumpName>
   Decreases the cooldown and warm up of the specified gate at the cost of voting points. Only the gates creator can use this command
   e.g. !UPGRADEJUMP Spawn
   !DESTROYJUMP <JumpName>
   Deletes the specified jump gate and returns a % of the spent voting points back (90% default). Only the gates creator can use this command
   e.g. !DESTROYJUMP Spawn
   !PLAYERWHITELIST <+/-> <Player/All>
   Adds (+) or removes (-) players by name from your personal whitelist (who can and cant use your jump gates). Everyone can use your gate by default. If you dont want that, then do !PLAYERWHITELIST - All
   e.g. !PLAYERWHITELIST + Titansmasher
   !ADMINADDJUMP <JumpName> <X,Y,Z> <GateTeir> <GateOwner> <LinkedEntity(optional)>
   <AdminCommand> Creates a jump gate at the specified sector, called the specified name, belonging to the specified player and linked to the specified entity. <GateTeir> is a number between 1 and 9 (by default) and controls warmup and cooldown (higher the better)
   e.g. !ADMINADDJUMP Spawn 2,2,2 9 Titansmasher Spawn_Station
   !ADMINDELETEJUMP <JumpName>
   <AdminCommand> Deletes the specified Jump Gate from the file. Gives no refunds
   e.g. !ADMINDELETEJUMP Spawn

This set of commands provide a way for you to store credits into a banks servers, and use that money to place bounties on people
   !DEPOSIT <Amount>
   Takes the amount of credits from your player and stores it in your bank account
   e.g. !DEPOSIT 3000
   !WITHDRAW <Amount>
   Takes the amount of credits from your account and give it to your player. Be wary of the games credit limit!
   e.g. !WITHDRAW 3000
   !TRANSFER <Player> <Amount>
   Takes the amount of credits out of your account and gives them to the specified players account
   !TRANSFER Titansmasher 3000
   !BALANCE
   Tells you how many credits are stored in your account
   e.g. !BALANCE

This set of commands allow you to place bounties on players, and collect the bounties of players you've killed.
   !POSTBOUNTY <Player> <Amount>
   Places a bounty on the player, meaning when they are killed, the killer will get the bounty on that persons head
   e.g. !POSTBOUNTY Titansmasher 3000
   !LISTBOUNTY
   Lists all bounties that are placed on all players.
   e.g. !LISTBOUNTY
   !COLLECTBOUNTY <Player>
   If you have killed the specified player recently, and the player has a bounty on their head, then this will give you the value of the bounty.
   e.g. !COLLECTBOUNTY Titansmasher

This set of commands is all related to the player rank system, and getting information from it
   !RANKME
   Tells you what rank you are, and what commands you can use.
   e.g. !RANKME
   !RANKLIST
   Gives you a list of all the ranks.
   e.g. !RANKLIST
   !RANKSET <Player> <Rank>
   <AdminCommand> Sets the rank of the player, allowing them to use different commands
   e.g. !RANKSET Titansmasher Admin
   !RANKUSER <Player>
   <AdminCommand> Tells you what rank the player is
   e.g. !RANKUSER Titansmasher

These commands serve a function in conjuction with other commands
   !CONFIRM
   Confirms actions for the next 20s. (Not in use currently, but intended as a method of making sure you mean to use a command)
   e.g. !CONFIRM
   !VOTEBALANCE
   Tells you how many voting points you have. Voting points are automatically gained for voting for the server.
   e.g. !VOTEBALANCE
   !SEARCH
   Finds the coordinates of the last ship you were inside.
   e.g. !SEARCH

These commands are intended for Admin use only
   !BANHAMMER <Player>
   <AdminCommand> Bans a player from the server by Name, IP and Star-made.org account
   e.g. !BANHAMMER Titansmasher
   !KILL <Player>
   <AdminCommand> Kills the specified player using the command /kill_character
   e.g. !KILL Titansmasher
   !WHITEADD <Player>
   <AdminCommand> Adds the specified player to the whitelist by name
   e.g. !WHITEADD Titansmasher
   !BANPLAYER <Player>
   <AdminCommand> Bans the specified player from the server by name
   e.g. !BANPLAYER Titansmasher
   !UNBAN <Player>
   <AdminCommand> Un-bans the specified player from the server by name
   e.g. !UNBAN Titansmasher
   !SHUTDOWN <Time>
   <AdminCommand> Shuts down the server with a specified delay. !SHUTDOWN -1 to cancel
   e.g. !SHUTDOWN 60
   !RESTART
   <AdminCommand> Shuts the server down with a 60s delay and then starts it back up again
   e.g. !RESTART
   !CREDITS <Player (Optional)> <Amount>
   <AdminCommand> Gives you/the player the specified amount of credits
   e.g. !CREDITS Titansmasher 3000
   !IMPORT <X> <Y> <Z> <SectorExportName>
   <AdminCommand> Imports the specified export file into the specified sector coords. If there is a player near to the sector specified, the import will fail
   e.g. !IMPORT 2 2 2 Spawn
   !EXPORT <X> <Y> <Z> <SectorExportName>
   <AdminCommand> Saves the specified sector to file to beimported back elsewhere using !IMPORT.
   e.g. !EXPORT 2 2 2 Spawn
   s
   !DESPAWN <X> <Y> <Z> <ShipName>
   <AdminCommand> Removes all entities that start with the specified name from the specified sector
   e.g. !DESPAWN 2 2 2 MOB_
   !LOADSHIP <BlueprintName> <EntityName> <X> <Y> <Z>
   <AdminCommand> Spawns in the specified blueprint from the catalogue in the specified sector as a ship with the specified name
   e.g. !LOADSHIP Thunderclap_V1 TurretOfDeath 2 2 2
   !GIVE <Player (Optional)> <ItemID> <Amount>
   <AdminCommand> Gives you/the specified player the item ID specified
   e.g. !GIVE Titansmasher 1 100
   !GIVENORMAL
   <AdminCommand> Gives you 10,000 of every normal hull block and some other useful building blocks
   e.g. !GIVENORMAL
   !GIVEHARD
   <AdminCommand> Gives you 10,000 of every hardened hull block and some other useful building blocks
   e.g. !GIVEHARD
   !CLEAR
   <AdminCommand> Clears your inventory of all Items
   e.g. !CLEAR
   !KICK <Player>
   <AdminCommand> Kicks the specified player from the server
   e.g. !KICK Titansmasher
   !GODON
   <AdminCommand> Turns godmode on for you (makes you invincible)
   e.g. !GODON
   !GODOFF
   <AdminCommand> Turns godmode off for you (makes you vulnerable)
   e.g. !GODOFF
   !LISTWHITE <NAME/IP/ACCOUNT/ALL>
   <AdminCommand> Tells you who is on the whitelist, by name, account, ip or tells you everyone (non case-sensitive)
   e.g. !LISTWHITE Name
   !INVISION
   <AdminCommand> Makes your PLAYERMODEL invisible to all players. Does not work on ships, stations or planets
   e.g. !INVISION
   !INVISIOFF
   <AdminCommand> Makes your PLAYERMODEL visible to all players.
   e.g. !INVISIOFF
   !TELEPORT <Player (Optional)> <X> <Y> <Z>
   <AdminCommand> Teleports you or the specified player to the specified coordinates
   e.g. !TELEPORT Titansmasher 2 2 2
   !PROTECT <X> <Y> <Z>
   <AdminCommand> Protects everything inside the specified sector from all forms of damage
   e.g. !PROTECT 2 2 2
   !UNPROTECT <X> <Y> <Z>
   <AdminCommand> Removes all protection from the specified sector, meaning damage can occur.
   e.g. !UNPROTECT 2 2 2
   !SPAWNSTOP <X> <Y> <Z>
   <AdminCommand> Stops pirates and the trading guild from attacking players within the specified sector
   e.g. !SPAWNSTOP 2 2 2
   !SPAWNSTART <X> <Y> <Z>
   <AdminCommand> Allows pirates and the trading guild to attack players within the specified sector again
   e.g. !SPAWNSTART

This set of commands is designed to help with tracking down problems on the server.
   !MYDETAILS
   Tells you all the details stored inside your player file. May be hard to read, as it keeps all text, and a bit spammy for your chat, as the playerfile contains 26 lines
   e.g. !MYDETAILS
   !ADMINCOOLDOWN <Player>
   <AdminCommand> Sets all cooldown timers for the specified player to 0, meaning they can use !JUMP, !FOLD and !CORE straight away
   e.g. !ADMINCOOLDOWN Titansmasher
   !ADMINREADFILE
   <AdminCommand> Allows you to read ANY file from the daemon directory down, while ingame. Logs are kept at logs, playerfiles at playerfile and playerwhitelist at playerwhitelist. Use with catution
   e.g. !ADMINREADFILE playerfile/Titansmasher

Version History
Version .04
Fix for Chat (Schema Changed it to /chat so I fixed it)
Version .05
Added port option to support running daemon with multiple copies of Starmade on same server.  Also added new log function smlog which records Players logged on off, kills, admin commands, chat, and active players.  Look forwards to a code rewrite for the next version as things have gotten sloppy.
Version .06
I added in a variable for screen names so it will be easier to run multiple copies of starmade on the same server with different daemon scripts.  I re-wrote for several hours troubleshooting and making the code more consistent.  I improved and altered every function in the script with new routines.  I added in path variables for logging and changed the start function to always log.  smlog and smdetect are now log and detect respectively.  I have several different projects so stay tuned for future developments.
Version .07
Added a new command screenlog that starts the logging session in a screen.  I fixed the stop routine and start routine to be more accurate in dealing with screens.  I addressed a bug that would allow dead screens to prevent the server from starting by adding screen  -wipe where needed.  I reworked the logging function and removed the script that linked chatID to player name.  Chat will still be logged it just won't have the persons name in place of the chatID.
Version .08-.09
Fixed start function by adding in -port:$PORT to allow servers to use other ports
Fixed install function it had a error on a add_user command
Added a routine to screenlog to ensure multiple copies will not run
Changed back to using ps aux to detect servers due to inconsistency with screen
Added in grep for port:$port and grep -v tee to remove fale positives
Fixed Backup to correctly detect is zip has been installed or not
Completely re-did logging to update it to current server output.  Added new logging in as well.
Version .10
Fixed ship and station names with a space so they work with logging.  Fixed a bug that transposed playername into ship log.  Added check and precheck to help automate updates.  Added a destroy routine to remove ships and station from their respective logs when they are destroyed or removed.  Fixed other minor bugs and reformated script to be more readable.  I will go back and add more comments in later to make what the script is doing more clear.  Added in chat commands, please see !HELP ingame for a list.  Added in a Ranking system to control access to chat commands, you will have to add yourself to rank.log with the chosen RANK5 name to be able to set ranks.
Version .11
Added routine to allow anyone in admins.txt to use !RANKSET.  Fixed Shipbuy log.  Fixed Chat Import and Despawn commands.  Added routine into detect to prevent the server from resetting while repairing the database. Added services into main start line so if you are running a modified or renamed StarMade.jar it will work. Added Chat commands to give players items and cash as well as adding people to whitelist and listing people on whitelist
Version .12
Added a routine to shutdown screenlog in case it was still running.  Moved variables from screenlog to the beggining of the daemon to make it more easy to configure.  Changed output log variable so it was more consistent.  Added a line that can be uncommented right after server start to begin screen logging for admin commands.  Added in a !RAKCOMMAND to allow users to see what their ranks can do.  Added in !BANHAMMER command so a client with the proper rank can now ban a player with name and IP.  Added a new function called smban which essentially does the same thing as banhammer only can be used from command line.  Fixed some other minor bugs and did some formatting.  Still have some concerns about some of the logging function.  You can always comment out everything but chat string if you just want chat commands on you server.
Version .13
I decided to rewrite logging directory structure.  Screen logging is now default and all logs are dumped into starterpath/logs.  At Schema's request jstack does a threaddump.log when ebrake is used for the detect routine.  I run the detect routine ever 5 minutes with cronjob to see if the server is reponsive, if not it will restart the server.  You can send you threddump.log to Schema so he can troubleshoot the crashes better.  I also added a few comments and formatted a bit to make things easier to seperate.
Version .14 - .16
Titansmasher , who joined the Daemon project, helped to rewrite the chat command system.  Chat commands became individual functions and a new rank system was created.  A new logging system was implemented to improve on the old and make it easier to create new conditions in logging.  The Daemon now creates its own config file which should be edited and detects the user so it should be run by the correct user at first.  A banking, a fold, and a bounty system were added to chat commands. Titansmasher added a warp gate system, mail, spam, and a vote counting system.  Numerous bug fixes thanks to Titansmaher.
