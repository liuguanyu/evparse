package cn.pplive.player.dac
{
   import flash.utils.Timer;
   import com.pplive.dac.logclient.DataLogSource;
   import com.pplive.dac.logclient.DataLogItem;
   import com.pplive.dac.logclient.DataLog;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.utils.PrintDebug;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   
   public class DACQueue extends Object
   {
      
      private static var _noQueue:Array = [];
      
      private static var _timer:Timer;
      
      private static var _logSource:DataLogSource;
      
      public function DACQueue()
      {
         super();
      }
      
      public static function set noQueue(param1:Array) : void
      {
         _noQueue = param1;
      }
      
      private static function getItem(param1:Array) : Vector.<DataLogItem>
      {
         var _loc4_:Array = null;
         var _loc2_:Vector.<DataLogItem> = new Vector.<DataLogItem>();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_].split("=");
            _loc2_.push(new DataLogItem(_loc4_[0],decodeURIComponent(_loc4_[1])));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function sendLog(param1:Array, param2:Array) : void
      {
         var _loc6_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:DataLog = null;
         var _loc3_:Vector.<DataLogItem> = getItem(param1) as Vector.<DataLogItem>;
         var _loc4_:Vector.<DataLogItem> = getItem(param2) as Vector.<DataLogItem>;
         var _loc5_:* = true;
         var _loc7_:int = _noQueue.length;
         for(_loc8_ in _loc3_)
         {
            _loc9_ = _loc3_[_loc8_]["Name"];
            if(_loc9_ == "dt")
            {
               _logSource = DataLogSource.IKanVodApp;
               _loc6_ = _loc3_[_loc8_]["Value"];
            }
            if(_loc9_ == "A")
            {
               _logSource = DataLogSource.IKanOnlineApp;
               _loc6_ = "online";
            }
            if(_loc9_ == "plt")
            {
               _logSource = DataLogSource.IKanBehaApp;
               _loc6_ = "action";
            }
            if((_loc9_ == "guid" || _loc9_ == "B" || _loc9_ == "puid") && !(_loc3_[_loc8_]["Value"] == "null"))
            {
               _loc5_ = false;
               break;
            }
            _loc10_ = 0;
            while(_loc10_ < _loc7_)
            {
               if(_noQueue[_loc10_] == _loc3_[_loc8_]["Value"])
               {
                  _loc5_ = false;
                  break;
               }
               _loc10_++;
            }
         }
         if(!Global.getInstance()["queue"])
         {
            Global.getInstance()["queue"] = [];
         }
         if(!_loc5_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc7_)
            {
               if(_noQueue[_loc11_] == _loc6_)
               {
                  _noQueue.splice(_loc11_,1);
               }
               _loc11_++;
            }
            _loc12_ = new DataLog(_logSource);
            _loc12_.sendLogRequestAsync(_loc3_,_loc4_);
         }
         else
         {
            Global.getInstance()["queue"].push({
               "first":_loc3_,
               "second":_loc4_
            });
            PrintDebug.Trace("建立 queue 日志数组，长度  >>>>>>>>  " + Global.getInstance()["queue"].length);
         }
      }
      
      public static function sendLogQueue(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:Vector.<DataLogItem> = null;
         var _loc6_:Vector.<DataLogItem> = null;
         var _loc7_:String = null;
         var _loc8_:DataLog = null;
         var _loc9_:String = null;
         var _loc2_:Array = Global.getInstance()["queue"];
         if((_loc2_) && _loc2_.length > 0)
         {
            PrintDebug.Trace("计时器监听 DAC 队列已经存在，开始处理发送......");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = _loc2_[_loc4_]["first"];
               _loc6_ = _loc2_[_loc4_]["second"];
               for(_loc7_ in _loc5_)
               {
                  _loc9_ = _loc5_[_loc7_]["Name"];
                  if((_loc9_ == "guid" || _loc9_ == "B" || _loc9_ == "puid") && _loc5_[_loc7_]["Value"] == "null")
                  {
                     _loc5_[_loc7_]["Value"] = param1;
                  }
                  if(_loc9_ == "dt")
                  {
                     _logSource = DataLogSource.IKanVodApp;
                     _loc3_ = _loc5_[_loc7_]["Value"];
                  }
                  if(_loc9_ == "A")
                  {
                     _logSource = DataLogSource.IKanOnlineApp;
                     _loc3_ = "online";
                  }
                  if(_loc9_ == "plt")
                  {
                     _logSource = DataLogSource.IKanBehaApp;
                     _loc3_ = "action";
                  }
               }
               PrintDebug.Trace("队列发送 " + _loc3_ + " 日志......" + String(_loc2_[_loc4_]["first"]).split(",").join("&") + "&" + String(_loc2_[_loc4_]["second"]).split(",").join("&"));
               _loc8_ = new DataLog(_logSource);
               _loc8_.sendLogRequestAsync(_loc5_,_loc6_);
               _loc4_++;
            }
            PrintDebug.Trace("队列 DAC 发送完毕，清除队列......");
            delete Global.getInstance()["queue"];
            true;
         }
      }
      
      public static function sendURL(param1:String) : void
      {
         if(param1)
         {
            sendToURL(new URLRequest(param1));
         }
      }
   }
}
