// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include character\clientscripts\c_zom_inmate1;
#include character\clientscripts\c_zom_inmate2;

main()
{
    switch ( self getcharacterindex() )
    {
        case 0:
            character\clientscripts\c_zom_inmate1::main();
            break;
        case 1:
            character\clientscripts\c_zom_inmate2::main();
            break;
    }

    self._aitype = "zm_tomb_basic_german";
}

#using_animtree("zm_tomb_basic");

precache( ai_index )
{
    character\clientscripts\c_zom_inmate1::precache();
    character\clientscripts\c_zom_inmate2::precache();
    usefootsteptable( ai_index, "default_ai" );
    precacheanimstatedef( ai_index, #animtree, "zm_tomb_basic" );
    setdemolockonvalues( ai_index, 100, 60, -15, 60, 30, -5, 60 );
}