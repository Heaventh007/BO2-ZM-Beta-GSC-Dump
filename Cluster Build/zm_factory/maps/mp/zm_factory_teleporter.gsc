// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_factory_teleporter;
#include maps\mp\zombies\_zm_timer;
#include maps\mp\zombies\_zm_score;

teleporter_init()
{
    precachemodel( "collision_wall_128x128x10" );
    level.dog_melee_range = 130;
    level thread dog_blocker_clip();
    level.teleport = [];
    level.active_links = 0;
    level.countdown = 0;
    level.teleport_delay = 2;
    level.teleport_cost = 1500;
    level.teleport_cooldown = 5;
    level.is_cooldown = 0;
    level.active_timer = -1;
    level.teleport_time = 0;
    flag_init( "teleporter_pad_link_1" );
    flag_init( "teleporter_pad_link_2" );
    flag_init( "teleporter_pad_link_3" );
    flag_wait( "start_zombie_round_logic" );

    for ( i = 0; i < 3; i++ )
    {
        trig = getent( "trigger_teleport_pad_" + i, "targetname" );

        if ( isdefined( trig ) )
            level.teleporter_pad_trig[i] = trig;
    }

    thread teleport_pad_think( 0 );
    thread teleport_pad_think( 1 );
    thread teleport_pad_think( 2 );
    thread teleport_core_think();
    thread start_black_room_fx();
    thread init_pack_door();
    level.no_dog_clip = 1;
    packapunch_see = getent( "packapunch_see", "targetname" );

    if ( isdefined( packapunch_see ) )
        packapunch_see thread play_packa_see_vox();

    level.teleport_ae_funcs = [];

    if ( !issplitscreen() )
        level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_fov;

    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_shellshock;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_shellshock_electric;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_bw_vision;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_red_vision;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_flashy_vision;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_factory_teleporter::teleport_aftereffect_flare_vision;
}

init_pack_door()
{
    collision = spawn( "script_model", ( -56, 467, 157 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
    door = getent( "pack_door", "targetname" );
    door movez( -50, 0.05, 0 );
    wait 1.0;
    flag_wait( "start_zombie_round_logic" );
    door movez( 50, 1.5, 0 );
    door playsound( "packa_door_1" );
    wait 2;
    collision delete();
    flag_wait( "teleporter_pad_link_1" );
    door movez( -35, 1.5, 1 );
    door playsound( "packa_door_2" );
    door thread packa_door_reminder();
    wait 2;
    flag_wait( "teleporter_pad_link_2" );
    door movez( -25, 1.5, 1 );
    door playsound( "packa_door_2" );
    wait 2;
    flag_wait( "teleporter_pad_link_3" );
    door movez( -60, 1.5, 1 );
    door playsound( "packa_door_2" );
    clip = getentarray( "pack_door_clip", "targetname" );

    for ( i = 0; i < clip.size; i++ )
    {
        clip[i] connectpaths();
        clip[i] delete();
    }
}

pad_manager()
{
    for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
    {
        level.teleporter_pad_trig[i] sethintstring( &"ZOMBIE_TELEPORT_COOLDOWN" );
        level.teleporter_pad_trig[i] teleport_trigger_invisible( 0 );
    }

    level.is_cooldown = 1;
    wait( level.teleport_cooldown );
    level.is_cooldown = 0;

    for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
    {
        if ( level.teleporter_pad_trig[i].teleport_active )
        {
            level.teleporter_pad_trig[i] sethintstring( &"ZOMBIE_TELEPORT_TO_CORE" );
            continue;
        }

        level.teleporter_pad_trig[i] sethintstring( &"ZOMBIE_LINK_TPAD" );
    }
}

start_black_room_fx()
{
    for ( i = 901; i <= 904; i++ )
    {
        wait 1;
        exploder( i );
    }
}

teleport_pad_think( index )
{
    tele_help = getent( "tele_help_" + index, "targetname" );

    if ( isdefined( tele_help ) )
        tele_help thread play_tele_help_vox();

    active = 0;
    level.teleport[index] = "waiting";
    trigger = level.teleporter_pad_trig[index];
    trigger setcursorhint( "HINT_NOICON" );
    trigger sethintstring( &"ZOMBIE_NEED_POWER" );
    flag_wait( "power_on" );
    trigger sethintstring( &"ZOMBIE_POWER_UP_TPAD" );
    trigger.teleport_active = 0;

    if ( isdefined( trigger ) )
    {
        while ( !active )
        {
            trigger waittill( "trigger" );

            if ( level.active_links < 3 )
            {
                trigger_core = getent( "trigger_teleport_core", "targetname" );
                trigger_core teleport_trigger_invisible( 0 );
            }

            for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
                level.teleporter_pad_trig[i] teleport_trigger_invisible( 1 );

            level.teleport[index] = "timer_on";
            trigger thread teleport_pad_countdown( index, 30 );
            teleporter_vo( "countdown", trigger );

            while ( level.teleport[index] == "timer_on" )
                wait 0.05;

            if ( level.teleport[index] == "active" )
            {
                active = 1;
                clientnotify( "pw" + index );
                clientnotify( "tp" + index );
                teleporter_wire_wait( index );
                trigger thread player_teleporting( index );
            }
            else
            {
                for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
                    level.teleporter_pad_trig[i] teleport_trigger_invisible( 0 );
            }

            wait 0.05;
        }

        if ( level.is_cooldown )
        {
            trigger sethintstring( &"ZOMBIE_TELEPORT_COOLDOWN" );
            trigger teleport_trigger_invisible( 0 );
            trigger.teleport_active = 1;
        }
        else
            trigger thread teleport_pad_active_think( index );
    }
}

teleport_pad_countdown( index, time )
{
    self endon( "stop_countdown" );

    if ( level.active_timer < 0 )
        level.active_timer = index;

    level.countdown++;
    clientnotify( "pac" + index );
    clientnotify( "TRf" );
    players = get_players();

    for ( i = 0; i < players.size; i++ )
        players[i] thread maps\mp\zombies\_zm_timer::start_timer( time + 1, "stop_countdown" );

    wait( time + 1 );

    if ( level.active_timer == index )
        level.active_timer = -1;

    level.teleport[index] = "timer_off";
    clientnotify( "TRs" );
    level.countdown--;
}

teleport_pad_active_think( index )
{
    self setcursorhint( "HINT_NOICON" );
    self.teleport_active = 1;
    user = undefined;

    while ( true )
    {
        self waittill( "trigger", user );

        if ( is_player_valid( user ) && user.score >= level.teleport_cost && !level.is_cooldown )
        {
            for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
                level.teleporter_pad_trig[i] teleport_trigger_invisible( 1 );

            user maps\mp\zombies\_zm_score::minus_to_player_score( level.teleport_cost );
            self player_teleporting( index );
        }
    }
}

player_teleporting( index )
{
    time_since_last_teleport = gettime() - level.teleport_time;
    teleport_pad_start_exploder( index );
    exploder( 105 );
    clientnotify( "tpw" + index );
    self thread teleport_pad_player_fx( level.teleport_delay );
    self thread teleport_2d_audio();
    self thread teleport_nuke( 20, 300 );
    wait( level.teleport_delay );
    self notify( "fx_done" );
    teleport_pad_end_exploder( index );
    self teleport_players();
    clientnotify( "tpc" + index );

    if ( level.is_cooldown == 0 )
        thread pad_manager();

    wait 2.0;
    ss = getstruct( "teleporter_powerup", "targetname" );

    if ( isdefined( ss ) )
        ss thread special_powerup_drop( ss.origin );

    if ( time_since_last_teleport < 60000 && level.active_links == 3 && level.round_number > 20 )
        thread play_sound_2d( "sam_nospawn" );

    level.teleport_time = gettime();
}

teleport_pad_start_exploder( index )
{
    switch ( index )
    {
        case 0:
            exploder( 202 );
            break;
        case 1:
            exploder( 302 );
            break;
        case 2:
            exploder( 402 );
            break;
    }
}

teleport_pad_end_exploder( index )
{
    switch ( index )
    {
        case 0:
            exploder( 201 );
            break;
        case 1:
            exploder( 301 );
            break;
        case 2:
            exploder( 401 );
            break;
    }
}

teleport_trigger_invisible( enable )
{
    players = get_players();

    for ( i = 0; i < players.size; i++ )
    {
        if ( isdefined( players[i] ) )
            self setinvisibletoplayer( players[i], enable );
    }
}

player_is_near_pad( player )
{
    radius = 88;
    scale_factor = 2;
    dist = distance2d( player.origin, self.origin );
    dist_touching = radius * scale_factor;

    if ( dist < dist_touching )
        return true;

    return false;
}

teleport_pad_player_fx( delay )
{
    self endon( "fx_done" );

    while ( true )
    {
        players = get_players();

        for ( i = 0; i < players.size; i++ )
        {
            if ( isdefined( players[i] ) )
            {
                if ( self player_is_near_pad( players[i] ) )
                    continue;
            }
        }

        wait 0.05;
    }
}

teleport_players()
{
    player_radius = 16;
    players = get_players();
    core_pos = [];
    occupied = [];
    image_room = [];
    players_touching = [];
    player_idx = 0;
    prone_offset = vectorscale( ( 0, 0, 1 ), 49.0 );
    crouch_offset = vectorscale( ( 0, 0, 1 ), 20.0 );
    stand_offset = ( 0, 0, 0 );

    for ( i = 0; i < 4; i++ )
    {
        core_pos[i] = getent( "origin_teleport_player_" + i, "targetname" );
        occupied[i] = 0;
        image_room[i] = getent( "teleport_room_" + i, "targetname" );

        if ( isdefined( players[i] ) )
        {
            if ( self player_is_near_pad( players[i] ) )
            {
                players_touching[player_idx] = i;
                player_idx++;

                if ( isdefined( image_room[i] ) )
                {
                    players[i] disableoffhandweapons();
                    players[i] disableweapons();

                    if ( players[i] getstance() == "prone" )
                        desired_origin = image_room[i].origin + prone_offset;
                    else if ( players[i] getstance() == "crouch" )
                        desired_origin = image_room[i].origin + crouch_offset;
                    else
                        desired_origin = image_room[i].origin + stand_offset;

                    players[i].teleport_origin = spawn( "script_origin", players[i].origin );
                    players[i].teleport_origin.angles = players[i].angles;
                    players[i] linkto( players[i].teleport_origin );
                    players[i].teleport_origin.origin = desired_origin;
                    players[i] freezecontrols( 1 );
                    wait_network_frame();

                    if ( isdefined( players[i] ) )
                    {
                        setclientsysstate( "levelNotify", "black_box_start", players[i] );
                        players[i].teleport_origin.angles = image_room[i].angles;
                    }
                }
            }
        }
    }

    wait 2;
    core = getent( "trigger_teleport_core", "targetname" );
    core thread teleport_nuke( undefined, 300 );

    for ( i = 0; i < players.size; i++ )
    {
        if ( isdefined( players[i] ) )
        {
            for ( j = 0; j < 4; j++ )
            {
                if ( !occupied[j] )
                {
                    dist = distance2d( core_pos[j].origin, players[i].origin );

                    if ( dist < player_radius )
                        occupied[j] = 1;
                }
            }

            setclientsysstate( "levelNotify", "black_box_end", players[i] );
        }
    }

    wait_network_frame();

    for ( i = 0; i < players_touching.size; i++ )
    {
        player_idx = players_touching[i];
        player = players[player_idx];

        if ( !isdefined( player ) )
            continue;

        slot = i;
        start = 0;

        while ( occupied[slot] && start < 4 )
        {
            start++;
            slot++;

            if ( slot >= 4 )
                slot = 0;
        }

        occupied[slot] = 1;
        pos_name = "origin_teleport_player_" + slot;
        teleport_core_pos = getent( pos_name, "targetname" );
        player unlink();
        assert( isdefined( player.teleport_origin ) );
        player.teleport_origin delete();
        player.teleport_origin = undefined;
        player enableweapons();
        player enableoffhandweapons();
        player setorigin( core_pos[slot].origin );
        player setplayerangles( core_pos[slot].angles );
        player freezecontrols( 0 );
        player thread teleport_aftereffects();
        vox_rand = randomintrange( 1, 100 );

        if ( vox_rand <= 2 )
            continue;
    }

    exploder( 106 );
}

teleport_core_hint_update()
{
    self setcursorhint( "HINT_NOICON" );

    while ( true )
    {
        if ( !flag( "power_on" ) )
            self sethintstring( &"ZOMBIE_NEED_POWER" );
        else if ( teleport_pads_are_active() )
            self sethintstring( &"ZOMBIE_LINK_TPAD" );
        else if ( level.active_links == 0 )
            self sethintstring( &"ZOMBIE_INACTIVE_TPAD" );
        else
            self sethintstring( "" );

        wait 0.05;
    }
}

teleport_core_think()
{
    trigger = getent( "trigger_teleport_core", "targetname" );

    if ( isdefined( trigger ) )
    {
        trigger thread teleport_core_hint_update();
        flag_wait( "power_on" );
/#
        if ( getdvarint( #"_id_FA81816F" ) >= 6 )
        {
            for ( i = 0; i < level.teleport.size; i++ )
                level.teleport[i] = "timer_on";
        }
#/

        while ( true )
        {
            if ( teleport_pads_are_active() )
            {
                cheat = 0;
/#
                if ( getdvarint( #"_id_FA81816F" ) >= 6 )
                    cheat = 1;
#/

                if ( !cheat )
                    trigger waittill( "trigger" );

                for ( i = 0; i < level.teleport.size; i++ )
                {
                    if ( isdefined( level.teleport[i] ) )
                    {
                        if ( level.teleport[i] == "timer_on" )
                        {
                            level.teleport[i] = "active";
                            level.active_links++;
                            flag_set( "teleporter_pad_link_" + level.active_links );
                            clientnotify( "scd" + i );
                            teleport_core_start_exploder( i );

                            if ( level.active_links == 3 )
                            {
                                exploder( 101 );
                                clientnotify( "pap1" );
                                teleporter_vo( "linkall", trigger );
                                earthquake( 0.3, 2.0, trigger.origin, 3700 );
                            }

                            pad = "trigger_teleport_pad_" + i;
                            trigger_pad = getent( pad, "targetname" );
                            trigger_pad stop_countdown();
                            clientnotify( "TRs" );
                            level.active_timer = -1;
                        }
                    }
                }
            }

            wait 0.05;
        }
    }
}

stop_countdown()
{
    self notify( "stop_countdown" );
    players = get_players();

    for ( i = 0; i < players.size; i++ )
        players[i] notify( "stop_countdown" );
}

teleport_pads_are_active()
{
    if ( isdefined( level.teleport ) )
    {
        for ( i = 0; i < level.teleport.size; i++ )
        {
            if ( isdefined( level.teleport[i] ) )
            {
                if ( level.teleport[i] == "timer_on" )
                    return true;
            }
        }
    }

    return false;
}

teleport_core_start_exploder( index )
{
    switch ( index )
    {
        case 0:
            exploder( 102 );
            break;
        case 1:
            exploder( 103 );
            break;
        case 2:
            exploder( 104 );
            break;
    }
}

teleport_2d_audio()
{
    self endon( "fx_done" );

    while ( true )
    {
        players = get_players();
        wait 1.7;

        for ( i = 0; i < players.size; i++ )
        {
            if ( isdefined( players[i] ) )
            {
                if ( self player_is_near_pad( players[i] ) )
                    setclientsysstate( "levelNotify", "t2d", players[i] );
            }
        }
    }
}

teleport_nuke( max_zombies, range )
{
    zombies = getaispeciesarray( level.zombie_team );
    zombies = get_array_of_closest( self.origin, zombies, undefined, max_zombies, range );

    for ( i = 0; i < zombies.size; i++ )
    {
        wait( randomfloatrange( 0.2, 0.3 ) );

        if ( !isdefined( zombies[i] ) )
            continue;

        if ( is_magic_bullet_shield_enabled( zombies[i] ) )
            continue;

        if ( !zombies[i].isdog )
        {

        }

        zombies[i] dodamage( 10000, zombies[i].origin );
        playsoundatposition( "nuked", zombies[i].origin );
    }
}

teleporter_vo( tele_vo_type, location )
{
    if ( !isdefined( location ) )
        self thread teleporter_vo_play( tele_vo_type, 2 );
    else
    {
        players = get_players();

        for ( i = 0; i < players.size; i++ )
        {
            if ( distance( players[i].origin, location.origin ) < 64 )
            {
                switch ( tele_vo_type )
                {
                    case "linkall":
                        players[i] thread teleporter_vo_play( "tele_linkall" );
                        break;
                    case "countdown":
                        players[i] thread teleporter_vo_play( "tele_count", 3 );
                        break;
                }
            }
        }
    }
}

teleporter_vo_play( vox_type, pre_wait )
{
    if ( !isdefined( pre_wait ) )
        pre_wait = 0;

    wait( pre_wait );
}

play_tele_help_vox()
{
    level endon( "tele_help_end" );

    while ( true )
    {
        self waittill( "trigger", who );

        if ( flag( "power_on" ) )
        {
            who thread teleporter_vo_play( "tele_help" );
            level notify( "tele_help_end" );
        }

        while ( isdefined( who ) && who istouching( self ) )
            wait 0.1;
    }
}

play_packa_see_vox()
{
    wait 10;

    if ( !flag( "teleporter_pad_link_3" ) )
    {
        self waittill( "trigger", who );
        who thread teleporter_vo_play( "perk_packa_see" );
    }
}

teleporter_wire_wait( index )
{
    targ = getstruct( "pad_" + index + "_wire", "targetname" );

    if ( !isdefined( targ ) )
        return;

    while ( isdefined( targ ) )
    {
        if ( isdefined( targ.target ) )
        {
            target = getstruct( targ.target, "targetname" );
            wait 0.1;
            targ = target;
        }
        else
            break;
    }
}

teleport_aftereffects()
{
    if ( getdvar( #"_id_A0FE0B5C" ) == "-1" )
        self thread [[ level.teleport_ae_funcs[randomint( level.teleport_ae_funcs.size )] ]]();
    else
        self thread [[ level.teleport_ae_funcs[int( getdvar( #"_id_A0FE0B5C" ) )] ]]();
}

teleport_aftereffect_shellshock()
{
/#
    println( "*** Explosion Aftereffect***\\n" );
#/
    self shellshock( "explosion", 4 );
}

teleport_aftereffect_shellshock_electric()
{
/#
    println( "***Electric Aftereffect***\\n" );
#/
    self shellshock( "electrocution", 4 );
}

teleport_aftereffect_fov()
{
    setclientsysstate( "levelNotify", "tae", self );
}

teleport_aftereffect_bw_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "tae", self );
}

teleport_aftereffect_red_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "tae", self );
}

teleport_aftereffect_flashy_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "tae", self );
}

teleport_aftereffect_flare_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "tae", self );
}

packa_door_reminder()
{
    while ( !flag( "teleporter_pad_link_3" ) )
    {
        rand = randomintrange( 4, 16 );
        self playsound( "packa_door_hitch" );
        wait( rand );
    }
}

dog_blocker_clip()
{
    collision = spawn( "script_model", ( -106, -2294, 216 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 37.2 );
    collision hide();
    collision = spawn( "script_model", ( -1208, -439, 363 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
}
