package cn.pplive.player.dac
{
   import flash.events.EventDispatcher;
   import cn.pplive.player.utils.AS3Cookie;
   import flash.utils.Dictionary;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.common.*;
   import com.pplive.dac.logclient.*;
   import flash.events.Event;
   import cn.pplive.player.utils.hash.Global;
   import flash.system.Capabilities;
   
   public class DACReport extends EventDispatcher
   {
      
      public static const INIT_VVID:String = "init_vvid";
      
      private static const STATIC:String = "static";
      
      public static var vvid:String = null;
      
      private var $dso:AS3Cookie;
      
      private var $dacItem:Dictionary;
      
      private var $source:String = "1";
      
      private var $isVip:Boolean;
      
      private var $puid:String = null;
      
      private var tdsArr:Array;
      
      private var tdsTime:Number = 0;
      
      public function DACReport(param1:String)
      {
         this.tdsArr = [];
         super();
         this.$dso = new AS3Cookie(param1);
         this.$dso.isOften = false;
         vvid = Guid.create();
         PrintDebug.Trace("初始化创建vvid" + vvid);
         this.$dacItem = new Dictionary();
      }
      
      public function set isVip(param1:Boolean) : void
      {
         this.$isVip = param1;
         this.setValue(DACCommon.ISVIP,Number(this.$isVip));
      }
      
      public function set puid(param1:String) : void
      {
         this.$puid = param1;
         this.$dso.setData("guid",this.$puid);
      }
      
      public function get puid() : String
      {
         if(this.$dso.contains("guid"))
         {
            this.$puid = this.$dso.getData("guid");
         }
         return this.$puid;
      }
      
      public function updateSession() : void
      {
         vvid = Guid.create();
         PrintDebug.Trace("切换频道更新vvid" + vvid);
         this.initSession();
      }
      
      private function initSession() : void
      {
         if(!this.$dso.contains(STATIC))
         {
            this.$dso.setData(STATIC,{});
         }
         if(!this.$dso.getData(STATIC)[vvid])
         {
            this.$dso.getData(STATIC)[vvid] = {};
         }
         this.dispatchEvent(new Event(DACReport.INIT_VVID));
      }
      
      public function setValue(param1:String, param2:*, param3:String = null) : void
      {
         if(!param3)
         {
            var param3:String = vvid;
         }
         try
         {
            this.$dso.getData(STATIC)[param3][param1] = param2;
            this.$dso.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public function getValue(param1:String, param2:String = null, param3:Boolean = false) : *
      {
         var _loc5_:Object = null;
         if(!param2)
         {
            var param2:String = vvid;
         }
         var _loc4_:* = null;
         try
         {
            _loc5_ = this.$dso.getData(STATIC)[param2];
            if(!this.$dso.isNullOrUndefined(_loc5_[param1]))
            {
               if(param3)
               {
                  _loc4_ = _loc5_[param1];
               }
               else
               {
                  _loc4_ = encodeURIComponent(_loc5_[param1]);
               }
            }
         }
         catch(e:Error)
         {
         }
         return _loc4_;
      }
      
      public function addValue(param1:String, param2:Number = 1) : void
      {
         var _loc3_:int = int(this.getValue(param1));
         _loc3_ = _loc3_ + param2;
         this.setValue(param1,_loc3_);
      }
      
      public function addObjectValue(param1:String, param2:Object = null) : void
      {
         var _loc3_:Array = null;
         if(param2)
         {
            try
            {
               _loc3_ = [];
               if(this.getValue(param1,null,true))
               {
                  _loc3_ = this.getValue(param1,null,true);
               }
               _loc3_.push(param2);
               this.setValue(param1,_loc3_);
            }
            catch(err:Error)
            {
            }
         }
         if(param2)
         {
            return;
         }
      }
      
      public function setMark(param1:String, param2:*) : void
      {
         switch(param1)
         {
            case DACCommon.TDS:
               this.tdsArr.push(param2["p"] + "=" + encodeURIComponent(String(param2["t"] - this.tdsTime)));
               if(this.tdsTime == 0)
               {
                  this.tdsTime = param2["t"];
               }
               break;
         }
      }
      
      public function get tdsMark() : String
      {
         if(this.tdsArr.length > 0)
         {
            return this.tdsArr.join("&");
         }
         return "";
      }
      
      public function startRecord(param1:String) : void
      {
         Global.getInstance()[param1] = {
            "time":new Date().getTime(),
            "bool":true
         };
      }
      
      public function stopRecord(param1:String, param2:* = null) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:Number = new Date().getTime();
         if((Global.getInstance()[param1]) && (Global.getInstance()[param1]["bool"]))
         {
            _loc3_ = Global.getInstance()[param1]["time"];
            Global.getInstance()[param1]["bool"] = false;
            Global.getInstance()[param1]["time"] = _loc4_ - _loc3_ < 20000 * 1000?_loc4_ - _loc3_:1;
            switch(param1)
            {
               case DACCommon.TDD:
                  this.sendRecord("dd",DACCommon.TDD,Global.getInstance()[DACCommon.TDD]["time"]);
                  break;
               case DACCommon.DTT:
                  this.sendRecord("dtt",DACCommon.DTT,Global.getInstance()[DACCommon.DTT]["time"]);
                  break;
               case DACCommon.TDS:
                  this.sendRecord("sd",DACCommon.TDS,Global.getInstance()[DACCommon.TDS]["time"],this.tdsMark + (param2?"&" + param2:""));
                  this.tdsArr = [];
                  this.tdsTime = 0;
                  break;
               case DACCommon.VST:
                  this.sendRecord("vst",DACCommon.VST,Global.getInstance()[DACCommon.VST]["time"]);
                  break;
               case DACCommon.BS:
                  this.addValue(DACCommon.BS,Global.getInstance()[DACCommon.BS]["time"]);
                  break;
            }
         }
      }
      
      private function sendRecord(param1:String, param2:String, param3:Number, param4:String = "") : void
      {
         var _loc5_:Array = null;
         if(param3 < 120 * 1000)
         {
            _loc5_ = [param2 + "=" + param3];
            if(param4 != "")
            {
               _loc5_ = _loc5_.concat(param4.split("&"));
            }
            this.sendDAC(param1,_loc5_);
         }
         if(Global.getInstance()[param2])
         {
            delete Global.getInstance()[param2];
            true;
         }
      }
      
      private function getCtx(param1:*) : Array
      {
         var all:* = param1;
         var ctxValue:Function = function(param1:String):String
         {
            var _loc2_:String = param1;
            if(_loc2_.indexOf("=") == -1)
            {
               _loc2_ = decodeURIComponent(_loc2_);
               if(_loc2_.indexOf("=") == -1)
               {
                  _loc2_ = ctxValue(_loc2_);
               }
            }
            return _loc2_;
         };
         return ctxValue(String(all)).split("&");
      }
      
      public function sendP2PLog(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            if(!(_loc3_.toString() == "dt") && !(param1[_loc3_] == null))
            {
               _loc2_.push(_loc3_.toString() + "=" + encodeURIComponent(param1[_loc3_].toString()));
            }
         }
         _loc2_.push("player=p2p");
         this.sendDAC(param1.dt,_loc2_);
      }
      
      private function sendDAC(param1:String, param2:Array = null, param3:String = null) : void
      {
         if(!param3)
         {
            var param3:String = vvid;
         }
         var _loc4_:Array = ["dt=" + param1,"guid=" + this.puid];
         var _loc5_:Array = ["uid=" + String(this.getValue(DACCommon.UID,param3)),"s=" + this.$source,"v=" + String(this.getValue(DACCommon.VERSION,param3)),"n=" + String(this.getValue(DACCommon.MN,param3)),"pid=" + String(this.getValue(DACCommon.PID,param3)),"h=" + String(this.getValue(DACCommon.VH,param3)),"vid=" + String(this.getValue(DACCommon.VID,param3)),"cid=" + String(this.getValue(DACCommon.CID,param3)),"clid=" + String(this.getValue(DACCommon.CLD,param3)),"vvid=" + encodeURIComponent(param3),"isvip=" + String(this.getValue(DACCommon.ISVIP,param3)),"cv=" + String(this.getValue(DACCommon.CORE_VERSION,param3)),"pl=" + String(this.getValue(DACCommon.PL,param3))];
         if((param2) && param2.length > 0)
         {
            _loc5_ = _loc5_.concat(param2);
         }
         if(this.getValue(DACCommon.CTX,param3))
         {
            _loc5_ = _loc5_.concat(this.getCtx(this.getValue(DACCommon.CTX,param3)));
         }
         if(this.getValue(DACCommon.DCTX,param3))
         {
            _loc5_ = _loc5_.concat(this.getCtx(this.getValue(DACCommon.DCTX,param3)));
         }
         _loc5_.push("rnd=" + Math.random());
         if(param1 == "bfr")
         {
            this.clearVVID(param3);
            if(this.getValue(DACCommon.CID,param3))
            {
               PrintDebug.Trace("bfr报文发送前，cookie中bfr原始数据没有完全清除......");
               return;
            }
            PrintDebug.Trace("bfr原始数据已经获取到当前缓存中，cookie中bfr数据已经清除......");
         }
         PrintDebug.Trace("发送DAC统计  加密前： " + _loc4_.join("&") + "&" + _loc5_.join("&"));
         DACQueue.noQueue = ["bfr","pv"];
         DACQueue.sendLog(_loc4_,_loc5_);
         this.$dacItem[param1] = {
            "vvid":param3,
            "update":this.getValue("update",param3)
         };
      }
      
      private function send_online() : void
      {
         var _loc1_:Array = ["A=" + "0","B=" + this.puid];
         var _loc2_:Array = ["vvid=" + vvid,"C=" + String(this.getValue(DACCommon.CID)),"D=" + String(this.getValue(DACCommon.VID)),"E=" + "","F=" + "","G=" + new Date().valueOf(),"h=" + String(this.getValue(DACCommon.VH)),"v=" + String(this.getValue(DACCommon.VERSION)),"vt=" + int(this.getValue(DACCommon.VT)) * 1000];
         if(this.getValue(DACCommon.CTX))
         {
            _loc2_ = _loc2_.concat(this.getCtx(this.getValue(DACCommon.CTX)));
         }
         PrintDebug.Trace("发送online统计  加密前： " + _loc1_.join("&") + "&" + _loc2_.join("&"));
         DACQueue.sendLog(_loc1_,_loc2_);
      }
      
      public function sendError(param1:String, param2:String = "") : void
      {
         var _loc3_:Array = ["er=" + param1];
         if(param2 != "")
         {
            _loc3_ = _loc3_.concat(param2.split("&"));
         }
         this.sendDAC("er",_loc3_);
         this.tdsArr = [];
         this.tdsTime = 0;
         if(param1 == DACCommon.ERROR_BOOSTFAILED)
         {
            this.clearVVID(vvid,"er");
         }
      }
      
      public function sendAction(param1:String, param2:*) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         switch(param1)
         {
            case DACCommon.BFR:
               _loc3_ = this.$dso.getData(STATIC);
               for(_loc4_ in _loc3_)
               {
                  this.send_beha(_loc4_);
                  this.send_bfr(_loc4_);
               }
               this.initSession();
               break;
            case DACCommon.PV:
               this.send_pv();
               break;
            case DACCommon.ONLINE:
               this.send_online();
               break;
            case DACCommon.ADERR:
               this.send_aderr(param2);
               break;
            case DACCommon.BF:
            case DACCommon.DG:
            case DACCommon.VT:
               this.addValue(param1);
               break;
         }
      }
      
      private function send_beha(param1:String = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         try
         {
            if(!param1)
            {
               var param1:String = vvid;
            }
            _loc2_ = this.behaObjectProcess(this.getValue(DACCommon.BEHA,param1,true));
            if(_loc2_)
            {
               PrintDebug.Trace("发送行为统计 act=",_loc2_);
               _loc3_ = ["plt=ik","puid=" + this.puid,"act=" + _loc2_];
               _loc4_ = ["uid=" + String(this.getValue(DACCommon.UID,param1)),"vip=" + String(this.getValue(DACCommon.ISVIP,param1)),"ver=" + String(this.getValue(DACCommon.VERSION,param1)),"o=" + String(this.getValue(DACCommon.RCCID,param1)),"pid=" + String(this.getValue(DACCommon.PID,param1)),"vvid=" + encodeURIComponent(param1),"cid=" + String(this.getValue(DACCommon.CID,param1)),"rnd=" + Math.random()];
               DACQueue.sendLog(_loc3_,_loc4_);
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      private function behaObjectProcess(param1:* = null) : String
      {
         var _loc3_:* = 0;
         var _loc4_:* = undefined;
         var _loc2_:* = "";
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               for(_loc4_ in param1[_loc3_])
               {
                  if(_loc4_.toString() == "time")
                  {
                     param1[_loc3_][_loc4_] = Math.floor(new Date().getTime() / 1000) - Number(param1[_loc3_][_loc4_]);
                  }
                  _loc2_ = _loc2_ + (_loc4_.toString() + ":" + param1[_loc3_][_loc4_] + ",");
               }
               if(_loc2_.length > 1)
               {
                  _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
               }
               if(_loc2_.length > 0)
               {
                  _loc2_ = _loc2_ + ";";
               }
               _loc3_++;
            }
         }
         if(_loc2_.length == 0)
         {
            return null;
         }
         return _loc2_;
      }
      
      private function send_bfr(param1:String = null) : void
      {
         var _loc3_:Array = null;
         try
         {
            if((this.$dacItem["bfr"]) && this.$dacItem["bfr"]["vvid"] == param1)
            {
               PrintDebug.Trace("相同vvid的bfr报文不允许重复发送.......");
               return;
            }
         }
         catch(e:Error)
         {
         }
         var _loc2_:int = int(this.getValue(DACCommon.VT,param1)) * 1000;
         if(_loc2_ > 0)
         {
            _loc3_ = ["bf=" + int(this.getValue(DACCommon.BF,param1)),"bs=" + int(this.getValue(DACCommon.BS,param1)),"du=" + int(this.getValue(DACCommon.DU,param1)) * 1000,"dg=" + int(this.getValue(DACCommon.DG,param1)),"vt=" + _loc2_,"np=" + String(this.getValue(DACCommon.NP,param1)),"sr=" + String(this.getValue(DACCommon.SR,param1)),"ft=" + String(this.getValue(DACCommon.CFT,param1)),"bwtype=" + String(this.getValue(DACCommon.BWT,param1)),"now=" + String(this.getValue(DACCommon.NOW,param1)),"bit=" + String(this.getValue(DACCommon.BIT,param1)),"cs=" + Math.abs(this.getValue(DACCommon.CS,param1))];
            if(this.getValue(DACCommon.SBR,param1))
            {
               _loc3_ = _loc3_.concat(decodeURIComponent(String(this.getValue(DACCommon.SBR,param1))).split("&"));
            }
            this.sendDAC("bfr",_loc3_,param1);
         }
         else
         {
            this.clearVVID(param1);
         }
      }
      
      private function send_pv() : void
      {
         this.sendDAC("pv",["swfver=" + encodeURIComponent(Capabilities.version)]);
      }
      
      private function send_aderr(param1:String) : void
      {
         var _loc2_:Array = [];
         if(param1)
         {
            _loc2_ = param1.split("&");
         }
         this.sendDAC("aderr",_loc2_);
      }
      
      private function send_thirdvv(param1:Array) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            DACQueue.sendURL(param1[_loc2_].toString());
            _loc2_++;
         }
      }
      
      private function clearVVID(param1:String, param2:String = null) : void
      {
         PrintDebug.Trace("当前的vvid=" + vvid + ",清除vvid=" + param1);
         if(param1 == vvid && !(param2 == "er"))
         {
            return;
         }
         if(this.$dso.getData(STATIC)[param1])
         {
            PrintDebug.Trace("清除成功vvid=" + param1);
            delete this.$dso.getData(STATIC)[param1];
            true;
            this.$dso.flush();
         }
      }
   }
}

class Guid extends Object
{
   
   function Guid()
   {
      super();
   }
   
   public static function create() : String
   {
      var _loc1_:Array = [];
      _loc1_.push(getCharAt(8));
      var _loc2_:* = 0;
      while(_loc2_ < 3)
      {
         _loc1_.push(getCharAt(4));
         _loc2_++;
      }
      var _loc3_:Number = new Date().getTime();
      _loc1_.push(("0000000" + _loc3_.toString(16)).substr(-8) + getCharAt(4));
      return _loc1_.join("-");
   }
   
   private static function getCharAt(param1:int) : String
   {
      var _loc2_:* = "";
      var _loc3_:* = "0123456789abcdef";
      var _loc4_:* = 0;
      while(_loc4_ < param1)
      {
         _loc2_ = _loc2_ + _loc3_.charAt(Math.random() * (_loc3_.length - 1) >> 0);
         _loc4_++;
      }
      return _loc2_;
   }
}
