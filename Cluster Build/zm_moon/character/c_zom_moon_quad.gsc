// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

main()
{
    self setmodel( "c_zom_quad_body_bloat" );
    self.headmodel = "c_zom_quad_head_bloat";
    self attach( self.headmodel, "", 1 );
    self.voice = "american";
    self.skeleton = "base";
}

precache()
{
    precachemodel( "c_zom_quad_body_bloat" );
    precachemodel( "c_zom_quad_head_bloat" );
}
