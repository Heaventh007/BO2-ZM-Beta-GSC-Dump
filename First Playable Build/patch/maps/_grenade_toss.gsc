// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include maps\_anim;

#using_animtree("generic_human");

force_grenade_toss( pos, grenade_weapon, explode_time, anime, throw_tag )
{
    self endon( "death" );
    og_grenadeweapon = undefined;

    if ( isdefined( grenade_weapon ) )
    {
        og_grenadeweapon = self.grenadeweapon;
        self.grenadeweapon = grenade_weapon;
    }

    self.grenadeammo++;

    if ( !isdefined( explode_time ) )
        explode_time = 4;

    if ( !isdefined( throw_tag ) )
        throw_tag = "tag_inhand";

    angles = vectortoangles( pos - self.origin );
    self orientmode( "face angle", angles[1] );

    if ( distancesquared( self.origin, pos ) < 40000 )
    {
/#
        println( "^3Grenade position is too close!" );
#/
        return false;
    }

    self.force_grenade_throw_tag = throw_tag;
    self.force_grenade_pos = pos;
    self.force_grenade_explod_time = explode_time;

    if ( !isdefined( anime ) )
    {
        anime = "force_grenade_throw";

        if ( !isdefined( self.animname ) )
            self.animname = "force_grenader";

        if ( !isdefined( level.scr_anim[self.animname] ) || !isdefined( level.scr_anim[self.animname][anime] ) )
        {
            switch ( self.a.special )
            {
                case "cover_crouch":
                case "none":
                    if ( self.a.pose == "stand" )
                        throw_anim = %stand_grenade_throw;
                    else
                        throw_anim = %crouch_grenade_throw;

                    gun_hand = "left";
                    break;
                default:
                    throw_anim = %stand_grenade_throw;
                    gun_hand = "left";
                    break;
            }

            level.scr_anim[self.animname][anime] = throw_anim;
            maps\_anim::addnotetrack_attach( self.animname, "grenade_right", getweaponmodel( self.grenadeweapon ), self.force_grenade_throw_tag, anime );
            maps\_anim::addnotetrack_detach( self.animname, "fire", getweaponmodel( self.grenadeweapon ), self.force_grenade_throw_tag, anime );
        }
    }

    function = ::force_grenade_toss_internal;

    if ( !maps\_anim::notetrack_customfunction_exists( self.animname, "fire", function, anime ) )
        maps\_anim::addnotetrack_customfunction( self.animname, "fire", function, anime );

    self maps\_anim::anim_single( self, anime );

    if ( self.animname == "force_grenader" )
        self.animname = undefined;

    if ( isdefined( og_grenadeweapon ) )
        self.grenadeweapon = og_grenadeweapon;

    self notify( "forced_grenade_thrown" );
    return true;
}

force_grenade_toss_internal( guy )
{
    guy magicgrenade( guy gettagorigin( guy.force_grenade_throw_tag ), guy.force_grenade_pos, guy.force_grenade_explod_time );
    guy.grenadeammo--;
    guy.force_grenade_pos = undefined;
    guy.force_grenade_explod_time = undefined;
    guy.force_grenade_throw_tag = undefined;
}