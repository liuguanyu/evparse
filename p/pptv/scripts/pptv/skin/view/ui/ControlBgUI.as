package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   
   public class ControlBgUI extends MovieClip
   {
      
      public var bg:MovieClip;
      
      private var $grid:MovieClip;
      
      private var $bg:MovieClip;
      
      public function ControlBgUI()
      {
         super();
         this.$bg = this.getChildByName("bg") as MovieClip;
      }
      
      public function resize(param1:Number, param2:Number = 40) : void
      {
         this.$bg.width = param1;
         this.$bg.height = param2;
      }
      
      override public function get height() : Number
      {
         return this.$bg.height;
      }
      
      override public function get width() : Number
      {
         return this.$bg.width;
      }
   }
}
