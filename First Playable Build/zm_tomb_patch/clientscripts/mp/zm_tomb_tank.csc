// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_music;

#using_animtree("zm_tomb_tank");

init()
{
    registerclientfield( "vehicle", "mortar_firing", 14000, 2, "int", ::play_mortar_launch );
    registerclientfield( "scriptmover", "mortar_landing", 14000, 2, "int", ::play_mortar_land );
    registerclientfield( "vehicle", "tank_tread_fx", 14000, 1, "int", ::play_tread_fx );
    scriptmodelsuseanimtree( #animtree );
}

play_tread_fx( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == oldval )
        return;

    if ( newval == 1 )
    {
/#
        println( "Mark IV Tank Tread FX ON" );
#/
        self thread tread_fx_loop( localclientnum );
    }
    else if ( newval == 0 )
    {
/#
        println( "Mark IV Tank Tread FX OFF" );
#/
        self notify( "tread_fx_stop" );
    }
}

tread_fx_loop( localclientnum )
{
    self endon( "tread_fx_stop" );

    while ( true )
    {
        self.tread_fx_left = playfxontag( localclientnum, level._effect["tank_treads"], self, "tag_wheel_back_left" );
        self.tread_fx_right = playfxontag( localclientnum, level._effect["tank_treads"], self, "tag_wheel_back_right" );
        wait 0.5;
    }
}

play_mortar_launch( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
    {
        playfxontag( localclientnum, level._effect["mortar_launch"], self, "tag_mortar_l_fx" );
        wait 0.7;
        playfxontag( localclientnum, level._effect["mortar_launch"], self, "tag_mortar_r_fx" );
    }
}

play_mortar_land( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
    {
        playfx( localclientnum, level._effect["fx_mortarexp_sand"], self.origin );
        wait 0.7;
        playfx( localclientnum, level._effect["fx_mortarexp_sand"], self.origin );
    }
}