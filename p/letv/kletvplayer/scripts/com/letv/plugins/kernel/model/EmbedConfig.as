package com.letv.plugins.kernel.model
{
   public final class EmbedConfig extends Object
   {
      
      private static const BIN_CONFIG:Class = EmbedConfig_BIN_CONFIG;
      
      private static var _config:XML;
      
      public function EmbedConfig()
      {
         super();
      }
      
      public static function get CONFIG() : XML
      {
         if(_config == null)
         {
            _config = XML(new BIN_CONFIG());
         }
         return _config;
      }
   }
}
