// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;

init( str_zombie_model )
{
    level.str_zombie_blood_model = str_zombie_model;
    precachemodel( level.str_zombie_blood_model );
    add_zombie_powerup( "zombie_blood", "p_glo_intravenous_dripbag", &"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_always_drop, 1, 0, 0, undefined, "powerup_zombie_blood", "zombie_powerup_zombie_blood_time", "zombie_powerup_zombie_blood_on" );
    onplayerconnect_callback( ::init_player_zombie_blood_vars );

    if ( !isdefined( level.vsmgr_prio_visionset_zm_powerup_zombie_blood ) )
        level.vsmgr_prio_visionset_zm_powerup_zombie_blood = 15;

    if ( !isdefined( level.vsmgr_prio_overlay_zm_powerup_zombie_blood ) )
        level.vsmgr_prio_overlay_zm_powerup_zombie_blood = 16;

    maps\mp\_visionset_mgr::vsmgr_register_info( "visionset", "zm_powerup_zombie_blood_visionset", 14000, level.vsmgr_prio_visionset_zm_powerup_zombie_blood, 1, 1 );
    maps\mp\_visionset_mgr::vsmgr_register_info( "overlay", "zm_powerup_zombie_blood_overlay", 14000, level.vsmgr_prio_overlay_zm_powerup_zombie_blood, 1, 1 );
}

init_player_zombie_blood_vars()
{
    self.zombie_vars["zombie_powerup_zombie_blood_on"] = 0;
    self.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
}

zombie_blood_powerup( m_powerup, e_player )
{
    e_player notify( "zombie_blood" );
    e_player endon( "zombie_blood" );
    e_player.ignoreme = 1;
    e_player._show_solo_hud = 1;
    e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
    e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 1;
    maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_powerup_zombie_blood_visionset", e_player );
    maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_powerup_zombie_blood_overlay", e_player );

    if ( !isdefined( e_player.m_fx ) )
    {
        v_origin = e_player gettagorigin( "J_Eyeball_LE" );
        v_angles = e_player gettagangles( "J_Eyeball_LE" );
        m_fx = spawn( "script_model", v_origin );
        m_fx setmodel( "tag_origin" );
        m_fx.angles = v_angles;
        m_fx linkto( e_player, "J_Eyeball_LE", ( 0, 0, 0 ), ( 0, 0, 0 ) );
        playfxontag( level._effect["zombie_blood"], m_fx, "tag_origin" );
        e_player.m_fx = m_fx;

        if ( isdefined( level.str_zombie_blood_model ) )
        {
            e_player.hero_model = e_player.model;
            e_player setmodel( level.str_zombie_blood_model );
        }
    }

    while ( e_player.zombie_vars["zombie_powerup_zombie_blood_time"] >= 0 )
    {
        wait 0.05;
        e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = e_player.zombie_vars["zombie_powerup_zombie_blood_time"] - 0.05;
    }

    e_player.m_fx delete();
    maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_powerup_zombie_blood_visionset", e_player );
    maps\mp\_visionset_mgr::vsmgr_deactivate( "overlay", "zm_powerup_zombie_blood_overlay", e_player );
    e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 0;
    e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
    e_player._show_solo_hud = 0;
    e_player.ignoreme = 0;

    if ( isdefined( e_player.hero_model ) )
    {
        e_player setmodel( e_player.hero_model );
        e_player.hero_model = undefined;
    }
}