// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

shouldsaveonstartup()
{
    gt = getdvar( #"g_gametype" );

    switch ( gt )
    {
        case "vs":
            return false;
        default:
            break;
    }

    return true;
}
