// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\gametypes\_callbacksetup;
#include maps\mp\gametypes\_gameobjects;
#include maps\mp\gametypes\_spawning;
#include maps\mp\gametypes\_spawnlogic;
#include maps\mp\gametypes\_globallogic_score;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_globallogic_audio;
#include maps\mp\_scoreevents;
#include maps\mp\_entityheadicons;
#include maps\mp\killstreaks\_ai_tank;
#include maps\mp\killstreaks\_remotemissile;

main()
{
    if ( getdvar( #"mapname" ) == "mp_background" )
        return;

    maps\mp\gametypes\_globallogic::init();
    maps\mp\gametypes\_callbacksetup::setupcallbacks();
    maps\mp\gametypes\_globallogic::setupcallbacks();
    registertimelimit( 0, 1440 );
    registerscorelimit( 0, 50000 );
    registerroundlimit( 0, 10 );
    registerroundwinlimit( 0, 10 );
    registernumlives( 0, 100 );
    maps\mp\gametypes\_globallogic::registerfriendlyfiredelay( level.gametype, 15, 0, 1440 );
    level.scoreroundbased = getgametypesetting( "roundscorecarry" ) == 0;
    level.teambased = 0;
    level.onstartgametype = ::onstartgametype;
    level.onspawnplayer = ::onspawnplayer;
    level.onspawnplayerunified = ::onspawnplayerunified;
    level.onplayerkilled = ::onplayerkilled;
    level.onprecachegametype = ::onprecachegametype;
    level.onendgame = ::onendgame;
    level.onroundendgame = ::onroundendgame;
    level.givecustomloadout = ::givecustomloadout;
    level.customloadoutscavenge = ::customloadoutscavenge;
    level.onplayerscore = ::onplayerscore;
    level.onplayerdamage = ::onplayerdamage;
    game["dialog"]["gametype"] = "hack_start";
    game["dialog"]["offense_obj"] = "hack_obj";
    game["dialog"]["defense_obj"] = "hack_obj";
    game["dialog"]["hack_link"] = "hack_link";
    game["dialog"]["hack_hacked"] = "hack_hacked";
    setscoreboardcolumns( "score", "kills", "deaths", "agrkills", "hacks" );
}

onprecachegametype()
{
    precacheshader( "compass_waypoint_captureneutral" );
    precacheshader( "compass_waypoint_capture_white" );
    precacheshader( "compass_waypoint_defend_white" );
    precacheshader( "waypoint_captureneutral" );
    precacheshader( "waypoint_capture" );
    precacheshader( "waypoint_defend" );
    precacheshader( "hud_waypoint_capture_team1" );
    precacheshader( "hud_waypoint_capture_team2" );
    precacheshader( "hud_waypoint_capture_team3" );
    precacheshader( "hud_waypoint_capture_team4" );
    precacheshader( "hud_waypoint_defend_team1" );
    precacheshader( "hud_waypoint_defend_team2" );
    precacheshader( "hud_waypoint_defend_team3" );
    precacheshader( "hud_waypoint_defend_team4" );
    precacheshader( "hud_waypoint_capture_white" );
    precacheshader( "hud_waypoint_defend_white" );
    precachevehicle( "ai_tank_drone_nondrivable_mp" );
    precachemodel( "veh_t6_drone_tank" );
    precacheitem( "ai_tank_drone_rocket_mp" );
    precachestring( &"MP_DRONE_HACKED" );
    precachestring( &"MP_DRONE_KILL" );
    precachestring( &"MP_KILL" );
    precachestring( &"MP_DRONE_DESTROYED" );
    precachestring( &"MP_YOUR_DRONE_DESTROYED" );
    precachestring( &"MP_DRONES_ACTIVE_IN" );
    precachestring( &"MPUI_HACKER_YOU_HACKED" );
    precachestring( &"MPUI_HACKER_GOT_HACKED" );
}

onstartgametype()
{
    level.drone_count = getgametypesetting( "objectiveSpawnTime" );
    level.drone_hack_time = getgametypesetting( "crateCaptureTime" );
    level.drone_active_time = getgametypesetting( "captureTime" );
    level.drone_stun_time = getgametypesetting( "flagRespawnTime" );
    level.drone_destroy_unowned = getgametypesetting( "hotPotato" );
    level.drone_head_icon = getgametypesetting( "enemyCarrierVisible" );
    level.drone_min_emps = getgametypesetting( "destroyTime" );
    level.drone_spawn_emps = getgametypesetting( "idleFlagResetTime" );
    setclientnamemode( "auto_change" );
    allowed[0] = "hq";
    maps\mp\gametypes\_gameobjects::main( allowed );
    maps\mp\gametypes\_spawning::create_map_placed_influencers();
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    setobjectivetext( "allies", &"OBJECTIVES_TDM" );
    setobjectivetext( "axis", &"OBJECTIVES_TDM" );
    setobjectivehinttext( "allies", &"OBJECTIVES_HACKER_HINT" );
    setobjectivehinttext( "axis", &"OBJECTIVES_HACKER_HINT" );
    setobjectivescoretext( "allies", &"OBJECTIVES_TDM_SCORE" );
    setobjectivescoretext( "axis", &"OBJECTIVES_TDM_SCORE" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "allies", "mp_dm_spawn" );
    maps\mp\gametypes\_spawnlogic::addspawnpoints( "axis", "mp_dm_spawn" );
    maps\mp\gametypes\_spawning::updateallspawnpoints();
    level.mapcenter = maps\mp\gametypes\_spawnlogic::findboxcenter( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );
    spawnpoint = maps\mp\gametypes\_spawnlogic::getrandomintermissionpoint();
    setdemointermissionpoint( spawnpoint.origin, spawnpoint.angles );
    level.usestartspawns = 0;

    if ( !isoneround() && isscoreroundbased() )
        maps\mp\gametypes\_globallogic_score::resetteamscores();

    bwars_init();
}

bwars_get_spawnpoint( team )
{
    spawnpoints = maps\mp\gametypes\_spawnlogic::getteamspawnpoints( team );
    spawnpoint = maps\mp\gametypes\_spawnlogic::getspawnpoint_dm( spawnpoints );
    return spawnpoint;
}

givecustomloadout()
{
    if ( !isdefined( self.emp_count ) )
        self.emp_count = level.drone_spawn_emps;
    else if ( self.emp_count < level.drone_min_emps )
        self.emp_count = level.drone_min_emps;

    self takeallweapons();
    self clearperks();
    self giveweapon( "kard_mp" );
    self giveweapon( "knife_mp" );
    self givestartammo( "kard_mp" );
    self switchtoweapon( "kard_mp" );
    self giveweapon( level.weapons["frag"] );
    self setweaponammoclip( level.weapons["frag"], 0 );
    self.grenadetypeprimary = level.weapons["frag"];
    self giveweapon( "emp_grenade_mp" );
    self setweaponammoclip( "emp_grenade_mp", self.emp_count );
    self setoffhandsecondaryclass( "emp_grenade_mp" );
    self setperk( "specialty_scavenger" );
    self setperk( "specialty_movefaster" );
    self setperk( "specialty_longersprint" );
    self setactionslot( 1, "" );
    self setactionslot( 2, "" );
    self setactionslot( 3, "" );
    self setactionslot( 4, "" );
}

customloadoutscavenge( weapon )
{
    if ( weapon == level.weapons["frag"] )
        return 0;

    return weaponmaxammo( weapon );
}

mayspawn()
{
    if ( is_true( level.drones_spawned ) && self.bwars_drone_count == 0 )
        return false;

    return true;
}

player_spawn()
{
    if ( !isdefined( self.bwars_drone_count ) )
        self.bwars_drone_count = 0;

    self player_tank_hud_init();
    self.hackedagrcount = 0;
    self.killedhackertime = 0;

    if ( is_true( level.drones_spawned ) && self.bwars_drone_count == 0 )
    {

    }
}

onspawnplayerunified()
{
    self player_spawn();

    if ( level.usestartspawns && !level.ingraceperiod && !level.playerqueuedrespawn )
        level.usestartspawns = 0;

    maps\mp\gametypes\_spawning::onspawnplayer_unified();
}

onspawnplayer( predictedspawn )
{
    self player_spawn();
    spawnpoint = self bwars_get_spawnpoint( self.pers["team"] );

    if ( predictedspawn )
        self predictspawnpoint( spawnpoint.origin, spawnpoint.angles );
    else
        self spawn( spawnpoint.origin, spawnpoint.angles, "bwars" );
}

onendgame( winningteam )
{

}

ontimelimit()
{
    foreach ( team in level.aliveplayers )
    {
        foreach ( player in team )
            player thread maps\mp\gametypes\_hud_message::hintmessage( &"MP_DRONES_ACTIVE" );
    }

    if ( level.drone_destroy_unowned )
    {
        drones = getentarray( "talon", "targetname" );

        foreach ( drone in drones )
            drone tank_stop();
    }

    wait 0.5;
    self maps\mp\gametypes\_globallogic_audio::leaderdialog( "hack_link" );
    drones = getentarray( "talon", "targetname" );

    foreach ( drone in drones )
        drone tank_start();

    level.drones_spawned = 1;
    players = get_players();

    foreach ( player in players )
        player player_tank_hud_update();
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

bubblesort_structs( structs )
{
    while ( true )
    {
        swapped = 0;

        for ( i = 1; i < structs.size; i++ )
        {
            if ( int( structs[i - 1].script_index ) > int( structs[i].script_index ) )
            {
                t = structs[i - 1];
                structs[i - 1] = structs[i];
                structs[i] = t;
                swapped = 1;
            }
        }

        if ( !swapped )
            break;
    }

    return structs;
}

spawn_from_structs()
{
    structs = getstructarray( "hacker_agr_spawn", "script_noteworthy" );

    if ( !structs.size )
        return false;

    structs = bubblesort_structs( structs );
    spawned = 0;

    for ( i = 0; i < structs.size; i++ )
    {
        drone = spawnvehicle( "veh_t6_drone_tank", "talon", "ai_tank_drone_nondrivable_mp", structs[i].origin, ( 0, randomintrange( 0, 360 ), 0 ) );
        drone ai_tank_init();
        forward = anglestoforward( drone.angles );
        forward = drone.origin + forward * 128;
        forward = forward - vectorscale( ( 0, 0, 1 ), 64.0 );
        drone setturrettargetvec( forward );
        drone setvehicleavoidance( 1 );
        trigger = spawn( "trigger_radius_use", drone.origin, 16, 16 );
        visuals[0] = spawn( "script_model", drone.origin );
        use = maps\mp\gametypes\_gameobjects::createuseobject( "neutral", trigger, visuals, ( 0, 0, 0 ) );
        use maps\mp\gametypes\_gameobjects::allowuse( "any" );
        use maps\mp\gametypes\_gameobjects::setusetime( level.drone_hack_time );
        use maps\mp\gametypes\_gameobjects::setusetext( &"MP_HACKING" );
        use maps\mp\gametypes\_gameobjects::setusehinttext( &"MP_TALON_HACKING" );
        use maps\mp\gametypes\_gameobjects::setvisibleteam( "any" );
        use.onbeginuse = ::onbeginuse;
        use.onuse = ::onuse;
        use.onenduse = ::onenduse;
        trigger setcursorhint( "HINT_NOICON" );
        trigger enablelinkto();
        trigger linkto( drone );
        trigger triggerignoreteam();
        trigger setvisibletoall();
        trigger setteamfortrigger( "none" );
        use.drone = drone;
        drone.trigger = trigger;
        drone.use = use;
        drone.objectiveindex = 0;
        drone.objectivetype = "hacker_agr";
        spawned++;

        if ( spawned == level.drone_count )
            break;
    }

    return true;
}

bwars_init()
{
    setdvar( "scavenger_tactical_proc", "1" );
    allowed[0] = "";
    maps\mp\gametypes\_gameobjects::main( allowed );
    level thread bwars_time_think();

    if ( spawn_from_structs() )
        return;

    nodes = getallnodes();
    node = getclosest( level.mapcenter, nodes );
    nodes = getnodesinradius( node.origin, 1024, 0, 512, "Path" );
    nodes = array_randomize( nodes );
    spawned = 0;

    for ( i = 0; i < nodes.size; i++ )
    {
        if ( !valid_location( nodes[i] ) )
            continue;

        nodes[i].drone = 1;
        drone = spawnvehicle( "veh_t6_drone_tank", "talon", "ai_tank_drone_nondrivable_mp", nodes[i].origin, ( 0, randomintrange( 0, 360 ), 0 ) );
        drone ai_tank_init();
        forward = anglestoforward( drone.angles );
        forward = drone.origin + forward * 128;
        forward = forward - vectorscale( ( 0, 0, 1 ), 64.0 );
        drone setturrettargetvec( forward );
        drone setvehicleavoidance( 1 );
        trigger = spawn( "trigger_radius_use", drone.origin, 16, 16 );
        visuals[0] = spawn( "script_model", drone.origin );
        use = maps\mp\gametypes\_gameobjects::createuseobject( "neutral", trigger, visuals, ( 0, 0, 0 ) );
        use maps\mp\gametypes\_gameobjects::allowuse( "any" );
        use maps\mp\gametypes\_gameobjects::setusetime( level.drone_hack_time );
        use maps\mp\gametypes\_gameobjects::setusetext( &"MP_HACKING" );
        use maps\mp\gametypes\_gameobjects::setusehinttext( &"MP_TALON_HACKING" );
        use maps\mp\gametypes\_gameobjects::setvisibleteam( "any" );
        use.onbeginuse = ::onbeginuse;
        use.onuse = ::onuse;
        use.onenduse = ::onenduse;
        trigger setcursorhint( "HINT_NOICON" );
        trigger enablelinkto();
        trigger linkto( drone );
        trigger triggerignoreteam();
        trigger setvisibletoall();
        trigger setteamfortrigger( "none" );
        use.drone = drone;
        drone.trigger = trigger;
        drone.use = use;
        drone.objectiveindex = 0;
        drone.objectivetype = "hacker_agr";
        spawned++;

        if ( spawned == level.drone_count )
            break;
    }
}

tank_wander()
{
    if ( isdefined( level.spawn_all ) && level.spawn_all.size > 0 )
        spawns = arraysort( level.spawn_all, self.origin );
    else if ( isdefined( level.spawnpoints ) && level.spawnpoints.size > 0 )
        spawns = arraysort( level.spawnpoints, self.origin );
    else if ( isdefined( level.spawn_start ) && level.spawn_start.size > 0 )
    {
        spawns = arraycombine( level.spawn_start["allies"], level.spawn_start["axis"], 1, 0 );
        spawns = arraysort( spawns, self.origin );
    }
    else
        return false;

    far = int( spawns.size / 2 );
    far = randomintrange( far, spawns.size );
    nodes = getnodesinradius( spawns[far].origin, 512, 64, 512, "Path" );
    nodes = array_randomize( nodes );

    foreach ( node in nodes )
    {
        if ( self setvehgoalpos( node.origin, 1, 2 ) )
            return true;
    }

    return false;
}

tank_collision_think()
{
    self notify( "collision_think" );
    self endon( "collision_think" );
    self endon( "reached_end_node" );

    for (;;)
    {
        self waittill( "veh_collision", position, normal, intensity, type, entity );

        if ( isdefined( entity ) )
        {
            if ( isdefined( entity.targetname ) && entity.targetname == "talon" )
            {
                dist = randomintrange( 256, 512 );
                origin = self.origin - vectorscale( normal, dist );
                nodes = getnodesinradius( origin, dist * 0.5, 0, 512, "Path" );

                foreach ( node in nodes )
                {
                    if ( self setvehgoalpos( node.origin, 1, 2 ) )
                    {
                        wait 2;
                        break;
                    }
                }
            }
        }
    }
}

tank_move_think()
{
    self endon( "death" );
    self endon( "stunned" );
    self endon( "remote_start" );
    level endon( "game_ended" );

    for (;;)
    {
        wait( randomfloatrange( 1, 4 ) );

        if ( !tank_valid_location() )
        {
            self notify( "death" );
            return;
        }

        if ( !tank_is_idle() )
        {
            enemy = tank_get_target();

            if ( valid_target( enemy, self.team, self.owner ) )
            {
                if ( self setvehgoalpos( enemy.origin, 1, 2 ) )
                {
                    self wait_endon( 3, "reached_end_node" );
                    continue;
                }
            }
        }

        if ( self tank_wander() )
        {
            self thread tank_collision_think();
            self waittill_any_timeout( 45, "reached_end_node", "force_movement_wake" );
        }

        if ( self.aim_entity.delay > 0 )
            self waittill_any_timeout( self.aim_entity.delay, "reached_end_node", "force_movement_wake" );
    }
}

bwars_time_think()
{
    level waittill( "prematch_over" );

    while ( level.inprematchperiod )
        wait 0.05;

    for ( time = int( level.drone_active_time ); time > 0; time-- )
    {
        if ( time == level.drone_active_time - 3 )
        {
            level.timerdisplay = createservertimer( "objective", 1.4 );
            level.timerdisplay setpoint( "TOPRIGHT", "TOPRIGHT", 0, 40 );
            level.timerdisplay.label = &"MP_DRONES_ACTIVE_IN";
            level.timerdisplay.alpha = 1;
            level.timerdisplay.archived = 0;
            level.timerdisplay.hidewheninmenu = 1;
            level.timerdisplay settimer( level.drone_active_time - 3 );
        }

        wait 1;
    }

    ontimelimit();

    if ( isdefined( level.timerdisplay ) )
        level.timerdisplay destroyelem();
}

valid_location( node )
{
    if ( isdefined( node.drone ) )
        return false;

    drones = getentarray( "talon", "targetname" );

    foreach ( drone in drones )
    {
        if ( distancesquared( drone.origin, node.origin ) < 65536 )
            return false;
    }

    level.ai_tank_valid_locations = array_randomize( level.ai_tank_valid_locations );
    count = min( level.ai_tank_valid_locations.size, 5 );

    for ( i = 0; i < count; i++ )
    {
        if ( findpath( node.origin, level.ai_tank_valid_locations[i], 0 ) )
            return true;
    }

    return false;
}

ai_tank_init()
{
    self.maxhealth = 999999;
    self.health = self.maxhealth;
    self setteam( "team8" );
    self.isstunned = 0;
    self.controlled = 0;
    self.numberrockets = 3;
    self.warningshots = 6;
}

players_on_team( team )
{
    players = [];
    all = get_players();

    foreach ( player in all )
    {
        if ( !isdefined( player.team ) )
            continue;

        if ( player.team == team )
            players[players.size] = player;
    }

    return players;
}

player_tank_hud_init()
{
    if ( isdefined( self.bwars_hud ) )
        return;

    x = -40;
    y = 150;
    hud = newclienthudelem( self );
    hud.alignx = "left";
    hud.aligny = "middle";
    hud.foreground = 1;
    hud.fontscale = 1;
    hud.alpha = 0;
    hud.x = x;
    hud.y = y;
    hud.hidewhendead = 1;
    hud.hidewheninkillcam = 1;
    hud.score = newclienthudelem( self );
    hud.score.alignx = "left";
    hud.score.aligny = "middle";
    hud.score.foreground = 1;
    hud.score.fontscale = 1;
    hud.score.alpha = 0;
    hud.score.x = x + 80;
    hud.score.y = y;
    hud.score.hidewhendead = 1;
    hud.score.hidewheninkillcam = 1;
    self.bwars_hud = hud;
    self player_tank_hud_update();
    drones = getentarray( "talon", "targetname" );
    self.icons = [];

    foreach ( drone in drones )
    {
        entity = drone;
        headicon = newclienthudelem( self );
        headicon.archived = 1;
        headicon.x = 0;
        headicon.y = 0;
        headicon.z = 60;
        headicon.alpha = 0;
        headicon setshader( "waypoint_capture", 6, 6 );
        headicon setwaypoint( 0 );
        headicon settargetent( entity );
        self.icons[drone getentitynumber()] = headicon;

        if ( level.drone_head_icon == 1 || level.drone_head_icon == 2 )
        {
            if ( isdefined( drone.owner ) && drone.owner != self )
                headicon.alpha = 0.8;
        }
    }
}

player_tank_hud_update()
{
    if ( self.team == "spectator" )
        return;

    self.bwars_hud settext( "Hacked AGRs:" );
    self.bwars_hud.score setvalue( self.bwars_drone_count );

    if ( self.bwars_drone_count == 0 )
    {
        self.bwars_hud.color = vectorscale( ( 1, 0, 0 ), 0.85 );
        self.bwars_hud.score.color = vectorscale( ( 1, 0, 0 ), 0.85 );
    }
    else
    {
        self.bwars_hud.color = ( 1, 1, 1 );
        self.bwars_hud.score.color = ( 1, 1, 1 );
    }
}

onbeginuse( user )
{
    user.hackingdrone = self.drone;
    self.drone.being_hacked = 1;
    user setplayercurrentobjective( self.drone.objectiveindex, self.drone.objectivetype );
}

onuseupdate( team, progress, change )
{

}

onenduse( team, player, success )
{
    player.hackingdrone = undefined;
    self.drone.being_hacked = 0;

    if ( player.killedhackertime > 0 )
    {
        if ( player.killedhackertime + 5000 > gettime() && player.killedhackerdrone == self.drone )
            maps\mp\_scoreevents::processscoreevent( "kill_hacker_then_hack", player );
    }

    player setplayercurrentobjective( 0, "none" );
}

onuse( player )
{
    maps\mp\gametypes\_globallogic_score::giveplayerscore( "hacker_drone_hacked", player );
    player.hackedagrcount++;

    if ( player.hackedagrcount == 3 )
    {
        player.hackedagrcount = 0;
        maps\mp\_scoreevents::processscoreevent( "hack_3_agrs", player );
    }

    self.trigger setvisibletoall();
    self.trigger setinvisibletoplayer( player );
    player.pers["hacks"]++;
    player.hacks = player.pers["hacks"];

    if ( isdefined( self.drone.owner ) )
    {
        self.drone.owner iprintln( &"MPUI_HACKER_GOT_HACKED", player.name );
        player iprintln( &"MPUI_HACKER_YOU_HACKED", self.drone.owner.name );
        self.drone.owner maps\mp\gametypes\_globallogic_audio::leaderdialogonplayer( "hack_hacked" );
        self.drone.owner.bwars_drone_count--;
        self.drone.owner player_tank_hud_update();
    }

    needs_start = 0;

    if ( !isdefined( self.drone.owner ) )
        needs_start = 1;

    self.drone setowner( player );
    self.drone setteam( "free" );
    self.drone.owner = player;
    self.drone.team = player.team;
    self.drone.aiteam = player.team;

    if ( needs_start && is_true( level.drones_spawned ) )
        self.drone tank_start();

    if ( level.drone_head_icon == 0 || level.drone_head_icon == 2 )
        self.drone maps\mp\_entityheadicons::setentityheadicon( self.drone.team, player, vectorscale( ( 0, 0, 1 ), 60.0 ), "waypoint_defend" );

    player.icons[self.drone getentitynumber()].alpha = 0;

    if ( level.drone_head_icon == 1 || level.drone_head_icon == 2 )
    {
        all = get_players();

        foreach ( p in all )
        {
            if ( p == player )
                continue;

            if ( p.team == "spectator" )
                continue;

            p.icons[self.drone getentitynumber()].alpha = 0.8;
        }
    }

    player.bwars_drone_count++;
    player player_tank_hud_update();
    self.drone.stunfinishtime = 0;
    self.drone notify( "drone_hacked" );
    self.drone thread tank_abort_think();
}

tank_start()
{
    if ( is_true( self.dead ) )
        return;

    if ( !isdefined( self.owner ) )
        return;

    self setclientfield( "ai_tank_hack_spawned", 1 );
    self setclientfield( "ai_tank_death", 0 );
    self.trigger setinvisibletoall();
    self maps\mp\gametypes\_spawning::create_aitank_influencers( self.team );
    self thread tank_move_think();
    self thread maps\mp\killstreaks\_ai_tank::tank_aim_think();
    self thread maps\mp\killstreaks\_ai_tank::tank_combat_think();
    self thread maps\mp\killstreaks\_ai_tank::tank_rocket_think();
    self thread tank_damage_think();
    self thread tank_death_think();
}

tank_stop()
{
    if ( !isdefined( self.owner ) )
        self notify( "death" );
}

tank_death_think()
{
    self endon( "drone_abort" );
    team = self.team;
    self waittill( "death", attacker );
    self.dead = 1;

    for ( i = 0; i < self.entityheadicons.size; i++ )
    {
        if ( isdefined( self.entityheadicons[i] ) )
            self.entityheadicons[i] destroy();
    }

    all = get_players();

    foreach ( p in all )
    {
        if ( isdefined( p.icons ) && isdefined( p.icons[self getentitynumber()] ) )
            p.icons[self getentitynumber()] destroy();
    }

    self.use maps\mp\gametypes\_gameobjects::disableobject();
    self.trigger setinvisibletoall();
    self clearvehgoalpos();

    if ( self.controlled == 1 )
    {
        self.owner thread maps\mp\killstreaks\_remotemissile::staticeffect( 1.0 );
        self.owner destroy_remote_hud();
    }

    stunned = 0;
    playfx( level._effect["rcbombexplosion"], self.origin, ( 0, randomfloat( 360 ), 0 ) );
    playsoundatposition( "wpn_agr_explode", self.origin );
    wait 0.05;
    self hide();

    if ( isdefined( self.stun_fx ) )
        self.stun_fx delete();

    wait 0.95;

    if ( isdefined( self.aim_entity ) )
        self.aim_entity delete();

    self delete();

    if ( stunned == 0 )
    {

    }
}

tank_damage_think()
{
    self endon( "death" );
    self endon( "drone_abort" );
    self.maxhealth = 999999;
    self.health = self.maxhealth;
    self.isstunned = 0;
    self.stunfinishtime = 0;

    for (;;)
    {
        self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );
        self.maxhealth = 999999;
        self.health = self.maxhealth;

        if ( weapon == "emp_grenade_mp" && mod == "MOD_GRENADE_SPLASH" )
        {
            self.stunstarttime = gettime();
            self.stunfinishtime = gettime() + level.drone_stun_time * 1000 + 500;

            if ( !self.isstunned )
            {
                self thread tank_stun();
                self.isstunned = 1;
            }
        }
    }
}

tank_abort_think()
{
    self endon( "death" );
    self endon( "drone_hacked" );
    self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );
    self setteam( "team8" );
    self.owner = undefined;
    self.team = undefined;
    self.aiteam = undefined;
    angles = self gettagangles( "tag_turret" );
    forward = anglestoforward( angles );
    forward = self.origin + forward * 128;
    forward = forward - vectorscale( ( 0, 0, 1 ), 64.0 );
    self setturrettargetvec( forward );
    self clearvehgoalpos();
    self.trigger setvisibletoall();

    for ( i = 0; i < self.entityheadicons.size; i++ )
    {
        if ( isdefined( self.entityheadicons[i] ) )
            self.entityheadicons[i] destroy();
    }

    all = get_players();

    foreach ( p in all )
    {
        if ( isdefined( p.icons ) && isdefined( p.icons[self getentitynumber()] ) )
            p.icons[self getentitynumber()].alpha = 0;
    }

    self notify( "stunned" );
    self notify( "drone_abort" );
    self setclientfield( "ai_tank_death", 1 );
    self setclientfield( "ai_tank_hack_spawned", 0 );
}

tank_stun_abort()
{
    self endon( "death" );
    self endon( "stun_done" );
    self waittill( "drone_hacked" );
    self.stunfinishtime = 0;
}

tank_stun()
{
    self endon( "death" );
    self notify( "stunned" );
    self.isstunned = 1;
    self setclientflag( 3 );
    angles = self gettagangles( "tag_turret" );
    forward = anglestoforward( angles );
    forward = self.origin + forward * 128;
    forward = forward - vectorscale( ( 0, 0, 1 ), 64.0 );
    self setturrettargetvec( forward );
    self clearvehgoalpos();
    self laseroff();
    self.trigger setvisibletoall();
    self.trigger setinvisibletoplayer( self.owner );
    self thread tank_stun_abort();
    current = gettime();

    while ( self.stunfinishtime > current )
    {
        wait 0.05;
        self setclientfield( "ai_tank_hack_rebooting", 0 );

        if ( !is_true( self.being_hacked ) )
        {
            reboot_time = ( self.stunfinishtime - self.stunstarttime ) * 0.5;
            reboot_time = self.stunstarttime + reboot_time;

            if ( current >= reboot_time )
                self setclientfield( "ai_tank_hack_rebooting", 1 );
        }

        current = gettime();

        if ( self.stunfinishtime - current < 200 )
            self.trigger setinvisibletoall();
    }

    while ( is_true( self.being_hacked ) )
    {
        self setclientfield( "ai_tank_hack_rebooting", 0 );
        wait 0.05;
    }

    self thread tank_move_think();
    self thread maps\mp\killstreaks\_ai_tank::tank_aim_think();
    self thread maps\mp\killstreaks\_ai_tank::tank_combat_think();
    self.isstunned = 0;
    self clearclientflag( 3 );
    self setclientfield( "ai_tank_hack_rebooting", 0 );
    self notify( "stun_done" );
}

tank_valid_location()
{
    nodes = getnodesinradius( self.origin, 512, 8, 128, "Path" );
    return nodes.size > 0;
}

get_winning_team()
{
    highest = 0;
    winner = "";
    tied = 0;
    players = get_players();

    foreach ( player in players )
    {
        if ( !player is_bot() )
        {
            if ( player.score > highest )
            {
                winner = player.team;
                highest = player.score;
                tied = 0;
                continue;
            }

            if ( player.score == highest )
                tied = 1;
        }
    }

    if ( tied )
        return "";

    return winner;
}

onplayerkilled( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    self.emp_count = self getweaponammostock( "emp_grenade_mp" );
    drone_kill = 0;

    if ( isdefined( sweapon ) && sweapon == "ai_tank_drone_rocket_mp" )
        drone_kill = 1;
    else if ( isdefined( einflictor ) && isdefined( einflictor.targetname ) && einflictor.targetname == "talon" )
        drone_kill = 1;

    if ( drone_kill )
    {
        if ( isdefined( attacker ) && isplayer( attacker ) && attacker != self )
        {
            maps\mp\gametypes\_globallogic_score::giveplayerscore( "hacker_drone_killed", attacker );
            attacker.pers["agrkills"]++;
            attacker.agrkills = attacker.pers["agrkills"];
        }
    }
    else if ( isdefined( self.hackingdrone ) )
    {
        if ( isdefined( self.hackingdrone.owner ) && self.hackingdrone.owner == attacker )
            maps\mp\_scoreevents::processscoreevent( "kill_hacker", attacker );

        attacker.killedhackertime = gettime();
        attacker.killedhackerdrone = self.hackingdrone;
    }
}

get_highest_scoring_player()
{
    highest = undefined;
    players = get_players();

    foreach ( player in players )
    {
        if ( !isdefined( player.score ) )
            continue;

        if ( player.score < 0 )
            continue;

        if ( !isdefined( highest ) )
        {
            highest = player;
            continue;
        }

        if ( player.score == highest.score )
            return undefined;

        if ( player.score > highest.score )
            highest = player;
    }

    return highest;
}

onplayerscore( event, player, victim )
{
    maps\mp\gametypes\_globallogic_score::default_onplayerscore( event, player, victim );
    player = get_highest_scoring_player();

    if ( !isdefined( player ) )
    {
        if ( isdefined( level.bwars_last_highest ) )
        {
            level.bwars_last_highest maps\mp\gametypes\_globallogic_audio::leaderdialogonplayer( "lead_lost" );
            level.bwars_last_highest = undefined;
        }
    }
    else if ( player.score > 0 )
    {
        if ( isdefined( level.bwars_last_highest ) && player != level.bwars_last_highest )
        {
            player maps\mp\gametypes\_globallogic_audio::leaderdialogonplayer( "lead_taken" );
            level.bwars_last_highest maps\mp\gametypes\_globallogic_audio::leaderdialogonplayer( "lead_lost" );
            level.bwars_last_highest = player;
        }
        else if ( !isdefined( level.bwars_last_highest ) )
        {
            player maps\mp\gametypes\_globallogic_audio::leaderdialogonplayer( "lead_taken" );
            level.bwars_last_highest = player;
        }
    }
}

onplayerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
    if ( smeansofdeath == "MOD_CRUSH" )
    {
        if ( isdefined( einflictor.targetname ) && einflictor.targetname == "talon" )
        {
            if ( einflictor.isstunned )
                return 0;

            if ( !is_true( level.drones_spawned ) )
                return 0;

            speed = einflictor getspeed();

            if ( speed <= 1 )
                return 0;
        }
    }

    return undefined;
}