// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\mp\_utility;
#include common_scripts\utility;

#using_animtree("critter");

main()
{
    level.scr_anim["pig"]["pig_hoist_squirm"][0] = %a_rebirth_pig_hoist_squirm;
    level.scr_anim["pig"]["pig_hoist_death"] = %a_rebirth_pig_hoist_death;
    level.scr_anim["pig"]["pig_hoist_deathpose"][0] = %a_rebirth_pig_hoist_deathpose;
    level thread lab_pig_init();
    level thread init_freezegun_anims();
}

lab_pig_init()
{
    level waittill( "start_of_round" );
    hoist_piggy = getent( "hoist_pig", "targetname" );
    hoist_piggy hide();
    hoist_piggy setcandamage( 1 );
    hoist_piggy.health = 99999;
    level setclientfield( "clientfield_pentagon_pig_play", 1 );
    hoist_piggy waittill( "damage", damage, attacker, direction_vec, point );
    level setclientfield( "clientfield_pentagon_pig_death", 1 );
}

#using_animtree("zombie_pentagon");

init_freezegun_anims()
{
    if ( !isdefined( level._zombie_freezegun_death ) )
        level._zombie_freezegun_death = [];

    level._zombie_freezegun_death["zombie"] = [];
    level._zombie_freezegun_death["zombie"][0] = %ai_zombie_freeze_death_a;
    level._zombie_freezegun_death["zombie"][1] = %ai_zombie_freeze_death_b;
    level._zombie_freezegun_death["zombie"][2] = %ai_zombie_freeze_death_c;
    level._zombie_freezegun_death["zombie"][3] = %ai_zombie_freeze_death_d;
    level._zombie_freezegun_death["zombie"][4] = %ai_zombie_freeze_death_e;

    if ( !isdefined( level._zombie_freezegun_death_missing_legs ) )
        level._zombie_freezegun_death_missing_legs = [];

    level._zombie_freezegun_death_missing_legs["zombie"] = [];
    level._zombie_freezegun_death_missing_legs["zombie"][0] = %ai_zombie_crawl_freeze_death_01;
    level._zombie_freezegun_death_missing_legs["zombie"][1] = %ai_zombie_crawl_freeze_death_02;
}