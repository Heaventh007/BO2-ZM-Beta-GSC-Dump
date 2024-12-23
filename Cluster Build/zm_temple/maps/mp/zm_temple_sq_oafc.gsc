// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_temple_sq_brock;
#include maps\mp\zm_temple_sq_skits;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_temple_sq;

init()
{
    precachemodel( "p_ztem_glyphs_00" );
    declare_sidequest_stage( "sq", "OaFC", ::init_stage, ::stage_logic, ::exit_stage );
    set_stage_time_limit( "sq", "OaFC", 300 );
    declare_stage_asset_from_struct( "sq", "OaFC", "sq_oafc_switch", ::oafc_switch );
    declare_stage_asset_from_struct( "sq", "OaFC", "sq_oafc_tileset1", ::tileset1, maps\mp\zombies\_zm_sidequests::radius_trigger_thread );
    declare_stage_asset_from_struct( "sq", "OaFC", "sq_oafc_tileset2", ::tileset2, maps\mp\zombies\_zm_sidequests::radius_trigger_thread );
    flag_init( "oafc_switch_pressed" );
    flag_init( "oafc_plot_vo_done" );
}

stage_logic()
{
/#
    flag_wait( "oafc_switch_pressed" );

    if ( get_players().size == 1 )
    {
        wait 20;
        level notify( "raise_crystal_1", 1 );
        level waittill( "raised_crystal_1" );
        wait 5.0;
        stage_completed( "sq", "OaFC" );
        return;
    }
#/
}

oafc_switch()
{
    level endon( "sq_OaFC_over" );
    level thread knocking_audio();
    self.on_pos = self.origin;
    self.off_pos = self.on_pos - anglestoup( self.angles ) * 5.5;
    self waittill( "triggered", who );
    entity_num = who getentitynumber();

    if ( isdefined( who.zm_random_char ) )
        entity_num = who.zm_random_char;

    level._player_who_pressed_the_switch = entity_num;
    self.trigger trigger_off();
    self playsound( "evt_sq_gen_button" );
    self moveto( self.off_pos, 0.25 );
    self waittill( "movedone" );
    flag_set( "oafc_switch_pressed" );
    level thread oafc_story_vox();
}

knocking_audio()
{
    level endon( "sq_OaFC_over" );
    struct = getstruct( "sq_location_oafc", "targetname" );

    if ( !isdefined( struct ) )
        return;

    while ( !flag( "oafc_switch_pressed" ) )
    {
        playsoundatposition( "evt_sq_oafc_knock", struct.origin );
        wait( randomfloatrange( 1.5, 4 ) );
    }
}

tileset1()
{
    self.set = 1;
    self.original_origin = self.origin;
}

tileset2()
{
    self.set = 2;
    self.original_origin = self.origin;
}

tile_cheat()
{
/#
    level endon( "reset_tiles" );
    level endon( "sq_OaFC_over" );

    while ( isdefined( self.matched ) && !self.matched )
    {
        print3d( self.origin, self.tile, vectorscale( ( 0, 1, 0 ), 255.0 ) );
        wait 0.1;
    }
#/
}

tile_debug()
{
    level endon( "sq_OaFC_over" );

    if ( !isdefined( level._debug_tiles ) )
    {
        level._debug_tiles = 1;
        level.selected_tile1 = newdebughudelem();
        level.selected_tile1.location = 0;
        level.selected_tile1.alignx = "left";
        level.selected_tile1.aligny = "middle";
        level.selected_tile1.foreground = 1;
        level.selected_tile1.fontscale = 1.3;
        level.selected_tile1.sort = 20;
        level.selected_tile1.x = 10;
        level.selected_tile1.y = 240;
        level.selected_tile1.og_scale = 1;
        level.selected_tile1.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        level.selected_tile1.alpha = 1;
        level.selected_tile1_text = newdebughudelem();
        level.selected_tile1_text.location = 0;
        level.selected_tile1_text.alignx = "right";
        level.selected_tile1_text.aligny = "middle";
        level.selected_tile1_text.foreground = 1;
        level.selected_tile1_text.fontscale = 1.3;
        level.selected_tile1_text.sort = 20;
        level.selected_tile1_text.x = 0;
        level.selected_tile1_text.y = 240;
        level.selected_tile1_text.og_scale = 1;
        level.selected_tile1_text.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        level.selected_tile1_text.alpha = 1;
        level.selected_tile1_text settext( "Tile1: " );
        level.selected_tile2 = newdebughudelem();
        level.selected_tile2.location = 0;
        level.selected_tile2.alignx = "left";
        level.selected_tile2.aligny = "middle";
        level.selected_tile2.foreground = 1;
        level.selected_tile2.fontscale = 1.3;
        level.selected_tile2.sort = 20;
        level.selected_tile2.x = 10;
        level.selected_tile2.y = 270;
        level.selected_tile2.og_scale = 1;
        level.selected_tile2.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        level.selected_tile2.alpha = 1;
        level.selected_tile2_text = newdebughudelem();
        level.selected_tile2_text.location = 0;
        level.selected_tile2_text.alignx = "right";
        level.selected_tile2_text.aligny = "middle";
        level.selected_tile2_text.foreground = 1;
        level.selected_tile2_text.fontscale = 1.3;
        level.selected_tile2_text.sort = 20;
        level.selected_tile2_text.x = 0;
        level.selected_tile2_text.y = 270;
        level.selected_tile2_text.og_scale = 1;
        level.selected_tile2_text.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        level.selected_tile2_text.alpha = 1;
        level.selected_tile2_text settext( "Tile2: " );
        level.num_matched = newdebughudelem();
        level.num_matched.location = 0;
        level.num_matched.alignx = "left";
        level.num_matched.aligny = "middle";
        level.num_matched.foreground = 1;
        level.num_matched.fontscale = 1.3;
        level.num_matched.sort = 20;
        level.num_matched.x = 10;
        level.num_matched.y = 300;
        level.num_matched.og_scale = 1;
        level.num_matched.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        level.num_matched.alpha = 1;
        level.num_matched_text = newdebughudelem();
        level.num_matched_text.location = 0;
        level.num_matched_text.alignx = "right";
        level.num_matched_text.aligny = "middle";
        level.num_matched_text.foreground = 1;
        level.num_matched_text.fontscale = 1.3;
        level.num_matched_text.sort = 20;
        level.num_matched_text.x = 0;
        level.num_matched_text.y = 300;
        level.num_matched_text.og_scale = 1;
        level.num_matched_text.color = vectorscale( ( 1, 1, 1 ), 255.0 );
        level.num_matched_text.alpha = 1;
        level.num_matched_text settext( "NMT: " );
    }

    while ( true )
    {
        if ( isdefined( level._picked_tile1 ) )
            level.selected_tile1 settext( level._picked_tile1.tile );
        else
            level.selected_tile1 settext( "None." );

        if ( isdefined( level._picked_tile2 ) )
            level.selected_tile2 settext( level._picked_tile2.tile );
        else
            level.selected_tile2 settext( "None." );

        if ( isdefined( level._num_matched_tiles ) )
            level.num_matched settext( level._num_matched_tiles );

        wait 0.05;
    }
}

tile_monitor()
{
    level endon( "sq_OaFC_over" );
    self endon( "tiles_picked" );
    level endon( "reset_tiles" );
    self.origin = self.original_origin;
}

init_stage()
{
    level thread tile_debug();
    flag_clear( "oafc_switch_pressed" );
    flag_clear( "oafc_plot_vo_done" );
    reset_tiles();
    maps\mp\zm_temple_sq_brock::delete_radio();
    level thread delayed_start_skit();
}

delayed_start_skit()
{
    wait 0.5;
    level thread maps\mp\zm_temple_sq_skits::start_skit( "tt1" );
}

tile_moves_up( delay )
{
    level endon( "sq_OaFC_over" );
    flag_wait( "oafc_switch_pressed" );

    for ( i = 0; i < delay; i++ )
        wait_network_frame();

    self moveto( self.original_origin, 0.25 );
}

set_tile_models( tiles, models )
{
    for ( i = 0; i < tiles.size; i++ )
    {
        tiles[i] setmodel( "p_ztem_glyphs_00" );
        tiles[i].tile = models[i];
        tiles[i].matched = 0;
        tiles[i].origin = tiles[i].original_origin - vectorscale( ( 0, 0, 1 ), 24.0 );
        tiles[i] thread tile_moves_up( i % 4 );
    }
}

player_in_trigger()
{
    players = get_players();

    for ( i = 0; i < players.size; i++ )
    {
        if ( players[i].sessionstate != "spectator" && self istouching( players[i] ) )
            return players[i];
    }

    return undefined;
}

oafc_trigger_thread( tiles, set )
{
    self endon( "death" );
    level endon( "reset_tiles" );
    self trigger_off();
    flag_wait( "oafc_switch_pressed" );
    self trigger_on();

    while ( true )
    {
        for ( i = 0; i < tiles.size; i++ )
        {
            tile = tiles[i];

            if ( isdefined( tile ) && !tile.matched )
            {
                self.origin = tiles[i].origin;
                touched_player = self player_in_trigger();

                if ( isdefined( touched_player ) )
                {
/#
                    if ( set == 1 )
                        println( "trig thread has new tile " + i );
#/
                    tile setmodel( tile.tile );
                    tile playsound( "evt_sq_oafc_glyph_activate" );
                    matched = 0;

                    if ( set == 1 )
                        level._picked_tile1 = tile;
                    else
                        level._picked_tile2 = tile;

                    while ( isdefined( touched_player ) && self istouching( touched_player ) && touched_player.sessionstate != "spectator" && !tile.matched )
                    {
                        self.touched_player = touched_player;

                        if ( set == 1 )
                        {
                            if ( isdefined( level._picked_tile1 ) && isdefined( level._picked_tile2 ) )
                            {
                                if ( level._picked_tile1.tile == level._picked_tile2.tile )
                                {
                                    level._picked_tile1 playsound( "evt_sq_oafc_glyph_correct" );
                                    level._picked_tile2 playsound( "evt_sq_oafc_glyph_correct" );
                                    matched = 1;
                                    level._picked_tile1.matched = 1;
                                    level._picked_tile2.matched = 1;
                                    level._picked_tile1 moveto( level._picked_tile1.origin - vectorscale( ( 0, 0, 1 ), 24.0 ), 0.5 );
                                    level._picked_tile2 moveto( level._picked_tile2.origin - vectorscale( ( 0, 0, 1 ), 24.0 ), 0.5 );
                                    level._picked_tile1 waittill( "movedone" );
                                    level._picked_tile1 = undefined;
                                    level._picked_tile2 = undefined;
                                    level._num_matched_tiles++;

                                    if ( level._num_matched_tiles < level._num_tiles_to_match )
                                    {
                                        rand = randomintrange( 0, 2 );

                                        if ( isdefined( touched_player ) && rand == 0 )
                                            touched_player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest1", undefined, randomintrange( 5, 8 ) );
                                        else if ( isdefined( level._oafc_trigger2.touched_player ) )
                                            level._oafc_trigger2.touched_player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest1", undefined, randomintrange( 5, 8 ) );
                                    }

                                    if ( level._num_matched_tiles == level._num_tiles_to_match )
                                    {
                                        struct = getstruct( "sq_location_oafc", "targetname" );

                                        if ( isdefined( struct ) )
                                        {
                                            playsoundatposition( "evt_sq_oafc_glyph_complete", struct.origin );
                                            playsoundatposition( "evt_sq_oafc_kachunk", struct.origin );
                                        }

                                        if ( isdefined( touched_player ) )
                                        {

                                        }

                                        level notify( "suspend_timer" );
                                        level notify( "raise_crystal_1", 1 );
                                        level waittill( "raised_crystal_1" );
                                        flag_wait( "oafc_plot_vo_done" );
                                        wait 5.0;
                                        stage_completed( "sq", "OaFC" );
                                        return;
                                    }

/#
                                    println( "breaking out of match" );
#/
                                    break;
                                }
                                else
                                {
                                    level._picked_tile1 playsound( "evt_sq_oafc_glyph_wrong" );
                                    level._picked_tile2 playsound( "evt_sq_oafc_glyph_wrong" );
                                    rand = randomintrange( 0, 2 );

                                    if ( isdefined( touched_player ) && rand == 0 )
                                        touched_player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest1", undefined, randomintrange( 2, 5 ) );
                                    else if ( isdefined( level._oafc_trigger2.touched_player ) )
                                        level._oafc_trigger2.touched_player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest1", undefined, randomintrange( 2, 5 ) );

                                    while ( isdefined( touched_player ) && self istouching( touched_player ) && isdefined( level._picked_tile2 ) )
                                        wait 0.05;

/#
                                    println( "Breaking out of unmatched." );
#/
                                    level thread reset_tiles();
                                    break;
                                }
                            }
                        }

                        wait 0.05;
                    }

                    tile playsound( "evt_sq_oafc_glyph_clear" );

                    if ( set == 1 )
                        level._picked_tile1 = undefined;
                    else
                        level._picked_tile2 = undefined;

                    tile setmodel( "p_ztem_glyphs_00" );
                }
            }
        }

        wait 0.05;
    }

/#
    if ( set == 1 )
        println( "Fallen out of trig thread." );
#/
}

reset_tiles()
{
    tile_models = array( "p_ztem_glyphs_01_unlit", "p_ztem_glyphs_02_unlit", "p_ztem_glyphs_03_unlit", "p_ztem_glyphs_04_unlit", "p_ztem_glyphs_05_unlit", "p_ztem_glyphs_06_unlit", "p_ztem_glyphs_07_unlit", "p_ztem_glyphs_08_unlit", "p_ztem_glyphs_09_unlit", "p_ztem_glyphs_10_unlit", "p_ztem_glyphs_11_unlit", "p_ztem_glyphs_12_unlit" );
    level notify( "reset_tiles" );

    if ( !isdefined( level._oafc_trigger1 ) )
    {
        level._oafc_trigger1 = spawn( "trigger_radius", ( 0, 0, 0 ), 0, 22, 72 );
        level._oafc_trigger2 = spawn( "trigger_radius", ( 0, 0, 0 ), 0, 22, 72 );
        level._oafc_trigger1 thread wait_for_first_stepon();
        level._oafc_trigger2 thread wait_for_first_stepon();
    }

    level._num_matched_tiles = 0;
    level._picked_tile1 = undefined;
    level._picked_tile2 = undefined;
    tile_models = array_randomize( tile_models );
    tileset1 = getentarray( "sq_oafc_tileset1", "targetname" );
    level._num_tiles_to_match = tileset1.size;
    set_tile_models( tileset1, tile_models );
    level._oafc_trigger1 thread oafc_trigger_thread( tileset1, 1 );
    tile_models = array_randomize( tile_models );
    tileset2 = getentarray( "sq_oafc_tileset2", "targetname" );
    set_tile_models( tileset2, tile_models );
    level._oafc_trigger2 thread oafc_trigger_thread( tileset2, 2 );
}

wait_for_first_stepon()
{
    self endon( "death" );
    level endon( "quest1_glyph_line_said" );

    while ( true )
    {
        self waittill( "trigger", who );

        if ( isdefined( who ) && isplayer( who ) )
        {
            who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest1", undefined, 1 );
            break;
        }
    }

    level notify( "quest1_glyph_line_said" );
}

exit_stage( success )
{
    if ( isdefined( level._debug_tiles ) )
    {
        level._debug_tiles = undefined;
        level.selected_tile1 destroy();
        level.selected_tile1 = undefined;
        level.selected_tile1_text destroy();
        level.selected_tile1_text = undefined;
        level.selected_tile2 destroy();
        level.selected_tile2 = undefined;
        level.selected_tile2_text destroy();
        level.selected_tile2_text = undefined;
        level.num_matched destroy();
        level.num_matched.location = undefined;
        level.num_matched_text destroy();
        level.num_matched_text = undefined;
    }

    if ( success )
        maps\mp\zm_temple_sq_brock::create_radio( 2, maps\mp\zm_temple_sq_brock::radio2_override );
    else
    {
        maps\mp\zm_temple_sq_brock::create_radio( 1 );
        level thread maps\mp\zm_temple_sq_skits::fail_skit( 1 );
    }

    level._oafc_trigger1 delete();
    level._oafc_trigger2 delete();

    if ( isdefined( level._oafc_sound_ent ) )
    {
        level._oafc_sound_ent delete();
        level._oafc_sound_ent = undefined;
    }

    level.skit_vox_override = 0;
}

oafc_story_vox()
{
    level endon( "sq_OaFC_over" );
    struct = getstruct( "sq_location_oafc", "targetname" );

    if ( !isdefined( struct ) )
        return;

    level._oafc_sound_ent = spawn( "script_origin", struct.origin );
    level._oafc_sound_ent playsound( "vox_egg_story_1_0", "sounddone" );
    level._oafc_sound_ent waittill( "sounddone" );
    players = get_players();

    if ( isdefined( players[level._player_who_pressed_the_switch] ) )
    {
        level.skit_vox_override = 1;
        players[level._player_who_pressed_the_switch] playsound( "vox_egg_story_1_1" + maps\mp\zm_temple_sq::get_variant_from_entity_num( level._player_who_pressed_the_switch ), "vox_egg_sounddone" );
        players[level._player_who_pressed_the_switch] waittill( "vox_egg_sounddone" );
        level.skit_vox_override = 0;
    }

    level._oafc_sound_ent playsound( "vox_egg_story_1_2", "sounddone" );
    level._oafc_sound_ent waittill( "sounddone" );

    while ( level._num_matched_tiles < 1 )
        wait 0.1;

    level._oafc_sound_ent playsound( "vox_egg_story_1_3", "sounddone" );
    level._oafc_sound_ent waittill( "sounddone" );

    while ( level._num_matched_tiles != level._num_tiles_to_match )
        wait 0.1;

    level._oafc_sound_ent playsound( "vox_egg_story_1_4", "sounddone" );
    level._oafc_sound_ent waittill( "sounddone" );
    players = get_players();

    if ( isdefined( players[level._player_who_pressed_the_switch] ) )
    {
        level.skit_vox_override = 1;
        players[level._player_who_pressed_the_switch] playsound( "vox_egg_story_1_5" + maps\mp\zm_temple_sq::get_variant_from_entity_num( level._player_who_pressed_the_switch ), "vox_egg_sounddone" );
        players[level._player_who_pressed_the_switch] waittill( "vox_egg_sounddone" );
        level.skit_vox_override = 0;
    }

    level._oafc_sound_ent playsound( "vox_egg_story_1_6", "sounddone" );
    level._oafc_sound_ent waittill( "sounddone" );
    level._oafc_sound_ent playsound( "vox_egg_story_1_7", "sounddone" );
    level._oafc_sound_ent waittill( "sounddone" );
    flag_set( "oafc_plot_vo_done" );
    level._oafc_sound_ent delete();
    level._oafc_sound_ent = undefined;
}
