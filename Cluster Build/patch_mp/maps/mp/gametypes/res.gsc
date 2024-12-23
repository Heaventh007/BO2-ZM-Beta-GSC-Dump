// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\gametypes\_callbacksetup;
#include maps\mp\gametypes\_gameobjects;
#include maps\mp\gametypes\_spawning;
#include maps\mp\gametypes\_spawnlogic;
#include maps\mp\gametypes\_globallogic_score;
#include maps\mp\gametypes\_globallogic_defaults;
#include maps\mp\teams\_teams;
#include maps\mp\gametypes\_globallogic_utils;
#include maps\mp\gametypes\_objpoints;
#include maps\mp\gametypes\_globallogic_audio;
#include maps\mp\_demo;
#include maps\mp\_popups;
#include maps\mp\_medals;
#include maps\mp\_scoreevents;

main()
{
    if ( getdvar( #"mapname" ) == "mp_background" )
        return;

    maps\mp\gametypes\_globallogic::init();
    maps\mp\gametypes\_callbacksetup::setupcallbacks();
    maps\mp\gametypes\_globallogic::setupcallbacks();
    registerroundswitch( 0, 9 );
    registertimelimit( 0, 2.5 );
    registerscorelimit( 0, 1000 );
    registerroundlimit( 0, 10 );
    registerroundwinlimit( 0, 10 );
    registernumlives( 0, 100 );
    maps\mp\gametypes\_globallogic::registerfriendlyfiredelay( level.gametype, 15, 0, 1440 );
    level.teambased = 1;
    level.overrideteamscore = 1;
    level.onstartgametype = ::onstartgametype;
    level.onroundswitch = ::onroundswitch;
    level.onspawnplayer = ::onspawnplayer;
    level.onspawnplayerunified = ::onspawnplayerunified;
    level.onplayerkilled = ::onplayerkilled;
    level.onprecachegametype = ::onprecachegametype;
    level.onendgame = ::onendgame;
    level.gamemodespawndvars = ::res_gamemodespawndvars;
    level.onroundendgame = ::onroundendgame;
    level.ontimelimit = ::ontimelimit;
    level.gettimelimit = ::gettimelimit;
    game["dialog"]["gametype"] = "res_start";
    game["dialog"]["gametype_hardcore"] = "hcres_start";
    game["dialog"]["offense_obj"] = "cap_start";
    game["dialog"]["defense_obj"] = "defend_start";
    level.lastdialogtime = 0;
    level.iconoffset = vectorscale( ( 0, 0, 1 ), 100.0 );
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
    precacheshader( "waypoint_targetneutral" );
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

onroundswitch()
{
    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
    {
        aheadteam = getbetterteam();

        if ( aheadteam != game["defenders"] )
            game["switchedsides"] = !game["switchedsides"];
        else
            level.halftimesubcaption = "";

        level.halftimetype = "overtime";
    }
    else
    {
        level.halftimetype = "halftime";
        game["switchedsides"] = !game["switchedsides"];
    }
}

getbetterteam()
{
    kills["allies"] = 0;
    kills["axis"] = 0;
    deaths["allies"] = 0;
    deaths["axis"] = 0;

    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];
        team = player.pers["team"];

        if ( isdefined( team ) && ( team == "allies" || team == "axis" ) )
        {
            kills[team] = kills[team] + player.kills;
            deaths[team] = deaths[team] + player.deaths;
        }
    }

    if ( kills["allies"] > kills["axis"] )
        return "allies";
    else if ( kills["axis"] > kills["allies"] )
        return "axis";

    if ( deaths["allies"] < deaths["axis"] )
        return "allies";
    else if ( deaths["axis"] < deaths["allies"] )
        return "axis";

    if ( randomint( 2 ) == 0 )
        return "allies";

    return "axis";
}

onstartgametype()
{
    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    if ( game["switchedsides"] )
    {
        oldattackers = game["attackers"];
        olddefenders = game["defenders"];
        game["attackers"] = olddefenders;
        game["defenders"] = oldattackers;
    }

    level.usingextratime = 0;
    game["strings"]["flags_capped"] = &"MP_TARGET_DESTROYED";
    setobjectivetext( game["attackers"], &"OBJECTIVES_RES_ATTACKER" );
    setobjectivetext( game["defenders"], &"OBJECTIVES_RES_DEFENDER" );

    if ( level.splitscreen )
    {
        setobjectivescoretext( game["attackers"], &"OBJECTIVES_RES_ATTACKER" );
        setobjectivescoretext( game["defenders"], &"OBJECTIVES_RES_DEFENDER" );
    }
    else
    {
        setobjectivescoretext( game["attackers"], &"OBJECTIVES_RES_ATTACKER_SCORE" );
        setobjectivescoretext( game["defenders"], &"OBJECTIVES_RES_DEFENDER_SCORE" );
    }

    setobjectivehinttext( game["attackers"], &"OBJECTIVES_RES_ATTACKER_HINT" );
    setobjectivehinttext( game["defenders"], &"OBJECTIVES_RES_DEFENDER_HINT" );
    level.objectivehintpreparehq = &"MP_CONTROL_HQ";
    level.objectivehintcapturehq = &"MP_CAPTURE_HQ";
    level.objectivehintdefendhq = &"MP_DEFEND_HQ";
    precachestring( level.objectivehintpreparehq );
    precachestring( level.objectivehintcapturehq );
    precachestring( level.objectivehintdefendhq );
    level.flagbasefxid = [];
    level.flagbasefxid["allies"] = loadfx( "misc/fx_ui_flagbase_" + game["allies"] );
    level.flagbasefxid["axis"] = loadfx( "misc/fx_ui_flagbase_" + game["axis"] );
    setclientnamemode( "auto_change" );
    allowed[0] = "res";
    maps\mp\gametypes\_gameobjects::main( allowed );
    maps\mp\gametypes\_spawning::create_map_placed_influencers();
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    maps\mp\gametypes\_spawnlogic::placespawnpoints( "mp_res_spawn_allies_start" );
    maps\mp\gametypes\_spawnlogic::placespawnpoints( "mp_res_spawn_axis_start" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_res_spawn_allies" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_res_spawn_axis" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_res_spawn_axis_a" );
    maps\mp\gametypes\_spawnlogic::dropspawnpoints( "mp_res_spawn_allies_a" );
    maps\mp\gametypes\_spawning::updateallspawnpoints();
    level.mapcenter = maps\mp\gametypes\_spawnlogic::findboxcenter( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );
    spawnpoint = maps\mp\gametypes\_spawnlogic::getrandomintermissionpoint();
    setdemointermissionpoint( spawnpoint.origin, spawnpoint.angles );
    level.spawn_start = [];

    foreach ( team in level.teams )
        level.spawn_start[team] = maps\mp\gametypes\_spawnlogic::getspawnpointarray( "mp_res_spawn_" + team + "_start" );

    hud_createflagprogressbar();
    updategametypedvars();
    thread createtimerdisplay();
    thread resflagsinit();
    level.overtime = 0;
    overtime = 0;

    if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
        overtime = 1;

    if ( overtime )
        maps\mp\gametypes\_spawnlogic::clearspawnpoints();

    maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_res_spawn_allies_a" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_res_spawn_axis" );
    maps\mp\gametypes\_spawning::updateallspawnpoints();

    if ( overtime )
        setupnextflag( int( level.resflags.size / 3 ) );
    else
        setupnextflag( 0 );

    level.overtime = overtime;

    if ( level.flagactivatedelay )
        updateobjectivehintmessages( level.objectivehintpreparehq, level.objectivehintpreparehq );
    else
        updateobjectivehintmessages( level.objectivehintcapturehq, level.objectivehintcapturehq );
}

onspawnplayerunified()
{
    if ( level.usestartspawns && !level.ingraceperiod )
        level.usestartspawns = 0;

    maps\mp\gametypes\_spawning::onspawnplayer_unified();
}

onspawnplayer( predictedspawn )
{
    spawnpoint = undefined;

    if ( self.pers["team"] == game["defenders"] )
        spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_random( level.spawn_start["axis"] );
    else
        spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_random( level.spawn_start["allies"] );

    if ( predictedspawn )
        self predictspawnpoint( spawnpoint.origin, spawnpoint.angles );
    else
        self spawn( spawnpoint.origin, spawnpoint.angles, "res" );
}

onendgame( winningteam )
{
    for ( i = 0; i < level.resflags.size; i++ )
        level.resflags[i] maps\mp\gametypes\_gameobjects::allowuse( "none" );
}

onroundendgame( roundwinner )
{
    winner = maps\mp\gametypes\_globallogic::determineteamwinnerbygamestat( "roundswon" );
    return winner;
}

res_endgame( winningteam, endreasontext )
{
    if ( isdefined( winningteam ) && winningteam != "tie" )
        maps\mp\gametypes\_globallogic_score::giveteamscoreforobjective( winningteam, 1 );

    thread maps\mp\gametypes\_globallogic::endgame( winningteam, endreasontext );
}

ontimelimit()
{
    if ( level.overtime )
    {
        if ( isdefined( level.resprogressteam ) )
            res_endgame( level.resprogressteam, game["strings"]["time_limit_reached"] );
        else
            res_endgame( "tie", game["strings"]["time_limit_reached"] );
    }
    else
        res_endgame( game["defenders"], game["strings"]["time_limit_reached"] );
}

gettimelimit()
{
    timelimit = maps\mp\gametypes\_globallogic_defaults::default_gettimelimit();

    if ( level.usingextratime )
    {
        flagcount = 0;

        if ( isdefined( level.currentflag ) )
            flagcount = flagcount + level.currentflag.orderindex;

        return timelimit + level.extratime * flagcount;
    }

    return timelimit;
}

updategametypedvars()
{
    level.flagcapturetime = getgametypesetting( "captureTime" );
    level.flagdecaytime = getgametypesetting( "flagDecayTime" );
    level.flagactivatedelay = getgametypesetting( "objectiveSpawnTime" );
    level.flaginactiveresettime = getgametypesetting( "idleFlagResetTime" );
    level.flaginactivedecay = getgametypesetting( "idleFlagDecay" );
    level.extratime = getgametypesetting( "extraTime" );
    level.flagcapturegraceperiod = getgametypesetting( "flagCaptureGracePeriod" );
    level.playeroffensivemax = getgametypesetting( "maxPlayerOffensive" );
    level.playerdefensivemax = getgametypesetting( "maxPlayerDefensive" );
}

resflagsinit()
{
    level.laststatus["allies"] = 0;
    level.laststatus["axis"] = 0;
    level.flagmodel["allies"] = maps\mp\teams\_teams::getteamflagmodel( "allies" );
    level.flagmodel["axis"] = maps\mp\teams\_teams::getteamflagmodel( "axis" );
    level.flagmodel["neutral"] = maps\mp\teams\_teams::getteamflagmodel( "neutral" );
    precachemodel( level.flagmodel["allies"] );
    precachemodel( level.flagmodel["axis"] );
    precachemodel( level.flagmodel["neutral"] );
    precachestring( &"MP_TIME_EXTENDED" );
    precachestring( &"MP_CAPTURING_FLAG" );
    precachestring( &"MP_LOSING_FLAG" );
    precachestring( &"MP_RES_YOUR_FLAG_WAS_CAPTURED" );
    precachestring( &"MP_RES_ENEMY_FLAG_CAPTURED" );
    precachestring( &"MP_RES_NEUTRAL_FLAG_CAPTURED" );
    precachestring( &"MP_ENEMY_FLAG_CAPTURED_BY" );
    precachestring( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
    precachestring( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_A_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_B_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_C_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_D_CAPTURED_BY" );
    precachestring( &"MP_DOM_FLAG_E_CAPTURED_BY" );
    primaryflags = getentarray( "res_flag_primary", "targetname" );

    if ( primaryflags.size < 2 )
    {
/#
        println( "^1Not enough Resistance flags found in level!" );
#/
        maps\mp\gametypes\_callbacksetup::abortlevel();
        return;
    }

    level.flags = [];

    for ( index = 0; index < primaryflags.size; index++ )
        level.flags[level.flags.size] = primaryflags[index];

    level.resflags = [];

    for ( index = 0; index < level.flags.size; index++ )
    {
        trigger = level.flags[index];

        if ( isdefined( trigger.target ) )
            visuals[0] = getent( trigger.target, "targetname" );
        else
        {
            visuals[0] = spawn( "script_model", trigger.origin );
            visuals[0].angles = trigger.angles;
        }

        visuals[0] setmodel( level.flagmodel[game["defenders"]] );
        resflag = maps\mp\gametypes\_gameobjects::createuseobject( game["defenders"], trigger, visuals, level.iconoffset );
        resflag maps\mp\gametypes\_gameobjects::allowuse( "none" );
        resflag maps\mp\gametypes\_gameobjects::setusetime( level.flagcapturetime );
        resflag maps\mp\gametypes\_gameobjects::setusetext( &"MP_CAPTURING_FLAG" );
        resflag maps\mp\gametypes\_gameobjects::setdecaytime( level.flagdecaytime );
        label = resflag maps\mp\gametypes\_gameobjects::getlabel();
        resflag.label = label;
        resflag maps\mp\gametypes\_gameobjects::setmodelvisibility( 0 );
        resflag.onuse = ::onuse;
        resflag.onbeginuse = ::onbeginuse;
        resflag.onuseupdate = ::onuseupdate;
        resflag.onuseclear = ::onuseclear;
        resflag.onenduse = ::onenduse;
        resflag.claimgraceperiod = level.flagcapturegraceperiod;
        resflag.decayprogress = level.flaginactivedecay;
        tracestart = visuals[0].origin + vectorscale( ( 0, 0, 1 ), 32.0 );
        traceend = visuals[0].origin + vectorscale( ( 0, 0, -1 ), 32.0 );
        trace = bullettrace( tracestart, traceend, 0, undefined );
        upangles = vectortoangles( trace["normal"] );
        resflag.baseeffectforward = anglestoforward( upangles );
        resflag.baseeffectright = anglestoright( upangles );
        resflag.baseeffectpos = trace["position"];
        level.flags[index].useobj = resflag;
        level.flags[index].nearbyspawns = [];
        resflag.levelflag = level.flags[index];
        level.resflags[level.resflags.size] = resflag;
    }

    sortflags();
    level.bestspawnflag = [];
    level.bestspawnflag["allies"] = getunownedflagneareststart( "allies", undefined );
    level.bestspawnflag["axis"] = getunownedflagneareststart( "axis", level.bestspawnflag["allies"] );

    for ( index = 0; index < level.resflags.size; index++ )
        level.resflags[index] createflagspawninfluencers();
}

sortflags()
{
    flagorder["_a"] = 0;
    flagorder["_b"] = 1;
    flagorder["_c"] = 2;
    flagorder["_d"] = 3;
    flagorder["_e"] = 4;

    for ( i = 0; i < level.resflags.size; i++ )
    {
        level.resflags[i].orderindex = flagorder[level.resflags[i].label];
        assert( isdefined( level.resflags[i].orderindex ) );
    }

    for ( i = 1; i < level.resflags.size; i++ )
    {
        for ( j = 0; j < level.resflags.size - i; j++ )
        {
            if ( level.resflags[j].orderindex > level.resflags[j + 1].orderindex )
            {
                temp = level.resflags[j];
                level.resflags[j] = level.resflags[j + 1];
                level.resflags[j + 1] = temp;
            }
        }
    }
}

setupnextflag( flagindex )
{
    prevflagindex = flagindex - 1;

    if ( prevflagindex >= 0 )
        thread hideflag( prevflagindex );

    if ( flagindex < level.resflags.size && !level.overtime )
        thread showflag( flagindex );
    else
    {
        maps\mp\gametypes\_globallogic_utils::resumetimer();
        hud_hideflagprogressbar();
    }
}

createtimerdisplay()
{
    flagspawninginstr = &"MP_HQ_AVAILABLE_IN";
    precachestring( flagspawninginstr );
    level.locationobjid = maps\mp\gametypes\_gameobjects::getnextobjid();
    level.timerdisplay = [];
    level.timerdisplay["allies"] = createservertimer( "objective", 1.4, "allies" );
    level.timerdisplay["allies"] setpoint( "TOPCENTER", "TOPCENTER", 0, 0 );
    level.timerdisplay["allies"].label = flagspawninginstr;
    level.timerdisplay["allies"].alpha = 0;
    level.timerdisplay["allies"].archived = 0;
    level.timerdisplay["allies"].hidewheninmenu = 1;
    level.timerdisplay["axis"] = createservertimer( "objective", 1.4, "axis" );
    level.timerdisplay["axis"] setpoint( "TOPCENTER", "TOPCENTER", 0, 0 );
    level.timerdisplay["axis"].label = flagspawninginstr;
    level.timerdisplay["axis"].alpha = 0;
    level.timerdisplay["axis"].archived = 0;
    level.timerdisplay["axis"].hidewheninmenu = 1;
    thread hidetimerdisplayongameend( level.timerdisplay["allies"] );
    thread hidetimerdisplayongameend( level.timerdisplay["axis"] );
}

hidetimerdisplayongameend( timerdisplay )
{
    level waittill( "game_ended" );
    timerdisplay.alpha = 0;
}

showflag( flagindex )
{
    assert( flagindex < level.resflags.size );
    resflag = level.resflags[flagindex];
    label = resflag.label;
    resflag maps\mp\gametypes\_gameobjects::setvisibleteam( "any" );
    resflag maps\mp\gametypes\_gameobjects::setmodelvisibility( 1 );
    level.currentflag = resflag;

    if ( level.flagactivatedelay )
    {
        hud_hideflagprogressbar();

        if ( level.prematchperiod > 0 && level.inprematchperiod == 1 )
            level waittill( "prematch_over" );

        nextobjpoint = maps\mp\gametypes\_objpoints::createteamobjpoint( "objpoint_next_hq", resflag.curorigin + level.iconoffset, "all", "waypoint_targetneutral" );
        nextobjpoint setwaypoint( 1, "waypoint_targetneutral" );
        objective_position( level.locationobjid, resflag.curorigin );
        objective_icon( level.locationobjid, "waypoint_targetneutral" );
        objective_state( level.locationobjid, "active" );
        updateobjectivehintmessages( level.objectivehintpreparehq, level.objectivehintdefendhq );
        flagspawninginstr = &"MP_HQ_AVAILABLE_IN";
        level.timerdisplay["allies"].label = flagspawninginstr;
        level.timerdisplay["allies"] settimer( level.flagactivatedelay );
        level.timerdisplay["allies"].alpha = 1;
        level.timerdisplay["axis"].label = flagspawninginstr;
        level.timerdisplay["axis"] settimer( level.flagactivatedelay );
        level.timerdisplay["axis"].alpha = 1;
        wait( level.flagactivatedelay );
        maps\mp\gametypes\_objpoints::deleteobjpoint( nextobjpoint );
        objective_state( level.locationobjid, "invisible" );
        maps\mp\gametypes\_globallogic_audio::leaderdialog( "hq_online" );
        hud_showflagprogressbar();
    }

    level.timerdisplay["allies"].alpha = 0;
    level.timerdisplay["axis"].alpha = 0;
    resflag maps\mp\gametypes\_gameobjects::set2dicon( "friendly", "compass_waypoint_defend" + label );
    resflag maps\mp\gametypes\_gameobjects::set3dicon( "friendly", "waypoint_defend" + label );
    resflag maps\mp\gametypes\_gameobjects::set2dicon( "enemy", "compass_waypoint_capture" + label );
    resflag maps\mp\gametypes\_gameobjects::set3dicon( "enemy", "waypoint_capture" + label );

    if ( level.overtime )
    {
        resflag maps\mp\gametypes\_gameobjects::allowuse( "enemy" );
        resflag maps\mp\gametypes\_gameobjects::setvisibleteam( "any" );
        resflag maps\mp\gametypes\_gameobjects::setownerteam( "neutral" );
        resflag maps\mp\gametypes\_gameobjects::setdecaytime( level.flagcapturetime );
    }
    else
        resflag maps\mp\gametypes\_gameobjects::allowuse( "enemy" );

    resflag resetflagbaseeffect();
}

hideflag( flagindex )
{
    assert( flagindex < level.resflags.size );
    resflag = level.resflags[flagindex];
    resflag maps\mp\gametypes\_gameobjects::allowuse( "none" );
    resflag maps\mp\gametypes\_gameobjects::setvisibleteam( "none" );
    resflag maps\mp\gametypes\_gameobjects::setmodelvisibility( 0 );
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
    ownerteam = self maps\mp\gametypes\_gameobjects::getownerteam();
    setdvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getlabel() + "_flash", 1 );
    self.didstatusnotify = 0;

    if ( ownerteam == "allies" )
        otherteam = "axis";
    else
        otherteam = "allies";

    if ( ownerteam == "neutral" )
    {
        if ( gettime() - level.lastdialogtime > 5000 )
        {
            otherteam = getotherteam( player.pers["team"] );
            statusdialog( "securing" + self.label, player.pers["team"] );
            level.lastdialogtime = gettime();
        }

        self.objpoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startflashing();
        return;
    }

    self.objpoints["allies"] thread maps\mp\gametypes\_objpoints::startflashing();
    self.objpoints["axis"] thread maps\mp\gametypes\_objpoints::startflashing();
}

onuseupdate( team, progress, change )
{
    if ( !isdefined( level.resprogress ) )
        level.resprogress = progress;

    if ( progress > 0.05 && change && !self.didstatusnotify )
    {
        ownerteam = self maps\mp\gametypes\_gameobjects::getownerteam();

        if ( gettime() - level.lastdialogtime > 10000 )
        {
            statusdialog( "losing" + self.label, ownerteam );
            statusdialog( "securing" + self.label, team );
            level.lastdialogtime = gettime();
        }

        self.didstatusnotify = 1;
    }

    if ( level.resprogress < progress )
    {
        maps\mp\gametypes\_globallogic_utils::pausetimer();
        setgameendtime( 0 );
        level.resprogressteam = team;
    }
    else
        maps\mp\gametypes\_globallogic_utils::resumetimer();

    level.resprogress = progress;
    hud_setflagprogressbar( progress, team );
}

onuseclear()
{
    maps\mp\gametypes\_globallogic_utils::resumetimer();
    hud_setflagprogressbar( 0 );
}

statusdialog( dialog, team )
{
    time = gettime();

    if ( gettime() < level.laststatus[team] + 6000 )
        return;

    thread delayedleaderdialog( dialog, team );
    level.laststatus[team] = gettime();
}

onenduse( team, player, success )
{
    setdvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getlabel() + "_flash", 0 );
    self.objpoints["allies"] thread maps\mp\gametypes\_objpoints::stopflashing();
    self.objpoints["axis"] thread maps\mp\gametypes\_objpoints::stopflashing();
}

resetflagbaseeffect()
{
    if ( isdefined( self.baseeffect ) )
        return;

    team = self maps\mp\gametypes\_gameobjects::getownerteam();

    if ( team != "axis" && team != "allies" )
        return;

    fxid = level.flagbasefxid[team];
    self.baseeffect = spawnfx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
    triggerfx( self.baseeffect );
}

onuse( player, team )
{
    team = player.pers["team"];
    oldteam = self maps\mp\gametypes\_gameobjects::getownerteam();
    label = self maps\mp\gametypes\_gameobjects::getlabel();
    player logstring( "flag captured: " + self.label );
    setupnextflag( self.orderindex + 1 );

    if ( self.orderindex + 1 == level.resflags.size || level.overtime )
    {
        setgameendtime( 0 );
        wait 1;
        res_endgame( player.team, game["strings"]["flags_capped"] );
    }
    else
    {
        level.usestartspawns = 0;
        assert( team != "neutral" );

        if ( [[ level.gettimelimit ]]() > 0 && level.extratime )
        {
            level.usingextratime = 1;

            if ( !level.hardcoremode )
                iprintln( &"MP_TIME_EXTENDED" );
        }

        maps\mp\gametypes\_spawnlogic::clearspawnpoints();
        maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_res_spawn_allies" );
        maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_res_spawn_axis" );

        if ( label == "_a" )
        {
            maps\mp\gametypes\_spawnlogic::clearspawnpoints();
            maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_res_spawn_allies_a" );
            maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_res_spawn_axis" );
        }
        else if ( label == "_b" )
        {
            maps\mp\gametypes\_spawnlogic::addspawnpoints( game["attackers"], "mp_res_spawn_allies_b" );
            maps\mp\gametypes\_spawnlogic::addspawnpoints( game["defenders"], "mp_res_spawn_axis" );
        }
        else
        {
            maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_res_spawn_allies_c" );
            maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_res_spawn_axis" );
        }

        maps\mp\gametypes\_spawning::updateallspawnpoints();
        string = &"";

        switch ( label )
        {
            case "_a":
                string = &"MP_DOM_FLAG_A_CAPTURED_BY";
                break;
            case "_b":
                string = &"MP_DOM_FLAG_B_CAPTURED_BY";
                break;
            case "_c":
                string = &"MP_DOM_FLAG_C_CAPTURED_BY";
                break;
            case "_d":
                string = &"MP_DOM_FLAG_D_CAPTURED_BY";
                break;
            case "_e":
                string = &"MP_DOM_FLAG_E_CAPTURED_BY";
                break;
            default:
                break;
        }

        assert( string != &"" );
        touchlist = [];
        touchkeys = getarraykeys( self.touchlist[team] );

        for ( i = 0; i < touchkeys.size; i++ )
            touchlist[touchkeys[i]] = self.touchlist[team][touchkeys[i]];

        thread give_capture_credit( touchlist, string );
        thread printandsoundoneveryone( team, oldteam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "" );

        if ( getteamflagcount( team ) == level.flags.size )
        {
            statusdialog( "secure_all", team );
            statusdialog( "lost_all", oldteam );
        }
        else
        {
            statusdialog( "secured" + self.label, team );
            statusdialog( "lost" + self.label, oldteam );
        }

        level.bestspawnflag[oldteam] = self.levelflag;
        self update_spawn_influencers( team );
    }
}

give_capture_credit( touchlist, string )
{
    wait 0.05;
    maps\mp\gametypes\_globallogic_utils::waittillslowprocessallowed();
    players = getarraykeys( touchlist );

    for ( i = 0; i < players.size; i++ )
    {
        player_from_touchlist = touchlist[players[i]].player;
        player_from_touchlist recordgameevent( "capture" );

        if ( isdefined( player_from_touchlist.pers["captures"] ) )
        {
            player_from_touchlist.pers["captures"]++;
            player_from_touchlist.captures = player_from_touchlist.pers["captures"];
        }

        maps\mp\_demo::bookmark( "event", gettime(), player_from_touchlist );
        player_from_touchlist addplayerstatwithgametype( "CAPTURES", 1 );
        level thread maps\mp\_popups::displayteammessagetoall( string, player_from_touchlist );
    }
}

delayedleaderdialog( sound, team )
{
    wait 0.1;
    maps\mp\gametypes\_globallogic_utils::waittillslowprocessallowed();
    maps\mp\gametypes\_globallogic_audio::leaderdialog( sound, team );
}

onscoreclosemusic()
{
    axisscore = [[ level._getteamscore ]]( "axis" );
    alliedscore = [[ level._getteamscore ]]( "allies" );
    scorelimit = level.scorelimit;
    scorethreshold = scorelimit * 0.1;
    scoredif = abs( axisscore - alliedscore );
    scorethresholdstart = abs( scorelimit - scorethreshold );
    scorelimitcheck = scorelimit - 10;

    if ( !isdefined( level.playingactionmusic ) )
        level.playingactionmusic = 0;

    if ( alliedscore > axisscore )
        currentscore = alliedscore;
    else
        currentscore = axisscore;

    if ( getdvarint( #"_id_0BC4784C" ) > 0 )
    {
/#
        println( "Music System Resistance - scoreDif " + scoredif );
        println( "Music System Resistance - axisScore " + axisscore );
        println( "Music System Resistance - alliedScore " + alliedscore );
        println( "Music System Resistance - scoreLimit " + scorelimit );
        println( "Music System Resistance - currentScore " + currentscore );
        println( "Music System Resistance - scoreThreshold " + scorethreshold );
        println( "Music System Resistance - scoreDif " + scoredif );
        println( "Music System Resistance - scoreThresholdStart " + scorethresholdstart );
#/
    }

    if ( scoredif <= scorethreshold && scorethresholdstart <= currentscore && level.playingactionmusic != 1 )
    {
        thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
        thread maps\mp\gametypes\_globallogic_audio::actionmusicset();
    }
    else
        return;
}

onplayerkilled( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    if ( self.touchtriggers.size && isplayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
    {
        triggerids = getarraykeys( self.touchtriggers );
        ownerteam = self.touchtriggers[triggerids[0]].useobj.ownerteam;
        team = self.pers["team"];

        if ( team == ownerteam )
        {
            if ( !isdefined( attacker.res_offends ) )
                attacker.res_offends = 0;

            attacker.res_offends++;

            if ( level.playeroffensivemax >= attacker.res_offends )
            {
                attacker maps\mp\_medals::offenseglobalcount();
                attacker addplayerstatwithgametype( "OFFENDS", 1 );
                maps\mp\_scoreevents::processscoreevent( "killed_defender", attacker );
                self recordkillmodifier( "defending" );
            }
        }
        else
        {
            if ( !isdefined( attacker.res_defends ) )
                attacker.res_defends = 0;

            attacker.res_defends++;

            if ( level.playerdefensivemax >= attacker.res_defends )
            {
                attacker maps\mp\_medals::defenseglobalcount();
                attacker addplayerstatwithgametype( "DEFENDS", 1 );

                if ( isdefined( attacker.pers["defends"] ) )
                {
                    attacker.pers["defends"]++;
                    attacker.defends = attacker.pers["defends"];
                }

                maps\mp\_scoreevents::processscoreevent( "killed_attacker", attacker, undefined, sweapon );
                self recordkillmodifier( "assaulting" );
            }
        }
    }
}

getteamflagcount( team )
{
    score = 0;

    for ( i = 0; i < level.flags.size; i++ )
    {
        if ( level.resflags[i] maps\mp\gametypes\_gameobjects::getownerteam() == team )
            score++;
    }

    return score;
}

getflagteam()
{
    return self.useobj maps\mp\gametypes\_gameobjects::getownerteam();
}

updateobjectivehintmessages( alliesobjective, axisobjective )
{
    game["strings"]["objective_hint_allies"] = alliesobjective;
    game["strings"]["objective_hint_axis"] = axisobjective;
}

createflagspawninfluencers()
{
    ss = level.spawnsystem;

    for ( flag_index = 0; flag_index < level.flags.size; flag_index++ )
    {
        if ( level.resflags[flag_index] == self )
            break;
    }

    abc = [];
    abc[0] = "A";
    abc[1] = "B";
    abc[2] = "C";
    abc[3] = "D";
    abc[4] = "E";
    self.owned_flag_influencer = addsphereinfluencer( level.spawnsystem.einfluencer_type_game_mode, self.trigger.origin, ss.res_owned_flag_influencer_radius[flag_index], ss.res_owned_flag_influencer_score[flag_index], 0, "res_owned_flag_" + abc[flag_index] + ",r,s", maps\mp\gametypes\_spawning::get_score_curve_index( ss.res_owned_flag_influencer_score_curve ) );
    self.neutral_flag_influencer = addsphereinfluencer( level.spawnsystem.einfluencer_type_game_mode, self.trigger.origin, ss.res_unowned_flag_influencer_radius, ss.res_unowned_flag_influencer_score, 0, "res_unowned_flag,r,s", maps\mp\gametypes\_spawning::get_score_curve_index( ss.res_owned_flag_influencer_score_curve ) );
    self.enemy_flag_influencer = addsphereinfluencer( level.spawnsystem.einfluencer_type_game_mode, self.trigger.origin, ss.res_enemy_flag_influencer_radius[flag_index], ss.res_enemy_flag_influencer_score[flag_index], 0, "res_enemy_flag_" + abc[flag_index] + ",r,s", maps\mp\gametypes\_spawning::get_score_curve_index( ss.res_enemy_flag_influencer_score_curve ) );
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

res_gamemodespawndvars()
{
    ss = level.spawnsystem;
    ss.res_owned_flag_influencer_score = [];
    ss.res_owned_flag_influencer_radius = [];
    ss.res_owned_flag_influencer_score[0] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_A_influencer_score", "10" );
    ss.res_owned_flag_influencer_radius[0] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_A_influencer_radius", "" + 25.0 * get_player_height() );
    ss.res_owned_flag_influencer_score[1] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_B_influencer_score", "10" );
    ss.res_owned_flag_influencer_radius[1] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_B_influencer_radius", "" + 25.0 * get_player_height() );
    ss.res_owned_flag_influencer_score[2] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_C_influencer_score", "10" );
    ss.res_owned_flag_influencer_radius[2] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_C_influencer_radius", "" + 25.0 * get_player_height() );
    ss.res_owned_flag_influencer_score[3] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_D_influencer_score", "10" );
    ss.res_owned_flag_influencer_radius[3] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_D_influencer_radius", "" + 25.0 * get_player_height() );
    ss.res_owned_flag_influencer_score[4] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_E_influencer_score", "10" );
    ss.res_owned_flag_influencer_radius[4] = set_dvar_float_if_unset( "scr_spawn_res_owned_flag_E_influencer_radius", "" + 25.0 * get_player_height() );
    ss.res_owned_flag_influencer_score_curve = set_dvar_if_unset( "scr_spawn_res_owned_flag_influencer_score_curve", "constant" );
    ss.res_enemy_flag_influencer_score = [];
    ss.res_enemy_flag_influencer_radius = [];
    ss.res_enemy_flag_influencer_score[0] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_A_influencer_score", "-10" );
    ss.res_enemy_flag_influencer_radius[0] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_A_influencer_radius", "" + 15.0 * get_player_height() );
    ss.res_enemy_flag_influencer_score[1] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_B_influencer_score", "-10" );
    ss.res_enemy_flag_influencer_radius[1] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_B_influencer_radius", "" + 15.0 * get_player_height() );
    ss.res_enemy_flag_influencer_score[2] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_C_influencer_score", "-10" );
    ss.res_enemy_flag_influencer_radius[2] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_C_influencer_radius", "" + 15.0 * get_player_height() );
    ss.res_enemy_flag_influencer_score[3] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_D_influencer_score", "-10" );
    ss.res_enemy_flag_influencer_radius[3] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_D_influencer_radius", "" + 15.0 * get_player_height() );
    ss.res_enemy_flag_influencer_score[4] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_E_influencer_score", "-10" );
    ss.res_enemy_flag_influencer_radius[4] = set_dvar_float_if_unset( "scr_spawn_res_enemy_flag_E_influencer_radius", "" + 15.0 * get_player_height() );
    ss.res_enemy_flag_influencer_score_curve = set_dvar_if_unset( "scr_spawn_res_enemy_flag_influencer_score_curve", "constant" );
    ss.res_unowned_flag_influencer_score = set_dvar_float_if_unset( "scr_spawn_res_unowned_flag_influencer_score", "500" );
    ss.res_unowned_flag_influencer_score_curve = set_dvar_if_unset( "scr_spawn_res_unowned_flag_influencer_score_curve", "constant" );
    ss.res_unowned_flag_influencer_radius = set_dvar_float_if_unset( "scr_spawn_res_unowned_flag_influencer_radius", "" + 25.0 * get_player_height() );
}

hud_createflagprogressbar()
{
    level.attackerscaptureprogresshud = createteamprogressbar( game["attackers"] );
    level.defenderscaptureprogresshud = createteamprogressbar( game["defenders"] );
    hud_hideflagprogressbar();
}

hud_hideflagprogressbar()
{
    hud_setflagprogressbar( 0 );
    level.attackerscaptureprogresshud hideelem();
    level.defenderscaptureprogresshud hideelem();
}

hud_showflagprogressbar()
{
    level.attackerscaptureprogresshud showelem();
    level.defenderscaptureprogresshud showelem();
}

hud_setflagprogressbar( value, cappingteam )
{
    if ( value < 0.0 )
        value = 0.0;

    if ( value > 1.0 )
        value = 1.0;

    if ( isdefined( cappingteam ) )
    {
        if ( cappingteam == game["attackers"] )
        {
            level.attackerscaptureprogresshud.bar.color = vectorscale( ( 1, 1, 1 ), 255.0 );
            level.defenderscaptureprogresshud.bar.color = vectorscale( ( 1, 0, 0 ), 255.0 );
        }
        else
        {
            level.attackerscaptureprogresshud.bar.color = vectorscale( ( 1, 0, 0 ), 255.0 );
            level.defenderscaptureprogresshud.bar.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        }
    }

    level.attackerscaptureprogresshud updatebar( value );
    level.defenderscaptureprogresshud updatebar( value );
}
