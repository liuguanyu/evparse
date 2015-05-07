package com.letv.player.model.stat
{
   import com.alex.logging.Log;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.URLRequestMethod;
   import flash.net.sendToURL;
   import flash.net.SharedObject;
   import com.letv.pluginsAPI.cookieApi.CookieAPI;
   import com.alex.utils.ID;
   import com.letv.pluginsAPI.stat.Stat;
   import com.alex.utils.BrowserUtil;
   import flash.system.Capabilities;
   import com.alex.utils.ObjectUtil;
   import flash.external.ExternalInterface;
   import com.letv.player.facade.MyResource;
   import com.letv.player.view.PlayerLayer;
   
   public class LetvStatistics extends Object
   {
      
      public static const STAT_CLK_SHARE:String = "share";
      
      public static const STAT_CLK_TESTSPEED:String = "speed";
      
      public static const STAT_CLK_GPU:String = "gpu";
      
      public static const STAT_CLK_LIKE:String = "scr_cmt";
      
      public static const STAT_CLK_HOT:String = "hot";
      
      public static const SCR_CMT_SEND:String = "scr_cmt_send";
      
      public static const SCR_CMT_MORE:String = "scr_cmt_more";
      
      public static const SHARE_SCR_CMT:String = "share_scr_cmt";
      
      public static const STAT_CLK_QRCODE:String = "scr_qrcode";
      
      public static const STAT_CLK_1080P:String = "scr_1080p";
      
      public static const STAT_CLK_2K:String = "scr_2k";
      
      public static const STAT_CLK_4K:String = "scr_4k";
      
      public static const BARRAGE:String = "barrage";
      
      public static const STAT_PAUSE_TIP:String = "a11";
      
      public static const STAT_CLK_DEFINITION_AD_SP:String = "scr_definition_ad_sp";
      
      public static const LOGINLIMIT_REGIST_TIP:String = "loginLimit_regist_tip";
      
      public static const LOGINLIMIT_LOGIN_TIP:String = "loginLimit_login_tip";
      
      public static const LOGINLIMIT_SHOW_PANEL:String = "loginLimit_show_panel";
      
      public static const LOGINLIMIT_REGIST_PANEL:String = "loginLimit_regist_panel";
      
      public static const LOGINLIMIT_LOGIN_PANEL:String = "loginLimit_login_panel";
      
      public static const DUBI_CLICK:String = "dubi_click";
      
      public static const DUBI_SHOW:String = "dubi_show";
      
      public static const SUPER_PHONE_CLICK:String = "super_phone_click";
      
      private static const UPLOAD_FEEDBACK_URL:String = "http://stat.letv.com/vplay/feedback.php";
      
      private static const UPLOAD_ERROR_URL:String = "http://stat.letv.com/flverr";
      
      public var params:LetvParams;
      
      private var R:MyResource;
      
      private var layer:PlayerLayer;
      
      private var storage_so:SharedObject;
      
      public function LetvStatistics(param1:MyResource)
      {
         this.params = new LetvParams();
         this.layer = PlayerLayer.getInstance();
         super();
         this.R = param1;
      }
      
      public function getXMLLog(param1:String, param2:String, param3:Object) : XML
      {
         var _loc6_:String = null;
         var _loc4_:XML = <root></root>;
         _loc4_.appendChild(XML("<errorCode>" + param2 + "</errorCode>"));
         _loc4_.appendChild(XML("<errorInfo>" + param1 + "</errorInfo>"));
         var _loc5_:* = "<details><![CDATA[";
         if(param3 != null)
         {
            for(_loc6_ in param3)
            {
               _loc5_ = _loc5_ + (_loc6_ + " : " + param3[_loc6_] + "\n");
            }
         }
         else
         {
            _loc5_ = _loc5_ + "undefined";
         }
         _loc5_ = _loc5_ + "]]></details>";
         _loc4_.appendChild(XML(_loc5_));
         _loc4_.appendChild(XML("<all><![CDATA[" + Log.getHtmlLog() + "]]></ad>"));
         return _loc4_;
      }
      
      public function uploadErrorLog(param1:Object) : void
      {
         var request:URLRequest = null;
         var vars:URLVariables = null;
         var item:String = null;
         var value:Object = param1;
         try
         {
            request = new URLRequest();
            request.method = URLRequestMethod.POST;
            vars = new URLVariables();
            for(item in value)
            {
               vars[item] = value[item];
            }
            request.data = vars;
            request.url = UPLOAD_ERROR_URL;
            sendToURL(request);
         }
         catch(e:Error)
         {
         }
      }
      
      public function uploadUserFeedback(param1:Object) : void
      {
         var request:URLRequest = null;
         var vars:URLVariables = null;
         var item:String = null;
         var value:Object = param1;
         try
         {
            request = new URLRequest();
            request.method = URLRequestMethod.POST;
            vars = new URLVariables();
            for(item in value)
            {
               vars[item] = value[item];
            }
            vars.log = Log.getHtmlLog();
            request.data = vars;
            request.url = UPLOAD_FEEDBACK_URL;
            sendToURL(request);
         }
         catch(e:Error)
         {
         }
      }
      
      public function get idinfo() : Object
      {
         return {
            "uuid":this.uuid,
            "lc":this.lc
         };
      }
      
      public function get lc() : String
      {
         var value:String = null;
         try
         {
            if(this.storage_so == null)
            {
               this.storage_so = SharedObject.getLocal(CookieAPI.COOKIE_STORAGE,"/");
            }
            if(this.storage_so.data.hasOwnProperty("lc"))
            {
               value = this.storage_so.data["lc"];
            }
            if(value == null || value == "")
            {
               value = ID.createGUID();
               this.storage_so.data["lc"] = value;
               this.storage_so.flush();
            }
         }
         catch(e:Error)
         {
         }
         return value;
      }
      
      public function get uuid() : String
      {
         if(this.params.uuid == null)
         {
            this.params.uuid = ID.createGUID();
         }
         if(this.params.gslbcount > 0)
         {
            return this.params.uuid + "_" + this.params.gslbcount;
         }
         return this.params.uuid;
      }
      
      public function sendStat(param1:Object = null) : void
      {
         var url:String = null;
         var pyvalue:Object = null;
         var value:Object = param1;
         url = Stat.URL_STAT_PLAY;
         try
         {
            url = url + ("?ver=" + Stat.VERSION);
            url = url + ("&ac=" + Stat.LOG_PLAY_INIT);
            url = url + ("&p1=" + this.R.flashvars.p1);
            url = url + ("&p2=" + this.R.flashvars.p2);
            url = url + ("&p3=" + this.R.flashvars.p3);
            url = url + ("&lc=" + this.lc);
            url = url + "&uid=-";
            url = url + ("&uuid=" + this.uuid);
            url = url + "&auid=-";
            url = url + "&cid=-";
            url = url + "&pid=-";
            url = url + ("&vid=" + this.R.flashvars.vid);
            url = url + "&vlen=-";
            url = url + ("&ch=" + this.R.coops.typeFrom);
            url = url + "&ty=0";
            url = url + "&vt=-";
            url = url + ("&url=" + encodeURIComponent(BrowserUtil.url));
            url = url + ("&ref=" + encodeURIComponent(BrowserUtil.referer));
            url = url + ("&pv=" + Capabilities.version);
            url = url + "&st=-";
            url = url + "&ilu=-";
            url = url + "&pcode=-";
            url = url + "&pt=0";
            if(value != null)
            {
               pyvalue = value.hasOwnProperty("py")?value["py"]:{};
               if(this.R.flashvars.up == "1")
               {
                  pyvalue["play"] = "1";
               }
               url = url + ("&py=" + encodeURIComponent(ObjectUtil.objectParseToString(pyvalue)));
               if(value.hasOwnProperty("error"))
               {
                  url = url + ("&err=" + value["error"]);
               }
               else
               {
                  url = url + "&err=0";
               }
               if(value.hasOwnProperty("utime"))
               {
                  url = url + ("&ut=" + value["utime"]);
               }
               else
               {
                  url = url + "&ut=0";
               }
               if(value.hasOwnProperty("retry"))
               {
                  url = url + ("&ry=" + value["retry"]);
               }
            }
            else
            {
               url = url + "&py=-";
               url = url + "&err=0";
               url = url + "&ut=-";
            }
            url = url + ("&r=" + Math.random());
            this.R.log.append("[Stat] " + url);
            sendToURL(new URLRequest(url));
         }
         catch(e:Error)
         {
            R.log.append("[Stat] " + url,"error");
         }
      }
      
      public function sendPgvStat(param1:Object = null) : void
      {
         var ref:String = null;
         var ch:String = null;
         var islogin:int = 0;
         var url:String = null;
         var value:Object = param1;
         try
         {
            ref = (value) && (value["ref"])?value["ref"]:encodeURIComponent(BrowserUtil.referer);
            islogin = (value) && value["islogin"] == "1"?1:0;
         }
         catch(e:*)
         {
         }
         url = Stat.URL_STAT_PGV;
         try
         {
            url = url + ("?ver=" + Stat.VERSION);
            url = url + ("&p1=" + this.R.flashvars.p1);
            url = url + ("&p2=" + this.R.flashvars.p2);
            url = url + ("&p3=" + this.R.flashvars.p3);
            url = url + ("&cid=" + this.R.flashvars.cid);
            url = url + ("&pid=" + this.R.flashvars.pid);
            url = url + ("&vid=" + this.R.flashvars.vid);
            url = url + ("&uuid=" + this.uuid);
            url = url + ("&lc=" + this.lc);
            url = url + ("&ref=" + ref);
            url = url + "&ct=1";
            url = url + ("&rcid=" + this.R.flashvars.cid);
            url = url + "&kw=-";
            url = url + ("&cur_url=" + encodeURIComponent(BrowserUtil.url));
            url = url + ("&ch=" + this.R.coops.typeFrom);
            url = url + ("&ilu=" + islogin);
            url = url + ("&weid=" + this.webeventid);
            url = url + ("&r=" + Math.random());
            this.R.log.append("[Stat] " + url);
            sendToURL(new URLRequest(url));
         }
         catch(e:Error)
         {
            R.log.append("[Stat] " + url,"error");
         }
      }
      
      public function get webeventid() : String
      {
         var id:String = null;
         try
         {
            id = ExternalInterface.call("eval","Stats.WEID");
         }
         catch(e:Error)
         {
         }
         if(id == null)
         {
            return "-";
         }
         return id;
      }
      
      public function sendDocDebug(param1:String, param2:Object = null) : void
      {
         var type:String = param1;
         var value:Object = param2;
         try
         {
            if(this.R.assists.docStat)
            {
               if(value == null)
               {
                  value = {};
               }
               value["type"] = type;
               this.layer.sdk.sendStatistics({
                  "mode":Stat.LOG_ACTION,
                  "type":Stat.LOG_ACTION_CLK,
                  "info":{"py":value}
               });
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function sendTrylookStat() : void
      {
         try
         {
            sendToURL(new URLRequest("http://dc.letv.com/s/?k=sumtmp;paybg"));
         }
         catch(e:Error)
         {
         }
      }
   }
}
