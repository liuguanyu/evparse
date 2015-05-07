package com.letv.player.model.config
{
   import com.alex.utils.BrowserUtil;
   import com.alex.utils.RichStringUtil;
   import com.letv.player.model.EmbedConfig;
   
   public class InfoPluginConfig extends Object
   {
      
      public var DATE:String = "0000-00-00-00";
      
      public var VERSION:String = "0.0.0";
      
      public var UPDATES:XMLList;
      
      public var pluginCompress:String = "";
      
      public var pluginVersions:String = "";
      
      private var _pccs:XML;
      
      private var _skinUrl:String;
      
      private var _sdkUrl:String;
      
      private var _recommendUrl:String;
      
      private var _footballUrl:String;
      
      private var _teleTextUrl:String;
      
      public function InfoPluginConfig()
      {
         var EMBED_CONFIG:XML = null;
         super();
         try
         {
            EMBED_CONFIG = EmbedConfig.CONFIG;
            this.VERSION = EMBED_CONFIG.version;
            this.DATE = EMBED_CONFIG.date;
            this.UPDATES = EMBED_CONFIG.update.item;
         }
         catch(e:Error)
         {
            VERSION = "Unknow";
            UPDATES = null;
         }
         this.pluginVersions = this.VERSION + " " + this.DATE;
      }
      
      public function init(param1:Object, param2:XML) : void
      {
         var params:Object = null;
         var flashvars:Object = param1;
         var pccsXML:XML = param2;
         this._pccs = pccsXML;
         try
         {
            this._pccs.appendChild(XML("<version>" + this.VERSION + "</version>"));
         }
         catch(e:Error)
         {
            _pccs.appendChild(XML("<version>Unknown</version>"));
         }
         try
         {
            this._skinUrl = String(this._pccs.skin[0].skinStyle[0].item[0].url[0]);
         }
         catch(e:Error)
         {
            _skinUrl = null;
         }
         try
         {
            this._sdkUrl = this._pccs.sdk[0].url[0];
         }
         catch(e:Error)
         {
            _sdkUrl = null;
         }
         try
         {
            this._recommendUrl = this._pccs.recommend[0].url[0];
         }
         catch(e:Error)
         {
            _recommendUrl = null;
         }
         try
         {
            this._footballUrl = this._pccs.sport[0].football[0].url[0];
         }
         catch(e:Error)
         {
            _footballUrl = null;
         }
         try
         {
            this._teleTextUrl = this._pccs.sport[0].teletext[0].url[0];
         }
         catch(e:Error)
         {
            _teleTextUrl = null;
         }
         try
         {
            if((flashvars.hasOwnProperty("sdk")) && !(flashvars["sdk"] == ""))
            {
               this._sdkUrl = flashvars.ad;
            }
            if((flashvars.hasOwnProperty("skin")) && !(flashvars["skin"] == ""))
            {
               this._skinUrl = flashvars.skin;
            }
            if((flashvars.hasOwnProperty("isRecommend")) && flashvars["isRecommend"] == "0")
            {
               this._recommendUrl = null;
            }
            params = BrowserUtil.urlparams;
            if(params.hasOwnProperty("skin"))
            {
               this._skinUrl = params["skin"];
            }
         }
         catch(e:Error)
         {
         }
         this._sdkUrl = RichStringUtil.remove(this._sdkUrl," ");
         this._skinUrl = RichStringUtil.remove(this._skinUrl," ");
         this._recommendUrl = RichStringUtil.remove(this._recommendUrl," ");
      }
      
      public function get pccs() : XML
      {
         return this._pccs;
      }
      
      public function get skinUrl() : String
      {
         return this._skinUrl;
      }
      
      public function get sdkUrl() : String
      {
         return this._sdkUrl;
      }
      
      public function get recommendUrl() : String
      {
         return this._recommendUrl;
      }
      
      public function get footballUrl() : String
      {
         return this._footballUrl;
      }
      
      public function get teleTextUrl() : String
      {
         return this._teleTextUrl;
      }
   }
}
