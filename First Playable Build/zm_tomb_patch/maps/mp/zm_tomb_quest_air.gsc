// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_net;

main()
{
    flag_init( "air_puzzle_1_complete" );
    flag_init( "air_puzzle_2_complete" );
    flag_init( "air_upgrade_available" );
    air_puzzle_1_init();
    air_puzzle_2_init();
    level thread air_run_moving_platforms();
    flag_wait( "door_air_opened" );
    level thread air_puzzle_1_run();
    flag_wait( "air_puzzle_1_complete" );
    level thread air_puzzle_1_cleanup();
    level thread air_puzzle_2_run();
}

air_run_moving_platforms()
{
    m_ramp = getent( "air_chamber_platform", "targetname" );
    m_ramp setmovingplatformenabled( 1 );
    m_ramp.lower_front = getnode( "ramp_lower_front", "targetname" );
    m_ramp.lower_back = getnode( "ramp_lower_back", "targetname" );
    m_ramp.upper_right = getnode( "ramp_upper_right", "targetname" );
    m_ramp.upper_left = getnode( "ramp_upper_left", "targetname" );
    m_ramp.platform_upper_front = getnode( "platform_upper_front", "targetname" );
    m_ramp.platform_upper_right = getnode( "platform_upper_right", "targetname" );
    m_ramp.platform_upper_left = getnode( "platform_upper_left", "targetname" );
    m_ramp.platform_upper_back = getnode( "platform_upper_back", "targetname" );
    m_ramp.platform_lower_front = getnode( "platform_lower_front", "targetname" );
    m_ramp.platform_lower_right = getnode( "platform_lower_right", "targetname" );
    m_ramp.platform_lower_left = getnode( "platform_lower_left", "targetname" );
    m_ramp.platform_lower_back = getnode( "platform_lower_back", "targetname" );
    link_platform_nodes( m_ramp.lower_front, m_ramp.platform_lower_front );
    link_platform_nodes( m_ramp.lower_back, m_ramp.platform_lower_back );
    link_platform_nodes( m_ramp.upper_right, m_ramp.platform_upper_right );
    link_platform_nodes( m_ramp.upper_left, m_ramp.platform_upper_left );
    flag_wait( "staff_air_zm_upgrade_unlocked" );
    trigger_wait( "trigger_air_chamber" );
    wait 4;
    m_ramp thread air_rotate_chamber_ramps();
}

air_rotate_chamber_ramps()
{
    n_rot_time = 5;
    n_interval = 20;

    while ( true )
    {
        unlink_platform_nodes( self.lower_front, self.platform_lower_front );
        unlink_platform_nodes( self.lower_back, self.platform_lower_back );
        unlink_platform_nodes( self.upper_right, self.platform_upper_right );
        unlink_platform_nodes( self.upper_left, self.platform_upper_left );
        self rotateyaw( 90, n_rot_time );
        self waittill( "rotatedone" );
        link_platform_nodes( self.lower_front, self.platform_lower_right );
        link_platform_nodes( self.lower_back, self.platform_lower_left );
        link_platform_nodes( self.upper_right, self.platform_upper_back );
        link_platform_nodes( self.upper_left, self.platform_upper_front );
        wait( n_interval );
        unlink_platform_nodes( self.lower_front, self.platform_lower_right );
        unlink_platform_nodes( self.lower_back, self.platform_lower_left );
        unlink_platform_nodes( self.upper_right, self.platform_upper_back );
        unlink_platform_nodes( self.upper_left, self.platform_upper_front );
        self rotateyaw( 90, n_rot_time );
        self waittill( "rotatedone" );
        link_platform_nodes( self.lower_front, self.platform_lower_back );
        link_platform_nodes( self.lower_back, self.platform_lower_front );
        link_platform_nodes( self.upper_right, self.platform_upper_left );
        link_platform_nodes( self.upper_left, self.platform_upper_right );
        wait( n_interval );
        unlink_platform_nodes( self.lower_front, self.platform_lower_back );
        unlink_platform_nodes( self.lower_back, self.platform_lower_front );
        unlink_platform_nodes( self.upper_right, self.platform_upper_left );
        unlink_platform_nodes( self.upper_left, self.platform_upper_right );
        self rotateyaw( 90, n_rot_time );
        self waittill( "rotatedone" );
        link_platform_nodes( self.lower_front, self.platform_lower_left );
        link_platform_nodes( self.lower_back, self.platform_lower_right );
        link_platform_nodes( self.upper_right, self.platform_upper_front );
        link_platform_nodes( self.upper_left, self.platform_upper_back );
        wait( n_interval );
        unlink_platform_nodes( self.lower_front, self.platform_lower_left );
        unlink_platform_nodes( self.lower_back, self.platform_lower_right );
        unlink_platform_nodes( self.upper_right, self.platform_upper_front );
        unlink_platform_nodes( self.upper_left, self.platform_upper_back );
        self rotateyaw( 90, n_rot_time );
        self waittill( "rotatedone" );
        link_platform_nodes( self.lower_front, self.platform_lower_front );
        link_platform_nodes( self.lower_back, self.platform_lower_back );
        link_platform_nodes( self.upper_right, self.platform_upper_right );
        link_platform_nodes( self.upper_left, self.platform_upper_left );
        wait( n_interval );
    }
}

air_puzzle_1_init()
{
    level.a_ceiling_rings = getentarray( "ceiling_ring", "script_noteworthy" );

    foreach ( e_ring in level.a_ceiling_rings )
        e_ring ceiling_ring_init();

    air_ring_actuators = getentarray( "ceiling_ring_actuator", "script_noteworthy" );

    foreach ( e_actuator in air_ring_actuators )
    {
        e_target = getent( e_actuator.target, "targetname" );
        e_target linkto( e_actuator );
        e_actuator.ring = e_target;
    }
}

air_puzzle_1_cleanup()
{
    wait 5.0;
    a_air_ring_numbers = getentarray( "air_ring_number", "script_noteworthy" );
    array_delete( a_air_ring_numbers );
}

air_puzzle_1_run()
{
    air_ring_actuators = getentarray( "ceiling_ring_actuator", "script_noteworthy" );
    array_thread( air_ring_actuators, ::ring_actuator_run );
}

check_puzzle_solved()
{
    num_solved = 0;

    foreach ( e_ring in level.a_ceiling_rings )
    {
        if ( e_ring.script_int != e_ring.position )
            return false;
    }

    return true;
}

actuator_rotate()
{
    self.position = ( self.position + 1 ) % 4;
    self.ring.position = self.position;
    new_angles = ( self.angles[0], self.position * 90, self.angles[2] );
    self rotateto( new_angles, 0.5, 0.2, 0.2 );
    self waittill( "rotatedone" );
    solved = check_puzzle_solved();

    if ( solved )
        flag_set( "air_puzzle_1_complete" );
}

ceiling_ring_init()
{
    self.position = 0;
    a_e_numbers = getentarray( self.target, "targetname" );

    foreach ( e_number in a_e_numbers )
        e_number linkto( self );
}

ring_actuator_run()
{
    level endon( "air_puzzle_1_complete" );
    self setcandamage( 1 );
    self.position = 0;

    while ( true )
    {
        self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );

        if ( weaponname == "staff_air_zm" )
            self actuator_rotate();
    }
}

air_puzzle_2_init()
{
    a_smoke_pos = getstructarray( "puzzle_smoke_origin", "targetname" );

    foreach ( s_smoke_pos in a_smoke_pos )
    {
        s_smoke_pos.detector_brush = getent( s_smoke_pos.target, "targetname" );
        s_smoke_pos.detector_brush ghost();
    }
}

air_puzzle_2_run()
{
    a_smoke_pos = getstructarray( "puzzle_smoke_origin", "targetname" );

    foreach ( s_smoke_pos in a_smoke_pos )
        s_smoke_pos thread air_puzzle_smoke();

    while ( true )
    {
        level waittill( "air_puzzle_smoke_solved" );
        all_smoke_solved = 1;

        foreach ( s_smoke_pos in a_smoke_pos )
        {
            if ( !s_smoke_pos.solved )
                all_smoke_solved = 0;
        }

        if ( all_smoke_solved )
        {
            flag_set( "air_puzzle_2_complete" );
            level thread play_puzzle_stinger_on_all_players();
            break;
        }
    }
}

air_puzzle_smoke()
{
    self.e_fx = spawn( "script_model", self.origin );
    self.e_fx.angles = self.angles;
    self.e_fx setmodel( "tag_origin" );
    s_dest = getstruct( "puzzle_smoke_dest", "targetname" );
    playfxontag( level._effect["air_puzzle_smoke"], self.e_fx, "tag_origin" );
    self thread air_puzzle_run_smoke_direction();
    flag_wait( "air_puzzle_2_complete" );
    self.e_fx movez( -1000, 1.0, 0.1, 0.1 );
    self.e_fx waittill( "movedone" );
    self.e_fx delete();
    self.detector_brush delete();
}

air_puzzle_run_smoke_direction()
{
    level endon( "air_puzzle_2_complete" );
    self endon( "death" );
    s_dest = getstruct( "puzzle_smoke_dest", "targetname" );
    v_to_dest = vectornormalize( s_dest.origin - self.origin );
    f_min_dot = cos( self.script_int );
    self.solved = 0;
    self.detector_brush setcandamage( 1 );

    while ( true )
    {
        self.detector_brush waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );

        if ( weaponname == "staff_air_zm" )
        {
            new_yaw = vectoangles( direction_vec );
            new_orient = ( 0, new_yaw, 0 );
            self.e_fx rotateto( new_orient, 1.0, 0.3, 0.3 );
            self.e_fx waittill( "rotatedone" );
            f_dot = vectordot( v_to_dest, direction_vec );
            self.solved = f_dot > f_min_dot;
            level notify( "air_puzzle_smoke_solved" );
        }
    }
}