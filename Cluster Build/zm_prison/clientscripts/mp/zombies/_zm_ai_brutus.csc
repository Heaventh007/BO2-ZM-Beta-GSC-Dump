// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

precache()
{

}

init()
{
    registerclientfield( "actor", "helmet_off", 9000, 1, "int", ::brutus_helmet_launch_cb );
    registerclientfield( "actor", "brutus_lock_down", 9000, 1, "int", ::brutus_lock_down_effects_cb, 1 );
    registerbrutusfootstepcb( "zm_alcatraz_brutus", ::brutusfootstepcbfunc );
}

brutus_helmet_launch_cb( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( is_true( self.helmet_launched ) )
        return;

    if ( newval )
    {
        self.helmet_launched = 1;
        createdynentandlaunch( localclientnum, "c_zom_cellbreaker_helmet", self.origin + vectorscale( ( 0, 0, 1 ), 85.0 ), self.angles, self.origin + vectorscale( ( 0, 0, 1 ), 85.0 ), anglestoforward( self.angles ) );
    }
}

brutus_lock_down_effects_cb( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    player = getlocalplayer( localclientnum );
    player earthquake( 0.7, 1, self.origin, 1500 );
    playrumbleonposition( localclientnum, "explosion_generic", self.origin );
}

brutusfootstepcbfunc( localclientnum, pos, surface, notetrack, bone )
{
    player = getlocalplayer( localclientnum );

    if ( abs( self.origin[2] - player.origin[2] ) < 100 )
    {
        player earthquake( 0.5, 0.1, self.origin, 1500 );
        playrumbleonposition( localclientnum, "brutus_footsteps", self.origin );
    }

    footstepdoeverything();
}

registerbrutusfootstepcb( aitype, func )
{
    if ( !isdefined( level._footstepcbfuncs ) )
        level._footstepcbfuncs = [];

    if ( isdefined( level._footstepcbfuncs[aitype] ) )
    {
/#
        println( "Attempting to register footstep callback function for ai type " + aitype + " multiple times." );
#/
        return;
    }

    level._footstepcbfuncs[aitype] = func;
}