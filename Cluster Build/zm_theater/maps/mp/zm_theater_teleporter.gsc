// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_theater_teleporter;
#include maps\mp\zm_theater_magic_box;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;

teleporter_init()
{
    level.teleport = [];
    level.teleport_delay = 1.8;
    level.teleport_cost = 0;
    level.teleport_ae_funcs = [];
    level.eeroomsinuse = undefined;
    level.second_hand = getent( "zom_clock_second_hand", "targetname" );
    level.second_hand_angles = level.second_hand.angles;
    level.zombietheaterteleporterseeklogicfunc = maps\mp\zm_theater_teleporter::zombietheaterteleporterseeklogic;
    flag_init( "teleporter_linked" );
    flag_init( "core_linked" );
    setdvar( "theaterAftereffectOverride", "-1" );
    poi1 = getent( "teleporter_poi1", "targetname" );
    poi2 = getent( "teleporter_poi2", "targetname" );
    players = getplayers();

    if ( players.size > 1 )
    {
        poi1 create_zombie_point_of_interest( undefined, 30, 0, 0 );
        poi2 create_zombie_point_of_interest( 256, 15, 0, 0 );
    }
    else
    {
        poi1 create_zombie_point_of_interest( undefined, 35, 100, 0 );
        poi2 create_zombie_point_of_interest( 256, 10, 0, 0 );
    }

    poi1 thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
    poi2 thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
    thread teleport_core_think( 0 );
    thread teleport_link_think();
    thread teleport_pad_think();
    thread theater_fly_me_to_the_moon_init();
    players = getplayers();

    for ( i = 0; i < players.size; i++ )
        setclientsysstate( "levelNotify", "pack_clock_start", players[i] );

    if ( !issplitscreen() )
        level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_fov;

    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_shellshock;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_shellshock_electric;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_bw_vision;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_red_vision;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_flashy_vision;
    level.teleport_ae_funcs[level.teleport_ae_funcs.size] = maps\mp\zm_theater_teleporter::teleport_aftereffect_flare_vision;
}

teleport_core_think( index )
{
    trigger_name = "trigger_teleport_pad_" + index;
    active = 0;
    user = undefined;
    trigger = getent( trigger_name, "targetname" );
    trigger setcursorhint( "HINT_NOICON" );
    teleport_start_exploder( 0 );
    trigger sethintstring( "" );
    trigger maps\mp\zm_theater_magic_box::turnlightred( "teleporter_indicator_light1", 1 );

    if ( isdefined( trigger ) )
    {
        while ( !active )
        {
            flag_wait( "teleporter_linked" );
            trigger maps\mp\zm_theater_magic_box::turnlightgreen( "teleporter_indicator_light1", 1 );
            trigger sethintstring( &"ZOMBIE_THEATER_USE_TELEPORTER" );
            trigger waittill( "trigger", user );

            if ( is_player_valid( user ) && user.score >= level.teleport_cost )
            {
                active = 1;
                trigger maps\mp\zm_theater_magic_box::turnlightred( "teleporter_indicator_light1", 1 );
                trigger sethintstring( "" );
                user maps\mp\zombies\_zm_score::minus_to_player_score( level.teleport_cost );
                trigger player_teleporting( index );

                if ( isdefined( level.link_cable_on ) && isdefined( level.link_cable_off ) )
                {
                    level.link_cable_on hide();
                    level.link_cable_off show();
                }

                trigger sethintstring( &"ZOMBIE_TELEPORT_COOLDOWN" );
                wait 90;
                active = 0;
                flag_clear( "teleporter_linked" );
                flag_clear( "core_linked" );
                trigger maps\mp\zm_theater_magic_box::turnlightgreen( "teleporter_indicator_light1", 1 );
            }
        }
    }
}

teleport_link_think()
{
    trigger_name = "trigger_teleport_pad_0";
    core = getent( trigger_name, "targetname" );
    user = undefined;

    while ( true )
    {
        if ( !flag( "core_linked" ) )
        {
            core sethintstring( &"ZOMBIE_THEATER_LINK_CORE" );
            core waittill( "trigger", user );
            core playsound( "evt_teleporter_activate_start" );
            flag_set( "core_linked" );
            core sethintstring( "" );
            pad = getent( core.target, "targetname" );
            pad sethintstring( &"ZOMBIE_THEATER_LINK_PAD" );
        }

        wait_network_frame();
    }
}

teleport_pad_hide_use()
{
    trigger_name = "trigger_teleport_pad_0";
    core = getent( trigger_name, "targetname" );
    pad = getent( core.target, "targetname" );
    pad setcursorhint( "HINT_NOICON" );
    level.link_cable_off = getent( "teleporter_link_cable_off", "targetname" );
    level.link_cable_on = getent( "teleporter_link_cable_on", "targetname" );

    if ( isdefined( level.link_cable_on ) )
        level.link_cable_on hide();

    pad sethintstring( &"ZOMBIE_NEED_POWER" );
    flag_wait( "power_on" );
    pad sethintstring( &"ZOMBIE_THEATER_START_CORE" );
}

teleport_pad_think()
{
    trigger_name = "trigger_teleport_pad_0";
    core = getent( trigger_name, "targetname" );
    pad = getent( core.target, "targetname" );
    user = undefined;

    while ( true )
    {
        if ( !flag( "teleporter_linked" ) && flag( "core_linked" ) )
        {
            pad waittill( "trigger", user );
            pad sethintstring( "" );
            pad playsound( "evt_teleporter_activate_finish" );
            flag_set( "teleporter_linked" );

            if ( isdefined( level.link_cable_on ) && isdefined( level.link_cable_off ) )
            {
                level.link_cable_off hide();
                level.link_cable_on show();
            }
        }

        wait_network_frame();
    }
}

teleport_start_exploder( index )
{
    switch ( index )
    {
        case 0:
            exploder( 102 );
            break;
    }
}

player_teleporting( index )
{
    players_in_proj_room = [];
    teleport_pad_start_exploder( index );
    self thread teleport_pad_player_fx( undefined );
    self thread teleport_2d_audio();
    self thread teleport_nuke( undefined, 300 );
    wait( level.teleport_delay );
    self notify( "fx_done" );
    self thread teleport_pad_end_exploder( 0 );
    players_in_proj_room = self teleport_players( players_in_proj_room, "projroom" );

    if ( !isdefined( players_in_proj_room ) || isdefined( players_in_proj_room ) && players_in_proj_room.size < 1 )
        return;

    wait 30;
    level.extracam_screen hide();
    clientnotify( "camera_stop" );

    if ( randomint( 100 ) > 24 && !isdefined( level.eeroomsinuse ) )
    {
        loc = "eerooms";
        level.eeroomsinuse = 1;

        if ( randomint( 100 ) > 65 )
            level thread eeroom_powerup_drop();
    }
    else
    {
        loc = "theater";
        exploder( 301 );
    }

    self thread teleport_pad_player_fx( players_in_proj_room );
    self thread teleport_2d_audio_specialroom_start( players_in_proj_room );
    wait( level.teleport_delay );
    self notify( "fx_done" );
    self thread teleport_2d_audio_specialroom_go( players_in_proj_room );
    self teleport_players( players_in_proj_room, loc );

    if ( isdefined( loc ) && loc == "eerooms" )
    {
        loc = "theater";
        wait 4;
        self thread teleport_2d_audio_specialroom_start( players_in_proj_room );
        exploder( 301 );
        self thread teleport_pad_player_fx( players_in_proj_room );
        wait( level.teleport_delay );
        self notify( "fx_done" );
        self thread teleport_2d_audio_specialroom_go( players_in_proj_room );
        self teleport_players( players_in_proj_room, loc );
    }
}

teleport_pad_start_exploder( index )
{
    switch ( index )
    {
        case 0:
            exploder( 202 );
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
    }
}

teleport_trigger_invisible( enable )
{
    players = getplayers();

    for ( i = 0; i < players.size; i++ )
    {
        if ( isdefined( players[i] ) )
            self setinvisibletoplayer( players[i], enable );
    }
}

player_is_near_pad( player )
{
    if ( player istouching( self ) )
        return true;

    return false;
}

teleport_pad_player_fx( players )
{
    self endon( "fx_done" );
    inprojroom = 0;

    if ( !isdefined( players ) )
        players = getplayers();
    else
        inprojroom = 1;

    while ( true )
    {
        for ( i = 0; i < players.size; i++ )
        {
            if ( isdefined( players[i] ) )
            {
                if ( self player_is_near_pad( players[i] ) || inprojroom )
                    continue;
            }
        }

        wait 0.05;
    }
}

teleport_players( players_in_proj_room, loc )
{
    player_radius = 16;
    dest_room = [];
    all_players = get_players();
    slot = undefined;
    start = undefined;

    if ( loc == "projroom" )
        players = all_players;
    else
        players = players_in_proj_room;

    dest_room = get_array_spots( "teleport_room_", dest_room );
    initialize_occupied_flag( dest_room );
    check_for_occupied_spots( dest_room, all_players, player_radius );
    prone_offset = vectorscale( ( 0, 0, 1 ), 49.0 );
    crouch_offset = vectorscale( ( 0, 0, 1 ), 20.0 );
    stand_offset = ( 0, 0, 0 );

    for ( i = 0; i < players.size; i++ )
    {
        if ( isdefined( players[i] ) )
        {
            if ( loc == "projroom" && self player_is_near_pad( players[i] ) == 0 )
                continue;
            else if ( loc == "projroom" && self player_is_near_pad( players[i] ) )
                players_in_proj_room[players_in_proj_room.size] = players[i];

            players[i].is_teleporting = 1;
            slot = i;
            start = 0;

            while ( dest_room[slot].occupied && start < 4 )
            {
                start++;
                slot++;

                if ( slot >= 4 )
                    slot = 0;
            }

            dest_room[slot].occupied = 1;
            players[i].inteleportation = 1;
            players[i] disableoffhandweapons();
            players[i] disableweapons();

            if ( players[i] getstance() == "prone" )
                desired_origin = dest_room[i].origin + prone_offset;
            else if ( players[i] getstance() == "crouch" )
                desired_origin = dest_room[i].origin + crouch_offset;
            else
                desired_origin = dest_room[i].origin + stand_offset;

            players[i].teleport_origin = spawn( "script_origin", players[i].origin );
            players[i].teleport_origin.angles = players[i].angles;
            players[i] linkto( players[i].teleport_origin );
            players[i].teleport_origin.origin = desired_origin;
            players[i] freezecontrols( 1 );
            wait_network_frame();
            setclientsysstate( "levelNotify", "black_box_start", players[i] );
            players[i].teleport_origin.angles = dest_room[i].angles;
        }
    }

    if ( !isdefined( players_in_proj_room ) || isdefined( players_in_proj_room ) && players_in_proj_room.size < 1 )
        return;

    wait 2;
    dest_room = [];

    if ( loc == "projroom" )
        dest_room = get_array_spots( "projroom_teleport_player", dest_room );
    else if ( loc == "eerooms" )
    {
        level.eeroomsinuse = 1;
        dest_room = get_array_spots( "ee_teleport_player", dest_room );
    }
    else if ( loc == "theater" )
    {
        if ( isdefined( self.target ) )
        {
            ent = getent( self.target, "targetname" );
            self thread teleport_nuke( undefined, 20 );
        }

        dest_room = get_array_spots( "theater_teleport_player", dest_room );
    }

    initialize_occupied_flag( dest_room );
    check_for_occupied_spots( dest_room, all_players, player_radius );

    for ( i = 0; i < players_in_proj_room.size; i++ )
    {
        slot = randomintrange( 0, 4 );
        start = 0;

        while ( dest_room[slot].occupied && start < 4 )
        {
            start++;
            slot++;

            if ( slot >= 4 )
                slot = 0;
        }

        dest_room[slot].occupied = 1;
        setclientsysstate( "levelNotify", "black_box_end", players_in_proj_room[i] );
        assert( isdefined( players_in_proj_room[i].teleport_origin ) );
        players_in_proj_room[i].teleport_origin delete();
        players_in_proj_room[i].teleport_origin = undefined;
        players_in_proj_room[i] setorigin( dest_room[slot].origin );
        players_in_proj_room[i] setplayerangles( dest_room[slot].angles );

        if ( loc != "eerooms" )
        {
            players_in_proj_room[i] enableweapons();
            players_in_proj_room[i] enableoffhandweapons();
            players_in_proj_room[i] freezecontrols( 0 );
        }
        else
            players_in_proj_room[i] freezecontrols( 0 );

        setclientsysstate( "levelNotify", "t2bfx", players_in_proj_room[i] );
        players_in_proj_room[i] teleport_aftereffects();

        if ( loc == "projroom" )
        {
            level.second_hand thread start_wall_clock();
            thread extra_cam_startup();
        }
        else if ( loc == "theater" )
            players_in_proj_room[i].inteleportation = 0;

        players[i].is_teleporting = 0;
    }

    if ( loc == "projroom" )
        return players_in_proj_room;
    else if ( loc == "theater" )
    {
        level.eeroomsinuse = undefined;
        exploder( 302 );
    }
}

extra_cam_startup()
{
    wait 2.0;
    level.extracam_screen show();
    players = get_players();

    for ( i = 0; i < players.size; i++ )
        setclientsysstate( "levelNotify", "camera_start", players[i] );
}

get_array_spots( sname, spots )
{
    for ( i = 0; i < 4; i++ )
        spots[i] = getent( sname + i, "targetname" );

    return spots;
}

initialize_occupied_flag( spots )
{
    for ( i = 0; i < spots.size; i++ )
        spots[i].occupied = 0;
}

check_for_occupied_spots( dest, players, player_radius )
{
    for ( i = 0; i < players.size; i++ )
    {
        if ( isdefined( players[i] ) )
        {
            for ( j = 0; j < dest.size; j++ )
            {
                if ( !dest[j].occupied )
                {
                    dist = distance2d( dest[j].origin, players[i].origin );

                    if ( dist < player_radius )
                        dest[j].occupied = 1;
                }
            }
        }
    }
}

teleport_2d_audio()
{
    self endon( "fx_done" );
    clientnotify( "tpa" );
    players = getplayers();
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

teleport_2d_audio_nopad( player )
{
    self endon( "fx_done" );

    for ( i = 0; i < player.size; i++ )
    {
        if ( isdefined( player[i] ) )
            setclientsysstate( "levelNotify", "t2dn", player[i] );
    }
}

teleport_2d_audio_specialroom_start( player )
{
    self endon( "fx_done" );

    for ( i = 0; i < player.size; i++ )
    {
        if ( isdefined( player[i] ) )
            setclientsysstate( "levelNotify", "tss", player[i] );
    }
}

teleport_2d_audio_specialroom_go( player )
{
    self endon( "fx_done" );

    for ( i = 0; i < player.size; i++ )
    {
        if ( isdefined( player[i] ) )
            setclientsysstate( "levelNotify", "tsg", player[i] );
    }
}

teleport_nuke( max_zombies, range )
{
    zombies = getaispeciesarray( "axis" );
    zombies = get_array_of_closest( self.origin, zombies, undefined, max_zombies, range );

    for ( i = 0; i < zombies.size; i++ )
    {
        wait( randomfloatrange( 0.2, 0.3 ) );

        if ( !isdefined( zombies[i] ) )
            continue;

        if ( isdefined( zombies[i].animname ) && ( zombies[i].animname != "boss_zombie" && zombies[i].animname != "ape_zombie" && zombies[i].animname != "zombie_dog" ) && zombies[i].health < 5000 )
            zombies[i] maps\mp\zombies\_zm_spawner::zombie_head_gib();

        zombies[i] dodamage( zombies[i].health + 100, zombies[i].origin );
        playsoundatposition( "nuked", zombies[i].origin );
    }
}

teleporter_vo_play( vox_type, pre_wait )
{
    if ( !isdefined( pre_wait ) )
        pre_wait = 0;

    index = maps\mp\zombies\_zm_weapons::get_player_index( self );
    plr = "plr_" + index + "_";
    wait( pre_wait );
    self maps\mp\zombies\_zm_audio::create_and_play_dialog( plr, vox_type, 0.25 );
}

teleport_aftereffects()
{
    if ( getdvar( #"_id_3608B991" ) == "-1" )
        self thread [[ level.teleport_ae_funcs[randomint( level.teleport_ae_funcs.size )] ]]();
    else
        self thread [[ level.teleport_ae_funcs[int( getdvar( #"_id_3608B991" ) )] ]]();
}

teleport_aftereffect_shellshock()
{
/#
    println( "*** Explosion Aftereffect***\\n" );
#/
    self shellshock( "explosion", 3 );
}

teleport_aftereffect_shellshock_electric()
{
/#
    println( "***Electric Aftereffect***\\n" );
#/
    self shellshock( "electrocution", 3 );
}

teleport_aftereffect_fov()
{
    setclientsysstate( "levelNotify", "teleport_ae_start", self );
}

teleport_aftereffect_bw_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "teleport_ae_start", self );
}

teleport_aftereffect_red_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "teleport_ae_start", self );
}

teleport_aftereffect_flashy_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "teleport_ae_start", self );
}

teleport_aftereffect_flare_vision( localclientnum )
{
    setclientsysstate( "levelNotify", "teleport_ae_start", self );
}

zombietheaterteleporterseeklogic()
{
    inteleportcount = 0;
    nonteleportinvalidcount = 0;
    poi1 = getent( "teleporter_poi1", "targetname" );
    poi2 = getent( "teleporter_poi2", "targetname" );
    players = getplayers();

    for ( i = 0; i < players.size; i++ )
    {
        if ( isdefined( players[i].inteleportation ) && players[i].inteleportation == 1 )
            inteleportcount++;

        if ( !is_player_valid( players[i] ) && ( !isdefined( players[i].inteleportation ) || players[i].inteleportation == 0 ) )
            nonteleportinvalidcount++;
    }

    if ( inteleportcount > 0 && ( inteleportcount == players.size || inteleportcount + nonteleportinvalidcount == players.size ) )
    {
        if ( !poi1.poi_active && !poi2.poi_active )
        {
            poi1 activate_zombie_point_of_interest();
            poi2 activate_zombie_point_of_interest();
        }
    }
    else if ( inteleportcount != players.size )
    {
        if ( poi1.poi_active && poi2.poi_active )
        {
            if ( isdefined( poi1.attractor_array ) )
                poi1 deactivate_zombie_point_of_interest();

            if ( isdefined( poi2.attractor_array ) )
                poi2 deactivate_zombie_point_of_interest();
        }

        if ( inteleportcount > 0 )
        {
            for ( i = 0; i < players.size; i++ )
            {
                if ( isdefined( players[i].inteleportation ) && players[i].inteleportation == 1 )
                    self.ignore_player[self.ignore_player.size] = players[i];
            }
        }
    }
}

zombies_goto_position( position )
{
    self endon( "death" );
    self endon( "bad_path" );
    orig_radius = self.goalradius;
    self.ignoreall = 1;
    self.goalradius = 128;
/#
    iprintlnbold( "zombie goal radius ", orig_radius );
#/
    self setgoalpos( position.origin + ( randomfloatrange( -40, 40 ), randomfloatrange( -40, 40 ), 0 ) );
    self waittill( "goal" );
    self.ignoreall = 0;
    self.goalradius = orig_radius;
    self orientmode( "face point", level.extracam_screen.origin );
}

start_wall_clock()
{
    self rotatepitch( 180, 0.05 );
    self waittill( "rotatedone" );

    for ( clocktime = 0; clocktime != 30; clocktime++ )
    {
        self rotatepitch( 6, 0.1 );
        wait 1;
    }

    wait 5.0;
    self rotateto( level.second_hand_angles, 0.05 );
}

movie_graveyard_return()
{
    trigger = getent( "teleporter_exit_graveyard", "targetname" );
    trigger setcursorhint( "HINT_NOICON" );
    trigger sethintstring( &"ZOMBIE_USE_TELEPORTER", level.teleport_cost );

    if ( isdefined( trigger ) )
    {
        while ( true )
        {
            trigger waittill( "trigger", user );
            trigger sethintstring( "" );
            level notify( "return_from_graveyard" );
            wait 60;
            trigger sethintstring( &"ZOMBIE_USE_TELEPORTER", level.teleport_cost );
        }
    }
}

film_grain_init()
{
    grain = newclienthudelem( self );
    grain.x = 0;
    grain.y = 0;
    grain.alignx = "left";
    grain.aligny = "top";
    grain.horzalign = "fullscreen";
    grain.vertalign = "fullscreen";
    grain.foreground = 1;
    grain setshader( "ac130_overlay_grain", 640, 480 );
    grain.alpha = 0.5;
    visionsetnaked( "cheat_bw", 0.5 );
    level waittill( "return_from_graveyard" );
    visionsetnaked( "default", 0 );
    grain destroy();
}

eeroom_powerup_drop()
{
    struct_array = getstructarray( "struct_random_powerup_post_teleport", "targetname" );
    powerup_array = [];
    powerup_array[powerup_array.size] = "nuke";
    powerup_array[powerup_array.size] = "insta_kill";
    powerup_array[powerup_array.size] = "double_points";
    powerup_array[powerup_array.size] = "carpenter";
    powerup_array[powerup_array.size] = "fire_sale";
    powerup_array[powerup_array.size] = "full_ammo";
    powerup_array[powerup_array.size] = "minigun";
    struct_array = array_randomize( struct_array );
    powerup_array = array_randomize( powerup_array );
    level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( powerup_array[0], struct_array[0].origin );
}

theater_fly_me_to_the_moon_init()
{
    funny_trigger = getent( "trigger_jump", "targetname" );
    to_the_moon_alice_trigger = getent( "trigger_fly_me_to_the_moon", "targetname" );
    funny_trigger thread theater_player_jumps();
    to_the_moon_alice_trigger thread theater_fly_me_to_the_moon();
}

theater_player_jumps()
{
    while ( isdefined( self ) )
    {
        self waittill( "trigger", who );

        if ( !isdefined( who._moon_jumps ) )
            who._moon_jumps = 0;

        self trigger_thread( who, ::theater_moon_jumps, ::theater_moon_jumps_clear );
    }
}

theater_moon_jumps( guy, str_endon )
{
    self endon( str_endon );

    while ( true )
    {
        if ( guy jumpbuttonpressed() )
        {
            guy._moon_jumps = guy._moon_jumps + 1;
            wait 0.9;
        }

        wait 0.1;
    }
}

theater_moon_jumps_clear( guy )
{
    if ( guy._moon_jumps < 5 )
        guy._moon_jumps = 0;
}

theater_fly_me_to_the_moon()
{
    self sethintstring( "" );
    self setcursorhint( "HINT_NOICON" );

    while ( isdefined( self ) )
    {
        self waittill( "trigger", who );

        if ( !isdefined( who._moon_jumps ) || who._moon_jumps < 5 )
        {
            wait 0.1;
            continue;
        }

        if ( isdefined( who._moon_jumps ) && who._moon_jumps >= 5 )
        {
            level theater_moon_jump_go();
            who._moon_jumps = 0;
        }
    }
}

theater_moon_jump_go()
{
    ship = getent( "model_zombie_rocket", "targetname" );
    blast_off_fx = level._effect["fx_mp_pipe_steam"];
    ship_base_origin = ship.origin;
    ship.fx_spot = spawn( "script_model", ship.origin + vectorscale( ( 0, 0, -1 ), 19.0 ) );
    ship.fx_spot setmodel( "tag_origin" );
    ship.fx_spot.angles = vectorscale( ( 1, 0, 0 ), 90.0 );
    ship.fx_spot linkto( ship );
    wait 0.1;
    playfxontag( blast_off_fx, ship.fx_spot, "tag_origin" );
    ship movez( 120, 3.0, 0.7, 0 );
    ship waittill( "movedone" );
    ship.fx_spot unlink();
    ship.fx_spot delete();
    ship hide();
    ship moveto( ship_base_origin, 0.1 );
    ship waittill( "movedone" );
    ship show();
}
