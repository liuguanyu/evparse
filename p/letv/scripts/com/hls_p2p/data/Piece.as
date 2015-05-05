package com.hls_p2p.data
{
   import flash.utils.ByteArray;
   import com.hls_p2p.loaders.cdnLoader.CDNRateStrategy;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.p2p.utils.CheckSum;
   import com.p2p.utils.console;
   import com.hls_p2p.statistics.Statistic;
   
   public class Piece extends Object
   {
      
      public var isDebug:Boolean = false;
      
      private var var_8:class_3;
      
      public var id:int = 0;
      
      public var pieceKey:String = "";
      
      public var type:String = "PN";
      
      public var groupID:String = "";
      
      public var var_2:String = "";
      
      private var var_22:ByteArray;
      
      public var from:String = "";
      
      public var iLoadType:int = 0;
      
      public var name_1:Boolean = false;
      
      public var checkSum:String = "";
      
      public var size:Number = 0;
      
      public var peerID:String = "";
      
      public var var_23:Number = 0;
      
      public var end:Number = 0;
      
      private var var_24:int = 0;
      
      public var duration:Number = 0;
      
      public var var_25:Boolean = false;
      
      public var clientType:String = "PC";
      
      public var protocol:String = "rtmfp";
      
      public var blockIDArray:Array;
      
      public var var_26:int = 0;
      
      private var var_27:Object = null;
      
      public function Piece(param1:class_3)
      {
         this.var_22 = new ByteArray();
         this.blockIDArray = new Array();
         super();
         this.var_8 = param1;
      }
      
      public function set method_46(param1:int) : void
      {
         this.var_24 = this.var_24 + param1;
         CDNRateStrategy.method_261().method_44(this.size);
      }
      
      public function get method_46() : int
      {
         return this.var_24;
      }
      
      private function method_47(param1:ByteArray = null) : Boolean
      {
         var _loc2_:uint = 0;
         if(param1.length == this.size)
         {
            if(LiveVodConfig.IS_DRM)
            {
               var param1:ByteArray = this.var_8.drm.decryptSream(param1,this.blockIDArray[0]);
            }
            _loc2_ = new CheckSum().checkSum(param1);
            if(uint(this.checkSum) == _loc2_)
            {
               if((LiveVodConfig.IS_DRM) && this.id == 0)
               {
                  this.var_8.firstTsPieceOk = true;
                  console.log(this,"first ts `s piece is decrypt!");
               }
               return true;
            }
            trace(this,"checkSum有问题！！ " + this.id + ",key=" + this.pieceKey + ",CS=" + this.checkSum + ",CV=" + _loc2_,this.blockIDArray);
            console.log(this,"checkSum有问题！！ " + this.id + ",key=" + this.pieceKey + ",CS=" + this.checkSum + ",CV=" + _loc2_,this.blockIDArray);
            if(this.from == "http")
            {
               if(this.var_26++ >= 10)
               {
                  this.var_26 = 10;
               }
               else
               {
                  this.var_26;
               }
               Statistic.method_261().method_117("CDN CS Error " + this.id + ",key=" + this.pieceKey + ",bID=" + this.blockIDArray + ",CS=" + this.checkSum + ",CV=" + _loc2_);
            }
            else
            {
               Statistic.method_261().method_117("P2P CS Error " + this.id + ",key=" + this.pieceKey + ",bID=" + this.blockIDArray + ",CS=" + this.checkSum + ",CV=" + _loc2_);
            }
         }
         else
         {
            trace(this,"size有问题！！ " + this.id + " s=" + this.size + " l=" + param1.length,this.blockIDArray);
            console.log(this,"size有问题！！ " + this.id + " s=" + this.size + " l=" + param1.length,this.blockIDArray);
            if(this.from == "http")
            {
               if(this.var_26++ >= 10)
               {
                  this.var_26 = 10;
               }
               else
               {
                  this.var_26;
               }
               Statistic.method_261().method_117("CDN SIZE Error " + this.id + ",key=" + this.pieceKey + ",bID=" + this.blockIDArray + ",s=" + this.size + ",l=" + param1.length);
            }
            else
            {
               Statistic.method_261().method_117("P2P SIZE Error " + this.id + ",key=" + this.pieceKey + ",bID=" + this.blockIDArray + ",s=" + this.size + ",l=" + param1.length);
            }
         }
         return false;
      }
      
      public function method_48(param1:ByteArray, param2:String = "", param3:String = "PC") : Boolean
      {
         var _loc4_:String = null;
         if(this.var_22.length == 0 && this.name_1 == false && (this.method_47(param1)))
         {
            param1.position = 0;
            this.var_22.clear();
            param1.readBytes(this.var_22);
            console.log(this,"piece ok :" + this.id + " pKey:" + this.pieceKey + " bID:" + this.blockIDArray + ", gID:" + String(this.groupID).substr(0,5) + ", " + this.type + ", " + this.size + ", _stream.length" + this.var_22.length);
            this.var_8.name_3 = this.var_8.name_3 + this.size;
            this.var_8.method_131(this.size);
            if("TN" == this.type)
            {
               this.var_8.addTNRange(this.groupID,Number(this.pieceKey));
            }
            else if("PN" == this.type)
            {
               this.var_8.addPNRange(this.groupID,Number(this.pieceKey));
            }
            
            this.name_1 = true;
            this.iLoadType = 3;
            this.var_8.method_141();
            if(true == this.var_25)
            {
               this.var_8.method_134(this);
            }
            if(!(param2 == "") && this.peerID == "")
            {
               this.peerID = param2;
            }
            this.clientType = param3;
            this.method_49();
            return true;
         }
         if(!this.name_1)
         {
            _loc4_ = "";
            if(this.from == "http")
            {
               _loc4_ = "cdn";
            }
            else
            {
               _loc4_ = this.peerID;
            }
            this.method_51();
         }
         return false;
      }
      
      private function method_49() : void
      {
         var _loc1_:* = "";
         if(this.type == "TN")
         {
            _loc1_ = "TN_";
         }
         if(this.from == "http")
         {
            if(this.var_25)
            {
               _loc1_ = String("R_" + _loc1_);
            }
            Statistic.method_261().method_42(_loc1_ + this.blockIDArray + "_" + this.pieceKey,this.var_23,this.end,this.size,this.groupID);
            CDNRateStrategy.method_261().method_42(this.size);
         }
         else
         {
            this.end = new Date().time;
            Statistic.method_261().method_110(_loc1_ + this.blockIDArray + "_" + this.pieceKey,this.var_23,this.end,this.size,this.peerID,this.groupID,this.clientType,this.protocol);
            CDNRateStrategy.method_261().method_43(this.size);
         }
      }
      
      public function method_50() : ByteArray
      {
         return this.var_22;
      }
      
      public function method_51() : void
      {
         this.var_23 = 0;
         this.end = 0;
         this.iLoadType = 0;
         this.peerID = "";
         this.from = "";
         this.name_1 = false;
         if(this.var_22.length > 0)
         {
            if("TN" == this.type)
            {
               this.var_8.deleteTNRange(this.groupID,Number(this.pieceKey));
            }
            else if("PN" == this.type)
            {
               this.var_8.deletePNRange(this.groupID,Number(this.pieceKey));
            }
            
            this.var_8.name_3 = this.var_8.name_3 - this.var_22.length;
            this.var_8.method_132(this.var_22.length);
            Statistic.method_261().method_116("reset:" + String(this.groupID).substr(0,5) + "_" + " bID:" + this.blockIDArray[0] + "pID:" + this.id + "->" + Math.round(this.var_8.name_3 / (1024 * 1024)) + "->" + this.var_8.var_91.length);
         }
         console.log(this,"resetPiece:" + this.id + " pKey:" + this.pieceKey + " bID:",this.blockIDArray,this.type,this.size);
         this.var_22.clear();
      }
      
      public function reset(param1:Number) : void
      {
         if(!(-1 == this.blockIDArray.indexOf(param1)) && this.blockIDArray.length > 1)
         {
            return;
         }
         this.method_51();
      }
      
      public function method_52() : Object
      {
         if(null == this.var_27)
         {
            this.var_27 = {
               "groupID":this.groupID,
               "pieceKey":this.pieceKey,
               "type":this.type
            };
         }
         return this.var_27;
      }
      
      public function clear(param1:Number) : void
      {
         if(-1 != this.blockIDArray.indexOf(param1))
         {
            this.blockIDArray.splice(this.blockIDArray.indexOf(param1),1);
            if(this.blockIDArray.length != 0)
            {
               return;
            }
         }
         this.method_51();
         this.id = 0;
         this.pieceKey = "";
         this.type = "PN";
         this.groupID = "";
         this.size = 0;
         this.var_8 = null;
         this.checkSum = "";
         this.var_27 = null;
      }
   }
}
