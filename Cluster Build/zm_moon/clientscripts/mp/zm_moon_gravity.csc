// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm;

init()
{
    level.low_gravity_default = -136;
}

zombie_low_gravity( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    self endon( "death" );
    self endon( "entityshutdown" );

    if ( newval )
    {
        self setphysicsgravity( level.low_gravity_default );
        self.in_low_g = 1;
    }
    else
    {
        self clearphysicsgravity();
        self.in_low_g = 0;
    }
}