package com.letv.player.model.config
{
   import flash.display.Stage;
   import com.alex.utils.BrowserUtil;
   
   public class SkinDisplayBarConfig extends Object
   {
      
      public static const SCREENSHOT_SHARE_URL:String = "http://api.app.letv.com/api/share_video.php?from=www";
      
      public static const SHARE_WEIBO:String = "sina";
      
      public static const SHARE_QZONE:String = "qqzone";
      
      public static const SHARE_QWEIBO:String = "qq";
      
      public static const SHARE_RENREN:String = "renren";
      
      public static const URL_SINA:String = "http://v.t.sina.com.cn/share/share.php?appkey=3577304239&ralateUid=1732370473&sourceUrl=http://www.letv.com";
      
      public static const URL_QQMB:String = "http://share.v.t.qq.com/index.php?c=share&a=index&appkey=f0090e3870dd49f79e28f45f893835aa&site=http://www.letv.com";
      
      public static const URL_QZONE:String = "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey";
      
      public static const URL_RENREN:String = "http://share.renren.com/share/buttonshare.do";
      
      private var _shareVisible:Boolean;
      
      private var _cameraVisible:Boolean;
      
      private var _listVisible:Boolean = true;
      
      private var _moreVisible:Boolean = true;
      
      private var _barrageVisible:Boolean = false;
      
      private var _barrageemList:String;
      
      private var _dockVisible:Boolean = true;
      
      public function SkinDisplayBarConfig(param1:Object, param2:XML)
      {
         var xml:XML = null;
         var flashvars:Object = param1;
         var pccs:XML = param2;
         super();
         try
         {
            xml = XML(pccs.skin[0].displayBar[0]);
         }
         catch(e:Error)
         {
         }
         try
         {
            this._shareVisible = String(xml.dock[0].share[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _shareVisible = true;
         }
         try
         {
            this._cameraVisible = String(xml.dock[0].camera[0]) == "1"?true:false;
         }
         catch(e:Error)
         {
            _cameraVisible = false;
         }
         try
         {
            this._listVisible = String(xml.dock[0].list[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _listVisible = true;
         }
         try
         {
            this._moreVisible = String(xml.dock[0].more[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _moreVisible = true;
         }
         try
         {
            this._barrageVisible = String(xml.dock[0].barrage[0]) == "1"?true:false;
         }
         catch(e:Error)
         {
            _barrageVisible = false;
         }
         try
         {
            if(xml.hasOwnProperty("barrageem"))
            {
               this._barrageemList = xml.barrageem[0];
            }
         }
         catch(e:Error)
         {
            _barrageemList = null;
         }
         try
         {
            this._dockVisible = String(xml.dock[0].showdock[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _dockVisible = false;
         }
         try
         {
            if((flashvars.hasOwnProperty("share")) && !(flashvars["share"] == ""))
            {
               this._shareVisible = String(flashvars["share"]) == "0"?false:true;
            }
            if((flashvars.hasOwnProperty("camera")) && !(flashvars["camera"] == ""))
            {
               this._cameraVisible = String(flashvars["camera"]) == "1"?true:false;
            }
            if((flashvars.hasOwnProperty("list")) && !(flashvars["list"] == ""))
            {
               this._listVisible = String(flashvars["list"]) == "0"?false:true;
            }
            if((flashvars.hasOwnProperty("more")) && !(flashvars["more"] == ""))
            {
               this._moreVisible = String(flashvars["more"]) == "0"?false:true;
            }
            if((flashvars.hasOwnProperty("barrage")) && !(flashvars["barrage"] == ""))
            {
               this._barrageVisible = String(flashvars["barrage"]) == "1"?true:false;
            }
            if((flashvars.hasOwnProperty("showdock")) && !(flashvars["showdock"] == ""))
            {
               this._dockVisible = String(flashvars["showdock"]) == "0"?false:true;
            }
            if((flashvars.hasOwnProperty("simple")) && !(flashvars["simple"] == ""))
            {
               this._shareVisible = false;
               this._cameraVisible = false;
               this._listVisible = false;
               this._moreVisible = false;
               this._barrageVisible = false;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function sendSharePic(param1:String, param2:String, param3:String, param4:String = null, param5:Stage = null) : void
      {
         var _loc6_:String = SCREENSHOT_SHARE_URL;
         _loc6_ = _loc6_ + ("&to=" + param1);
         _loc6_ = _loc6_ + ("&url=" + encodeURIComponent(param2));
         _loc6_ = _loc6_ + ("&title=" + encodeURIComponent(param3));
         if(param4 != null)
         {
            _loc6_ = _loc6_ + ("&picurl=" + encodeURIComponent(param4));
         }
         BrowserUtil.openBlankWindow(_loc6_,param5);
      }
      
      public function get shareVisible() : Boolean
      {
         return this._shareVisible;
      }
      
      public function get cameraVisible() : Boolean
      {
         return this._cameraVisible;
      }
      
      public function get listVisible() : Boolean
      {
         return this._listVisible;
      }
      
      public function get moreVisible() : Boolean
      {
         return this._moreVisible;
      }
      
      public function get barrageVisible() : Boolean
      {
         return this._barrageVisible;
      }
      
      public function get dockVisible() : Boolean
      {
         return this._dockVisible;
      }
      
      public function get barrageemList() : String
      {
         return this._barrageemList;
      }
   }
}
