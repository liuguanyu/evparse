package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.display.SimpleButton;
   import cn.pplive.player.utils.CommonUtils;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   
   public class TopUI extends MovieClip
   {
      
      private static const KW:String = "http://search.pptv.com/s_video/?kw=";
      
      public var titleTxt:TextField;
      
      public var search_mc:MovieClip;
      
      private var _title_txt:TextField;
      
      private var _search_mc:MovieClip;
      
      private var _input_txt:TextField;
      
      private var _search_btn:SimpleButton;
      
      public function TopUI()
      {
         super();
         this._title_txt = this.getChildByName("titleTxt") as TextField;
         this._title_txt.autoSize = "left";
         this._title_txt.mouseEnabled = false;
         this._title_txt.x = 10;
         this._title_txt.y = 10;
         this._title_txt.filters = [new GlowFilter(3355443,1,6,6,2,BitmapFilterQuality.HIGH)];
         this._search_mc = this.getChildByName("search_mc") as MovieClip;
         this._search_mc.y = 15;
         this._search_mc.visible = false;
         this._input_txt = this._search_mc.getChildByName("inputTxt") as TextField;
         this._search_btn = this._search_mc.getChildByName("search_btn") as SimpleButton;
         this._search_btn.addEventListener(MouseEvent.CLICK,this.searchBtnHander);
         this._input_txt.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
      }
      
      public function resize(param1:Number) : void
      {
         this._search_mc.x = param1 - this._search_mc.width - 10;
      }
      
      public function setTitle(param1:String, param2:Boolean, param3:String) : void
      {
         this._title_txt.htmlText = CommonUtils.getHtml(param1 == null?"":param1,"#f1f1f1",22);
         this._search_mc.visible = param2;
         this._input_txt.text = param3 == null?"":param3;
      }
      
      private function onKeyUpHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.dispatchSearch();
         }
      }
      
      private function searchBtnHander(param1:MouseEvent) : void
      {
         this.dispatchSearch();
      }
      
      private function dispatchSearch() : void
      {
         if(this._input_txt.text.length > 0)
         {
            this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SEARCH,{"value":KW + encodeURIComponent(this._input_txt.text)}));
         }
      }
   }
}
