// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\_music;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm;

init()
{
    level.zombie_quantum_bomb_spawned_func = ::quantum_bomb_spawned;

    if ( getdvar( #"createfx" ) == "on" )
        return;

    if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "zombie_quantum_bomb" ) )
        return;

    level._effect["quantum_bomb_viewmodel_twist"] = loadfx( "weapon/quantum_bomb/fx_twist" );
    level._effect["quantum_bomb_viewmodel_press"] = loadfx( "weapon/quantum_bomb/fx_press" );
    level thread quantum_bomb_notetrack_think();
}

quantum_bomb_notetrack_think()
{
    for (;;)
    {
        level waittill( "notetrack", localclientnum, note );

        switch ( note )
        {
            case "quantum_bomb_twist":
                playviewmodelfx( localclientnum, level._effect["quantum_bomb_viewmodel_twist"], "tag_weapon" );
                break;
            case "quantum_bomb_press":
                playviewmodelfx( localclientnum, level._effect["quantum_bomb_viewmodel_press"], "tag_weapon" );
                break;
        }
    }
}

quantum_bomb_spawned( localclientnum, play_sound )
{
    temp_ent = spawn( 0, self.origin, "script_origin" );
    temp_ent playsound( 0, "wpn_quantum_rise" );

    while ( isdefined( self ) )
    {
        temp_ent.origin = self.origin;
        wait 0.05;
    }

    temp_ent delete();
}