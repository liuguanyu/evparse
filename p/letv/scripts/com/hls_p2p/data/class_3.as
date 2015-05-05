package com.hls_p2p.data
{
   import com.hls_p2p.dataManager.DataManager;
   import com.p2p.utils.console;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.data.vo.Clip;
   
   public class class_3 extends Object
   {
      
      public var isDebug:Boolean = true;
      
      public var drm:Object = null;
      
      public var drmOk:Boolean = false;
      
      public var firstTsPieceOk:Boolean = false;
      
      private var var_8:Object;
      
      public var var_91:Array;
      
      private var var_7:Object;
      
      public var name_2:Array;
      
      public var var_92:DataManager = null;
      
      public var groupID:String = "";
      
      public var createTime:Number = 0;
      
      private var var_93:Number = 0;
      
      private var _groupList:GroupList;
      
      private var var_49:Number = 0;
      
      public var var_94:Array = null;
      
      public var var_95:Number = -1;
      
      private var var_96:Number = 0;
      
      public var playerKbps:String = "";
      
      public var flvURL:Array = null;
      
      public var playLevelArr:Array = null;
      
      public function class_3(param1:DataManager, param2:GroupList)
      {
         this.var_8 = new Object();
         this.var_91 = new Array();
         this.var_7 = new Object();
         this.name_2 = new Array();
         super();
         this.var_92 = param1;
         this._groupList = param2;
      }
      
      private function method_127(param1:Array, param2:Number) : void
      {
         if(param1.length == 0)
         {
            param1.push({
               "start":param2,
               "end":param2
            });
            return;
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(param2 + 1 < param1[_loc3_]["start"])
            {
               param1.splice(_loc3_,0,{
                  "start":param2,
                  "end":param2
               });
               return;
            }
            if(param2 + 1 == param1[_loc3_]["start"])
            {
               param1[_loc3_]["start"] = param2;
               return;
            }
            if(param2 >= param1[_loc3_]["start"] && param2 <= param1[_loc3_]["end"])
            {
               return;
            }
            if(param2 - 1 == param1[_loc3_]["end"])
            {
               param1[_loc3_]["end"] = param2;
               if((param1[_loc3_ + 1]) && param1[_loc3_]["end"] + 1 == param1[_loc3_ + 1]["start"])
               {
                  param1[_loc3_]["end"] = param1[_loc3_ + 1]["end"];
                  param1.splice(_loc3_ + 1,1);
               }
               return;
            }
            if(param2 - 1 > param1[_loc3_]["end"])
            {
               if(param1[_loc3_ + 1])
               {
                  if(param2 + 1 < param1[_loc3_ + 1]["start"])
                  {
                     param1.splice(_loc3_ + 1,0,{
                        "start":param2,
                        "end":param2
                     });
                     return;
                  }
                  if(param2 + 1 == param1[_loc3_ + 1]["start"])
                  {
                     param1[_loc3_ + 1]["start"] = param2;
                     return;
                  }
               }
               else
               {
                  param1.push({
                     "start":param2,
                     "end":param2
                  });
                  return;
               }
            }
            _loc3_++;
         }
      }
      
      public function method_128(param1:Array, param2:Number) : void
      {
         var _loc4_:* = NaN;
         if(param2 <= -1)
         {
            return;
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(param2 >= param1[_loc3_]["start"] && param2 <= param1[_loc3_]["end"])
            {
               if(param2 == param1[_loc3_]["start"] && param2 == param1[_loc3_]["end"])
               {
                  param1.splice(_loc3_,1);
                  return;
               }
               if(param2 == param1[_loc3_]["start"])
               {
                  param1[_loc3_]["start"]++;
                  return;
               }
               if(param2 == param1[_loc3_]["end"])
               {
                  param1[_loc3_]["end"]--;
                  return;
               }
               _loc4_ = param1[_loc3_]["end"];
               param1[_loc3_]["end"] = param2 - 1;
               param1.splice(_loc3_ + 1,0,{
                  "start":param2 + 1,
                  "end":_loc4_
               });
               return;
            }
            _loc3_++;
         }
      }
      
      public function getTNRange(param1:String) : Array
      {
         if((this.method_130) && (this.method_130[param1]) && (this.method_130[param1]["TNRange"]))
         {
            return this.method_130[param1]["TNRange"];
         }
         return null;
      }
      
      public function addTNRange(param1:String, param2:Number) : void
      {
         if(param2 <= -1)
         {
            return;
         }
         if(null == this.method_130 || null == this.method_130[param1])
         {
            return;
         }
         if(null == this.method_130[param1]["TNRange"])
         {
            this.method_130[param1]["TNRange"] = new Array();
         }
         var _loc3_:Array = this.method_130[param1]["TNRange"] as Array;
         this.method_127(_loc3_,param2);
      }
      
      public function deleteTNRange(param1:String, param2:Number) : void
      {
         if(param2 <= -1)
         {
            return;
         }
         if(null == this.method_130 || null == this.method_130[param1] || null == this.method_130[param1]["TNRange"])
         {
            return;
         }
         var _loc3_:Array = this.method_130[param1]["TNRange"] as Array;
         this.method_128(_loc3_,param2);
      }
      
      public function getPNRange(param1:String) : Array
      {
         if((this.method_130) && (this.method_130[param1]) && (this.method_130[param1]["PNRange"]))
         {
            return this.method_130[param1]["PNRange"];
         }
         return null;
      }
      
      public function addPNRange(param1:String, param2:Number) : void
      {
         if(param2 <= -1)
         {
            return;
         }
         if(null == this.method_130 || null == this.method_130[param1])
         {
            return;
         }
         if(null == this.method_130[param1]["PNRange"])
         {
            this.method_130[param1]["PNRange"] = new Array();
         }
         var _loc3_:Array = this.method_130[param1]["PNRange"] as Array;
         this.method_127(_loc3_,param2);
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length - 1)
         {
            if(_loc3_[_loc4_]["start"] > _loc3_[_loc4_]["end"])
            {
               console.log(this,"超出警戒");
            }
            if(_loc3_[_loc4_]["end"] >= _loc3_[_loc4_ + 1]["start"])
            {
               console.log(this,"超出警戒");
            }
            _loc4_++;
         }
      }
      
      public function deletePNRange(param1:String, param2:Number) : void
      {
         if(param2 <= -1)
         {
            return;
         }
         if(null == this.method_130 || null == this.method_130[param1] || null == this.method_130[param1]["PNRange"])
         {
            return;
         }
         var _loc3_:Array = this.method_130[param1]["PNRange"] as Array;
         this.method_128(_loc3_,param2);
      }
      
      public function get method_129() : Object
      {
         return this.var_8;
      }
      
      public function get method_130() : Object
      {
         return this.var_7;
      }
      
      public function get name_3() : Number
      {
         return this.var_96;
      }
      
      public function set name_3(param1:Number) : void
      {
         this.var_96 = param1;
      }
      
      public function method_131(param1:Number) : void
      {
         this._groupList.name_3 = this._groupList.name_3 + param1;
      }
      
      public function method_132(param1:Number) : void
      {
         this._groupList.name_3 = this._groupList.name_3 - param1;
      }
      
      public function setMemoryTime(param1:Number) : void
      {
         if((!(LiveVodConfig.TYPE == LiveVodConfig.LIVE)) && (param1) && param1 > 0)
         {
            this.var_49 = param1;
            this.var_93 = Math.floor(LiveVodConfig.method_262 * 8 / 1024 / param1) - 5 * 60;
         }
      }
      
      public function get memoryTime() : Number
      {
         return this.var_93;
      }
      
      public function method_133(param1:Clip) : Boolean
      {
         if(this.var_8 == null)
         {
            this.var_8 = new Object();
         }
         if(this.var_91 == null)
         {
            this.var_91 = new Array();
         }
         var _loc2_:class_1 = this.var_8[param1.timestamp];
         if(null != _loc2_)
         {
            if(-1 != param1.nextID)
            {
               _loc2_.var_1 = param1.nextID;
            }
            _loc2_.url_ts = param1.url_ts;
            if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
            {
               return true;
            }
            if(_loc2_.method_5(0))
            {
               return true;
            }
         }
         return this.method_135(param1);
      }
      
      public function method_134(param1:Piece) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.name_2.length)
         {
            if(param1 == this.name_2[_loc2_]["piece"])
            {
               this.name_2.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function method_135(param1:Clip) : Boolean
      {
         var _loc3_:* = NaN;
         var _loc2_:class_1 = null;
         _loc2_ = new class_1(this);
         _loc2_.id = param1.timestamp;
         _loc2_.duration = param1.duration;
         _loc2_.width = param1.width;
         _loc2_.height = param1.height;
         _loc2_.name = param1.name;
         _loc2_.url_ts = param1.url_ts;
         _loc2_.var_4 = param1.var_106;
         _loc2_.size = param1.size;
         _loc2_.discontinuity = param1.discontinuity;
         _loc2_.groupID = param1.groupID;
         _loc2_.var_2 = param1.var_2;
         _loc2_.var_1 = param1.nextID;
         _loc2_.pieceInfoArray = param1.pieceInfoArray;
         _loc2_.playerKbps = this.playerKbps;
         if(-1 == param1.timestamp)
         {
            trace(param1.timestamp);
         }
         if(_loc2_.duration == 0)
         {
            _loc2_.method_2();
         }
         this.var_8[param1.timestamp] = _loc2_;
         this.var_91.push(_loc2_.id);
         this.var_91.sort(Array.NUMERIC);
         console.log(this,"add Block  gID=" + String(_loc2_.groupID).substr(0,5) + ", id=" + _loc2_.id);
         if(_loc2_.name_1 == false)
         {
            if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
            {
               if(_loc2_.var_1 == -1)
               {
                  this.var_95 = _loc2_.id;
               }
               if(!(this.groupID == LiveVodConfig.nextVid && !("" == LiveVodConfig.nextVid)))
               {
                  this.method_136(this.groupID,_loc2_);
               }
               else
               {
                  _loc3_ = this.var_92.method_10();
                  if(_loc3_ >= 0)
                  {
                     if(_loc2_.id >= _loc3_ - 16)
                     {
                        this.method_136(this.groupID,_loc2_);
                     }
                  }
                  else
                  {
                     this.method_136(this.groupID,_loc2_);
                  }
               }
            }
            else
            {
               this.method_136(LiveVodConfig.currentVid,_loc2_);
            }
         }
         LiveVodConfig.var_282 = _loc2_.id;
         return true;
      }
      
      private function method_136(param1:String, param2:class_1) : void
      {
         if(!LiveVodConfig.var_278[param1])
         {
            LiveVodConfig.var_278[param1] = new Array();
         }
         if(false == param2.name_1)
         {
            LiveVodConfig.var_278[param1].push(param2.id);
            LiveVodConfig.var_278[param1].sort(Array.NUMERIC);
         }
      }
      
      public function method_22(param1:Number) : Number
      {
         if(-1 == param1)
         {
            return -1;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this.var_91.length == 1)
         {
            if(Math.abs(param1 - this.var_91[0]) < 16)
            {
               return this.var_91[0];
            }
         }
         if(param1 < this.var_91[0])
         {
            if(this.var_91[0] - param1 < 16)
            {
               return this.var_91[0];
            }
         }
         var _loc5_:* = 0;
         while(_loc5_ < this.var_91.length - 1)
         {
            if(param1 >= this.var_91[_loc5_] && param1 < this.var_91[_loc5_ + 1])
            {
               if(this.method_24(this.var_91[_loc5_]))
               {
                  if(!(this.method_24(this.var_91[_loc5_]).var_1 == -1) && param1 < this.method_24(this.var_91[_loc5_]).var_1)
                  {
                     return this.var_91[_loc5_];
                  }
                  if(this.method_24(this.var_91[_loc5_]).var_1 == -1)
                  {
                     _loc4_ = (this.var_91[_loc5_] + this.var_91[_loc5_ + 1]) / 2;
                     if(_loc4_ > param1)
                     {
                        if(param1 - this.var_91[_loc5_] < 16)
                        {
                           return this.var_91[_loc5_];
                        }
                     }
                     else if(this.var_91[_loc5_ + 1] - param1 < 16)
                     {
                        return this.var_91[_loc5_ + 1];
                     }
                     
                  }
               }
            }
            _loc5_++;
         }
         if(param1 >= this.var_91[this.var_91.length - 1])
         {
            if(param1 - this.var_91[this.var_91.length - 1] < 16)
            {
               return this.var_91[this.var_91.length - 1];
            }
         }
         return -1;
      }
      
      public function method_137(param1:Number) : Number
      {
         if(-1 == param1)
         {
            return -1;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this.var_91.length == 1)
         {
            if(Math.abs(param1 - this.var_91[0]) < 16)
            {
               return this.var_91[0];
            }
         }
         if(param1 < this.var_91[0])
         {
            if(this.var_91[0] - param1 < 16)
            {
               return this.var_91[0];
            }
         }
         var _loc5_:* = 0;
         var _loc6_:int = this.var_91.length - 1;
         var _loc7_:* = 0;
         var _loc8_:Number = -1;
         var _loc9_:Number = -1;
         var _loc10_:class_1 = null;
         while(_loc5_ <= _loc6_)
         {
            _loc7_ = (_loc5_ + _loc6_) / 2;
            _loc8_ = this.var_91[_loc7_];
            if(_loc7_ == this.var_91.length - 1)
            {
               if(param1 - this.var_91[_loc7_] < 16)
               {
                  return this.var_91[_loc7_];
               }
               return -1;
            }
            if(param1 >= this.var_91[_loc7_] && param1 < this.var_91[_loc7_ + 1])
            {
               if(!(this.method_24(this.var_91[_loc7_]).var_1 == -1) && param1 < this.method_24(this.var_91[_loc7_]).var_1)
               {
                  return this.var_91[_loc7_];
               }
               if(!(this.method_24(this.var_91[_loc7_]).var_1 == -1) && param1 > this.method_24(this.var_91[_loc7_]).var_1)
               {
                  if(param1 - this.method_24(this.var_91[_loc7_]).var_1 < 16)
                  {
                     return this.method_24(this.var_91[_loc7_]).var_1;
                  }
                  return -1;
               }
               if(this.method_24(this.var_91[_loc7_]).var_1 == -1)
               {
                  _loc4_ = (this.var_91[_loc7_] + this.var_91[_loc7_ + 1]) / 2;
                  if(_loc4_ > param1)
                  {
                     if(param1 - this.var_91[_loc7_] < 16)
                     {
                        return this.var_91[_loc7_];
                     }
                     return -1;
                  }
                  if(this.var_91[_loc7_ + 1] - param1 < 16)
                  {
                     return this.var_91[_loc7_ + 1];
                  }
                  return -1;
               }
            }
            else if(param1 > this.var_91[_loc7_])
            {
               _loc5_ = _loc7_ + 1;
            }
            else if(param1 < this.var_91[_loc7_])
            {
               _loc6_ = _loc7_ - 1;
            }
            
            
         }
         return -1;
      }
      
      public function method_138(param1:Number) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:* = 0;
         while(_loc4_ < this.var_91.length)
         {
            if(this.var_91[_loc4_] == param1)
            {
               _loc2_ = this.var_91[_loc4_];
               if(_loc4_ == this.var_91.length - 1)
               {
                  return -1;
               }
               _loc3_ = this.var_91[_loc4_ + 1];
               if(_loc3_ - _loc2_ < 16)
               {
                  return _loc3_;
               }
               return -1;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public function method_5(param1:Object) : Piece
      {
         if(null == this.method_130)
         {
            return null;
         }
         if((param1 && param1.hasOwnProperty("groupID")) && (param1.hasOwnProperty("pieceKey")) && (param1.hasOwnProperty("type")))
         {
            if((this.method_130[param1.groupID]) && (this.method_130[param1.groupID][param1.type]) && (this.method_130[param1.groupID][param1.type][param1.pieceKey]))
            {
               return this.method_130[param1.groupID][param1.type][param1.pieceKey];
            }
         }
         return null;
      }
      
      public function method_139(param1:Object) : void
      {
         this.method_130[param1.groupID][param1.type][param1.pieceKey] = null;
         delete this.method_130[param1.groupID][param1.type][param1.pieceKey];
         true;
      }
      
      public function method_24(param1:Number) : class_1
      {
         if(null == this.var_8)
         {
            return null;
         }
         if(param1 == -1)
         {
            return null;
         }
         return this.var_8[param1];
      }
      
      public function method_140() : class_1
      {
         if(null == this.var_8 && null == this.var_91)
         {
            return null;
         }
         return this.var_8[this.var_91[0]];
      }
      
      public function method_17() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = new Array();
         if(this.var_7)
         {
            for(_loc2_ in this.var_7)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function method_141() : void
      {
         this._groupList.method_142();
      }
      
      public function method_142(param1:String) : void
      {
         var _loc5_:* = NaN;
         if(LiveVodConfig.BlockID < 0)
         {
            return;
         }
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:class_1 = null;
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && (this.var_91.length > 300 || this._groupList.name_3 >= LiveVodConfig.method_262))
         {
            _loc3_ = 0;
            if(_loc3_ < this.var_91.length)
            {
               _loc4_ = this.method_24(this.var_91[0]);
               if(_loc4_.id >= LiveVodConfig.BlockID - 30)
               {
                  console.log(this,"左侧数据已经淘汰到边界" + _loc4_.id);
               }
               else
               {
                  this.method_144(_loc4_,false);
                  console.log(this,"淘汰后: _streamSize:" + this._groupList.name_3 + "(" + int(this._groupList.name_3 / 1024 / 1024) + ")",this.var_91.length);
                  this.method_143();
                  return;
               }
            }
            _loc3_ = this.var_91.length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = this.method_24(this.var_91[_loc3_]);
               if(_loc4_ == null)
               {
                  _loc3_--;
                  continue;
               }
               if(_loc4_.id <= LiveVodConfig.ADD_DATA_TIME + LiveVodConfig.var_280)
               {
                  console.log(this,"右侧数据已经淘汰到边界" + _loc4_.id);
                  this.method_143();
                  break;
               }
               this.method_144(_loc4_,false);
               console.log(this,"淘汰后: _this._groupList.streamSize:" + this._groupList.name_3 + "(" + int(this._groupList.name_3 / 1024 / 1024) + ")",this.var_91.length);
               this.method_143();
               _loc5_ = 0;
               _loc4_ = this.method_24(this.var_91[LiveVodConfig.ADD_DATA_TIME]);
               if(!_loc4_ && this.var_91.length > 0)
               {
                  _loc4_ = this.method_24(this.var_91[0]);
                  if((_loc4_) && _loc4_.id > LiveVodConfig.ADD_DATA_TIME)
                  {
                     LiveVodConfig.method_267 = LiveVodConfig.ADD_DATA_TIME;
                     return;
                  }
               }
               if(!_loc4_)
               {
                  LiveVodConfig.method_267 = LiveVodConfig.ADD_DATA_TIME;
                  return;
               }
               while(_loc4_.var_1 != -1)
               {
                  _loc5_ = _loc4_.id;
                  _loc4_ = this.method_24(_loc4_.var_1);
                  if(null == _loc4_)
                  {
                     this.method_24(_loc5_).var_1 = -1;
                     LiveVodConfig.method_267 = _loc5_;
                     return;
                  }
               }
               if(_loc4_.id < LiveVodConfig.BlockID && !(LiveVodConfig.BlockID == -1))
               {
                  LiveVodConfig.method_267 = LiveVodConfig.BlockID;
                  return;
               }
               LiveVodConfig.method_267 = _loc4_.id;
               return;
               break;
            }
         }
         else if(!(this.groupID == LiveVodConfig.currentVid) && !(this.groupID == LiveVodConfig.nextVid))
         {
            _loc3_ = 0;
            while(_loc3_ < this.var_91.length)
            {
               _loc4_ = this.method_24(this.var_91[_loc3_]);
               this.method_144(_loc4_,false);
               if(this._groupList.name_3 >= LiveVodConfig.method_262)
               {
                  _loc3_++;
                  continue;
               }
               console.log(this,"淘汰后 set memorySize:" + LiveVodConfig.method_262 + " _streamSize:" + this._groupList.name_3 + "(" + int(this._groupList.name_3 / 1024 / 1024) + ")");
               this.method_143();
               return;
            }
            if(_loc3_ == this.var_91.length)
            {
               this.method_143();
               return;
            }
         }
         else if(this.groupID == LiveVodConfig.currentVid)
         {
            if("left" == param1)
            {
               _loc3_ = 0;
               while(_loc3_ < this.var_91.length)
               {
                  if(this.var_91[_loc3_] >= LiveVodConfig.BlockID - 60)
                  {
                     console.log(this,"左侧数据已经淘汰");
                     break;
                  }
                  _loc4_ = this.method_24(this.var_91[_loc3_]);
                  this.method_144(_loc4_,true);
                  if(this._groupList.name_3 >= LiveVodConfig.method_262)
                  {
                     _loc3_++;
                     continue;
                  }
                  console.log(this,"淘汰后 set memorySize:" + LiveVodConfig.method_262 + " _streamSize:" + this._groupList.name_3 + "(" + int(this._groupList.name_3 / 1024 / 1024) + ")");
                  this.method_143();
                  return;
                  break;
               }
            }
            else if("right" == param1)
            {
               _loc3_ = this.var_91.length - 1;
               while(_loc3_ >= 0)
               {
                  if(this.var_91[_loc3_] <= LiveVodConfig.BlockID + 60)
                  {
                     console.log(this,"淘汰到右侧边界");
                     this.method_143();
                     return;
                  }
                  _loc4_ = this.method_24(this.var_91[_loc3_]);
                  this.method_144(_loc4_,true);
                  if(this._groupList.name_3 >= LiveVodConfig.method_262)
                  {
                     _loc3_--;
                     continue;
                  }
                  console.log(this,"淘汰后: _streamSize:" + this._groupList.name_3 + "(" + int(this._groupList.name_3 / 1024 / 1024) + ")");
                  this.method_143();
                  return;
               }
            }
            
         }
         else if(this.groupID == LiveVodConfig.nextVid)
         {
            _loc3_ = this.var_91.length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = this.method_24(this.var_91[_loc3_]);
               this.method_144(_loc4_,true);
               if(this._groupList.name_3 >= LiveVodConfig.method_262)
               {
                  _loc3_--;
                  continue;
               }
               console.log(this,"淘汰后: _streamSize:" + this._groupList.name_3 + "(" + int(this._groupList.name_3 / 1024 / 1024) + ")");
               this.method_143();
               return;
            }
            if(_loc3_ <= -1)
            {
               this.method_143();
               return;
            }
         }
         
         
         
      }
      
      private function method_143() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         for(_loc1_ in this.method_130)
         {
            _loc2_ = 0;
            for(_loc3_ in this.method_130[_loc1_])
            {
               _loc2_++;
               if(_loc2_ != 0)
               {
                  _loc4_ = 0;
                  _loc5_ = 0;
                  if(this.method_130[_loc1_]["TN"])
                  {
                     for(_loc6_ in this.method_130[_loc1_]["TN"])
                     {
                        _loc4_++;
                     }
                  }
                  if(this.method_130[_loc1_]["PN"])
                  {
                     for(_loc7_ in this.method_130[_loc1_]["PN"])
                     {
                        _loc5_++;
                     }
                  }
                  if(_loc4_ == 0 && _loc5_ == 0)
                  {
                     this.method_130[_loc1_] = null;
                     delete this.method_130[_loc1_];
                     true;
                  }
               }
               else
               {
                  this.method_130[_loc1_] = null;
                  delete this.method_130[_loc1_];
                  true;
               }
            }
         }
         if(0 == this.name_3 && !(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && !(this.groupID == LiveVodConfig.currentVid) && !(this.groupID == LiveVodConfig.nextVid))
         {
            this._groupList.method_147(this.groupID);
         }
      }
      
      private function method_144(param1:class_1, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         console.log(this,"eliminate block:" + param1.id + " isReset:" + param2);
         if(param2)
         {
            param1.reset();
         }
         else if(!param2)
         {
            _loc3_ = -1;
            if(this.var_91)
            {
               _loc3_ = this.var_91.indexOf(param1.id);
               if(_loc3_ != -1)
               {
                  this.var_91.splice(_loc3_,1);
               }
            }
            if((this.var_8) && (param1))
            {
               if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
               {
                  _loc4_ = LiveVodConfig.var_278[this.groupID].indexOf(param1.id);
                  if(-1 != _loc4_)
                  {
                     LiveVodConfig.var_278[this.groupID].splice(_loc4_,1);
                  }
               }
               else
               {
                  _loc4_ = LiveVodConfig.var_278[LiveVodConfig.currentVid].indexOf(param1.id);
                  if(-1 != _loc4_)
                  {
                     LiveVodConfig.var_278[LiveVodConfig.currentVid].splice(_loc4_,1);
                  }
               }
               param1.clear();
               if(this.var_8[param1.id])
               {
                  this.var_8[param1.id] = null;
                  delete this.var_8[param1.id];
                  true;
               }
            }
            var param1:class_1 = null;
         }
         
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function clear() : void
      {
         trace(this,"blockList clear " + String(this.groupID).substr(0,5));
         console.log(this,"blockList clear " + String(this.groupID).substr(0,5));
         this.drm = null;
         this.drmOk = false;
         this.firstTsPieceOk = false;
         this.var_91 = null;
         this.var_8 = null;
         this.method_132(this.name_3);
         if(LiveVodConfig.var_278[this.groupID])
         {
            LiveVodConfig.var_278[this.groupID] = null;
            delete LiveVodConfig.var_278[this.groupID];
            true;
         }
         this.var_7 = null;
         this.var_92 = null;
         this.name_2 = null;
         this.groupID = "";
         this.createTime = 0;
         this.var_95 = -1;
      }
   }
}
