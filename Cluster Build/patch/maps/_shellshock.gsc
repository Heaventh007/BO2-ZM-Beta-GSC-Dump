// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;

main( origin, duration, shock_range, nmaxdamagebase, nrandamagebase, nmindamagebase, nexposed, customshellshock, stancelockduration )
{
    assert( isdefined( origin ), "_shellshock::main() needs a origin passed in now for coop consideration." );

    if ( !isdefined( shock_range ) )
        shock_range = 500;

    if ( !isdefined( duration ) )
        duration = 12;
    else if ( duration < 7 )
        duration = 7;

    if ( !isdefined( nmaxdamagebase ) )
        nmaxdamagebase = 150;

    if ( !isdefined( nrandamagebase ) )
        nrandamagebase = 100;

    if ( !isdefined( nmindamagebase ) )
        nmindamagebase = 100;

    if ( !isdefined( customshellshock ) )
        customshellshock = "default";

    players = get_players();

    for ( q = 0; q < players.size; q++ )
    {
        if ( distancesquared( players[q].origin, origin ) < shock_range * shock_range )
            players[q] thread shellshock_thread( duration, nmaxdamagebase, nrandamagebase, nmindamagebase, nexposed, customshellshock, stancelockduration );
    }
}

shellshock_thread( duration, nmaxdamagebase, nrandamagebase, nmindamagebase, nexposed, customshellshock, stancelockduration )
{
    origin = self getorigin() + ( 0, 8, 2 );

    if ( isdefined( nrandamagebase ) && nrandamagebase > 0 )
        maxdamage = nmaxdamagebase + randomint( nrandamagebase );
    else
        maxdamage = nmaxdamagebase;

    mindamage = nmindamagebase;
    wait 0.25;
    radiusdamage( origin, 320, maxdamage, mindamage );
    earthquake( 0.75, 2, origin, 2250 );

    if ( isalive( self ) )
    {
        if ( isdefined( stancelockduration ) && stancelockduration > 0 )
        {
            self allowstand( 0 );
            self allowcrouch( 0 );
            self allowprone( 1 );
        }

        wait 0.15;
        self viewkick( 127, self.origin );
        self shellshock( customshellshock, duration );

        if ( !isdefined( nexposed ) )
            level thread playerhitable( duration );

        if ( !isdefined( stancelockduration ) )
            stancelockduration = 1.5;

        wait( stancelockduration );
        self allowstand( 1 );
        self allowcrouch( 1 );
    }
}

playerhitable( duration )
{
    self.shellshocked = 1;
    self.ignoreme = 1;
    level notify( "player is shell shocked" );
    level endon( "player is shell shocked" );
    wait( duration - 1 );
    self.shellshocked = 0;
    self.ignoreme = 0;
}

endondeath()
{
    self waittill( "death" );
    waittillframeend;
    self notify( "end_explode" );
}

grenade_earthquake()
{
    self thread endondeath();
    self endon( "end_explode" );
    self waittill( "explode", position );
    playrumbleonposition( "grenade_rumble", position );
    earthquake( 0.5, 0.5, position, 1000 );
}

c4_earthquake()
{
    self thread endondeath();
    self endon( "end_explode" );
    self waittill( "explode", position );
    playrumbleonposition( "grenade_rumble", position );
    earthquake( 0.5, 0.5, position, 1000 );
}

satchel_earthquake()
{
    self thread endondeath();
    self endon( "end_explode" );
    self waittill( "explode", position );
    playrumbleonposition( "grenade_rumble", position );
    earthquake( 0.5, 0.5, position, 1000 );
}

barrel_earthquake()
{
    playrumbleonposition( "grenade_rumble", self.origin );
    earthquake( 0.5, 0.5, self.origin, 1000 );
}

artillery_earthquake()
{
    playrumbleonposition( "artillery_rumble", self.origin );
    earthquake( 0.7, 0.5, self.origin, 800 );
}

rocket_earthquake()
{
    self thread endondeath();
    self endon( "end_explode" );
    self waittill( "projectile_impact", weapon_name, position, explosion_radius, rocket_entity );
    playrumbleonposition( "grenade_rumble", position );
    earthquake( 0.5, 0.5, position, 1000 );
}

explosive_bolt_earthquake()
{
    self thread endondeath();
    self endon( "end_explode" );
    self waittill( "explode", position );
    playrumbleonposition( "grenade_rumble", position );
    earthquake( 0.5, 0.5, position, 1000 );
}

mortar_earthquake( position )
{
    playrumbleonposition( "grenade_rumble", position );
    earthquake( 0.5, 0.5, position, 800 );
}