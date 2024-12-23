// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\gametypes\_callbacksetup;
#include maps\mp\gametypes\_spawnlogic;
#include maps\mp\gametypes\_gameobjects;
#include maps\mp\gametypes\_spawning;
#include maps\mp\gametypes\_globallogic_score;
#include maps\mp\gametypes\_globallogic_utils;
#include maps\mp\_demo;
#include maps\mp\_popups;
#include maps\mp\gametypes\_globallogic_audio;
#include maps\mp\gametypes\_hostmigration;

main()
{
    if ( getdvar( #"mapname" ) == "mp_background" )
        return;

    maps\mp\gametypes\_globallogic::init();
    maps\mp\gametypes\_callbacksetup::setupcallbacks();
    maps\mp\gametypes\_globallogic::setupcallbacks();
    registertimelimit( 0, 1440 );
    registerscorelimit( 0, 1000 );
    registerroundlimit( 0, 10 );
    registerroundwinlimit( 0, 10 );
    registerroundswitch( 0, 9 );
    registernumlives( 0, 100 );
    maps\mp\gametypes\_globallogic::registerfriendlyfiredelay( level.gametype, 15, 0, 1440 );
    level.scoreroundbased = getgametypesetting( "roundscorecarry" ) == 0;
    level.teambased = 0;
    level.overrideteamscore = 1;
    level.overrideplayerscore = 1;
    level.onstartgametype = ::onstartgametype;
    level.onspawnplayer = ::onspawnplayer;
    level.onspawnplayerunified = ::onspawnplayerunified;
    level.onplayerkilled = ::onplayerkilled;
    level.onroundswitch = ::onroundswitch;
    level.onprecachegametype = ::onprecachegametype;
    level.onendgame = ::onendgame;
    level.gamemodespawndvars = ::dom_gamemodespawndvars;
    level.onroundendgame = ::onroundendgame;
    game["dialog"]["gametype"] = "dom_start";
    game["dialog"]["gametype_hardcore"] = "hcdom_start";
    game["dialog"]["offense_obj"] = "cap_start";
    game["dialog"]["defense_obj"] = "cap_start";
    level.lastdialogtime = 0;
    setscoreboardcolumns( "score", "kills", "deaths", "captures", "defends" );
}

onprecachegametype()
{
    precacheshader( "compass_waypoint_captureneutral" );
    precacheshader( "compass_waypoint_capture" );
    precacheshader( "compass_waypoint_defend" );
    precacheshader( "compass_waypoint_captureneutral_a" );
    precacheshader( "compass_waypoint_capture_a" );
    precacheshader( "compass_waypoint_defend_a" );
    precacheshader( "compass_waypoint_captureneutral_b" );
    precacheshader( "compass_waypoint_capture_b" );
    precacheshader( "compass_waypoint_defend_b" );
    precacheshader( "compass_waypoint_captureneutral_c" );
    precacheshader( "compass_waypoint_capture_c" );
    precacheshader( "compass_waypoint_defend_c" );
    precacheshader( "compass_waypoint_captureneutral_d" );
    precacheshader( "compass_waypoint_capture_d" );
    precacheshader( "compass_waypoint_defend_d" );
    precacheshader( "compass_waypoint_captureneutral_e" );
    precacheshader( "compass_waypoint_capture_e" );
    precacheshader( "compass_waypoint_defend_e" );
    precacheshader( "waypoint_captureneutral" );
    precacheshader( "waypoint_capture" );
    precacheshader( "waypoint_defend" );
    precacheshader( "waypoint_captureneutral_a" );
    precacheshader( "waypoint_capture_a" );
    precacheshader( "waypoint_defend_a" );
    precacheshader( "waypoint_captureneutral_b" );
    precacheshader( "waypoint_capture_b" );
    precacheshader( "waypoint_defend_b" );
    precacheshader( "waypoint_captureneutral_c" );
    precacheshader( "waypoint_capture_c" );
    precacheshader( "waypoint_defend_c" );
    precacheshader( "waypoint_captureneutral_d" );
    precacheshader( "waypoint_capture_d" );
    precacheshader( "waypoint_defend_d" );
    precacheshader( "waypoint_captureneutral_e" );
    precacheshader( "waypoint_capture_e" );
    precacheshader( "waypoint_defend_e" );
}

onstartgametype()
{
    setobjectivetext( "allies", &"OBJECTIVES_DOM" );
    setobjectivetext( "axis", &"OBJECTIVES_DOM" );

    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    if ( game["switchedsides"] )
    {
        oldattackers = game["attackers"];
        olddefenders = game["defenders"];
        game["attackers"] = olddefenders;
        game["defenders"] = oldattackers;
    }

    if ( level.splitscreen )
    {
        setobjectivescoretext( "allies", &"OBJECTIVES_DOM" );
        setobjectivescoretext( "axis", &"OBJECTIVES_DOM" );
    }
    else
    {
        setobjectivescoretext( "allies", &"OBJECTIVES_DOM_SCORE" );
        setobjectivescoretext( "axis", &"OBJECTIVES_DOM_SCORE" );
    }

    setobjectivehinttext( "allies", &"OBJECTIVES_DOM_HINT" );
    setobjectivehinttext( "axis", &"OBJECTIVES_DOM_HINT" );
    level.flagbasefxid = [];
    level.flagbasefxid["allies"] = loadfx( "misc/fx_ui_flagbase_gold_t5" );
    level.flagbasefxid["axis"] = loadfx( "misc/fx_ui_flagbase_gold_t5" );
    setclientnamemode( "auto_change" );
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    maps\mp\gametypes\_spawnlogic::placespawnpoints( "mp_dom_spawn_allies_start" );
    maps\mp\gametypes\_spawnlogic::placespawnpoints( "mp_dom_spawn_axis_start" );
    level.mapcenter = maps\mp\gametypes\_spawnlogic::findboxcenter( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );
    spawnpoint = maps\mp\gametypes\_spawnlogic::getrandomintermissionpoint();
    setdemointermissionpoint( spawnpoint.origin, spawnpoint.angles );
    level.spawn_all = maps\mp\gametypes\_spawnlogic::getspawnpointarray( "mp_dom_spawn" );
    level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getspawnpointarray( "mp_dom_spawn_axis_start" );
    level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getspawnpointarray( "mp_dom_spawn_allies_start" );
    flagspawns = maps\mp\gametypes\_spawnlogic::getspawnpointarray( "mp_dom_spawn_flag_a" );
    level.startpos["allies"] = level.spawn_allies_start[0].origin;
    level.startpos["axis"] = level.spawn_axis_start[0].origin;
    allowed[0] = "dom";
    maps\mp\gametypes\_gameobjects::main( allowed );
    maps\mp\gametypes\_spawning::create_map_placed_influencers();

    if ( !isoneround() && isscoreroundbased() )
        maps\mp\gametypes\_globallogic_score::resetteamscores();

    updategametypedvars();
    bwars_init();
    level thread bwars_update_scores();
    bwars_spawns_update();
}

onspawnplayerunified()
{
    maps\mp\gametypes\_spawning::onspawnplayer_unified();
}

onspawnplayer( predictedspawn )
{
    spawnpoint = undefined;
    spawnteam = self.pers["team"];

    if ( game["switchedsides"] )
        spawnteam = getotherteam( spawnteam );

    self player_world_icon_init();
    self player_hud_init();

    if ( !level.usestartspawns )
    {
        flagsowned = 0;
        enemyflagsowned = 0;
        myteam = self.pers["team"];

        for ( i = 0; i < level.flags.size; i++ )
        {
            team = level.flags[i] getflagteam();

            if ( team == myteam )
            {
                flagsowned++;
                continue;
            }

            if ( team != "neutral" && team != myteam )
                enemyflagsowned++;
        }

        if ( flagsowned == level.flags.size )
        {
            enemybestspawnflag = level.bestspawnflag[getotherteam( self.pers["team"] )];
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_nearteam( level.spawn_all, getspawnsboundingflag( enemybestspawnflag ) );
        }
        else if ( flagsowned > 0 )
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_nearteam( level.spawn_all, getboundaryflagspawns( myteam ) );
        else
        {
            bestflag = undefined;

            if ( enemyflagsowned > 0 && enemyflagsowned < level.flags.size )
                bestflag = getunownedflagneareststart( spawnteam );

            if ( !isdefined( bestflag ) )
                bestflag = level.bestspawnflag[self.pers["team"]];

            level.bestspawnflag[self.pers["team"]] = bestflag;
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_nearteam( level.spawn_all, bestflag.nearbyspawns );
        }
    }

    if ( !isdefined( spawnpoint ) )
    {
        if ( spawnteam == "axis" )
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_random( level.spawn_axis_start );
        else
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_random( level.spawn_allies_start );
    }

    assert( isdefined( spawnpoint ) );

    if ( predictedspawn )
        self predictspawnpoint( spawnpoint.origin, spawnpoint.angles );
    else
        self spawn( spawnpoint.origin, spawnpoint.angles, "dom" );
}

onendgame( winningteam )
{

}

onroundendgame( roundwinner )
{
    if ( level.roundscorecarry == 0 )
    {
        [[ level._setteamscore ]]( "allies", game["roundswon"]["allies"] );
        [[ level._setteamscore ]]( "axis", game["roundswon"]["axis"] );

        if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
            winner = "tie";
        else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
            winner = "axis";
        else
            winner = "allies";
    }
    else
    {
        axisscore = [[ level._getteamscore ]]( "axis" );
        alliedscore = [[ level._getteamscore ]]( "allies" );

        if ( axisscore == alliedscore )
            winner = "tie";
        else if ( axisscore > alliedscore )
            winner = "axis";
        else
            winner = "allies";
    }

    return winner;
}

updategametypedvars()
{
    level.flagcapturetime = getgametypesetting( "captureTime" );
    level.flagcapturelpm = dvarfloatvalue( "maxFlagCapturePerMinute", 3, 0, 10 );
    level.playercapturelpm = dvarfloatvalue( "maxPlayerCapturePerMinute", 2, 0, 10 );
    level.playercapturemax = dvarfloatvalue( "maxPlayerCapture", 1000, 0, 1000 );
    level.playeroffensivemax = dvarfloatvalue( "maxPlayerOffensive", 16, 0, 1000 );
    level.playerdefensivemax = dvarfloatvalue( "maxPlayerDefensive", 16, 0, 1000 );
}

bwars_init()
{
    level.laststatus["allies"] = 0;
    level.laststatus["axis"] = 0;
    precachemodel( "mp_flag_green" );
    precachemodel( "mp_flag_red" );
    precachemodel( "mp_flag_neutral" );
    precachestring( &"MP_CAPTURING_FLAG" );
    precachestring( &"MP_LOSING_FLAG" );
    precachestring( &"MP_DOM_YOUR_FLAG_WAS_CAPTURED" );
    precachestring( &"MP_DOM_ENEMY_FLAG_CAPTURED" );
    precachestring( &"MP_DOM_NEUTRAL_FLAG_CAPTURED" );
    precachestring( &"MP_ENEMY_FLAG_CAPTURED_BY" );
    precachestring( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
    precachestring( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_A_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_B_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_C_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_D_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_E_CAPTURED_BY" );
    triggers = getentarray( "flag_primary", "targetname" );

    if ( !triggers.size )
    {
        println( "^1Not enough domination flags found in level!" );
        maps\mp\gametypes\_callbacksetup::abortlevel();
        return;
    }

    level.bwars_flags = [];

    foreach ( trigger in triggers )
    {
        visuals = trigger flag_model_init();
        flag = maps\mp\gametypes\_gameobjects::createuseobject( "neutral", trigger, visuals, vectorscale( ( 0, 0, 1 ), 100.0 ) );
        objective_delete( flag.objidallies );
        maps\mp\gametypes\_gameobjects::releaseobjid( flag.objidallies );
        flag maps\mp\gametypes\_gameobjects::allowuse( "any" );
        flag maps\mp\gametypes\_gameobjects::setusetime( level.flagcapturetime );
        flag maps\mp\gametypes\_gameobjects::setusetext( &"MP_CAPTURING_FLAG" );
        flag maps\mp\gametypes\_gameobjects::setvisibleteam( "any" );
        flag flag_compass_init();
        flag.onuse = ::onuse;
        flag.onbeginuse = ::onbeginuse;
        flag.onuseupdate = ::onuseupdate;
        flag.onenduse = ::onenduse;
        level.bwars_flags[level.bwars_flags.size] = flag;
    }
}

player_hud_init()
{
    if ( isdefined( self.bwars_hud ) )
        return;

    self.bwars_hud = [];
    x = -40;
    y = 300;

    for ( i = 0; i < 4; i++ )
    {
        hud = newclienthudelem( self );
        hud.alignx = "left";
        hud.aligny = "middle";
        hud.foreground = 1;
        hud.fontscale = 1.5;
        hud.alpha = 0.8;
        hud.x = x;
        hud.y = y;
        hud.hidewhendead = 1;
        hud.hidewheninkillcam = 1;
        hud.score = newclienthudelem( self );
        hud.score.alignx = "left";
        hud.score.aligny = "middle";
        hud.score.foreground = 1;
        hud.score.fontscale = 1.5;
        hud.score.alpha = 0.8;
        hud.score.x = x + 125;
        hud.score.y = y;
        hud.score.hidewhendead = 1;
        hud.score.hidewheninkillcam = 1;
        self.bwars_hud[self.bwars_hud.size] = hud;
        y = y + 15;
    }

    level bwars_scoreboard_update();
}

player_hud_update( names, scores )
{
    if ( !isdefined( self.bwars_hud ) )
        return;

    for ( i = 0; i < 4; i++ )
    {
        self.bwars_hud[i] settext( names[i] );

        if ( names[i] == "" )
            self.bwars_hud[i].score settext( "" );
        else
            self.bwars_hud[i].score setvalue( scores[i] );

        if ( names[i] == self.name )
        {
            self.bwars_hud[i].color = ( 1, 0.84, 0 );
            self.bwars_hud[i].score.color = ( 1, 0.84, 0 );
            continue;
        }

        self.bwars_hud[i].color = ( 1, 1, 1 );
        self.bwars_hud[i].score.color = ( 1, 1, 1 );
    }
}

bubblesort_players()
{
    players = get_players();

    while ( true )
    {
        swapped = 0;

        for ( i = 1; i < players.size; i++ )
        {
            if ( players[i - 1].score < players[i].score )
            {
                t = players[i - 1];
                players[i - 1] = players[i];
                players[i] = t;
                swapped = 1;
            }
        }

        if ( !swapped )
            break;
    }

    return players;
}

bwars_scoreboard_update()
{
    names = [];
    scores = [];
    players = bubblesort_players();

    for ( i = 0; i < 4; i++ )
    {
        if ( players.size > i )
        {
            names[i] = players[i].name;
            scores[i] = players[i].score;
            continue;
        }

        names[i] = "";
        scores[i] = -1;
    }

    foreach ( player in players )
        player player_hud_update( names, scores );
}

flag_model_init()
{
    visuals = [];
    visuals[0] = spawn( "script_model", self.origin );
    visuals[0].angles = self.angles;
    visuals[0] setmodel( "mp_flag_neutral" );
    visuals[0] setinvisibletoall();
    visuals[1] = spawn( "script_model", self.origin );
    visuals[1].angles = self.angles;
    visuals[1] setmodel( "mp_flag_neutral" );
    visuals[1] setvisibletoall();
    return visuals;
}

flag_model_update()
{
    owner = self maps\mp\gametypes\_gameobjects::getownerteam();
    self.visuals[0] setmodel( "mp_flag_green" );
    self.visuals[0] setinvisibletoall();
    self.visuals[0] setvisibletoplayer( owner );
    self.visuals[1] setmodel( "mp_flag_red" );
    self.visuals[1] setvisibletoall();
    self.visuals[1] setinvisibletoplayer( owner );
}

flag_compass_init()
{
    self.compass_icons = [];
    self.compass_icons[0] = maps\mp\gametypes\_gameobjects::getnextobjid();
    self.compass_icons[1] = maps\mp\gametypes\_gameobjects::getnextobjid();
    label = self maps\mp\gametypes\_gameobjects::getlabel();
    objective_add( self.compass_icons[0], "active", self.curorigin );
    objective_icon( self.compass_icons[0], "compass_waypoint_defend" + label );
    objective_setinvisibletoall( self.compass_icons[0] );
    objective_add( self.compass_icons[1], "active", self.curorigin );
    objective_icon( self.compass_icons[1], "compass_waypoint_captureneutral" + label );
    objective_setvisibletoall( self.compass_icons[1] );
}

flag_compass_update()
{
    label = self maps\mp\gametypes\_gameobjects::getlabel();
    owner = self maps\mp\gametypes\_gameobjects::getownerteam();
    objective_icon( self.compass_icons[0], "compass_waypoint_defend" + label );
    objective_state( self.compass_icons[0], "active" );
    objective_setinvisibletoall( self.compass_icons[0] );
    objective_setvisibletoplayer( self.compass_icons[0], owner );
    objective_icon( self.compass_icons[1], "compass_waypoint_capture" + label );
    objective_state( self.compass_icons[1], "active" );
    objective_setvisibletoall( self.compass_icons[1] );
    objective_setinvisibletoplayer( self.compass_icons[1], owner );
}

player_world_icon_init()
{
    if ( isdefined( self.bwars_icons ) )
        return;

    self.bwars_icons = [];

    foreach ( flag in level.bwars_flags )
    {
        icon = newclienthudelem( self );
        icon.flag = flag;
        icon.x = flag.curorigin[0];
        icon.y = flag.curorigin[1];
        icon.z = flag.curorigin[2] + 100;
        icon.fadewhentargeted = 1;
        icon.archived = 0;
        icon.alpha = 1;
        self.bwars_icons[self.bwars_icons.size] = icon;
    }

    self player_world_icon_update();
}

player_world_icon_update()
{
    assert( isdefined( self.bwars_icons ) );

    foreach ( icon in self.bwars_icons )
    {
        label = icon.flag maps\mp\gametypes\_gameobjects::getlabel();
        owner = icon.flag maps\mp\gametypes\_gameobjects::getownerteam();

        if ( isstring( owner ) && owner == "neutral" )
        {
            icon setwaypoint( 1, "waypoint_captureneutral" + label );
            continue;
        }

        if ( owner == self )
        {
            icon setwaypoint( 1, "waypoint_defend" + label );
            continue;
        }

        icon setwaypoint( 1, "waypoint_capture" + label );
    }
}

world_icon_update()
{
    players = get_players();

    foreach ( player in players )
        player player_world_icon_update();
}

getunownedflagneareststart( team, excludeflag )
{
    best = undefined;
    bestdistsq = undefined;

    for ( i = 0; i < level.flags.size; i++ )
    {
        flag = level.flags[i];

        if ( flag getflagteam() != "neutral" )
            continue;

        distsq = distancesquared( flag.origin, level.startpos[team] );

        if ( ( !isdefined( excludeflag ) || flag != excludeflag ) && ( !isdefined( best ) || distsq < bestdistsq ) )
        {
            bestdistsq = distsq;
            best = flag;
        }
    }

    return best;
}

onbeginuse( player )
{

}

onuseupdate( team, progress, change )
{

}

statusdialog( dialog, team )
{
    time = gettime();

    if ( gettime() < level.laststatus[team] + 6000 )
        return;

    thread delayedleaderdialog( dialog, team );
    level.laststatus[team] = gettime();
}

statusdialogenemies( dialog, friend_team )
{
    foreach ( team in level.teams )
    {
        if ( team == friend_team )
            continue;

        statusdialog( dialog, team );
    }
}

onenduse( team, player, success )
{

}

resetflagbaseeffect()
{

}

onuse( player )
{
    self maps\mp\gametypes\_gameobjects::setownerteam( player );
    self maps\mp\gametypes\_gameobjects::allowuse( "enemy" );
    self flag_compass_update();
    self flag_model_update();
    level world_icon_update();
    level bwars_spawns_update();
}

give_capture_credit( touchlist, string )
{
    wait 0.05;
    maps\mp\gametypes\_globallogic_utils::waittillslowprocessallowed();
    self updatecapsperminute();
    players = getarraykeys( touchlist );

    for ( i = 0; i < players.size; i++ )
    {
        player_from_touchlist = touchlist[players[i]].player;
        player_from_touchlist updatecapsperminute();

        if ( !isscoreboosting( player_from_touchlist, self ) )
        {
            if ( isdefined( player_from_touchlist.pers["captures"] ) )
            {
                player_from_touchlist.pers["captures"]++;
                player_from_touchlist.captures = player_from_touchlist.pers["captures"];
            }

            maps\mp\_demo::bookmark( "event", gettime(), player_from_touchlist );
            player_from_touchlist addplayerstatwithgametype( "CAPTURES", 1 );
        }

        level thread maps\mp\_popups::displayteammessagetoall( string, player_from_touchlist );
    }
}

delayedleaderdialog( sound, team )
{
    wait 0.1;
    maps\mp\gametypes\_globallogic_utils::waittillslowprocessallowed();
    maps\mp\gametypes\_globallogic_audio::leaderdialog( sound, team );
}

delayedleaderdialogbothteams( sound1, team1, sound2, team2 )
{
    wait 0.1;
    maps\mp\gametypes\_globallogic_utils::waittillslowprocessallowed();
    maps\mp\gametypes\_globallogic_audio::leaderdialogbothteams( sound1, team1, sound2, team2 );
}

bwars_update_scores()
{
    while ( !level.gameended )
    {
        foreach ( flag in level.bwars_flags )
        {
            owner = flag maps\mp\gametypes\_gameobjects::getownerteam();

            if ( isplayer( owner ) )
                owner.score = owner.score + 1;
        }

        level bwars_scoreboard_update();
        players = get_players();

        foreach ( player in players )
            player maps\mp\gametypes\_globallogic::checkscorelimit();

        wait 5.0;
        maps\mp\gametypes\_hostmigration::waittillhostmigrationdone();
    }
}

onroundswitch()
{
    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    game["switchedsides"] = !game["switchedsides"];

    if ( level.roundscorecarry == 0 )
    {
        [[ level._setteamscore ]]( "allies", game["roundswon"]["allies"] );
        [[ level._setteamscore ]]( "axis", game["roundswon"]["axis"] );
    }
}

onplayerkilled( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{

}

getteamflagcount( team )
{
    score = 0;

    for ( i = 0; i < level.flags.size; i++ )
    {
        if ( level.domflags[i] maps\mp\gametypes\_gameobjects::getownerteam() == team )
            score++;
    }

    return score;
}

getflagteam()
{
    return self.useobj maps\mp\gametypes\_gameobjects::getownerteam();
}

getboundaryflags()
{
    bflags = [];

    for ( i = 0; i < level.flags.size; i++ )
    {
        for ( j = 0; j < level.flags[i].adjflags.size; j++ )
        {
            if ( level.flags[i].useobj maps\mp\gametypes\_gameobjects::getownerteam() != level.flags[i].adjflags[j].useobj maps\mp\gametypes\_gameobjects::getownerteam() )
            {
                bflags[bflags.size] = level.flags[i];
                break;
            }
        }
    }

    return bflags;
}

getboundaryflagspawns( team )
{
    spawns = [];
    bflags = getboundaryflags();

    for ( i = 0; i < bflags.size; i++ )
    {
        if ( isdefined( team ) && bflags[i] getflagteam() != team )
            continue;

        for ( j = 0; j < bflags[i].nearbyspawns.size; j++ )
            spawns[spawns.size] = bflags[i].nearbyspawns[j];
    }

    return spawns;
}

getspawnsboundingflag( avoidflag )
{
    spawns = [];

    for ( i = 0; i < level.flags.size; i++ )
    {
        flag = level.flags[i];

        if ( flag == avoidflag )
            continue;

        isbounding = 0;

        for ( j = 0; j < flag.adjflags.size; j++ )
        {
            if ( flag.adjflags[j] == avoidflag )
            {
                isbounding = 1;
                break;
            }
        }

        if ( !isbounding )
            continue;

        for ( j = 0; j < flag.nearbyspawns.size; j++ )
            spawns[spawns.size] = flag.nearbyspawns[j];
    }

    return spawns;
}

getownedandboundingflagspawns( team )
{
    spawns = [];

    for ( i = 0; i < level.flags.size; i++ )
    {
        if ( level.flags[i] getflagteam() == team )
        {
            for ( s = 0; s < level.flags[i].nearbyspawns.size; s++ )
                spawns[spawns.size] = level.flags[i].nearbyspawns[s];

            continue;
        }

        for ( j = 0; j < level.flags[i].adjflags.size; j++ )
        {
            if ( level.flags[i].adjflags[j] getflagteam() == team )
            {
                for ( s = 0; s < level.flags[i].nearbyspawns.size; s++ )
                    spawns[spawns.size] = level.flags[i].nearbyspawns[s];

                break;
            }
        }
    }

    return spawns;
}

getownedflagspawns( team )
{
    spawns = [];

    for ( i = 0; i < level.flags.size; i++ )
    {
        if ( level.flags[i] getflagteam() == team )
        {
            for ( s = 0; s < level.flags[i].nearbyspawns.size; s++ )
                spawns[spawns.size] = level.flags[i].nearbyspawns[s];
        }
    }

    return spawns;
}

flagsetup()
{
    maperrors = [];
    descriptorsbylinkname = [];
    descriptors = getentarray( "flag_descriptor", "targetname" );
    flags = level.flags;

    for ( i = 0; i < level.domflags.size; i++ )
    {
        closestdist = undefined;
        closestdesc = undefined;

        for ( j = 0; j < descriptors.size; j++ )
        {
            dist = distance( flags[i].origin, descriptors[j].origin );

            if ( !isdefined( closestdist ) || dist < closestdist )
            {
                closestdist = dist;
                closestdesc = descriptors[j];
            }
        }

        if ( !isdefined( closestdesc ) )
        {
            maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
            break;
        }

        if ( isdefined( closestdesc.flag ) )
        {
            maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
            continue;
        }

        flags[i].descriptor = closestdesc;
        closestdesc.flag = flags[i];
        descriptorsbylinkname[closestdesc.script_linkname] = closestdesc;
    }

    if ( maperrors.size == 0 )
    {
        for ( i = 0; i < flags.size; i++ )
        {
            if ( isdefined( flags[i].descriptor.script_linkto ) )
                adjdescs = strtok( flags[i].descriptor.script_linkto, " " );
            else
                adjdescs = [];

            for ( j = 0; j < adjdescs.size; j++ )
            {
                otherdesc = descriptorsbylinkname[adjdescs[j]];

                if ( !isdefined( otherdesc ) || otherdesc.targetname != "flag_descriptor" )
                {
                    maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
                    continue;
                }

                adjflag = otherdesc.flag;

                if ( adjflag == flags[i] )
                {
                    maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to itself";
                    continue;
                }

                flags[i].adjflags[flags[i].adjflags.size] = adjflag;
            }
        }
    }

    spawnpoints = maps\mp\gametypes\_spawnlogic::getspawnpointarray( "mp_dom_spawn" );

    for ( i = 0; i < spawnpoints.size; i++ )
    {
        if ( isdefined( spawnpoints[i].script_linkto ) )
        {
            desc = descriptorsbylinkname[spawnpoints[i].script_linkto];

            if ( !isdefined( desc ) || desc.targetname != "flag_descriptor" )
            {
                maperrors[maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
                continue;
            }

            nearestflag = desc.flag;
        }
        else
        {
            nearestflag = undefined;
            nearestdist = undefined;

            for ( j = 0; j < flags.size; j++ )
            {
                dist = distancesquared( flags[j].origin, spawnpoints[i].origin );

                if ( !isdefined( nearestflag ) || dist < nearestdist )
                {
                    nearestflag = flags[j];
                    nearestdist = dist;
                }
            }
        }

        nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
    }

    if ( maperrors.size > 0 )
    {
/#
        println( "^1------------ Map Errors ------------" );

        for ( i = 0; i < maperrors.size; i++ )
            println( maperrors[i] );

        println( "^1------------------------------------" );
        maps\mp\_utility::error( "Map errors. See above" );
#/
        maps\mp\gametypes\_callbacksetup::abortlevel();
        return;
    }
}

createflagspawninfluencers()
{
    ss = level.spawnsystem;

    for ( flag_index = 0; flag_index < level.flags.size; flag_index++ )
    {
        if ( level.domflags[flag_index] == self )
            break;
    }

    abc = [];
    abc[0] = "A";
    abc[1] = "B";
    abc[2] = "C";
    self.owned_flag_influencer = addsphereinfluencer( level.spawnsystem.einfluencer_type_game_mode, self.trigger.origin, ss.dom_owned_flag_influencer_radius[flag_index], ss.dom_owned_flag_influencer_score[flag_index], 0, "dom_owned_flag_" + abc[flag_index] + ",r,s", maps\mp\gametypes\_spawning::get_score_curve_index( ss.dom_owned_flag_influencer_score_curve ) );
    self.neutral_flag_influencer = addsphereinfluencer( level.spawnsystem.einfluencer_type_game_mode, self.trigger.origin, ss.dom_unowned_flag_influencer_radius, ss.dom_unowned_flag_influencer_score, 0, "dom_unowned_flag,r,s", maps\mp\gametypes\_spawning::get_score_curve_index( ss.dom_owned_flag_influencer_score_curve ) );
    self.enemy_flag_influencer = addsphereinfluencer( level.spawnsystem.einfluencer_type_game_mode, self.trigger.origin, ss.dom_enemy_flag_influencer_radius[flag_index], ss.dom_enemy_flag_influencer_score[flag_index], 0, "dom_enemy_flag_" + abc[flag_index] + ",r,s", maps\mp\gametypes\_spawning::get_score_curve_index( ss.dom_enemy_flag_influencer_score_curve ) );
    self update_spawn_influencers( "neutral" );
}

update_spawn_influencers( team )
{
    assert( isdefined( self.neutral_flag_influencer ) );
    assert( isdefined( self.owned_flag_influencer ) );
    assert( isdefined( self.enemy_flag_influencer ) );

    if ( team == "neutral" )
    {
        enableinfluencer( self.neutral_flag_influencer, 1 );
        enableinfluencer( self.owned_flag_influencer, 0 );
        enableinfluencer( self.enemy_flag_influencer, 0 );
    }
    else
    {
        enableinfluencer( self.neutral_flag_influencer, 0 );
        enableinfluencer( self.owned_flag_influencer, 1 );
        enableinfluencer( self.enemy_flag_influencer, 1 );
        setinfluencerteammask( self.owned_flag_influencer, getteammask( team ) );
        setinfluencerteammask( self.enemy_flag_influencer, getotherteamsmask( team ) );
    }
}

dom_gamemodespawndvars( reset_dvars )
{
    ss = level.spawnsystem;
    ss.dom_owned_flag_influencer_score = [];
    ss.dom_owned_flag_influencer_radius = [];
    ss.dom_owned_flag_influencer_score[0] = set_dvar_float_if_unset( "scr_spawn_dom_owned_flag_A_influencer_score", "10", reset_dvars );
    ss.dom_owned_flag_influencer_radius[0] = set_dvar_float_if_unset( "scr_spawn_dom_owned_flag_A_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
    ss.dom_owned_flag_influencer_score[1] = set_dvar_float_if_unset( "scr_spawn_dom_owned_flag_B_influencer_score", "10", reset_dvars );
    ss.dom_owned_flag_influencer_radius[1] = set_dvar_float_if_unset( "scr_spawn_dom_owned_flag_B_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
    ss.dom_owned_flag_influencer_score[2] = set_dvar_float_if_unset( "scr_spawn_dom_owned_flag_C_influencer_score", "10", reset_dvars );
    ss.dom_owned_flag_influencer_radius[2] = set_dvar_float_if_unset( "scr_spawn_dom_owned_flag_C_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
    ss.dom_owned_flag_influencer_score_curve = set_dvar_if_unset( "scr_spawn_dom_owned_flag_influencer_score_curve", "constant", reset_dvars );
    ss.dom_enemy_flag_influencer_score = [];
    ss.dom_enemy_flag_influencer_radius = [];
    ss.dom_enemy_flag_influencer_score[0] = set_dvar_float_if_unset( "scr_spawn_dom_enemy_flag_A_influencer_score", "-10", reset_dvars );
    ss.dom_enemy_flag_influencer_radius[0] = set_dvar_float_if_unset( "scr_spawn_dom_enemy_flag_A_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
    ss.dom_enemy_flag_influencer_score[1] = set_dvar_float_if_unset( "scr_spawn_dom_enemy_flag_B_influencer_score", "-10", reset_dvars );
    ss.dom_enemy_flag_influencer_radius[1] = set_dvar_float_if_unset( "scr_spawn_dom_enemy_flag_B_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
    ss.dom_enemy_flag_influencer_score[2] = set_dvar_float_if_unset( "scr_spawn_dom_enemy_flag_C_influencer_score", "-10", reset_dvars );
    ss.dom_enemy_flag_influencer_radius[2] = set_dvar_float_if_unset( "scr_spawn_dom_enemy_flag_C_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
    ss.dom_enemy_flag_influencer_score_curve = set_dvar_if_unset( "scr_spawn_dom_enemy_flag_influencer_score_curve", "constant", reset_dvars );
    ss.dom_unowned_flag_influencer_score = set_dvar_float_if_unset( "scr_spawn_dom_unowned_flag_influencer_score", "-500", reset_dvars );
    ss.dom_unowned_flag_influencer_score_curve = set_dvar_if_unset( "scr_spawn_dom_unowned_flag_influencer_score_curve", "constant", reset_dvars );
    ss.dom_unowned_flag_influencer_radius = set_dvar_float_if_unset( "scr_spawn_dom_unowned_flag_influencer_radius", "" + 15.0 * get_player_height(), reset_dvars );
}

bwars_spawns_update()
{
    maps\mp\gametypes\_spawnlogic::clearspawnpoints();
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_dom_spawn" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_dom_spawn" );
    maps\mp\gametypes\_spawning::updateallspawnpoints();
}

dominated_challenge_check()
{
    num_flags = level.flags.size;
    allied_flags = 0;
    axis_flags = 0;

    for ( i = 0; i < num_flags; i++ )
    {
        flag_team = level.flags[i] getflagteam();

        if ( flag_team == "allies" )
            allied_flags++;
        else if ( flag_team == "axis" )
            axis_flags++;
        else
            return false;

        if ( allied_flags > 0 && axis_flags > 0 )
            return false;
    }

    return true;
}

dominated_check()
{
    num_flags = level.flags.size;
    allied_flags = 0;
    axis_flags = 0;

    for ( i = 0; i < num_flags; i++ )
    {
        flag_team = level.flags[i] getflagteam();

        if ( flag_team == "allies" )
            allied_flags++;
        else if ( flag_team == "axis" )
            axis_flags++;

        if ( allied_flags > 0 && axis_flags > 0 )
            return false;
    }

    return true;
}

updatecapsperminute()
{
    if ( !isdefined( self.capsperminute ) )
    {
        self.numcaps = 0;
        self.capsperminute = 0;
    }

    self.numcaps++;
    minutespassed = maps\mp\gametypes\_globallogic_utils::gettimepassed() / 60000;

    if ( isplayer( self ) && isdefined( self.timeplayed["total"] ) )
        minutespassed = self.timeplayed["total"] / 60;

    self.capsperminute = self.numcaps / minutespassed;

    if ( self.capsperminute > self.numcaps )
        self.capsperminute = self.numcaps;
}

isscoreboosting( player, flag )
{
    if ( !level.rankedmatch )
        return false;

    if ( player.capsperminute > level.playercapturelpm )
        return true;

    if ( flag.capsperminute > level.flagcapturelpm )
        return true;

    if ( player.numcaps > level.playercapturemax )
        return true;

    return false;
}
