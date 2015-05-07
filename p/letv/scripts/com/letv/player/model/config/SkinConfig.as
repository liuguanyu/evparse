package com.letv.player.model.config
{
   import flash.events.EventDispatcher;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   
   public class SkinConfig extends EventDispatcher
   {
      
      public var barrageSupport:Boolean = true;
      
      public var screenNormalDockVisible:Boolean = true;
      
      public var screenNormalVideoListBtnVisible:Boolean = false;
      
      public var mainLoading:Object;
      
      private var _skin:DisplayObjectContainer;
      
      private var _controlBar:DisplayObject;
      
      private var _topPanel:DisplayObject;
      
      private var _displayBar:DisplayObject;
      
      private var _loading:DisplayObject;
      
      private var _trylook:DisplayObject;
      
      private var _infotip:DisplayObject;
      
      private var _firstlook:DisplayObject;
      
      private var _loginlook:DisplayObject;
      
      public function SkinConfig(param1:DisplayObjectContainer)
      {
         var skins:DisplayObjectContainer = param1;
         super();
         try
         {
            this._skin = skins.getChildByName("player") as DisplayObjectContainer;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._controlBar = this._skin.getChildByName("controlBar");
            this._controlBar.x = 0;
            this._controlBar.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._topPanel = this._skin.getChildByName("topPanel");
            this._topPanel.x = 0;
            this._topPanel.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._displayBar = this._skin.getChildByName("displayBar");
            this._displayBar.x = 0;
            this._displayBar.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._loading = this._skin.getChildByName("loading");
            this._loading.x = 0;
            this._loading.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._trylook = this._skin.getChildByName("trylook");
            this._trylook.x = 0;
            this._trylook.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._infotip = this._skin.getChildByName("infotip");
            this._infotip.x = 0;
            this._infotip.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._firstlook = this._skin.getChildByName("firstlook");
            this._firstlook.x = 0;
            this._firstlook.y = 0;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._loginlook = this._skin.getChildByName("loginlook");
            this._loginlook.x = 0;
            this._loginlook.y = 0;
         }
         catch(e:Error)
         {
         }
      }
      
      public function get skin() : DisplayObjectContainer
      {
         return this._skin;
      }
      
      public function get controlBar() : Object
      {
         return this._controlBar;
      }
      
      public function get topPanel() : Object
      {
         return this._topPanel;
      }
      
      public function get displayBar() : Object
      {
         return this._displayBar;
      }
      
      public function get loading() : Object
      {
         return this._loading;
      }
      
      public function get trylook() : Object
      {
         return this._trylook;
      }
      
      public function get infotip() : Object
      {
         return this._infotip;
      }
      
      public function get firstlook() : Object
      {
         return this._firstlook;
      }
      
      public function get loginlook() : Object
      {
         return this._loginlook;
      }
   }
}
