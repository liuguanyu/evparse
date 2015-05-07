package com.letv.player.model
{
   public class EmbedConfig extends Object
   {
      
      private static const BIN_CONFIG:Class = EmbedConfig_BIN_CONFIG;
      
      private static const BIN_PCCS:Class = EmbedConfig_BIN_PCCS;
      
      private static var _PCCS:XML;
      
      private static var _CONFIG:XML;
      
      public function EmbedConfig()
      {
         super();
      }
      
      public static function get PCCS() : XML
      {
         if(_PCCS)
         {
            return _PCCS;
         }
         try
         {
            _PCCS = XML(new BIN_PCCS());
         }
         catch(e:Error)
         {
            _PCCS = null;
         }
         return _PCCS;
      }
      
      public static function get CONFIG() : XML
      {
         if(_CONFIG)
         {
            return _CONFIG;
         }
         try
         {
            _CONFIG = XML(new BIN_CONFIG());
         }
         catch(e:Error)
         {
            _CONFIG = null;
         }
         return _CONFIG;
      }
   }
}
