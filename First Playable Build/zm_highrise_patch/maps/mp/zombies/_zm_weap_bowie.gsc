// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weapons;

init()
{
    if ( isdefined( level.bowie_cost ) )
        cost = level.bowie_cost;
    else
        cost = 3000;

    maps\mp\zombies\_zm_melee_weapon::init( "bowie_knife_zm", "zombie_bowie_flourish", "knife_ballistic_bowie_zm", "knife_ballistic_bowie_upgraded_zm", cost, "bowie_upgrade", &"ZOMBIE_WEAPON_BOWIE_BUY", "bowie", undefined );
    maps\mp\zombies\_zm_weapons::add_retrievable_knife_init_name( "knife_ballistic_bowie" );
    maps\mp\zombies\_zm_weapons::add_retrievable_knife_init_name( "knife_ballistic_bowie_upgraded" );
}