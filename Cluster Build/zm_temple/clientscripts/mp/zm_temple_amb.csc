// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_music;
#include clientscripts\mp\_busing;
#include clientscripts\mp\_audio;

main()
{
    declareambientroom( "outside" );
    setambientroomtone( "outside", "amb_wind_outside", 0.6, 1 );
    setambientroomreverb( "outside", "rv_zmbtemple_outdoor", 1, 1 );
    setambientroomcontext( "outside", "ringoff_plr", "outdoor" );
    declareambientroom( "small_stone_room" );
    setambientroomtone( "small_stone_room", "amb_wind_cave", 0.6, 1 );
    setambientroomreverb( "small_stone_room", "rv_zmbtemple_cave_tunnels", 1, 1 );
    setambientroomcontext( "small_stone_room", "ringoff_plr", "indoor" );
    declareambientroom( "large_stone_room" );
    setambientroomtone( "large_stone_room", "amb_wind_cave", 0.6, 1 );
    setambientroomreverb( "large_stone_room", "rv_zmbtemple_cave_tunnels", 1, 1 );
    setambientroomcontext( "large_stone_room", "ringoff_plr", "indoor" );
    declareambientroom( "waterfall_base" );
    setambientroomtone( "waterfall_base", "amb_wind_cave", 0.6, 1 );
    setambientroomreverb( "waterfall_base", "rv_zmbtemple_waterfall_base", 1, 1 );
    setambientroomcontext( "waterfall_base", "ringoff_plr", "indoor" );
    declareambientroom( "maze" );
    setambientroomtone( "maze", "amb_wind_outside", 0.6, 1 );
    setambientroomreverb( "maze", "rv_zmbtemple_small_stone_room", 1, 1 );
    setambientroomcontext( "maze", "ringoff_plr", "indoor" );
    declareambientroom( "cave_tunnels" );
    setambientroomtone( "cave_tunnels", "amb_wind_cave", 0.6, 1 );
    setambientroomreverb( "cave_tunnels", "rv_zmbtemple_cave_tunnels", 1, 1 );
    setambientroomcontext( "cave_tunnels", "ringoff_plr", "indoor" );
    activateambientroom( 0, "outside", 0 );
    declaremusicstate( "WAVE" );
    musicaliasloop( "mus_temple_underscore", 4, 2 );
    declaremusicstate( "EGG" );
    musicalias( "mus_egg", 1 );
    declaremusicstate( "SILENCE" );
    musicalias( "null", 1 );
    level thread sq_setup();
    level thread waitfor_revive_deactivate();
    level thread geyser_watch();
    level thread waitfor_meteor_shrink();
    level thread wait_for_game_end();
    level thread slow_trigger_enter();
    level thread slow_trigger_exit();
    level thread snd_start_autofx_audio();
}

waitfor_revive_deactivate()
{
    level waittill( "drb" );
    level notify( "deactivate_revive_bump" );
}

sq_setup()
{
    level.bg_ent = undefined;
    amb_structs = getstructarray( "sq_ambs", "targetname" );
    level thread waitfor_ec( amb_structs );
    level thread waitfor_return();
}

waitfor_ec( amb_structs )
{
    while ( true )
    {
        level waittill( "ec" );
        playsound( 0, "evt_sq_gen_transition", ( 0, 0, 0 ) );

        if ( !isdefined( level.bg_ent ) )
        {
            level.bg_ent = spawn( 0, ( 0, 0, 0 ), "script_origin" );
            level.bg_ent playloopsound( "evt_sq_gen_bg", 2 );
        }

        if ( isdefined( amb_structs ) )
            array_thread( amb_structs, ::play_sq_ambients );

        snd_set_snapshot( "zmb_temple_sq" );
    }
}

waitfor_return()
{
    first_time = 1;

    while ( true )
    {
        level waittill( "db" );

        if ( !first_time )
            playsound( 0, "evt_sq_gen_transition", ( 0, 0, 0 ) );

        first_time = 0;

        if ( isdefined( level.bg_ent ) )
        {
            level.bg_ent stoploopsound( 2 );
            wait 2;
            level.bg_ent delete();
        }

        snd_set_snapshot( "default" );
    }
}

play_sq_ambients()
{
    level endon( "db" );
    wait( randomfloatrange( 2, 28 ) );

    while ( true )
    {
        if ( randomintrange( 0, 101 ) <= 50 )
            playsound( 0, "evt_sq_gen_animals_clicky", self.origin );
        else
            playsound( 0, "evt_sq_gen_animals_whiny", self.origin );

        wait( randomintrange( 20, 55 ) );
    }
}

geyser_watch()
{
    level thread geyser_emitter( 0 );
    level thread geyser_emitter( 1 );
}

geyser_emitter( num )
{
    while ( true )
    {
        level waittill( "ge" + num );
        level notify( "evt_geyser_blast_" + num );
        wait 14.5;
        level notify( "evt_geyser_blast_" + num );
    }
}

waitfor_meteor_shrink()
{
    level waittill( "mts" );
    snd_set_snapshot( "zmb_temple_egg" );
    wait 5.5;

    if ( isdefined( level.bg_ent ) )
        snd_set_snapshot( "zmb_temple_sq" );
    else
        snd_set_snapshot( "default" );
}

wait_for_game_end()
{
    level waittill( "zesn" );
    snd_set_snapshot( "zmb_temple_egg" );
}

slow_trigger_enter()
{
    while ( true )
    {
        level waittill( "sle" );
        player = getlocalplayer( 0 );
        player.step_sound = "fly_step_run_plr_slowed";
    }
}

slow_trigger_exit()
{
    while ( true )
    {
        level waittill( "sll" );
        player = getlocalplayer( 0 );
        player.step_sound = "none";
    }
}

snd_start_autofx_audio()
{
    snd_play_auto_fx( "fx_ztem_torch", "amb_fire_medium" );
}