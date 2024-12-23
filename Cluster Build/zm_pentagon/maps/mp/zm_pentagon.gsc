// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_pentagon_teleporter;
#include maps\mp\zm_pentagon_fx;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_pentagon_amb;
#include maps\mp\zm_pentagon_anim;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_load;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_pentagon;
#include maps\mp\gametypes_zm\_callbacksetup;
#include maps\mp\zombies\_zm_ai_dogs;
#include maps\mp\zombies\_zm_ai_thief;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_freezegun;
#include maps\mp\zm_pentagon_magic_box;
#include maps\mp\_compass;
#include maps\mp\zm_pentagon_traps;
#include maps\mp\zm_pentagon_elevators;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_blockers;
#include character\c_usa_jfk_zt;
#include character\c_usa_mcnamara_zt;
#include character\c_usa_nixon_zt;
#include character\c_cub_castro_zt;
#include maps\mp\zombies\_zm_ai_quad;

main()
{
    level.zombiemode_using_revive_perk = 1;
    level.zombiemode_using_juggernaut_perk = 1;
    level.zombiemode_using_pack_a_punch = 1;
    level.zombiemode_using_sleightofhand_perk = 1;
    level.zombiemode_using_doubletap_perk = 1;
    level pentagon_precache();
    maps\mp\zm_pentagon_fx::main();
    maps\mp\zombies\_zm::init_fx();
    maps\mp\zm_pentagon_amb::main();
    maps\mp\zm_pentagon_anim::main();
    level.register_offhand_weapons_for_level_defaults_override = ::offhand_weapon_overrride;
    level thread maps\mp\_sticky_grenade::init();
    level.zombiemode = 1;
    maps\mp\zombies\_load::main();
    maps\mp\gametypes_zm\_spawning::level_use_unified_spawning( 1 );
    level._round_start_func = maps\mp\zombies\_zm::round_start;
    level.givecustomloadout = ::givecustomloadout;
    level.precachecustomcharacters = ::precachecustomcharacters;
    level.givecustomcharacters = ::givecustomcharacters;
    initcharacterstartindex();
    level._zombie_custom_add_weapons = ::custom_add_weapons;
    level.zbarrier_override = maps\mp\zm_pentagon::pentagon_zbarrier_init_override;
    precacheshader( "zom_icon_trap_switch_handle" );
    level.dogs_enabled = 0;
    level.random_pandora_box_start = 0;
    registerclientfield( "allplayers", "clientfield_pentagon_player_portalfx", 7000, 1, "int" );
    registerclientfield( "world", "clientfield_pentagon_pig_play", 7000, 1, "int" );
    registerclientfield( "world", "clientfield_pentagon_pig_death", 7000, 1, "int" );
    maps\mp\gametypes_zm\_callbacksetup::setupcallbacks();
    level.quad_move_speed = 35;
    level.quad_explode = 1;
    level.dog_spawn_func = maps\mp\zombies\_zm_ai_dogs::dog_spawn_factory_logic;
    level.custom_ai_type = [];
    level.custom_ai_type[level.custom_ai_type.size] = maps\mp\zombies\_zm_ai_dogs::init;
    level.custom_ai_type[level.custom_ai_type.size] = ::pentagon_quad_ai_init_override;
    level.custom_ai_type[level.custom_ai_type.size] = maps\mp\zombies\_zm_ai_thief::init;
    level.door_dialog_function = maps\mp\zombies\_zm::play_door_dialog;
    include_weapons();
    include_powerups();
    init_level_specific_wall_buy_fx();
    level.use_zombie_heroes = 1;
    level.disable_protips = 1;
    level.delete_when_in_createfx = ::delete_in_createfx;
    maps\mp\zombies\_zm::init();
    maps\mp\zombies\_zm_weap_bowie::init();
    maps\mp\zombies\_zm_weap_claymore::init();
    maps\mp\zombies\_zm_weap_ballistic_knife::init();
    maps\mp\zombies\_zm_weap_cymbal_monkey::init();
    maps\mp\zombies\_zm_weap_freezegun::init();
    level maps\mp\zm_pentagon_magic_box::magic_box_init();
    maps\mp\_compass::setupminimap( "menu_map_zombie_pentagon" );
    level.zone_manager_init_func = ::pentagon_zone_init;
    init_zones[0] = "conference_level1";
    level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );
    level.random_spawners = 1;
    level maps\mp\zm_pentagon_traps::init_traps();
    level thread maps\mp\zm_pentagon_elevators::init();
    level thread electric_switch();
    level thread enable_zone_elevators_init();
    level thread maps\mp\zm_pentagon_teleporter::pentagon_packapunch_init();
    level thread maps\mp\zm_pentagon_teleporter::pack_door_init();
    level thread maps\mp\zm_pentagon_teleporter::teleporter_power_cable();
    level thread vision_set_init();
    onplayerconnect_callback( ::laststand_bleedout_init );
    level thread lab_shutters_init();
    level thread pentagon_brush_lights_init();
    level thread zombie_warroom_barricade_fix();
    level thread barricade_glitch_fix();
    level thread maps\mp\zombies\_zm::post_main();
    level.bonfire_init_func = ::pentagon_bonfire_init;
    level.validate_enemy_path_length = ::pentagon_validate_enemy_path_length;
    init_sounds();
    init_pentagon_client_flags();
    level thread play_starting_vox();
}

init_pentagon_client_flags()
{
    level.zombie_pentagon_player_portalfx = 5;
    level.zombie_pentagon_player_portalfx_cool = 6;
}

delete_in_createfx()
{
    if ( getdvar( #"createfx" ) != "" )
    {
        exterior_goals = getstructarray( "exterior_goal", "targetname" );

        for ( i = 0; i < exterior_goals.size; i++ )
        {
            if ( !isdefined( exterior_goals[i].target ) )
                continue;

            targets = getentarray( exterior_goals[i].target, "targetname" );

            for ( j = 0; j < targets.size; j++ )
            {
                if ( isdefined( targets[j].script_parameters ) && targets[j].script_parameters == "repair_board" )
                {
                    unbroken_section = getent( targets[j].target, "targetname" );

                    if ( isdefined( unbroken_section ) )
                        unbroken_section self_delete();
                }

                targets[j] self_delete();
            }
        }

        return;
    }
}

pentagon_zone_init()
{
    flag_init( "always_on" );
    flag_set( "always_on" );
    add_adjacent_zone( "conference_level1", "hallway_level1", "conf1_hall1" );
    add_adjacent_zone( "hallway3_level1", "hallway_level1", "conf1_hall1" );
    add_adjacent_zone( "conference_level2", "war_room_zone_south", "war_room_entry", 1 );
    add_adjacent_zone( "conference_level2", "war_room_zone_north", "war_room_special", 1 );
    add_adjacent_zone( "war_room_zone_top", "war_room_zone_south", "war_room_stair" );
    add_adjacent_zone( "war_room_zone_top", "war_room_zone_north", "war_room_stair" );
    add_adjacent_zone( "war_room_zone_south", "war_room_zone_north", "war_room_stair" );
    add_adjacent_zone( "war_room_zone_south", "war_room_zone_north", "war_room_west" );
    add_adjacent_zone( "war_room_zone_north", "war_room_zone_elevator", "war_room_elevator" );
    add_adjacent_zone( "labs_elevator", "labs_hallway1", "labs_enabled" );
    add_adjacent_zone( "labs_hallway1", "labs_hallway2", "labs_enabled" );
    add_adjacent_zone( "labs_hallway2", "labs_zone1", "lab1_level3" );
    add_adjacent_zone( "labs_hallway1", "labs_zone2", "lab2_level3" );
    add_adjacent_zone( "labs_hallway2", "labs_zone2", "lab2_level3" );
    add_adjacent_zone( "labs_hallway1", "labs_zone3", "lab3_level3" );
    level.zones["conference_level1"].num_spawners = 4;
    level.zones["hallway_level1"].num_spawners = 4;
}

enable_zone_elevators_init()
{
    elev_zone_trig = getent( "elevator1_down_riders", "targetname" );
    elev_zone_trig thread maps\mp\zm_pentagon_teleporter::enable_zone_portals();
    elev_zone_trig2 = getent( "elevator2_down_riders", "targetname" );
    elev_zone_trig2 thread maps\mp\zm_pentagon_teleporter::enable_zone_portals();
    elev_zone_trig3 = getent( "elevator1_down_riders2", "targetname" );
    elev_zone_trig3 thread maps\mp\zm_pentagon_teleporter::enable_zone_portals();
}

include_weapons()
{
    include_weapon( "frag_grenade_zm", 0, 1 );
    include_weapon( "claymore_zm", 0, 1 );
    include_weapon( "m1911_zm", 0 );
    include_weapon( "m1911_upgraded_zm", 0 );
    include_weapon( "python_zm" );
    include_weapon( "python_upgraded_zm", 0 );
    include_weapon( "fiveseven_zm" );
    include_weapon( "fiveseven_upgraded_zm", 0 );
    include_weapon( "m14_zm", 0, 1 );
    include_weapon( "m14_upgraded_zm", 0 );
    include_weapon( "m16_zm", 0, 1 );
    include_weapon( "m16_gl_upgraded_zm", 0 );
    include_weapon( "xm8_zm" );
    include_weapon( "xm8_upgraded_zm", 0 );
    include_weapon( "type95_zm" );
    include_weapon( "type95_upgraded_zm", 0 );
    include_weapon( "ak74u_zm", 0, 1 );
    include_weapon( "ak74u_upgraded_zm", 0 );
    include_weapon( "mp5k_zm", 0, 1 );
    include_weapon( "mp5k_upgraded_zm", 0 );
    include_weapon( "beretta93r_zm", 0, 1 );
    include_weapon( "beretta93r_upgraded_zm", 0 );
    include_weapon( "pdw57_zm", 0, 1 );
    include_weapon( "pdw57_upgraded_zm", 0 );
    include_weapon( "kard_zm" );
    include_weapon( "kard_upgraded_zm", 0 );
    include_weapon( "fivesevendw_zm" );
    include_weapon( "fivesevendw_upgraded_zm", 0 );
    include_weapon( "870mcs_zm", 0, 1 );
    include_weapon( "870mcs_upgraded_zm", 0 );
    include_weapon( "rottweil72_zm", 0, 1 );
    include_weapon( "rottweil72_upgraded_zm", 0 );
    include_weapon( "srm1216_zm" );
    include_weapon( "srm1216_upgraded_zm", 0 );
    include_weapon( "saiga12_zm" );
    include_weapon( "saiga12_upgraded_zm", 0 );
    include_weapon( "tar21_zm" );
    include_weapon( "tar21_upgraded_zm", 0 );
    include_weapon( "galil_zm" );
    include_weapon( "galil_upgraded_zm", 0 );
    include_weapon( "hk416_zm" );
    include_weapon( "hk416_upgraded_zm", 0 );
    include_weapon( "sa58_zm" );
    include_weapon( "sa58_upgraded_zm", 0 );
    include_weapon( "barretm82_zm" );
    include_weapon( "barretm82_upgraded_zm", 0 );
    include_weapon( "dsr50_zm" );
    include_weapon( "dsr50_upgraded_zm", 0 );
    include_weapon( "rpd_zm" );
    include_weapon( "rpd_upgraded_zm", 0 );
    include_weapon( "hamr_zm" );
    include_weapon( "hamr_upgraded_zm", 0 );
    include_weapon( "usrpg_zm" );
    include_weapon( "usrpg_upgraded_zm", 0 );
    include_weapon( "m32_zm" );
    include_weapon( "m32_upgraded_zm", 0 );
    include_weapon( "cymbal_monkey_zm" );
    include_weapon( "ray_gun_zm" );
    include_weapon( "ray_gun_upgraded_zm", 0 );
    include_weapon( "freezegun_zm" );
    include_weapon( "freezegun_upgraded_zm", 0 );
    include_weapon( "knife_ballistic_zm", 1 );
    include_weapon( "knife_ballistic_upgraded_zm", 0 );
    include_weapon( "knife_ballistic_bowie_zm", 0 );
    include_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );
    level._uses_retrievable_ballisitic_knives = 1;
    include_weapon( "minigun_zm" );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "m1911_zm", 0 );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "freezegun_zm", 1 );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_zm", 1 );
}

include_powerups()
{
    include_powerup( "nuke" );
    include_powerup( "insta_kill" );
    include_powerup( "double_points" );
    include_powerup( "full_ammo" );
    include_powerup( "carpenter" );
    include_powerup( "fire_sale" );
    include_powerup( "bonfire_sale" );
    include_powerup( "tesla" );
    precacheitem( "minigun_zm" );
    include_powerup( "minigun" );
}

electric_switch()
{
    trig = getent( "use_elec_switch", "targetname" );
    trig sethintstring( &"ZOMBIE_ELECTRIC_SWITCH" );
    trig setcursorhint( "HINT_NOICON" );
    level thread wait_for_power();
    trig waittill( "trigger", user );
    trig delete();
    flag_set( "power_on" );
}

wait_for_power()
{
    master_switch = getent( "elec_switch", "targetname" );
    master_switch notsolid();
    flag_wait( "power_on" );
    maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
    level notify( "power_controlled_light" );
    exploder( 3500 );
    stop_exploder( 2000 );
    exploder( 2001 );
    level thread regular_portal_fx_on();
    level thread maps\mp\zm_pentagon::change_pentagon_vision();
    master_switch rotateroll( -90, 0.3 );
    master_switch playsound( "zmb_switch_flip" );
    level notify( "revive_on" );
    level notify( "juggernog_on" );
    level notify( "sleight_on" );
    level notify( "doubletap_on" );
    level notify( "Pack_A_Punch_on" );
    clientnotify( "ZPO" );
    maps\mp\zm_pentagon_teleporter::teleporter_init();
    master_switch waittill( "rotatedone" );
    playfx( level._effect["switch_sparks"], getstruct( "elec_switch_fx", "targetname" ).origin );
    master_switch playsound( "zmb_turn_on" );
    level thread maps\mp\zm_pentagon_amb::play_pentagon_announcer_vox( "zmb_vox_pentann_poweron" );
}

init_sounds()
{
    maps\mp\zombies\_zm_utility::add_sound( "wood_door_fall", "zmb_wooden_door_fall" );
    maps\mp\zombies\_zm_utility::add_sound( "window_grate", "zmb_window_grate_slide" );
    maps\mp\zombies\_zm_utility::add_sound( "lab_door", "zmb_lab_door_slide" );
    maps\mp\zombies\_zm_utility::add_sound( "lab_door_swing", "zmb_door_wood_open" );
}

quad_traverse_death_fx()
{
    self endon( "quad_end_traverse_anim" );
    self waittill( "death" );
    playfx( level._effect["quad_grnd_dust_spwnr"], self.origin );
}

zombie_pathing_init()
{
    cleanup_trig = getentarray( "zombie_movement_cleanup", "targetname" );

    for ( i = 0; i < cleanup_trig.size; i++ )
        cleanup_trig[i] thread zombie_pathing_cleanup();
}

zombie_pathing_cleanup()
{
    while ( true )
    {
        self waittill( "trigger", who );

        if ( isdefined( who.animname ) && who.animname == "thief_zombie" )
            continue;
        else if ( who.team == "axis" )
        {
            level.zombie_total++;
            who dodamage( who.health + 100, who.origin );
        }
    }
}

vision_set_init()
{
    level waittill( "start_of_round" );
    exploder( 2000 );
}

change_pentagon_vision()
{
    if ( flag( "thief_round" ) )
        return;

    players = get_players();

    for ( i = 0; i < players.size; i++ )
    {
        players[i].floor = maps\mp\zombies\_zm_ai_thief::thief_check_floor( players[i] );
        setclientsysstate( "levelNotify", "vis" + players[i].floor, players[i] );
        wait_network_frame();
    }
}

laststand_bleedout_init()
{
    self thread wait_for_laststand_notify();
    self thread bleedout_listener();
}

wait_for_laststand_notify()
{
    self endon( "disconnect" );

    while ( true )
    {
        num_on_floor = 0;
        num_floor_laststand = 0;
        self waittill( "player_downed" );

        while ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        {
            self.floor = maps\mp\zombies\_zm_ai_thief::thief_check_floor( self );
            current_floor = self.floor;
            players = get_players();

            for ( i = 0; i < players.size; i++ )
            {
                players[i].floor = maps\mp\zombies\_zm_ai_thief::thief_check_floor( players[i] );

                if ( players[i].floor == current_floor )
                {
                    num_on_floor++;

                    if ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
                        num_floor_laststand++;
                }
            }

            wait_network_frame();

            if ( players.size > 1 && num_on_floor == num_floor_laststand )
                self thread maps\mp\zm_pentagon_elevators::laststand_elev_zombies_away();

            wait 5;
        }
    }
}

bleedout_listener()
{
    while ( true )
    {
        self waittill( "spawned_spectator" );
        self thread bleedout_respawn_listener();
        wait 2;
        level thread check_if_empty_floors();
        wait 1;
    }
}

bleedout_respawn_listener()
{
    self waittill( "spawned_player" );
    self.floor = maps\mp\zombies\_zm_ai_thief::thief_check_floor( self );
    setclientsysstate( "levelNotify", "vis" + self.floor, self );
}

pentagon_bonfire_init()
{
    if ( flag( "defcon_active" ) && level.defcon_activated == 0 )
        return;
    else if ( flag( "defcon_active" ) && level.defcon_activated == 1 )
    {
        level.defcon_countdown_time = 30;
        level.defcon_level = 5;
        return;
    }

    current_defcon_level = level.defcon_level;
    punch_switches = getentarray( "punch_switch", "targetname" );
    signs = getentarray( "defcon_sign", "targetname" );
    pack_door_slam = getent( "slam_pack_door", "targetname" );
    flag_set( "bonfire_reset" );
    level.defcon_level = 1;
    level notify( "pack_room_reset" );
    wait 0.1;

    if ( isdefined( punch_switches ) )
    {
        for ( i = 0; i < punch_switches.size; i++ )
        {
            punch_switches[i] notify( "trigger" );
            wait 0.5;
        }
    }

    if ( level.zones["conference_level2"].is_occupied )
    {
        wait 1;
        level thread start_defcon_countdown();
    }

    level waittill( "bonfire_sale_off" );

    if ( level.defcon_activated == 1 || level.zones["conference_level2"].is_occupied )
        return;
    else
    {
        flag_clear( "defcon_active" );
        level thread regular_portal_fx_on();
        level.defcon_level = 1;
        level notify( "pack_room_reset" );
        level thread defcon_sign_lights();
    }

    flag_clear( "bonfire_reset" );
}

pentagon_validate_enemy_path_length( player )
{
    max_dist = 1296;
    d = distancesquared( self.origin, player.origin );

    if ( d <= max_dist )
        return true;

    return false;
}

lab_shutters_init()
{
    shutters = getentarray( "lab_shutter", "script_noteworthy" );

    if ( isdefined( shutters ) )
    {
        for ( i = 0; i < shutters.size; i++ )
            shutters[i] thread lab_shutters_think();
    }
}

lab_shutters_think()
{
    door_pos = self.origin;
    time = 1;
    scale = 1;

    if ( isdefined( self.script_flag ) && !flag( self.script_flag ) )
    {
        flag_wait( self.script_flag );

        if ( flag( "thief_round" ) )
        {
            while ( flag( "thief_round" ) )
                wait 0.5;
        }

        if ( isdefined( self.script_vector ) )
        {
            vector = vectorscale( self.script_vector, scale );
            thief_vector = vectorscale( self.script_vector, 0.2 );

            while ( true )
            {
                self moveto( door_pos + vector, time, time * 0.25, time * 0.25 );
                self thread maps\mp\zombies\_zm_blockers::door_solid_thread();
                flag_wait( "thief_round" );
                self moveto( door_pos + thief_vector, time, time * 0.25, time * 0.25 );
                self thread maps\mp\zombies\_zm_blockers::door_solid_thread();

                while ( flag( "thief_round" ) )
                    wait 0.5;
            }
        }
    }
}

play_starting_vox()
{
    flag_wait( "start_zombie_round_logic" );
    level thread maps\mp\zm_pentagon_amb::play_pentagon_announcer_vox( "zmb_vox_pentann_levelstart" );
}

pentagon_brush_lights_init()
{
    sbrush_office_ceiling_lights_off = getentarray( "sbrushmodel_interior_office_lights", "targetname" );

    if ( isdefined( sbrush_office_ceiling_lights_off ) && sbrush_office_ceiling_lights_off.size > 0 )
        array_thread( sbrush_office_ceiling_lights_off, ::pentagon_brush_lights );
}

pentagon_brush_lights()
{
    if ( !isdefined( self.target ) )
        return;

    self.off_version = getent( self.target, "targetname" );
    self.off_version hide();
    flag_wait( "power_on" );
    self hide();
    self.off_version show();
}

pentagon_precache()
{
    precachemodel( "zombie_zapper_cagelight_red" );
    precachemodel( "zombie_zapper_cagelight_green" );
    precacheshellshock( "electrocution" );
    precachemodel( "viewmodel_usa_pent_officeworker_arms" );
    precachemodel( "c_zom_suit_viewhands" );
    precachemodel( "zombie_trap_switch" );
    precachemodel( "zombie_trap_switch_light" );
    precachemodel( "zombie_trap_switch_light_on_green" );
    precachemodel( "zombie_trap_switch_light_on_red" );
    precachemodel( "zombie_trap_switch_handle" );
    precachemodel( "p_zom_monitor_screen_fsale1" );
    precachemodel( "p_zom_monitor_screen_fsale2" );
    precachemodel( "p_zom_monitor_screen_labs0" );
    precachemodel( "p_zom_monitor_screen_labs1" );
    precachemodel( "p_zom_monitor_screen_labs2" );
    precachemodel( "p_zom_monitor_screen_labs3" );
    precachemodel( "p_zom_monitor_screen_lobby0" );
    precachemodel( "p_zom_monitor_screen_lobby1" );
    precachemodel( "p_zom_monitor_screen_lobby2" );
    precachemodel( "p_zom_monitor_screen_logo" );
    precachemodel( "p_zom_monitor_screen_off" );
    precachemodel( "p_zom_monitor_screen_on" );
    precachemodel( "p_zom_monitor_screen_warroom0" );
    precachemodel( "p_zom_monitor_screen_warroom1" );
    precachemodel( "p_pent_light_ceiling" );
    precachemodel( "p_pent_light_tinhat_off" );
    precachemodel( "p_rus_rb_lab_warning_light_01" );
    precachemodel( "p_rus_rb_lab_warning_light_01_off" );
    precachemodel( "p_rus_rb_lab_light_core_on" );
    precachemodel( "p_rus_rb_lab_light_core_off" );
    precachemodel( "p_zm_pent_defcon_sign_02" );
    precachemodel( "p_zm_pent_defcon_sign_03" );
    precachemodel( "p_zm_pent_defcon_sign_04" );
    precachemodel( "p_zm_pent_defcon_sign_05" );
}

zombie_warroom_barricade_fix()
{
    precachemodel( "collision_wall_128x128x10" );
    wait 1;
    collision = spawn( "script_model", ( -1219, 2039, -241 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    flag_wait( "war_room_stair" );
    collision delete();
}

barricade_glitch_fix()
{
    precachemodel( "collision_wall_64x64x10" );
    precachemodel( "collision_geo_64x64x64" );
    collision = spawn( "script_model", ( -270, 2318, 184 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -270, 2712, 184 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -1215, 3426, -547 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -2361, 1871, -347 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
    collision = spawn( "script_model", ( -1675, 3754, -547 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -875, 3395, -579 ) );
    collision setmodel( "collision_wall_64x64x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -644, 1960, -448 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -794, 1801, -449 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
    collision = spawn( "script_model", ( -959, 1801, -449 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
    collision = spawn( "script_model", ( -640, 1324, -211 ) );
    collision setmodel( "collision_geo_64x64x64" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 342.6 );
    collision hide();
    collision = spawn( "script_model", ( -774, 1390, -189 ) );
    collision setmodel( "collision_geo_64x64x64" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 341.6 );
    collision hide();
    collision = spawn( "script_model", ( -1763, 2212, -449 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -381, 4988, -545 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision = spawn( "script_model", ( -644, 1960, -448 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision hide();
    collision2 = spawn( "script_model", ( -653, 1987, -480 ) );
    collision2 setmodel( "collision_wall_128x128x10" );
    collision2.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
    collision2 hide();
    collision3 = spawn( "script_model", ( -493, 2037, -448 ) );
    collision3 setmodel( "collision_wall_128x128x10" );
    collision3.angles = ( 0, 0, 0 );
    collision3 hide();
    collision = spawn( "script_model", ( -2116, 2300, -347 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
    collision = spawn( "script_model", ( -568, 5354, -648 ) );
    collision setmodel( "collision_wall_128x128x10" );
    collision.angles = ( 0, 0, 0 );
    collision hide();
    collision2 = spawn( "script_model", ( -1100, 2243, -407 ) );
    collision2 setmodel( "collision_wall_64x64x10" );
    collision2.angles = ( 0, 0, 0 );
    collision2 hide();
    collision3 = spawn( "script_model", ( -1063, 2271, -407 ) );
    collision3 setmodel( "collision_wall_64x64x10" );
    collision3.angles = vectorscale( ( 0, 1, 0 ), 60.8 );
    collision3 hide();
    collision4 = spawn( "script_model", ( -1019, 2300, -407 ) );
    collision4 setmodel( "collision_wall_64x64x10" );
    collision4.angles = vectorscale( ( 0, 1, 0 ), 6.19994 );
    collision4 hide();
}

custom_add_weapons()
{
    add_zombie_weapon( "m1911_zm", "m1911_upgraded_zm", &"ZOMBIE_WEAPON_M1911", 50, "pistol", "", undefined );
    add_zombie_weapon( "python_zm", "python_upgraded_zm", &"ZOMBIE_WEAPON_PYTHON", 50, "pistol", "", undefined );
    add_zombie_weapon( "ak74u_zm", "ak74u_upgraded_zm", &"ZOMBIE_WEAPON_AK74U", 1200, "smg", "", undefined );
    add_zombie_weapon( "mp5k_zm", "mp5k_upgraded_zm", &"ZOMBIE_WEAPON_MP5K", 1000, "smg", "", undefined );
    add_zombie_weapon( "srm1216_zm", "srm1216_upgraded_zm", &"ZOMBIE_WEAPON_SRM1216", 50, "wpck_m1216", "", undefined, 1 );
    add_zombie_weapon( "rottweil72_zm", "rottweil72_upgraded_zm", &"ZOMBIE_WEAPON_ROTTWEIL72", 500, "shotgun", "", undefined );
    add_zombie_weapon( "m14_zm", "m14_upgraded_zm", &"ZOMBIE_WEAPON_M14", 500, "rifle", "", undefined );
    add_zombie_weapon( "m16_zm", "m16_gl_upgraded_zm", &"ZOMBIE_WEAPON_M16", 1200, "burstrifle", "", undefined );
    add_zombie_weapon( "galil_zm", "galil_upgraded_zm", &"ZOMBIE_WEAPON_GALIL", 50, "assault", "", undefined );
    add_zombie_weapon( "sa58_zm", "sa58_upgraded_zm", &"ZOMBIE_WEAPON_SA58", 50, "burstrifle", "", undefined );
    add_zombie_weapon( "frag_grenade_zm", undefined, &"ZOMBIE_WEAPON_FRAG_GRENADE", 250, "grenade", "", undefined );
    add_zombie_weapon( "sticky_grenade_zm", undefined, &"ZOMBIE_WEAPON_STICKY_GRENADE", 250, "grenade", "", undefined );
    add_zombie_weapon( "claymore_zm", undefined, &"ZOMBIE_WEAPON_CLAYMORE", 1000, "grenade", "", undefined );
    add_zombie_weapon( "cymbal_monkey_zm", undefined, &"ZOMBIE_WEAPON_SATCHEL_2000", 2000, "monkey", "", undefined );
    add_zombie_weapon( "ray_gun_zm", "ray_gun_upgraded_zm", &"ZOMBIE_WEAPON_RAYGUN", 10000, "raygun", "", undefined );
    add_zombie_weapon( "knife_ballistic_zm", "knife_ballistic_upgraded_zm", &"ZOMBIE_WEAPON_KNIFE_BALLISTIC", 10, "sickle", "", undefined );
    add_zombie_weapon( "knife_ballistic_bowie_zm", "knife_ballistic_bowie_upgraded_zm", &"ZOMBIE_WEAPON_KNIFE_BALLISTIC", 10, "sickle", "", undefined );
    add_zombie_weapon( "knife_ballistic_no_melee_zm", "knife_ballistic_no_melee_upgraded_zm", &"ZOMBIE_WEAPON_KNIFE_BALLISTIC", 10, "sickle", "", undefined );
    add_zombie_weapon( "fiveseven_zm", "fiveseven_upgraded_zm", &"ZOMBIE_WEAPON_FIVESEVEN", 50, "wpck_57", "", undefined, 1 );
    add_zombie_weapon( "mp40_zm", "mp40_upgraded_zm", &"ZOMBIE_WEAPON_MP40", 1000, "smg", "", undefined );
    add_zombie_weapon( "beretta93r_zm", "beretta93r_upgraded_zm", &"ZOMBIE_WEAPON_BERETTA93r", 1000, "smg", "", undefined );
    add_zombie_weapon( "pdw57_zm", "pdw57_upgraded_zm", &"ZOMBIE_WEAPON_PDW57", 1000, "smg", "", undefined );
    add_zombie_weapon( "kard_zm", "kard_upgraded_zm", &"ZOMBIE_WEAPON_KARD", 50, "wpck_kap", "", undefined, 1 );
    add_zombie_weapon( "fivesevendw_zm", "fivesevendw_upgraded_zm", &"ZOMBIE_WEAPON_FIVESEVENDW", 50, "dualwield", "", undefined );
    add_zombie_weapon( "870mcs_zm", "870mcs_upgraded_zm", &"ZOMBIE_WEAPON_870MCS", 1500, "shotgun", "", undefined );
    add_zombie_weapon( "saiga12_zm", "saiga12_upgraded_zm", &"ZOMBIE_WEAPON_SAIGA12", 50, "shotgun", "", undefined );
    add_zombie_weapon( "xm8_zm", "xm8_upgraded_zm", &"ZOMBIE_WEAPON_XM8", 900, "burstrifle", "", undefined );
    add_zombie_weapon( "type95_zm", "type95_upgraded_zm", &"ZOMBIE_WEAPON_TYPE95", 50, "wpck_type25", "", undefined, 1 );
    add_zombie_weapon( "tar21_zm", "tar21_upgraded_zm", &"ZOMBIE_WEAPON_TAR21", 1200, "wpck_x951", "", undefined, 1 );
    add_zombie_weapon( "hk416_zm", "hk416_upgraded_zm", &"ZOMBIE_WEAPON_HK416", 100, "assault", "", undefined );
    add_zombie_weapon( "barretm82_zm", "barretm82_upgraded_zm", &"ZOMBIE_WEAPON_BARRETM82", 2500, "sniper", "", undefined );
    add_zombie_weapon( "dsr50_zm", "dsr50_upgraded_zm", &"ZOMBIE_WEAPON_DSR50", 50, "sniper", "", undefined );
    add_zombie_weapon( "rpd_zm", "rpd_upgraded_zm", &"ZOMBIE_WEAPON_RPD", 4000, "mg", "", undefined );
    add_zombie_weapon( "hamr_zm", "hamr_upgraded_zm", &"ZOMBIE_WEAPON_HAMR", 50, "mg", "", undefined );
    add_zombie_weapon( "usrpg_zm", "usrpg_upgraded_zm", &"ZOMBIE_WEAPON_USRPG", 2000, "launcher", "", undefined );
    add_zombie_weapon( "m32_zm", "m32_upgraded_zm", &"ZOMBIE_WEAPON_M32", 2000, "wpck_m32", "", undefined, 1 );
    add_zombie_weapon( "freezegun_zm", "freezegun_upgraded_zm", &"ZOMBIE_WEAPON_FREEZEGUN", 10, "freezegun", "", undefined );
}

precachecustomcharacters()
{
    character\c_usa_jfk_zt::precache();
    character\c_usa_mcnamara_zt::precache();
    character\c_usa_nixon_zt::precache();
    character\c_cub_castro_zt::precache();
    precachemodel( "viewmodel_usa_pow_arms" );
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

givecustomcharacters()
{
    self detachall();

    switch ( self selectcharacterindextouse() )
    {
        case 0:
            self character\c_usa_jfk_zt::main();
            self setviewmodel( "c_zom_suit_viewhands" );
            self.characterindex = 0;
            break;
        case 1:
            self character\c_usa_mcnamara_zt::main();
            self setviewmodel( "c_zom_suit_viewhands" );
            self.characterindex = 1;
            break;
        case 2:
            self character\c_usa_nixon_zt::main();
            self setviewmodel( "c_zom_suit_viewhands" );
            self.characterindex = 2;
            break;
        case 3:
            self character\c_cub_castro_zt::main();
            self setviewmodel( "viewmodel_usa_pent_officeworker_arms" );
            self.characterindex = 3;
            break;
    }

    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
}

givecustomloadout( takeallweapons, alreadyspawned )
{
    self giveweapon( "knife_zm" );
    self give_start_weapon( 1 );
}

offhand_weapon_overrride()
{
    register_lethal_grenade_for_level( "frag_grenade_zm" );
    level.zombie_lethal_grenade_player_init = "frag_grenade_zm";
    register_tactical_grenade_for_level( "cymbal_monkey_zm" );
    level.zombie_tactical_grenade_player_init = undefined;
    register_placeable_mine_for_level( "claymore_zm" );
    level.zombie_placeable_mine_player_init = undefined;
    register_melee_weapon_for_level( "knife_zm" );
    register_melee_weapon_for_level( "bowie_knife_zm" );
    level.zombie_melee_weapon_player_init = "knife_zm";
    level._allow_melee_weapon_switching = 1;
}

pentagon_quad_ai_init_override()
{
    init_quad_zombie_fx();
    level.quad_spawners = getentarray( "quad_zombie_spawner", "script_noteworthy" );
    array_thread( level.quad_spawners, ::add_spawn_function, maps\mp\zombies\_zm_ai_quad::quad_prespawn );
}

init_level_specific_wall_buy_fx()
{
    level._effect["pdw57_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_pdw57" );
    level._effect["frag_grenade_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_frag_nade" );
}

pentagon_zbarrier_init_override( zbarrier )
{
    self.zbarrier = zbarrier;
    m_collision = isdefined( self.zbarrier.script_string ) ? self.zbarrier.script_string : "p6_anim_zm_barricade_board_collision";
    precachemodel( m_collision );
    self.zbarrier setzbarriercolmodel( m_collision );
    self.zbarrier.chunk_health = [];

    for ( i = 0; i < self.zbarrier getnumzbarrierpieces(); i++ )
        self.zbarrier.chunk_health[i] = 0;

    if ( isdefined( self.zbarrier.target ) )
    {
        self.zbarrier.dynents = getentarray( self.zbarrier.target, "targetname" );

        for ( i = 0; i < self.zbarrier.dynents.size; i++ )
            self.zbarrier.dynents[i] thread blocked_dynent_wait_for_damage( self.zbarrier );
    }
}

blocked_dynent_wait_for_damage( zbarrier )
{
    self endon( "torn_down" );
    assert( isdefined( self.script_int ) );
    zbarrier hidezbarrierpiece( self.script_int );
    self setcandamage( 1 );
    self.health = 99999;
    self thread wait_on_teardown( self.script_int, zbarrier );
    self waittill( "damage" );
    zbarrier setzbarrierpiecestate( self.script_int, "open" );
    self delete();
}

wait_on_teardown( piece_index, zbarrier )
{
    self endon( "damage" );

    for ( piece_state = "closed"; piece_state != "open" && piece_state != "opening"; piece_state = zbarrier getzbarrierpiecestate( piece_index ) )
        wait 0.05;

    self notify( "torn_down" );
    self delete();
}
