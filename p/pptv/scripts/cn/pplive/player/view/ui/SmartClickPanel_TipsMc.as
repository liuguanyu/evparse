package cn.pplive.player.view.ui
{
   import mx.core.MovieClipLoaderAsset;
   import flash.utils.ByteArray;
   
   public class SmartClickPanel_TipsMc extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class;
      
      public function SmartClickPanel_TipsMc()
      {
         this.dataClass = SmartClickPanel_TipsMc_dataClass;
         super();
         initialWidth = 580 / 20;
         initialHeight = 1740 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}
