package pptv.skin.view.ui
{
   import mx.core.MovieClipLoaderAsset;
   import flash.utils.ByteArray;
   
   public class StartFreshUI_Loading extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class;
      
      public function StartFreshUI_Loading()
      {
         this.dataClass = StartFreshUI_Loading_dataClass;
         super();
         initialWidth = 10600 / 20;
         initialHeight = 6000 / 20;
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
