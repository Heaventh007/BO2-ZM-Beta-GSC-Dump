// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include maps\mp\createfx\zm_tomb_fx;

main()
{
    precache_createfx_fx();
    precache_scripted_fx();
    precache_fxanim_props();
    maps\mp\createfx\zm_tomb_fx::main();
}

precache_scripted_fx()
{
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["zapper_light_ready"] = loadfx( "maps/zombie_tomb/fx_tomb_capture_light_green" );
    level._effect["zapper_light_notready"] = loadfx( "maps/zombie_tomb/fx_tomb_capture_light_red" );
    level._effect["poltergeist"] = loadfx( "misc/fx_zombie_couch_effect" );
    level._effect["door_steam"] = loadfx( "maps/zombie_tomb/fx_tomb_dieselmagic_doors_steam" );
    level._effect["flame_trap_start"] = loadfx( "maps/zombie_tomb/fx_tomb_trap_fire_start" );
    level._effect["flame_trap_loop"] = loadfx( "maps/zombie_tomb/fx_tomb_trap_fire_os" );
    level._effect["fire_ai_torso"] = loadfx( "fire/fx_fire_ai_torso" );
    level._effect["fire_ai_leg_left"] = loadfx( "fire/fx_fire_ai_leg_left" );
    level._effect["fire_ai_leg_right"] = loadfx( "fire/fx_fire_ai_leg_right" );
    level._effect["fire_ai_arm_left"] = loadfx( "fire/fx_fire_ai_arm_left" );
    level._effect["fire_ai_arm_right"] = loadfx( "fire/fx_fire_ai_arm_right" );
    level._effect["zomb_gib"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_torso_explo" );
    level._effect["lava_burning"] = loadfx( "env/fire/fx_fire_lava_player_torso" );
    level._effect["spawn_cloud"] = loadfx( "maps/zombie/fx_zmb_race_zombie_spawn_cloud" );
    level._effect["robot_foot_stomp"] = loadfx( "maps/zombie_tomb/fx_tomb_robot_dust" );
    level._effect["zombie_blood"] = loadfx( "maps/zombie_tomb/fx_tomb_pwr_up_zmb_blood" );
    level._effect["air_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_elem_reveal_air_glow" );
    level._effect["elec_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_elem_reveal_elec_glow" );
    level._effect["fire_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_elem_reveal_fire_glow" );
    level._effect["ice_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_elem_reveal_ice_glow" );
    level._effect["crystal_insert"] = loadfx( "maps/zombie/fx_zmb_tranzit_marker_glow" );
    level._effect["air_reveal"] = loadfx( "maps/zombie_tomb/fx_tomb_elem_reveal_air_blimp" );
    level._effect["lightning_reveal"] = loadfx( "maps/zombie_tomb/fx_tomb_elem_reveal_elec_rod" );
    level._effect["digging"] = loadfx( "maps/zombie_tomb/fx_tomb_shovel_dig" );
    level._effect["fast_rise"] = loadfx( "maps/zombie_tomb/fx_tomb_riser_fast_dirt_dig" );
    level._effect["mechz_death"] = loadfx( "maps/zombie_tomb/fx_tomb_mech_death" );
    level._effect["mechz_sparks"] = loadfx( "maps/zombie_tomb/fx_tomb_mech_dmg_sparks" );
    level._effect["mechz_steam"] = loadfx( "maps/zombie_tomb/fx_tomb_mech_dmg_steam" );
    level._effect["mechz_claw"] = loadfx( "maps/zombie_tomb/fx_tomb_mech_wpn_claw" );
    level._effect["mechz_claw_arm"] = loadfx( "maps/zombie_tomb/fx_tomb_mech_wpn_source" );
    level._effect["staff_charge"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_charge" );
    level._effect["staff_soul"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_charge_souls" );
    level._effect["crypt_gem_beam"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_charge_souls" );
    level._effect["air_puzzle_smoke"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_air_smoke" );
    level._effect["elec_piano_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_elec_sparks" );
    level._effect["elec_switch_spark"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_elec_sparks" );
    level._effect["fire_ash_explosion"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_fire_exp_ash" );
    level._effect["fire_sacrifice_flame"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_fire_sacrifice" );
    level._effect["fire_torch"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_fire_torch" );
    level._effect["ice_drip"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_ice_water_drip" );
    level._effect["ice_explode"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_ice_pipe_burst" );
    level._effect["puzzle_orb_trail"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_plinth_trail" );
    level._effect["rise_burst_water"] = loadfx( "maps/zombie/fx_mp_zombie_hand_water_burst" );
    level._effect["rise_billow_water"] = loadfx( "maps/zombie/fx_mp_zombie_body_water_billowing" );
    level._effect["rise_dust_water"] = loadfx( "maps/zombie/fx_zombie_body_wtr_falling" );
    level._effect["teleport_1p"] = loadfx( "maps/zombie_tomb/fx_tomb_teleport_1p" );
    level._effect["teleport_3p"] = loadfx( "maps/zombie_tomb/fx_tomb_teleport_3p" );
    level._effect["lift"] = loadfx( "maps/zombie_tomb/fx_tomb_robot_head_elevator" );
    level._effect["auto_turret_light"] = loadfx( "maps/zombie/fx_zombie_auto_turret_light" );
    level._effect["tesla_elec_kill"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_afterlife_zmb_tport" );
    level._effect["capture_progression"] = loadfx( "maps/zombie_tomb/fx_tomb_capture_progression" );
    level._effect["capture_complete"] = loadfx( "maps/zombie_tomb/fx_tomb_capture_complete" );
    level._effect["screecher_hole"] = loadfx( "maps/zombie_tomb/fx_tomb_screecher_vortex" );
    level._effect["screecher_hole_os"] = loadfx( "maps/zombie_tomb/fx_tomb_screecher_vortex_os" );
    level._effect["player_rain"] = loadfx( "maps/zombie_tomb/fx_tomb_player_weather_rain" );
    level._effect["player_snow"] = loadfx( "maps/zombie_tomb/fx_tomb_player_weather_snow" );
    level._effect["lightning_flash"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_lightning_lg" );
    level._effect["mortar_launch"] = loadfx( "maps/zombie_tomb/fx_tomb_veh_tank_mortar_launch" );
    level._effect["fx_mortarexp_sand"] = loadfx( "maps/zombie_tomb/fx_tomb_veh_tank_mortar_exp" );
    level._effect["tank_treads"] = loadfx( "maps/zombie_tomb/fx_tomb_veh_tank_treadfx_mud" );
    level._effect["bottle_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_bottle_glow" );
}

precache_createfx_fx()
{
    level._effect["fx_death_cloud"] = loadfx( "maps/zombie_tomb/fx_tomb_death_cloud" );
    level._effect["fx_sky_flash_orange"] = loadfx( "maps/zombie_tomb/fx_tomb_sky_flash_orange" );
    level._effect["fx_sky_dist_aa_tracers"] = loadfx( "maps/zombie_tomb/fx_tomb_sky_dist_aa_tracers" );
    level._effect["fx_sky_dist_smk_plume"] = loadfx( "maps/zombie_tomb/fx_tomb_sky_dist_smk_plume" );
    level._effect["fx_sphere"] = loadfx( "weapon/zmb_staff/fx_sphere" );
    level._effect["fx_pack_a_punch"] = loadfx( "maps/zombie_tomb/fx_tomb_pack_a_punch_light_beams" );
    level._effect["fx_molten_ball"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_fire_trail_bolt_p" );
    level._effect["fx_puzzle"] = loadfx( "maps/zombie_tomb/fx_tomb_puzzle_fire_sacrifice" );
    level._effect["fx_tomb_dust_fall"] = loadfx( "maps/zombie_tomb/fx_tomb_dust_fall" );
    level._effect["fx_tomb_embers_flat"] = loadfx( "maps/zombie_tomb/fx_tomb_embers_flat" );
    level._effect["fx_tomb_fire_lg"] = loadfx( "maps/zombie_tomb/fx_tomb_fire_lg" );
    level._effect["fx_tomb_fire_sm"] = loadfx( "maps/zombie_tomb/fx_tomb_fire_sm" );
    level._effect["fx_tomb_ground_fog"] = loadfx( "maps/zombie_tomb/fx_tomb_ground_fog" );
    level._effect["fx_tomb_sparks"] = loadfx( "maps/zombie_tomb/fx_tomb_sparks" );
    level._effect["fx_tomb_water_drips"] = loadfx( "maps/zombie_tomb/fx_tomb_water_drips" );
    level._effect["fx_tomb_smoke_pillar_xlg"] = loadfx( "maps/zombie_tomb/fx_tomb_smoke_pillar_xlg" );
}

#using_animtree("fxanim_props");

precache_fxanim_props()
{
    level.scr_anim["fxanim_props"]["dogfights"] = %fxanim_zom_tomb_dogfights_anim;
}
