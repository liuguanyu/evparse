package p2pstream.mango
{
   import flash.net.NetStream;
   import p2pstream.util.MD5;
   import flash.net.NetConnection;
   
   public class SSNetStream extends NetStream
   {
      
      public static var swcLoaded:Boolean = true;
      
      public static var probP2P:Number = 1;
      
      private var _nsMain = null;
      
      private var _useP2P:Boolean = true;
      
      public function SSNetStream(param1:NetConnection, param2:String = "connectToFMS")
      {
         super(param1,param2);
         this._useP2P = Math.random() < probP2P;
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain = new SSNetStreamMain(this);
            this._nsMain.init();
         }
      }
      
      public function set useP2P(param1:Boolean) : void
      {
         this._useP2P = param1;
      }
      
      public function get useP2P() : Boolean
      {
         return this._useP2P;
      }
      
      override public function set bufferTime(param1:Number) : void
      {
         super.bufferTime = param1;
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain.bufferTime = param1;
         }
      }
      
      function get super_time() : Number
      {
         return super.time;
      }
      
      override public function get time() : Number
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.time:this.super_time;
      }
      
      public function get totalUniqAppendBytes() : Number
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.totalUniqAppendBytes:0;
      }
      
      public function get totalAppendBytes() : Number
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.totalAppendBytes:0;
      }
      
      public function get totalSourceBytes() : Number
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.totalSourceBytes:0;
      }
      
      public function get totalPeerBytes() : Number
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.totalPeerBytes:0;
      }
      
      function get super_bytesLoaded() : uint
      {
         return super.bytesLoaded;
      }
      
      override public function get bytesLoaded() : uint
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.bytesLoaded:this.super_bytesLoaded;
      }
      
      function get super_bytesTotal() : uint
      {
         return super.bytesTotal;
      }
      
      override public function get bytesTotal() : uint
      {
         return (swcLoaded) && (this._useP2P)?this._nsMain.bytesTotal:this.super_bytesTotal;
      }
      
      function super_seek(param1:Number) : void
      {
         super.seek(param1);
      }
      
      override public function seek(param1:Number) : void
      {
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain.seek(param1);
         }
         else
         {
            this.super_seek(param1);
         }
      }
      
      private function apply_func(param1:Function, param2:Array) : void
      {
         switch(param2.length)
         {
            case 0:
               param1();
               break;
            case 1:
               param1(param2[0]);
               break;
            case 2:
               param1(param2[0],param2[1]);
               break;
            case 3:
               param1(param2[0],param2[1],param2[2]);
               break;
            case 4:
               param1(param2[0],param2[1],param2[2],param2[3]);
               break;
            case 5:
               param1(param2[0],param2[1],param2[2],param2[3],param2[4]);
               break;
            case 6:
               param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5]);
               break;
            case 7:
               param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6]);
               break;
            case 8:
               param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7]);
               break;
            case 9:
               param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8]);
               break;
         }
      }
      
      public function super_play(... rest) : void
      {
         this.apply_func(super.play,rest);
      }
      
      override public function play(... rest) : void
      {
         if((swcLoaded) && (this._useP2P))
         {
            this.apply_func(this._nsMain.play,rest);
         }
         else
         {
            this.apply_func(super.play,rest);
         }
      }
      
      override public function close() : void
      {
         super.close();
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain.close();
         }
      }
      
      function super_pause() : void
      {
         super.pause();
      }
      
      override public function pause() : void
      {
         this.super_pause();
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain.pause();
         }
      }
      
      function super_resume() : void
      {
         super.resume();
      }
      
      override public function resume() : void
      {
         this.super_resume();
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain.resume();
         }
      }
      
      override public function togglePause() : void
      {
         super.togglePause();
         if((swcLoaded) && (this._useP2P))
         {
            this._nsMain.togglePause();
         }
      }
      
      private function getCodedURL(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:RegExp = new RegExp("http:\\/\\/([^\\/]*)\\/([^\\&\\?]*)","i");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_[1];
            _loc5_ = _loc3_[2];
            _loc6_ = Math.floor(new Date().time / 1000).toString(16).toLowerCase();
            _loc7_ = MD5.hash("hcclw/" + _loc5_ + _loc6_);
            var param1:String = "http://" + _loc4_ + "/" + _loc5_ + "?wsSecret=" + _loc7_ + "&wsTime=" + _loc6_;
         }
         return param1;
      }
   }
}
