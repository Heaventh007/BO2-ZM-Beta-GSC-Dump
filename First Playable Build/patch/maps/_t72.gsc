// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\_vehicle;

main()
{

}

set_vehicle_anims( positions )
{
    return positions;
}

setanims()
{
    positions = [];

    for ( i = 0; i < 11; i++ )
        positions[i] = spawnstruct();

    positions[0].getout_delete = 1;
    return positions;
}