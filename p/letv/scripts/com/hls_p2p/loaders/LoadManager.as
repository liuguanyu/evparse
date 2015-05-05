package com.hls_p2p.loaders
{
   import com.hls_p2p.dataManager.DataManager;
   import com.hls_p2p.loaders.p2pLoader.P2P_Cluster;
   import com.hls_p2p.data.vo.class_2;
   import com.p2p.utils.console;
   import com.hls_p2p.loaders.cdnLoader.CDNLoad;
   import com.hls_p2p.data.class_1;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.data.Piece;
   import com.hls_p2p.statistics.Statistic;
   import com.p2p.utils.ParseUrl;
   import com.hls_p2p.data.LIVE_TIME;
   
   public class LoadManager extends Object
   {
      
      public static var var_289:String = "";
      
      {
         var_289 = "";
      }
      
      public var isDebug:Boolean = false;
      
      protected var var_107:DataManager;
      
      protected var var_108:Array = null;
      
      protected var var_109:P2P_Cluster;
      
      private var var_110:Number;
      
      protected var _initData:class_2;
      
      private var var_111:Boolean = false;
      
      public function LoadManager(param1:DataManager)
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         this.var_110 = LiveVodConfig.method_266;
         super();
         this.var_107 = param1;
         this.var_109 = new P2P_Cluster();
         if(null == this.var_108)
         {
            _loc2_ = 1;
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
            {
               _loc2_ = 4;
            }
            this.var_108 = new Array(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < this.var_108.length)
            {
               if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && _loc3_ == 0)
               {
                  this.var_108[_loc3_] = new CDNLoad(param1,this);
                  this.var_108[_loc3_].id = _loc3_;
               }
               else
               {
                  this.var_108[_loc3_] = new CDNLoad(param1,this,false);
                  this.var_108[_loc3_].id = _loc3_;
               }
               _loc3_++;
            }
         }
      }
      
      public function method_154(param1:Array) : void
      {
         this.var_109.method_154(param1);
      }
      
      public function get method_155() : Number
      {
         return this.var_110;
      }
      
      public function start(param1:class_2) : void
      {
         console.log(this,"start");
         this._initData = param1;
         this.method_156();
         var _loc2_:* = 0;
         while(_loc2_ < this.var_108.length)
         {
            (this.var_108[_loc2_] as CDNLoad).start(this._initData);
            _loc2_++;
         }
         if(this._initData.playlevel == 1)
         {
            this.method_159();
         }
         this.var_109.initialize(this._initData,this.var_107);
      }
      
      private function method_156() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = 0;
         var _loc3_:class_1 = null;
         var _loc4_:String = null;
         if(!LiveVodConfig.var_278)
         {
            LiveVodConfig.var_278 = new Object();
            console.log(this,"new LiveVodConfig.TaskCache");
         }
         for(_loc4_ in LiveVodConfig.var_278)
         {
            if(!(_loc4_ == LiveVodConfig.nextVid && !("" == LiveVodConfig.nextVid)))
            {
               _loc1_ = this.var_107.method_34(_loc4_);
               if(_loc1_)
               {
                  LiveVodConfig.var_278[_loc4_] = new Array();
                  _loc2_ = 0;
                  while(_loc2_ < _loc1_.length)
                  {
                     if(_loc1_[_loc2_] >= LiveVodConfig.ADD_DATA_TIME - 16)
                     {
                        _loc3_ = this.var_107.method_24(_loc4_,_loc1_[_loc2_]);
                        if((_loc3_) && _loc3_.name_1 == false)
                        {
                           LiveVodConfig.var_278[_loc4_].push(_loc1_[_loc2_]);
                        }
                     }
                     _loc2_++;
                  }
               }
               continue;
            }
         }
      }
      
      protected function method_157() : void
      {
         var _loc1_:Array = null;
         var _loc2_:class_1 = null;
         if(!LiveVodConfig.var_278[LiveVodConfig.currentVid])
         {
            return;
         }
         while(LiveVodConfig.var_278[LiveVodConfig.currentVid].length > 0)
         {
            this.var_111 = true;
            if(LiveVodConfig.var_278[LiveVodConfig.currentVid][0] < LiveVodConfig.BlockID)
            {
               LiveVodConfig.var_278[LiveVodConfig.currentVid].shift();
               continue;
            }
            break;
         }
         if((this.var_111) && LiveVodConfig.var_278[LiveVodConfig.currentVid].length == 0)
         {
            _loc1_ = this.var_107.method_34(LiveVodConfig.currentVid);
            LiveVodConfig.method_94 = _loc1_[_loc1_.length - 1];
            console.log(this,"NEAREST_WANT_ID = " + LiveVodConfig.method_94 + ", gID=" + String(LiveVodConfig.currentVid).substr(0,5));
         }
         this.method_166(this.var_107.method_17());
         if(LiveVodConfig.var_278[LiveVodConfig.currentVid].length > 0)
         {
            _loc2_ = this.var_107.method_24(LiveVodConfig.currentVid,LiveVodConfig.var_278[LiveVodConfig.currentVid][0]);
            if(_loc2_)
            {
               LiveVodConfig.method_94 = _loc2_.id;
               console.log(this,"NEAREST_WANT_ID = " + LiveVodConfig.method_94 + ", bID=" + _loc2_.id + ", gID=" + String(LiveVodConfig.currentVid).substr(0,5));
               if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
               {
                  this.method_159();
                  if(this.var_110 == LiveVodConfig.method_266)
                  {
                     if(_loc2_.id - LiveVodConfig.ADD_DATA_TIME > LiveVodConfig.method_266)
                     {
                        this.var_110 = LiveVodConfig.method_266 / 2;
                     }
                  }
                  else if(_loc2_.id - LiveVodConfig.ADD_DATA_TIME < LiveVodConfig.method_266 / 2)
                  {
                     this.var_110 = LiveVodConfig.method_266;
                  }
                  
                  if(LiveVodConfig.IS_CHANGE_KBPS == true && !("" == LiveVodConfig.currentChangeVid))
                  {
                     this.var_110 = LiveVodConfig.method_266 * 2;
                  }
               }
               else if(this.var_110 == LiveVodConfig.method_266)
               {
                  if(_loc2_.id - LiveVodConfig.ADD_DATA_TIME >= LiveVodConfig.method_266)
                  {
                     if(this._initData.playlevel != 1)
                     {
                        this.method_158();
                     }
                     this.var_110 = LiveVodConfig.method_266 / 2;
                  }
                  else
                  {
                     this.method_159();
                     this.var_110 = LiveVodConfig.method_266;
                  }
               }
               else if(_loc2_.id - LiveVodConfig.ADD_DATA_TIME <= LiveVodConfig.method_266 / 2)
               {
                  this.method_159();
                  this.var_110 = LiveVodConfig.method_266;
               }
               
               
            }
         }
      }
      
      private function method_158() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.var_108.length)
         {
            if(_loc1_ > 0)
            {
               (this.var_108[_loc1_] as CDNLoad).resume();
            }
            _loc1_++;
         }
      }
      
      private function method_159() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.var_108.length)
         {
            if(_loc1_ > 0)
            {
               (this.var_108[_loc1_] as CDNLoad).pause();
            }
            _loc1_++;
         }
      }
      
      public function method_160(param1:Boolean) : Object
      {
         var _loc5_:* = 0;
         var _loc6_:* = NaN;
         var _loc7_:String = null;
         var _loc8_:* = NaN;
         var _loc2_:String = LiveVodConfig.PLAYING_BLOCK_GID;
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            _loc2_ = LiveVodConfig.currentVid;
         }
         var _loc3_:class_1 = this.var_107.method_24(_loc2_,LiveVodConfig.BlockID);
         if((true == LiveVodConfig.IS_CHANGE_KBPS && !("" == LiveVodConfig.currentChangeVid)) && (_loc3_) && true == _loc3_.name_1)
         {
            _loc2_ = LiveVodConfig.currentChangeVid;
            console.log(this,"currentChangeVid = " + _loc2_);
         }
         if((LiveVodConfig.IS_DRM) && (this.var_107.method_33(_loc2_)) && !this.var_107.method_33(_loc2_).drmOk)
         {
            return null;
         }
         this.method_157();
         if((this._initData) && (this._initData.method_60()))
         {
            if(!((LiveVodConfig.IS_DRM) && (this.var_107.method_33(_loc2_)) && !this.var_107.method_33(_loc2_).firstTsPieceOk))
            {
               console.log(this,"P2PFirst");
               return null;
            }
         }
         if(!LiveVodConfig.var_278[_loc2_] || LiveVodConfig.var_278[_loc2_].length == 0)
         {
            if(!((LiveVodConfig.var_278[_loc2_]) && (LiveVodConfig.TYPE == LiveVodConfig.VOD) && !("" == LiveVodConfig.nextVid)))
            {
               console.log(this,"!LiveVodConfig.TaskCache [gID] = " + _loc2_);
               return null;
            }
         }
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = this.method_161(_loc3_);
         if(_loc4_ != null)
         {
            LiveVodConfig.method_94 = _loc3_.id;
            return _loc4_;
         }
         if(!((this.method_162()) && (this._initData.method_62())))
         {
            _loc5_ = 0;
            while(true)
            {
               if(_loc5_ < LiveVodConfig.var_278[_loc2_].length)
               {
                  _loc6_ = LiveVodConfig.BlockID;
                  if(-1 == _loc6_)
                  {
                     break;
                  }
                  _loc3_ = this.var_107.method_24(_loc2_,LiveVodConfig.var_278[_loc2_][_loc5_]);
                  if((_loc3_) && (_loc3_.id >= _loc6_ || true == LiveVodConfig.IS_CHANGE_KBPS && !("" == LiveVodConfig.currentChangeVid) && _loc3_.id < _loc6_ && _loc3_.id + _loc3_.duration >= _loc6_))
                  {
                     if(_loc3_.id - _loc6_ <= this.var_110)
                     {
                        _loc4_ = this.method_161(_loc3_);
                        if(_loc4_ != null)
                        {
                           console.log(this,_loc3_.id + " isChecked= " + _loc3_.name_1 + " gID = " + String(_loc3_.groupID).substr(0,5));
                           return _loc4_;
                        }
                     }
                     else
                     {
                        console.log(this,_loc3_.id + " >= " + _loc6_ + " gID = " + String(_loc3_.groupID).substr(0,5));
                     }
                  }
                  else
                  {
                     console.log(this,"!!!blk");
                  }
                  _loc5_++;
                  continue;
               }
            }
            return null;
         }
         _loc7_ = LiveVodConfig.nextVid;
         _loc8_ = this.var_107.method_10();
         _loc5_ = 0;
         while(_loc5_ < LiveVodConfig.var_278[_loc7_].length)
         {
            _loc3_ = this.var_107.method_24(_loc7_,LiveVodConfig.var_278[_loc7_][_loc5_]);
            if((_loc3_) && _loc3_.id >= _loc8_)
            {
               if(_loc3_.id - _loc8_ <= this.var_110)
               {
                  _loc4_ = this.method_161(_loc3_);
                  if(_loc4_ != null)
                  {
                     console.log(this,"TaskCache[nextVid] " + String(LiveVodConfig.nextVid).substr(0,5) + "; blk.id= " + _loc3_.id);
                     return _loc4_;
                  }
               }
               else
               {
                  console.log(this,"TaskCache[nextVid] " + _loc3_.id + " >= " + _loc6_ + " gID = " + String(_loc3_.groupID).substr(0,5));
                  break;
               }
            }
            _loc5_++;
         }
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && true == param1)
         {
            return {
               "block":this.method_19(),
               "isBuffer":false
            };
         }
         return null;
      }
      
      private function method_161(param1:class_1) : Object
      {
         var _loc2_:Piece = null;
         var _loc3_:* = 0;
         if(false == param1.name_1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.var_6.length)
            {
               _loc2_ = this.var_107.method_5(param1.var_6[_loc3_]);
               if((_loc2_) && (!_loc2_.name_1) && !(_loc2_.iLoadType == 1))
               {
                  if(_loc2_.peerID != "")
                  {
                     Statistic.method_261().method_85(_loc2_.pieceKey,"H_" + _loc2_.peerID);
                  }
                  console.log(this,"getCDNTask = " + param1.id + " gID = " + String(param1.groupID).substr(0,5));
                  if(true == LiveVodConfig.IS_CHANGE_KBPS)
                  {
                  }
                  return {
                     "block":param1,
                     "isBuffer":true
                  };
               }
               _loc3_++;
            }
         }
         else
         {
            console.log(this,param1.id + " isChecked= " + param1.name_1 + " gID = " + String(param1.groupID).substr(0,5));
         }
         return null;
      }
      
      private function method_162() : Boolean
      {
         if((!("" == LiveVodConfig.nextVid) && this._initData.var_65) && (LiveVodConfig.var_278.hasOwnProperty(LiveVodConfig.nextVid)) && LiveVodConfig.var_278[LiveVodConfig.nextVid].length > 0)
         {
            return true;
         }
         return false;
      }
      
      private function method_19() : class_1
      {
         return this.var_107.method_19();
      }
      
      private function method_163(param1:Piece, param2:Array, param3:Object) : Object
      {
         var _loc7_:* = undefined;
         if(!param2 || !param3)
         {
            return null;
         }
         var _loc4_:* = 0;
         var _loc5_:int = param2.length - 1;
         var _loc6_:* = 0;
         while(_loc4_ <= _loc5_)
         {
            _loc6_ = (_loc4_ + _loc5_) / 2;
            _loc7_ = param2[_loc6_];
            if(Number(param1.pieceKey) >= _loc7_.start && Number(param1.pieceKey) <= _loc7_.end)
            {
               param1.iLoadType = 2;
               param1.peerID = param3.remoteID;
               param1.var_23 = this.getTime();
               return param1;
            }
            if(Number(param1.pieceKey) > _loc7_.end)
            {
               _loc4_ = _loc6_ + 1;
            }
            else if(Number(param1.pieceKey) < _loc7_.start)
            {
               _loc5_ = _loc6_ - 1;
            }
            
         }
         return null;
      }
      
      public function method_7(param1:Object) : Object
      {
         var _loc2_:String = null;
         var _loc3_:Piece = null;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         var _loc6_:class_1 = null;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:Array = null;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         var _loc13_:* = 0;
         var _loc14_:class_1 = null;
         if(true == LiveVodConfig.IS_CHANGE_KBPS)
         {
            return null;
         }
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            _loc2_ = param1.groupID;
         }
         else
         {
            _loc2_ = LiveVodConfig.currentVid;
         }
         if((LiveVodConfig.IS_DRM) && (this.var_107.method_33(_loc2_)))
         {
            if(!this.var_107.method_33(_loc2_).drmOk || !this.var_107.method_33(_loc2_).firstTsPieceOk)
            {
               return null;
            }
         }
         if(!(_loc2_ == LiveVodConfig.currentVid || _loc2_ == LiveVodConfig.nextVid || _loc2_ == LiveVodConfig.currentChangeVid))
         {
            return null;
         }
         if(this._initData.playlevel == 1 && this.var_110 >= LiveVodConfig.method_262)
         {
            return null;
         }
         this.method_157();
         if((_loc2_ == LiveVodConfig.currentVid && LiveVodConfig.var_278[LiveVodConfig.currentVid]) && (LiveVodConfig.var_278[LiveVodConfig.currentVid].length > 0) && !this.method_162())
         {
            _loc4_ = null;
            _loc5_ = 0;
            while(_loc5_ < LiveVodConfig.var_278[LiveVodConfig.currentVid].length)
            {
               if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && LiveVodConfig.var_278[LiveVodConfig.currentVid][_loc5_] - LiveVodConfig.ADD_DATA_TIME >= this.var_107.method_41(LiveVodConfig.currentVid))
               {
                  return null;
               }
               _loc6_ = this.var_107.method_24(LiveVodConfig.currentVid,LiveVodConfig.var_278[LiveVodConfig.currentVid][_loc5_]);
               if(!((_loc6_) && !(_loc6_.groupID == param1.groupID)))
               {
                  if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
                  {
                     if(LiveVodConfig.var_278[LiveVodConfig.currentVid][_loc5_] - LiveVodConfig.ADD_DATA_TIME >= LiveVodConfig.var_280)
                     {
                        return null;
                     }
                  }
                  if((LiveVodConfig.TYPE == LiveVodConfig.LIVE && _loc6_) && (false == this._initData.method_60() && _loc6_.id - LiveVodConfig.ADD_DATA_TIME <= LiveVodConfig.method_266) && !_loc6_.name_1)
                  {
                     if(false == this._initData.cdnDownloadSlow)
                     {
                        console.log(this,"紧急区不p2p");
                        return null;
                     }
                  }
                  if((_loc6_) && (_loc6_.id - LiveVodConfig.ADD_DATA_TIME > this.var_110 || true == this._initData.method_60() || LiveVodConfig.cdnDisable == 1 && (Statistic.method_261().var_80) || true == this._initData.cdnDownloadSlow))
                  {
                     _loc4_ = this.method_164(_loc6_,param1);
                     if(_loc4_ != null)
                     {
                        return _loc4_;
                     }
                  }
               }
               _loc5_++;
            }
         }
         if((_loc2_ == LiveVodConfig.nextVid) && (LiveVodConfig.var_278[LiveVodConfig.nextVid]) && LiveVodConfig.var_278[LiveVodConfig.nextVid].length > 0)
         {
            _loc7_ = this.var_107.method_41(LiveVodConfig.currentVid);
            _loc8_ = this.var_107.method_41(LiveVodConfig.nextVid);
            _loc9_ = this.var_107.method_34(LiveVodConfig.currentVid);
            if(!_loc9_ || _loc8_ == 0)
            {
               return null;
            }
            _loc10_ = _loc9_[_loc9_.length - 1];
            _loc11_ = LiveVodConfig.ADD_DATA_TIME + _loc7_ - _loc10_;
            if(_loc11_ <= 0)
            {
               return null;
            }
            _loc12_ = _loc11_ / _loc7_ * _loc8_;
            _loc13_ = 0;
            while(_loc13_ < LiveVodConfig.var_278[LiveVodConfig.nextVid].length)
            {
               if(LiveVodConfig.var_278[LiveVodConfig.nextVid][_loc13_] >= _loc12_)
               {
                  console.log(this,"P2P TaskCache[nextVid] >= " + LiveVodConfig.var_278[LiveVodConfig.nextVid][_loc13_] + " > " + _loc12_);
                  return null;
               }
               _loc14_ = this.var_107.method_24(LiveVodConfig.nextVid,LiveVodConfig.var_278[LiveVodConfig.nextVid][_loc13_]);
               if(!((_loc14_) && !(_loc14_.groupID == param1.groupID)))
               {
                  if(_loc14_)
                  {
                     _loc4_ = this.method_164(_loc14_,param1);
                     if(_loc4_ != null)
                     {
                        console.log(this,"P2P TaskCache[nextVid] " + _loc14_.id + " gID = " + String(_loc14_.groupID).substr(0,5));
                        return _loc4_;
                     }
                  }
               }
               _loc13_++;
            }
         }
         return null;
      }
      
      private function method_164(param1:class_1, param2:Object) : Object
      {
         var _loc3_:Piece = null;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         if(false == param1.name_1)
         {
            _loc4_ = null;
            _loc5_ = 0;
            while(_loc5_ < param1.var_6.length)
            {
               _loc3_ = param1.method_5(_loc5_);
               if(!_loc3_.name_1 && !(_loc3_.iLoadType == 1) && !(_loc3_.iLoadType == 3) && (_loc3_.peerID == "" || !(_loc3_.peerID == param2.remoteID) && this.getTime() - _loc3_.var_23 > 30 * 1000))
               {
                  if(!(_loc3_.peerID == "") && !(_loc3_.peerID == param2.remoteID) && this.getTime() - _loc3_.var_23 > 30 * 1000)
                  {
                     Statistic.method_261().method_85(_loc3_.pieceKey,_loc3_.peerID);
                     _loc3_.peerID = "";
                     _loc3_.var_23 = 0;
                     _loc3_.from = "";
                     _loc3_.iLoadType = 0;
                  }
                  _loc6_ = param2.TNrange;
                  if("PN" == _loc3_.type)
                  {
                     _loc6_ = param2.PNrange;
                  }
                  _loc4_ = this.method_163(_loc3_,_loc6_,param2);
                  if(_loc4_ != null)
                  {
                     return _loc4_;
                  }
               }
               _loc5_++;
            }
         }
         return null;
      }
      
      public function get method_165() : String
      {
         return this._initData.flvURL[this._initData.g_nM3U8Idx];
      }
      
      public function method_39() : Object
      {
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc1_:Object = new Object();
         var _loc2_:* = "";
         var _loc3_:Number = 5;
         var _loc4_:* = "";
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            _loc7_ = 0;
            if(this._initData.var_52 == true)
            {
               _loc7_ = LiveVodConfig.ADD_DATA_TIME;
               _loc2_ = this._initData.flvURL[this._initData.g_nM3U8Idx];
               _loc2_ = ParseUrl.replaceParam(_loc2_,"mslice",String(3));
               this._initData.var_52 = false;
            }
            else if(true == LiveVodConfig.IS_SEEKING)
            {
               _loc7_ = LiveVodConfig.ADD_DATA_TIME;
            }
            else
            {
               _loc7_ = LiveVodConfig.method_267;
            }
            
            if(this._initData.var_55 != 0)
            {
               _loc7_ = this._initData.var_55;
               LiveVodConfig.method_267 = this._initData.var_55;
               console.log(this,"===*****===_initData.g_seekPos: " + this._initData.var_55 + "LiveVodConfig.M3U8_MAXTIME: " + LiveVodConfig.method_267);
               this._initData.var_55 = 0;
            }
            if(_loc7_ > LiveVodConfig.ADD_DATA_TIME + 10 * 60)
            {
               _loc7_ = LiveVodConfig.ADD_DATA_TIME + 10 * 60;
            }
            _loc7_ = Math.floor(_loc7_);
            _loc7_ = Math.round(_loc7_);
            if(this._initData.var_57)
            {
               _loc2_ = ParseUrl.replaceParam(this.method_165,"abtimeshift","" + _loc7_);
            }
            _loc2_ = ParseUrl.replaceParam(_loc2_,"rdm","" + this.getTime());
            _loc2_ = ParseUrl.replaceParam(_loc2_,"mslice",String(5));
            console.log(this,"LiveVodConfig.M3U8_MAXTIME - LiveVodConfig.ADD_DATA_TIME: " + (LiveVodConfig.method_267 - LiveVodConfig.ADD_DATA_TIME),"timeshift: " + _loc7_);
            console.log(this,"LIVE_TIME.GetLiveTime - LiveVodConfig.M3U8_MAXTIME: " + (LIVE_TIME.method_257() - LiveVodConfig.method_267));
            if(LiveVodConfig.method_267 - LiveVodConfig.ADD_DATA_TIME > 20 || LIVE_TIME.method_257() - LiveVodConfig.method_267 < 20)
            {
               console.log(this,"m3u8 set 3000ms");
               _loc3_ = 3000;
            }
            else
            {
               console.log(this,"m3u8 set 500ms");
               _loc3_ = 500;
            }
            _loc8_ = this.var_107.method_41(LiveVodConfig.currentVid);
            if(!(_loc8_ == 0) && LiveVodConfig.method_267 - LiveVodConfig.ADD_DATA_TIME > -1 * 60)
            {
               _loc3_ = 3000;
               _loc2_ = "";
               console.log(this,"(LiveVodConfig.M3U8_MAXTIME - LiveVodConfig.ADD_DATA_TIME) > 60 set 60000");
            }
         }
         else if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            _loc3_ = 6000;
            if(false == LiveVodConfig.IS_CHANGE_KBPS)
            {
               if(false == this._initData.var_53)
               {
                  _loc2_ = this._initData.flvURL[this._initData.g_nM3U8Idx];
                  _loc4_ = this._initData.kbps;
                  _loc5_ = this._initData.flvURL.concat();
                  _loc6_ = this._initData.playLevelArr.concat();
               }
               else if((this._initData.var_65) && (this._initData.var_65.flvURL))
               {
                  _loc2_ = this._initData.var_65.flvURL[this._initData.var_65.g_nM3U8Idx];
                  _loc4_ = this._initData.var_65.kbps;
                  _loc5_ = this._initData.var_65.flvURL.concat();
                  _loc6_ = this._initData.var_65.playLevelArr.concat();
                  Statistic.method_261().method_95("startNextM3U8");
               }
               else
               {
                  return null;
               }
               
            }
            else
            {
               _loc2_ = this._initData.method_68[this._initData.g_nM3U8Idx];
               _loc4_ = this._initData.method_70[0]["kbps"];
               _loc5_ = this._initData.method_68.concat();
               _loc6_ = this._initData.method_69.concat();
            }
         }
         
         _loc1_.flvURL = _loc5_;
         _loc1_.playLevelArr = _loc6_;
         _loc1_.kbps = _loc4_;
         _loc1_.url = _loc2_;
         _loc1_.delaytime = _loc3_;
         return _loc1_;
      }
      
      protected function method_166(param1:Object) : void
      {
         if((param1) && (param1 is Array) && (param1 as Array).length > 0)
         {
            this.var_109.method_202(param1 as Array);
         }
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function method_30(param1:String) : void
      {
         this.var_109.method_30(param1);
      }
      
      public function clear() : void
      {
         var _loc1_:* = 0;
         console.log(this,"clear");
         if(this.var_108)
         {
            _loc1_ = this.var_108.length - 1;
            while(_loc1_ >= 0)
            {
               (this.var_108[_loc1_] as CDNLoad).clear();
               this.var_108.splice(_loc1_);
               _loc1_--;
            }
            this.var_108 = null;
         }
         if(this.var_109)
         {
            this.var_109.clear();
            this.var_109 = null;
         }
         this.var_110 = LiveVodConfig.method_266;
         this.var_111 = false;
         this._initData = null;
      }
   }
}
