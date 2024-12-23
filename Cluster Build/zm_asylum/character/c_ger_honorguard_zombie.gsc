// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include codescripts\character;
#include xmodelalias\c_ger_honorguard_zomb_headalias;

main()
{
    self setmodel( "c_ger_honorguard_zombie_body1" );
    self.headmodel = codescripts\character::randomelement( xmodelalias\c_ger_honorguard_zomb_headalias::main() );
    self attach( self.headmodel, "", 1 );
    self.voice = "american";
    self.skeleton = "base";
    self.torsodmg1 = "char_ger_honorgd_body1_g_upclean";
    self.torsodmg2 = "char_ger_honorgd_body1_g_rarmoff_1";
    self.torsodmg3 = "char_ger_honorgd_body1_g_larmoff_1";
    self.torsodmg4 = "char_ger_honorgd_body1_g_torso_1";
    self.torsodmg5 = "char_ger_honorgd_body1_g_behead";
    self.legdmg1 = "char_ger_honorgd_body1_g_lowclean";
    self.legdmg2 = "char_ger_honorgd_body1_g_rlegoff_1";
    self.legdmg3 = "char_ger_honorgd_body1_g_llegoff_1";
    self.legdmg4 = "char_ger_honorgd_body1_g_legsoff_1";
    self.gibspawn1 = "char_ger_honorgd_body1_g_rarmspawn";
    self.gibspawntag1 = "J_Elbow_RI";
    self.gibspawn2 = "char_ger_honorgd_body1_g_larmspawn";
    self.gibspawntag2 = "J_Elbow_LE";
    self.gibspawn3 = "char_ger_honorgd_body1_g_rlegspawn";
    self.gibspawntag3 = "J_Knee_RI";
    self.gibspawn4 = "char_ger_honorgd_body1_g_llegspawn";
    self.gibspawntag4 = "J_Knee_LE";
}

precache()
{
    precachemodel( "c_ger_honorguard_zombie_body1" );
    codescripts\character::precachemodelarray( xmodelalias\c_ger_honorguard_zomb_headalias::main() );
    precachemodel( "char_ger_honorgd_body1_g_upclean" );
    precachemodel( "char_ger_honorgd_body1_g_rarmoff_1" );
    precachemodel( "char_ger_honorgd_body1_g_larmoff_1" );
    precachemodel( "char_ger_honorgd_body1_g_torso_1" );
    precachemodel( "char_ger_honorgd_body1_g_behead" );
    precachemodel( "char_ger_honorgd_body1_g_lowclean" );
    precachemodel( "char_ger_honorgd_body1_g_rlegoff_1" );
    precachemodel( "char_ger_honorgd_body1_g_llegoff_1" );
    precachemodel( "char_ger_honorgd_body1_g_legsoff_1" );
    precachemodel( "char_ger_honorgd_body1_g_rarmspawn" );
    precachemodel( "char_ger_honorgd_body1_g_larmspawn" );
    precachemodel( "char_ger_honorgd_body1_g_rlegspawn" );
    precachemodel( "char_ger_honorgd_body1_g_llegspawn" );
}
