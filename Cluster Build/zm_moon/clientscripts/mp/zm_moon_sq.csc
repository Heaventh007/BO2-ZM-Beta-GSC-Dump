// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zm_moon_fx;

rocket_test()
{

}

dte_watcher()
{
    level waittill( "dte" );
    level._dte_done = 1;

    for ( lcn = 0; lcn < level._ctt_num_players; lcn++ )
    {

    }

    wait 3.0;

    for ( lcn = 0; lcn < level._ctt_num_players; lcn++ )
    {

    }

    waitrealtime( 5.9 );

    for ( i = 0; i < getlocalplayers().size; i++ )
    {
        player = getlocalplayers()[i];

        if ( !isdefined( player._previous_vision ) )
            player._previous_vision = "zme";

        player clientscripts\mp\zm_moon_fx::moon_vision_set( "dte", player._previous_vision, i, 1.0 );
    }
}

ctt_cleanup()
{
    waitforallclients();
    level._ctt_num_players = getlocalplayers().size;
    level._ctt_targets = [];

    while ( true )
    {
        level waittill( "ctto" );
        level._ctt_targets = [];
    }
}

dest_debug( dest )
{
    while ( true )
    {
/#
        print3d( dest, "+", vectorscale( ( 1, 0, 0 ), 255.0 ), 30 );
#/
        wait 1;
    }
}

vision_wobble()
{
    setdvarfloat( "r_poisonFX_debug_amount", 0 );
    setdvar( "r_poisonFX_debug_enable", 1 );
    setdvarfloat( "r_poisonFX_pulse", 2 );
    setdvarfloat( "r_poisonFX_warpX", -0.3 );
    setdvarfloat( "r_poisonFX_warpY", 0.15 );
    setdvarfloat( "r_poisonFX_dvisionA", 0 );
    setdvarfloat( "r_poisonFX_dvisionX", 0 );
    setdvarfloat( "r_poisonFX_dvisionY", 0 );
    setdvarfloat( "r_poisonFX_blurMin", 0 );
    setdvarfloat( "r_poisonFX_blurMax", 3 );
    delta = 0.064;
    amount = 1;
    setdvarfloat( "r_poisonFX_debug_amount", amount );
    waitrealtime( 3 );

    while ( amount > 0 )
    {
        amount = max( amount - delta, 0 );
        setdvarfloat( "r_poisonFX_debug_amount", amount );
        wait 0.016;
    }

    setdvarfloat( "r_poisonFX_debug_amount", 0 );
    setdvar( "r_poisonFX_debug_enable", 0 );
}

soul_swap( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
        return;

    if ( bnewent )
        return;

    if ( !newval )
        return;

    if ( level._ctt_num_players == 1 )
        level thread vision_wobble();

    for ( i = 0; i < level._ctt_num_players; i++ )
    {
        e = spawn( i, self.origin + vectorscale( ( 0, 0, 1 ), 24.0 ), "script_model" );
        e setmodel( "tag_origin" );

        if ( i == 0 )
            e playsound( 0, "evt_soul_release" );

        e thread ctt_trail_runner( i, "soul_swap_trail", level._sam.origin + vectorscale( ( 0, 0, 1 ), 24.0 ) );
        e = spawn( i, level._sam.origin + vectorscale( ( 0, 0, 1 ), 24.0 ), "script_model" );
        e setmodel( "tag_origin" );

        if ( i == 0 )
            e playsound( 0, "evt_soul_release" );

        e thread ctt_trail_runner( i, "soul_swap_trail", self.origin + vectorscale( ( 0, 0, 1 ), 24.0 ) );
    }
}

ctt_trail_runner( localclientnum, fx_name, dest )
{
    playfxontag( localclientnum, level._effect[fx_name], self, "tag_origin" );
    self moveto( dest, 0.5 );
    self waittill( "movedone" );
    playsound( 0, "evt_soul_impact", dest );
    self delete();
}

zombie_release_soul( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
        return;

    closest = undefined;
    min_dist = 99980001;

    for ( i = 0; i < level._ctt_targets.size; i++ )
    {
        dist = distancesquared( self.origin, level._ctt_targets[i].origin );

        if ( dist < min_dist )
        {
            min_dist = dist;
            closest = level._ctt_targets[i];
        }
    }

    if ( isdefined( closest ) )
    {
/#
        println( "Zap from " + self.origin + " to " + closest.origin );
#/

        for ( i = 0; i < level._ctt_num_players; i++ )
        {
            e = spawn( i, self.origin + vectorscale( ( 0, 0, 1 ), 24.0 ), "script_model" );
            e setmodel( "tag_origin" );

            if ( i == 0 )
                e playsound( 0, "evt_soul_release" );

            e thread ctt_trail_runner( i, "fx_weak_sauce_trail", closest.origin - vectorscale( ( 0, 0, 1 ), 12.0 ) );
        }
    }
    else
    {
/#
        println( "Want to zap - but nothing close." );
#/
    }
}

build_ctt_targets( tank_names, second_names )
{
    ret_array = [];
    tanks = getstructarray( tank_names, "targetname" );
/#
    println( "*** build_ctt_targets" );
#/

    for ( i = 0; i < tanks.size; i++ )
    {
        tank = tanks[i];
        capacitor = getstruct( tank.target, "targetname" );
        ret_array[ret_array.size] = capacitor;
    }

    if ( isdefined( second_names ) )
    {
        tanks = getstructarray( second_names, "targetname" );

        for ( i = 0; i < tanks.size; i++ )
        {
            tank = tanks[i];
            capacitor = getstruct( tank.target, "targetname" );
            ret_array[ret_array.size] = capacitor;
        }
    }

    return ret_array;
}

cp_init()
{
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "cp", lcn );

    targs = getstructarray( "sq_cp_final", "targetname" );

    for ( i = 0; i < targs.size; i++ )
    {
        targ = targs[i];

        for ( j = 0; j < level._ctt_num_players; j++ )
        {
            e = spawn( j, targ.origin, "script_model" );
            e setmodel( targ.model );

            if ( isdefined( targ.angles ) )
                e.angles = targ.angles;

            e playsound( 0, "evt_clank" );
        }
    }
}

wp_init()
{
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "wp", lcn );

    targ = getstruct( "sq_wire_final", "targetname" );

    for ( j = 0; j < level._ctt_num_players; j++ )
    {
        e = spawn( j, targ.origin, "script_model" );
        e setmodel( targ.model );
        e playsound( 0, "evt_start_old_computer" );

        if ( isdefined( targ.angles ) )
            e.angles = targ.angles;
    }
}

sam_rise_and_bob( struct )
{
    endpos = getstruct( struct.target, "targetname" );
    self moveto( endpos.origin, 3.0 );
    self waittill( "movedone" );
    start_z = self.origin;
    amplitude = 7;
    frequency = 75;
    t = 0.0;
    level._sam = self;

    while ( true )
    {
        normalized_wave_height = sin( frequency * t );
        wave_height_z = amplitude * normalized_wave_height;
        self.origin = start_z + ( 0, 0, wave_height_z );
        t = t + 0.016;
        wait 0.016;
    }
}

sam_init()
{
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "sm", lcn );

    targ = getstruct( "sq_sam", "targetname" );

    for ( j = 0; j < level._ctt_num_players; j++ )
    {
        e = spawn( j, targ.origin, "script_model" );
        e setmodel( targ.model );

        if ( isdefined( targ.angles ) )
            e.angles = targ.angles;

        playfx( j, level._effect["lght_marker_flare"], targ.origin );
        e thread sam_rise_and_bob( targ );
        e playloopsound( "evt_samantha_reveal_loop", 1 );
    }
}

bob_vg()
{
    self endon( "death" );
    start_z = self.origin;
    amplitude = 2;
    frequency = 100;
    t = 0.0;

    while ( true )
    {
        normalized_wave_height = sin( frequency * t );
        wave_height_z = amplitude * normalized_wave_height;
        self.origin = start_z + ( 0, 0, wave_height_z );
        t = t + 0.016;
        wait 0.016;
    }
}

vg_init()
{
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "vg", lcn );

    targ = getstruct( "sq_charge_vg_pos", "targetname" );
    ents = [];

    for ( j = 0; j < level._ctt_num_players; j++ )
    {
        e = spawn( j, targ.origin, "script_model" );
        e setmodel( targ.model );

        if ( isdefined( targ.angles ) )
            e.angles = targ.angles;

        e thread bob_vg();
        ents[ents.size] = e;
    }

    lcn = -1;

    while ( lcn != 0 )
        level waittill( "vg", lcn );

    for ( i = 0; i < ents.size; i++ )
        playfxontag( i, level._effect["vrill_glow"], ents[i], "tag_origin" );

    lcn = -1;

    while ( lcn != 0 )
        level waittill( "vg", lcn );

    for ( j = 0; j < ents.size; j++ )
        ents[j] delete();

    ents = [];
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "vg", lcn );

    targ = getstruct( "sq_vg_final", "targetname" );
    ents = [];

    for ( j = 0; j < level._ctt_num_players; j++ )
    {
        e = spawn( j, targ.origin, "script_model" );
        e setmodel( targ.model );

        if ( isdefined( targ.angles ) )
            e.angles = targ.angles;

        ents[ents.size] = e;
    }

    for ( i = 0; i < ents.size; i++ )
        playfxontag( i, level._effect["vrill_glow"], ents[i], "tag_origin" );

    level._override_eye_fx = "blue_eyes";
}

ctt1_init()
{
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "ctt1", lcn );

    level._ctt_targets = build_ctt_targets( "sq_first_tank" );
}

ctt2_init()
{
    lcn = -1;

    while ( lcn != 0 )
        level waittill( "ctt2", lcn );

    level._ctt_targets = build_ctt_targets( "sq_second_tank", "sq_first_tank" );
}

sr_rumble()
{
    level waittill( "p_r" );
    level thread do_sr_rumble();
}

do_sr_rumble()
{
    level endon( "s_r" );
    dist = 562500;
    struct = getstruct( "pyramid_walls_retract", "targetname" );

    while ( true )
    {
        for ( i = 0; i < level.localplayers.size; i++ )
        {
            player = getlocalplayers()[i];

            if ( !isdefined( player ) )
                continue;

            if ( distancesquared( struct.origin, player.origin ) < dist )
                player playrumbleonentity( i, "slide_rumble" );
        }

        wait( randomfloatrange( 0.05, 0.15 ) );
    }
}

sam_vo_rumble()
{
    while ( true )
    {
        level waittill( "st1", lcn );

        if ( isdefined( lcn ) && lcn != 0 )
            continue;

        level thread do_sam_vo_rumble();
    }
}

do_sam_vo_rumble()
{
    level endon( "sp1" );

    while ( true )
    {
        for ( i = 0; i < level.localplayers.size; i++ )
        {
            player = getlocalplayers()[i];

            if ( !isdefined( player ) )
                continue;

            player earthquake( randomfloatrange( 0.2, 0.25 ), 5, player.origin, 100 );
            player playrumbleonentity( i, "slide_rumble" );
        }

        wait( randomfloatrange( 0.1, 0.15 ) );
    }
}

r_r()
{
    level waittill( "R_R" );
    level thread do_rr_rumble();
    wait 4.5;
    level notify( "_stop_rr" );
}

do_rr_rumble()
{
    level endon( "_stop_rr" );

    while ( true )
    {
        for ( i = 0; i < level.localplayers.size; i++ )
        {
            player = getlocalplayers()[i];

            if ( !isdefined( player ) )
                continue;

            player earthquake( randomfloatrange( 0.15, 0.2 ), 5, player.origin, 100 );
            player playrumbleonentity( i, "slide_rumble" );
        }

        wait( randomfloatrange( 0.1, 0.15 ) );
    }
}

r_l()
{
    level waittill( "R_L" );
    level thread do_rl_rumble();
    wait 6;
    level notify( "_stop_rl" );
}

do_rl_rumble()
{
    level endon( "_stop_rl" );

    while ( true )
    {
        for ( i = 0; i < level.localplayers.size; i++ )
        {
            player = getlocalplayers()[i];

            if ( !isdefined( player ) )
                continue;

            player earthquake( randomfloatrange( 0.26, 0.31 ), 5, player.origin, 100 );
            player playrumbleonentity( i, "damage_light" );
        }

        wait( randomfloatrange( 0.1, 0.15 ) );
    }
}

d_e()
{
    level waittill( "dte" );
    wait 3.5;
    level thread do_de_rumble();
    wait 4;
    level notify( "_stop_de" );
}

do_de_rumble()
{
    level endon( "_stop_de" );

    for ( i = 0; i < level.localplayers.size; i++ )
    {
        player = getlocalplayers()[i];

        if ( !isdefined( player ) )
            continue;

        player earthquake( randomfloatrange( 0.4, 0.45 ), 5, player.origin, 100 );
        player playrumbleonentity( i, "damage_heavy" );
    }

    wait 0.2;

    while ( true )
    {
        for ( i = 0; i < level.localplayers.size; i++ )
        {
            player = getlocalplayers()[i];

            if ( !isdefined( player ) )
                continue;

            player earthquake( randomfloatrange( 0.35, 0.4 ), 5, player.origin, 100 );
            player playrumbleonentity( i, "damage_light" );
        }

        wait( randomfloatrange( 0.1, 0.15 ) );
    }
}