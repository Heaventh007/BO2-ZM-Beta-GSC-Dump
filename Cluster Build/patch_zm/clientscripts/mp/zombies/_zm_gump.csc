// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
    if ( !is_true( level.disable_blackscreen_clientfield ) )
        registerclientfield( "toplayer", "blackscreen", 1, 1, "int", ::blackscreen_cb, 0 );

    machinelocal = machinelocalstorage();
    machinelocal.gumpname = [];
    machinelocal.gumpname[0] = "none";
    machinelocal.gumpname[1] = "none";
    machinelocal.gumpname[2] = "none";
    machinelocal.gumpname[3] = "none";
    machinelocal.gumpnamequeued = [];
    machinelocal.gumpnamequeued[0] = "none";
    machinelocal.gumpnamequeued[1] = "none";
    machinelocal.gumpnamequeued[2] = "none";
    machinelocal.gumpnamequeued[3] = "none";
    machinelocal.gump_loading = 0;
    machinelocal.gump_loading_slot = [];

    if ( !isdefined( level.uses_gumps ) )
        level.uses_gumps = 0;
}

get_gump_info( localclientnum, test_ent, gump_trigs )
{
    if ( !demoisanyfreemovecamera() )
    {
        player = playerbeingspectated( localclientnum );

        if ( "free" != player.team )
        {
            self.view = player getentitynumber();
            test_ent.origin = player.origin;
        }
        else
        {
            test_ent.origin = player geteyeapprox();
            self.view = level.gump_view_index_camera_intermission;
        }
    }
    else
    {
        test_ent.origin = getcamposbylocalclientnum( localclientnum );

        if ( demoismoviecamera() )
            self.view = level.gump_view_index_camera_movie;
        else if ( demoiseditcamera() )
            self.view = level.gump_view_index_camera_edit;
        else if ( demoisdollycamera() )
            self.view = level.gump_view_index_camera_dolly;
    }

    for ( trig_index = 0; trig_index < gump_trigs.size; trig_index++ )
    {
        if ( test_ent istouching( gump_trigs[trig_index] ) )
        {
            self.gump = gump_trigs[trig_index].script_string;
            break;
        }
    }
}

gump_demo_jump_listener()
{
    while ( true )
    {
        level waittill( "demo_jump" );
        self.view = -1;
    }
}

demo_monitor( gump_trigs )
{
    if ( !level.isdemoplaying )
        return;

    test_ent = spawn( 0, ( 0, 0, 0 ), "script_model" );
    test_ent setmodel( "tag_origin" );
    test_ent hide();
    spectatecolor = vectorscale( ( 1, 1, 1 ), 0.1 );
    localclientnum = 0;
    level.gump_view_index_camera_intermission = 100;
    level.gump_view_index_camera_movie = 101;
    level.gump_view_index_camera_edit = 102;
    level.gump_view_index_camera_dolly = 103;
    prev_gump_info = spawnstruct();
    prev_gump_info.gump = "";
    prev_gump_info.view = -1;
    prev_gump_info thread gump_demo_jump_listener();
    curr_gump_info = spawnstruct();
    curr_gump_info.gump = "";
    curr_gump_info.view = -1;

    while ( true )
    {
        curr_gump_info get_gump_info( localclientnum, test_ent, gump_trigs );

        if ( prev_gump_info.gump != curr_gump_info.gump )
        {
            thread load_gump_for_player( localclientnum, curr_gump_info.gump );

            if ( prev_gump_info.view != curr_gump_info.view || level.gump_view_index_camera_intermission == curr_gump_info.view )
                sethidegumpalpha( localclientnum, spectatecolor );
        }

        prev_gump_info.gump = curr_gump_info.gump;
        prev_gump_info.view = curr_gump_info.view;
        wait 0.01;
    }
}

blackscreen_cb( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( oldval != newval && newval )
        player_blackscreen( localclientnum, newval );
}

player_blackscreen( localclientnum, onoff )
{
/#
    println( "CSCGUMP: blackscreen for player " + localclientnum + "\\n" );
#/
    players = getlocalplayers();
    player = players[localclientnum];

    if ( onoff )
    {
        player notify( "gump_blackscreen_on" );
        player endon( "gump_blackscreen_off" );
        screechercolor = ( 0, 0, 0 );
        sethidegumpalpha( localclientnum, screechercolor );
    }
}

hostmigration_blackscreen()
{
    if ( is_true( level.uses_gumps ) )
    {
        hostmigrationcolor = ( 0, 0, 0 );
        players = getlocalplayers();

        for ( i = 0; i < players.size; i++ )
        {
            localclientnum = i;
/#
            println( "CSCGUMP: hostmigration blackscreen for player " + localclientnum + "\\n" );
#/
            player = players[localclientnum];

            if ( !player islocalplayer() )
                continue;

            player thread player_hostmigration_blackscreen( localclientnum );
            player notify( "gump_blackscreen_on" );
            sethidegumpalpha( localclientnum, hostmigrationcolor );
        }
    }
}

player_hostmigration_blackscreen( localclientnum )
{
    level endon( "gump_loaded" );
    self endon( "gump_blackscreen_off" );
    hostmigrationcolor = ( 0, 0, 0 );

    while ( true )
    {
        self notify( "gump_blackscreen_on" );
        sethidegumpalpha( localclientnum, hostmigrationcolor );
        wait 0.1;
    }
}

machinelocalstorage()
{
    return level;
}

watch_spectation( gump_trigs )
{
    level thread demo_monitor( gump_trigs );

    if ( level.isdemoplaying )
        return;

    players = getlocalplayers();

    for ( i = 0; i < players.size; i++ )
        players[i] thread watch_spectation_player( i, gump_trigs );
}

watch_spectation_player( lcn, gump_trigs )
{
    spectatecolor = vectorscale( ( 1, 1, 1 ), 0.1 );
    followed = playerbeingspectated( lcn );

    for (;;)
    {
        wait 0.01;
        new_followed = playerbeingspectated( lcn );

        if ( followed != new_followed )
        {
            followed = new_followed;
            sethidegumpalpha( lcn, spectatecolor );
            self find_new_gump( gump_trigs, lcn, followed );
        }
    }
}

find_new_gump( gump_trigs, lcn, player )
{
    for ( i = 0; i < gump_trigs.size; i++ )
    {
        if ( isdefined( gump_trigs[i].script_string ) && isdefined( player ) && player istouching( gump_trigs[i] ) )
        {
            load_gump_for_player( lcn, gump_trigs[i].script_string );
            return;
        }
    }
}

same_player( p1, p2 )
{
    if ( p1 getentitynumber() == p2 getentitynumber() )
        return true;

    return false;
}

gump_watch_trigger( localclientnum )
{
    if ( level.isdemoplaying )
        return;

    machinelocal = machinelocalstorage();
    players = getlocalplayers();
    gump = localclientnum != 0;

    while ( true )
    {
        self waittill( "trigger", who );

        if ( who isplayer() && isdefined( self.script_string ) )
        {
            if ( same_player( who, playerbeingspectated( 0 ) ) )
            {
                machinelocal.gumpnamequeued[0] = self.script_string;
                self thread trigger_thread( who, ::enter_gump_trigger0 );
            }
            else if ( players.size > 1 && same_player( who, playerbeingspectated( 1 ) ) )
            {
                machinelocal.gumpnamequeued[1] = self.script_string;
                self thread trigger_thread( who, ::enter_gump_trigger1 );
            }
            else if ( players.size > 2 && same_player( who, playerbeingspectated( 2 ) ) )
            {
                machinelocal.gumpnamequeued[2] = self.script_string;
                self thread trigger_thread( who, ::enter_gump_trigger2 );
            }
            else if ( players.size > 3 && same_player( who, playerbeingspectated( 3 ) ) )
            {
                machinelocal.gumpnamequeued[3] = self.script_string;
                self thread trigger_thread( who, ::enter_gump_trigger3 );
            }
        }
    }
}

enter_gump_trigger0( player )
{
    if ( player isplayer() )
        thread load_gump_for_player( 0, self.script_string );
}

enter_gump_trigger1( player )
{
    if ( player isplayer() )
        thread load_gump_for_player( 1, self.script_string );
}

enter_gump_trigger2( player )
{
    if ( player isplayer() )
        thread load_gump_for_player( 2, self.script_string );
}

enter_gump_trigger3( player )
{
    if ( player isplayer() )
        thread load_gump_for_player( 3, self.script_string );
}

load_gump_for_player( gump, name )
{
    machinelocal = machinelocalstorage();
    machinelocal.gumpnamequeued[gump] = name;

    if ( is_true( machinelocal.gump_loading_slot[gump] ) )
        return;

    while ( is_true( machinelocal.gump_loading ) )
        wait 0.25;

    machinelocal.gump_loading = 1;
    machinelocal.gump_loading_slot[gump] = 1;

    while ( machinelocal.gumpname[gump] != machinelocal.gumpnamequeued[gump] )
    {
/#
        println( "CSCGUMP: Loading " + machinelocal.gumpnamequeued[gump] + " in gump " + gump + " to replace " + machinelocal.gumpname[gump] + "\\n" );
#/
        machinelocal.gumpname[gump] = machinelocal.gumpnamequeued[gump];
        loadgump( machinelocal.gumpname[gump], gump );
        level waittill_notify_or_timeout( "gump_loaded", 10 );
    }

    machinelocal.gump_loading_slot[gump] = 0;
    machinelocal.gump_loading = 0;
}