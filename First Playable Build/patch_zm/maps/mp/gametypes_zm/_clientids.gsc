// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    level.clientid = 0;
    level thread onplayerconnect();
}

onplayerconnect()
{
    for (;;)
    {
        level waittill( "connecting", player );
        player.clientid = level.clientid;
        level.clientid++;
    }
}