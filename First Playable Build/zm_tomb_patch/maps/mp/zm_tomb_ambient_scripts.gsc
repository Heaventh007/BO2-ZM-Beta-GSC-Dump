// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\zm_death;

tomb_ambient_precache()
{
    precachemodel( "veh_t6_dlc_zm_zeppelin" );
}

init_tomb_ambient_scripts()
{
    tomb_ambient_precache();
    level thread ambient_zeppelins( "a_zeppelin_start_pos", "stop_ambient_zeppelins" );
}

ambient_zeppelins( str_a_start_structs, str_ender )
{
    level endon( str_ender );

    while ( true )
    {
        if ( getentarray( "ambient_2d_zeppelin", "targetname" ).size <= 3 )
        {
            level thread ambient_aircraft_path( str_a_start_structs );
            wait( randomintrange( 10, 15 ) );
        }
        else
            wait( randomintrange( 10, 15 ) );
    }
}

ambient_aircraft_path( str_a_start_structs )
{
    a_struct_array = getstructarray( str_a_start_structs, "targetname" );
    s_start_point = random( a_struct_array );

    if ( isdefined( s_start_point.b_path_in_use ) && is_true( s_start_point.b_path_in_use ) )
        return;

    m_ambient_model = spawn( "script_model", s_start_point.origin );
    m_ambient_model.angles = s_start_point.angles;
    s_start_point.b_path_in_use = 1;

    if ( str_a_start_structs == "a_zeppelin_start_pos" )
    {
        m_ambient_model setmodel( "veh_t6_dlc_zm_zeppelin" );
        n_model_speed = randomfloatrange( 90.0, 110.0 );
        m_ambient_model.targetname = "ambient_2d_zeppelin";
    }

    s_end_spot = getstruct( s_start_point.target, "targetname" );
    m_ambient_model moveto( s_end_spot.origin, n_model_speed );
    m_ambient_model waittill( "movedone" );
    s_start_point.b_path_in_use = 0;
    m_ambient_model delete();
}