package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.display.Loader;
   import org.qrcode.QRCode;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.StyleSheet;
   import cn.pplive.player.utils.CommonUtils;
   
   public class CodeEditorUI extends MovieClip
   {
      
      private var $txt:TextField;
      
      private var bmpBox:MovieClip = null;
      
      private var lo:Loader = null;
      
      public function CodeEditorUI()
      {
         super();
         this.initTxt();
         this.$txt.width = 150;
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.parseCSS("a {text-decoration:underline;}");
         _loc1_.parseCSS("a:link,a:visited,a:active {text-decoration:underline;}");
         this.$txt.styleSheet = _loc1_;
         var _loc2_:* = "<textformat leading=\"5\">";
         _loc2_ = _loc2_ + CommonUtils.getHtml("立即用手机扫描左侧二维码在手机上继续观看视频","#999999",14);
         _loc2_ = _loc2_ + "<br><br>";
         _loc2_ = _loc2_ + (CommonUtils.getHtml("<a href=\"http://app.pptv.com/mobile/\" target=\"_blank\">>立即安装PPTV移动APP</a>","#3399ff") + "</textformat>");
         this.$txt.htmlText = _loc2_;
      }
      
      private function initTxt() : void
      {
         this.$txt = new TextField();
         this.$txt.autoSize = "left";
         this.$txt.wordWrap = true;
         this.$txt.multiline = true;
         addChild(this.$txt);
         this.$txt.x = 175;
         this.$txt.y = 5;
      }
      
      public function showCode(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(_loc2_)
         {
            removeChild(_loc2_);
            _loc2_ = null;
         }
         _loc2_ = new MovieClip();
         addChild(_loc2_);
         _loc2_.x = 10;
         _loc2_.y = 10;
         var _loc3_:QRCode = new QRCode();
         _loc3_.encode(param1);
         var _loc4_:Bitmap = new Bitmap(_loc3_.bitmapData);
         _loc2_.addChild(_loc4_);
         _loc4_.width = _loc4_.height = 140;
         var _loc5_:MovieClip = new PPTVIcon();
         var _loc6_:BitmapData = new BitmapData(_loc5_.width,_loc5_.height,false,4.294967295E9);
         _loc6_.draw(_loc5_,null,null,null,null,true);
         var _loc7_:Bitmap = new Bitmap(_loc6_,"auto",true);
         _loc7_.scaleX = _loc7_.scaleY = 0.7;
         _loc2_.addChild(_loc7_);
         _loc7_.x = _loc2_.width - _loc7_.width >> 1;
         _loc7_.y = _loc2_.height - _loc7_.height >> 1;
      }
   }
}
