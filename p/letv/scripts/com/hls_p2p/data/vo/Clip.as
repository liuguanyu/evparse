package com.hls_p2p.data.vo
{
   public dynamic class Clip extends Object
   {
      
      public var timestamp:Number = -1;
      
      public var size:Number = -1;
      
      public var duration:Number = -1;
      
      public var groupID:String = "";
      
      public var var_2:String = "";
      
      public var name:String = "";
      
      public var url_ts:String = "";
      
      public var var_104:String;
      
      public var sequence:int = 0;
      
      public var var_105:int = 0;
      
      public var width:Number = 0;
      
      public var height:Number = 0;
      
      public var totalDuration:Number = 0;
      
      public var discontinuity:int = 0;
      
      public var var_106:Number = 0;
      
      public var pieceInfoArray:Array;
      
      public var nextID:Number = -1;
      
      public function Clip()
      {
         this.pieceInfoArray = new Array();
         super();
      }
   }
}
