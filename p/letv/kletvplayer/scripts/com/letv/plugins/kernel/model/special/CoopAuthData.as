package com.letv.plugins.kernel.model.special
{
   import com.letv.pluginsAPI.kernel.User;
   
   public class CoopAuthData extends Object
   {
      
      public var status:String;
      
      public var playtime:int = -1;
      
      public var playEndCallback:String;
      
      public function CoopAuthData(param1:Object, param2:UserSetting)
      {
         super();
         if(param1)
         {
            if(param1.hasOwnProperty("status"))
            {
               this.status = String(param1["status"]);
            }
            if(param1.hasOwnProperty("playtime"))
            {
               this.playtime = int(param1["playtime"]);
            }
            if(param1.hasOwnProperty("playEndCallback"))
            {
               this.playEndCallback = String(param1["playEndCallback"]);
            }
         }
         else
         {
            this.status = null;
            this.playtime = -1;
            this.playEndCallback = null;
         }
         if(this.status == "1")
         {
            param2.status = User.VIP_NORMAL;
         }
         else
         {
            param2.reset();
         }
      }
   }
}
