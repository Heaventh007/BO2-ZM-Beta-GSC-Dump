// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\_music;
#include clientscripts\mp\createfx\zm_pentagon_fx;
#include clientscripts\mp\zombies\_zm;

main()
{
    clientscripts\mp\createfx\zm_pentagon_fx::main();
    clientscripts\mp\_fx::reportnumeffects();
    precache_util_fx();
    precache_createfx_fx();
    disablefx = getdvarint( #"_id_C9B177D6" );

    if ( !isdefined( disablefx ) || disablefx <= 0 )
        precache_scripted_fx();

    level thread clientscripts\mp\zombies\_zm::init_perk_machines_fx();
    level thread trap_fx_monitor( "trap_quickrevive", "nhe", "electric" );
    level thread trap_fx_monitor( "trap_elevator", "she", "electric" );
    level thread light_model_swap( "smodel_light_electric", "lights_indlight_on" );
}

precache_util_fx()
{

}

precache_scripted_fx()
{
    level._effect["eye_glow"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["headshot"] = loadfx( "impacts/fx_flesh_hit" );
    level._effect["headshot_nochunks"] = loadfx( "misc/fx_zombie_bloodsplat" );
    level._effect["bloodspurt"] = loadfx( "misc/fx_zombie_bloodspurt" );
    level._effect["animscript_gib_fx"] = loadfx( "weapon/bullet/fx_flesh_gib_fatal_01" );
    level._effect["animscript_gibtrail_fx"] = loadfx( "trail/fx_trail_blood_streak" );
    level._effect["no_power"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["fire_sale"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["level1_chest"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["level1_chest2"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["level2_chest"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["start_chest"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["start_chest2"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["start_chest3"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["test_spin_fx"] = loadfx( "env/light/fx_light_warning" );
}

precache_createfx_fx()
{
    level._effect["zapper"] = loadfx( "misc/fx_zombie_electric_trap" );
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["fire_trap_med"] = loadfx( "maps/zombie/fx_zombie_fire_trap_med" );
    level._effect["zombie_pentagon_teleporter"] = loadfx( "maps/zombie/fx_zombie_portal_nix_num" );
    level._effect["zombie_pent_portal_pack"] = loadfx( "maps/zombie/fx_zombie_portal_nix_num_pp" );
    level._effect["zombie_pent_portal_cool"] = loadfx( "maps/zombie/fx_zombie_portal_nix_num_pp_fd" );
    level._effect["transporter_beam"] = loadfx( "maps/zombie/fx_transporter_beam" );
    level._effect["transporter_start"] = loadfx( "maps/zombie/fx_transporter_start" );
    level._effect["fx_zombie_portal_corona_lg"] = loadfx( "maps/zombie/fx_zombie_portal_corona_lg" );
    level._effect["fx_zombie_portal_corona_sm"] = loadfx( "maps/zombie/fx_zombie_portal_corona_sm" );
    level._effect["fx_pent_cigar_smoke"] = loadfx( "maps/zombie/fx_zombie_cigar_tip_smoke" );
    level._effect["fx_pent_cigarette_tip_smoke"] = loadfx( "maps/zombie/fx_zombie_cigarette_tip_smoke" );
    level._effect["fx_glo_studio_light"] = loadfx( "maps/pentagon/fx_glo_studio_light" );
    level._effect["fx_pent_tinhat_light"] = loadfx( "maps/pentagon/fx_pent_tinhat_light" );
    level._effect["fx_pent_lamp_desk_light"] = loadfx( "maps/pentagon/fx_pent_lamp_desk_light" );
    level._effect["fx_pent_security_camera"] = loadfx( "maps/pentagon/fx_pent_security_camera" );
    level._effect["fx_pent_globe_projector"] = loadfx( "maps/zombie/fx_zombie_globe_projector" );
    level._effect["fx_pent_globe_projector_blue"] = loadfx( "maps/zombie/fx_zombie_globe_projector_blue" );
    level._effect["fx_pent_movie_projector"] = loadfx( "maps/pentagon/fx_pent_movie_projector" );
    level._effect["fx_pent_tv_glow"] = loadfx( "maps/zombie/fx_zombie_tv_glow" );
    level._effect["fx_pent_tv_glow_sm"] = loadfx( "maps/zombie/fx_zombie_tv_glow_sm" );
    level._effect["fx_pent_smk_ambient_room"] = loadfx( "maps/pentagon/fx_pent_smk_ambient_room" );
    level._effect["fx_pent_smk_ambient_room_lg"] = loadfx( "maps/zombie/fx_zombie_pent_smk_ambient_room_lg" );
    level._effect["fx_pent_smk_ambient_room_sm"] = loadfx( "maps/pentagon/fx_pent_smk_ambient_room_sm" );
    level._effect["fx_light_overhead_int_amber"] = loadfx( "maps/zombie/fx_zombie_light_overhead_amber" );
    level._effect["fx_light_overhead_int_amber_short"] = loadfx( "maps/zombie/fx_zombie_light_overhead_amber_short" );
    level._effect["fx_light_overhead_cool"] = loadfx( "maps/zombie/fx_zombie_light_overhead_cool" );
    level._effect["fx_light_floodlight_bright"] = loadfx( "maps/zombie/fx_zombie_light_floodlight_bright" );
    level._effect["fx_quad_vent_break"] = loadfx( "maps/zombie/fx_zombie_crawler_vent_break" );
    level._effect["fx_smk_linger_lit"] = loadfx( "maps/mp_maps/fx_mp_smk_linger" );
    level._effect["fx_water_drip_light_long"] = loadfx( "env/water/fx_water_drip_light_long" );
    level._effect["fx_water_drip_light_short"] = loadfx( "env/water/fx_water_drip_light_short" );
    level._effect["fx_mp_blood_drip_short"] = loadfx( "maps/mp_maps/fx_mp_blood_drip_short" );
    level._effect["fx_pipe_steam_md"] = loadfx( "env/smoke/fx_pipe_steam_md" );
    level._effect["fx_mp_fumes_vent_sm_int"] = loadfx( "maps/mp_maps/fx_mp_fumes_vent_sm_int" );
    level._effect["fx_mp_fumes_vent_xsm_int"] = loadfx( "maps/mp_maps/fx_mp_fumes_vent_xsm_int" );
    level._effect["fx_zombie_light_glow_telephone"] = loadfx( "maps/zombie/fx_zombie_light_glow_telephone" );
    level._effect["fx_light_pent_ceiling_light"] = loadfx( "env/light/fx_light_pent_ceiling_light" );
    level._effect["fx_light_pent_ceiling_light_flkr"] = loadfx( "env/light/fx_light_pent_ceiling_light_flkr" );
    level._effect["fx_light_office_light_03"] = loadfx( "env/light/fx_light_office_light_03" );
    level._effect["fx_mp_light_dust_motes_md"] = loadfx( "maps/zombie/fx_zombie_light_dust_motes_md" );
    level._effect["fx_insects_swarm_md_light"] = loadfx( "bio/insects/fx_insects_swarm_md_light" );
    level._effect["fx_insects_maggots"] = loadfx( "bio/insects/fx_insects_maggots_sm" );
    level._effect["fx_mp_elec_spark_burst_xsm_thin_runner"] = loadfx( "maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin_runner" );
    level._effect["fx_mp_elec_spark_burst_sm_runner"] = loadfx( "maps/mp_maps/fx_mp_elec_spark_burst_sm_runner" );
    level._effect["fx_interrog_morgue_mist"] = loadfx( "maps/zombie/fx_zombie_morgue_mist" );
    level._effect["fx_interrog_morgue_mist_falling"] = loadfx( "maps/zombie/fx_zombie_morgue_mist_falling" );
}

trap_fx_monitor( name, loc, trap_type )
{
    structs = getstructarray( name, "targetname" );
    points = [];

    for ( i = 0; i < structs.size; i++ )
    {
        if ( !isdefined( structs[i].model ) )
            points[points.size] = structs[i];
    }

    while ( true )
    {
        level waittill( loc + "1" );

        for ( i = 0; i < points.size; i++ )
            points[i] thread trap_play_fx( loc, trap_type );
    }
}

trap_play_fx( loc, trap_type )
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

    fx_name = "";

    if ( isdefined( self.script_string ) )
        fx_name = self.script_string;
    else
    {
        switch ( trap_type )
        {
            case "electric":
                fx_name = "zapper";
                break;
            case "fire":
            default:
                fx_name = "fire_trap_med";
                break;
        }
    }

    players = getlocalplayers();

    for ( i = 0; i < players.size; i++ )
    {
        self.loopfx[i] = spawnfx( i, level._effect[fx_name], self.origin, 0, forward, up );
        triggerfx( self.loopfx[i] );
    }

    level waittill( loc + "0" );

    for ( i = 0; i < self.loopfx.size; i++ )
        self.loopfx[i] delete();

    self.loopfx = [];
}

light_model_swap( name, model )
{
    level waittill( "pl1" );
    players = getlocalplayers();

    for ( p = 0; p < players.size; p++ )
    {
        lamps = getentarray( p, name, "targetname" );

        for ( i = 0; i < lamps.size; i++ )
            lamps[i] setmodel( model );
    }
}