// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

magic_box_init()
{
    level thread _update_magic_box_indicators();
    level thread _watch_fire_sale();
}

_update_magic_box_indicators()
{
    while ( true )
    {
        flag_wait( "moving_chest_now" );

        while ( flag( "moving_chest_now" ) )
            wait 0.1;
    }
}

_watch_fire_sale()
{
    while ( true )
    {
        level waittill( "powerup fire sale" );
        level waittill( "fire_sale_off" );
    }
}

_get_current_chest()
{
    return level.chests[level.chest_index].script_noteworthy;
}