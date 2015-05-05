package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.common.VodPlay;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.common.VodNotification;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.manager.PreviewSnapshotManager;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import flash.display.Bitmap;
   import cn.pplive.player.manager.DrawBmpManager;
   import flash.geom.Rectangle;
   
   public class VodPreSnapshotProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_presnapshot_proxy";
      
      private var $posi:Number;
      
      public function VodPreSnapshotProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      private function check(param1:Number, param2:Number) : Object
      {
         var _loc4_:* = NaN;
         if((isNaN(VodCommon.row)) && (isNaN(VodCommon.column)))
         {
            return null;
         }
         var _loc3_:Number = 0;
         if(Global.getInstance()["playmodel"] == "live")
         {
            _loc3_ = Math.floor(param1 / (VodPlay.interval * param2 * VodCommon.column)) * VodPlay.interval * param2 * VodCommon.column;
            _loc4_ = _loc3_ + VodPlay.interval * param2 * VodCommon.column;
            if(_loc4_ <= VodPlay.start)
            {
               return {
                  "interval":VodPlay.interval,
                  "column":VodCommon.column,
                  "row":param2,
                  "beg":_loc3_,
                  "end":_loc4_,
                  "posi":param1,
                  "height":VodCommon.snapshotHeight / VodCommon.row * param2
               };
            }
            return param2 != 1?this.check(param1,1):null;
         }
         if(Global.getInstance()["playmodel"] == "vod")
         {
            _loc3_ = Math.floor(param1 / (VodPlay.interval * param2 * VodCommon.column));
            return {
               "interval":VodPlay.interval,
               "column":VodCommon.column,
               "row":param2,
               "beg":_loc3_,
               "end":VodPlay.duration,
               "posi":param1,
               "height":VodCommon.snapshotHeight / VodCommon.row * param2
            };
         }
         return null;
      }
      
      public function initData(param1:Number) : void
      {
         var _loc2_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:* = NaN;
         this.$posi = param1;
         var _loc3_:Object = this.check(this.$posi,VodCommon.row);
         if(Global.getInstance()["playmodel"] == "live")
         {
            if(!_loc3_)
            {
               PrintDebug.Trace("预览截图暂未生成，请求取消 ===>>>");
               sendNotification(VodNotification.VOD_PREVIEW_SNAPSHOT,{"posi":this.$posi});
               return;
            }
            if(VodCommon.preSnapshot)
            {
               for each(_loc4_ in VodCommon.preSnapshot)
               {
                  if(this.$posi >= _loc4_["snapshot"]["beg"] && this.$posi <= _loc4_["snapshot"]["end"])
                  {
                     this.getSnapshot(_loc4_["content"],_loc4_["snapshot"],_loc4_["snapshot"]["row"]);
                     return;
                  }
               }
            }
            _loc2_ = "http://live.panoimage.pptv.com/pano/" + VodCommon.currRid;
         }
         else if(Global.getInstance()["playmodel"] == "vod")
         {
            if(VodCommon.preSnapshot)
            {
               for each(_loc4_ in VodCommon.preSnapshot)
               {
                  _loc5_ = _loc4_["snapshot"]["interval"] * _loc4_["snapshot"]["row"] * _loc4_["snapshot"]["column"];
                  if(this.$posi >= _loc4_["snapshot"]["beg"] * _loc5_ && this.$posi < (_loc4_["snapshot"]["beg"] + 1) * _loc5_)
                  {
                     this.getSnapshot(_loc4_["content"],_loc4_["snapshot"],_loc4_["snapshot"]["row"]);
                     return;
                  }
               }
            }
            _loc2_ = "http://panoimage.pptv.com/" + VodCommon.snapshotVersion + "/" + VodParser.cid;
         }
         
         sendNotification(VodNotification.VOD_PREVIEW_SNAPSHOT,{"posi":this.$posi});
         _loc2_ = _loc2_ + ("_" + _loc3_["interval"]);
         _loc2_ = _loc2_ + ("_" + _loc3_["column"]);
         _loc2_ = _loc2_ + ("x" + _loc3_["row"]);
         _loc2_ = _loc2_ + ("_" + _loc3_["beg"]);
         _loc2_ = _loc2_ + ("_" + _loc3_["height"] + ".jpg");
         PreviewSnapshotManager.getInstance().loadData(_loc2_,_loc3_);
         PreviewSnapshotManager.getInstance().addEventListener(PreviewSnapshotManager.PREVIEW_SNAPSHOT,this.onPreviewSnapshotHandler);
      }
      
      private function onPreviewSnapshotHandler(param1:Event) : void
      {
         try
         {
            if(!VodCommon.preSnapshot)
            {
               VodCommon.preSnapshot = new Vector.<Object>();
            }
            VodCommon.preSnapshot.push(param1.target.dataObj);
            this.getSnapshot(param1.target.dataObj["content"],param1.target.dataObj["snapshot"],param1.target.dataObj["snapshot"]["row"]);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function getSnapshot(param1:DisplayObject, param2:Object, param3:Number) : void
      {
         var _loc4_:* = 0;
         if(Global.getInstance()["playmodel"] == "live")
         {
            _loc4_ = Math.floor((this.$posi - param2["beg"]) / param2["interval"]);
         }
         else if(Global.getInstance()["playmodel"] == "vod")
         {
            _loc4_ = Math.floor((this.$posi - param2["interval"] * param2["row"] * param2["column"] * param2["beg"]) / param2["interval"]);
         }
         
         if(_loc4_ < 0 || _loc4_ > param2["column"] * param3 - 1)
         {
            return;
         }
         var _loc5_:Bitmap = new Bitmap(DrawBmpManager.draw(param1,new Rectangle(_loc4_ % param2["column"] * param1.width / param2["column"],Math.floor(_loc4_ / param2["column"]) * param1.height / param3,param1.width / param2["column"] >> 0,param1.height / param3 >> 0)),"auto",true);
         sendNotification(VodNotification.VOD_PREVIEW_SNAPSHOT,{
            "bmp":_loc5_,
            "posi":this.$posi
         });
      }
      
      public function disposed(param1:Boolean, param2:Number = NaN) : void
      {
         var _loc3_:* = undefined;
         if(VodCommon.preSnapshot)
         {
            if(param1)
            {
               VodCommon.preSnapshot = null;
               PreviewSnapshotManager.getInstance().dispose();
            }
            else
            {
               if(isNaN(param2))
               {
                  return;
               }
               for each(_loc3_ in VodCommon.preSnapshot)
               {
                  if(_loc3_["snapshot"]["end"] < param2)
                  {
                     VodCommon.preSnapshot.splice(VodCommon.preSnapshot.indexOf(_loc3_),1);
                     break;
                  }
               }
            }
         }
      }
   }
}
