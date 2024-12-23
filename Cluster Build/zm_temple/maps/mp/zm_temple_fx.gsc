// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\_utility;
#include common_scripts\utility;
#include maps\mp\createfx\zm_temple_fx;

main()
{
    precache_util_fx();
    precache_scripted_fx();
    precache_createfx_fx();
    precache_creek_fx();
    maps\mp\createfx\zm_temple_fx::main();
    level thread reset_water_burst_fx();
    set_wind();
}

precache_util_fx()
{
    level._effect["animscript_gib_fx"] = loadfx( "weapon/bullet/fx_flesh_gib_fatal_01" );
    level._effect["fx_trail_blood_streak"] = loadfx( "trail/fx_trail_blood_streak" );
    level._effect["lght_marker"] = loadfx( "maps/zombie_temple/fx_ztem_magicbox" );
    level._effect["lght_marker_flare"] = loadfx( "maps/zombie/fx_zombie_coast_marker_fl" );
    level._effect["poltergeist"] = loadfx( "misc/fx_zombie_couch_effect" );
    level._effect["large_ceiling_dust"] = loadfx( "maps/zombie/fx_dust_ceiling_impact_lg_mdbrown" );
}

precache_scripted_fx()
{
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["trap_light_ready"] = loadfx( "misc/fx_zombie_zapper_light_green" );
    level._effect["trap_light_notready"] = loadfx( "misc/fx_zombie_zapper_light_red" );
    level._effect["waterfall_trap"] = loadfx( "env/water/fx_water_pipe_gush_lg" );
    level._effect["geyser_ready"] = loadfx( "env/water/fx_water_temple_geyser_ready" );
    level._effect["geyser_active"] = loadfx( "env/water/fx_water_pipe_spill_lg" );
    level._effect["rise_burst_water"] = loadfx( "maps/zombie/fx_mp_zombie_hand_water_burst" );
    level._effect["rise_billow_water"] = loadfx( "maps/zombie/fx_mp_zombie_body_water_billowing" );
    level._effect["maze_wall_impact"] = loadfx( "maps/zombie_temple/fx_ztem_dust_impact_maze" );
    level._effect["fx_ztem_torch"] = loadfx( "maps/zombie_temple/fx_ztem_torch" );
    level._effect["fx_ztem_geyser_bloom"] = loadfx( "maps/zombie_temple/fx_ztem_geyser_bloom" );
    level._effect["fx_ztem_cart_stop"] = loadfx( "maps/zombie_temple/fx_ztem_cart_stop" );
    level._effect["fx_mp_dlc4_roof_spill"] = loadfx( "maps/mp_maps/fx_mp_dlc4_roof_spill" );
    level._effect["maze_wall_raise"] = loadfx( "maps/zombie_temple/fx_ztem_dust_maze_raise" );
    level._effect["punji_dust"] = loadfx( "maps/zombie_temple/fx_ztem_dust_punji" );
    level._effect["barrier_break"] = loadfx( "maps/zombie_temple/fx_ztem_dest_wood_barrier" );
    level._effect["square_door_open"] = loadfx( "maps/zombie_temple/fx_ztem_dust_door_square" );
    level._effect["rolling_door_open"] = loadfx( "maps/zombie_temple/fx_ztem_dust_door_round" );
    level._effect["player_water_splash"] = loadfx( "Bio/player/fx_player_water_splash" );
    level._effect["player_land_dust"] = loadfx( "Maps/zombie_temple/fx_ztem_dust_player_impact" );
    level._effect["napalm_zombie_footstep"] = loadfx( "maps/zombie_temple/fx_ztem_napalm_zombie_ground2" );
    level._effect["thundergun_knockdown_ground"] = loadfx( "maps/zombie/fx_mp_zombie_hand_water_burst" );
    level._effect["rag_doll_gib_mini"] = loadfx( "maps/zombie_temple/fx_ztem_zombie_mini_squish" );
    level._effect["corpse_gib"] = loadfx( "maps/zombie/fx_zombie_dog_explosion" );
}

reset_water_burst_fx()
{
    wait 2.0;
    level._effect["rise_burst_water"] = loadfx( "maps/zombie/fx_mp_zombie_hand_water_burst" );
    level._effect["rise_billow_water"] = loadfx( "maps/zombie/fx_mp_zombie_body_water_billowing" );
}

precache_createfx_fx()
{
    level._effect["fx_water_temple_geyser_ready"] = loadfx( "env/water/fx_water_temple_geyser_ready" );
    level._effect["fx_fire_md"] = loadfx( "env/fire/fx_fire_md" );
    level._effect["fx_fire_sm"] = loadfx( "env/fire/fx_fire_sm" );
    level._effect["fx_zombie_light_dust_motes_md"] = loadfx( "maps/zombie/fx_zombie_light_dust_motes_md" );
    level._effect["fx_mp_insects_lantern"] = loadfx( "maps/zombie/fx_mp_insects_lantern" );
    level._effect["fx_dust_crumble_int_md"] = loadfx( "env/dirt/fx_dust_crumble_int_md" );
    level._effect["fx_zmb_light_incandescent"] = loadfx( "maps/zombie/fx_zmb_light_incandescent" );
    level._effect["fx_ztem_drips"] = loadfx( "maps/zombie_temple/fx_ztem_drips" );
    level._effect["fx_ztem_waterfall_mist"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_mist" );
    level._effect["fx_ztem_waterfall_mist_trap"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_mist_trap" );
    level._effect["fx_ztem_leaves_falling"] = loadfx( "maps/zombie_temple/fx_ztem_leaves_falling" );
    level._effect["fx_ztem_leaves_falling_wide"] = loadfx( "maps/zombie_temple/fx_ztem_leaves_falling_wide" );
    level._effect["fx_ztem_dust_motes_blowing_lg"] = loadfx( "maps/zombie_temple/fx_ztem_dust_motes_blowing_lg" );
    level._effect["fx_ztem_butterflies"] = loadfx( "maps/zombie_temple/fx_ztem_butterflies" );
    level._effect["fx_ztem_tinhat_indoor"] = loadfx( "maps/zombie_temple/fx_ztem_tinhat_indoor" );
    level._effect["fx_ztem_godray_md"] = loadfx( "maps/zombie_temple/fx_ztem_godray_md" );
    level._effect["fx_ztem_fog_cave"] = loadfx( "maps/zombie_temple/fx_ztem_fog_cave" );
    level._effect["fx_ztem_fog_cave_lg"] = loadfx( "maps/zombie_temple/fx_ztem_fog_cave_lg" );
    level._effect["fx_ztem_fog_cave_drk"] = loadfx( "maps/zombie_temple/fx_ztem_fog_cave_drk" );
    level._effect["fx_ztem_fog_cave_drk2"] = loadfx( "maps/zombie_temple/fx_ztem_fog_cave_drk2" );
    level._effect["fx_ztem_spider"] = loadfx( "maps/zombie_temple/fx_ztem_spider" );
    level._effect["fx_ztem_birds"] = loadfx( "maps/zombie_temple/fx_ztem_birds" );
    level._effect["fx_ztem_fog_outdoor"] = loadfx( "maps/zombie_temple/fx_ztem_fog_outdoor" );
    level._effect["fx_ztem_fog_tunnels"] = loadfx( "maps/zombie_temple/fx_ztem_fog_tunnels" );
    level._effect["fx_ztem_fog_outdoor_lg"] = loadfx( "maps/zombie_temple/fx_ztem_fog_outdoor_lg" );
    level._effect["fx_ztem_power_on"] = loadfx( "maps/zombie_temple/fx_ztem_power_on" );
    level._effect["fx_ztem_power_onb"] = loadfx( "maps/zombie_temple/fx_ztem_power_onb" );
    level._effect["fx_ztem_dragonflies_lg"] = loadfx( "maps/zombie_temple/fx_ztem_dragonflies_lg" );
    level._effect["fx_slide_wake"] = loadfx( "bio/player/fx_player_water_swim_wake" );
    level._effect["fx_ztem_splash_3"] = loadfx( "maps/zombie_temple/fx_ztem_splash_3" );
    level._effect["fx_ztem_splash_4"] = loadfx( "maps/zombie_temple/fx_ztem_splash_4" );
    level._effect["fx_ztem_splash_exploder"] = loadfx( "maps/zombie_temple/fx_ztem_splash_exploder" );
    level._effect["fx_ztem_water_wake_exploder"] = loadfx( "maps/zombie_temple/fx_ztem_water_wake_exploder" );
    level._effect["fx_pow_cave_water_splash_sm"] = loadfx( "maps/pow/fx_pow_cave_water_splash_sm" );
    level._effect["fx_ztem_pap"] = loadfx( "maps/zombie_temple/fx_ztem_pap" );
    level._effect["fx_ztem_pap_splash"] = loadfx( "maps/zombie_temple/fx_ztem_pap_splash" );
    level._effect["fx_ztem_water_wake"] = loadfx( "maps/zombie_temple/fx_ztem_water_wake" );
    level._effect["fx_ztem_waterfall_body"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_body" );
    level._effect["fx_ztem_waterfall_body_b"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_body_b" );
    level._effect["fx_ztem_waterfall_trap"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_trap" );
    level._effect["fx_ztem_waterfall_notrap"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_notrap" );
    level._effect["fx_ztem_waterfall_trap_h"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_trap_h" );
    level._effect["fx_ztem_waterfall_drips"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_drips" );
    level._effect["fx_ztem_waterfall_low"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_low" );
    level._effect["fx_ztem_waterslide_splashes"] = loadfx( "maps/zombie_temple/fx_ztem_waterslide_splashes" );
    level._effect["fx_ztem_waterslide_splashes_wide"] = loadfx( "maps/zombie_temple/fx_ztem_waterslide_splashes_wide" );
    level._effect["fx_ztem_water_troff_power"] = loadfx( "maps/zombie_temple/fx_ztem_water_troff_power" );
    level._effect["fx_ztem_pap_stairs_splashes"] = loadfx( "maps/zombie_temple/fx_ztem_pap_stairs_splashes" );
    level._effect["fx_ztem_spikemore"] = loadfx( "maps/zombie_temple/fx_ztem_spikemore" );
    level._effect["fx_ztem_geyser"] = loadfx( "maps/zombie_temple/fx_ztem_geyser" );
    level._effect["fx_ztem_power_sparks"] = loadfx( "maps/zombie_temple/fx_ztem_power_sparks" );
    level._effect["fx_elec_wire_spark_burst_xsm"] = loadfx( "env/electrical/fx_elec_wire_spark_burst_xsm" );
    level._effect["fx_ztem_dust_impact_maze"] = loadfx( "maps/zombie_temple/fx_ztem_dust_impact_maze" );
    level._effect["fx_ztem_smk_ceiling_crawl"] = loadfx( "maps/zombie_temple/fx_ztem_smk_ceiling_crawl" );
    level._effect["fx_ztem_dust_crumble_int_md_runner"] = loadfx( "maps/zombie_temple/fx_ztem_dust_crumble_int_md_runner" );
    level._effect["fx_ztem_ember_xsm"] = loadfx( "maps/zombie_temple/fx_ztem_ember_xsm" );
    level._effect["fx_ztem_dust_door_round"] = loadfx( "maps/zombie_temple/fx_ztem_dust_door_round" );
    level._effect["fx_ztem_fountain_splash"] = loadfx( "maps/zombie_temple/fx_ztem_fountain_splash" );
    level._effect["fx_ztem_waterfall_distort"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_distort" );
    level._effect["fx_ztem_waterfall_bottom"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_bottom" );
    level._effect["fx_ztem_waterfall_b_bottom"] = loadfx( "maps/zombie_temple/fx_ztem_waterfall_b_bottom" );
    level._effect["fx_ztem_cave_wtr_sld_bttm"] = loadfx( "maps/zombie_temple/fx_ztem_cave_wtr_sld_bttm" );
    level._effect["fx_ztem_pap_warning"] = loadfx( "maps/zombie_temple/fx_ztem_pap_warning" );
    level._effect["fx_ztem_dest_wood_barrier"] = loadfx( "maps/zombie_temple/fx_ztem_dest_wood_barrier" );
    level._effect["fx_ztem_fireflies"] = loadfx( "maps/zombie_temple/fx_ztem_fireflies" );
    level._effect["fx_ztem_tunnel_water_gush"] = loadfx( "maps/zombie_temple/fx_ztem_tunnel_water_gush" );
    level._effect["fx_ztem_tunnel_water_splash"] = loadfx( "maps/zombie_temple/fx_ztem_tunnel_water_splash" );
    level._effect["fx_ztem_leak_gas_jet"] = loadfx( "maps/zombie_temple/fx_ztem_leak_gas_jet" );
    level._effect["fx_ztem_leak_flame_jet_runner"] = loadfx( "maps/zombie_temple/fx_ztem_leak_flame_jet_runner" );
    level._effect["fx_ztem_leak_water_jet_runner"] = loadfx( "maps/zombie_temple/fx_ztem_leak_water_jet_runner" );
    level._effect["fx_ztem_moon_eclipse"] = loadfx( "maps/zombie_temple/fx_ztem_moon_eclipse" );
    level._effect["fx_ztem_star_shooting_runner"] = loadfx( "maps/zombie_temple/fx_ztem_star_shooting_runner" );
    level._effect["fx_ztem_crystal_hit_success"] = loadfx( "maps/zombie_temple/fx_ztem_crystal_hit_success" );
    level._effect["fx_ztem_crystal_hit_fail"] = loadfx( "maps/zombie_temple/fx_ztem_crystal_hit_fail" );
    level._effect["fx_ztem_crystal_pause_success"] = loadfx( "maps/zombie_temple/fx_ztem_crystal_pause_success" );
    level._effect["fx_ztem_crystal_pause_fail"] = loadfx( "maps/zombie_temple/fx_ztem_crystal_pause_fail" );
    level._effect["fx_hot_sauce_trail"] = loadfx( "maps/zombie_temple/fx_ztem_hot_sauce_trail" );
    level._effect["fx_weak_sauce_trail"] = loadfx( "maps/zombie_temple/fx_ztem_weak_sauce_trail" );
    level._effect["fx_ztem_meteor_shrink"] = loadfx( "maps/zombie_temple/fx_ztem_meteor_shrink" );
    level._effect["fx_ztem_hot_sauce_end"] = loadfx( "maps/zombie_temple/fx_ztem_hot_sauce_end" );
    level._effect["fx_ztem_weak_sauce_end"] = loadfx( "maps/zombie_temple/fx_ztem_weak_sauce_end" );
    level._effect["fx_ztem_meteorite_trail_big"] = loadfx( "maps/zombie_temple/fx_ztem_meteorite_trail_big" );
    level._effect["fx_ztem_meteorite_tell"] = loadfx( "maps/zombie_temple/fx_ztem_meteorite_tell" );
    level._effect["fx_ztem_meteorite_shimmer"] = loadfx( "maps/zombie_temple/fx_ztem_meteorite_shimmer" );
    level._effect["fx_ztem_meteorite_small_shimmer"] = loadfx( "maps/zombie_temple/fx_ztem_meteorite_small_shimmer" );
    level._effect["fx_ztem_meteorite_big_shimmer"] = loadfx( "maps/zombie_temple/fx_ztem_meteorite_big_shimmer" );
    level._effect["fx_crystal_water_trail"] = loadfx( "maps/zombie_temple/fx_ztem_meteorite_splash_run" );
    level._effect["rise_dust_water"] = loadfx( "maps/zombie/fx_zombie_body_wtr_falling" );
}

precache_creek_fx()
{
    level._effect["fx_insect_swarm_lg"] = loadfx( "maps/creek/fx_insect_swarm_lg" );
    level._effect["fx_insect_swarm"] = loadfx( "maps/creek/fx_insect_swarm" );
    level._effect["fx_ztem_smoke_thick_indoor"] = loadfx( "maps/zombie_temple/fx_ztem_smoke_thick_indoor" );
}

set_wind()
{

}

precache_fx_prop_anims()
{

}
