// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;

init()
{
    if ( !maps\mp\zombies\_zm_weapons::is_weapon_included( "tesla_gun_zm" ) && !is_true( level.uses_tesla_powerup ) )
        return;

    level._effect["tesla_bolt"] = loadfx( "maps/zombie/fx_zombie_tesla_bolt_secondary" );
    level._effect["tesla_shock"] = loadfx( "maps/zombie/fx_zombie_tesla_shock" );
    level._effect["tesla_shock_secondary"] = loadfx( "maps/zombie/fx_zombie_tesla_shock_secondary" );
    level._effect["tesla_viewmodel_rail"] = loadfx( "maps/zombie/fx_zombie_tesla_rail_view" );
    level._effect["tesla_viewmodel_tube"] = loadfx( "maps/zombie/fx_zombie_tesla_tube_view" );
    level._effect["tesla_viewmodel_tube2"] = loadfx( "maps/zombie/fx_zombie_tesla_tube_view2" );
    level._effect["tesla_viewmodel_tube3"] = loadfx( "maps/zombie/fx_zombie_tesla_tube_view3" );
    level._effect["tesla_viewmodel_rail_upgraded"] = loadfx( "maps/zombie/fx_zombie_tesla_rail_view_ug" );
    level._effect["tesla_viewmodel_tube_upgraded"] = loadfx( "maps/zombie/fx_zombie_tesla_tube_view_ug" );
    level._effect["tesla_viewmodel_tube2_upgraded"] = loadfx( "maps/zombie/fx_zombie_tesla_tube_view2_ug" );
    level._effect["tesla_viewmodel_tube3_upgraded"] = loadfx( "maps/zombie/fx_zombie_tesla_tube_view3_ug" );
    level._effect["tesla_shock_eyes"] = loadfx( "maps/zombie/fx_zombie_tesla_shock_eyes" );
    precacheshellshock( "electrocution" );
    set_zombie_var( "tesla_max_arcs", 5 );
    set_zombie_var( "tesla_max_enemies_killed", 20 );
    set_zombie_var( "tesla_radius_start", 300 );
    set_zombie_var( "tesla_radius_decay", 20 );
    set_zombie_var( "tesla_head_gib_chance", 50 );
    set_zombie_var( "tesla_arc_travel_time", 0.5, 1 );
    set_zombie_var( "tesla_kills_for_powerup", 15 );
    set_zombie_var( "tesla_min_fx_distance", 128 );
    set_zombie_var( "tesla_network_death_choke", 4 );
/#
    level thread tesla_devgui_dvar_think();
#/
    onplayerconnect_callback( ::on_player_connect );
}

tesla_devgui_dvar_think()
{
/#
    if ( !maps\mp\zombies\_zm_weapons::is_weapon_included( "tesla_gun_zm" ) )
        return;

    setdvar( "scr_tesla_max_arcs", level.zombie_vars["tesla_max_arcs"] );
    setdvar( "scr_tesla_max_enemies", level.zombie_vars["tesla_max_enemies_killed"] );
    setdvar( "scr_tesla_radius_start", level.zombie_vars["tesla_radius_start"] );
    setdvar( "scr_tesla_radius_decay", level.zombie_vars["tesla_radius_decay"] );
    setdvar( "scr_tesla_head_gib_chance", level.zombie_vars["tesla_head_gib_chance"] );
    setdvar( "scr_tesla_arc_travel_time", level.zombie_vars["tesla_arc_travel_time"] );

    for (;;)
    {
        level.zombie_vars["tesla_max_arcs"] = getdvarint( #"_id_31F0CB32" );
        level.zombie_vars["tesla_max_enemies_killed"] = getdvarint( #"_id_C613594F" );
        level.zombie_vars["tesla_radius_start"] = getdvarint( #"_id_F0BC7E19" );
        level.zombie_vars["tesla_radius_decay"] = getdvarint( #"_id_EFA4DB31" );
        level.zombie_vars["tesla_head_gib_chance"] = getdvarint( #"_id_DF26DD48" );
        level.zombie_vars["tesla_arc_travel_time"] = getdvarfloat( #"_id_E5069375" );
        wait 0.5;
    }
#/
}

tesla_damage_init( hit_location, hit_origin, player )
{
    player endon( "disconnect" );

    if ( isdefined( player.tesla_enemies_hit ) && player.tesla_enemies_hit > 0 )
    {
        debug_print( "TESLA: Player: '" + player.name + "' currently processing tesla damage" );
        return;
    }

    if ( isdefined( self.zombie_tesla_hit ) && self.zombie_tesla_hit )
        return;

    debug_print( "TESLA: Player: '" + player.name + "' hit with the tesla gun" );
    player.tesla_enemies = undefined;
    player.tesla_enemies_hit = 1;
    player.tesla_powerup_dropped = 0;
    player.tesla_arc_count = 0;
    self tesla_arc_damage( self, player, 1 );

    if ( player.tesla_enemies_hit >= 4 )
        player thread tesla_killstreak_sound();

    player.tesla_enemies_hit = 0;
}

tesla_arc_damage( source_enemy, player, arc_num )
{
    player endon( "disconnect" );
    debug_print( "TESLA: Evaulating arc damage for arc: " + arc_num + " Current enemies hit: " + player.tesla_enemies_hit );
    tesla_flag_hit( self, 1 );
    wait_network_frame();
    radius_decay = level.zombie_vars["tesla_radius_decay"] * arc_num;
    enemies = tesla_get_enemies_in_area( self gettagorigin( "j_head" ), level.zombie_vars["tesla_radius_start"] - radius_decay, player );
    tesla_flag_hit( enemies, 1 );
    self thread tesla_do_damage( source_enemy, arc_num, player );
    debug_print( "TESLA: " + enemies.size + " enemies hit during arc: " + arc_num );

    for ( i = 0; i < enemies.size; i++ )
    {
        if ( enemies[i] == self )
            continue;

        if ( tesla_end_arc_damage( arc_num + 1, player.tesla_enemies_hit ) )
        {
            tesla_flag_hit( enemies[i], 0 );
            continue;
        }

        player.tesla_enemies_hit++;
        enemies[i] tesla_arc_damage( self, player, arc_num + 1 );
    }
}

tesla_end_arc_damage( arc_num, enemies_hit_num )
{
    if ( arc_num >= level.zombie_vars["tesla_max_arcs"] )
    {
        debug_print( "TESLA: Ending arcing. Max arcs hit" );
        return true;
    }

    if ( enemies_hit_num >= level.zombie_vars["tesla_max_enemies_killed"] )
    {
        debug_print( "TESLA: Ending arcing. Max enemies killed" );
        return true;
    }

    radius_decay = level.zombie_vars["tesla_radius_decay"] * arc_num;

    if ( level.zombie_vars["tesla_radius_start"] - radius_decay <= 0 )
    {
        debug_print( "TESLA: Ending arcing. Radius is less or equal to zero" );
        return true;
    }

    return false;
}

tesla_get_enemies_in_area( origin, distance, player )
{
/#
    level thread tesla_debug_arc( origin, distance );
#/
    distance_squared = distance * distance;
    enemies = [];

    if ( !isdefined( player.tesla_enemies ) )
    {
        player.tesla_enemies = get_round_enemy_array();
        player.tesla_enemies = get_array_of_closest( origin, player.tesla_enemies );
    }

    zombies = player.tesla_enemies;

    if ( isdefined( zombies ) )
    {
        for ( i = 0; i < zombies.size; i++ )
        {
            if ( !isdefined( zombies[i] ) )
                continue;

            test_origin = zombies[i] gettagorigin( "j_head" );

            if ( isdefined( zombies[i].zombie_tesla_hit ) && zombies[i].zombie_tesla_hit == 1 )
                continue;

            if ( is_magic_bullet_shield_enabled( zombies[i] ) )
                continue;

            if ( distancesquared( origin, test_origin ) > distance_squared )
                continue;

            if ( !bullettracepassed( origin, test_origin, 0, undefined ) )
                continue;

            enemies[enemies.size] = zombies[i];
        }
    }

    return enemies;
}

tesla_flag_hit( enemy, hit )
{
    if ( isarray( enemy ) )
    {
        for ( i = 0; i < enemy.size; i++ )
            enemy[i].zombie_tesla_hit = hit;
    }
    else
        enemy.zombie_tesla_hit = hit;
}

tesla_do_damage( source_enemy, arc_num, player )
{
    player endon( "disconnect" );

    if ( arc_num > 1 )
        wait( randomfloatrange( 0.2, 0.6 ) * arc_num );

    if ( !isdefined( self ) || !isalive( self ) )
        return;

    if ( !self.isdog )
    {
        if ( self.has_legs )
            self.deathanim = random( level._zombie_tesla_death[self.animname] );
        else
            self.deathanim = random( level._zombie_tesla_crawl_death[self.animname] );
    }
    else
        self.a.nodeath = undefined;

    if ( is_true( self.is_traversing ) )
        self.deathanim = undefined;

    if ( source_enemy != self )
    {
        if ( player.tesla_arc_count > 3 )
        {
            wait_network_frame();
            player.tesla_arc_count = 0;
        }

        player.tesla_arc_count++;
        source_enemy tesla_play_arc_fx( self );
    }

    while ( player.tesla_network_death_choke > level.zombie_vars["tesla_network_death_choke"] )
    {
        debug_print( "TESLA: Choking Tesla Damage. Dead enemies this network frame: " + player.tesla_network_death_choke );
        wait 0.05;
    }

    if ( !isdefined( self ) || !isalive( self ) )
        return;

    player.tesla_network_death_choke++;
    self.tesla_death = 1;
    self tesla_play_death_fx( arc_num );
    origin = source_enemy.origin;

    if ( source_enemy == self || !isdefined( origin ) )
        origin = player.origin;

    if ( !isdefined( self ) || !isalive( self ) )
        return;

    if ( isdefined( self.tesla_damage_func ) )
    {
        self [[ self.tesla_damage_func ]]( origin, player );
        return;
    }
    else
        self dodamage( self.health + 666, origin, player );

    player maps\mp\zombies\_zm_score::player_add_points( "death", "", "" );
}

tesla_play_death_fx( arc_num )
{
    tag = "J_SpineUpper";
    fx = "tesla_shock";

    if ( self.isdog )
        tag = "J_Spine1";

    if ( arc_num > 1 )
        fx = "tesla_shock_secondary";

    network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[fx], self, tag );
    self playsound( "wpn_imp_tesla" );

    if ( isdefined( self.tesla_head_gib_func ) && !self.head_gibbed )
        [[ self.tesla_head_gib_func ]]();
}

tesla_play_arc_fx( target )
{
    if ( !isdefined( self ) || !isdefined( target ) )
    {
        wait( level.zombie_vars["tesla_arc_travel_time"] );
        return;
    }

    tag = "J_SpineUpper";

    if ( self.isdog )
        tag = "J_Spine1";

    target_tag = "J_SpineUpper";

    if ( target.isdog )
        target_tag = "J_Spine1";

    origin = self gettagorigin( tag );
    target_origin = target gettagorigin( target_tag );
    distance_squared = level.zombie_vars["tesla_min_fx_distance"] * level.zombie_vars["tesla_min_fx_distance"];

    if ( distancesquared( origin, target_origin ) < distance_squared )
    {
        debug_print( "TESLA: Not playing arcing FX. Enemies too close." );
        return;
    }

    fxorg = spawn( "script_model", origin );
    fxorg setmodel( "tag_origin" );
    fx = playfxontag( level._effect["tesla_bolt"], fxorg, "tag_origin" );
    playsoundatposition( "wpn_tesla_bounce", fxorg.origin );
    fxorg moveto( target_origin, level.zombie_vars["tesla_arc_travel_time"] );
    fxorg waittill( "movedone" );
    fxorg delete();
}

tesla_debug_arc( origin, distance )
{
/#
    if ( getdvarint( #"zombie_debug" ) != 3 )
        return;

    start = gettime();

    while ( gettime() < start + 3000 )
    {
        drawcylinder( origin, distance, 1 );
        wait 0.05;
    }
#/
}

is_tesla_damage( mod )
{
    return isdefined( self.damageweapon ) && ( self.damageweapon == "tesla_gun_zm" || self.damageweapon == "tesla_gun_upgraded_zm" ) && ( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" );
}

enemy_killed_by_tesla()
{
    return isdefined( self.tesla_death ) && self.tesla_death == 1;
}

on_player_connect()
{
    self thread tesla_sound_thread();
    self thread tesla_pvp_thread();
    self thread tesla_network_choke();
}

tesla_sound_thread()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );

    for (;;)
    {
        result = self waittill_any_return( "grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback" );

        if ( !isdefined( result ) )
            continue;

        if ( ( result == "weapon_change" || result == "grenade_fire" ) && ( self getcurrentweapon() == "tesla_gun_zm" || self getcurrentweapon() == "tesla_gun_upgraded_zm" ) )
        {
            self playloopsound( "wpn_tesla_idle", 0.25 );
            continue;
        }

        self notify( "weap_away" );
        self stoploopsound( 0.25 );
    }
}

tesla_engine_sweets()
{
    self endon( "disconnect" );
    self endon( "weap_away" );

    while ( true )
    {
        wait( randomintrange( 7, 15 ) );
        self play_tesla_sound( "wpn_tesla_sweeps_idle" );
    }
}

tesla_pvp_thread()
{
    self endon( "disconnect" );
    self endon( "death" );
    self waittill( "spawned_player" );

    for (;;)
    {
        self waittill( "weapon_pvp_attack", attacker, weapon, damage, mod );

        if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
            continue;

        if ( weapon != "tesla_gun_zm" && weapon != "tesla_gun_upgraded_zm" )
            continue;

        if ( mod != "MOD_PROJECTILE" && mod != "MOD_PROJECTILE_SPLASH" )
            continue;

        if ( self == attacker )
        {
            damage = int( self.maxhealth * 0.25 );

            if ( damage < 25 )
                damage = 25;

            if ( self.health - damage < 1 )
                self.health = 1;
            else
                self.health = self.health - damage;
        }

        self setelectrified( 1.0 );
        self shellshock( "electrocution", 1.0 );
        self playsound( "wpn_tesla_bounce" );
    }
}

play_tesla_sound( emotion )
{
    self endon( "disconnect" );

    if ( !isdefined( level.one_emo_at_a_time ) )
    {
        level.one_emo_at_a_time = 0;
        level.var_counter = 0;
    }

    if ( level.one_emo_at_a_time == 0 )
    {
        level.var_counter++;
        level.one_emo_at_a_time = 1;
        org = spawn( "script_origin", self.origin );
        org linkto( self );
        org playsoundwithnotify( emotion, "sound_complete" + "_" + level.var_counter );
        org waittill( "sound_complete" + "_" + level.var_counter );
        org delete();
        level.one_emo_at_a_time = 0;
    }
}

tesla_killstreak_sound()
{
    self endon( "disconnect" );
    self maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "tesla" );
    wait 3.5;
    level clientnotify( "TGH" );
}

tesla_network_choke()
{
    self endon( "disconnect" );
    self endon( "death" );
    self waittill( "spawned_player" );
    self.tesla_network_death_choke = 0;

    for (;;)
    {
        wait_network_frame();
        wait_network_frame();
        self.tesla_network_death_choke = 0;
    }
}