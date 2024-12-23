// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include codescripts\character;
#include xmodelalias\c_zom_prison_guard_head_als;
#include xmodelalias\c_zom_prison_guard_hat_als;

main()
{
    self setmodel( "c_zom_guard_body" );
    self.headmodel = codescripts\character::randomelement( xmodelalias\c_zom_prison_guard_head_als::main() );
    self attach( self.headmodel, "", 1 );
    self.hatmodel = codescripts\character::randomelement( xmodelalias\c_zom_prison_guard_hat_als::main() );
    self attach( self.hatmodel, "", 1 );
    self.voice = "american";
    self.skeleton = "base";
}

precache()
{
    precachemodel( "c_zom_guard_body" );
    codescripts\character::precachemodelarray( xmodelalias\c_zom_prison_guard_head_als::main() );
    codescripts\character::precachemodelarray( xmodelalias\c_zom_prison_guard_hat_als::main() );
}
