// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\_music;

init()
{
    if ( getdvar( #"createfx" ) == "on" )
        return;

    level._effect["lightning_hit"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_ug_impact_hit" );
    level._effect["lightning_hit_end"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_ug_impact_hit_end" );
    level._effect["lightning_miss"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_ug_impact_miss" );
    level._effect["lightning_arc"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_trail_bolt_cheap" );
    level._effect["lightning_impact"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_ug_impact_hit_torso" );
    level._effect["tesla_shock_eyes"] = loadfx( "maps/zombie/fx_zombie_tesla_shock_eyes" );
    registerclientfield( "actor", "lightning_hit_fx", 14000, 1, "int", ::lightning_hit_play_fx );
    registerclientfield( "actor", "lightning_impact_fx", 14000, 1, "int", ::lightning_impact_play_fx );
    registerclientfield( "scriptmover", "lightning_miss_fx", 14000, 1, "int", ::lightning_miss_play_fx );
    registerclientfield( "scriptmover", "lightning_arc_fx", 14000, 1, "int", ::lightning_arc_play_fx );
}

lightning_hit_play_fx( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
        playfxontag( localclientnum, level._effect["lightning_hit"], self, "J_SpineUpper" );
}

lightning_impact_play_fx( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
        playfxontag( localclientnum, level._effect["lightning_impact"], self, "J_SpineUpper" );
}

lightning_miss_play_fx( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
        playfxontag( localclientnum, level._effect["lightning_miss"], self, "tag_origin" );
}

lightning_arc_play_fx( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
        playfxontag( localclientnum, level._effect["lightning_arc"], self, "tag_origin" );
}