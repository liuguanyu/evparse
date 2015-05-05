package cn.pplive.player.view.ui
{
   import flash.display.MovieClip;
   
   public class SmartClickUI extends MovieClip
   {
      
      private var _data:Object;
      
      public function SmartClickUI()
      {
         super();
         this.buttonMode = true;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function destroy() : void
      {
         this._data = null;
      }
   }
}
