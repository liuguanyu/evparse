package com.letv.player.components.displayBar
{
   import com.letv.player.components.BaseCenterDisplayPopup;
   import flash.text.TextFormat;
   import com.alex.controls.Image;
   import flash.events.MouseEvent;
   
   public class FirstlookUI extends BaseCenterDisplayPopup
   {
      
      private var imag:Image;
      
      public function FirstlookUI(param1:Object)
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
            skin.tipTxt.defaultTextFormat = _loc1_;
         }
         if(skin.hasOwnProperty("title"))
         {
            skin.title.defaultTextFormat = _loc1_;
         }
      }
      
      override public function hide(param1:Object = true) : void
      {
         super.hide();
      }
      
      public function showFirstlook(param1:int, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc3_:Object = sdk.getVideoSetting();
         if(skin.hasOwnProperty("tipTxt"))
         {
            if(param1 == 1)
            {
               skin.closeBtn.visible = false;
               _loc4_ = "http://m.letv.com/qxk.html?htime=" + Math.round(sdk.getVideoTime()) + "&vid=" + _loc3_.vid + "&pid=" + _loc3_.pid + "&qrcode=letv&ref=" + param2 + "&type=" + R.coops.typeFrom;
               skin.tipTxt.text = "试看已结束，观看完整视频请用乐视手机客户端扫一扫。微信扫描二维码，可下载乐视手机客户端。";
            }
            else if(param1 == 2)
            {
               skin.closeBtn.visible = true;
               _loc4_ = "http://m.letv.com/qxk.html?htime=" + Math.round(sdk.getVideoTime()) + "&vid=" + _loc3_.vid + "&pid=" + _loc3_.pid + "&qrcode=letv&ref=" + param2 + "&type=" + R.coops.typeFrom;
               skin.tipTxt.text = "微信扫一扫下载乐视手机客户端。乐视APP扫一扫，完整视频马上看。";
            }
            
         }
         var _loc5_:String = "http://api.app.letv.com/getqr?w=160&txt=" + encodeURIComponent(_loc4_);
         if(skin.hasOwnProperty("title"))
         {
            skin.title.text = this.validString(_loc3_.title);
         }
         if(this.imag == null)
         {
            this.imag = new Image();
         }
         this.imag.source = _loc5_;
         this.imag.backgroundAlpha = 0;
         this.imag.width = 160;
         this.imag.height = 160;
         skin.scanBack.addChild(this.imag.skin);
         skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         super.show();
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
