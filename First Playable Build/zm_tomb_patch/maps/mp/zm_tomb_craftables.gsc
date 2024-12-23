// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_ai_quadrotor;
#include maps\mp\zombies\_zm_equipment;

randomize_craftable_spawns()
{
    a_randomized_craftables = array( "gramophone_vinyl_ice", "gramophone_vinyl_air", "gramophone_vinyl_elec", "gramophone_vinyl_fire", "gramophone_vinyl_master", "gramophone_vinyl_player" );

    foreach ( str_craftable in a_randomized_craftables )
    {
        s_original_pos = getstruct( str_craftable, "targetname" );
        s_original_pos thread puzzle_debug_position( "C", vectorscale( ( 0, 1, 0 ), 255.0 ) );
        a_alt_locations = getstructarray( str_craftable + "_alt", "targetname" );
        n_loc_index = randomintrange( 0, a_alt_locations.size + 1 );

        if ( n_loc_index == a_alt_locations.size )
            continue;
        else
        {
            s_original_pos.origin = a_alt_locations[n_loc_index].origin;
            s_original_pos.angles = a_alt_locations[n_loc_index].angles;
        }
    }
}

init_craftables()
{
    level.craftable_piece_count = 4;
    register_clientfields();
    add_zombie_craftable( "equip_dieseldrone_zm", &"ZM_TOMB_CRAFT_QUADROTOR", &"ZM_TOMB_CRAFT_QUADROTOR", &"ZM_TOMB_TAKE_QUADROTOR", ::onfullycrafted_quadrotor, 1 );
    make_zombie_craftable_open( "equip_dieseldrone_zm", "veh_t6_dlc_zm_quadrotor", ( 0, 0, 0 ), ( 0, -4, 10 ) );
    add_zombie_craftable( "alcatraz_shield_zm", &"ZM_PRISON_CRAFT_RIOT", undefined, &"ZOMBIE_BOUGHT_RIOT", undefined, 1 );
    make_zombie_craftable_open( "alcatraz_shield_zm", "t6_wpn_zmb_shield_dlc2_dmg0_world", vectorscale( ( 0, -1, 0 ), 90.0 ), ( 0, 0, level.riotshield_placement_zoffset ) );
    add_zombie_craftable( "elemental_staff_fire", &"ZM_TOMB_CRAFT_FIRE_STAFF", &"ZM_TOMB_INSERT_CRYSTAL", &"ZM_TOMB_BOUGHT_FIRE", ::staff_fire_fullycrafted, 1 );
    add_zombie_craftable( "elemental_staff_air", &"ZM_TOMB_CRAFT_AIR_STAFF", &"ZM_TOMB_INSERT_CRYSTAL", &"ZM_TOMB_BOUGHT_AIR", ::staff_air_fullycrafted, 1 );
    add_zombie_craftable( "elemental_staff_lightning", &"ZM_TOMB_CRAFT_LIGHTNING_STAFF", &"ZM_TOMB_INSERT_CRYSTAL", &"ZM_TOMB_BOUGHT_LIGHTNING", ::staff_lightning_fullycrafted, 1 );
    add_zombie_craftable( "elemental_staff_water", &"ZM_TOMB_CRAFT_WATER_STAFF", &"ZM_TOMB_INSERT_CRYSTAL", &"ZM_TOMB_BOUGHT_WATER", ::staff_water_fullycrafted, 1 );
    add_zombie_craftable( "gramophone", &"ZM_TOMB_CRAFT_GRAMOPHONE", &"ZM_TOMB_CRAFT_GRAMOPHONE", &"ZM_TOMB_BOUGHT_GRAMOPHONE", undefined, 0 );
    level.zombie_craftable_persistent_weapon = ::tomb_check_crafted_weapon_persistence;
    level.custom_craftable_validation = ::tomb_custom_craftable_validation;
    level.zombie_custom_equipment_setup = ::setup_quadrotor_purchase;
    level thread hide_staff_model();
    level.quadrotor_status = spawnstruct();
    level.quadrotor_status.crafted = 0;
    level.quadrotor_status.picked_up = 0;
}

craftables_debug()
{
/#
    s_start_pos = getstruct( "elemental_staff_piece_debug", "targetname" );
    v_pos = s_start_pos.origin;
    v_fwd = anglestoforward( s_start_pos.angles );
    a_part_locations = getstructarray( "elemental_staff_piece", "script_noteworthy" );
    a_part_locations = arraycombine( a_part_locations, getstructarray( "gramophone_part", "script_noteworthy" ), 1, 0 );
    a_piece_order = array( "fire", "water", "air", "lightning", "gramophone" );
    element_number = 0;

    foreach ( str_element in a_piece_order )
    {
        v_pos = s_start_pos.origin + anglestoright( s_start_pos.angles ) * element_number * 68.0;

        foreach ( s_staff_piece in a_part_locations )
        {
            if ( issubstr( s_staff_piece.targetname, str_element ) )
            {
                v_pos = v_pos + v_fwd * 32.0;
                s_staff_piece.origin = v_pos;
            }
        }

        element_number++;
    }
#/
}

add_craftable_cheat( craftable )
{
/#
    if ( !isdefined( level.cheat_craftables ) )
        level.cheat_craftables = [];

    foreach ( s_piece in craftable.a_piecestubs )
    {
        id_string = undefined;
        client_field_val = undefined;

        if ( isdefined( s_piece.client_field_id ) )
        {
            id_string = s_piece.client_field_id;
            client_field_val = id_string;
        }
        else if ( isdefined( s_piece.client_field_state ) )
        {
            id_string = "gem";
            client_field_val = s_piece.client_field_state;
        }
        else
            continue;

        tokens = strtok( id_string, "_" );
        display_string = "piece";

        foreach ( token in tokens )
        {
            if ( token != "piece" && token != "staff" && token != "zm" )
                display_string = display_string + "_" + token;
        }

        level.cheat_craftables["" + client_field_val] = s_piece;
        adddebugcommand( "devgui_cmd \"Zombies/Tomb:1/Craftables:1/" + craftable.name + "/" + display_string + "\" \"give_craftable " + client_field_val + "\"\n" );
        s_piece.waste = "waste";
    }
#/
}

run_craftables_devgui()
{
/#
    setdvar( "give_craftable", "" );

    while ( true )
    {
        craftable_id = getdvar( #"_id_817E2753" );

        if ( craftable_id != "" )
        {
            piece_spawn = level.cheat_craftables[craftable_id].piecespawn;

            if ( isdefined( piece_spawn ) )
            {
                players = getplayers();
                players[0] maps\mp\zombies\_zm_craftables::player_take_piece( piece_spawn );
            }

            setdvar( "give_craftable", "" );
        }

        wait 0.05;
    }
#/
}

include_craftables()
{
    if ( getdvarint( #"_id_3152944D" ) > 0 )
        craftables_debug();

    level thread run_craftables_devgui();
    craftable_name = "equip_dieseldrone_zm";
    quadrotor_body = generate_zombie_craftable_piece( craftable_name, "body", "veh_t6_dlc_zm_quad_piece_body", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_body", 1 );
    quadrotor_brain = generate_zombie_craftable_piece( craftable_name, "brain", "veh_t6_dlc_zm_quad_piece_brain", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_brain", 1 );
    quadrotor_engine = generate_zombie_craftable_piece( craftable_name, "engine", "veh_t6_dlc_zm_quad_piece_engine", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_engine", 1 );
    quadrotor = spawnstruct();
    quadrotor.name = craftable_name;
    quadrotor add_craftable_piece( quadrotor_body );
    quadrotor add_craftable_piece( quadrotor_brain );
    quadrotor add_craftable_piece( quadrotor_engine );
    quadrotor.triggerthink = ::quadrotorcraftable;
    include_zombie_craftable( quadrotor );
    add_craftable_cheat( quadrotor );
    craftable_name = "alcatraz_shield_zm";
    riotshield_dolly = generate_zombie_craftable_piece( craftable_name, "dolly", "t6_wpn_zmb_shield_dlc2_dolly", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs" );
    riotshield_door = generate_zombie_craftable_piece( craftable_name, "door", "t6_wpn_zmb_shield_dlc2_door", 48, 15, 25, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs" );
    riotshield_clamp = generate_zombie_craftable_piece( craftable_name, "clamp", "t6_wpn_zmb_shield_dlc2_shackles", 32, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs" );
    riotshield = spawnstruct();
    riotshield.name = craftable_name;
    riotshield add_craftable_piece( riotshield_dolly );
    riotshield add_craftable_piece( riotshield_door );
    riotshield add_craftable_piece( riotshield_clamp );
    riotshield.onbuyweapon = ::onbuyweapon_riotshield;
    riotshield.triggerthink = ::riotshieldcraftable;
    include_craftable( riotshield );
    craftable_name = "elemental_staff_air";
    staff_air_gem = generate_zombie_craftable_piece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_air_world", 48, 64, 0, undefined, ::onpickup_aircrystal, ::ondrop_aircrystal, undefined, undefined, undefined, undefined, 1, 0 );
    staff_air_upper_staff = generate_zombie_craftable_piece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_air", 1 );
    staff_air_middle_staff = generate_zombie_craftable_piece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_air", 1 );
    staff_air_lower_staff = generate_zombie_craftable_piece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_air", 1 );
    staff = spawnstruct();
    staff.name = craftable_name;
    staff add_craftable_piece( staff_air_gem );
    staff add_craftable_piece( staff_air_upper_staff );
    staff add_craftable_piece( staff_air_middle_staff );
    staff add_craftable_piece( staff_air_lower_staff );
    staff.triggerthink = ::staffcraftable_air;
    staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
    include_zombie_craftable( staff );
    add_craftable_cheat( staff );
    count_staff_piece_pickup( array( staff_air_upper_staff, staff_air_middle_staff, staff_air_lower_staff ) );
    craftable_name = "elemental_staff_fire";
    staff_fire_gem = generate_zombie_craftable_piece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_fire_world", 48, 64, 0, undefined, ::onpickup_firecrystal, ::ondrop_firecrystal, undefined, undefined, undefined, undefined, 2, 0 );
    staff_fire_upper_staff = generate_zombie_craftable_piece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_fire", 1 );
    staff_fire_middle_staff = generate_zombie_craftable_piece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_fire", 1 );
    staff_fire_lower_staff = generate_zombie_craftable_piece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_fire", 1 );

    if ( getdvarint( #"_id_3152944D" ) <= 0 )
    {
        level thread maps\mp\zm_tomb_main_quest::staff_mechz_drop_pieces( array( staff_fire_lower_staff ) );
        level thread maps\mp\zm_tomb_main_quest::staff_biplane_drop_pieces( array( staff_fire_middle_staff ) );
        level thread maps\mp\zm_tomb_main_quest::staff_unlock_with_zone_capture( staff_fire_upper_staff, "zone_village_1" );
    }

    staff = spawnstruct();
    staff.name = craftable_name;
    staff add_craftable_piece( staff_fire_gem );
    staff add_craftable_piece( staff_fire_upper_staff );
    staff add_craftable_piece( staff_fire_middle_staff );
    staff add_craftable_piece( staff_fire_lower_staff );
    staff.triggerthink = ::staffcraftable_fire;
    staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
    include_zombie_craftable( staff );
    add_craftable_cheat( staff );
    count_staff_piece_pickup( array( staff_fire_upper_staff, staff_fire_middle_staff, staff_fire_lower_staff ) );
    craftable_name = "elemental_staff_lightning";
    staff_lightning_gem = generate_zombie_craftable_piece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_bolt_world", 48, 64, 0, undefined, ::onpickup_lightningcrystal, ::ondrop_lightningcrystal, undefined, undefined, undefined, undefined, 3, 0 );
    staff_lightning_upper_staff = generate_zombie_craftable_piece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_lightning", 1 );
    staff_lightning_middle_staff = generate_zombie_craftable_piece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_lightning", 1 );
    staff_lightning_lower_staff = generate_zombie_craftable_piece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_lightning", 1 );
    staff = spawnstruct();
    staff.name = craftable_name;
    staff add_craftable_piece( staff_lightning_gem );
    staff add_craftable_piece( staff_lightning_upper_staff );
    staff add_craftable_piece( staff_lightning_middle_staff );
    staff add_craftable_piece( staff_lightning_lower_staff );
    staff.triggerthink = ::staffcraftable_lightning;
    staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
    include_zombie_craftable( staff );
    add_craftable_cheat( staff );
    count_staff_piece_pickup( array( staff_lightning_upper_staff, staff_lightning_middle_staff, staff_lightning_lower_staff ) );
    craftable_name = "elemental_staff_water";
    staff_water_gem = generate_zombie_craftable_piece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_water_world", 48, 64, 0, undefined, ::onpickup_watercrystal, ::ondrop_watercrystal, undefined, undefined, undefined, undefined, 4, 0 );
    staff_water_upper_staff = generate_zombie_craftable_piece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_water", 1 );
    staff_water_middle_staff = generate_zombie_craftable_piece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_water", 1 );
    staff_water_lower_staff = generate_zombie_craftable_piece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_upg_world", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_water", 1 );
    a_ice_staff_parts = array( staff_water_lower_staff, staff_water_middle_staff, staff_water_upper_staff );

    if ( getdvarint( #"_id_3152944D" ) <= 0 )
        level thread maps\mp\zm_tomb_main_quest::staff_ice_dig_pieces( a_ice_staff_parts );

    staff = spawnstruct();
    staff.name = craftable_name;
    staff add_craftable_piece( staff_water_gem );
    staff add_craftable_piece( staff_water_upper_staff );
    staff add_craftable_piece( staff_water_middle_staff );
    staff add_craftable_piece( staff_water_lower_staff );
    staff.triggerthink = ::staffcraftable_water;
    staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
    include_zombie_craftable( staff );
    add_craftable_cheat( staff );
    count_staff_piece_pickup( array( staff_water_upper_staff, staff_water_middle_staff, staff_water_lower_staff ) );
    craftable_name = "gramophone";
    vinyl_pickup_player = vinyl_add_pickup( craftable_name, "vinyl_player", "p6_zm_tm_gramophone", "piece_record_zm_player" );
    vinyl_pickup_master = vinyl_add_pickup( craftable_name, "vinyl_master", "p6_zm_tm_record_master", "piece_record_zm_vinyl_master" );
    vinyl_pickup_air = vinyl_add_pickup( craftable_name, "vinyl_air", "p6_zm_tm_record_wind", "piece_record_zm_vinyl_air", "quest_state2" );
    vinyl_pickup_ice = vinyl_add_pickup( craftable_name, "vinyl_ice", "p6_zm_tm_record_ice", "piece_record_zm_vinyl_water", "quest_state4" );
    vinyl_pickup_fire = vinyl_add_pickup( craftable_name, "vinyl_fire", "p6_zm_tm_record_fire", "piece_record_zm_vinyl_fire", "quest_state1" );
    vinyl_pickup_elec = vinyl_add_pickup( craftable_name, "vinyl_elec", "p6_zm_tm_record_lightning", "piece_record_zm_vinyl_lightning", "quest_state3" );
    gramophone = spawnstruct();
    gramophone.name = craftable_name;
    gramophone add_craftable_piece( vinyl_pickup_player );
    gramophone add_craftable_piece( vinyl_pickup_master );
    gramophone add_craftable_piece( vinyl_pickup_air );
    gramophone add_craftable_piece( vinyl_pickup_ice );
    gramophone add_craftable_piece( vinyl_pickup_fire );
    gramophone add_craftable_piece( vinyl_pickup_elec );
    gramophone.triggerthink = ::gramophonecraftable;
    include_zombie_craftable( gramophone );
    add_craftable_cheat( gramophone );
    staff_fire_gem thread watch_part_pickup( "quest_state1", 2 );
    staff_air_gem thread watch_part_pickup( "quest_state2", 2 );
    staff_lightning_gem thread watch_part_pickup( "quest_state3", 2 );
    staff_water_gem thread watch_part_pickup( "quest_state4", 2 );
}

register_clientfields()
{
    bits = 1;
    registerclientfield( "world", "piece_quadrotor_zm_body", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_quadrotor_zm_brain", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_quadrotor_zm_engine", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_riotshield_dolly", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_riotshield_door", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_riotshield_clamp", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_gem_air", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_ustaff_air", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_mstaff_air", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_lstaff_air", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_gem_fire", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_ustaff_fire", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_mstaff_fire", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_lstaff_fire", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_gem_lightning", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_ustaff_lightning", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_mstaff_lightning", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_lstaff_lightning", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_gem_water", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_ustaff_water", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_mstaff_water", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_staff_zm_lstaff_water", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_record_zm_player", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_record_zm_vinyl_master", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_record_zm_vinyl_air", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_record_zm_vinyl_water", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_record_zm_vinyl_fire", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "piece_record_zm_vinyl_lightning", 14000, bits, "int", undefined, 0 );
    registerclientfield( "scriptmover", "crystal_air_fx", 14000, 1, "int" );
    registerclientfield( "scriptmover", "crystal_fire_fx", 14000, 1, "int" );
    registerclientfield( "scriptmover", "crystal_lightning_fx", 14000, 1, "int" );
    registerclientfield( "scriptmover", "crystal_water_fx", 14000, 1, "int" );
    bits = 3;
    registerclientfield( "world", "segments_staff1", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "segments_staff2", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "segments_staff3", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "segments_staff4", 14000, bits, "int", undefined, 0 );
    bits = getminbitcountfornum( 5 );
    registerclientfield( "world", "staff_player1", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "staff_player2", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "staff_player3", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "staff_player4", 14000, bits, "int", undefined, 0 );
    bits = getminbitcountfornum( 5 );
    registerclientfield( "world", "quest_state1", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "quest_state2", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "quest_state3", 14000, bits, "int", undefined, 0 );
    registerclientfield( "world", "quest_state4", 14000, bits, "int", undefined, 0 );
    registerclientfield( "toplayer", "sndMudSlow", 14000, 1, "int" );
}

tomb_staff_update_prompt( player, b_set_hint_string_now, trigger )
{
    if ( isdefined( self.crafted ) && self.crafted )
        return true;

    self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";

    if ( isdefined( player ) )
    {
        if ( !isdefined( player.current_craftable_piece ) )
            return false;

        if ( !self.craftablespawn craftable_has_piece( player.current_craftable_piece ) )
        {
            self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
            return false;
        }
    }

    if ( level.staff_part_count[self.craftablespawn.craftable_name] == 0 )
    {
        self.hint_string = level.zombie_craftablestubs[self.equipname].str_to_craft;
        return true;
    }
    else
        return false;
}

quadrotorcraftable()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "quadrotor_zm_craftable_trigger", "equip_dieseldrone_zm", "equip_dieseldrone_zm", &"ZM_TOMB_TAKE_QUADROTOR", 1, 1 );
}

riotshieldcraftable()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "riotshield_zm_craftable_trigger", "alcatraz_shield_zm", "alcatraz_shield_zm", &"ZOMBIE_GRAB_RIOTSHIELD", 1, 1 );
}

staffcraftable_air()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "staff_air_craftable_trigger", "elemental_staff_air", "staff_air_zm", &"ZM_TOMB_TAKE_AIR_STAFF", 1, 1 );
}

staffcraftable_fire()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "staff_fire_craftable_trigger", "elemental_staff_fire", "staff_fire_zm", &"ZM_TOMB_TAKE_FIRE_STAFF", 1, 1 );
}

staffcraftable_lightning()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "staff_lightning_craftable_trigger", "elemental_staff_lightning", "staff_lightning_zm", &"ZM_TOMB_TAKE_LIGHTNING_STAFF", 1, 1 );
}

staffcraftable_water()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "staff_water_craftable_trigger", "elemental_staff_water", "staff_water_zm", &"ZM_TOMB_TAKE_WATER_STAFF", 1, 1 );
}

gramophonecraftable()
{
    maps\mp\zombies\_zm_craftables::craftable_trigger_think( "gramophone_craftable_trigger", "gramophone", "gramophone", &"ZOMBIE_GRAB_GRAMOPHONE", 1, 1 );
}

tankcraftableupdateprompt( player, sethintstringnow, buildabletrigger )
{
    if ( level.vh_tank getspeedmph() > 0.0 )
    {
        if ( isdefined( self ) )
        {
            self.hint_string = "";

            if ( isdefined( sethintstringnow ) && sethintstringnow && isdefined( buildabletrigger ) )
                buildabletrigger sethintstring( self.hint_string );
        }

        return false;
    }

    return true;
}

ondrop_common( player )
{
    self.piece_owner = undefined;
}

ondrop_crystal( player )
{
    ondrop_common( player );
    s_piece = self.piecestub;
    s_piece.piecespawn.canmove = 1;
    maps\mp\zombies\_zm_unitrigger::reregister_unitrigger_as_dynamic( s_piece.piecespawn.unitrigger );
    s_original_pos = getstruct( self.craftablename + "_" + self.piecename );
    s_piece.piecespawn.unitrigger trigger_off();
    s_piece.piecespawn.model ghost();
    s_piece.piecespawn.model moveto( s_original_pos.origin, 0.05 );
    s_piece.piecespawn.model waittill( "movedone" );
    s_piece.piecespawn.model show();
    s_piece.piecespawn.unitrigger trigger_on();
}

ondrop_firecrystal( player )
{
    level setclientfield( "piece_staff_zm_gem_fire", 0 );
    ondrop_crystal( player );
}

ondrop_aircrystal( player )
{
    level setclientfield( "piece_staff_zm_gem_air", 0 );
    ondrop_crystal( player );
}

ondrop_lightningcrystal( player )
{
    level setclientfield( "piece_staff_zm_gem_lightning", 0 );
    ondrop_crystal( player );
}

ondrop_watercrystal( player )
{
    level setclientfield( "piece_staff_zm_gem_water", 0 );
    ondrop_crystal( player );
}

onpickup_common( player )
{
    player playsound( "zmb_craftable_pickup" );
    self.piece_owner = player;
/#
    foreach ( spawn in self.spawns )
        spawn notify( "stop_debug_position" );
#/
}

onpickup_crystal( player, elementname, elementenum )
{
    onpickup_common( player );
    level setclientfield( "piece_staff_zm_gem_" + elementname, 1 );
    n_player = player getentitynumber() + 1;
    level setclientfield( "staff_player" + n_player, elementenum );
}

onpickup_firecrystal( player )
{
    onpickup_crystal( player, "fire", 1 );
}

onpickup_aircrystal( player )
{
    onpickup_crystal( player, "air", 2 );
}

onpickup_lightningcrystal( player )
{
    onpickup_crystal( player, "lightning", 3 );
}

onpickup_watercrystal( player )
{
    onpickup_crystal( player, "water", 4 );
}

vinyl_add_pickup( str_craftable_name, str_piece_name, str_model_name, str_bit_clientfield, str_quest_clientfield )
{
    craftable = generate_zombie_craftable_piece( str_craftable_name, str_piece_name, str_model_name, 32, 62, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, str_bit_clientfield, 1 );
    craftable thread watch_part_pickup( str_quest_clientfield, 1 );
    return craftable;
}

watch_part_pickup( str_quest_clientfield, n_clientfield_val )
{
    flag_wait( "start_zombie_round_logic" );
    self.piecespawn waittill( "pickup" );
    level notify( self.craftablename + "_" + self.piecename + "_picked_up" );

    if ( isdefined( str_quest_clientfield ) && isdefined( n_clientfield_val ) )
        level setclientfield( str_quest_clientfield, n_clientfield_val );
}

count_staff_piece_pickup( a_staff_pieces )
{
    if ( !isdefined( level.staff_part_count ) )
        level.staff_part_count = [];

    str_name = a_staff_pieces[0].craftablename;
    level.staff_part_count[str_name] = a_staff_pieces.size;

    foreach ( piece in a_staff_pieces )
    {
        assert( piece.craftablename == str_name );
        piece thread watch_staff_pickup();
    }
}

watch_staff_pickup()
{
    flag_wait( "start_zombie_round_logic" );
    self.piecespawn waittill( "pickup" );
    level.staff_part_count[self.craftablename]--;
}

onfullycrafted_quadrotor( player )
{
    level.quadrotor_status.crafted = 1;
    return true;
}

onbuyweapon_riotshield( player )
{
    if ( isdefined( player.player_shield_reset_health ) )
        player [[ player.player_shield_reset_health ]]();

    if ( isdefined( player.player_shield_reset_location ) )
        player [[ player.player_shield_reset_location ]]();
}

staff_fullycrafted( player, modelname, elementenum )
{
    staff_model = getent( modelname, "targetname" );

    if ( !isdefined( staff_model.inused ) )
    {
        staff_model show();
        staff_model.inused = 1;
    }

    str_fieldname = "quest_state" + elementenum;
    level setclientfield( str_fieldname, 3 );
    return true;
}

staff_fire_fullycrafted( player )
{
    return staff_fullycrafted( player, "craftable_staff_fire_zm", 1 );
}

staff_air_fullycrafted( player )
{
    return staff_fullycrafted( player, "craftable_staff_air_zm", 2 );
}

staff_lightning_fullycrafted( player )
{
    return staff_fullycrafted( player, "craftable_staff_lightning_zm", 3 );
}

staff_water_fullycrafted( player )
{
    return staff_fullycrafted( player, "craftable_staff_water_zm", 4 );
}

quadrotor_watcher()
{
    self endon( "disconnect" );
    n_cooldown_interval = 60;
/#
    if ( getdvarint( #"_id_FA81816F" ) > 0 )
        n_cooldown_interval = 0.1;
#/
    self waittill( "equip_dieseldrone_zm_given" );

    while ( true )
    {
        if ( !self hasweapon( "equip_dieseldrone_zm" ) )
        {
            wait 0.1;
            continue;
        }

        quadrotor_set_unavailable();

        if ( self actionslottwobuttonpressed() )
        {
            self waittill( "weapon_change_complete" );
            weapons = self getweaponslistprimaries();
            self switchtoweapon( weapons[0] );
            self waittill( "weapon_change_complete" );

            if ( self hasweapon( "equip_dieseldrone_zm" ) )
            {
                self takeweapon( "equip_dieseldrone_zm" );
                self setactionslot( 2, "" );
            }

            qr = spawnvehicle( "veh_t6_dlc_zm_quadrotor", "quadrotor_ai", "heli_quadrotor_zm", self.origin + vectorscale( ( 0, 0, 1 ), 96.0 ), self.angles );
            qr.player_owner = self;
            qr.health = 200;
            qr makevehicleunusable();
            qr thread maps\mp\zombies\_zm_ai_quadrotor::quadrotor_think();
            qr thread follow_ent( self );
            wait 30;
            qr dodamage( 200, qr.origin );
            qr delete();
            wait( n_cooldown_interval );
            quadrotor_set_available();
        }

        wait 0.05;
    }
}

quadrotor_set_available()
{
    level.quadrotor_status.picked_up = 0;
    level.quadrotor_status.pickup_trig trigger_on();
    level.quadrotor_status.pickup_trig.model show();
}

quadrotor_set_unavailable()
{
    level.quadrotor_status.picked_up = 1;
    level.quadrotor_status.pickup_trig trigger_off();
    level.quadrotor_status.pickup_trig.model ghost();
}

sqcommoncraftable()
{
    level.sq_craftable = maps\mp\zombies\_zm_craftables::craftable_trigger_think( "sq_common_craftable_trigger", "sq_common", "sq_common", "", 1, 0 );
}

droponmover( player )
{

}

pickupfrommover()
{

}

setup_quadrotor_purchase( player )
{
    if ( self.stub.weaponname == "equip_dieseldrone_zm" )
    {
        if ( players_has_weapon( "equip_dieseldrone_zm" ) )
            return true;

        quadrotor = getentarray( "quadrotor_ai", "targetname" );

        if ( quadrotor.size >= 1 )
            return true;

        quadrotor_set_unavailable();
        player giveweapon( "equip_dieseldrone_zm" );
        player setweaponammoclip( "equip_dieseldrone_zm", 1 );

        if ( isdefined( self.stub.craftablestub.use_actionslot ) )
            player setactionslot( self.stub.craftablestub.use_actionslot, "weapon", "equip_dieseldrone_zm" );
        else
            player setactionslot( 2, "weapon", "equip_dieseldrone_zm" );

        player notify( "equip_dieseldrone_zm_given" );
        return true;
    }

    return false;
}

players_has_weapon( weaponname )
{
    players = getplayers();

    for ( i = 0; i < players.size; i++ )
    {
        if ( players[i] hasweapon( weaponname ) )
            return true;
    }

    return false;
}

tomb_custom_craftable_validation( player )
{
    if ( self.stub.equipname == "equip_dieseldrone_zm" )
    {
        level.quadrotor_status.pickup_trig = self.stub;

        if ( level.quadrotor_status.crafted )
            return !level.quadrotor_status.picked_up;
    }

    if ( !issubstr( self.stub.weaponname, "staff" ) )
        return 1;

    str_craftable = self.stub.equipname;

    if ( !( isdefined( level.craftables_crafted[str_craftable] ) && level.craftables_crafted[str_craftable] ) )
        return 1;

    if ( !player can_pickup_staff() )
        return 0;

    return 1;
}

tomb_check_crafted_weapon_persistence( player )
{
    if ( self.stub.equipname == "equip_dieseldrone_zm" )
    {
        if ( level.quadrotor_status.picked_up )
            return true;
        else if ( level.quadrotor_status.crafted )
            return false;
    }
    else if ( self.stub.weaponname == "staff_air_zm" || self.stub.weaponname == "staff_fire_zm" || self.stub.weaponname == "staff_lightning_zm" || self.stub.weaponname == "staff_water_zm" )
    {
        if ( self thread check_for_limited_weapon( self.stub.weaponname ) )
        {
            s_elemental_staff = get_staff_info_from_weapon_name( self.stub.weaponname, 0 );
            player maps\mp\zombies\_zm_weapons::weapon_give( s_elemental_staff.weapname, 0, 0 );

            if ( isdefined( level.zombie_craftablestubs[self.stub.equipname].str_taken ) )
                self.stub.hint_string = level.zombie_craftablestubs[self.stub.equipname].str_taken;
            else
                self.stub.hint_string = "";

            self sethintstring( self.stub.hint_string );
            player track_craftables_pickedup( self.stub.craftablespawn );
            model = getent( "craftable_" + self.stub.weaponname, "targetname" );
            model ghost();
            self.stub thread track_staff_weapon_respawn( player );
            set_player_staff( self.stub.weaponname, player );
        }
        else
        {
            self.stub.hint_string = "";
            self sethintstring( self.stub.hint_string );
        }

        return true;
    }

    return false;
}

check_for_limited_weapon( weapon )
{
    if ( !maps\mp\zombies\_zm_equipment::is_limited_equipment( weapon ) )
        return true;
    else
    {
        players = get_players();

        foreach ( player in players )
        {
            if ( isdefined( player ) && player has_weapon_or_upgrade( weapon ) )
                return false;
        }
    }

    return true;
}

get_staff_info_from_weapon_name( str_name, b_base_info_only )
{
    if ( !isdefined( b_base_info_only ) )
        b_base_info_only = 1;

    foreach ( s_staff in level.a_elemental_staffs )
    {
        if ( s_staff.weapname == str_name || s_staff.upgrade.weapname == str_name )
        {
            if ( s_staff.charger.is_charged && !b_base_info_only )
                return s_staff.upgrade;
            else
                return s_staff;
        }
    }

    return undefined;
}

track_staff_weapon_respawn( player )
{
    self trigger_off();

    if ( !isdefined( self.base_weaponname ) )
        self.base_weaponname = self.weaponname;

    s_elemental_staff = get_staff_info_from_weapon_name( self.weaponname, 1 );
    s_upgraded_staff = s_elemental_staff.upgrade;

    for ( has_weapon = 0; isalive( player ); has_weapon = 0 )
    {
        if ( isdefined( s_elemental_staff.charger.is_inserted ) && s_elemental_staff.charger.is_inserted || isdefined( s_upgraded_staff.charger.is_inserted ) && s_upgraded_staff.charger.is_inserted )
            has_weapon = 1;
        else
        {
            weapons = player getweaponslistprimaries();

            foreach ( weapon in weapons )
            {
                if ( weapon == self.base_weaponname || weapon == s_upgraded_staff.weapname )
                    has_weapon = 1;
            }
        }

        if ( !has_weapon )
            break;

        wait 0.5;
    }

    model = getent( "craftable_" + self.base_weaponname, "targetname" );
    model show();
    self trigger_on();
    clear_player_staff( self.base_weaponname );
}

set_player_staff( str_weaponname, e_player )
{
    s_staff = get_staff_info_from_weapon_name( str_weaponname );
    s_staff.e_owner = e_player;
    n_player = e_player getentitynumber() + 1;
    e_player.staff_enum = s_staff.enum;
    level setclientfield( "staff_player" + n_player, s_staff.enum );
/#
    iprintlnbold( "Player " + n_player + " has staff " + s_staff.enum );
#/
}

clear_player_staff( str_weaponname )
{
    s_staff = get_staff_info_from_weapon_name( str_weaponname );

    if ( isdefined( s_staff.e_owner ) )
    {
        if ( !isdefined( s_staff.e_owner.staff_enum ) && !isdefined( s_staff.enum ) || isdefined( s_staff.e_owner.staff_enum ) && isdefined( s_staff.enum ) && s_staff.e_owner.staff_enum == s_staff.enum )
        {
            n_player = s_staff.e_owner getentitynumber() + 1;
            s_staff.e_owner.staff_enum = 0;
            level setclientfield( "staff_player" + n_player, 0 );
        }
    }

/#
    iprintlnbold( "Nobody has staff " + s_staff.enum );
#/
    s_staff.e_owner = undefined;
}

hide_staff_model()
{
    staffs = getentarray( "craftable_staff_model", "script_noteworthy" );

    foreach ( stave in staffs )
        stave ghost();
}
