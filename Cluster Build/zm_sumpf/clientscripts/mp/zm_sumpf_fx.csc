// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\_fx;
#include clientscripts\_music;
#include clientscripts\mp\createfx\zm_sumpf_fx;
#include clientscripts\mp\_fx;

main()
{
    clientscripts\mp\createfx\zm_sumpf_fx::main();
    clientscripts\mp\_fx::reportnumeffects();
    precache_scripted_fx();
    precache_createfx_fx();
    level thread trap_fx_monitor( "north_west_tgt", "north_west_elec_light" );
    level thread trap_fx_monitor( "south_west_tgt", "south_west_elec_light" );
    level thread trap_fx_monitor( "north_east_tgt", "north_east_elec_light" );
    level thread trap_fx_monitor( "south_east_tgt", "south_east_elec_light" );
}

footsteps()
{

}

precache_scripted_fx()
{
    level._effect["eye_glow"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["zapper_fx"] = loadfx( "maps/zombie/fx_zombie_zapper_powerbox_on" );
    level._effect["zapper_wall"] = loadfx( "maps/zombie/fx_zombie_zapper_wall_control_on" );
    level._effect["elec_trail_one_shot"] = loadfx( "maps/zombie/fx_zombie_elec_trail_oneshot" );
    level._effect["zapper_light_ready"] = loadfx( "maps/zombie/fx_zm_swamp_light_glow_green" );
    level._effect["zapper_light_notready"] = loadfx( "maps/zombie/fx_zm_swamp_light_glow_red" );
    level._effect["wire_sparks_oneshot"] = loadfx( "electrical/fx_elec_wire_spark_dl_oneshot" );
    level._effect["headshot"] = loadfx( "impacts/fx_flesh_hit" );
    level._effect["headshot_nochunks"] = loadfx( "misc/fx_zombie_bloodsplat" );
    level._effect["bloodspurt"] = loadfx( "misc/fx_zombie_bloodspurt" );
    level._effect["animscript_gib_fx"] = loadfx( "weapon/bullet/fx_flesh_gib_fatal_01" );
    level._effect["animscript_gibtrail_fx"] = loadfx( "trail/fx_trail_blood_streak" );
}

precache_createfx_fx()
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
    level._effect["zapper"] = loadfx( "maps/zombie/fx_zombie_electric_trap" );
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["betty_explode"] = loadfx( "weapon/bouncing_betty/fx_explosion_betty_generic" );
    level._effect["betty_trail"] = loadfx( "weapon/bouncing_betty/fx_betty_trail" );
    level._effect["fx_light_god_ray_sm_sumpf_warm_v1"] = loadfx( "env/light/fx_light_god_ray_sm_sumpf_warm_v1" );
}

trap_fx_monitor( name, side )
{
    while ( true )
    {
        level waittill( name );
        fire_points = getstructarray( name, "targetname" );

        for ( i = 0; i < fire_points.size; i++ )
            fire_points[i] thread electric_trap_fx( name, side );
    }
}

electric_trap_fx( name, side )
{
    ang = self.angles;
    forward = anglestoforward( ang );
    up = anglestoup( ang );

    if ( isdefined( self.loopfx ) )
    {
        for ( i = 0; i < self.loopfx.size; i++ )
            self.loopfx[i] delete();

        self.loopfx = [];
    }

    if ( !isdefined( self.loopfx ) )
        self.loopfx = [];

    players = getlocalplayers();

    for ( i = 0; i < players.size; i++ )
    {
        self.loopfx[i] = spawnfx( i, level._effect["zapper"], self.origin, 0, forward, up );
        triggerfx( self.loopfx[i] );
    }

    level waittill( side + "off" );

    for ( i = 0; i < self.loopfx.size; i++ )
        self.loopfx[i] delete();

    self.loopfx = [];
}

zapper_switch_fx( ent )
{
    switchfx = getstruct( "zapper_switch_fx_" + ent, "targetname" );
    zapperfx = getstruct( "zapper_fx_" + ent, "targetname" );
    switch_forward = anglestoforward( switchfx.angles );
    switch_up = anglestoup( switchfx.angles );
    zapper_forward = anglestoforward( zapperfx.angles );
    zapper_up = anglestoup( zapperfx.angles );

    while ( true )
    {
        level waittill( ent );

        if ( isdefined( switchfx.loopfx ) )
        {
            for ( i = 0; i < switchfx.loopfx.size; i++ )
            {
                switchfx.loopfx[i] delete();
                zapperfx.loopfx[i] delete();
            }

            switchfx.loopfx = [];
            zapperfx.loopfx = [];
        }

        if ( !isdefined( switchfx.loopfx ) )
        {
            switchfx.loopfx = [];
            zapperfx.loopfx = [];
        }

        players = getlocalplayers();

        for ( i = 0; i < players.size; i++ )
        {
            switchfx.loopfx[i] = spawnfx( i, level._effect["zapper_wall"], switchfx.origin, 0, switch_forward, switch_up );
            triggerfx( switchfx.loopfx[i] );
            zapperfx.loopfx[i] = spawnfx( i, level._effect["zapper_fx"], zapperfx.origin, 0, zapper_forward, zapper_up );
            triggerfx( zapperfx.loopfx[i] );
        }

        wait 30;

        for ( i = 0; i < switchfx.loopfx.size; i++ )
        {
            switchfx.loopfx[i] delete();
            zapperfx.loopfx[i] delete();
        }

        switchfx.loopfx = [];
        zapperfx.loopfx = [];
    }
}