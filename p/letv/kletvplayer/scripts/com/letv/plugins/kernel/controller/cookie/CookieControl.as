package com.letv.plugins.kernel.controller.cookie
{
   import flash.net.SharedObject;
   import com.letv.pluginsAPI.cookieApi.CookieAPI;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.controller.Controller;
   import com.letv.pluginsAPI.kernel.DefinitionType;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.pluginsAPI.kernel.Config;
   import com.adobe.crypto.MD5;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   
   public class CookieControl extends Object
   {
      
      private static var _instance:CookieControl;
      
      public static const VCS_MIN_DT:uint = 600;
      
      public static const VCS_SET_URL:String = "http://api.my.letv.com/vcs/set";
      
      private var recordVolumeTimeout:int;
      
      private var localstorage:SharedObject;
      
      private var model:Model;
      
      private var controller:Controller;
      
      private var vcsRecordInter:int;
      
      private var playRecordInter:int;
      
      public function CookieControl()
      {
         super();
      }
      
      public static function getInstance() : CookieControl
      {
         if(_instance == null)
         {
            _instance = new CookieControl();
         }
         return _instance;
      }
      
      public function get so() : SharedObject
      {
         try
         {
            return SharedObject.getLocal(CookieAPI.COOKIE_NAME,"/");
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function init(param1:Model, param2:Controller) : void
      {
         this.model = param1;
         this.controller = param2;
      }
      
      public function readData(param1:Boolean = true) : void
      {
         var nodeInfo:Object = null;
         var nodeDuration:Number = NaN;
         var nodeSpeed:Number = NaN;
         var node:String = null;
         var startTime:Number = NaN;
         var nowTime:Number = NaN;
         var timeValue:Number = NaN;
         var checkD:Boolean = param1;
         var cookie:Object = {
            "jump":this.model.setting.jump,
            "continuePlay":this.model.setting.continuePlay,
            "fullscreenInput":this.model.setting.fullscreenInput,
            "defaultDefinition":DefinitionType.AUTO,
            "currentDefinition":DefinitionType.SD,
            "recordTime":0
         };
         try
         {
            Kernel.sendLog(this + " SetCookie ReadData ID " + this.model.setting.vid);
            if(this.so.data.hasOwnProperty(CookieAPI.DATA_NODE_INFO))
            {
               nodeInfo = this.so.data[CookieAPI.DATA_NODE_INFO];
               if((nodeInfo.hasOwnProperty("node")) && (nodeInfo.hasOwnProperty("duration")) && (nodeInfo.hasOwnProperty("startTime")))
               {
                  nodeDuration = nodeInfo.duration * 3600000;
                  nodeSpeed = Number(nodeInfo.speed);
                  node = String(nodeInfo.node);
                  startTime = nodeInfo.startTime;
                  nowTime = new Date().getTime();
                  timeValue = nowTime - startTime;
                  if((node) && (timeValue > 0) && timeValue < nodeDuration)
                  {
                     Kernel.sendLog("Ever Node " + node + " Validity " + nodeDuration + "-" + startTime + "-" + nowTime);
                     this.model.gslb.everNodeID = node;
                     this.model.gslb.everNodeSpeed = nodeSpeed;
                  }
                  else
                  {
                     Kernel.sendLog("Ever Node " + node + " Invalidity " + nodeDuration + "-" + startTime + "-" + nowTime,"warn");
                     this.model.gslb.everNodeID = null;
                     this.model.gslb.everNodeSpeed = 0;
                  }
               }
            }
            cookie.jump = this.so.data.hasOwnProperty(CookieAPI.DATA_JUMP)?Boolean(this.so.data[CookieAPI.DATA_JUMP]):true;
            cookie.continuePlay = this.so.data.hasOwnProperty(CookieAPI.DATA_CONTINUEPLAY)?Boolean(this.so.data[CookieAPI.DATA_CONTINUEPLAY]):true;
            cookie.fullscreenInput = this.so.data.hasOwnProperty(CookieAPI.DATA_FULLSCREEN_INPUT)?Boolean(this.so.data[CookieAPI.DATA_FULLSCREEN_INPUT]):false;
            cookie.barrage = this.so.data.hasOwnProperty(CookieAPI.DATA_BARRAGE)?Boolean(this.so.data[CookieAPI.DATA_BARRAGE]):false;
            cookie.volume = this.so.data.hasOwnProperty(CookieAPI.DATA_VOLUME)?Math.abs(this.so.data[CookieAPI.DATA_VOLUME]):this.model.setting.volume;
            if(cookie.volume > Config.VOLUME_TOTAL)
            {
               cookie.volume = Config.VOLUME_TOTAL;
            }
            if(checkD)
            {
               if(this.model.config.rate != null)
               {
                  cookie.currentDefinition = this.model.config.rate;
                  cookie.defaultDefinition = this.getRightDefaultDefinition(this.model.config.rate);
               }
               else if(this.so.data.hasOwnProperty(CookieAPI.DATA_DEFAULTDEFINITION))
               {
                  cookie.defaultDefinition = this.so.data[CookieAPI.DATA_DEFAULTDEFINITION];
                  cookie.currentDefinition = cookie.defaultDefinition == DefinitionType.AUTO?this.getDBySpeed():cookie.defaultDefinition;
               }
               else
               {
                  cookie.defaultDefinition = DefinitionType.AUTO;
                  cookie.currentDefinition = this.getDBySpeed();
               }
               
               cookie.currentDefinition = this.getAutoD(cookie.currentDefinition);
            }
            else
            {
               cookie.currentDefinition = this.model.setting.definition;
               cookie.defaultDefinition = this.model.setting.defaultDefinition;
            }
            cookie.recordTime = this.model.config.record?this.getPlayRecord():0;
         }
         catch(e:Error)
         {
         }
         this.model.setFlashCookie(cookie);
      }
      
      private function getRightDefaultDefinition(param1:String) : String
      {
         var _loc2_:* = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < DefinitionType.STACK.length)
            {
               if(DefinitionType.STACK[_loc2_] == param1)
               {
                  return param1;
               }
               _loc2_++;
            }
         }
         return DefinitionType.AUTO;
      }
      
      private function getPlayRecord() : Number
      {
         var recordIdentify:String = null;
         var recordArr:Array = null;
         var unit:Object = null;
         var i:int = 0;
         if(this.model.setting.duration <= VCS_MIN_DT)
         {
            return 0;
         }
         var records:Object = {
            "htime":0,
            "utime":0
         };
         try
         {
            if(this.model.setting.vid != null)
            {
               recordIdentify = this.model.setting.vid;
            }
            else
            {
               recordIdentify = MD5.hash(this.model.setting.title + this.model.setting.duration);
            }
            recordArr = this.so.data[CookieAPI.DATA_PLAYRECORD];
            if(recordArr != null)
            {
               i = 0;
               while(i < recordArr.length)
               {
                  if(String(recordArr[i].id) == recordIdentify)
                  {
                     unit = recordArr[i];
                     break;
                  }
                  i++;
               }
            }
            if(unit != null)
            {
               if((unit.hasOwnProperty("position")) && !isNaN(unit.position))
               {
                  records["htime"] = unit.position;
               }
               if((unit.hasOwnProperty("utime")) && !isNaN(unit.utime))
               {
                  records["utime"] = unit.utime;
               }
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            return records.htime;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      private function getDBySpeed() : String
      {
         var _loc4_:String = null;
         var _loc5_:* = false;
         var _loc1_:Array = this.averageSpeedInfo;
         var _loc2_:Number = _loc1_[0];
         var _loc3_:Boolean = _loc1_[1];
         Kernel.sendLog("Kernel.getAutoDefinition Speed " + _loc2_);
         if(!_loc3_)
         {
            _loc4_ = DefinitionType.SD;
         }
         else
         {
            _loc5_ = (this.model.config.forvip) || (this.model.user.isVip);
            if((_loc5_) && _loc2_ >= Config.AUTO_TO_P1080)
            {
               _loc4_ = DefinitionType.P1080;
            }
            else if((_loc5_) && _loc2_ >= Config.AUTO_TO_P720)
            {
               _loc4_ = DefinitionType.P720;
            }
            else if(_loc2_ >= Config.AUTO_TO_YH)
            {
               _loc4_ = DefinitionType.YUANHUA;
            }
            else if(_loc2_ >= Config.AUTO_TO_K4)
            {
               _loc4_ = DefinitionType.K4;
            }
            else if(_loc2_ >= Config.AUTO_TO_HD)
            {
               _loc4_ = DefinitionType.HD;
            }
            else if(_loc2_ >= Config.AUTO_TO_SD)
            {
               _loc4_ = DefinitionType.SD;
            }
            else
            {
               _loc4_ = DefinitionType.LW;
            }
            
            
            
            
            
         }
         return _loc4_;
      }
      
      public function getAutoD(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc4_:Array = null;
         var _loc3_:* = 0;
         if(this.model.user.isVip)
         {
            _loc4_ = this.model.transfer.listTotal;
         }
         else
         {
            _loc4_ = this.model.transfer.listFree;
         }
         var _loc5_:int = _loc4_.length;
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_[_loc6_] == param1)
            {
               _loc3_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         _loc6_ = _loc3_;
         while(_loc6_ >= 0)
         {
            if(this.model.gslb.gslblist.hasOwnProperty(_loc4_[_loc6_]))
            {
               _loc2_ = _loc4_[_loc6_];
               break;
            }
            _loc6_--;
         }
         if(_loc2_ == null)
         {
            _loc6_ = _loc3_;
            while(_loc6_ < _loc5_)
            {
               if(this.model.gslb.gslblist.hasOwnProperty(_loc4_[_loc6_]))
               {
                  _loc2_ = _loc4_[_loc6_];
                  break;
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function getAutoDefinition() : String
      {
         return this.getAutoD(this.getDBySpeed());
      }
      
      public function setRecordVcsLoop(param1:Boolean, param2:Boolean = false, param3:Boolean = false, param4:Number = -1) : void
      {
         clearInterval(this.vcsRecordInter);
         if(param3)
         {
            this.onRecordTimeVcs();
         }
         if(param2)
         {
            if(this.model.setting.duration > VCS_MIN_DT)
            {
               this.onRecordTimeVcs(true);
            }
         }
         if(param1)
         {
            if(!param3 && !param2)
            {
               this.onRecordTimeVcs(false,param4);
            }
            this.playRecordInter = setInterval(this.onRecordTimeVcs,Config.RECORD_VCS_RATE);
         }
      }
      
      private function onRecordTimeVcs(param1:Boolean = false, param2:Number = -1) : void
      {
         var url:String = null;
         var position:uint = 0;
         var playStop:Boolean = param1;
         var seekTime:Number = param2;
         try
         {
            if(!this.model.config.record)
            {
               return;
            }
            url = VCS_SET_URL;
            url = url + ("?cid=" + this.model.setting.cid);
            url = url + ("&pid=" + this.model.setting.pid);
            url = url + ("&vid=" + this.model.setting.vid);
            url = url + ("&nvid=" + this.model.setting.nextvid);
            url = url + ("&uid=" + this.model.user.uid);
            url = url + ("&vtype=" + (this.model.config.forvip?"2":"1"));
            url = url + ("&from=" + (this.model.config.flashvars.p2 == "11"?"5":"1"));
            position = seekTime >= 0?seekTime:this.controller.getVideoTime();
            if(position > this.model.setting.duration - Config.RECORD_DURATION_LIMIT)
            {
               playStop = true;
            }
            else if(position < Config.RECORD_DURATION_LIMIT)
            {
               playStop = false;
               position = 0;
            }
            
            if(this.model.isTrylook)
            {
               url = url + ("&htime=" + position);
            }
            else
            {
               url = url + ("&htime=" + (playStop == true?-1:position));
            }
            sendToURL(new URLRequest(url));
         }
         catch(e:Error)
         {
         }
      }
      
      public function setRecordLoop(param1:Boolean, param2:Boolean = false, param3:Boolean = false, param4:Number = -1) : void
      {
         clearInterval(this.playRecordInter);
         if(!this.model.config.record)
         {
            return;
         }
         if(param3)
         {
            this.onRecordTime();
         }
         if(param2)
         {
            if(this.model.setting.duration > VCS_MIN_DT)
            {
               this.onRecordTime(true);
            }
         }
         if(param1)
         {
            if(!param3 && !param2 && !this.model.play.limitData.limitPlay)
            {
               this.onRecordTime(false,param4);
            }
            this.playRecordInter = setInterval(this.onRecordTime,Config.RECORD_TIME_RATE);
         }
      }
      
      private function onRecordTime(param1:Boolean = false, param2:Number = -1) : void
      {
         var recordIdentify:String = null;
         var unit:Object = null;
         var recordArr:Array = null;
         var i:int = 0;
         var playStop:Boolean = param1;
         var seekTime:Number = param2;
         try
         {
            if(this.model.setting.vid != null)
            {
               recordIdentify = this.model.setting.vid;
            }
            else
            {
               recordIdentify = MD5.hash(this.model.setting.title + this.model.setting.duration);
            }
            unit = {};
            unit.from = 1;
            unit.id = recordIdentify;
            unit.vid = this.model.setting.vid;
            unit.pid = this.model.setting.pid;
            unit.cid = this.model.setting.cid;
            unit.url = this.model.setting.url;
            unit.pic = this.model.setting.pic;
            unit.vtime = int(this.model.setting.duration);
            unit.title = this.model.setting.title;
            unit.nextid = this.model.setting.nextvid;
            unit.position = int(seekTime >= 0?seekTime:this.controller.getVideoTime());
            if(playStop)
            {
               if(this.model.isTrylook)
               {
                  return;
               }
               unit.position = -1;
            }
            else if(unit.position > this.model.setting.duration - Config.RECORD_DURATION_LIMIT)
            {
               unit.position = -1;
            }
            else if(unit.position < Config.RECORD_DURATION_LIMIT)
            {
               unit.position = 0;
            }
            
            
            recordArr = this.so.data[CookieAPI.DATA_PLAYRECORD];
            if(recordArr == null)
            {
               recordArr = [];
            }
            else
            {
               i = 0;
               while(i < recordArr.length)
               {
                  if((recordArr[i].hasOwnProperty("pid")) && String(recordArr[i].pid) == unit.pid)
                  {
                     recordArr.splice(i,1);
                     i--;
                  }
                  i++;
               }
            }
            recordArr.push(unit);
            if(recordArr.length > Config.RECORD_PLAYER_MAX)
            {
               recordArr.shift();
            }
            this.so.data[CookieAPI.DATA_PLAYRECORD] = recordArr;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function recordDefinition() : void
      {
         try
         {
            this.so.data[CookieAPI.DATA_DEFAULTDEFINITION] = this.model.setting.defaultDefinition;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function recordJump() : void
      {
         try
         {
            this.so.data[CookieAPI.DATA_JUMP] = this.model.setting.jump;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function recordFullscreenInput() : void
      {
         try
         {
            this.so.data[CookieAPI.DATA_FULLSCREEN_INPUT] = this.model.setting.fullscreenInput;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function recordBarrage() : void
      {
         try
         {
            this.so.data[CookieAPI.DATA_BARRAGE] = this.model.setting.barrage;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function recordVolume(param1:Number) : void
      {
         clearTimeout(this.recordVolumeTimeout);
         this.recordVolumeTimeout = setTimeout(this.onDelayRecordVolume,200,param1);
      }
      
      private function onDelayRecordVolume(param1:Number) : void
      {
         var value:Number = param1;
         if(value > Config.VOLUME_TOTAL)
         {
            value = Config.VOLUME_TOTAL;
         }
         try
         {
            this.so.data[CookieAPI.UP_VOLUME] = this.so.data[CookieAPI.DATA_VOLUME];
            this.so.data[CookieAPI.DATA_VOLUME] = value;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function recordSpeed(param1:Number) : void
      {
         var speedStack:Array = null;
         var value:Number = param1;
         try
         {
            this.model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.PLAYER_SPEED,value));
            speedStack = this.so.data[CookieAPI.DATA_SPEED];
            if(speedStack == null)
            {
               speedStack = [];
            }
            speedStack.push(value);
            if(speedStack.length > Config.RECORD_SPEED_MAX)
            {
               speedStack.shift();
            }
            this.so.data[CookieAPI.DATA_SPEED] = speedStack;
            this.so.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function get averageSpeedInfo() : Array
      {
         var speed:int = 0;
         var speedStack:Array = null;
         var speedLen:int = 0;
         var i:int = 0;
         speed = 0;
         try
         {
            speedStack = this.so.data[CookieAPI.DATA_SPEED] as Array;
            speedLen = speedStack.length;
            i = 0;
            while(i < speedLen)
            {
               speed = speed + speedStack[i];
               i++;
            }
            speed = int(speed / speedLen);
            return [speed,true];
         }
         catch(e:Error)
         {
            return [speed,false];
         }
         return [speed,true];
      }
      
      public function get averageSpeed() : int
      {
         return this.averageSpeedInfo[0];
      }
      
      public function preloadDefinition() : String
      {
         var value:String = null;
         var definition:String = null;
         var index:int = 0;
         var stack:Array = null;
         var len:int = 0;
         var i:int = 0;
         try
         {
            if(this.model.config.rate != null)
            {
               value = this.model.config.rate;
            }
            else if(this.so.data.hasOwnProperty(CookieAPI.DATA_DEFAULTDEFINITION))
            {
               value = this.so.data[CookieAPI.DATA_DEFAULTDEFINITION] == DefinitionType.AUTO?this.getDBySpeed():this.so.data[CookieAPI.DATA_DEFAULTDEFINITION];
            }
            else
            {
               value = this.getDBySpeed();
            }
            
            index = 0;
            if(this.model.user.isVip)
            {
               stack = this.model.transfer.listTotal;
            }
            else
            {
               stack = this.model.transfer.listFree;
            }
            len = stack.length;
            i = 0;
            while(i < len)
            {
               if(stack[i] == value)
               {
                  index = i;
                  break;
               }
               i++;
            }
            i = index;
            while(i >= 0)
            {
               if(this.model.preloadData.preloadData.playData.list.hasOwnProperty(stack[i]))
               {
                  definition = stack[i];
                  break;
               }
               i--;
            }
            if(definition == null)
            {
               i = index;
               while(i < len)
               {
                  if(this.model.preloadData.preloadData.playData.list.hasOwnProperty(stack[i]))
                  {
                     definition = stack[i];
                     break;
                  }
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            definition = model.setting.definition;
         }
         Kernel.sendLog("重新获取清晰度");
         return definition;
      }
   }
}
