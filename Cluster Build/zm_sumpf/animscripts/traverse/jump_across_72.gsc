// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

main()
{
    preparefortraverse();
    traversedata["traverseAnim"] = animarray( "jump_across_72", "move" );
    traversedata["traverseStance"] = "stand";
    dotraverse( traversedata );
}