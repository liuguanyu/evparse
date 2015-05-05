package com.hls_p2p.data.vo
{
   import com.p2p.utils.console;
   import com.p2p.utils.TimeTranslater;
   
   public dynamic class class_2 extends Object
   {
      
      public var isDebug:Boolean = true;
      
      private var var_38:Number = 0;
      
      private var var_39:String;
      
      private var var_40:String;
      
      private var var_41:Array;
      
      private var var_42:Array;
      
      private var var_43:Array;
      
      private var var_44:Array;
      
      private var var_45:Array;
      
      private var var_46:String;
      
      private var var_47:Number = 0;
      
      private var var_48:String = "";
      
      private var var_49:String = "";
      
      public var var_50:Object;
      
      public var g_nM3U8Idx:int = 0;
      
      public var var_51:int = 0;
      
      public var var_52:Boolean = false;
      
      public var var_53:Boolean = false;
      
      public var var_54:Boolean = false;
      
      public var var_55:Number = 0;
      
      private var _adRemainingTime:Number = 0;
      
      private var var_56:Number = 0;
      
      public var reportVar:Object = null;
      
      public var var_57:Boolean = true;
      
      public var var_58:Array;
      
      private var var_59:Number = -1;
      
      private var var_60:Number = 0;
      
      private var var_61:int = 0;
      
      private var var_28:Number = 0;
      
      private var var_29:Number = 0;
      
      public var totalDuration:Number = 0;
      
      public var mediaDuration:Number = 0;
      
      public var var_62:Number = 0;
      
      public var var_63:Number = 0;
      
      public var totalSize:Number = 0;
      
      public var var_64:Number = 0;
      
      public var var_65:Object = null;
      
      private var var_66:int = -1;
      
      private var var_67:Array;
      
      private var var_68:Array;
      
      private var var_69:Array;
      
      private var var_70:Boolean = false;
      
      private var var_71:int = 4;
      
      public function class_2()
      {
         this.var_58 = new Array();
         super();
      }
      
      public function method_58(param1:Number) : void
      {
         this._adRemainingTime = param1;
         this.var_56 = this.getTime();
      }
      
      public function method_59() : Number
      {
         var _loc1_:Number = this._adRemainingTime - (this.getTime() - this.var_56);
         if(_loc1_ <= 0)
         {
            return 0;
         }
         return _loc1_;
      }
      
      public function method_60() : Boolean
      {
         if(this.method_59() <= LiveVodConfig.var_288 * 1000)
         {
            return false;
         }
         return true;
      }
      
      public function method_61(param1:Number) : void
      {
         this.var_59 = param1;
         this.var_60 = this.getTime();
      }
      
      public function method_62() : Boolean
      {
         if(this.var_59 >= 0 && this.getTime() - this.var_60 >= this.var_59)
         {
            return true;
         }
         return false;
      }
      
      public function method_63() : Boolean
      {
         console.log(this,"_pieceFailedCount = " + this.var_61);
         if(this.var_61 >= 3)
         {
            return true;
         }
         return false;
      }
      
      public function method_64(param1:Number, param2:Number) : void
      {
         console.log(this,"LiveVodConfig.BlockID = " + LiveVodConfig.BlockID + ", bID = " + param1);
         console.log(this,"LiveVodConfig.PieceID = " + LiveVodConfig.var_279 + ", pID = " + param2);
         if(this.var_28 == LiveVodConfig.BlockID && this.var_29 == LiveVodConfig.var_279)
         {
            if(LiveVodConfig.BlockID == param1 && LiveVodConfig.var_279 == param2)
            {
               console.log(this,"LiveVodConfig.BlockID = " + LiveVodConfig.BlockID);
               console.log(this,"LiveVodConfig.PieceID = " + LiveVodConfig.var_279);
               console.log(this,"getAdRemainingTime() + " + this.method_59());
               this.var_61++;
            }
         }
         else
         {
            if(LiveVodConfig.BlockID == param1 && LiveVodConfig.var_279 == param2)
            {
               this.var_61++;
            }
            else
            {
               console.log(this,"_pieceFailedCount = 0 LiveVodConfig.BlockID = " + LiveVodConfig.BlockID);
               console.log(this,"_pieceFailedCount = 0 LiveVodConfig.PieceID = " + LiveVodConfig.var_279);
               this.var_61 = 0;
            }
            this.var_28 = LiveVodConfig.BlockID;
            this.var_29 = LiveVodConfig.var_279;
         }
      }
      
      public function get gslbURL() : String
      {
         return this.var_48;
      }
      
      public function set gslbURL(param1:String) : void
      {
         var param1:String = this.replaceParam(param1,"expect","3");
         param1 = this.replaceParam(param1,"format","2");
         this.var_48 = param1;
      }
      
      public function get method_65() : String
      {
         return this.var_40;
      }
      
      public function set method_65(param1:String) : void
      {
         this.var_40 = param1;
      }
      
      public function get url() : String
      {
         return this.var_46;
      }
      
      public function set url(param1:String) : void
      {
         this.var_46 = param1;
      }
      
      public function get groupName() : String
      {
         return this.var_39;
      }
      
      public function set groupName(param1:String) : void
      {
         this.var_39 = param1;
      }
      
      public function method_66(param1:int) : void
      {
         this.var_66 = param1;
      }
      
      public function method_67() : int
      {
         this.var_66++;
         if(this.var_66 == this.flvURL.length)
         {
            this.var_66 = 0;
         }
         return this.var_66;
      }
      
      public function get flvURL() : Array
      {
         return this.var_41;
      }
      
      public function set flvURL(param1:Array) : void
      {
         this.var_41 = null;
         this.var_41 = param1;
      }
      
      public function get playLevelArr() : Array
      {
         return this.var_42;
      }
      
      public function get method_68() : Array
      {
         return this.var_67;
      }
      
      public function get method_69() : Array
      {
         return this.var_68;
      }
      
      public function get method_70() : Array
      {
         return this.var_69;
      }
      
      public function method_71(param1:Array) : void
      {
         this.var_69 = param1;
         this.var_67 = new Array();
         this.var_68 = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this.var_69.length)
         {
            this.var_67.push(this.var_69[_loc2_]["location"]);
            this.var_68.push(this.var_69[_loc2_]["playlevel"]);
            _loc2_++;
         }
         this.var_43 = null;
         this.var_44 = null;
         this.var_45 = null;
         this.g_nM3U8Idx = 0;
         this.var_53 = false;
         this.var_54 = false;
         this.var_52 = false;
      }
      
      public function method_72() : void
      {
         this.var_69 = null;
         this.var_67 = null;
         this.var_68 = null;
         this.var_62 = 0;
         this.var_63 = 0;
         this.var_64 = 0;
      }
      
      public function changeKBPSSuccess() : void
      {
         this.cdnInfo = this.method_70;
         if(this.var_64 > 0)
         {
            this.totalSize = this.var_64;
         }
         this.var_69 = null;
         this.var_67 = null;
         this.var_68 = null;
         this.var_62 = 0;
         this.var_63 = 0;
         this.var_64 = 0;
      }
      
      public function get method_73() : Array
      {
         return this.var_43;
      }
      
      public function set method_73(param1:Array) : void
      {
         this.var_43 = null;
         this.var_43 = param1;
      }
      
      public function set cdnInfo(param1:Array) : void
      {
         var _loc2_:* = 0;
         if(param1)
         {
            this.var_41 = new Array();
            this.var_42 = new Array();
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.var_41.push(param1[_loc2_]["location"]);
               this.var_42.push(param1[_loc2_]["playlevel"]);
               if(param1[_loc2_]["kbps"])
               {
                  this.var_49 = String(param1[_loc2_]["kbps"]);
               }
               _loc2_++;
            }
            trace(this,"_flvURL = " + this.var_41);
         }
      }
      
      public function get kbps() : String
      {
         return this.var_49;
      }
      
      public function set kbps(param1:String) : void
      {
         this.var_49 = param1;
      }
      
      public function set method_74(param1:Array) : void
      {
         this.var_44 = null;
         this.var_44 = param1;
         this.var_43 = new Array();
         this.var_45 = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this.var_44.length)
         {
            this.var_43.push(this.var_44[_loc2_]["location"]);
            this.var_45.push(this.var_44[_loc2_]["playlevel"]);
            _loc2_++;
         }
      }
      
      public function get playlevel() : int
      {
         if((this.var_42) && (this.var_42[this.g_nM3U8Idx]))
         {
            return this.var_42[this.g_nM3U8Idx];
         }
         return 4;
      }
      
      public function set playlevel(param1:int) : void
      {
         this.var_71 = param1;
      }
      
      public function get startTime() : Number
      {
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            if((this.var_38 == 0 || this.var_38 > this.var_47 - LiveVodConfig.var_273) && this.var_47 > 0)
            {
               this.var_38 = this.var_47 - LiveVodConfig.var_273;
            }
         }
         return this.var_38;
      }
      
      public function get method_75() : Number
      {
         return this.var_38;
      }
      
      public function set startTime(param1:Number) : void
      {
         this.var_38 = param1;
      }
      
      public function set serverCurtime(param1:Number) : void
      {
         this.var_47 = param1;
         console.log(this,"serverCurtime" + TimeTranslater.getTime(this.var_47),this.var_47);
      }
      
      public function get serverCurtime() : Number
      {
         return this.var_47;
      }
      
      protected function method_76(param1:Array) : Array
      {
         var _loc4_:String = null;
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_.indexOf("p2p=1") != -1)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function replaceParam(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:RegExp = new RegExp("[?&]" + param2 + "=(\\w{0,})?","");
         var _loc5_:* = "";
         if(_loc4_.test(param1))
         {
            _loc5_ = param1.match(_loc4_)[0];
         }
         if(_loc5_.length > 0)
         {
            var param1:String = param1.replace(_loc5_,_loc5_.charAt(0) + param2 + "=" + param3);
         }
         return param1;
      }
      
      private function getTime() : Number
      {
         return new Date().time;
      }
   }
}
