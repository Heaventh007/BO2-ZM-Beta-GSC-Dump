// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include character\clientscripts\c_usa_pent_zombie_officeworker;

main()
{
    character\clientscripts\c_usa_pent_zombie_officeworker::main();
    self._aitype = "zm_pentagon_officeworker";
}

#using_animtree("zombie_pentagon");

precache( ai_index )
{
    character\clientscripts\c_usa_pent_zombie_officeworker::precache();
    usefootsteptable( ai_index, "default_ai" );
    precacheanimstatedef( ai_index, #animtree, "zm_pentagon_basic" );
    setdemolockonvalues( ai_index, 100, 60, -15, 60, 30, -5, 60 );
}
