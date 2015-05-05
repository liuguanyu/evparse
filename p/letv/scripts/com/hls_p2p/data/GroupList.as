package com.hls_p2p.data
{
   import com.hls_p2p.dataManager.DataManager;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.p2p.utils.ParseUrl;
   import com.hls_p2p.data.vo.Clip;
   import com.p2p.utils.console;
   
   public class GroupList extends Object
   {
      
      public var isDebug:Boolean = true;
      
      private var _groupList:Object;
      
      private var var_97:DataManager;
      
      public var name_3:Number = 0;
      
      public var var_98:DataManager = null;
      
      private var var_99:class_3;
      
      public function GroupList(param1:DataManager)
      {
         super();
         this.var_98 = param1;
         this.init();
      }
      
      public function get name_2() : Array
      {
         if(this._groupList[LiveVodConfig.currentVid])
         {
            return (this._groupList[LiveVodConfig.currentVid] as class_3).name_2;
         }
         return null;
      }
      
      private function init() : void
      {
         this._groupList = new Object();
      }
      
      private function method_145(param1:String) : String
      {
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            return param1;
         }
         return LiveVodConfig.currentVid;
      }
      
      public function getTNRange(param1:String) : Array
      {
         var _loc2_:String = this.method_145(param1);
         if((this._groupList) && (this._groupList.hasOwnProperty(_loc2_)))
         {
            return (this._groupList[_loc2_] as class_3).getTNRange(param1);
         }
         return null;
      }
      
      public function getPNRange(param1:String) : Array
      {
         var _loc2_:String = this.method_145(param1);
         if((this._groupList) && (this._groupList.hasOwnProperty(_loc2_)))
         {
            return (this._groupList[_loc2_] as class_3).getPNRange(param1);
         }
         return null;
      }
      
      public function method_134(param1:Piece) : void
      {
         var _loc2_:String = this.method_145(param1.groupID);
         if(this._groupList.hasOwnProperty(_loc2_))
         {
            (this._groupList[_loc2_] as class_3).method_134(param1);
         }
      }
      
      public function method_14(param1:String) : Number
      {
         if(this._groupList[param1])
         {
            return (this._groupList[param1] as class_3).var_95;
         }
         return -1;
      }
      
      public function method_16(param1:String) : String
      {
         var _loc2_:String = null;
         for(_loc2_ in this._groupList)
         {
            if((this._groupList[_loc2_] as class_3).playerKbps == param1)
            {
               return _loc2_;
            }
         }
         return "null";
      }
      
      public function method_11(param1:Array, param2:String) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         if(this._groupList[param2])
         {
            _loc3_ = new Array();
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc3_.push(param1[_loc5_]["location"]);
               _loc4_.push(param1[_loc5_]["playlevel"]);
               _loc5_++;
            }
            if(_loc3_.length > 0 && _loc4_.length > 0)
            {
               this._groupList[param2].flvURL = null;
               this._groupList[param2].playLevelArr = null;
               this._groupList[param2].flvURL = _loc3_.concat();
               this._groupList[param2].playLevelArr = _loc4_.concat();
               return true;
            }
         }
         return false;
      }
      
      public function method_8(param1:String) : String
      {
         if((this._groupList.hasOwnProperty(param1)) && (this._groupList[param1].flvURL) && this._groupList[param1].flvURL.length >= 1)
         {
            return ParseUrl.getParam(this._groupList[param1].flvURL[0],"uuid");
         }
         return "";
      }
      
      public function method_133(param1:Clip, param2:Number = 0, param3:Array = null, param4:Array = null) : Boolean
      {
         var var_294:String = null;
         var var_295:Object = null;
         var var_293:Clip = param1;
         var kbps:Number = param2;
         var flvURL:Array = param3;
         var playLevelArr:Array = param4;
         var_294 = this.method_145(var_293.groupID);
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            var_294 = LiveVodConfig.currentVid;
         }
         if(!this._groupList.hasOwnProperty(var_294))
         {
            this._groupList[var_294] = new class_3(this.var_98,this);
            this._groupList[var_294].createTime = this.getTime();
            this._groupList[var_294].groupID = var_293.groupID;
            if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
            {
               this._groupList[var_294].playerKbps = var_293.playerKbps;
               this._groupList[var_294].flvURL = flvURL.concat();
               this._groupList[var_294].playLevelArr = playLevelArr.concat();
            }
            if(LiveVodConfig.IS_DRM)
            {
               var_295 = this.var_98.method_9();
               if(var_295)
               {
                  this._groupList[var_294].drm = var_295;
                  this._groupList[var_294].drm.initDrm(var_293.var_2,function():void
                  {
                     _groupList[var_294].drmOk = true;
                  },function(param1:String = null):void
                  {
                     LiveVodConfig.var_269 = true;
                  });
               }
            }
         }
         else if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            this._groupList[var_294].createTime = this.getTime();
            if((this._groupList[var_294].memoryTime == 0) && (kbps) && kbps > 0)
            {
               this._groupList[var_294].setMemoryTime(kbps);
            }
         }
         
         return (this._groupList[var_294] as class_3).method_133(var_293);
      }
      
      public function method_22(param1:String, param2:Number) : Number
      {
         var _loc3_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc3_))
         {
            return (this._groupList[_loc3_] as class_3).method_22(param2);
         }
         if(false == LiveVodConfig.IS_CHANGE_KBPS)
         {
            return -2;
         }
         return -1;
      }
      
      public function method_138(param1:String, param2:Number) : Number
      {
         var _loc3_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc3_))
         {
            return (this._groupList[_loc3_] as class_3).method_138(param2);
         }
         if(false == LiveVodConfig.IS_CHANGE_KBPS)
         {
            return -2;
         }
         return -1;
      }
      
      public function method_5(param1:Object) : Piece
      {
         var _loc2_:String = null;
         if((param1) && (param1.hasOwnProperty("groupID")))
         {
            _loc2_ = this.method_145(param1["groupID"]);
            if(this._groupList.hasOwnProperty(_loc2_))
            {
               return (this._groupList[_loc2_] as class_3).method_5(param1);
            }
         }
         return null;
      }
      
      public function method_24(param1:String, param2:Number) : class_1
      {
         var _loc3_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc3_))
         {
            return (this._groupList[_loc3_] as class_3).method_24(param2);
         }
         return null;
      }
      
      public function method_140(param1:String) : class_1
      {
         var _loc2_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc2_))
         {
            return (this._groupList[_loc2_] as class_3).method_140();
         }
         return null;
      }
      
      public function method_32(param1:String) : Object
      {
         var _loc2_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc2_))
         {
            return (this._groupList[_loc2_] as class_3).method_129;
         }
         return null;
      }
      
      public function method_33(param1:String) : Object
      {
         var _loc2_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc2_))
         {
            return this._groupList[_loc2_] as class_3;
         }
         return null;
      }
      
      public function method_34(param1:String) : Array
      {
         var _loc2_:String = this.method_145(param1);
         if(this._groupList.hasOwnProperty(_loc2_))
         {
            return (this._groupList[_loc2_] as class_3).var_91;
         }
         return null;
      }
      
      public function method_17() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._groupList)
         {
            _loc1_ = _loc1_.concat((this._groupList[_loc2_] as class_3).method_17());
         }
         return _loc1_;
      }
      
      public function method_146() : String
      {
         var _loc3_:String = null;
         var _loc1_:* = "";
         var _loc2_:Array = new Array();
         for(_loc3_ in this._groupList)
         {
            if(!(_loc3_ == LiveVodConfig.currentVid) && !(_loc3_ == LiveVodConfig.nextVid))
            {
               _loc2_.push({
                  "createTime":(this._groupList[_loc3_] as class_3).createTime,
                  "groupId":_loc3_
               });
            }
         }
         if(_loc2_.length >= 1)
         {
            _loc2_.sortOn("createTime",16);
            return _loc2_[0]["groupId"];
         }
         return _loc1_;
      }
      
      public function method_142() : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(LiveVodConfig.BlockID < 0)
         {
            return;
         }
         var _loc1_:* = "";
         if(this.name_3 >= LiveVodConfig.method_262 + 1024 * 1024)
         {
            console.log(this,this.name_3 + " > " + (LiveVodConfig.method_262 + 1024 * 1024));
            _loc1_ = this.method_146();
            if(!("" == _loc1_) && !(_loc1_ == LiveVodConfig.currentVid))
            {
               (this._groupList[_loc1_] as class_3).method_142("left");
               if(this.name_3 < LiveVodConfig.method_262)
               {
                  return;
               }
            }
            (this._groupList[LiveVodConfig.currentVid] as class_3).method_142("left");
            if(this.name_3 >= LiveVodConfig.method_262 && !("" == LiveVodConfig.nextVid) && (this._groupList.hasOwnProperty(LiveVodConfig.nextVid)) && (this._groupList[LiveVodConfig.nextVid] as class_3).name_3 > 0)
            {
               (this._groupList[LiveVodConfig.nextVid] as class_3).method_142("right");
            }
            if(this.name_3 >= LiveVodConfig.method_262)
            {
               (this._groupList[LiveVodConfig.currentVid] as class_3).method_142("right");
            }
         }
         var _loc2_:int = this.method_17().length;
         var _loc3_:int = LiveVodConfig.const_6;
         if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && _loc2_ > _loc3_)
         {
            _loc4_ = _loc2_ - _loc3_;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc1_ = this.method_146();
               if(!("" == _loc1_) && (!(LiveVodConfig.nextVid == _loc1_) || !(LiveVodConfig.currentVid == _loc1_)))
               {
                  this.method_147(_loc1_);
               }
               _loc5_++;
            }
         }
      }
      
      public function method_147(param1:String) : void
      {
         if(!this._groupList.hasOwnProperty(param1))
         {
            console.log(this,"groupList delete BlockList error!!!");
            trace(this,"groupList delete BlockList error!!! " + param1);
            return;
         }
         this._groupList[param1].clear();
         this._groupList[param1] = null;
         delete this._groupList[param1];
         true;
         trace(this,"deleteBlockList " + param1);
      }
      
      public function method_41(param1:String) : Number
      {
         var _loc2_:String = this.method_145(param1);
         if(!this._groupList.hasOwnProperty(_loc2_))
         {
            console.log(this,"groupList getMemoryTimeByGid BlockList error!!!");
            return 0;
         }
         return (this._groupList[_loc2_] as class_3).memoryTime;
      }
      
      public function method_15(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for(_loc2_ in this._groupList)
         {
            if(_loc2_ == param1)
            {
               (this._groupList[_loc2_] as class_3).clear();
               delete this._groupList[_loc2_];
               true;
               trace(this,"clearGroup " + _loc2_ + " = true");
               console.log(this,"delete " + _loc2_ + " = true");
               return true;
            }
         }
         trace(this,"clearGroup " + _loc2_ + " = true");
         console.log(this,"clearGroup " + _loc2_ + " = false");
         return false;
      }
      
      public function clear() : void
      {
         var _loc1_:String = null;
         console.log(this,"clear");
         for(_loc1_ in this._groupList)
         {
            this._groupList[_loc1_].clear();
         }
         this._groupList = null;
         this.var_97 = null;
         this.name_3 = 0;
         this.var_99 = null;
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
   }
}
