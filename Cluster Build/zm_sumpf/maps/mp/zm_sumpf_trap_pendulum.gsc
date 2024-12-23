// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_sumpf;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zm_sumpf_zipline;
#include maps\mp\zombies\_zm_laststand;

initpendulumtrap()
{
    penbuytrigger = getentarray( "pendulum_buy_trigger", "targetname" );

    for ( i = 0; i < penbuytrigger.size; i++ )
    {
        penbuytrigger[i].lever = getent( penbuytrigger[i].target, "targetname" );
        penbuytrigger[i].pendamagetrig = getent( penbuytrigger[i].lever.target, "targetname" );
        penbuytrigger[i].pen = getent( penbuytrigger[i].pendamagetrig.target, "targetname" );
        penbuytrigger[i].pulley = getent( penbuytrigger[i].pen.target, "targetname" );
    }

    penbuytrigger[0].pendamagetrig enablelinkto();
    penbuytrigger[0].pendamagetrig linkto( penbuytrigger[0].pen );
    level thread maps\mp\zm_sumpf::turnlightgreen( "pendulum_light" );
}

moveleverdown()
{
    soundent_left = getent( "switch_left", "targetname" );
    soundent_right = getent( "switch_right", "targetname" );
    self.lever rotatepitch( 180, 0.5 );
    soundent_left playsound( "switch" );
    soundent_right playsound( "switch" );
    self.lever waittill( "rotatedone" );
    self notify( "leverDown" );
}

moveleverup()
{
    soundent_left = getent( "switch_left", "targetname" );
    soundent_right = getent( "switch_right", "targetname" );
    self.lever rotatepitch( -180, 0.5 );
    soundent_left playsound( "switch" );
    soundent_right playsound( "switch" );
    self.lever waittill( "rotatedone" );
    self notify( "leverUp" );
}

hint_string( string )
{
    if ( string == &"ZOMBIE_BUTTON_BUY_TRAP" )
    {
        self.is_available = 1;
        self.zombie_cost = 750;
        self.in_use = 0;
        self sethintstring( string, self.zombie_cost );
    }
    else
        self sethintstring( string );

    self setcursorhint( "HINT_NOICON" );
}

penthink()
{
    self sethintstring( "" );
    pa_system = getent( "speaker_by_log", "targetname" );
    wait 0.5;
    self.is_available = 1;
    self.zombie_cost = 750;
    self.in_use = 0;
    self sethintstring( &"ZOMBIE_BUTTON_BUY_TRAP", self.zombie_cost );
    self setcursorhint( "HINT_NOICON" );
    triggers = getentarray( "pendulum_buy_trigger", "targetname" );

    while ( true )
    {
        array_thread( triggers, ::hint_string, &"ZOMBIE_BUTTON_BUY_TRAP" );
        self waittill( "trigger", who );
        self.used_by = who;

        if ( who in_revive_trigger() )
            continue;

        if ( is_player_valid( who ) )
        {
            if ( who.score >= self.zombie_cost )
            {
                if ( !self.in_use )
                {
                    self.in_use = 1;
                    level thread maps\mp\zm_sumpf::turnlightred( "pendulum_light" );
                    array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_ACTIVE" );
                    play_sound_at_pos( "purchase", who.origin );
                    who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "trap_log" );
                    who maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost );
                    self thread moveleverdown();
                    self waittill( "leverDown" );
                    motor_left = getent( "engine_loop_left", "targetname" );
                    motor_right = getent( "engine_loop_right", "targetname" );
                    playsoundatposition( "motor_start_left", motor_left.origin );
                    playsoundatposition( "motor_start_right", motor_right.origin );
                    wait 0.5;
                    self thread activatepen( motor_left, motor_right, who );
                    self waittill( "penDown" );
                    array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_COOLDOWN" );
                    self thread moveleverup();
                    self waittill( "leverUp" );
                    wait 45.0;
                    pa_system playsound( "warning" );
                    level thread maps\mp\zm_sumpf::turnlightgreen( "pendulum_light" );
                    self.in_use = 0;
                }
            }
        }
    }
}

activatepen( motor_left, motor_right, who )
{
    wheel_left = spawn( "script_origin", motor_left.origin );
    wheel_right = spawn( "script_origin", motor_right.origin );
    wait_network_frame();
    motor_left playloopsound( "motor_loop_left" );
    motor_right playloopsound( "motor_loop_right" );
    wait_network_frame();
    wheel_left playloopsound( "wheel_loop" );
    wheel_right playloopsound( "belt_loop" );
    self.pen notify( "stopmonitorsolid" );
    self.pen notsolid();
    self.pendamagetrig trigger_on();
    self.pendamagetrig thread pendamage( self, who );
    self.penactive = 1;

    if ( self.script_noteworthy == "1" )
    {
        self.pulley rotatepitch( -14040, 30, 6, 6 );
        self.pen rotatepitch( -14040, 30, 6, 6 );
    }
    else
    {
        self.pulley rotatepitch( 14040, 30, 6, 6 );
        self.pen rotatepitch( 14040, 30, 6, 6 );
    }

    level thread trap_sounds( motor_left, motor_right, wheel_left, wheel_right );
    self.pen thread blade_sounds();
    self.pen waittill( "rotatedone" );
    self.pendamagetrig trigger_off();
    self.penactive = 0;
    self.pen thread maps\mp\zm_sumpf_zipline::objectsolid();
    self notify( "penDown" );
    level notify( "stop_blade_sounds" );
    wait 3;
    wheel_left delete();
    wheel_right delete();
}

blade_sounds()
{
    self endon( "rotatedone" );
    blade_left = getent( "blade_left", "targetname" );
    blade_right = getent( "blade_right", "targetname" );
    lastangle = self.angles[0];

    for (;;)
    {
        wooshangle = 90;
        wait 0.01;
        angle = self.angles[0];
        speed = int( abs( angle - lastangle ) ) % 360;
        relpos = int( abs( angle ) ) % 360;
        lastrelpos = int( abs( lastangle ) ) % 360;

        if ( relpos == lastrelpos || speed < 7 )
        {
            lastangle = angle;
            continue;
        }

        if ( relpos > wooshangle && lastrelpos <= wooshangle )
        {
            blade_left playsound( "blade_right" );
            blade_right playsound( "blade_right" );
        }

        if ( ( relpos + 180 ) % 360 > wooshangle && ( lastrelpos + 180 ) % 360 <= wooshangle )
        {
            blade_left playsound( "blade_right" );
            blade_right playsound( "blade_right" );
        }

        lastangle = angle;
    }
}

trap_sounds( motor_left, motor_right, wheel_left, wheel_right )
{
    wait 13;
    motor_left stoploopsound( 2 );
    motor_left playsound( "motor_stop_left" );
    motor_right stoploopsound( 2 );
    motor_right playsound( "motor_stop_right" );
    wait 8;
    wheel_left stoploopsound( 8 );
    wheel_right stoploopsound( 8 );
}

pendamage( parent, who )
{
    thread customtimer();

    while ( true )
    {
        self waittill( "trigger", ent );

        if ( parent.penactive == 1 )
        {
            if ( isplayer( ent ) )
                ent thread playerpendamage();
            else
            {
                ent thread zombiependamage( parent );
                who.trapped_used["log_trap"] = level.round_number;
            }
        }
    }
}

customtimer()
{
    level.my_time = 0;

    while ( level.my_time <= 20 )
    {
        wait 0.1;
        level.my_time = level.my_time + 0.1;
    }
}

playerpendamage()
{
    self endon( "death" );
    self endon( "disconnect" );
    players = get_players();

    if ( players.size == 1 )
    {
        self dodamage( 80, self.origin + vectorscale( ( 0, 0, 1 ), 20.0 ) );
        self setstance( "crouch" );
    }
    else if ( !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        radiusdamage( self.origin, 10, self.health + 100, self.health + 100 );
}

zombiependamage( parent, time )
{
    self endon( "death" );

    if ( flag( "dog_round" ) )
        self.a.nodeath = 1;
    else
    {
        if ( !isdefined( level.numlaunched ) )
            level thread launch_monitor();

        if ( !isdefined( self.flung ) )
        {
            if ( parent.script_noteworthy == "1" )
            {
                x = randomintrange( 200, 250 );
                y = randomintrange( -35, 35 );
                z = randomintrange( 95, 120 );
            }
            else
            {
                x = randomintrange( -250, -200 );
                y = randomintrange( -35, 35 );
                z = randomintrange( 95, 120 );
            }

            if ( level.my_time < 6 )
                adjustment = level.my_time / 6;
            else if ( level.my_time > 24 )
                adjustment = ( 30 - level.my_time ) / 6;
            else
                adjustment = 1;

            x = x * adjustment;
            y = y * adjustment;
            z = z * adjustment;
            self thread do_launch( x, y, z );
        }
    }
}

launch_monitor()
{
    level.numlaunched = 0;

    while ( true )
    {
        wait_network_frame();
        wait_network_frame();
        level.numlaunched = 0;
    }
}

do_launch( x, y, z )
{
    self.flung = 1;

    while ( level.numlaunched > 4 )
        wait_network_frame();

    self thread play_imp_sound();
    self startragdoll();
    self launchragdoll( ( x, y, z ) );
    level.numlaunched++;
}

flogger_vocal_monitor()
{
    while ( true )
    {
        level.numfloggervox = 0;
        wait_network_frame();
        wait_network_frame();
    }
}

play_imp_sound()
{
    if ( !isdefined( level.numfloggervox ) )
        level thread flogger_vocal_monitor();

    self playsound( "zmb_death_gibs" );
    wait 0.75;
    self dodamage( self.health + 600, self.origin );
}
