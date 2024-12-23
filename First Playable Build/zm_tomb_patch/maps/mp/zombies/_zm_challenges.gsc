// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_score;

init()
{
    level._challenges = spawnstruct();
    stats_init();
    board_init();
    box_init();
    onplayerconnect_callback( ::onplayerconnect );
}

onplayerconnect()
{
    player_stats_init( self.characterindex );
}

stats_init()
{
    level._challenges.a_stats = [];
    add_stat( "zombie_kills", 50 );
    add_stat( "zone_captures", 3, ::init_zone_captures );

    foreach ( stat in level._challenges.a_stats )
    {
        if ( isdefined( stat.fp_init_stat ) )
            level thread [[ stat.fp_init_stat ]]();
    }
}

add_stat( str_name, n_goal, fp_init_stat )
{
    if ( !isdefined( n_goal ) )
        n_goal = 1;

    stat = spawnstruct();
    stat.str_name = str_name;
    stat.n_goal = n_goal;

    if ( isdefined( fp_init_stat ) )
        stat.fp_init_stat = fp_init_stat;

    level._challenges.a_stats[str_name] = stat;
}

player_stats_init( n_index )
{
    s_challenges = spawnstruct();
    s_challenges.a_stats = [];

    foreach ( s_challenge in level._challenges.a_stats )
    {
        s_stat = spawnstruct();
        s_stat.n_value = 0;
        s_stat.b_medal_awarded = 0;
        s_challenges.a_stats[s_challenge.str_name] = s_stat;
    }

    s_challenges.n_completed = 0;
    s_challenges.n_medals_owned = 0;
    self._challenges = s_challenges;
}

player_increment_stat( str_stat, n_increment )
{
    if ( !isdefined( n_increment ) )
        n_increment = 1;

    if ( isdefined( self._challenges.a_stats[str_stat] ) )
    {
        self._challenges.a_stats[str_stat].n_value = self._challenges.a_stats[str_stat].n_value + n_increment;
        self player_check_stat( str_stat );
    }
}

player_set_stat( str_stat, n_set )
{
    if ( isdefined( self._challenges.a_stats[str_stat] ) )
    {
        self._challenges.a_stats[str_stat].n_value = n_set;
        self player_check_stat( str_stat );
    }
}

player_check_stat( str_stat )
{
    stat = self._challenges.a_stats[str_stat];

    if ( stat.b_medal_awarded )
        return;

    if ( stat.n_value >= level._challenges.a_stats[str_stat].n_goal )
    {
/#
        iprintln( str_stat + " CHALLENGE COMPLETE" );
#/
        self._challenges.n_completed++;
        self._challenges.n_medals_owned++;
        stat.b_medal_awarded = 1;
        self playsound( "zmb_perks_packa_ready" );
    }
}

player_get_medals_awarded()
{
    n_medals = 0;

    foreach ( stat in self._challenges.a_stats )
    {
        if ( stat.b_medal_awarded )
            n_medals++;
    }

    return n_medals;
}

board_init()
{
    s_board = getstruct( "s_challenge_board", "targetname" );
    s_unitrigger_stub = spawnstruct();
    s_unitrigger_stub.origin = s_board.origin + ( 0, 0, 0 );
    s_unitrigger_stub.angles = s_board.angles;
    s_unitrigger_stub.radius = 64;
    s_unitrigger_stub.script_length = 64;
    s_unitrigger_stub.script_width = 64;
    s_unitrigger_stub.script_height = 64;
    s_unitrigger_stub.cursor_hint = "HINT_NOICON";
    s_unitrigger_stub.hint_string = &"ZM_TOMB_CHALLENGE_INCOMPLETE";
    s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    s_unitrigger_stub.require_look_at = 1;
    s_unitrigger_stub.prompt_and_visibility_func = ::board_prompt_and_visiblity;
    s_unitrigger_stub.s_board = s_board;
    unitrigger_force_per_player_triggers( s_unitrigger_stub, 1 );
    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( s_unitrigger_stub, ::board_think );
}

board_prompt_and_visiblity( player )
{
    if ( player._challenges.n_medals_owned <= 0 )
        self.stub.hint_string = &"ZM_TOMB_CHALLENGE_INCOMPLETE";
    else
        self.stub.hint_string = &"ZM_TOMB_CHALLENGE_CHECK_BOX";

    self sethintstring( self.stub.hint_string );
    return true;
}

board_think()
{
    self endon( "kill_trigger" );
}

box_init()
{
    s_box = getstruct( "s_challenge_box", "targetname" );
    s_unitrigger_stub = spawnstruct();
    s_unitrigger_stub.origin = s_box.origin + ( 0, 0, 0 );
    s_unitrigger_stub.angles = s_box.angles;
    s_unitrigger_stub.radius = 64;
    s_unitrigger_stub.script_length = 64;
    s_unitrigger_stub.script_width = 64;
    s_unitrigger_stub.script_height = 64;
    s_unitrigger_stub.cursor_hint = "HINT_NOICON";
    s_unitrigger_stub.hint_string = &"ZM_TOMB_CHALLENGE_INCOMPLETE";
    s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    s_unitrigger_stub.require_look_at = 1;
    s_unitrigger_stub.prompt_and_visibility_func = ::box_prompt_and_visiblity;
    s_unitrigger_stub.s_box = s_box;
    unitrigger_force_per_player_triggers( s_unitrigger_stub, 1 );
    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( s_unitrigger_stub, ::box_think );
}

box_prompt_and_visiblity( player )
{
    if ( player._challenges.n_medals_owned <= 0 )
        self.stub.hint_string = "";
    else
        self.stub.hint_string = &"ZM_TOMB_CHALLENGE_COLLECT_REWARD";

    self sethintstring( self.stub.hint_string );
    return true;
}

box_think()
{
    self endon( "kill_trigger" );

    while ( true )
    {
        self waittill( "trigger", player );

        if ( !is_player_valid( player ) )
            continue;

        if ( player._challenges.n_medals_owned <= 0 )
            continue;

        player._challenges.n_medals_owned--;
        self.stub.hint_string = "";
        self sethintstring( self.stub.hint_string );
        player maps\mp\zombies\_zm_score::add_to_player_score( 1000 );
    }
}

init_zombie_kills()
{

}

init_zone_captures()
{
    flag_wait( "capture_zones_init_done" );

    foreach ( s_zone in level.a_s_capture_zones )
        s_zone thread track_zone_capture();
}

track_zone_capture()
{
    was_player_controlled = 0;

    while ( true )
    {
        flag_wait( "zone_capture_in_progress" );
        flag_waitopen( "zone_capture_in_progress" );
        a_players = get_players();

        foreach ( player in a_players )
        {
            if ( level.total_zone_captures == level.a_s_capture_zones.size )
                player player_set_stat( "zone_captures", level.total_zone_captures );
        }
    }
}
