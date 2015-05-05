package com.hls_p2p.data
{
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.p2p.utils.console;
   import flash.utils.ByteArray;
   import com.hls_p2p.statistics.Statistic;
   
   public class class_1 extends Object
   {
      
      public var isDebug:Boolean = true;
      
      public var id:Number = -1;
      
      public var var_1:Number = -1;
      
      public var groupID:String = "";
      
      public var var_2:String = "";
      
      public var name:String = "";
      
      public var url_ts:String = "";
      
      public var duration:Number = 0;
      
      public var width:Number = 0;
      
      public var height:Number = 0;
      
      private var var_3:Number = -1;
      
      public var var_4:Number = 0;
      
      private var var_5:Boolean = false;
      
      public var var_6:Array;
      
      private var var_7:Object;
      
      private var var_8:class_3;
      
      public var discontinuity:int = 0;
      
      public var playerKbps:String = "";
      
      public function class_1(param1:class_3)
      {
         this.var_6 = new Array();
         this.var_7 = new Object();
         super();
         this.var_8 = param1;
         this.var_7 = this.var_8.method_130;
      }
      
      public function method_1() : Array
      {
         return this.var_8.flvURL;
      }
      
      public function set pieceInfoArray(param1:Array) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         if(this.var_6.length > 0)
         {
            return;
         }
         new ParsePiece_uniform(this.var_8).method_126(param1,this.groupID,this.var_2,this.var_7,this.var_6,this.id);
         if(this.var_6.length > 1)
         {
            _loc2_ = Math.ceil(this.duration / (this.var_6.length - 1) * 10) / 10;
            _loc3_ = 1;
            while(_loc3_ < this.var_6.length)
            {
               (this.method_5(this.var_6[_loc3_]) as Piece).duration = _loc2_;
               _loc3_++;
            }
         }
      }
      
      public function get pieceInfoArray() : Array
      {
         return this.var_6;
      }
      
      public function set size(param1:Number) : void
      {
         this.var_3 = param1;
      }
      
      public function get size() : Number
      {
         return this.var_3;
      }
      
      public function get name_1() : Boolean
      {
         if(!this.var_5)
         {
            this.var_5 = this.method_3();
         }
         return this.var_5;
      }
      
      public function method_2() : void
      {
         var _loc1_:* = 0;
         this.var_5 = true;
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            _loc1_ = LiveVodConfig.var_278[this.var_8.groupID].indexOf(this.id);
            if(-1 != _loc1_)
            {
               LiveVodConfig.var_278[this.var_8.groupID].splice(_loc1_,1);
            }
         }
         else
         {
            _loc1_ = LiveVodConfig.var_278[LiveVodConfig.currentVid].indexOf(this.id);
            if(-1 != _loc1_)
            {
               LiveVodConfig.var_278[LiveVodConfig.currentVid].splice(_loc1_,1);
            }
         }
      }
      
      private function method_3() : Boolean
      {
         var _loc1_:Piece = null;
         var _loc2_:* = undefined;
         var _loc3_:* = 0;
         if(false == this.var_5)
         {
            _loc1_ = null;
            for each(_loc2_ in this.var_6)
            {
               _loc1_ = this.var_8.method_5(_loc2_);
               if((_loc1_) && (_loc1_.name_1 == false) && _loc1_.var_26 <= 3)
               {
                  return false;
               }
            }
            if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
            {
               if(this.id == -1)
               {
                  console.log(this,"VOD error!!!! blockid is not -1");
               }
               else if((this.var_8) && (this.var_8.groupID) && (LiveVodConfig.var_278[this.var_8.groupID]))
               {
                  _loc3_ = LiveVodConfig.var_278[this.var_8.groupID].indexOf(this.id);
                  if(-1 != _loc3_)
                  {
                     LiveVodConfig.var_278[this.var_8.groupID].splice(_loc3_,1);
                     console.log(this,"del Taskcache " + String(this.var_8.groupID).substr(0,5) + ", bID = " + this.id);
                  }
               }
               
            }
            else if(this.id == -1)
            {
               console.log(this,"LIVE error!!!! blockid is not -1");
            }
            else
            {
               _loc3_ = LiveVodConfig.var_278[LiveVodConfig.currentVid].indexOf(this.id);
               if(-1 != _loc3_)
               {
                  LiveVodConfig.var_278[LiveVodConfig.currentVid].splice(_loc3_,1);
               }
            }
            
         }
         console.log(this,"check==true " + String(this.var_8.groupID).substr(0,5) + ", " + this.id);
         return true;
      }
      
      public function method_4() : ByteArray
      {
         var var_232:Piece = null;
         var var_292:ByteArray = null;
         var var_291:ByteArray = new ByteArray();
         var i:int = 0;
         while(i < this.var_6.length)
         {
            var_232 = this.var_8.method_5(this.var_6[i]);
            if(var_232)
            {
               var_292 = var_232.method_50();
               if(var_292.bytesAvailable > 0)
               {
                  try
                  {
                     var_292.position = 0;
                     var_291.position = var_291.length;
                     var_291.writeBytes(var_292,0,var_292.length);
                  }
                  catch(err:Error)
                  {
                     console.log(this,err);
                     return new ByteArray();
                  }
               }
               i++;
               continue;
            }
            return new ByteArray();
         }
         var_291.position = 0;
         if(var_291.length != this.size)
         {
            console.log(this,"blockSizeErr");
            return new ByteArray();
         }
         return var_291;
      }
      
      public function method_5(param1:uint) : Piece
      {
         if(param1 >= this.var_6.length)
         {
            return null;
         }
         return this.var_8.method_5(this.var_6[param1]);
      }
      
      private function method_6(param1:String, param2:uint, param3:Boolean = false) : void
      {
         if(!param3)
         {
            Statistic.method_261().method_125(String(this.id + "_" + param2 + "," + param1));
         }
         else
         {
            Statistic.method_261().method_125(param1);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:Piece = null;
         this.var_5 = false;
         var _loc2_:* = 0;
         while(_loc2_ < this.var_6.length)
         {
            _loc1_ = this.var_8.method_5(this.var_6[_loc2_]);
            if(_loc1_)
            {
               if(_loc1_.var_25)
               {
                  this.var_8.method_134(_loc1_);
               }
               this.var_8.method_139(_loc1_.method_52());
               _loc1_.clear(this.id);
               _loc1_ = null;
               delete this.var_6[_loc2_];
               true;
            }
            _loc2_++;
         }
         this.var_3 = 0;
         this.groupID = "";
         this.var_6 = null;
         this.var_7 = null;
         this.var_8 = null;
      }
      
      public function reset() : void
      {
         var _loc1_:Piece = null;
         this.var_5 = false;
         var _loc2_:* = 0;
         while(_loc2_ < this.var_6.length)
         {
            _loc1_ = this.var_8.method_5(this.var_6[_loc2_]);
            if(_loc1_)
            {
               _loc1_.reset(this.id);
            }
            _loc2_++;
         }
      }
   }
}
