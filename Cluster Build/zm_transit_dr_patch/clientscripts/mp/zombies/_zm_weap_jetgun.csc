// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\_music;
#include clientscripts\mp\zombies\_zm_weapons;

init()
{
    if ( getdvar( #"createfx" ) == "on" )
        return;

    if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "jetgun_zm" ) )
        return;
}

player_init()
{
    waitforclient( 0 );
    level.jetgun_play_fx_power_cell = [];
    players = getlocalplayers();

    for ( i = 0; i < players.size; i++ )
    {
        level.jetgun_play_fx_power_cell[i] = 1;
        players[i] thread jetgun_fx_power_cell( i );
    }
}

jetgun_fx_power_cell( localclientnum )
{
    self endon( "disconnect" );
    oldammo = -1;
    oldcount = -1;
    self thread jetgun_fx_listener( localclientnum );

    for (;;)
    {
        waitrealtime( 0.1 );

        while ( !clienthassnapshot( 0 ) )
            wait 0.05;

        weaponname = undefined;
        currentweapon = getcurrentweapon( localclientnum );

        if ( !level.jetgun_play_fx_power_cell[localclientnum] || isthrowinggrenade( localclientnum ) || ismeleeing( localclientnum ) || isonturret( localclientnum ) || currentweapon != "jetgun_zm" && currentweapon != "jetgun_upgraded_zm" )
        {
            if ( oldammo != -1 )
                jetgun_play_power_cell_fx( localclientnum, 0 );

            oldammo = -1;
            oldcount = -1;
            continue;
        }

        ammo = getweaponammoclip( localclientnum, currentweapon );

        if ( oldammo > 0 && oldammo != ammo )
            jetgun_fx_fire( localclientnum );

        oldammo = ammo;

        if ( ammo > level.jetgun_power_cell_fx_handles.size )
            ammo = level.jetgun_power_cell_fx_handles.size;

        if ( oldcount == -1 || oldcount != ammo )
            level thread jetgun_play_power_cell_fx( localclientnum, ammo );

        oldcount = ammo;
    }
}

jetgun_play_power_cell_fx( localclientnum, count )
{
    level notify( "kill_power_cell_fx" );

    for ( i = 0; i < level.jetgun_power_cell_fx_handles.size; i++ )
    {
        if ( isdefined( level.jetgun_power_cell_fx_handles[i] ) && level.jetgun_power_cell_fx_handles[i] != -1 )
        {
            deletefx( localclientnum, level.jetgun_power_cell_fx_handles[i] );
            level.jetgun_power_cell_fx_handles[i] = -1;
        }
    }

    if ( !count )
        return;

    level endon( "kill_power_cell_fx" );

    for (;;)
    {
        currentweapon = getcurrentweapon( localclientnum );

        if ( currentweapon != "jetgun_zm" && currentweapon != "jetgun_upgraded_zm" )
        {
            wait 0.05;
            continue;
        }

        for ( i = count; i > 0; i-- )
        {
            fx = level._effect["jetgun_viewmodel_power_cell" + i];

            if ( currentweapon == "jetgun_upgraded_zm" )
                fx = level._effect["jetgun_viewmodel_power_cell_upgraded" + i];

            level.jetgun_power_cell_fx_handles[i - 1] = playviewmodelfx( localclientnum, fx, "tag_bulb" + i );
        }

        waitrealtime( 3 );
    }
}

jetgun_fx_fire( localclientnum )
{
    currentweapon = getcurrentweapon( localclientnum );
    fx = level._effect["jetgun_viewmodel_steam"];

    if ( currentweapon == "jetgun_upgraded_zm" )
        fx = level._effect["jetgun_viewmodel_steam_upgraded"];

    for ( i = level.jetgun_steam_vents; i > 0; i-- )
        playviewmodelfx( localclientnum, fx, "tag_steam" + i );

    playsound( localclientnum, "wpn_thunder_breath", ( 0, 0, 0 ) );
}

jetgun_notetrack_think()
{
    for (;;)
    {
        level waittill( "notetrack", localclientnum, note );

        switch ( note )
        {
            case "jetgun_putaway_start":
                level.jetgun_play_fx_power_cell[localclientnum] = 0;
                break;
            case "jetgun_pullout_start":
                level.jetgun_play_fx_power_cell[localclientnum] = 1;
                break;
            case "jetgun_fire_start":
                jetgun_fx_fire( localclientnum );
                break;
        }
    }
}

jetgun_death_effects( localclientnum, weaponname, userdata )
{

}

thread_zombie_vox()
{
    ent = spawn( 0, self.origin, "script_origin" );
    playsound( 0, "wpn_thundergun_proj_impact_zombie", ent.origin );
    wait 5;
    ent delete();
}

jetgun_fx_listener( localclientnum )
{
    self endon( "disconnect" );

    while ( true )
    {
        level waittill( "tgfx0" );
        level.jetgun_play_fx_power_cell[localclientnum] = 0;
        level waittill( "tgfx1" );
        level.jetgun_play_fx_power_cell[localclientnum] = 1;
    }
}