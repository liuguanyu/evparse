package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class LoadingUI extends MovieClip
   {
      
      public var bufferPrecent:TextField;
      
      private var _buffer_txt:TextField;
      
      public function LoadingUI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._buffer_txt = this["bufferPrecent"] as TextField;
         this.visible = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      public function showLoading(param1:Number) : void
      {
         if(param1 >= 100)
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
            this._buffer_txt.text = param1 + "%";
            this._buffer_txt.setTextFormat(this.txtFormat());
         }
      }
      
      private function txtFormat() : TextFormat
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = "Tahoma";
         _loc1_.bold = true;
         _loc1_.size = 16;
         return _loc1_;
      }
   }
}
