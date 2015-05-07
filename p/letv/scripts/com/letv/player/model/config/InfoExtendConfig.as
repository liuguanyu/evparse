package com.letv.player.model.config
{
   public class InfoExtendConfig extends Object
   {
      
      private var _plugins:Array;
      
      public function InfoExtendConfig(param1:XML)
      {
         var xml:XML = null;
         var list:XMLList = null;
         var len:int = 0;
         var i:int = 0;
         var obj:Object = null;
         var pccs:XML = param1;
         this._plugins = [];
         super();
         try
         {
            xml = XML(pccs.extend[0]);
         }
         catch(e:Error)
         {
            return;
         }
         try
         {
            list = xml.item;
            len = list.length();
            i = 0;
            while(i < len)
            {
               if(list[i] != null)
               {
                  obj = {};
                  obj.checkPolicy = true;
                  obj.type = "flash";
                  obj.title = list[i].title;
                  obj.url = list[i].url;
                  obj.time = int(list[i].time);
                  obj.id = list[i].id;
                  obj.eventid = String(list[i].eventid);
                  if((list[i].hasOwnProperty("openapi")) && String(list[i].openapi) == "0")
                  {
                     obj.openapi = false;
                  }
                  else
                  {
                     obj.openapi = true;
                  }
                  if((list[i].hasOwnProperty("shutdown")) && String(list[i].shutdown) == "1")
                  {
                     obj.shutdown = true;
                  }
                  else
                  {
                     obj.shutdown = false;
                  }
                  if((list[i].hasOwnProperty("hide")) && String(list[i].hide) == "1")
                  {
                     obj.hide = true;
                  }
                  else
                  {
                     obj.hide = false;
                  }
                  obj.position = this.getPosition(list[i].position[0]);
               }
               this._plugins[i] = obj;
               i++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function getPosition(param1:XML) : Object
      {
         var obj:Object = null;
         var xml:XML = param1;
         obj = {};
         try
         {
            if((xml.hasOwnProperty("horizontalCenter")) && !isNaN(xml.horizontalCenter))
            {
               obj.horizontalCenter = int(xml.horizontalCenter);
            }
            if(xml.hasOwnProperty("left"))
            {
               obj.left = int(xml.left[0]);
            }
            if(xml.hasOwnProperty("right"))
            {
               obj.right = int(xml.right[0]);
            }
            if((xml.hasOwnProperty("verticalCenter")) && !isNaN(xml.verticalCenter))
            {
               obj.verticalCenter = int(xml.verticalCenter);
            }
            if(xml.hasOwnProperty("top"))
            {
               obj.top = int(xml.top[0]);
            }
            if(xml.hasOwnProperty("bottom"))
            {
               obj.bottom = int(xml.bottom[0]);
            }
         }
         catch(e:Error)
         {
            obj.top = 0;
            obj.left = 0;
         }
         return obj;
      }
      
      public function get plugins() : Object
      {
         return this._plugins;
      }
   }
}
