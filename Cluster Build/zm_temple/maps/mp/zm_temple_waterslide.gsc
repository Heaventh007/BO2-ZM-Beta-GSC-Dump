// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_utility_raven;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_laststand;

precache_assets()
{
    level._effect["fx_slide_wake"] = loadfx( "bio/player/fx_player_water_swim_wake" );
    level._effect["fx_slide_splash"] = loadfx( "bio/player/fx_player_water_splash" );
    level._effect["fx_slide_splash_2"] = loadfx( "env/water/fx_water_splash_fountain_lg" );
    level._effect["fx_slide_splash_3"] = loadfx( "maps/pow/fx_pow_cave_water_splash" );
    level._effect["fx_slide_water_fall"] = loadfx( "maps/pow/fx_pow_cave_water_fall" );
}

waterslide_main()
{
    flag_init( "waterslide_open" );
    zombie_cave_slide_init();

    if ( getdvar( #"_id_3003FB1F" ) == "" )
        setdvar( "waterslide_debug", "0" );

    messagetrigger = getent( "waterslide_message_trigger", "targetname" );

    if ( isdefined( messagetrigger ) )
        messagetrigger setcursorhint( "HINT_NOICON" );

    cheat = 0;
/#
    cheat = getdvarint( #"_id_3003FB1F" ) > 0;
#/

    if ( !cheat )
    {
        if ( isdefined( messagetrigger ) )
            messagetrigger sethintstring( &"ZOMBIE_NEED_POWER" );

        flag_wait( "power_on" );

        if ( isdefined( messagetrigger ) )
            messagetrigger sethintstring( &"ZOMBIE_TEMPLE_DESTINATION_NOT_OPEN" );

        flag_wait_any( "cave01_to_cave02", "pressure_to_cave01" );
    }

    flag_set( "waterslide_open" );

    if ( isdefined( messagetrigger ) )
        messagetrigger sethintstring( "" );

    waterslideblocker = getent( "water_slide_blocker", "targetname" );

    if ( isdefined( waterslideblocker ) )
    {
        waterslideblocker connectpaths();
        waterslideblocker movez( 128, 1 );
    }

    level notify( "slide_open" );
}

zombie_cave_slide_init()
{
    flag_init( "slide_anim_change_allowed" );
    level.zombies_slide_anim_change = [];
    level thread slide_anim_change_throttle();
    flag_set( "slide_anim_change_allowed" );
    slide_trigs = getentarray( "zombie_cave_slide", "targetname" );
    array_thread( slide_trigs, ::slide_trig_watch );
    level thread slide_player_enter_watch();
    level thread slide_player_exit_watch();
    level thread zombie_caveslide_anim_failsafe();
}

zombie_caveslide_anim_failsafe()
{
    trig = getent( "zombie_cave_slide_failsafe", "targetname" );

    if ( isdefined( trig ) )
    {
        while ( true )
        {
            trig waittill( "trigger", who );

            if ( is_true( who.sliding ) )
                who.sliding = 0;
        }
    }
}

slide_trig_watch()
{
    slide_node = getnode( self.target, "targetname" );

    if ( !isdefined( slide_node ) )
        return;

    self trigger_off();
    level waittill( "slide_open" );
    self trigger_on();

    while ( true )
    {
        self waittill( "trigger", who );

        if ( who.animname == "zombie" || who.animname == "sonic_zombie" || who.animname == "napalm_zombie" )
        {
            if ( isdefined( who.sliding ) && who.sliding == 1 )
                continue;
            else
                who thread zombie_sliding( slide_node );
        }
        else if ( isdefined( who.zombie_sliding ) )
            who thread [[ who.zombie_sliding ]]( slide_node );
    }
}

cave_slide_anim_init()
{

}

zombie_sliding( slide_node )
{
    self endon( "death" );
    level endon( "intermission" );

    if ( !isdefined( self.cave_slide_flag_init ) )
    {
        self ent_flag_init( "slide_anim_change" );
        self.cave_slide_flag_init = 1;
    }

    self.is_traversing = 1;
    self notify( "zombie_start_traverse" );
    self thread zombie_slide_watch();
    self thread play_zombie_slide_looper();
    self.sliding = 1;
    self.ignoreall = 1;
    self thread gibbed_while_sliding();
    self notify( "stop_find_flesh" );
    self notify( "zombie_acquire_enemy" );
    self thread set_zombie_slide_anim();
    self setgoalnode( slide_node );
    check_dist_squared = 3600;

    while ( distancesquared( self.origin, slide_node.origin ) > check_dist_squared )
        wait 0.01;

    self notify( "water_slide_exit" );
    self.sliding = 0;
    self.is_traversing = 0;
    self notify( "zombie_end_traverse" );
    self.ignoreall = 0;
    self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

play_zombie_slide_looper()
{
    self endon( "death" );
    level endon( "intermission" );
    self playloopsound( "fly_dtp_slide_loop_npc_snow", 0.5 );
    self waittill_any( "zombie_end_traverse", "death" );
    self stoploopsound( 0.5 );
}

set_zombie_slide_anim()
{

}

reset_zombie_anim()
{

}

death_while_sliding()
{
    self endon( "death" );

    if ( self.animname == "sonic_zombie" || self.animname == "napalm_zombie" )
        return self.deathanim;

    death_animation = undefined;
    rand = randomintrange( 1, 5 );

    if ( self.has_legs )
        death_animation = level.scr_anim[self.animname]["attracted_death_" + rand];

    return death_animation;
}

gibbed_while_sliding()
{
    self endon( "death" );

    if ( self.animname == "sonic_zombie" || self.animname == "napalm_zombie" )
        return;

    if ( !self.has_legs )
        return;

    while ( self.sliding )
    {
        if ( !self.has_legs && self._had_legs == 1 )
            return;

        wait 0.1;
    }
}

slide_anim_change_throttle()
{
    if ( !isdefined( level.zombies_slide_anim_change ) )
        level.zombies_slide_anim_change = [];

    int_max_num_zombies_per_frame = 7;
    array_zombies_allowed_to_switch = [];

    while ( isdefined( level.zombies_slide_anim_change ) )
    {
        if ( level.zombies_slide_anim_change.size == 0 )
        {
            wait 0.1;
            continue;
        }

        array_zombies_allowed_to_switch = level.zombies_slide_anim_change;

        for ( i = 0; i < array_zombies_allowed_to_switch.size; i++ )
        {
            if ( isdefined( array_zombies_allowed_to_switch[i] ) && isalive( array_zombies_allowed_to_switch[i] ) )
                array_zombies_allowed_to_switch[i] ent_flag_set( "slide_anim_change" );

            if ( i >= int_max_num_zombies_per_frame )
                break;
        }

        flag_clear( "slide_anim_change_allowed" );

        for ( i = 0; i < array_zombies_allowed_to_switch.size; i++ )
        {
            if ( array_zombies_allowed_to_switch[i] ent_flag( "slide_anim_change" ) )
                level.zombies_slide_anim_change = array_remove( level.zombies_slide_anim_change, array_zombies_allowed_to_switch[i] );
        }

        level.zombies_slide_anim_change = array_removedead( level.zombies_slide_anim_change );
        flag_set( "slide_anim_change_allowed" );
        wait_network_frame();
        wait 0.1;
    }
}

array_remove( array, object )
{
    if ( !isdefined( array ) && !isdefined( object ) )
        return;

    new_array = [];

    foreach ( item in array )
    {
        if ( item != object )
            new_array[new_array.size] = item;
    }

    return new_array;
}

slide_player_enter_watch()
{
    level endon( "fake_death" );
    trig = getent( "cave_slide_force_crouch", "targetname" );

    while ( true )
    {
        trig waittill( "trigger", who );

        if ( isdefined( who ) && isplayer( who ) && who.sessionstate != "spectator" && !is_true( who.on_slide ) )
        {
            who.on_slide = 1;
            who thread player_slide_watch();
            who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "slide" );
        }
    }
}

slide_player_exit_watch()
{
    trig = getent( "cave_slide_force_stand", "targetname" );

    while ( true )
    {
        trig waittill( "trigger", who );

        if ( isdefined( who ) && isplayer( who ) && who.sessionstate != "spectator" && is_true( who.on_slide ) )
        {
            who.on_slide = 0;
            who notify( "water_slide_exit" );
        }
    }
}

player_slide_watch()
{
    self thread on_player_enter_slide();
    self thread player_slide_fake_death_watch();
    self waittill_any( "water_slide_exit", "death", "disconnect" );

    if ( isdefined( self ) )
        self thread on_player_exit_slide();
}

player_slide_fake_death_watch()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "water_slide_exit" );
    self waittill( "fake_death" );
    self allowstand( 1 );
    self allowprone( 1 );
}

on_player_enter_slide()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "water_slide_exit" );

    while ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        wait 0.1;

    while ( is_true( self.divetoprone ) )
        wait 0.1;

    self allowstand( 0 );
    self allowprone( 0 );
    self setstance( "crouch" );
}

on_player_exit_slide()
{
    self endon( "death" );
    self endon( "disconnect" );
    self allowstand( 1 );
    self allowprone( 1 );

    if ( !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        self setstance( "stand" );
}

zombie_slide_watch()
{
    self thread on_zombie_enter_slide();
    self waittill_any( "water_slide_exit", "death" );
    self thread on_zombie_exit_slide();
}

on_zombie_enter_slide()
{

}

on_zombie_exit_slide()
{

}
