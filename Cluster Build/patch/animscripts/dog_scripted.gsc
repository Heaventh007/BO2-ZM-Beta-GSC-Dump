// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

#using_animtree("dog");

main()
{
    self endon( "death" );
    self notify( "killanimscript" );
    waittillframeend;
    self.codescripted["root"] = %root;
    self trackscriptstate( "Scripted Main", "code" );
    self endon( "end_sequence" );
    self startscriptedanim( self.codescripted["notifyName"], self.codescripted["origin"], self.codescripted["angles"], self.codescripted["anim"], self.codescripted["AnimMode"], self.codescripted["root"], self.codescripted["rate"], self.codescripted["goalTime"] );
    self.a.script = "scripted";
    self.codescripted = undefined;

    if ( isdefined( self.deathstring_passed ) )
        self.deathstring = self.deathstring_passed;

    self waittill( "killanimscript" );
}

end_script()
{

}

init( notifyname, origin, angles, theanim, animmode, root )
{
    self.codescripted["notifyName"] = notifyname;
    self.codescripted["origin"] = origin;
    self.codescripted["angles"] = angles;
    self.codescripted["anim"] = theanim;

    if ( isdefined( animmode ) )
        self.codescripted["animMode"] = animmode;
    else
        self.codescripted["animMode"] = "normal";

    if ( isdefined( root ) )
        self.codescripted["root"] = root;
    else
        self.codescripted["root"] = %root;
}