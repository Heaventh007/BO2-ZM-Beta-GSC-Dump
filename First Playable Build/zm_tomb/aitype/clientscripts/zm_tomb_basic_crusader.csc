// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include character\clientscripts\c_zom_guard;

main()
{
    character\clientscripts\c_zom_guard::main();
    self._aitype = "zm_tomb_basic_crusader";
}

#using_animtree("zm_tomb_basic");

precache( ai_index )
{
    character\clientscripts\c_zom_guard::precache();
    usefootsteptable( ai_index, "default_ai" );
    precacheanimstatedef( ai_index, #animtree, "zm_tomb_basic" );
    setdemolockonvalues( ai_index, 100, 60, -15, 60, 30, -5, 60 );
}