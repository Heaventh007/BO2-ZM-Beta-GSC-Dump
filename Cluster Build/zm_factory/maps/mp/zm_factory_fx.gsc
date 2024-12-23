// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\createfx\zm_factory_fx;

main()
{
    precache_scripted_fx();
    precache_createfx_fx();
    maps\mp\createfx\zm_factory_fx::main();
}

precache_scripted_fx()
{
    level._effect["large_ceiling_dust"] = loadfx( "env/zombie/fx_dust_ceiling_impact_lg_mdbrown" );
    level._effect["poltergeist"] = loadfx( "misc/fx_zombie_couch_effect" );
    level._effect["gasfire"] = loadfx( "destructibles/fx_dest_fire_vert" );
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["wire_sparks_oneshot"] = loadfx( "electrical/fx_elec_wire_spark_dl_oneshot" );
    level._effect["lght_marker"] = loadfx( "maps/zombie/fx_zombie_coast_marker" );
    level._effect["lght_marker_flare"] = loadfx( "maps/zombie/fx_zombie_coast_marker_fl" );
    level._effect["betty_explode"] = loadfx( "weapon/bouncing_betty/fx_explosion_betty_generic" );
    level._effect["betty_trail"] = loadfx( "weapon/bouncing_betty/fx_betty_trail" );
    level._effect["zapper_fx"] = loadfx( "maps/zombie/fx_zombie_zapper_powerbox_on" );
    level._effect["zapper"] = loadfx( "maps/zombie/fx_zombie_electric_trap" );
    level._effect["zapper_wall"] = loadfx( "maps/zombie/fx_zombie_zapper_wall_control_on" );
    level._effect["zapper_light_ready"] = loadfx( "maps/zombie/fx_zombie_light_glow_green" );
    level._effect["zapper_light_notready"] = loadfx( "maps/zombie/fx_zombie_light_glow_red" );
    level._effect["elec_room_on"] = loadfx( "fx_zombie_light_elec_room_on" );
    level._effect["elec_md"] = loadfx( "electrical/fx_elec_player_md" );
    level._effect["elec_sm"] = loadfx( "electrical/fx_elec_player_sm" );
    level._effect["elec_torso"] = loadfx( "electrical/fx_elec_player_torso" );
    level._effect["elec_trail_one_shot"] = loadfx( "maps/zombie/fx_zombie_elec_trail_oneshot" );
    level._effect["wire_spark"] = loadfx( "maps/zombie/fx_zombie_wire_spark" );
    level._effect["powerup_on"] = loadfx( "misc/fx_zombie_powerup_on" );
}

precache_createfx_fx()
{
    level._effect["mp_battlesmoke_lg"] = loadfx( "maps/zombie_old/fx_mp_battlesmoke_thin_lg" );
    level._effect["mp_ray_fire_thin"] = loadfx( "maps/zombie_old/fx_mp_ray_fire_thin" );
    level._effect["mp_fire_column_lg"] = loadfx( "maps/mp_maps/fx_mp_fire_column_lg" );
    level._effect["mp_fire_furnace"] = loadfx( "maps/zombie_old/fx_mp_fire_furnace" );
    level._effect["mp_ray_light_sm"] = loadfx( "maps/zombie_old/fx_mp_ray_moon_sm" );
    level._effect["mp_ray_light_md"] = loadfx( "maps/zombie_old/fx_mp_ray_moon_md" );
    level._effect["mp_ray_light_lg"] = loadfx( "maps/zombie_old/fx_mp_ray_moon_lg" );
    level._effect["mp_ray_light_lg_1sd"] = loadfx( "maps/zombie_old/fx_mp_ray_moon_lg_1sd" );
    level._effect["mp_smoke_fire_column"] = loadfx( "maps/zombie_old/fx_mp_smoke_fire_column" );
    level._effect["mp_smoke_plume_lg"] = loadfx( "maps/zombie_old/fx_mp_smoke_plume_lg" );
    level._effect["mp_smoke_hall"] = loadfx( "maps/zombie_old/fx_mp_smoke_hall" );
    level._effect["mp_ash_and_embers"] = loadfx( "maps/zombie_old/fx_mp_ash_falling_large" );
    level._effect["mp_light_glow_indoor_short"] = loadfx( "maps/zombie_old/fx_mp_light_glow_indoor_short_loop" );
    level._effect["mp_light_glow_outdoor_long"] = loadfx( "maps/zombie_old/fx_mp_light_glow_outdoor_long_loop" );
    level._effect["mp_insects_lantern"] = loadfx( "maps/zombie_old/fx_mp_insects_lantern" );
    level._effect["fx_mp_fire_torch_noglow"] = loadfx( "maps/zombie_old/fx_mp_fire_torch_noglow" );
    level._effect["a_embers_falling_sm"] = loadfx( "env/fire/fx_embers_falling_sm" );
    level._effect["transporter_beam"] = loadfx( "maps/zombie/fx_transporter_beam" );
    level._effect["transporter_pad_start"] = loadfx( "maps/zombie/fx_transporter_pad_start" );
    level._effect["transporter_start"] = loadfx( "maps/zombie/fx_transporter_start" );
    level._effect["transporter_ambient"] = loadfx( "maps/zombie/fx_transporter_ambient" );
    level._effect["zombie_mainframe_link_all"] = loadfx( "maps/zombie/fx_zombie_mainframe_link_all" );
    level._effect["zombie_mainframe_link_single"] = loadfx( "maps/zombie/fx_zombie_mainframe_link_single" );
    level._effect["zombie_mainframe_linked"] = loadfx( "maps/zombie/fx_zombie_mainframe_linked" );
    level._effect["zombie_mainframe_beam"] = loadfx( "maps/zombie/fx_zombie_mainframe_beam" );
    level._effect["zombie_mainframe_flat"] = loadfx( "maps/zombie/fx_zombie_mainframe_flat" );
    level._effect["zombie_mainframe_flat_start"] = loadfx( "maps/zombie/fx_zombie_mainframe_flat_start" );
    level._effect["zombie_mainframe_beam_start"] = loadfx( "maps/zombie/fx_zombie_mainframe_beam_start" );
    level._effect["zombie_flashback_american"] = loadfx( "maps/zombie/fx_zombie_flashback_american" );
    level._effect["gasfire2"] = loadfx( "destructibles/fx_dest_fire_vert" );
    level._effect["mp_light_lamp"] = loadfx( "maps/zombie_old/fx_mp_light_lamp" );
    level._effect["zombie_difference"] = loadfx( "maps/zombie/fx_zombie_difference" );
    level._effect["zombie_mainframe_steam"] = loadfx( "maps/zombie/fx_zombie_mainframe_steam" );
    level._effect["zombie_heat_sink"] = loadfx( "maps/zombie/fx_zombie_heat_sink" );
    level._effect["mp_smoke_stack"] = loadfx( "maps/zombie_old/fx_mp_smoke_stack" );
    level._effect["zombie_elec_gen_idle"] = loadfx( "maps/zombie/fx_zombie_elec_gen_idle" );
    level._effect["zombie_moon_eclipse"] = loadfx( "maps/zombie/fx_zombie_moon_eclipse" );
    level._effect["zombie_clock_hand"] = loadfx( "maps/zombie/fx_zombie_clock_hand" );
    level._effect["zombie_elec_pole_terminal"] = loadfx( "maps/zombie/fx_zombie_elec_pole_terminal" );
    level._effect["mp_elec_broken_light_1shot"] = loadfx( "maps/zombie_old/fx_mp_elec_broken_light_1shot" );
    level._effect["mp_light_lamp_no_eo"] = loadfx( "maps/zombie_old/fx_mp_light_lamp_no_eo" );
    level._effect["zombie_packapunch"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
    level._effect["fx_zm_factory_fire_detail"] = loadfx( "fire/fx_zm_factory_fire_detail" );
    level._effect["fx_zm_factory_fire_rubble_sm"] = loadfx( "fire/fx_zm_factory_fire_rubble_sm" );
    level._effect["fx_zm_factory_fire_barrel"] = loadfx( "fire/fx_zm_factory_fire_barrel" );
    level._effect["fx_zm_factory_fire_window"] = loadfx( "maps/zombie/fx_zm_factory_fire_window" );
    level._effect["fx_zm_factory_god_ray_md"] = loadfx( "maps/zombie/fx_zm_factory_god_ray_md" );
    level._effect["fx_zm_factory_god_ray_lg"] = loadfx( "maps/zombie/fx_zm_factory_god_ray_lg" );
    level._effect["fx_zm_factory_smoke_stack"] = loadfx( "maps/zombie/fx_zm_factory_smoke_stack" );
    level._effect["fx_zm_factory_steam_loop"] = loadfx( "maps/zombie/fx_zm_factory_steam_loop" );
    level._effect["electric_short_oneshot"] = loadfx( "env/electrical/fx_elec_short_oneshot" );
}
