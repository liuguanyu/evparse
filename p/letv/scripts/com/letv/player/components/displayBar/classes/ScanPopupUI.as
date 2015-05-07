package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseCenterDisplayPopup;
   import com.alex.controls.Image;
   import flash.text.TextFormat;
   import flash.events.MouseEvent;
   
   public class ScanPopupUI extends BaseCenterDisplayPopup
   {
      
      private var imag:Image;
      
      public function ScanPopupUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = "Microsoft YaHei,微软雅黑,Arial,宋体";
         if(skin.hasOwnProperty("tipTxt"))
         {
            skin.closeBtn.visible = true;
            skin.tipTxt.defaultTextFormat = _loc1_;
            skin.tipTxt.text = "用微信/微博扫描二维码,在手机上继续观看该视频。";
         }
         if(skin.hasOwnProperty("title"))
         {
            skin.title.defaultTextFormat = _loc1_;
         }
      }
      
      override public function show(param1:Object = true) : void
      {
         var _loc2_:Object = sdk.getVideoSetting();
         var _loc3_:String = "http://m.letv.com/vplay_" + _loc2_.vid + ".html?htime=" + Math.round(sdk.getVideoTime()) + "&vid=" + _loc2_.vid + "&pid=" + _loc2_.pid + "&ref=qrcode&qrcode=letv&type=" + R.coops.typeFrom + "&title=" + encodeURIComponent(_loc2_.title);
         var _loc4_:String = "http://api.app.letv.com/getqr?w=160&txt=" + encodeURIComponent(_loc3_);
         if(skin.hasOwnProperty("title"))
         {
            skin.title.text = this.validString(_loc2_.title);
         }
         if(this.imag == null)
         {
            this.imag = new Image();
         }
         this.imag.source = _loc4_;
         this.imag.backgroundAlpha = 0;
         this.imag.width = 160;
         this.imag.height = 160;
         skin.scanBack.addChild(this.imag.skin);
         skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         super.show(param1);
      }
      
      override public function hide(param1:Object = true) : void
      {
         super.hide();
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function validString(param1:String) : String
      {
         if(param1.length > 11)
         {
            return param1.slice(0,11) + "...";
         }
         return param1;
      }
   }
}
