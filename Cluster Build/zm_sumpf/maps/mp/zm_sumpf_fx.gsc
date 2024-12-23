// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\createfx\zm_sumpf_fx;
#include maps\mp\animscripts\utility;

main()
{
    footsteps();
    scriptedfx();
    precachefx();
    maps\mp\createfx\zm_sumpf_fx::main();
}

footsteps()
{
    maps\mp\animscripts\utility::setfootstepeffect( "asphalt", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "brick", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "carpet", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "cloth", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "concrete", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "dirt", loadfx( "bio/player/fx_footstep_sand" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "foliage", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "gravel", loadfx( "bio/player/fx_footstep_sand" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "grass", loadfx( "bio/player/fx_footstep_sand" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "metal", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "mud", loadfx( "bio/player/fx_footstep_mud" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "paper", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "plaster", loadfx( "bio/player/fx_footstep_dust" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "rock", loadfx( "bio/player/fx_footstep_sand" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "sand", loadfx( "bio/player/fx_footstep_sand" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "water", loadfx( "bio/player/fx_footstep_water" ) );
    maps\mp\animscripts\utility::setfootstepeffect( "wood", loadfx( "bio/player/fx_footstep_dust" ) );
}

scriptedfx()
{
    level._effect["hanging_light_fx"] = loadfx( "env/light/fx_zmb_shino_glow_lantern" );
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["large_ceiling_dust"] = loadfx( "maps/zombie/fx_dust_ceiling_impact_lg_mdbrown" );
    level._effect["poltergeist"] = loadfx( "maps/zombie/fx_zombie_debris_removal" );
    level._effect["lght_marker_old"] = loadfx( "maps/zombie/fx_zombie_lght_marker" );
    level._effect["lght_marker"] = loadfx( "maps/zombie/fx_zombie_lght_marker_hut1" );
    level._effect["lght_marker_flare"] = loadfx( "maps/zombie/fx_zmb_tranzit_marker_glow" );
    level._effect["betty_explode"] = loadfx( "weapon/bouncing_betty/fx_explosion_betty_generic" );
    level._effect["betty_trail"] = loadfx( "weapon/bouncing_betty/fx_betty_trail" );
    level._effect["trap_fire"] = loadfx( "maps/zombie/fx_zombie_fire_trp" );
    level._effect["trap_log"] = loadfx( "maps/zombie/fx_zombie_log_trp" );
    level._effect["trap_blade"] = loadfx( "maps/zombie/fx_zombie_chopper_trp" );
    level._effect["dog_entrance_start"] = loadfx( "maps/zombie/fx_zombie_dog_gate_start" );
    level._effect["dog_entrance_looping"] = loadfx( "maps/zombie/fx_zombie_dog_gate_looping" );
    level._effect["dog_entrance_ending"] = loadfx( "maps/zombie/fx_zombie_dog_gate_end" );
    level._effect["stub"] = loadfx( "misc/fx_zombie_perk_lottery" );
    level._effect["zombie_perk_start"] = loadfx( "misc/fx_zombie_perk_lottery_start" );
    level._effect["zombie_perk_flash"] = loadfx( "misc/fx_zombie_perk_lottery_flash" );
    level._effect["zombie_perk_end"] = loadfx( "misc/fx_zombie_perk_lottery_end" );
    level._effect["zombie_perk_4th"] = loadfx( "misc/fx_zombie_perk_lottery_4" );
    level._effect["chopper_blur"] = loadfx( "maps/zombie/fx_zombie_chopper_trp_blur" );
}

wind_settings()
{

}

precachefx()
{
    level._effect["mp_fire_medium"] = loadfx( "fire/fx_fire_fuel_sm" );
    level._effect["mp_fire_large"] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_lrg" );
    level._effect["mp_smoke_ambiance_indoor"] = loadfx( "maps/mp_maps/fx_mp_smoke_ambiance_indoor" );
    level._effect["mp_smoke_ambiance_indoor_misty"] = loadfx( "maps/mp_maps/fx_mp_smoke_ambiance_indoor_misty" );
    level._effect["mp_smoke_ambiance_indoor_sm"] = loadfx( "maps/mp_maps/fx_mp_smoke_ambiance_indoor_sm" );
    level._effect["fx_fog_low_floor_sm"] = loadfx( "env/smoke/fx_fog_low_floor_sm" );
    level._effect["mp_smoke_column_tall"] = loadfx( "maps/mp_maps/fx_mp_smoke_column_tall" );
    level._effect["mp_smoke_column_short"] = loadfx( "maps/mp_maps/fx_mp_smoke_column_short" );
    level._effect["mp_fog_rolling_large"] = loadfx( "maps/mp_maps/fx_mp_fog_rolling_thick_large_area" );
    level._effect["mp_fog_rolling_small"] = loadfx( "maps/mp_maps/fx_mp_fog_rolling_thick_small_area" );
    level._effect["mp_flies_carcass"] = loadfx( "maps/mp_maps/fx_mp_flies_carcass" );
    level._effect["mp_insects_swarm"] = loadfx( "maps/mp_maps/fx_mp_insect_swarm" );
    level._effect["mp_insects_lantern"] = loadfx( "maps/zombie_old/fx_mp_insects_lantern" );
    level._effect["mp_firefly_ambient"] = loadfx( "maps/mp_maps/fx_mp_firefly_ambient" );
    level._effect["mp_firefly_swarm"] = loadfx( "maps/mp_maps/fx_mp_firefly_swarm" );
    level._effect["mp_maggots"] = loadfx( "maps/mp_maps/fx_mp_maggots" );
    level._effect["mp_falling_leaves_elm"] = loadfx( "maps/mp_maps/fx_mp_falling_leaves_elm" );
    level._effect["god_rays_dust_motes"] = loadfx( "env/light/fx_light_god_rays_dust_motes" );
    level._effect["light_ceiling_dspot"] = loadfx( "env/light/fx_ray_ceiling_amber_dim_sm" );
    level._effect["fx_bats_circling"] = loadfx( "bio/animals/fx_bats_circling" );
    level._effect["fx_bats_ambient"] = loadfx( "maps/mp_maps/fx_bats_ambient" );
    level._effect["mp_dragonflies"] = loadfx( "bio/insects/fx_insects_dragonflies_ambient" );
    level._effect["fx_mp_ray_moon_xsm_near"] = loadfx( "maps/mp_maps/fx_mp_ray_moon_xsm_near" );
    level._effect["fx_meteor_ambient"] = loadfx( "maps/zombie/fx_meteor_ambient" );
    level._effect["fx_meteor_flash"] = loadfx( "maps/zombie/fx_meteor_flash" );
    level._effect["fx_meteor_flash_spawn"] = loadfx( "maps/zombie/fx_meteor_flash_spawn" );
    level._effect["fx_meteor_hotspot"] = loadfx( "maps/zombie/fx_meteor_hotspot" );
    level._effect["fx_zm_swamp_fire_torch"] = loadfx( "fire/fx_zm_swamp_fire_torch" );
    level._effect["fx_zm_swamp_fire_detail"] = loadfx( "fire/fx_zm_swamp_fire_detail" );
    level._effect["fx_zm_swamp_glow_lantern"] = loadfx( "maps/zombie/fx_zm_swamp_glow_lantern" );
    level._effect["fx_zm_swamp_glow_lantern_sm"] = loadfx( "maps/zombie/fx_zm_swamp_glow_lantern_sm" );
    level._effect["fx_zm_swamp_glow_int_tinhat\\t"] = loadfx( "maps/zombie/fx_zm_swamp_glow_int_tinhat" );
    level._effect["fx_zm_swamp_glow_beacon\\t"] = loadfx( "maps/zombie/fx_zm_swamp_glow_beacon" );
    level._effect["zapper_fx"] = loadfx( "maps/zombie/fx_zombie_zapper_powerbox_on" );
    level._effect["zapper"] = loadfx( "maps/zombie/fx_zombie_electric_trap" );
    level._effect["zapper_wall"] = loadfx( "maps/zombie/fx_zombie_zapper_wall_control_on" );
    level._effect["zapper_light_ready"] = loadfx( "maps/zombie/fx_zm_swamp_light_glow_green" );
    level._effect["zapper_light_notready"] = loadfx( "maps/zombie/fx_zm_swamp_light_glow_red" );
    level._effect["elec_room_on"] = loadfx( "fx_zombie_light_elec_room_on" );
    level._effect["elec_md"] = loadfx( "electrical/fx_elec_player_md" );
    level._effect["elec_sm"] = loadfx( "electrical/fx_elec_player_sm" );
    level._effect["elec_torso"] = loadfx( "electrical/fx_elec_player_torso" );
    level._effect["wire_sparks_oneshot"] = loadfx( "electrical/fx_elec_wire_spark_dl_oneshot" );
    level._effect["elec_trail_one_shot"] = loadfx( "maps/zombie/fx_zombie_elec_trail_oneshot" );
    level._effect["rise_burst_water_swmp"] = loadfx( "maps/zombie/fx_zombie_body_wtr_burst_smpf" );
    level._effect["rise_billow_water_swmp"] = loadfx( "maps/zombie/fx_zombie_body_wtr_billow_smpf" );
    level._effect["fx_light_god_ray_sm_sumpf_warm_v1"] = loadfx( "env/light/fx_light_god_ray_sm_sumpf_warm_v1" );
}

post_lights()
{
    lanterns = getentarray( "post_lamp", "targetname" );
    array_thread( lanterns, ::swing_lanterns );
}

swing_lanterns()
{
    org_angles = self.angles;
    org_pos = self.origin;

    while ( true )
    {
        self rotateto( self.angles + ( randomintrange( -5, 5 ), randomintrange( -5, 5 ), 0 ), randomfloatrange( 0.5, 1 ) );
        self waittill( "rotatedone" );
        self rotateto( org_angles, randomfloatrange( 0.5, 1 ) );
        self waittill( "rotatedone" );
    }
}
