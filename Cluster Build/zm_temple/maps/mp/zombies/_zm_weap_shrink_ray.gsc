// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_spawner;

init()
{
    if ( !maps\mp\zombies\_zm_weapons::is_weapon_included( "shrink_ray_zm" ) )
        return;

    level.shrink_models = [];

    if ( isdefined( level.shrink_ray_model_mapping_func ) )
        [[ level.shrink_ray_model_mapping_func ]]();

    set_zombie_var( "shrink_ray_fling_range", 480 );
    keys = getarraykeys( level.shrink_models );

    for ( i = 0; i < keys.size; i++ )
        precachemodel( level.shrink_models[keys[i]] );

    level._effect["shrink_ray_stepped_on"] = loadfx( "maps/zombie_temple/fx_ztem_zombie_mini_squish" );
    level._effect["shrink_ray_stepped_on_in_water"] = loadfx( "maps/zombie_temple/fx_ztem_zombie_mini_drown" );
    level._effect["shrink_ray_stepped_on_no_gore"] = loadfx( "maps/zombie_temple/fx_ztem_monkey_shrink" );
    level._effect["shrink"] = loadfx( "weapon/shrink_ray/zombie_shrink" );
    level._effect["unshrink"] = loadfx( "weapon/shrink_ray/zombie_unshrink" );
    level thread shrink_ray_on_player_connect();
    level._shrinkable_objects = [];
}

add_shrinkable_object( ent )
{
    level._shrinkable_objects = add_to_array( level._shrinkable_objects, ent, 0 );
}

remove_shrinkable_object( ent )
{
    arrayremovevalue( level._shrinkable_objects, ent );
}

shrink_ray_on_player_connect()
{
    for (;;)
    {
        level waittill( "connecting", player );
        player thread wait_for_shrink_ray_fired();
    }
}

kicked_vox_network_choke()
{
    while ( true )
    {
        level._num_kicked_vox = 0;
        wait_network_frame();
    }
}

wait_for_shrink_ray_fired()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );

    for (;;)
    {
        self waittill( "weapon_fired" );
        currentweapon = self getcurrentweapon();

        if ( currentweapon == "shrink_ray_zm" || currentweapon == "shrink_ray_upgraded_zm" )
            self thread shrink_ray_fired( currentweapon == "shrink_ray_upgraded_zm" );
    }
}

shrink_ray_fired( upgraded )
{
    zombies = shrink_ray_get_enemies_in_range( upgraded, 0 );
    objects = shrink_ray_get_enemies_in_range( upgraded, 1 );
    zombies = arraycombine( zombies, objects, 1, 0 );
    maxshrinks = 1000;

    for ( i = 0; i < zombies.size && i < maxshrinks; i++ )
    {
        if ( isai( zombies[i] ) )
        {
            zombies[i] thread shrink_zombie( upgraded, self );
            continue;
        }

        zombies[i] notify( "shrunk", upgraded );
    }
}

shrink_ray_do_damage( upgraded, player )
{
    damage = 10;
    self dodamage( damage, player.origin, player, undefined, "projectile" );
    self shrink_ray_debug_print( damage, ( 0, 1, 0 ) );
}

shrink_corpse( upgraded, attacker )
{
    if ( isdefined( self.shrinked ) && self.shrinked )
        return;

    self.shrinked = 1;
    nummodels = self getattachsize();

    for ( i = nummodels - 1; i >= 0; i-- )
    {
        model = self getattachmodelname( i );
        self detach( model );
        attachmodel = level.shrink_models[model];

        if ( isdefined( attachmodel ) )
            self attach( attachmodel );
    }

    mini_model = level.shrink_models[self.model];

    if ( isdefined( mini_model ) )
        self setmodel( mini_model );
}

shrink_zombie( upgraded, attacker )
{
    self endon( "death" );

    if ( isdefined( self.shrinked ) && self.shrinked )
        return;

    if ( !isdefined( self.shrink_count ) )
        self.shrink_count = 0;

    shrinktime = 2.5;

    if ( self.animname == "sonic_zombie" )
    {
        if ( self.shrink_count == 0 )
            shrinktime = 0.75;
        else if ( self.shrink_count == 1 )
            shrinktime = 1.5;
        else
            shrinktime = 2.5;
    }
    else if ( self.animname == "napalm_zombie" )
    {
        if ( self.shrink_count == 0 )
            shrinktime = 0.75;
        else if ( self.shrink_count == 1 )
            shrinktime = 1.5;
        else
            shrinktime = 2.5;
    }
    else
    {
        shrinktime = 2.5;
        shrinktime = shrinktime + randomfloatrange( 0.0, 0.5 );
    }

    if ( upgraded )
        shrinktime = shrinktime * 2;

    self.shrink_count++;
    shrinkfxwait = 0;
    self setzombieshrink( 1 );
    self notify( "shrink" );
    self.shrinked = 1;
    self.shrinkattacker = attacker;

    if ( !isdefined( attacker.shrinked_zombies ) )
        attacker.shrinked_zombies = [];

    if ( !isdefined( attacker.shrinked_zombies[self.animname] ) )
        attacker.shrinked_zombies[self.animname] = 0;

    attacker.shrinked_zombies[self.animname]++;
    normalmodel = self.model;
    health = self.health;

    if ( isdefined( self.animname ) && self.animname == "monkey_zombie" )
    {
        if ( isdefined( self.shrink_ray_fling ) )
            self [[ self.shrink_ray_fling ]]( attacker );
        else
        {
            fling_range_squared = level.zombie_vars["shrink_ray_fling_range"] * level.zombie_vars["shrink_ray_fling_range"];
            view_pos = attacker getweaponmuzzlepoint();
            test_origin = self getcentroid();
            test_range_squared = distancesquared( view_pos, test_origin );
            dist_mult = ( fling_range_squared - test_range_squared ) / fling_range_squared;
            fling_vec = vectornormalize( test_origin - view_pos );
            fling_vec = ( fling_vec[0], fling_vec[1], abs( fling_vec[2] ) );
            fling_vec = vectorscale( fling_vec, 100 + 100 * dist_mult );
            self dodamage( self.health + 666, attacker.origin, attacker );
            self startragdoll();
            self launchragdoll( fling_vec );
        }
    }
    else if ( self zombie_gib_on_shrink_ray() )
        self shrink_death( attacker );
    else
    {
        self thread play_shrink_sound( "evt_shrink" );
        self.shrinkattacker thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "shrink" );
        self thread play_shrink_fx( "shrink", "J_MainRoot" );
        saved_meleedamage = self.meleedamage;
        self.meleedamage = 5;
        self maps\mp\zombies\_zm_spawner::zombie_eye_glow_stop();
        attachedmodels = [];
        attachedtags = [];
        hatmodel = self.hatmodel;
        nummodels = self getattachsize();

        for ( i = nummodels - 1; i >= 0; i-- )
        {
            model = self getattachmodelname( i );
            tag = self getattachtagname( i );
            ishat = isdefined( self.hatmodel ) && self.hatmodel == model;

            if ( ishat )
                self.hatmodel = undefined;

            attachedmodels[attachedmodels.size] = model;
            attachedtags[attachedtags.size] = tag;
            self detach( model );
            attachmodel = level.shrink_models[model];

            if ( isdefined( attachmodel ) )
            {
                self attach( attachmodel );

                if ( ishat )
                    self.hatmodel = attachmodel;
            }
        }

        mini_model = level.shrink_models[self.model];

        if ( isdefined( mini_model ) )
            self setmodel( mini_model );

        if ( self.has_legs )
            self setphysparams( 8, -2, 32 );
        else
        {
            neworigin = self.origin + vectorscale( ( 0, 0, 1 ), 10.0 );
            self teleport( neworigin, self.angles );
            self setphysparams( 8, -16, 10 );
        }

        self.health = 1;
        self thread play_ambient_vox();
        self thread watch_for_kicked();
        self thread watch_for_death();
        self.zombie_board_tear_down_callback = ::zomibe_shrunk_board_tear_down;

        if ( isdefined( self._zombie_shrink_callback ) )
            self [[ self._zombie_shrink_callback ]]();

        wait( shrinktime );
        self thread play_shrink_sound( "evt_unshrink" );
        self thread play_shrink_fx( "unshrink", "J_MainRoot" );
        wait 0.5;
        self.zombie_board_tear_down_callback = undefined;

        if ( isdefined( self._zombie_unshrink_callback ) )
            self [[ self._zombie_unshrink_callback ]]();

        nummodels = self getattachsize();

        for ( i = nummodels - 1; i >= 0; i-- )
        {
            model = self getattachmodelname( i );
            tag = self getattachtagname( i );
            self detach( model );
        }

        self.hatmodel = hatmodel;

        for ( i = 0; i < attachedmodels.size; i++ )
            self attach( attachedmodels[i] );

        self setmodel( normalmodel );

        if ( self.has_legs )
            self setphysparams( 15, 0, 72 );
        else
            self setphysparams( 15, 0, 24 );

        self.health = health;
        self.meleedamage = saved_meleedamage;
    }

    self maps\mp\zombies\_zm_spawner::zombie_eye_glow();
    self setzombieshrink( 0 );
    self notify( "unshrink" );
    self.shrinked = 0;
    self.shrinkattacker = undefined;
}

zombie_gib_on_shrink_ray()
{
    if ( isdefined( self getlinkedent() ) )
        return true;

    if ( is_true( self.sliding ) )
        return true;

    if ( is_true( self.in_the_ceiling ) )
        return true;

    return false;
}

play_ambient_vox()
{
    self endon( "unshrink" );
    self endon( "stepped_on" );
    self endon( "kicked" );
    self endon( "death" );
    wait( randomfloatrange( 0.2, 0.5 ) );

    while ( true )
    {
        self playsound( "zmb_mini_ambient" );
        wait( randomfloatrange( 1, 2.25 ) );
    }
}

play_shrink_fx( fxname, jointname, offset )
{
    playfxontag( level._effect[fxname], self, "tag_origin" );
}

play_shrink_sound( alias )
{
    self endon( "death" );
    wait( randomfloat( 0.5 ) );
    self play_sound_on_ent( alias );
}

watch_for_kicked()
{
    self endon( "death" );
    self endon( "unshrink" );
    self.shrinktrigger = spawn( "trigger_radius", self.origin, 0, 30, 24 );
    self.shrinktrigger sethintstring( "" );
    self.shrinktrigger setcursorhint( "HINT_NOICON" );
    self.shrinktrigger enablelinkto();
    self.shrinktrigger linkto( self );

    while ( true )
    {
        self.shrinktrigger waittill( "trigger", who );

        if ( !isplayer( who ) )
            continue;

        if ( !is_true( self.completed_emerging_into_playable_area ) )
            continue;

        if ( is_true( self.magic_bullet_shield ) )
            continue;

        movement = who getnormalizedmovement();

        if ( length( movement ) < 0.1 )
            continue;

        toenemy = self.origin - who.origin;
        toenemy = ( toenemy[0], toenemy[1], 0 );
        toenemy = vectornormalize( toenemy );
        forward_view_angles = anglestoforward( who.angles );
        dotfacing = vectordot( forward_view_angles, toenemy );

        if ( dotfacing > 0.5 && movement[0] > 0.0 )
        {
            self notify( "kicked" );
            self kicked_death( who );
        }
        else
        {
            self notify( "stepped_on" );
            self shrink_death( who );
        }
    }
}

watch_for_death()
{
    self endon( "unshrink" );
    self endon( "stepped_on" );
    self endon( "kicked" );
    self waittill( "death" );
    self shrink_death();
}

kicked_death( killer )
{
    if ( isdefined( self.shrinktrigger ) )
        self.shrinktrigger delete();

    self thread kicked_sound();
    kickangles = killer.angles;
    kickangles = kickangles + ( randomfloatrange( -30, -20 ), randomfloatrange( -5, 5 ), 0 );
    launchdir = anglestoforward( kickangles );

    if ( killer issprinting() )
        launchforce = randomfloatrange( 350, 400 );
    else
    {
        vel = killer getvelocity();
        speed = length( vel );
        scale = clamp( speed / 190, 0.1, 1.0 );
        launchforce = randomfloatrange( 200 * scale, 250 * scale );
    }

    self startragdoll();
    self launchragdoll( launchdir * launchforce );
    self setclientflag( level._cf_actor_ragdoll_impact_gib );
    wait_network_frame();
    killer thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "shrunken" );
    self dodamage( self.health + 666, self.origin, killer );
}

kicked_sound()
{
    if ( !isdefined( level._num_kicked_vox ) )
        level thread kicked_vox_network_choke();

    if ( level._num_kicked_vox > 3 )
        return;

    level._num_kicked_vox++;
    playsoundatposition( "zmb_mini_kicked", self.origin );
}

shrink_death( killer )
{
    if ( isdefined( self.shrinktrigger ) )
        self.shrinktrigger delete();

    playsoundatposition( "zmb_mini_squashed", self.origin );

    if ( is_mature() )
    {
        fx_name = "shrink_ray_stepped_on";

        if ( self depthinwater() > 0 )
            fx_name = "shrink_ray_stepped_on_in_water";

        playfx( level._effect[fx_name], self.origin );
    }
    else
        playfx( level._effect["shrink_ray_stepped_on_no_gore"], self.origin );

    self thread maps\mp\zombies\_zm_spawner::zombie_eye_glow_stop();
    wait_network_frame();
    self hide();
    self dodamage( self.health + 666, self.origin, killer );
}

shrink_ray_get_enemies_in_range( upgraded, shrinkable_objects )
{
    range = 480;
    radius = 60;

    if ( upgraded )
    {
        range = 1200;
        radius = 84;
    }

    hitzombies = [];
    view_pos = self getweaponmuzzlepoint();
    test_list = undefined;

    if ( shrinkable_objects )
    {
        test_list = level._shrinkable_objects;
        range = range * 5;
    }
    else
        test_list = get_round_enemy_array();

    zombies = get_array_of_closest( view_pos, test_list, undefined, undefined, range * 1.1 );

    if ( !isdefined( zombies ) )
        return;

    range_squared = range * range;
    radius_squared = radius * radius;
    forward_view_angles = self getweaponforwarddir();
    end_pos = view_pos + vectorscale( forward_view_angles, range );
/#
    if ( 2 == getdvarint( #"_id_F7D13E2C" ) )
    {
        near_circle_pos = view_pos + vectorscale( forward_view_angles, 2 );
        circle( near_circle_pos, radius, ( 1, 0, 0 ), 0, 0, 100 );
        line( near_circle_pos, end_pos, ( 0, 0, 1 ), 1, 0, 100 );
        circle( end_pos, radius, ( 1, 0, 0 ), 0, 0, 100 );
    }
#/

    for ( i = 0; i < zombies.size; i++ )
    {
        if ( !isdefined( zombies[i] ) || isai( zombies[i] ) && !isalive( zombies[i] ) )
            continue;

        if ( isdefined( zombies[i].shrinked ) && zombies[i].shrinked )
        {
            zombies[i] shrink_ray_debug_print( "shrinked", ( 1, 0, 0 ) );
            continue;
        }

        if ( isdefined( zombies[i].no_shrink ) && zombies[i].no_shrink )
        {
            zombies[i] shrink_ray_debug_print( "no_shrink", ( 1, 0, 0 ) );
            continue;
        }

        test_origin = zombies[i] getcentroid();
        test_range_squared = distancesquared( view_pos, test_origin );

        if ( test_range_squared > range_squared )
        {
            zombies[i] shrink_ray_debug_print( "range", ( 1, 0, 0 ) );
            break;
        }

        normal = vectornormalize( test_origin - view_pos );
        dot = vectordot( forward_view_angles, normal );

        if ( 0 > dot )
        {
            zombies[i] shrink_ray_debug_print( "dot", ( 1, 0, 0 ) );
            continue;
        }

        radial_origin = pointonsegmentnearesttopoint( view_pos, end_pos, test_origin );

        if ( distancesquared( test_origin, radial_origin ) > radius_squared )
        {
            zombies[i] shrink_ray_debug_print( "cylinder", ( 1, 0, 0 ) );
            continue;
        }

        if ( 0 == zombies[i] damageconetrace( view_pos, self ) )
        {
            zombies[i] shrink_ray_debug_print( "cone", ( 1, 0, 0 ) );
            continue;
        }

        hitzombies[hitzombies.size] = zombies[i];
    }

    return hitzombies;
}

shrink_ray_debug_print( msg, color )
{
/#
    if ( !getdvarint( #"_id_F7D13E2C" ) )
        return;

    if ( !isdefined( color ) )
        color = ( 1, 1, 1 );

    print3d( self.origin + vectorscale( ( 0, 0, 1 ), 60.0 ), msg, color, 1, 1, 40 );
#/
}

zomibe_shrunk_board_tear_down()
{
    self endon( "death" );
    self endon( "unshrink" );

    while ( true )
        taunt_anim = random( level._zombie_board_taunt["zombie"] );
}