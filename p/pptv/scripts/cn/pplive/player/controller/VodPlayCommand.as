package cn.pplive.player.controller
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import cn.pplive.player.view.source.DtListItem;
   import cn.pplive.player.common.*;
   import cn.pplive.player.dac.*;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.view.source.DragListItem;
   import cn.pplive.player.view.source.StreamListItem;
   import cn.pplive.player.utils.PrintDebug;
   import flash.system.Capabilities;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import cn.pplive.player.utils.CommonUtils;
   import cn.pplive.player.utils.hash.Global;
   
   public class VodPlayCommand extends SimpleFabricationCommand
   {
      
      private var $xml:XML;
      
      private var $limit:Number;
      
      private var $cft:Number;
      
      private var len:int = 4;
      
      public function VodPlayCommand()
      {
         super();
      }
      
      private function getDtList(param1:XMLList) : Vector.<DtListItem>
      {
         var _loc2_:Vector.<DtListItem> = new Vector.<DtListItem>(this.len);
         var _loc3_:* = 0;
         while(_loc3_ < param1.length())
         {
            if(Number(param1[_loc3_]["@ft"]) < _loc2_.length)
            {
               _loc2_[Number(param1[_loc3_]["@ft"])] = new DtListItem(Number(param1[_loc3_]["@ft"]),param1[_loc3_].hasOwnProperty("bh")?[].concat(param1[_loc3_]["sh"]).concat(param1[_loc3_]["bh"].split("@")):[].concat(param1[_loc3_]["sh"]),Date.parse(param1[_loc3_]["st"]),param1[_loc3_]["id"],Number(param1[_loc3_]["bwt"]),param1[_loc3_]["key"]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getDragList(param1:XMLList) : Vector.<DragListItem>
      {
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc2_:Vector.<DragListItem> = new Vector.<DragListItem>(this.len);
         var _loc3_:* = 0;
         while(_loc3_ < param1.length())
         {
            if(Number(param1[_loc3_]["@ft"]) < _loc2_.length)
            {
               _loc4_ = [];
               _loc5_ = 0;
               while(_loc5_ < param1[_loc3_]["sgm"].length())
               {
                  _loc4_.push({
                     "no":String(param1[_loc3_]["sgm"][_loc5_]["@no"]),
                     "headlength":Number(param1[_loc3_]["sgm"][_loc5_]["@hl"]),
                     "duration":Number(param1[_loc3_]["sgm"][_loc5_]["@dur"]),
                     "filesize":Number(param1[_loc3_]["sgm"][_loc5_]["@fs"]),
                     "offset":Number(param1[_loc3_]["sgm"][_loc5_]["@os"])
                  });
                  _loc5_++;
               }
               _loc2_[Number(param1[_loc3_]["@ft"])] = new DragListItem(Number(param1[_loc3_]["@br"]),Number(param1[_loc3_]["@fs"]),Number(param1[_loc3_]["@du"]),Number(param1[_loc3_]["@vw"]),Number(param1[_loc3_]["@vh"]),Number(param1[_loc3_]["@ft"]),_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getVodStream(param1:XMLList, param2:Vector.<DtListItem>, param3:Vector.<DragListItem>) : Vector.<StreamListItem>
      {
         var _loc4_:Vector.<StreamListItem> = new Vector.<StreamListItem>(this.len);
         var _loc5_:* = 0;
         while(_loc5_ < param1.length())
         {
            if((Number(param1[_loc5_]["@ft"]) < _loc4_.length) && (param2[Number(param1[_loc5_]["@ft"])]) && (param3[Number(param1[_loc5_]["@ft"])]))
            {
               if(isNaN(this.$cft))
               {
                  this.$cft = Number(param1[_loc5_]["@ft"]);
               }
               _loc4_[Number(param1[_loc5_]["@ft"])] = new StreamListItem(String(param1[_loc5_]["@rid"]),Number(param1[_loc5_]["@bitrate"]),Number(param1[_loc5_]["@width"]),Number(param1[_loc5_]["@height"]),Number(param1[_loc5_]["@ft"]),String(param1[_loc5_]["@vip"]),param2[Number(param1[_loc5_]["@ft"])],param3[Number(param1[_loc5_]["@ft"])]);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function getLiveStream(param1:XMLList) : Vector.<StreamListItem>
      {
         var _loc2_:Vector.<StreamListItem> = new Vector.<StreamListItem>(3);
         var _loc3_:* = 0;
         while(_loc3_ < param1.length())
         {
            if(Number(param1[_loc3_]["@ft"]) < _loc2_.length)
            {
               if(isNaN(this.$cft))
               {
                  this.$cft = Number(param1[_loc3_]["@ft"]);
               }
               _loc2_[Number(param1[_loc3_]["@ft"])] = new StreamListItem(String(param1[_loc3_]["@rid"]),Number(param1[_loc3_]["@bitrate"]),Number(param1[_loc3_]["@width"]),Number(param1[_loc3_]["@height"]),Number(param1[_loc3_]["@ft"]),String(param1[_loc3_]["@vip"]));
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function checklimit(param1:int) : Boolean
      {
         PrintDebug.Trace("当前选择 ft:" + param1,"  启动插件播放所需 ft:" + this.$cft,"  操作系统 : " + Capabilities.os);
         if(this.$xml["bc"])
         {
            if(param1 >= this.$cft && this.$limit == 0)
            {
               if(Capabilities.os.toLocaleLowerCase().indexOf("mac") == -1)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      private function checkMaxPlayIndex(param1:int) : Number
      {
         if(this.$xml["bc"])
         {
            if(param1 >= this.$cft)
            {
               if(Capabilities.os.toLocaleLowerCase().indexOf("mac") == -1)
               {
                  return this.$limit;
               }
            }
         }
         return 9999;
      }
      
      private function checkFtVip(param1:int) : Boolean
      {
         return !VIPPrivilege.isVip && !(VodPlay.streamVec[param1].vip == "0");
      }
      
      private function getStreamIndex(param1:Vector.<StreamListItem>) : int
      {
         var $streamIndex:int = 0;
         var changeIndex:Function = null;
         var vec:Vector.<StreamListItem> = param1;
         var $tempVec:Vector.<StreamListItem> = new Vector.<StreamListItem>();
         var i:int = 0;
         while(i < vec.length)
         {
            if(vec[i])
            {
               $tempVec.push(vec[i]);
            }
            i++;
         }
         if($tempVec.length == 1)
         {
            return $tempVec[0].ft;
         }
         $streamIndex = VodCommon.cookie.contains("ft")?VodCommon.cookie.getData("ft"):VodPlay.cft;
         if(!vec[$streamIndex])
         {
            i = 0;
            while(i < vec.length)
            {
               if(vec[i])
               {
                  $streamIndex = i;
                  break;
               }
               i++;
            }
         }
         changeIndex = function():void
         {
            var _loc1_:* = 0;
            if(!checklimit($streamIndex) || (checkFtVip($streamIndex)))
            {
               if($streamIndex > 0)
               {
                  _loc1_ = $streamIndex;
                  _loc1_--;
                  if(vec[_loc1_])
                  {
                     $streamIndex--;
                     changeIndex();
                  }
               }
            }
         };
         changeIndex();
         return $streamIndex;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:* = 0;
         var _loc7_:XMLList = null;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:XMLList = null;
         var _loc12_:Array = null;
         this.$xml = param1.getBody() as XML;
         if((this.$xml.hasOwnProperty("error")) && !(this.$xml["error"]["@code"] == "0"))
         {
            _loc2_ = {};
            VodPlay.fd = 0;
            VodPlay.isFd = false;
            _loc3_ = VodCommon.playErrorText;
            if(this.$xml["error"]["@code"] == "1")
            {
               _loc2_["code"] = VodCommon.callCode["play"][8];
               _loc2_["error"] = _loc3_.replace(new RegExp("%code%","g"),_loc2_["code"]);
               sendNotification(VodNotification.VOD_PLAY_FAILED,_loc2_);
               return;
            }
            if(this.$xml["error"]["@code"] == "2")
            {
               _loc2_["code"] = VodCommon.callCode["play"][6];
               _loc2_["error"] = _loc3_.replace(new RegExp("%code%","g"),_loc2_["code"]);
               sendNotification(VodNotification.VOD_PLAY_FAILED,_loc2_);
               return;
            }
            if(this.$xml["error"]["@code"] == "3" && !(this.$xml["error"]["@pay"] == "1"))
            {
               VodPlay.fd = Number(this.$xml["channel"]["@fd"]);
               if(ViewManager.getInstance().getMediator("skin"))
               {
                  if(VodPlay.fd > 0)
                  {
                     VodPlay.isFd = true;
                     PrintDebug.Trace("节目进入免费试看阶段，需付费观看完整版 ......");
                     ViewManager.getInstance().getMediator("skin").setTips({
                        "html":CommonUtils.getHtml(VodCommon.playPayFreeText.replace(new RegExp("\\[CID\\]","g"),VodParser.cid),"#ffffff"),
                        "times":"1",
                        "display":VodPlay.fd * 1000
                     });
                  }
                  else
                  {
                     ViewManager.getInstance().getMediator("skin").setTips({
                        "html":CommonUtils.getHtml(VodCommon.playPayNoFreeText.replace(new RegExp("\\[CID\\]","g"),VodParser.cid),"#ffffff"),
                        "times":"0",
                        "display":60 * 1000
                     });
                     return;
                  }
               }
            }
         }
         VodPlay.xml = this.$xml;
         VodPlay.rid = this.$xml["channel"]["@rid"];
         VodPlay.id = VodParser.cid = this.$xml["channel"]["@id"];
         VodPlay.cl = this.$xml["channel"]["@cl"];
         VodPlay.nm = this.$xml["channel"]["@nm"];
         VodPlay.lk = this.$xml["channel"]["@lk"];
         VodPlay.vt = this.$xml["channel"]["@vt"];
         VodPlay.olt = Number(this.$xml["channel"]["@olt"]);
         VodPlay.ts = Number(this.$xml["channel"]["@ts"]);
         VodPlay.duration = Number(this.$xml["channel"]["@dur"]);
         VodPlay.shareDisable = false;
         if(this.$xml.hasOwnProperty("itemList"))
         {
            _loc4_ = this.$xml.itemList.children();
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_["@id"] == "121" && _loc5_["@intValue"] == "1")
               {
                  VodPlay.shareDisable = true;
               }
            }
         }
         sendNotification(VodNotification.VOD_SHAREDISABLE,VodPlay.shareDisable);
         VodCommon.snapshotVersion = Number(this.$xml["channel"]["@mv"]);
         if(this.$xml["channel"].hasOwnProperty("barrage"))
         {
            VodPlay.barrage = {"display":(this.$xml["channel"]["barrage"].hasOwnProperty("@default_display")?CommonUtils.bool(this.$xml["channel"]["barrage"]["@default_display"].toString()):false)};
         }
         if(this.$xml["channel"].hasOwnProperty("@draghost"))
         {
            VodPlay.draghost = String(this.$xml["channel"]["@draghost"]);
         }
         try
         {
            VodPlay.markObj = {
               "align":this.$xml["logo"]["@align"],
               "ax":Number(this.$xml["logo"]["@ax"]),
               "ay":Number(this.$xml["logo"]["@ay"]),
               "aw":Number(this.$xml["logo"]["@width"])
            };
            _loc6_ = 0;
            while(_loc6_ < this.$xml["logo"].child("url").length())
            {
               if(this.$xml["logo"].child("url")[_loc6_]["@ext"] == "swf")
               {
                  VodPlay.markObj["url"] = String(this.$xml["logo"].child("url")[_loc6_]);
                  break;
               }
               if(this.$xml["logo"].hasOwnProperty("@diaphaneity"))
               {
                  VodPlay.markObj["diaphaneity"] = Number(Number(this.$xml["logo"]["@diaphaneity"]));
               }
               _loc6_++;
            }
         }
         catch(evt:Error)
         {
         }
         if(this.$xml.hasOwnProperty("img"))
         {
            VodCommon.row = Number(this.$xml["img"]["@r"]);
            VodCommon.column = Number(this.$xml["img"]["@c"]);
            VodCommon.snapshotHeight = Number(this.$xml["img"]["@h"]);
            if(this.$xml["img"].hasOwnProperty("@i"))
            {
               VodPlay.interval = Number(this.$xml["img"]["@i"]);
            }
         }
         else
         {
            VodCommon.row = NaN;
            VodCommon.column = NaN;
         }
         if(VodPlay.vt == "3")
         {
            VodPlay.cft = Number(this.$xml["channel"]["file"]["@cur"]);
            if(!(this.$xml["dt"].length() == 0) && !(this.$xml["dragdata"].length() == 0))
            {
               Global.getInstance()["playmodel"] = "vod";
               PrintDebug.Trace("play返回当前为 点播模式 ......");
               VodPlay.streamVec = this.getVodStream(this.$xml["channel"]["file"].children() as XMLList,this.getDtList(this.$xml["dt"]),this.getDragList(this.$xml["dragdata"]));
               if((this.$xml["channel"].hasOwnProperty("point")) && this.$xml["channel"]["point"].children().length() > 0)
               {
                  VodPlay.contentPoint = [];
                  VodPlay.adverPoint = [];
                  VodPlay.smartItem = [];
                  _loc7_ = this.$xml["channel"]["point"].children() as XMLList;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length())
                  {
                     _loc9_ = _loc7_[_loc8_]["@type"];
                     _loc10_ = {
                        "type":_loc7_[_loc8_]["@type"].toString(),
                        "time":Number(_loc7_[_loc8_]["@time"])
                     };
                     if(_loc10_["type"] == "1" || _loc10_["type"] == "2" || _loc10_["type"] == "5")
                     {
                        if(_loc10_["type"] == "1")
                        {
                           _loc10_["title"] = "片头";
                        }
                        else if(_loc10_["type"] == "2")
                        {
                           _loc10_["title"] = "片尾";
                        }
                        else
                        {
                           _loc10_["title"] = _loc7_[_loc8_]["@title"].toString();
                        }
                        
                        VodPlay.contentPoint.push(_loc10_);
                     }
                     if(_loc7_[_loc8_]["@type"] == "8")
                     {
                        VodPlay.adverPoint.push(_loc10_["time"]);
                        _loc11_ = _loc7_[_loc8_].children() as XMLList;
                        _loc6_ = 0;
                        while(_loc6_ < _loc11_.length())
                        {
                           VodPlay.smartItem.push({
                              "title":_loc11_[_loc6_]["@title"].toString(),
                              "duration":Number(_loc11_[_loc6_]["@duration"]),
                              "tl":_loc11_[_loc6_]["@tl"],
                              "br":_loc11_[_loc6_]["@br"],
                              "tagid":_loc11_[_loc6_]["@tagid"],
                              "time":_loc10_["time"]
                           });
                           _loc6_++;
                        }
                     }
                     _loc8_++;
                  }
               }
               this.$limit = 9999;
               VodPlay.bwt = Number(this.$xml["dt"][0]["bwt"] || this.$xml["bc"]["bwt"]);
               VodPlay.st = this.$xml["dt"][0]["st"];
               VodPlay.serverTime = Date.parse(VodPlay.st);
               VodPlay.start = VodPlay.serverTime / 1000 >> 0;
            }
            else
            {
               ViewManager.getInstance().getProxy("play").check("_dterror_");
               return;
            }
         }
         else if(VodPlay.vt == "5")
         {
            VodPlay.cft = Number(this.$xml["channel"]["stream"]["@cft"]);
            VodPlay.interval = Number(this.$xml["channel"]["stream"]["@interval"]);
            VodPlay.delay = Number(this.$xml["channel"]["stream"]["@delay"]);
            VodParser.stime = Number(this.$xml["channel"]["live"]["@start"]);
            VodParser.etime = Number(this.$xml["channel"]["live"]["@end"]);
            VodPlay.duration = VodParser.etime - VodParser.stime;
            if(this.$xml.hasOwnProperty("dt"))
            {
               Global.getInstance()["playmodel"] = "live";
               PrintDebug.Trace("play返回当前为 伪点播模式 ......");
               VodPlay.bwt = this.$xml["dt"]["bwt"];
               VodPlay.st = this.$xml["dt"]["st"];
               VodPlay.key = this.$xml["dt"]["key"];
               VodPlay.addr = this.$xml["dt"]["bh"]?[].concat(this.$xml["dt"]["sh"]).concat(this.$xml["dt"]["bh"].split("@")):this.$xml["dt"]["sh"];
               VodPlay.streamVec = this.getLiveStream(this.$xml["channel"]["stream"].children() as XMLList);
               this.$limit = 1;
               VodPlay.serverTime = Date.parse(VodPlay.st) / 1000 - VodPlay.delay >> 0;
               VodPlay.serverTime = VodPlay.serverTime - VodPlay.serverTime % VodPlay.interval;
               VodPlay.start = VodPlay.serverTime;
               VodPlay.localTime = Math.floor(new Date().valueOf() / 1000);
               VodPlay.posi = VodParser.stime;
            }
            else
            {
               ViewManager.getInstance().getProxy("play").check("_dterror_");
               return;
            }
         }
         else
         {
            ViewManager.getInstance().getProxy("play").check("_dterror_");
            return;
         }
         
         sendNotification(DACNotification.SET_VALUE,VodPlay.nm,DACCommon.MN);
         sendNotification(DACNotification.SET_VALUE,VodPlay.bwt,DACCommon.BWT);
         try
         {
            _loc12_ = String(this.$xml["bc"]["wp"]).split(".") as Array;
            this.$cft = Number(_loc12_[0]);
            this.$limit = Number(_loc12_[1]);
         }
         catch(e:Error)
         {
         }
         Global.getInstance()["checklimit"] = this.checklimit;
         Global.getInstance()["checkMaxPlayIndex"] = this.checkMaxPlayIndex;
         Global.getInstance()["getStreamIndex"] = this.getStreamIndex;
         Global.getInstance()["startUpStream"] = this.startUpStream;
         PrintDebug.Trace("play服务请求返回数据成功......");
         if(VodPlay.olt - VodPlay.ts > 0)
         {
            sendNotification(VodNotification.VOD_COUNTDOWN,{"time":VodPlay.olt - VodPlay.ts});
         }
         else
         {
            this.startUpStream(Global.getInstance()["playmodel"]);
         }
      }
      
      private function startUpStream(param1:String) : void
      {
         if(param1 == "vod")
         {
            VodPlay.streamIndex = this.getStreamIndex(VodPlay.streamVec);
            PrintDebug.Trace("准备播放执行码流 ===>>>  ",VodPlay.streamIndex);
            if(!VIPPrivilege.isVip && !(VodPlay.streamVec[VodPlay.streamIndex].vip == "0") && !VodCommon.smart)
            {
               sendNotification(VodNotification.VOD_VIP_PLAY);
               return;
            }
            sendNotification(DACNotification.SET_VALUE,VodPlay.streamIndex,DACCommon.CFT);
            sendNotification(DACNotification.SET_VALUE,VodPlay.streamVec[VodPlay.streamIndex].bitrate,DACCommon.BIT);
            sendNotification(VodNotification.VOD_DATA_REQUEST);
            VodCommon.cookie.setData("ft",VodPlay.streamIndex);
         }
         else if(param1 == "live")
         {
            PrintDebug.Trace("当前为伪点播，再次加载直播内核......");
            ViewManager.getInstance().getProxy("kernel").initData();
         }
         
      }
   }
}
