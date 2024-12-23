// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_utility_raven;
#include maps\mp\zombies\_zm_zone_manager;
#include maps\mp\zm_temple_elevators;
#include maps\mp\zm_temple_traps;
#include maps\mp\zm_temple_power;
#include maps\mp\zm_temple_spawning;
#include maps\mp\zm_temple_pack_a_punch;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_temple_fx;
#include maps\mp\createart\zm_temple_art;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_load;
#include maps\mp\zm_temple_waterslide;
#include maps\mp\_sticky_grenade;
#include maps\mp\zm_temple_magic_box;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_temple_minecart;
#include maps\mp\zm_temple_triggers;
#include maps\mp\zm_temple_sq;
#include character\c_usa_dempsey_zm;
#include character\c_rus_nikolai_zm;
#include character\c_jap_takeo_zm;
#include character\c_ger_richtofen_zm;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\zombies\_zm_net;
#include mptype\player_t5_zm_theater;
#include character\c_usa_dempsey_zt;
#include character\c_rus_nikolai_zt;
#include character\c_jap_takeo_zt;
#include character\c_ger_richtofen_zt;

main()
{
    level._use_choke_weapon_hints = 1;
    level._use_choke_blockers = 1;
    level.zombiemode = 1;
    level.random_pandora_box_start = 1;
    level._zombie_custom_add_weapons = ::custom_add_weapons;
    level.riser_fx_on_client = 1;
    level.use_clientside_rock_tearin_fx = 1;
    level.use_clientside_board_fx = 1;
    init_client_flags();
    level.check_for_alternate_poi = ::check_if_should_avoid_poi;
    level._dontinitnotifymessage = 1;
    maps\mp\gametypes_zm\_spawning::level_use_unified_spawning( 1 );
    level.givecustomloadout = ::givecustomloadout;
    level.precachecustomcharacters = ::precachecustomcharacters;
    level.givecustomcharacters = ::givecustomcharacters;
    initcharacterstartindex();
    level.use_zombie_heroes = 1;
    precache_assets();
    init_sounds();
    maps\mp\zm_temple_fx::main();
    maps\mp\createart\zm_temple_art::main();
    init_random_perk_machines();
    maps\mp\zombies\_zm::init_fx();
    maps\mp\zombies\_load::main();
    level.zombiemode = 1;
    level thread maps\mp\zm_temple_waterslide::cave_slide_anim_init();

    if ( !( isdefined( getdvar( #"createfx" ) != "" ) && getdvar( #"createfx" ) != "" ) )
        include_weapons();

    include_powerups();
    level.zombiemode_using_doubletap_perk = 1;
    level.zombiemode_using_juggernaut_perk = 1;
    level.zombiemode_using_revive_perk = 1;
    level.zombiemode_using_sleightofhand_perk = 1;
    level.zombiemode_using_marathon_perk = 1;
    level.zombiemode_using_divetonuke_perk = 1;
    level.zombiemode_using_deadshot_perk = 1;
    level.zombiemode_using_pack_a_punch = 1;
    level.zombiemode_precache_player_model_override = ::precache_player_model_override;
    level.zombiemode_give_player_model_override = ::give_player_model_override;
    level.zombiemode_player_set_viewmodel_override = ::player_set_viewmodel_override;
    level.exit_level_func = ::temple_exit_level;
    level.zombiemode_cross_bow_fired = ::zombiemode_cross_bow_fired_temple;
    level.player_intersection_tracker_override = ::zombie_temple_player_intersection_tracker_override;
    level.deathcard_spawn_func = ::temple_death_screen_cleanup;
    level.check_valid_spawn_override = ::temple_check_valid_spawn;
    level.revive_solo_fx_func = ::temple_revive_solo_fx;
    level.custom_ai_type = [];
    level.max_perks = 4;
    level.max_solo_lives = 3;
    level.register_offhand_weapons_for_level_defaults_override = ::temple_offhand_weapon_overrride;
    maps\mp\zombies\_zm::init();
    temple_sidequest_of_awesome();
    maps\mp\zombies\_zm::post_main();
    maps\mp\_sticky_grenade::init();
    thread maps\mp\zm_temple_magic_box::magic_box_init();
    level.poi_positioning_func = ::temple_poi_positioning_func;
    level.powerup_fx_func = ::temple_powerup_fx_func;
    level.playerlaststand_func = ::player_laststand_temple;
    level._round_start_func = maps\mp\zombies\_zm::round_start;
    level thread init_electric_switch();
    level.zone_manager_init_func = ::local_zone_init;
    init_zones[0] = "temple_start_zone";
    level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );
    level thread add_powerups_after_round_1();
    level thread maps\mp\zm_temple_elevators::init_elevator();
    level thread maps\mp\zm_temple_minecart::minecart_main();
    level thread maps\mp\zm_temple_waterslide::waterslide_main();
    level thread start_sparks();
    level thread init_temple_traps();
    level thread init_pack_a_punch();
    level thread maps\mp\zm_temple_triggers::main();
    level thread maps\mp\zm_temple_sq::start_temple_sidequest();
}

init_client_flags()
{
    level._cf_actor_is_napalm_zombie = 0;
    level._cf_actor_do_not_use = 1;
    level._cf_actor_napalm_zombie_explode = 2;
    level._cf_actor_is_sonic_zombie = 3;
    level._cf_actor_napalm_zombie_wet = 4;
    level._cf_actor_client_flag_spikemore = 5;
    level._cf_actor_ragdoll_impact_gib = 6;
    level._cf_player_geyser_fake_player_setup_prone = 0;
    level._cf_player_geyser_fake_player_setup_stand = 1;
    level._cf_player_maze_floor_rumble = 3;
    level.cf_player_underwater = 15;
    level._cf_scriptmover_client_flag_spikes = 3;
    level._cf_scriptmover_client_flag_maze_wall = 4;
    level._cf_scriptmover_client_flag_spikemore = 5;
    level._cf_scriptmover_client_flag_weaksauce_start = 6;
    level._cf_scriptmover_client_flag_hotsauce_start = 7;
    level._cf_scriptmover_client_flag_sauce_end = 8;
    level._cf_scriptmover_client_flag_water_trail = 9;
}

temple_sidequest_of_awesome()
{
    maps\mp\zm_temple_sq::init();
}

start_sparks()
{
    wait 2;
    exploder( 25 );
    exploder( 26 );
}

init_sounds()
{
    maps\mp\zombies\_zm_utility::add_sound( "door_stone_disc", "zmb_door_stone_disc" );
    maps\mp\zombies\_zm_utility::add_sound( "door_wood", "zmb_door_wood" );
    maps\mp\zombies\_zm_utility::add_sound( "door_spike", "zmb_door_spike" );
}

givecustomloadout( takeallweapons, alreadyspawned )
{
    self giveweapon( "knife_zm" );
    self give_start_weapon( 1 );
}

precachecustomcharacters()
{
    character\c_usa_dempsey_zm::precache();
    character\c_rus_nikolai_zm::precache();
    character\c_jap_takeo_zm::precache();
    character\c_ger_richtofen_zm::precache();
    precachemodel( "viewmodel_usa_pow_arms" );
    precachemodel( "viewmodel_rus_prisoner_arms" );
    precachemodel( "viewmodel_vtn_nva_standard_arms" );
    precachemodel( "viewmodel_usa_hazmat_arms" );
}

givecustomcharacters()
{
    self detachall();

    switch ( self selectcharacterindextouse() )
    {
        case 0:
            self character\c_usa_dempsey_zm::main();
            self setviewmodel( "viewmodel_usa_pow_arms" );
            self.characterindex = 0;
            break;
        case 1:
            self character\c_rus_nikolai_zm::main();
            self setviewmodel( "viewmodel_rus_prisoner_arms" );
            self.characterindex = 1;
            break;
        case 2:
            self character\c_jap_takeo_zm::main();
            self setviewmodel( "viewmodel_vtn_nva_standard_arms" );
            self.characterindex = 2;
            break;
        case 3:
            self character\c_ger_richtofen_zm::main();
            self setviewmodel( "viewmodel_usa_hazmat_arms" );
            self.characterindex = 3;
            break;
    }

    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
}

initcharacterstartindex()
{
    level.characterstartindex = randomint( 4 );
}

selectcharacterindextouse()
{
    if ( level.characterstartindex >= 4 )
        level.characterstartindex = 0;

    self.characterindex = level.characterstartindex;
    level.characterstartindex++;
    return self.characterindex;
}

precache_assets()
{
    maps\mp\zm_temple_minecart::precache_assets();
    maps\mp\zm_temple_waterslide::precache_assets();
    precachemodel( "zombie_zapper_cagelight_red" );
    precachemodel( "zombie_zapper_cagelight_green" );
    precachemodel( "p_ztem_power_hanging_light" );
    precachemodel( "p_lights_cagelight02_on" );
    precacheshader( "flamethrowerfx_color_distort_overlay_bloom" );
}

local_zone_init()
{
    flag_init( "always_on" );
    flag_set( "always_on" );
    add_adjacent_zone( "temple_start_zone", "pressure_plate_zone", "start_to_pressure" );
    add_adjacent_zone( "temple_start_zone", "waterfall_upper1_zone", "start_to_waterfall_upper" );
    add_adjacent_zone( "pressure_plate_zone", "cave_tunnel_zone", "pressure_to_cave01" );
    add_adjacent_zone( "caves1_zone", "cave_tunnel_zone", "pressure_to_cave01" );
    add_adjacent_zone( "waterfall_lower_zone", "waterfall_tunnel_zone", "waterfall_to_tunnel" );
    add_adjacent_zone( "waterfall_tunnel_zone", "waterfall_tunnel_a_zone", "waterfall_to_tunnel" );
    add_adjacent_zone( "waterfall_tunnel_a_zone", "waterfall_upper_zone", "waterfall_to_tunnel" );
    add_adjacent_zone( "waterfall_upper1_zone", "waterfall_upper_zone", "start_to_waterfall_upper" );
    add_adjacent_zone( "waterfall_upper1_zone", "waterfall_upper_zone", "waterfall_to_tunnel" );
    add_adjacent_zone( "caves1_zone", "caves2_zone", "cave01_to_cave02" );
    add_adjacent_zone( "caves3_zone", "power_room_zone", "cave03_to_power" );
    add_adjacent_zone( "caves_water_zone", "power_room_zone", "cave_water_to_power" );
    add_adjacent_zone( "caves_water_zone", "waterfall_lower_zone", "cave_water_to_waterfall" );
    add_adjacent_zone( "caves2_zone", "caves3_zone", "cave01_to_cave02" );
    add_adjacent_zone( "caves2_zone", "caves3_zone", "cave02_to_cave_water" );
    add_adjacent_zone( "caves2_zone", "caves3_zone", "cave03_to_power" );
    temple_init_zone_spawn_locations();
}

include_weapons()
{
    include_weapon( "frag_grenade_zm", 0 );
    include_weapon( "sticky_grenade_zm", 0, 1 );
    include_weapon( "m1911_zm", 0 );
    include_weapon( "m1911_upgraded_zm", 0 );
    include_weapon( "python_zm" );
    include_weapon( "python_upgraded_zm", 0 );
    include_weapon( "cz75_zm" );
    include_weapon( "cz75_upgraded_zm", 0 );
    include_weapon( "m14_zm", 0, 1 );
    include_weapon( "m14_upgraded_zm", 0 );
    include_weapon( "m16_zm", 0, 1 );
    include_weapon( "m16_gl_upgraded_zm", 0 );
    include_weapon( "g11_lps_zm" );
    include_weapon( "g11_lps_upgraded_zm", 0 );
    include_weapon( "famas_zm" );
    include_weapon( "famas_upgraded_zm", 0 );
    include_weapon( "ak74u_zm", 0, 1 );
    include_weapon( "ak74u_upgraded_zm", 0 );
    include_weapon( "mp5k_zm", 0, 1 );
    include_weapon( "mp5k_upgraded_zm", 0 );
    include_weapon( "mpl_zm", 0, 1 );
    include_weapon( "mpl_upgraded_zm", 0 );
    include_weapon( "pm63_zm", 0, 1 );
    include_weapon( "pm63_upgraded_zm", 0 );
    include_weapon( "spectre_zm" );
    include_weapon( "spectre_upgraded_zm", 0 );
    include_weapon( "cz75dw_zm" );
    include_weapon( "cz75dw_upgraded_zm", 0 );
    include_weapon( "ithaca_zm", 0, 1 );
    include_weapon( "ithaca_upgraded_zm", 0 );
    include_weapon( "rottweil72_zm", 0, 1 );
    include_weapon( "rottweil72_upgraded_zm", 0 );
    include_weapon( "spas_zm" );
    include_weapon( "spas_upgraded_zm", 0 );
    include_weapon( "hs10_zm" );
    include_weapon( "hs10_upgraded_zm", 0 );
    include_weapon( "aug_acog_zm", 1 );
    include_weapon( "aug_acog_mk_upgraded_zm", 0 );
    include_weapon( "galil_zm" );
    include_weapon( "galil_upgraded_zm", 0 );
    include_weapon( "commando_zm" );
    include_weapon( "commando_upgraded_zm", 0 );
    include_weapon( "fnfal_zm" );
    include_weapon( "fnfal_upgraded_zm", 0 );
    include_weapon( "dragunov_zm" );
    include_weapon( "dragunov_upgraded_zm", 0 );
    include_weapon( "l96a1_zm" );
    include_weapon( "l96a1_upgraded_zm", 0 );
    include_weapon( "rpk_zm" );
    include_weapon( "rpk_upgraded_zm", 0 );
    include_weapon( "hk21_zm" );
    include_weapon( "hk21_upgraded_zm", 0 );
    include_weapon( "m72_law_zm" );
    include_weapon( "m72_law_upgraded_zm", 0 );
    include_weapon( "china_lake_zm" );
    include_weapon( "china_lake_upgraded_zm", 0 );
    include_weapon( "cymbal_monkey_zm" );
    include_weapon( "ray_gun_zm" );
    include_weapon( "ray_gun_upgraded_zm", 0 );
    include_weapon( "crossbow_explosive_zm" );
    include_weapon( "crossbow_explosive_upgraded_zm", 0 );
    include_weapon( "knife_ballistic_zm", 1 );
    include_weapon( "knife_ballistic_upgraded_zm", 0 );
    include_weapon( "knife_ballistic_bowie_zm", 0 );
    include_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );
    level._uses_retrievable_ballisitic_knives = 1;
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "m1911_zm", 0 );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "crossbow_explosive_zm", 1 );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_zm", 1 );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "shrink_ray_zm", 1 );
    precacheitem( "explosive_bolt_zm" );
    precacheitem( "explosive_bolt_upgraded_zm" );
}

custom_add_weapons()
{
    add_zombie_weapon( "m1911_zm", "m1911_upgraded_zm", &"ZOMBIE_WEAPON_M1911", 50, "pistol", "", undefined );
    add_zombie_weapon( "python_zm", "python_upgraded_zm", &"ZOMBIE_WEAPON_PYTHON", 50, "pistol", "", undefined );
    add_zombie_weapon( "ak74u_zm", "ak74u_upgraded_zm", &"ZOMBIE_WEAPON_AK74U", 1200, "smg", "", undefined );
    add_zombie_weapon( "mp5k_zm", "mp5k_upgraded_zm", &"ZOMBIE_WEAPON_MP5K", 1000, "smg", "", undefined );
    add_zombie_weapon( "spas_zm", "spas_upgraded_zm", &"ZOMBIE_WEAPON_SPAS", 50, "shotgun", "", undefined );
    add_zombie_weapon( "rottweil72_zm", "rottweil72_upgraded_zm", &"ZOMBIE_WEAPON_ROTTWEIL72", 500, "shotgun", "", undefined );
    add_zombie_weapon( "m14_zm", "m14_upgraded_zm", &"ZOMBIE_WEAPON_M14", 500, "rifle", "", undefined );
    add_zombie_weapon( "m16_zm", "m16_gl_upgraded_zm", &"ZOMBIE_WEAPON_M16", 1200, "burstrifle", "", undefined );
    add_zombie_weapon( "galil_zm", "galil_upgraded_zm", &"ZOMBIE_WEAPON_GALIL", 50, "assault", "", undefined );
    add_zombie_weapon( "fnfal_zm", "fnfal_upgraded_zm", &"ZOMBIE_WEAPON_FNFAL", 50, "burstrifle", "", undefined );
    add_zombie_weapon( "frag_grenade_zm", undefined, &"ZOMBIE_WEAPON_FRAG_GRENADE", 250, "grenade", "", undefined );
    add_zombie_weapon( "sticky_grenade_zm", undefined, &"ZOMBIE_WEAPON_STICKY_GRENADE", 250, "grenade", "", undefined );
    add_zombie_weapon( "claymore_zm", undefined, &"ZOMBIE_WEAPON_CLAYMORE", 1000, "grenade", "", undefined );
    add_zombie_weapon( "cymbal_monkey_zm", undefined, &"ZOMBIE_WEAPON_SATCHEL_2000", 2000, "monkey", "", undefined );
    add_zombie_weapon( "ray_gun_zm", "ray_gun_upgraded_zm", &"ZOMBIE_WEAPON_RAYGUN", 10000, "raygun", "", undefined );
    add_zombie_weapon( "crossbow_explosive_zm", "crossbow_explosive_upgraded_zm", &"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE", 10, "crossbow", "", undefined );
    add_zombie_weapon( "knife_ballistic_zm", "knife_ballistic_upgraded_zm", &"ZOMBIE_WEAPON_KNIFE_BALLISTIC", 10, "sickle", "", undefined );
    add_zombie_weapon( "knife_ballistic_bowie_zm", "knife_ballistic_bowie_upgraded_zm", &"ZOMBIE_WEAPON_KNIFE_BALLISTIC", 10, "sickle", "", undefined );
    add_zombie_weapon( "cz75_zm", "cz75_upgraded_zm", &"ZOMBIE_WEAPON_CZ75", 50, "pistol", "", undefined );
    add_zombie_weapon( "mp40_zm", "mp40_upgraded_zm", &"ZOMBIE_WEAPON_MP40", 1000, "smg", "", undefined );
    add_zombie_weapon( "mpl_zm", "mpl_upgraded_zm", &"ZOMBIE_WEAPON_MPL", 1000, "smg", "", undefined );
    add_zombie_weapon( "pm63_zm", "pm63_upgraded_zm", &"ZOMBIE_WEAPON_PM63", 1000, "smg", "", undefined );
    add_zombie_weapon( "spectre_zm", "spectre_upgraded_zm", &"ZOMBIE_WEAPON_SPECTRE", 50, "smg", "", undefined );
    add_zombie_weapon( "cz75dw_zm", "cz75dw_upgraded_zm", &"ZOMBIE_WEAPON_CZ75DW", 50, "dualwield", "", undefined );
    add_zombie_weapon( "ithaca_zm", "ithaca_upgraded_zm", &"ZOMBIE_WEAPON_ITHACA", 1500, "shotgun", "", undefined );
    add_zombie_weapon( "hs10_zm", "hs10_upgraded_zm", &"ZOMBIE_WEAPON_HS10", 50, "shotgun", "", undefined );
    add_zombie_weapon( "g11_lps_zm", "g11_lps_upgraded_zm", &"ZOMBIE_WEAPON_G11", 900, "burstrifle", "", undefined );
    add_zombie_weapon( "famas_zm", "famas_upgraded_zm", &"ZOMBIE_WEAPON_FAMAS", 50, "burstrifle", "", undefined );
    add_zombie_weapon( "aug_acog_zm", "aug_acog_mk_upgraded_zm", &"ZOMBIE_WEAPON_AUG", 1200, "assault", "", undefined );
    add_zombie_weapon( "commando_zm", "commando_upgraded_zm", &"ZOMBIE_WEAPON_COMMANDO", 100, "assault", "", undefined );
    add_zombie_weapon( "dragunov_zm", "dragunov_upgraded_zm", &"ZOMBIE_WEAPON_DRAGUNOV", 2500, "sniper", "", undefined );
    add_zombie_weapon( "l96a1_zm", "l96a1_upgraded_zm", &"ZOMBIE_WEAPON_L96A1", 50, "sniper", "", undefined );
    add_zombie_weapon( "rpk_zm", "rpk_upgraded_zm", &"ZOMBIE_WEAPON_RPK", 4000, "mg", "", undefined );
    add_zombie_weapon( "hk21_zm", "hk21_upgraded_zm", &"ZOMBIE_WEAPON_HK21", 50, "mg", "", undefined );
    add_zombie_weapon( "m72_law_zm", "m72_law_upgraded_zm", &"ZOMBIE_WEAPON_M72_LAW", 2000, "launcher", "", undefined );
    add_zombie_weapon( "china_lake_zm", "china_lake_upgraded_zm", &"ZOMBIE_WEAPON_CHINA_LAKE", 2000, "launcher", "", undefined );
    add_zombie_weapon( "tesla_gun_zm", "tesla_gun_upgraded_zm", &"ZOMBIE_WEAPON_TESLA", 10, "tesla", "", undefined );
    add_zombie_weapon( "beretta93r_zm", "beretta93r_upgraded_zm", &"ZOMBIE_WEAPON_BERETTA93r", 1000, "", "", undefined );
    add_zombie_weapon( "870mcs_zm", "870mcs_upgraded_zm", &"ZOMBIE_WEAPON_870MCS", 1500, "shotgun", "", undefined );
}

include_powerups()
{
    include_powerup( "nuke" );
    include_powerup( "insta_kill" );
    include_powerup( "double_points" );
    include_powerup( "full_ammo" );
    include_powerup( "carpenter" );
    include_powerup( "fire_sale" );
    include_powerup( "free_perk" );
}

add_powerups_after_round_1()
{
/#
    if ( getdvarint( #"_id_FA81816F" ) > 0 )
        return;
#/

    while ( true )
    {
        if ( level.round_number > 1 )
        {
            level.zombie_powerup_array[level.zombie_powerup_array.size] = "nuke";
            level.zombie_powerup_array[level.zombie_powerup_array.size] = "fire_sale";
            break;
        }

        wait 1;
    }
}

init_weapons_locker()
{
    trigger = getent( "weapons_locker", "targetname" );
    trigger setcursorhint( "HINT_NOICON" );
    wallmodel = getent( trigger.target, "targetname" );
}

setup_water_physics()
{

}

mergesort( current_list, less_than )
{
    if ( current_list.size <= 1 )
        return current_list;

    left = [];
    right = [];
    middle = current_list.size / 2;

    for ( x = 0; x < middle; x++ )
        left = add_to_array( left, current_list[x] );

    while ( x < current_list.size )
    {
        right = add_to_array( right, current_list[x] );
        x++;
    }

    left = mergesort( left, less_than );
    right = mergesort( right, less_than );
    result = merge( left, right, less_than );
    return result;
}

merge( left, right, less_than )
{
    result = [];
    li = 0;
    ri = 0;

    while ( li < left.size && ri < right.size )
    {
        if ( [[ less_than ]]( left[li], right[ri] ) )
        {
            result[result.size] = left[li];
            li++;
        }
        else
        {
            result[result.size] = right[ri];
            ri++;
        }
    }

    while ( li < left.size )
    {
        result[result.size] = left[li];
        li++;
    }

    while ( ri < right.size )
    {
        result[result.size] = right[ri];
        ri++;
    }

    return result;
}

double_door_fx()
{
    flag_wait( "cave01_to_cave02" );
    door_ents = getentarray( "cave01_to_cave02_door", "targetname" );
    doors_x = 0;
    doors_y = 0;
    doors_z = 0;

    for ( i = 0; i < door_ents.size; i++ )
    {
        doors_x = doors_x + door_ents[i].origin[0];
        doors_y = doors_y + door_ents[i].origin[1];
        doors_z = doors_z + door_ents[i].origin[2];
    }

    doors_x = doors_x / door_ents.size;
    doors_y = doors_y / door_ents.size;
    doors_z = doors_z / door_ents.size;
    door_origin = ( doors_x, doors_y, doors_z );
    playfx( level._effect["square_door_open"], door_origin );
}

init_rolling_doors()
{
    rollingdoors = getentarray( "rolling_door", "targetname" );
    array_thread( rollingdoors, ::rolling_door_think );
}

rolling_door_think()
{
    self.door_movedir = anglestoforward( self.angles );
    self.door_movedist = self.script_float;
    self.door_movetime = self.script_timer;
    self.door_radius = self.script_radius;
    self.door_wait = self.script_string;
    flag_wait( self.door_wait );
    playsoundatposition( "evt_door_stone_disc", self.origin );
    self play_sound_on_ent( "purchase" );
    playfx( level._effect["rolling_door_open"], self.origin );
    pi = 3.14159;
    endorigin = self.origin + self.door_movedir * self.door_movedist;
    self moveto( endorigin, self.door_movetime, 0.1, 0.1 );
    cir = 2 * pi * self.door_radius;
    rotate = self.door_movedist / cir * 360.0;
    self rotateto( self.angles + ( rotate, 0, 0 ), self.door_movetime, 0.1, 0.1 );
    self connectpaths();
}

player_laststand_temple( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    if ( is_true( self.riding_geyser ) )
        self unlink();

    self maps\mp\zombies\_zm::player_laststand( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );
}

temple_poi_positioning_func( origin, forward )
{
    return maps\mp\zombies\_zm_server_throttle::server_safe_ground_trace_ignore_water( "poi_trace", 10, self.origin + forward + vectorscale( ( 0, 0, 1 ), 10.0 ) );
}

temple_powerup_fx_func()
{
    self delete_powerup_fx();
    self.fx_green = maps\mp\zombies\_zm_net::network_safe_spawn( "powerup_fx", 2, "script_model", self.origin );
    self.fx_green setmodel( "tag_origin" );
    self.fx_green linkto( self );
    playfxontag( level._effect["powerup_on"], self.fx_green, "tag_origin" );
    self thread delete_powerup_fx_wait();
}

delete_powerup_fx_wait()
{
    self waittill( "death" );
    self delete_powerup_fx();
}

delete_powerup_fx()
{
    if ( isdefined( self.fx_green ) )
    {
        self.fx_green unlink();
        self.fx_green delete();
        self.fx_green = undefined;
    }
}

init_random_perk_machines()
{
    randmachines = [];
    randmachines = _add_machine( randmachines, "vending_jugg", "mus_perks_jugganog_sting", "specialty_armorvest", "mus_perks_jugganog_jingle", "jugg_perk", "zombie_vending_jugg" );
    randmachines = _add_machine( randmachines, "vending_marathon", "mus_perks_stamin_sting", "specialty_longersprint", "mus_perks_stamin_jingle", "marathon_perk", "zombie_vending_marathon" );
    randmachines = _add_machine( randmachines, "vending_divetonuke", "mus_perks_phd_sting", "specialty_flakjacket", "mus_perks_phd_jingle", "divetonuke_perk", "zombie_vending_nuke" );
    randmachines = _add_machine( randmachines, "vending_deadshot", "mus_perks_deadshot_sting", "specialty_deadshot", "mus_perks_deadshot_jingle", "tap_deadshot", "zombie_vending_ads" );
    randmachines = _add_machine( randmachines, "vending_sleight", "mus_perks_speed_sting", "specialty_fastreload", "mus_perks_speed_jingle", "speedcola_perk", "zombie_vending_sleight" );
    randmachines = _add_machine( randmachines, "vending_doubletap", "mus_perks_doubletap_sting", "specialty_rof", "mus_perks_doubletap_jingle", "tap_perk", "zombie_vending_doubletap" );
    machines = getentarray( "zombie_vending_random", "targetname" );

    for ( i = 0; i < machines.size; i++ )
    {
        machine = machines[i];
        machine.allowed = [];

        if ( isdefined( machine.script_parameters ) )
            machine.allowed = strtok( machine.script_parameters, "," );

        if ( machine.allowed.size == 0 )
            machine.allowed = array( "jugg_perk", "marathon_perk", "divetonuke_perk", "tap_deadshot", "speedcola_perk", "tap_perk" );

        machine.allowed = array_randomize( machine.allowed );
    }

    machines = mergesort( machines, ::perk_machines_compare_func );

    for ( i = 0; i < machines.size; i++ )
    {
        machine = machines[i];
        randmachine = undefined;

        for ( j = 0; j < machine.allowed.size; j++ )
        {
            index = _rand_perk_index( randmachines, machine.allowed[j] );

            if ( isdefined( index ) )
            {
                randmachine = randmachines[index];
                randmachines = array_remove( randmachines, randmachine );
                break;
            }
        }

        machine.script_label = randmachine.script_label;
        machine.script_noteworthy = randmachine.script_noteworthy;
        machine.script_sound = randmachine.script_sound;
        machine.script_string = randmachine.script_string;
        machine.targetname = randmachine.targetname;
        machine_model = undefined;
        clip = undefined;
        targets = getentarray( machine.target, "targetname" );

        for ( j = 0; j < targets.size; j++ )
        {
            noteworthy = targets[j].script_noteworthy;

            if ( isdefined( noteworthy ) && noteworthy == "clip" )
            {
                clip = targets[j];
                continue;
            }

            machine_model = targets[j];
        }

        machine.target = randmachine.target;

        if ( isdefined( machine_model ) )
        {
            machine_model setmodel( randmachine.model );
            machine_model.targetname = randmachine.target;
            machine_model.script_string = randmachine.script_string;
        }

        if ( isdefined( clip ) )
            clip.targetname = randmachine.target;
    }
}

array_remove( array, object )
{
    if ( !isdefined( array ) && !isdefined( object ) )
        return;

    new_array = [];

    foreach ( item in array )
    {
        if ( item != object )
            new_array[new_array.size] = item;
    }

    return new_array;
}

_rand_perk_index( randmachines, name )
{
    for ( i = 0; i < randmachines.size; i++ )
    {
        if ( randmachines[i].script_string == name )
            return i;
    }

    return undefined;
}

perk_machines_compare_func( m1, m2 )
{
    return m1.allowed.size < m2.allowed.size;
}

_add_machine( machines, target, script_label, script_noteworthy, script_sound, script_string, model )
{
    s = spawnstruct();
    s.target = target;
    s.script_label = script_label;
    s.script_noteworthy = script_noteworthy;
    s.script_sound = script_sound;
    s.script_string = script_string;
    s.targetname = "zombie_vending";
    s.model = model;
    precachemodel( model );
    machines[machines.size] = s;
    return machines;
}

precache_player_model_override()
{
    mptype\player_t5_zm_theater::precache();
}

give_player_model_override( entity_num )
{
    if ( isdefined( self.zm_random_char ) )
        entity_num = self.zm_random_char;

    switch ( entity_num )
    {
        case 0:
            character\c_usa_dempsey_zt::main();
            break;
        case 1:
            character\c_rus_nikolai_zt::main();
            break;
        case 2:
            character\c_jap_takeo_zt::main();
            break;
        case 3:
            character\c_ger_richtofen_zt::main();
            break;
    }
}

player_set_viewmodel_override( entity_num )
{
    switch ( self.entity_num )
    {
        case 0:
            self setviewmodel( "viewmodel_usa_pow_arms" );
            break;
        case 1:
            self setviewmodel( "viewmodel_rus_prisoner_arms" );
            break;
        case 2:
            self setviewmodel( "viewmodel_vtn_nva_standard_arms" );
            break;
        case 3:
            self setviewmodel( "viewmodel_usa_hazmat_arms" );
            break;
    }
}

init_random_paths()
{
    nodes = getnodearray( "random_toggle_node", "script_noteworthy" );

    for ( i = 0; i < nodes.size; i++ )
        nodes[i] thread random_node_toggle( 10, 20, 10, 20 );
}

random_node_toggle( minon, maxon, minoff, maxoff )
{
    target = getnode( self.target, "targetname" );

    if ( !isdefined( target ) )
        return;

    while ( true )
    {
        wait( randomfloatrange( minon, maxoff ) );
        unlinknodes( self, target );
        wait( randomfloatrange( minoff, maxoff ) );
        linknodes( self, target );
    }
}

temple_exit_level()
{
    zombies = getaiarray( "axis" );

    for ( i = 0; i < zombies.size; i++ )
    {
        if ( is_true( zombies[i].ignore_solo_last_stand ) )
            continue;

        if ( isdefined( zombies[i].find_exit_point ) )
        {
            zombies[i] thread [[ zombies[i].find_exit_point ]]();
            continue;
        }

        if ( zombies[i].ignoreme )
        {
            zombies[i] thread temple_delayed_exit();
            continue;
        }

        zombies[i] thread temple_find_exit_point();
    }
}

temple_delayed_exit()
{
    self endon( "death" );

    while ( true )
    {
        if ( !flag( "wait_and_revive" ) )
            return;

        if ( !self.ignoreme )
            break;

        wait_network_frame();
    }

    self thread temple_find_exit_point();
}

temple_find_exit_point()
{
    self endon( "death" );

    while ( is_true( self.sliding ) )
        wait 0.1;

    min_distance_squared = 1048576;
    player = getplayers()[0];
    dest = 0;
    dist_far = 0;
    locs = array_randomize( level.enemy_dog_locations );

    for ( i = 0; i < locs.size; i++ )
    {
        dist_zombie = distancesquared( locs[i].origin, self.origin );
        dist_player = distancesquared( locs[i].origin, player.origin );

        if ( dist_player > dist_far )
        {
            dest = i;
            dist_far = dist_player;
        }

        if ( dist_zombie < dist_player && dist_player > min_distance_squared )
        {
            dest = i;
            break;
        }
    }

    self notify( "stop_find_flesh" );
    self notify( "zombie_acquire_enemy" );
    self setgoalpos( locs[dest].origin );

    while ( true )
    {
        if ( !flag( "wait_and_revive" ) )
            break;

        wait_network_frame();
    }
}

temple_offhand_weapon_overrride()
{
    register_lethal_grenade_for_level( "frag_grenade_zm" );
    register_lethal_grenade_for_level( "sticky_grenade_zm" );
    level.zombie_lethal_grenade_player_init = "frag_grenade_zm";
    register_tactical_grenade_for_level( "zombie_cymbal_monkey" );
    level.zombie_tactical_grenade_player_init = undefined;
    register_placeable_mine_for_level( "claymore_zm" );
    level.zombie_placeable_mine_player_init = undefined;
    register_melee_weapon_for_level( "knife_zm" );
    register_melee_weapon_for_level( "bowie_knife_zm" );
    level.zombie_melee_weapon_player_init = "knife_zm";
}

temple_shrink_ray_model_mapping_func()
{
    level.shrink_models["c_viet_zombie_female"] = "c_viet_zombie_female_mini";
    level.shrink_models["c_viet_zombie_female_head"] = "c_viet_zombie_female_head_mini";
    level.shrink_models["c_viet_zombie_nva1_body"] = "c_viet_zombie_nva1_body_m";
    level.shrink_models["c_viet_zombie_nva1_head1"] = "c_viet_zombie_nva1_head_m";
    level.shrink_models["c_viet_zombie_napalm"] = "c_viet_zombie_napalm_m";
    level.shrink_models["c_viet_zombie_napalm_head"] = "c_viet_zombie_napalm_head_m";
    level.shrink_models["c_viet_zombie_sonic_body"] = "c_viet_zombie_sonic_body_m";
    level.shrink_models["c_viet_zombie_sonic_head"] = "c_viet_zombie_sonic_head_m";
    level.shrink_models["c_viet_zombie_nva_body_alt"] = "c_viet_zombie_nva_body_alt_m";
    level.shrink_models["c_viet_zombie_female_alt"] = "c_viet_zombie_female_mini_alt";
    level.shrink_models["c_viet_zombie_vc_grunt_head"] = "c_viet_zombie_vc_grunt_head_m";
    level.shrink_models["c_viet_zombie_vc_grunt"] = "c_viet_zombie_vc_grunt_m";
    level.shrink_models["c_viet_zombie_sonic_bandanna"] = "c_viet_zombie_sonic_bandanna_m";
    level.shrink_models["c_viet_zombie_nva1_gasmask"] = "c_viet_zombie_nva1_gasmask_m";
    level.shrink_models["c_viet_zombie_female_g_barmsoff"] = "c_viet_zombie_female_g_barmsoff_mini";
    level.shrink_models["c_viet_zombie_female_g_headoff"] = "c_viet_zombie_female_g_headoff_mini";
    level.shrink_models["c_viet_zombie_female_g_legsoff"] = "c_viet_zombie_female_g_legsoff_mini";
    level.shrink_models["c_viet_zombie_female_g_llegoff"] = "c_viet_zombie_female_g_llegoff_mini";
    level.shrink_models["c_viet_zombie_female_g_lowclean"] = "c_viet_zombie_female_g_lowclean_mini";
    level.shrink_models["c_viet_zombie_female_g_rarmoff"] = "c_viet_zombie_female_g_rarmoff_mini";
    level.shrink_models["c_viet_zombie_female_g_rlegoff"] = "c_viet_zombie_female_g_rlegoff_mini";
    level.shrink_models["c_viet_zombie_female_g_upclean"] = "c_viet_zombie_female_g_upclean_mini";
    level.shrink_models["c_viet_zombie_female_g_larmoff"] = "c_viet_zombie_female_g_larmoff_mini";
    level.shrink_models["c_viet_zombie_female_g_barmsoff_alt"] = "c_viet_zombie_female_g_barmsoff_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_legsoff_alt"] = "c_viet_zombie_female_g_legsoff_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_llegoff_alt"] = "c_viet_zombie_female_g_llegoff_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_lowclean_alt"] = "c_viet_zombie_female_g_lowclean_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_rarmoff_alt"] = "c_viet_zombie_female_g_rarmoff_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_rlegoff_alt"] = "c_viet_zombie_female_g_rlegoff_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_upclean_alt"] = "c_viet_zombie_female_g_upclean_alt_mini";
    level.shrink_models["c_viet_zombie_female_g_larmoff_alt"] = "c_viet_zombie_female_g_larmoff_alt_mini";
    level.shrink_models["c_viet_zombie_nva1_g_barmsoff"] = "c_viet_zombie_nva1_g_barmsoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_headoff"] = "c_viet_zombie_nva1_g_headoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_legsoff"] = "c_viet_zombie_nva1_g_legsoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_llegoff"] = "c_viet_zombie_nva1_g_llegoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_lowclean"] = "c_viet_zombie_nva1_g_lowclean_m";
    level.shrink_models["c_viet_zombie_nva1_g_rarmoff"] = "c_viet_zombie_nva1_g_rarmoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_rlegoff"] = "c_viet_zombie_nva1_g_rlegoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_upclean"] = "c_viet_zombie_nva1_g_upclean_m";
    level.shrink_models["c_viet_zombie_nva1_g_larmoff"] = "c_viet_zombie_nva1_g_larmoff_m";
    level.shrink_models["c_viet_zombie_nva1_g_barmsoff_alt"] = "c_viet_zombie_nva1_g_barmsoff_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_legsoff_alt"] = "c_viet_zombie_nva1_g_legsoff_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_llegoff_alt"] = "c_viet_zombie_nva1_g_llegoff_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_lowclean_alt"] = "c_viet_zombie_nva1_g_lowclean_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_rarmoff_alt"] = "c_viet_zombie_nva1_g_rarmoff_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_rlegoff_alt"] = "c_viet_zombie_nva1_g_rlegoff_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_upclean_alt"] = "c_viet_zombie_nva1_g_upclean_alt_m";
    level.shrink_models["c_viet_zombie_nva1_g_larmoff_alt"] = "c_viet_zombie_nva1_g_larmoff_alt_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_barmsoff"] = "c_viet_zombie_vc_grunt_g_barmsoff_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_headoff"] = "c_viet_zombie_vc_grunt_g_headoff_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_legsoff"] = "c_viet_zombie_vc_grunt_g_legsoff_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_llegoff"] = "c_viet_zombie_vc_grunt_g_llegoff_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_lowclean"] = "c_viet_zombie_vc_grunt_g_lowclean_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_rarmoff"] = "c_viet_zombie_vc_grunt_g_rarmoff_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_rlegoff"] = "c_viet_zombie_vc_grunt_g_rlegoff_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_upclean"] = "c_viet_zombie_vc_grunt_g_upclean_m";
    level.shrink_models["c_viet_zombie_vc_grunt_g_larmoff"] = "c_viet_zombie_vc_grunt_g_larmoff_m";
}

check_if_should_avoid_poi()
{
    if ( is_true( self.sliding ) )
        return true;
    else
        return false;
}

zombiemode_cross_bow_fired_temple( grenade, weaponname, parent, player )
{
    if ( !isdefined( level.cross_bow_bolts ) )
        level.cross_bow_bolts = [];

    level.cross_bow_bolts[level.cross_bow_bolts.size] = grenade;
}

zombie_temple_player_intersection_tracker_override( other_player )
{
    if ( is_true( self.riding_geyser ) )
        return true;

    if ( is_true( other_player.riding_geyser ) )
        return true;

    return false;
}

zombie_temple_player_out_of_playable_area_monitor_callback()
{
    if ( is_true( self.on_slide ) )
        return false;

    if ( is_true( self.riding_geyser ) )
        return false;

    if ( is_true( self.is_on_minecart ) )
        return false;

    return true;
}

temple_death_screen_cleanup()
{
    self clearclientflag( level._cf_player_maze_floor_rumble );
    wait_network_frame();
    wait_network_frame();
    self setblur( 0, 0.1 );
}

temple_check_valid_spawn( revivee )
{
    spawn_points = getstructarray( "player_respawn_point", "targetname" );
    zkeys = getarraykeys( level.zones );

    for ( z = 0; z < zkeys.size; z++ )
    {
        zone_str = zkeys[z];

        if ( level.zones[zone_str].is_occupied )
        {
            for ( i = 0; i < spawn_points.size; i++ )
            {
                if ( spawn_points[i].script_noteworthy == zone_str )
                {
                    spawn_array = getstructarray( spawn_points[i].target, "targetname" );

                    for ( j = 0; j < spawn_array.size; j++ )
                    {
                        if ( spawn_array[j].script_int == revivee.entity_num + 1 )
                            return spawn_array[j].origin;
                    }

                    return spawn_array[0].origin;
                }
            }
        }
    }

    return undefined;
}

temple_revive_solo_fx()
{
    vending_triggers = getentarray( "zombie_vending", "targetname" );

    for ( i = 0; i < vending_triggers.size; i++ )
    {
        if ( vending_triggers[i].script_noteworthy == "specialty_quickrevive" )
        {
            vending_triggers[i] delete();
            break;
        }
    }
}
