// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
    if ( getdvar( #"createfx" ) == "on" )
        return;

    registerclientfield( "scriptmover", "staff_water_torso_damage_fx", 14000, 1, "int", ::staff_water_torso_damage_fx, 1 );
    registerclientfield( "scriptmover", "ice_sphere_fx", 14000, 1, "int", ::ice_sphere, 0 );
    registerclientfield( "actor", "attach_bullet_model", 14000, 1, "int", ::attach_model );
    level._effect["staff_water_damage_torso"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_ice_ug_impact_hit" );
    level._effect["staff_water_ice_shard"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_ice_trail_bolt" );
    registerclientfield( "actor", "anim_rate", 14000, 5, "float", undefined, 0 );
    setupclientfieldanimspeedcallbacks( "actor", 1, "anim_rate" );
}

attach_model( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
    {
        if ( isdefined( self.ice_shard_fx ) )
            stopfx( localclientnum, self.ice_shard_fx );

        self.ice_shard_fx = playfxontag( localclientnum, level._effect["staff_water_ice_shard"], self, "j_spine4" );
    }
    else if ( isdefined( self.ice_shard_fx ) )
    {
        stopfx( localclientnum, self.ice_shard_fx );
        self.ice_shard_fx = undefined;
    }
}

ice_sphere( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    players = getlocalplayers();

    for ( i = 0; i < players.size; i++ )
    {
        if ( newval )
        {
            self thread staff_water_play_ice_sphere_fx( i );
            self thread staff_water_scroll_ice_sphere_fx( i );
            continue;
        }

        self thread staff_water_noplay_ice_sphere_fx( i );
        self thread staff_water_noscroll_ice_sphere_fx( i );
    }
}

staff_water_play_ice_sphere_fx( localclientnum )
{
    self mapshaderconstant( localclientnum, 0, "scriptVector0" );
    x = 0;
    y = 0.5;
    level.b_x_increasing = 0;
    level.b_y_increasing = 1;

    while ( y <= 1 )
    {
        self setshaderconstant( localclientnum, 0, x, y, 0, 0 );
        y = ice_sphere_get_normal( y );
        wait 0.01;
    }
}

ice_sphere_get_fade( x )
{
    if ( level.b_x_increasing )
        x = x + 0.0;
    else
        x = x - 0.0;

    return x;
}

ice_sphere_get_normal( y )
{
    y = y + 0.008;
    return y;
}

staff_water_scroll_ice_sphere_fx( localclientnum )
{
    self mapshaderconstant( localclientnum, 1, "scriptVector1" );
    x = 0;
    y = 0;
    z = 0;
    w = 0;
    zinc = 0.01;

    while ( zinc > 0.00001 )
    {
        self setshaderconstant( localclientnum, 1, x, y, z, w );
        x = ice_sphere_scroll_normal_x( x );
        y = ice_sphere_scroll_normal_y( y );
        z = ice_sphere_scroll_normal_z( z, zinc );
        zinc = zinc * 0.95;
        wait 0.01;
    }
}

ice_sphere_scroll_normal_x( x )
{
    x = x + 0.0001;
    return x;
}

ice_sphere_scroll_normal_y( y )
{
    y = y + -0.0;
    return y;
}

ice_sphere_scroll_normal_z( z, zinc )
{
    z = z + zinc;
    return z;
}

ice_sphere_scroll_normal_w( w )
{
    inc = 0.0;
    w = w + inc * -1;
    inc = inc + 0.1;
    return w;
}

staff_water_noplay_ice_sphere_fx( localclientnum )
{
    self mapshaderconstant( localclientnum, 0, "scriptVector0" );
    x = 0;
    y = 0;
    self setshaderconstant( localclientnum, 0, x, y, 0, 0 );
}

staff_water_noscroll_ice_sphere_fx( localclientnum )
{
    self mapshaderconstant( localclientnum, 1, "scriptVector1" );
    x = 0;
    y = 0;
    z = 0;
    w = 0;
    self setshaderconstant( localclientnum, 1, x, y, z, w );
}

staff_water_end_all_torso_damage_fx( localclientnum )
{
    self.e_fx delete();
}

staff_water_play_all_torso_damage_fx( localclientnum )
{
    if ( !isdefined( self.staff_water_damage_torso_fx ) )
        self.staff_water_damage_torso_fx = [];

    if ( isdefined( self.staff_water_damage_torso_fx[localclientnum] ) )
        return;

    self.e_fx = spawn( localclientnum, self.origin + vectorscale( ( 0, 0, 1 ), 33.0 ), "script_model" );
    self.e_fx setmodel( "tag_origin" );
    playfxontag( localclientnum, level._effect["staff_water_damage_torso"], self.e_fx, "tag_origin" );
}

staff_water_torso_damage_fx( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
        self.ice_fx = playfxontag( localclientnum, level._effect["staff_water_damage_torso"], self, "tag_origin" );
    else if ( isdefined( self.ice_fx ) )
        stopfx( localclientnum, self.ice_fx );
}