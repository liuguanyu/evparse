package com.letv.store
{
   import flash.events.EventDispatcher;
   import flash.display.Sprite;
   import com.letv.player.components.CloseBtn;
   import com.letv.store.classes.ExtendList_2;
   import com.alex.rpc.AutoLoader;
   import flash.events.MouseEvent;
   import com.letv.store.events.ExtendListEvent;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.letv.store.events.ExtendEvent;
   import flash.events.Event;
   import flash.net.SharedObject;
   
   public class ExtendUI_2 extends EventDispatcher
   {
      
      private var container:Sprite;
      
      private var pluginContainer:Sprite;
      
      private var closeBtn:CloseBtn;
      
      private var allData:Array;
      
      private var list:ExtendList_2;
      
      private var plugin:Sprite;
      
      private var memory:Object;
      
      private var loader:AutoLoader;
      
      private var stream_id:Object;
      
      private var testurl:String;
      
      public function ExtendUI_2(param1:Object, param2:Object, param3:Object = null)
      {
         super();
         this.container = param1 as Sprite;
         this.allData = param2 as Array;
         this.init();
      }
      
      public function destroy() : void
      {
         this.removePlugin();
         this.container.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onPluginStopDrag);
         this.container = null;
         this.allData = null;
         if(this.list != null)
         {
            this.list.destroy();
            this.list.removeEventListener(ExtendListEvent.CHANGE,this.onListChange);
            this.list.removeEventListener(ExtendListEvent.CLOSE_PLUGIN,this.onClosePlugin);
            this.list = null;
         }
      }
      
      public function resize() : void
      {
         var _loc1_:Object = null;
         if((this.container.stage) && (this.pluginContainer) && (this.pluginContainer.stage))
         {
            if(this.plugin)
            {
               _loc1_ = this.getPluginPosition(this.memory.data.eventid);
               this.plugin.x = _loc1_.x;
               this.plugin.y = _loc1_.y;
               this.protectLayer = this.memory.data.shutdown;
            }
            this.setClosePos();
         }
      }
      
      private function setClosePos() : void
      {
         if((this.plugin) && (this.closeBtn))
         {
            this.closeBtn.x = this.plugin.x + this.memory.data.wid - this.closeBtn.width / 2;
            this.closeBtn.y = this.plugin.y - this.closeBtn.height / 4;
            this.closeBtn.visible = true;
            this.pluginContainer.addChild(this.closeBtn);
         }
         else
         {
            this.closeBtn.visible = false;
            if(this.pluginContainer.contains(this.closeBtn))
            {
               this.pluginContainer.removeChild(this.closeBtn);
            }
         }
      }
      
      public function set protectLayer(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.pluginContainer.stage)
            {
               this.pluginContainer.graphics.clear();
               this.pluginContainer.graphics.beginFill(0,0.7);
               this.pluginContainer.graphics.drawRect(0,0,this.pluginContainer.stage.stageWidth,this.pluginContainer.stage.stageHeight);
               this.pluginContainer.graphics.endFill();
            }
         }
         else
         {
            this.pluginContainer.graphics.clear();
         }
      }
      
      public function displayList(param1:Boolean = true, param2:String = null) : void
      {
         if(param1)
         {
            this.testurl = param2;
            this.list.toggle();
         }
         else
         {
            this.list.shutdown();
         }
      }
      
      public function removePlugin() : void
      {
         this.closeBtn.visible = false;
         if(this.plugin != null)
         {
            try
            {
               this.list.update(this.memory.data.eventid,false);
            }
            catch(e:Error)
            {
            }
            try
            {
               this.pluginContainer.removeChild(this.plugin);
            }
            catch(e:Error)
            {
            }
            this.plugin.removeEventListener("cookie",this.onPluginCookie);
            this.plugin.removeEventListener("command",this.onPluginCommand);
            this.plugin.removeEventListener(MouseEvent.MOUSE_DOWN,this.onPluginStartDrag);
            if(this.memory.data.shutdown)
            {
               this.protectLayer = false;
            }
            try
            {
               this.plugin.stopDrag();
            }
            catch(e:Error)
            {
            }
            try
            {
               this.plugin["destroy"]();
            }
            catch(e:Error)
            {
            }
            this.memory.data = null;
            this.plugin = null;
         }
         if(this.closeBtn)
         {
            this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onHidePlugin);
         }
         this.memory = null;
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.destroy();
            this.loader = null;
         }
      }
      
      public function setStreamID(param1:String) : void
      {
         this.stream_id = param1;
      }
      
      public function displayPlugin(param1:String, param2:String = null) : void
      {
         this.testurl = param2;
         var _loc3_:Object = this.getData(param1);
         if(!(_loc3_ == null) && !(this.container.stage == null))
         {
            this.removePlugin();
            this.loadPlugin(param1,[_loc3_]);
         }
      }
      
      private function getData(param1:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc2_:int = this.allData.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.allData[_loc3_].eventid == param1)
            {
               _loc4_ = {};
               for(_loc5_ in this.allData[_loc3_])
               {
                  _loc4_[_loc5_] = this.allData[_loc3_][_loc5_];
               }
               if((this.stream_id) && param1 == "extend_plugin_testspeed")
               {
                  _loc4_.url = _loc4_.url + ("?live=1&stream_id=" + this.stream_id);
               }
               _loc4_.first = 10000;
               _loc4_.gap = 3000;
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function loadPlugin(param1:String, param2:Array) : void
      {
         this.removePlugin();
         this.loader = new AutoLoader();
         this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError,false,0,true);
         this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete,false,0,true);
         this.loader.setup(param2);
      }
      
      private function onLoadError(param1:AutoLoaderEvent = null) : void
      {
         this.removePlugin();
         var _loc2_:ExtendEvent = new ExtendEvent(ExtendEvent.EXTEND_INFOTIP);
         if(param1)
         {
            _loc2_.eventid = param1.dataProvider.data.eventid;
            _loc2_.dataProvider = "<font size=\'12\' face=\'宋体\' color=\'#ffffff\'>): 对不起,插件</font><a href=\'event:load_extend_error\'>" + param1.dataProvider.data.title + "</a><font size=\'12\' face=\'宋体\' color=\'#ffffff\'>加载失败!</font>";
         }
         else
         {
            _loc2_.dataProvider = "<font size=\'12\' face=\'宋体\' color=\'#ffffff\'>): 对不起,插件加载失败!</font>";
         }
         dispatchEvent(_loc2_);
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var info:Object = null;
         var ev:ExtendEvent = null;
         var event:AutoLoaderEvent = param1;
         this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
         this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         this.plugin = event.dataProvider.content.content;
         if(this.plugin != null)
         {
            this.memory = {};
            this.memory.data = event.dataProvider.data;
            this.memory.data.hadMove = false;
            this.memory.data.wid = this.plugin.loaderInfo.width;
            this.memory.data.hei = this.plugin.loaderInfo.height;
            if(this.memory.data.hide)
            {
               this.list.hide();
            }
            this.pluginContainer.addChild(this.plugin);
            this.resize();
            this.plugin.addEventListener("cookie",this.onPluginCookie,false,0,true);
            this.plugin.addEventListener("command",this.onPluginCommand,false,0,true);
            info = {
               "uuid":null,
               "did":null,
               "gone":"-1",
               "gslbCount":1,
               "testurl":this.testurl
            };
            try
            {
               this.plugin["platformInfo"] = info;
            }
            catch(e:Error)
            {
            }
            this.list.update(this.memory.data.eventid,true);
            if(this.memory.data.shutdown)
            {
               this.protectLayer = true;
               ev = new ExtendEvent(ExtendEvent.EXTEND_COMMAND);
               ev.eventid = this.memory.data.eventid;
               ev.command = "shutDown";
               dispatchEvent(ev);
            }
            else
            {
               this.plugin.addEventListener(MouseEvent.MOUSE_DOWN,this.onPluginStartDrag,false,0,true);
            }
            this.closeBtn.addEventListener(MouseEvent.CLICK,this.onHidePlugin,false,0,true);
         }
         else
         {
            this.onLoadError();
         }
      }
      
      private function getPluginPosition(param1:String) : Object
      {
         var eventid:String = param1;
         var obj:Object = {
            "x":0,
            "y":0
         };
         var value:Object = this.getData(eventid);
         if(value == null || !value.hasOwnProperty("position"))
         {
            return obj;
         }
         var position:Object = value.position;
         try
         {
            if(this.memory.data.hadMove)
            {
               obj.x = this.plugin.x;
               obj.y = this.plugin.y;
               if(this.plugin.x + this.memory.data.wid > this.container.stage.stageWidth)
               {
                  obj.x = this.container.stage.stageWidth - this.memory.data.wid;
               }
               else if(this.plugin.x < 0)
               {
                  obj.x = 0;
               }
               
               if(this.plugin.y + this.memory.data.hei > this.container.stage.stageHeight)
               {
                  obj.y = this.container.stage.stageHeight - this.memory.data.hei;
               }
               else if(this.plugin.y < 0)
               {
                  obj.y = 0;
               }
               
               return obj;
            }
            if(position.hasOwnProperty("horizontalCenter"))
            {
               obj.x = (this.container.stage.stageWidth - this.memory.data.wid) / 2 + position.horizontalCenter;
            }
            else if(position.hasOwnProperty("left"))
            {
               obj.x = position.left;
            }
            else if(position.hasOwnProperty("right"))
            {
               obj.x = this.container.stage.stageWidth - position.right - this.memory.data.wid;
            }
            
            
            if(position.hasOwnProperty("verticalCenter"))
            {
               obj.y = (this.container.stage.stageHeight - this.memory.data.hei) / 2 + position.verticalCenter;
            }
            else if(position.hasOwnProperty("top"))
            {
               obj.y = position.top;
            }
            else if(position.hasOwnProperty("bottom"))
            {
               obj.y = this.container.stage.stageHeight - position.bottom - this.memory.data.hei;
            }
            
            
         }
         catch(e:Error)
         {
         }
         return obj;
      }
      
      protected function init() : void
      {
         this.pluginContainer = new Sprite();
         this.container.addChild(this.pluginContainer);
         this.list = new ExtendList_2(this.allData);
         this.list.addEventListener(ExtendListEvent.CHANGE,this.onListChange,false,0,true);
         this.list.addEventListener(ExtendListEvent.CLOSE_PLUGIN,this.onClosePlugin,false,0,true);
         this.container.addChild(this.list);
         this.closeBtn = new CloseBtn();
      }
      
      protected function onPluginCommand(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:ExtendEvent = null;
         if((this.memory.data.openapi) && (param1.hasOwnProperty("dataProvider")))
         {
            _loc2_ = param1["dataProvider"];
            _loc3_ = new ExtendEvent(ExtendEvent.EXTEND_COMMAND);
            _loc3_.eventid = this.memory.data.eventid;
            _loc3_.command = _loc2_.command;
            _loc3_.dataProvider = _loc2_.data;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onPluginCookie(param1:Event) : void
      {
         var value:Object = null;
         var cookieName:String = null;
         var so:SharedObject = null;
         var event:Event = param1;
         try
         {
            value = event["dataProvider"];
            cookieName = "com.letv";
            if(value.hasOwnProperty("cookieName"))
            {
               cookieName = value["cookieName"];
            }
            so = SharedObject.getLocal(cookieName,"/");
            so.data[value["dataName"]] = value["data"];
            so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      private function onPluginStartDrag(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            this.closeBtn.visible = false;
            this.memory.data.hadMove = true;
            this.pluginContainer.addChild(this.plugin);
            this.plugin.startDrag();
            this.container.stage.addEventListener(MouseEvent.MOUSE_UP,this.onPluginStopDrag,false,0,true);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onPluginStopDrag(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            this.plugin.stopDrag();
            if(this.plugin.x < 0)
            {
               this.plugin.x = 0;
            }
            else if(this.plugin.x > this.container.stage.stageWidth - this.memory.data.wid)
            {
               this.plugin.x = this.container.stage.stageWidth - this.memory.data.wid;
            }
            
            if(this.plugin.y < 0)
            {
               this.plugin.y = 0;
            }
            else if(this.plugin.y > this.container.stage.stageHeight - this.memory.data.hei)
            {
               this.plugin.y = this.container.stage.stageHeight - this.memory.data.hei;
            }
            
            this.setClosePos();
         }
         catch(e:Error)
         {
         }
         this.container.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onPluginStopDrag);
      }
      
      private function onHidePlugin(param1:MouseEvent) : void
      {
         var _loc3_:ExtendEvent = null;
         var _loc2_:String = this.memory.data.eventid;
         if(this.memory.data.shutdown)
         {
            this.protectLayer = false;
            _loc3_ = new ExtendEvent(ExtendEvent.EXTEND_COMMAND);
            _loc3_.eventid = _loc2_;
            _loc3_.command = "setNode";
            dispatchEvent(_loc3_);
         }
         this.removePlugin();
      }
      
      private function onListChange(param1:ExtendListEvent) : void
      {
         this.displayPlugin(param1.eventid,this.testurl);
      }
      
      private function onClosePlugin(param1:ExtendListEvent) : void
      {
         var _loc2_:* = false;
         var _loc3_:String = null;
         var _loc4_:ExtendEvent = null;
         if(this.plugin)
         {
            _loc2_ = this.memory.data.shutdown;
            _loc3_ = this.memory.data.eventid;
            this.removePlugin();
         }
         if(_loc2_)
         {
            this.protectLayer = false;
            _loc4_ = new ExtendEvent(ExtendEvent.EXTEND_COMMAND);
            _loc4_.eventid = _loc3_;
            _loc4_.command = "setNode";
            dispatchEvent(_loc4_);
         }
      }
   }
}
