// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\gametypes\_callbacksetup;
#include maps\mp\gametypes\_gameobjects;
#include maps\mp\gametypes\_spawnlogic;
#include maps\mp\gametypes\_spawning;
#include maps\mp\gametypes\_objpoints;
#include maps\mp\_scoreevents;
#include maps\mp\gametypes\_globallogic_score;
#include maps\mp\gametypes\_hostmigration;

main()
{
    maps\mp\gametypes\_globallogic::init();
    maps\mp\gametypes\_callbacksetup::setupcallbacks();
    maps\mp\gametypes\_globallogic::setupcallbacks();
    registertimelimit( 0, 1440 );
    registerscorelimit( 0, 50000 );
    registerroundlimit( 0, 10 );
    registerroundwinlimit( 0, 10 );
    registernumlives( 0, 100 );
    maps\mp\gametypes\_globallogic::registerfriendlyfiredelay( level.gametype, 15, 0, 1440 );
    level.scoreroundbased = 1;
    level.teambased = 1;
    level.onprecachegametype = ::onprecachegametype;
    level.onstartgametype = ::onstartgametype;
    level.onspawnplayer = ::onspawnplayer;
    level.onspawnplayerunified = ::onspawnplayerunified;
    level.onroundendgame = ::onroundendgame;
    level.onplayerkilled = ::onplayerkilled;
    game["dialog"]["gametype"] = "kill_confirmed";
    game["dialog"]["gametype_hardcore"] = "kill_confirmed";
    game["dialog"]["offense_obj"] = "generic_boost";
    game["dialog"]["defense_obj"] = "generic_boost";
    level.conf_fx["vanish"] = loadfx( "impacts/small_snowhit" );
    setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" );
}

onprecachegametype()
{
    precachemodel( "prop_dogtags_friend" );
    precachemodel( "prop_dogtags_foe" );
    precacheshader( "waypoint_dogtags" );
}

onstartgametype()
{
    setclientnamemode( "auto_change" );

    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    if ( game["switchedsides"] )
    {
        oldattackers = game["attackers"];
        olddefenders = game["defenders"];
        game["attackers"] = olddefenders;
        game["defenders"] = oldattackers;
    }

    setobjectivetext( "allies", &"OBJECTIVES_CONF" );
    setobjectivetext( "axis", &"OBJECTIVES_CONF" );

    if ( level.splitscreen )
    {
        setobjectivescoretext( "allies", &"OBJECTIVES_CONF" );
        setobjectivescoretext( "axis", &"OBJECTIVES_CONF" );
    }
    else
    {
        setobjectivescoretext( "allies", &"OBJECTIVES_CONF_SCORE" );
        setobjectivescoretext( "axis", &"OBJECTIVES_CONF_SCORE" );
    }

    setobjectivehinttext( "allies", &"OBJECTIVES_CONF_HINT" );
    setobjectivehinttext( "axis", &"OBJECTIVES_CONF_HINT" );
    allowed[0] = level.gametype;
    maps\mp\gametypes\_gameobjects::main( allowed );
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    maps\mp\gametypes\_spawnlogic::placespawnpoints( "mp_tdm_spawn_allies_start" );
    maps\mp\gametypes\_spawnlogic::placespawnpoints( "mp_tdm_spawn_axis_start" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_tdm_spawn" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_tdm_spawn" );
    maps\mp\gametypes\_spawning::updateallspawnpoints();
    level.mapcenter = maps\mp\gametypes\_spawnlogic::findboxcenter( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );
    spawnpoint = maps\mp\gametypes\_spawnlogic::getrandomintermissionpoint();
    setdemointermissionpoint( spawnpoint.origin, spawnpoint.angles );
    level.dogtags = [];
}

onplayerkilled( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    if ( isplayer( attacker ) && attacker.team == self.team )
        return;

    level thread spawndogtags( self, attacker );
    otherteam = getotherteam( attacker.team );

    if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][otherteam] )
        attacker.finalkill = 1;
}

spawndogtags( victim, attacker )
{
    if ( isdefined( level.dogtags[victim.guid] ) )
    {
        playfx( level.conf_fx["vanish"], level.dogtags[victim.guid].curorigin );
        level.dogtags[victim.guid] notify( "reset" );
    }
    else
    {
        visuals[0] = spawn( "script_model", ( 0, 0, 0 ) );
        visuals[0] setmodel( "prop_dogtags_foe" );
        visuals[1] = spawn( "script_model", ( 0, 0, 0 ) );
        visuals[1] setmodel( "prop_dogtags_friend" );
        trigger = spawn( "trigger_radius", ( 0, 0, 0 ), 0, 32, 32 );
        level.dogtags[victim.guid] = maps\mp\gametypes\_gameobjects::createuseobject( "any", trigger, visuals, vectorscale( ( 0, 0, 1 ), 16.0 ) );

        foreach ( team in level.teams )
        {
            objective_delete( level.dogtags[victim.entnum].objid[team] );
            maps\mp\gametypes\_objpoints::deleteobjpoint( level.dogtags[victim.entnum].objpoints[team] );
        }

        level.dogtags[victim.guid] maps\mp\gametypes\_gameobjects::setusetime( 0 );
        level.dogtags[victim.guid].onuse = ::onuse;
        level.dogtags[victim.guid].victim = victim;
        level.dogtags[victim.guid].victimteam = victim.team;
        level.dogtags[victim.guid].objid = maps\mp\gametypes\_gameobjects::getnextobjid();
        objective_add( level.dogtags[victim.guid].objid, "invisible", ( 0, 0, 0 ) );
        objective_icon( level.dogtags[victim.guid].objid, "waypoint_dogtags" );
        level thread clearonvictimdisconnect( victim );
        victim thread tagteamupdater( level.dogtags[victim.guid] );
    }

    pos = victim.origin + vectorscale( ( 0, 0, 1 ), 14.0 );
    level.dogtags[victim.guid].curorigin = pos;
    level.dogtags[victim.guid].trigger.origin = pos;
    level.dogtags[victim.guid].visuals[0].origin = pos;
    level.dogtags[victim.guid].visuals[1].origin = pos;
    level.dogtags[victim.guid] maps\mp\gametypes\_gameobjects::allowuse( "any" );
    level.dogtags[victim.guid].visuals[0] thread showtoteam( level.dogtags[victim.guid], getotherteam( victim.team ) );
    level.dogtags[victim.guid].visuals[1] thread showtoteam( level.dogtags[victim.guid], victim.team );
    level.dogtags[victim.guid].attacker = attacker;
    objective_position( level.dogtags[victim.guid].objid, pos );
    objective_state( level.dogtags[victim.guid].objid, "active" );
    objective_setinvisibletoall( level.dogtags[victim.guid].objid );
    objective_setvisibletoplayer( level.dogtags[victim.guid].objid, attacker );
    playsoundatposition( "mp_killconfirm_tags_drop", pos );
    level.dogtags[victim.guid] thread bounce();
}

showtoteam( gameobject, team )
{
    gameobject endon( "death" );
    gameobject endon( "reset" );
    self hide();

    foreach ( player in level.players )
    {
        if ( player.team == team )
            self showtoplayer( player );
    }

    for (;;)
    {
        level waittill( "joined_team" );
        self hide();

        foreach ( player in level.players )
        {
            if ( player.team == team )
                self showtoplayer( player );

            if ( gameobject.victimteam == player.team && player == gameobject.attacker )
                objective_state( gameobject.objid, "invisible" );
        }
    }
}

onuse( player )
{
    if ( player.team == self.victimteam )
    {
        self.trigger playsound( "mp_killconfirm_tags_deny" );
        player addplayerstatwithgametype( "KILLSDENIED", 1 );

        if ( self.victim == player )
        {
            event = "retrieve_own_tags";
            splash = &"SPLASHES_TAGS_RETRIEVED";
        }
        else
        {
            event = "kill_denied";
            splash = &"SPLASHES_KILL_DENIED";
        }
    }
    else
    {
        self.trigger playsound( "mp_killconfirm_tags_pickup" );
        event = "kill_confirmed";
        splash = &"SPLASHES_KILL_CONFIRMED";
        player addplayerstatwithgametype( "KILLSCONFIRMED", 1 );

        if ( self.attacker != player )
            maps\mp\_scoreevents::processscoreevent( event, self.attacker );

        self.trigger playsoundtoplayer( game["voice"][player.team] + "kill_confirmed", player );
        player maps\mp\gametypes\_globallogic_score::giveteamscoreforobjective( player.team, 1 );
    }

    maps\mp\_scoreevents::processscoreevent( event, player );
    self resettags();
}

resettags()
{
    self.attacker = undefined;
    self notify( "reset" );
    self.visuals[0] hide();
    self.visuals[1] hide();
    self.curorigin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self.trigger.origin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self.visuals[0].origin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self.visuals[1].origin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self maps\mp\gametypes\_gameobjects::allowuse( "none" );
    objective_state( self.objid, "invisible" );
}

bounce()
{
    level endon( "game_ended" );
    self endon( "reset" );
    bottompos = self.curorigin;
    toppos = self.curorigin + vectorscale( ( 0, 0, 1 ), 12.0 );

    while ( true )
    {
        self.visuals[0] moveto( toppos, 0.5, 0.15, 0.15 );
        self.visuals[0] rotateyaw( 180, 0.5 );
        self.visuals[1] moveto( toppos, 0.5, 0.15, 0.15 );
        self.visuals[1] rotateyaw( 180, 0.5 );
        wait 0.5;
        self.visuals[0] moveto( bottompos, 0.5, 0.15, 0.15 );
        self.visuals[0] rotateyaw( 180, 0.5 );
        self.visuals[1] moveto( bottompos, 0.5, 0.15, 0.15 );
        self.visuals[1] rotateyaw( 180, 0.5 );
        wait 0.5;
    }
}

timeout( victim )
{
    level endon( "game_ended" );
    victim endon( "disconnect" );
    self notify( "timeout" );
    self endon( "timeout" );
    level maps\mp\gametypes\_hostmigration::waitlongdurationwithhostmigrationpause( 30.0 );
    self.visuals[0] hide();
    self.visuals[1] hide();
    self.curorigin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self.trigger.origin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self.visuals[0].origin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self.visuals[1].origin = vectorscale( ( 0, 0, 1 ), 1000.0 );
    self maps\mp\gametypes\_gameobjects::allowuse( "none" );
}

tagteamupdater( tags )
{
    level endon( "game_ended" );
    self endon( "disconnect" );

    while ( true )
    {
        self waittill( "joined_team" );
        tags.victimteam = self.team;
        tags resettags();
    }
}

clearonvictimdisconnect( victim )
{
    level endon( "game_ended" );
    guid = victim.guid;
    victim waittill( "disconnect" );

    if ( isdefined( level.dogtags[guid] ) )
    {
        level.dogtags[guid] maps\mp\gametypes\_gameobjects::allowuse( "none" );
        playfx( level.conf_fx["vanish"], level.dogtags[guid].curorigin );
        level.dogtags[guid] notify( "reset" );
        wait 0.05;

        if ( isdefined( level.dogtags[guid] ) )
        {
            objective_delete( level.dogtags[guid].objid );
            level.dogtags[guid].trigger delete();

            for ( i = 0; i < level.dogtags[guid].visuals.size; i++ )
                level.dogtags[guid].visuals[i] delete();

            level.dogtags[guid] notify( "deleted" );
            level.dogtags[guid] = undefined;
        }
    }
}

initgametypeawards()
{

}

onspawnplayerunified()
{
    self.usingobj = undefined;

    if ( level.usestartspawns && !level.ingraceperiod )
        level.usestartspawns = 0;

    maps\mp\gametypes\_spawning::onspawnplayer_unified();
}

onspawnplayer( predictedspawn )
{
    pixbeginevent( "TDM:onSpawnPlayer" );
    self.usingobj = undefined;

    if ( level.ingraceperiod )
    {
        spawnpoints = maps\mp\gametypes\_spawnlogic::getspawnpointarray( maps\mp\gametypes\_spawning::gettdmstartspawnname( self.team ) );

        if ( !spawnpoints.size )
            spawnpoints = maps\mp\gametypes\_spawnlogic::getspawnpointarray( maps\mp\gametypes\_spawning::getteamstartspawnname( self.team, "mp_sab_spawn" ) );

        if ( !spawnpoints.size )
        {
            if ( game["switchedsides"] )
                spawnteam = getotherteam( self.team );

            spawnpoints = maps\mp\gametypes\_spawnlogic::getteamspawnpoints( self.team );
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_nearteam( spawnpoints );
        }
        else
            spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_random( spawnpoints );
    }
    else
    {
        if ( game["switchedsides"] )
            spawnteam = getotherteam( self.team );

        spawnpoints = maps\mp\gametypes\_spawnlogic::getteamspawnpoints( self.team );
        spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_nearteam( spawnpoints );
    }

    if ( predictedspawn )
        self predictspawnpoint( spawnpoint.origin, spawnpoint.angles );
    else
        self spawn( spawnpoint.origin, spawnpoint.angles, "tdm" );

    pixendevent();
}

onroundendgame( roundwinner )
{
    winner = maps\mp\gametypes\_globallogic::determineteamwinnerbygamestat( "roundswon" );
    return winner;
}