// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_jump_pad;
#include maps\mp\zombies\_zm_powerups;

init()
{
    level._uses_jump_pads = 1;
    level maps\mp\zombies\_zm_jump_pad::init();
    level moon_jump_pad_overrides();
    level thread moon_biodome_temptation_init();
    level thread moon_jump_pads_low_gravity();
    level thread moon_jump_pads_malfunctions();
    level thread moon_jump_pad_cushion_sound_init();
}

moon_jump_pad_overrides()
{
    level._jump_pad_override["biodome_logic"] = ::moon_jump_pad_progression_end;
    level._jump_pad_override["low_grav"] = ::moon_low_gravity_velocity;
    level._jump_pad_override["moon_vertical_jump"] = ::moon_vertical_jump;
    level._jump_pad_poi_start_override = ::moon_zombie_run_change;
    flag_init( "pad_allow_anim_change" );
    level._jump_pad_anim_change = [];
    flag_set( "pad_allow_anim_change" );
    level thread jump_pad_throttle_anim_changes();
}

moon_jump_pad_progression_end( ent_player )
{
    if ( isdefined( self.start.script_string ) )
        ent_player.script_string = self.start.script_string;

    if ( isdefined( ent_player.script_string ) )
    {
        end_spot_array = self.destination;
        end_spot_array = array_randomize( end_spot_array );

        for ( i = 0; i < end_spot_array.size; i++ )
        {
            if ( isdefined( end_spot_array[i].script_string ) && end_spot_array[i].script_string == ent_player.script_string )
            {
                end_point = end_spot_array[i];

                if ( randomint( 100 ) < 5 && !level._pad_powerup && isdefined( end_point.script_parameters ) )
                {
                    temptation_array = level._biodome_tempt_arrays[end_point.script_parameters];

                    if ( isdefined( temptation_array ) )
                    {

                    }
                }

                return end_point;
            }
        }
    }
}

moon_low_gravity_velocity( ent_start_point, struct_end_point )
{
    end_point = struct_end_point;
    start_point = ent_start_point;
    z_velocity = undefined;
    z_dist = undefined;
    fling_this_way = undefined;
    world_gravity = getdvarint( #"bg_gravity" );
    gravity_pulls = -13.3;
    top_velocity_sq = 810000;
    forward_scaling = 1.0;
    end_spot = struct_end_point.origin;

    if ( !is_true( self.script_airspeed ) )
    {
        rand_end = ( randomfloat( 0.1, 1.2 ), randomfloat( 0.1, 1.2 ), 0 );
        rand_scale = randomint( 100 );
        rand_spot = vectorscale( rand_end, rand_scale );
        end_spot = struct_end_point.origin + rand_spot;
    }

    pad_dist = distance( start_point.origin, end_spot );
    z_dist = end_spot[2] - start_point.origin[2];
    jump_velocity = end_spot - start_point.origin;

    if ( z_dist > 40 && z_dist < 135 )
    {
        z_dist = z_dist * 0.05;
        forward_scaling = 0.8;
/#
        if ( getdvarint( #"_id_D5FD01C3" ) )
        {
            z_dist = z_dist * getdvarfloat( #"_id_E2494021" );
            forward_scaling = getdvarfloat( #"_id_4E3BC729" );
        }
#/
    }
    else if ( z_dist >= 135 )
    {
        z_dist = z_dist * 0.2;
        forward_scaling = 0.7;
/#
        if ( getdvarint( #"_id_D5FD01C3" ) )
        {
            z_dist = z_dist * getdvarfloat( #"_id_E2494021" );
            forward_scaling = getdvarfloat( #"_id_4E3BC729" );
        }
#/
    }
    else if ( z_dist < 0 )
    {
        z_dist = z_dist * 0.1;
        forward_scaling = 0.95;
/#
        if ( getdvarint( #"_id_D5FD01C3" ) )
        {
            z_dist = z_dist * getdvarfloat( #"_id_E2494021" );
            forward_scaling = getdvarfloat( #"_id_4E3BC729" );
        }
#/
    }

    z_velocity = 0.75 * z_dist * world_gravity;

    if ( z_velocity < 0 )
        z_velocity = z_velocity * -1;

    if ( z_dist < 0 )
        z_dist = z_dist * -1;

    jump_time = sqrt( 2 * pad_dist / world_gravity );
    jump_time_2 = sqrt( z_dist / world_gravity );
    jump_time = jump_time + jump_time_2;

    if ( jump_time < 0 )
        jump_time = jump_time * -1;

    x = jump_velocity[0] * forward_scaling / jump_time;
    y = jump_velocity[1] * forward_scaling / jump_time;
    z = z_velocity / jump_time;
    fling_this_way = ( x, y, z );
    jump_info = [];
    jump_info[0] = fling_this_way;
    jump_info[1] = jump_time;
    return jump_info;
}

moon_vertical_jump( ent_start_point, struct_end_point )
{
    end_point = struct_end_point;
    start_point = ent_start_point;
    z_velocity = undefined;
    z_dist = undefined;
    fling_this_way = undefined;
    world_gravity = getdvarint( #"bg_gravity" );
    gravity_pulls = -13.3;
    top_velocity_sq = 810000;
    forward_scaling = 0.9;
    end_random_scale = ( randomfloatrange( -1, 1 ), randomfloatrange( -1, 1 ), 0 );
    vel_random = ( randomintrange( 2, 6 ), randomintrange( 2, 6 ), 0 );
    pad_dist = distance( start_point.origin, end_point.origin );
    jump_velocity = end_point.origin - start_point.origin;
    z_dist = end_point.origin[2] - start_point.origin[2];
    z_dist = z_dist * 1.5;
    z_velocity = 2 * z_dist * world_gravity;

    if ( z_velocity < 0 )
        z_velocity = z_velocity * -1;

    if ( z_dist < 0 )
        z_dist = z_dist * -1;

    jump_time = sqrt( 2 * pad_dist / world_gravity );
    jump_time_2 = sqrt( 2 * z_dist / world_gravity );
    jump_time = jump_time + jump_time_2;

    if ( jump_time < 0 )
        jump_time = jump_time * -1;

    x = jump_velocity[0] * forward_scaling / jump_time;
    y = jump_velocity[1] * forward_scaling / jump_time;
    z = z_velocity / jump_time;
    fling_vel = ( x, y, z ) + vel_random;
    fling_this_way = ( x, y, z );
    jump_info = [];
    jump_info[0] = fling_this_way;
    jump_info[1] = jump_time;
    return jump_info;
}

moon_biodome_temptation_init()
{
    level._biodome_tempt_arrays = [];
    level._biodome_tempt_arrays["struct_tempt_left_medium_start"] = getstructarray( "struct_tempt_left_medium_start", "targetname" );
    level._biodome_tempt_arrays["struct_tempt_right_medium_start"] = getstructarray( "struct_tempt_right_medium_start", "targetname" );
    level._biodome_tempt_arrays["struct_tempt_left_tall"] = getstructarray( "struct_tempt_left_tall", "targetname" );
    level._biodome_tempt_arrays["struct_tempt_middle_tall"] = getstructarray( "struct_tempt_middle_tall", "targetname" );
    level._biodome_tempt_arrays["struct_tempt_right_tall"] = getstructarray( "struct_tempt_right_tall", "targetname" );
    level._biodome_tempt_arrays["struct_tempt_left_medium_end"] = getstructarray( "struct_tempt_left_medium_end", "targetname" );
    level._biodome_tempt_arrays["struct_tempt_right_medium_end"] = getstructarray( "struct_tempt_right_medium_end", "targetname" );
    level._pad_powerup = 0;
    flag_wait( "start_zombie_round_logic" );
    level thread moon_biodome_random_pad_temptation();
}

moon_biodome_random_pad_temptation()
{
    level endon( "end_game" );
    structs = getstructarray( "struct_biodome_temptation", "script_noteworthy" );

    while ( true )
    {
        rand = randomint( structs.size );

        if ( isdefined( level._biodome_tempt_arrays[structs[rand].targetname] ) )
        {
            tempt_array = level._biodome_tempt_arrays[structs[rand].targetname];
            tempt_array = array_randomize( tempt_array );

            if ( isdefined( level.zones["forest_zone"] ) && is_true( level.zones["forest_zone"].is_enabled ) && !level._pad_powerup )
                level thread moon_biodome_powerup_temptation( tempt_array );
        }

        wait( randomintrange( 60, 180 ) );
    }
}

moon_biodome_powerup_temptation( struct_array )
{
    powerup = spawn( "script_model", struct_array[0].origin );
    level thread moon_biodome_temptation_active( powerup );
    powerup endon( "powerup_grabbed" );
    powerup endon( "powerup_timedout" );
    temptation_array = array( "fire_sale", "insta_kill", "nuke", "double_points", "carpenter" );
    temptation_index = 0;
    spot_index = 0;
    first_time = 1;
    struct = undefined;
    rotation = 0;
    temptation_array = array_randomize( temptation_array );

    while ( isdefined( powerup ) )
    {
        if ( temptation_array[temptation_index] == "fire_sale" && ( level.zombie_vars["zombie_powerup_fire_sale_on"] == 1 || level.chest_moves == 0 ) )
        {
            temptation_index++;

            if ( temptation_index >= temptation_array.size )
                temptation_index = 0;

            powerup maps\mp\zombies\_zm_powerups::powerup_setup( temptation_array[temptation_index] );
        }
        else
            powerup maps\mp\zombies\_zm_powerups::powerup_setup( temptation_array[temptation_index] );

        if ( first_time )
        {
            powerup thread maps\mp\zombies\_zm_powerups::powerup_timeout();
            powerup thread maps\mp\zombies\_zm_powerups::powerup_wobble();
            powerup thread maps\mp\zombies\_zm_powerups::powerup_grab();
            first_time = 0;
        }

        powerup.origin = struct_array[spot_index].origin;

        if ( rotation == 0 )
        {
            wait 15.0;
            rotation++;
        }
        else if ( rotation == 1 )
        {
            wait 7.5;
            rotation++;
        }
        else if ( rotation == 2 )
        {
            wait 2.5;
            rotation++;
        }
        else
        {
            wait 1.5;
            rotation++;
        }

        temptation_index++;

        if ( temptation_index >= temptation_array.size )
            temptation_index = 0;

        spot_index++;

        if ( spot_index >= struct_array.size )
            spot_index = 0;
    }
}

moon_biodome_temptation_active( ent_powerup )
{
    level._pad_powerup = 1;

    while ( isdefined( ent_powerup ) )
        wait 0.1;

    level._pad_powerup = 0;
}

moon_jump_pads_low_gravity()
{
    level endon( "end_game" );
    biodome_pads = getentarray( "biodome_pads", "script_noteworthy" );
    biodome_compromised = 0;

    while ( !biodome_compromised )
    {
        level waittill( "digger_arm_smash", digger, zone );

        if ( digger == "biodome" && isarray( zone ) && zone[0] == "forest_zone" )
            biodome_compromised = 1;
    }

    for ( i = 0; i < biodome_pads.size; i++ )
        biodome_pads[i].script_string = "low_grav";
}

moon_jump_pads_malfunctions()
{
    level endon( "end_game" );
    jump_pad_triggers = getentarray( "trig_jump_pad", "targetname" );
    flag_wait( "start_zombie_round_logic" );
    wait 2.0;
    level._dome_malfunction_pads = [];

    for ( i = 0; i < jump_pad_triggers.size; i++ )
    {
        pad = jump_pad_triggers[i];

        if ( isdefined( pad.script_label ) )
        {
            if ( pad.script_label == "pad_labs_low" )
            {
                level._dome_malfunction_pads = add_to_array( level._dome_malfunction_pads, pad, 0 );
                continue;
            }

            if ( pad.script_label == "pad_magic_box_low" )
            {
                level._dome_malfunction_pads = add_to_array( level._dome_malfunction_pads, pad, 0 );
                continue;
            }

            if ( pad.script_label == "pad_teleporter_low" )
                level._dome_malfunction_pads = add_to_array( level._dome_malfunction_pads, pad, 0 );
        }
    }

/#
    if ( level._dome_malfunction_pads.size == 0 )
    {
        println( "$$$$ malfunction pads missing $$$$" );
        return;
    }
#/
    flag_wait( "power_on" );

    for ( i = 0; i < level._dome_malfunction_pads.size; i++ )
        level._dome_malfunction_pads[i] thread moon_pad_malfunction_think();
}

moon_pad_malfunction_think()
{
    level endon( "end_game" );
    pad_hook = spawn( "script_model", self.origin );
    pad_hook setmodel( "tag_origin" );

    while ( isdefined( self ) )
    {
        wait( randomintrange( 30, 60 ) );
/#
        println( "$$$$ Shut down pad $$$$" );
#/
        pad_hook playsound( "zmb_turret_down" );
        pad_hook setclientfield( "dome_malfunction_pad", 1 );
        wait_network_frame();
        self trigger_off();
        wait( randomintrange( 10, 30 ) );
        pad_hook playsound( "zmb_turret_startup" );
        pad_hook setclientfield( "dome_malfunction_pad", 0 );
        wait_network_frame();
        self trigger_on();
/#
        println( "$$$$ Start up pad $$$$" );
#/
    }
}

moon_zombie_run_change( ent_poi )
{

}

jump_pad_store_movement_anim()
{
    self endon( "death" );
/#
    assert( isdefined( self.run_combatanim ) );
    assert( isdefined( self.zombie_move_speed ) );
#/
    current_anim = self.run_combatanim;
    anim_keys = getarraykeys( level.scr_anim[self.animname] );

    for ( j = 0; j < anim_keys.size; j++ )
    {
        if ( level.scr_anim[self.animname][anim_keys[j]] == current_anim )
            return anim_keys[j];
    }

/#
    assertmsg( "couldn't find zombie run anim in the array keys" );
#/
}

moon_stop_running_to_catch()
{
    self endon( "death" );

    if ( !is_true( self._pad_chase ) )
        return;

    if ( isdefined( self.animname ) && self.animname == "astro_zombie" )
        return;

    while ( is_true( self._pad_follow ) )
        wait 0.05;

/#
    assert( isdefined( self.zombie_move_speed ) );
    assert( isdefined( self.ent_flag["pad_anim_change"] ) );
#/
    flag_wait( "pad_allow_anim_change" );
    level._jump_pad_anim_change = add_to_array( level._jump_pad_anim_change, self, 0 );
    self ent_flag_wait( "pad_anim_change" );
    low_grav = 0;
    curr_zone = self get_current_zone();

    if ( isdefined( curr_zone ) && isdefined( level.zones[curr_zone].volumes[0].script_string ) && level.zones[curr_zone].volumes[0].script_string == "lowgravity" )
        low_grav = 1;

    anim_set = undefined;

    switch ( self.zombie_move_speed )
    {
        case "walk":
            if ( low_grav )
            {
                if ( self.has_legs )
                {
                    var = randomintrange( 1, level.num_anim[self.animname]["walk"] + 1 );
                    anim_set = "walk_moon" + var;
                    break;
                }
                else
                {
                    var = randomintrange( 1, level.num_anim[self.animname]["crawl"] + 1 );
                    anim_set = "crawl_moon" + var;
                    break;
                }
            }
            else if ( self.has_legs )
            {
                var = randomintrange( 1, 9 );
                anim_set = "walk" + var;
                break;
            }
            else
            {
                var = randomintrange( 1, 7 );
                anim_set = "crawl" + var;
                break;
            }
        case "run":
            if ( low_grav )
            {
                if ( self.has_legs )
                {
                    var = randomintrange( 1, level.num_anim[self.animname]["run"] + 1 );
                    anim_set = "run_moon" + var;
                    break;
                }
                else
                {
                    var = randomintrange( 1, level.num_anim[self.animname]["crawl"] + 1 );
                    anim_set = "crawl_moon" + var;
                    break;
                }
            }
            else if ( self.has_legs )
            {
                var = randomintrange( 1, 7 );
                anim_set = "run" + var;
                break;
            }
            else
            {
                var = randomintrange( 1, 3 );
                anim_set = "crawl_hand_" + var;
                break;
            }
        case "sprint":
            if ( low_grav )
            {
                if ( self.has_legs )
                {
                    var = randomintrange( 1, level.num_anim[self.animname]["sprint"] + 1 );
                    anim_set = "sprint_moon" + var;
                    break;
                }
                else
                {
                    var = randomintrange( 1, level.num_anim[self.animname]["crawl"] + 1 );
                    anim_set = "crawl_moon" + var;
                    break;
                }
            }
            else if ( self.has_legs )
            {
                var = randomintrange( 1, 5 );
                anim_set = "sprint" + var;
                break;
            }
            else
            {
                var = randomintrange( 1, 4 );
                anim_set = "crawl_sprint" + var;
                break;
            }
    }

    self moon_jump_pad_run_switch( anim_set );
    self._pad_chase = 0;
}

jump_pad_throttle_anim_changes()
{
    if ( !isdefined( level._jump_pad_anim_change ) )
        level._jump_pad_anim_change = [];

    int_max_num_zombies_per_frame = 7;
    array_zombies_allowed_to_switch = [];

    while ( isdefined( level._jump_pad_anim_change ) )
    {
        if ( level._jump_pad_anim_change.size == 0 )
        {
            wait 0.1;
            continue;
        }

        array_zombies_allowed_to_switch = level._jump_pad_anim_change;

        for ( i = 0; i < array_zombies_allowed_to_switch.size; i++ )
        {
            if ( !isalive( array_zombies_allowed_to_switch[i] ) )
                continue;

            array_zombies_allowed_to_switch[i] ent_flag_set( "pad_anim_change" );

            if ( i >= int_max_num_zombies_per_frame )
                break;
        }

        flag_clear( "pad_allow_anim_change" );
        wait 0.05;

        for ( i = 0; i < array_zombies_allowed_to_switch.size; i++ )
        {
            zmb = array_zombies_allowed_to_switch[i];

            if ( !isalive( zmb ) || !isdefined( zmb ) )
                continue;

            if ( zmb ent_flag( "pad_anim_change" ) )
            {
                arrayremovevalue( level._jump_pad_anim_change, zmb );
                zmb ent_flag_clear( "pad_anim_change" );
            }
        }

        level._jump_pad_anim_change = array_removedead( level._jump_pad_anim_change );
        arrayremovevalue( level._jump_pad_anim_change, undefined );
        flag_set( "pad_allow_anim_change" );
        wait 0.1;
    }
}

moon_jump_pad_run_switch( str_anim_key )
{

}

moon_jump_pad_cushion_sound_init()
{
    flag_wait( "start_zombie_round_logic" );
    cushion_sound_triggers = getentarray( "trig_cushion_sound", "targetname" );

    if ( !isdefined( cushion_sound_triggers ) || cushion_sound_triggers.size == 0 )
        return;

    for ( i = 0; i < cushion_sound_triggers.size; i++ )
        cushion_sound_triggers[i] thread moon_jump_pad_cushion_play_sound();
}

moon_jump_pad_cushion_play_sound()
{
    while ( isdefined( self ) )
    {
        self waittill( "trigger", who );

        if ( isplayer( who ) && is_true( who._padded ) )
            self playsound( "evt_jump_pad_land" );
    }
}
