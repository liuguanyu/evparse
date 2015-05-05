package com.hls_p2p.loaders
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.p2p.utils.console;
   
   public class ReportDownloadError extends Object
   {
      
      private var _initData:class_2;
      
      private var var_28:Number = -1;
      
      private var var_29:Number = -1;
      
      private var var_30:Number = -1;
      
      private var var_31:Number = -1;
      
      private var var_32:Number = 15000.0;
      
      private var var_33:Number = 15000.0;
      
      private var var_34:int = 0;
      
      private var var_35:int = 0;
      
      private var var_36:int = 3;
      
      private var var_37:int = 3;
      
      public function ReportDownloadError(param1:class_2)
      {
         super();
         this._initData = param1;
      }
      
      public function reset() : void
      {
         this.var_28 = 0;
         this.var_29 = 0;
         this.var_30 = -1;
         this.var_31 = -1;
         this.var_34 = 0;
         this.var_35 = 0;
      }
      
      public function clear() : void
      {
         this._initData = null;
         this.reset();
      }
      
      public function method_28(param1:Number, param2:Number) : void
      {
         if(param1 == LiveVodConfig.BlockID && param2 == LiveVodConfig.var_279)
         {
            if(!(this.var_28 == LiveVodConfig.BlockID) || !(this.var_29 == LiveVodConfig.var_279))
            {
               this.var_30 = this.getTime();
               this.var_34 = 0;
               this.var_28 = LiveVodConfig.BlockID;
               this.var_29 = LiveVodConfig.var_279;
            }
         }
      }
      
      public function method_29() : void
      {
         if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && this.var_31 == -1 && false == this._initData.var_53)
         {
            this.var_31 = this.getTime();
         }
      }
      
      public function method_53() : void
      {
         this.var_30 = -1;
         this.var_34 = 0;
      }
      
      public function method_54() : void
      {
         this.var_31 = -1;
         this.var_35 = 0;
      }
      
      public function method_26(param1:Number, param2:Number) : void
      {
         console.log(this,"LiveVodConfig.BlockID = " + LiveVodConfig.BlockID + ", bID = " + param1);
         trace(this,"1 LiveVodConfig.BlockID = " + LiveVodConfig.BlockID + ", bID = " + param1);
         trace(this,"downloadTSFailed .PieceID = " + LiveVodConfig.var_279 + ", pID = " + param2);
         if(this.var_28 == LiveVodConfig.BlockID)
         {
            if(LiveVodConfig.BlockID == param1)
            {
               console.log(this,"LiveVodConfig.BlockID = " + LiveVodConfig.BlockID);
               trace(this,"2 LiveVodConfig.BlockID = " + LiveVodConfig.BlockID + ", bID = " + param1);
               this.var_34++;
            }
         }
         else
         {
            if(LiveVodConfig.BlockID == param1)
            {
               trace(this,"3 LiveVodConfig.BlockID = " + LiveVodConfig.BlockID + ", bID = " + param1);
               this.var_34++;
            }
            this.var_28 = LiveVodConfig.BlockID;
            this.var_29 = LiveVodConfig.var_279;
         }
      }
      
      public function method_27() : void
      {
         this.var_35++;
      }
      
      public function method_55() : String
      {
         if(this.method_57())
         {
            return "m3u8";
         }
         if(this.method_56())
         {
            return "ts";
         }
         return "";
      }
      
      public function method_56() : Boolean
      {
         if(this.var_30 > -1 && this.getTime() - this.var_30 > this.var_32 && this._initData.flvURL.length > 0 && this.var_34 >= this._initData.flvURL.length)
         {
            return true;
         }
         return false;
      }
      
      public function method_57() : Boolean
      {
         if(this.var_31 > -1 && this.getTime() - this.var_31 > this.var_33 && this._initData.flvURL.length > 0 && this.var_35 >= this._initData.flvURL.length)
         {
            return true;
         }
         return false;
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
   }
}
