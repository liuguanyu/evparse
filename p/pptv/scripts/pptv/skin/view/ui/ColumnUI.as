package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   
   public class ColumnUI extends MovieClip
   {
      
      public var data:Object;
      
      public function ColumnUI()
      {
         this.data = {};
         super();
      }
      
      public function setColumLevel(param1:int) : void
      {
         this.gotoAndStop(param1);
      }
   }
}
