package com.hls_p2p.dataManager
{
   import com.hls_p2p.data.GroupList;
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.loaders.descLoader.IDescLoader;
   import com.hls_p2p.loaders.ReportDownloadError;
   import com.hls_p2p.loaders.LoadManager;
   import com.hls_p2p.loaders.Gslbloader.Gslbloader;
   import com.hls_p2p.events.EventWithData;
   import com.hls_p2p.events.protocol.NETSTREAM_PROTOCOL;
   import com.hls_p2p.loaders.descLoader.FactoryDesc;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.events.EventExtensions;
   import com.p2p.utils.console;
   import ɇ.start;
   import ɇ.stop;
   import com.hls_p2p.data.Piece;
   import com.hls_p2p.data.class_1;
   import com.hls_p2p.data.vo.Clip;
   import com.hls_p2p.statistics.Statistic;
   import ɇ.clear;
   
   public class DataManager extends Object
   {
      
      public var isDebug:Boolean = true;
      
      protected var _groupList:GroupList;
      
      protected var _initData:class_2;
      
      protected var var_9:IDescLoader;
      
      protected var _reportDownloadError:ReportDownloadError;
      
      protected var var_10:LoadManager;
      
      protected var var_11:Gslbloader;
      
      public function DataManager()
      {
         super();
         this.init();
      }
      
      public function method_7(param1:Object) : Object
      {
         if(null != this.var_10)
         {
            return this.var_10.method_7(param1);
         }
         return null;
      }
      
      protected function init() : void
      {
         EventWithData.method_261().addEventListener(NETSTREAM_PROTOCOL.PLAY,this.streamPlayHandler);
         EventWithData.method_261().addEventListener(NETSTREAM_PROTOCOL.SEEK,this.streamSeekHandler);
         this._groupList = new GroupList(this);
         this.var_11 = new Gslbloader(this);
         this.var_9 = new FactoryDesc().method_153(LiveVodConfig.TYPE,this);
         this.var_10 = new LoadManager(this);
      }
      
      public function method_8(param1:String) : String
      {
         if(this._groupList)
         {
            return this._groupList.method_8(param1);
         }
         return "";
      }
      
      public function method_9() : Object
      {
         if((this._initData) && (this._initData.drm))
         {
            return this._initData.drm;
         }
         return null;
      }
      
      protected function streamPlayHandler(param1:EventExtensions) : void
      {
         console.log(this,"streamPlayHandler");
         this._initData = param1.data["initData"] as class_2;
         this._reportDownloadError = param1.data["reportDownloadError"] as ReportDownloadError;
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            this.var_11.start(this._initData);
         }
         this.var_10.start(this._initData);
         this.var_9.ɇ.start(this._initData);
      }
      
      public function method_10() : Number
      {
         if((this._initData) && (this._initData.var_65) && this._initData.var_65.startTime >= 0)
         {
            return this._initData.var_65.startTime;
         }
         return -1;
      }
      
      public function method_11(param1:Array) : Boolean
      {
         var _loc2_:String = null;
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            _loc2_ = this.method_16(param1[0]["kbps"]);
            if(!(_loc2_ == "null") && param1[0]["kbps"] == this._initData.kbps)
            {
               return this._groupList.method_11(param1,_loc2_);
            }
         }
         return false;
      }
      
      public function method_12(param1:class_2) : void
      {
         this.var_9.ɇ.start(param1);
      }
      
      public function method_13() : void
      {
         this.var_9.stop();
      }
      
      public function method_14(param1:String) : Number
      {
         return this._groupList.method_14(param1);
      }
      
      public function method_15(param1:String) : Boolean
      {
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            trace(this,"clearNextVideoInfo = " + param1);
            return this._groupList.method_15(param1);
         }
         return false;
      }
      
      public function method_16(param1:String) : String
      {
         if(this._groupList)
         {
            return this._groupList.method_16(param1);
         }
         return "null";
      }
      
      protected function streamSeekHandler(param1:EventExtensions) : void
      {
         console.log(this,"streamSeekHandler");
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            this.var_9.ɇ.start(this._initData);
         }
         this.var_10.start(this._initData);
      }
      
      public function getTNRange(param1:String) : Array
      {
         return this._groupList.getTNRange(param1);
      }
      
      public function getPNRange(param1:String) : Array
      {
         return this._groupList.getPNRange(param1);
      }
      
      public function method_17() : Array
      {
         return this._groupList.method_17();
      }
      
      public function method_18(param1:Piece) : void
      {
         this._groupList.method_134(param1);
      }
      
      public function method_19() : class_1
      {
         var _loc1_:* = NaN;
         var _loc2_:Piece = null;
         if((this._groupList.name_2) && this._groupList.name_2.length > 0)
         {
            _loc1_ = Math.floor(Math.random() * this._groupList.name_2.length);
            _loc2_ = this._groupList.name_2[_loc1_]["piece"] as Piece;
            if(_loc2_)
            {
               if((this._groupList.name_2) && (this._groupList.name_2[_loc1_]) && (this._groupList.name_2[_loc1_]["blockID"]))
               {
                  console.log(this,"getCDNRandomTask:" + _loc2_.pieceKey);
                  return this._groupList.method_24(this._groupList.name_2[_loc1_]["piece"]["groupID"],this._groupList.name_2[_loc1_]["blockID"]);
               }
               return null;
            }
         }
         return null;
      }
      
      public function method_20(param1:Array) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Piece = null;
         var _loc4_:* = 0;
         var _loc5_:Object = null;
         if((this._groupList.name_2 && this._groupList.name_2.length > 0) && (param1) && param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._groupList.name_2.length)
            {
               _loc3_ = this._groupList.name_2[_loc2_]["piece"] as Piece;
               if(_loc3_)
               {
                  _loc4_ = 0;
                  while(_loc4_ < param1.length)
                  {
                     _loc5_ = param1[_loc4_];
                     if(_loc3_.groupID == _loc5_.groupID && _loc3_.pieceKey == _loc5_.pieceKey && _loc3_.type == _loc5_.type)
                     {
                        this._groupList.name_2.splice(_loc2_,1);
                        break;
                     }
                     _loc4_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function method_21() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = new Array();
         if((this._groupList.name_2) && this._groupList.name_2.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._groupList.name_2.length)
            {
               _loc1_.push((this._groupList.name_2[_loc2_]["piece"] as Piece).method_52());
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function method_22(param1:String, param2:Number) : Number
      {
         if(null == this._groupList)
         {
            return -1;
         }
         return this._groupList.method_22(param1,param2);
      }
      
      public function method_23(param1:Clip, param2:Number = 0, param3:Array = null, param4:Array = null) : void
      {
         if(LiveVodConfig.canChangeM3U8)
         {
            return;
         }
         if(!param1)
         {
            return;
         }
         if(param1.pieceInfoArray.length == 0)
         {
            if(param1.timestamp < LiveVodConfig.var_270)
            {
               return;
            }
            console.log(this,"LiveVodConfig.canChangeM3U8 = true");
            LiveVodConfig.canChangeM3U8 = true;
            LiveVodConfig.changeBlockId = param1.timestamp;
            return;
         }
         LiveVodConfig.changeBlockPreId = param1.timestamp;
         this._groupList.method_133(param1,param2,param3,param4);
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            if(LiveVodConfig.currentVid == param1.groupID && param1.nextID == -1)
            {
               LiveVodConfig.LAST_TS_ID = param1.timestamp;
            }
         }
         var _loc5_:Object = new Object();
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            Statistic.method_261().method_90(_loc5_);
         }
      }
      
      public function method_5(param1:Object) : Piece
      {
         if(null != this._groupList)
         {
            return this._groupList.method_5(param1);
         }
         return null;
      }
      
      public function method_24(param1:String, param2:Number, param3:Boolean = false) : class_1
      {
         if(null == this._groupList)
         {
            return null;
         }
         if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE && (this._initData.var_57) && param2 == 0))
         {
            if(!param3)
            {
               var param2:Number = this._groupList.method_22(param1,param2);
               if(-1 == param2)
               {
                  return null;
               }
            }
            return this._groupList.method_24(param1,param2);
         }
         return this._groupList.method_140(param1);
      }
      
      public function method_25(param1:String, param2:Number) : class_1
      {
         if(null == this._groupList)
         {
            return null;
         }
         var _loc3_:Number = this._groupList.method_138(param1,param2);
         if(-1 == _loc3_)
         {
            return null;
         }
         return this._groupList.method_24(param1,_loc3_);
      }
      
      public function method_26(param1:Number, param2:Number) : void
      {
         this._reportDownloadError.method_26(param1,param2);
      }
      
      public function method_27() : void
      {
         this._reportDownloadError.method_27();
      }
      
      public function method_28(param1:Number, param2:Number) : void
      {
         this._reportDownloadError.method_28(param1,param2);
      }
      
      public function method_29() : void
      {
         this._reportDownloadError.method_29();
      }
      
      public function method_30(param1:String) : void
      {
         this.var_10.method_30(param1);
      }
      
      public function clear() : void
      {
         console.log(this,"clear");
         EventWithData.method_261().removeEventListener(NETSTREAM_PROTOCOL.PLAY,this.streamPlayHandler);
         EventWithData.method_261().removeEventListener(NETSTREAM_PROTOCOL.SEEK,this.streamSeekHandler);
         this._groupList.clear();
         this.var_9.ɇ.clear();
         this.var_10.clear();
         this.var_11.clear();
         this.var_10 = null;
         this._initData = null;
         this._groupList = null;
         this.var_9 = null;
         this.var_11 = null;
         this._reportDownloadError = null;
      }
      
      public function get method_31() : Number
      {
         return LiveVodConfig.TOTAL_PIECE;
      }
      
      public function method_32(param1:String) : Object
      {
         return this._groupList.method_32(param1);
      }
      
      public function method_33(param1:String) : Object
      {
         return this._groupList.method_33(param1);
      }
      
      public function method_34(param1:String) : Array
      {
         return this._groupList.method_34(param1);
      }
      
      public function method_35() : Number
      {
         return LiveVodConfig.ADD_DATA_TIME;
      }
      
      public function method_36() : String
      {
         return LiveVodConfig.TYPE;
      }
      
      public function method_37() : uint
      {
         return LiveVodConfig.method_262;
      }
      
      public function method_38() : Number
      {
         return this.var_10.method_155;
      }
      
      public function method_39() : Object
      {
         if((LiveVodConfig.method_267 > LiveVodConfig.ADD_DATA_TIME + 2100 || true == LiveVodConfig.IS_CHANGE_KBPS) && LiveVodConfig.TYPE == LiveVodConfig.LIVE && false == LiveVodConfig.IS_SEEKING)
         {
            return null;
         }
         return this.var_10.method_39();
      }
      
      public function method_40() : Array
      {
         return null;
      }
      
      public function method_41(param1:String) : Number
      {
         return this._groupList.method_41(param1);
      }
   }
}
