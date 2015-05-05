package com.hls_p2p.loaders.p2pLoader
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.dataManager.DataManager;
   import com.p2p.utils.console;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.statistics.Statistic;
   import com.hls_p2p.data.Piece;
   
   public class P2P_Cluster extends Object
   {
      
      public var isDebug:Boolean = true;
      
      protected var var_171:Object;
      
      protected var initData:class_2;
      
      protected var var_172:DataManager = null;
      
      public var var_173:Boolean = false;
      
      public var var_174:Boolean = false;
      
      protected var var_175:String = "";
      
      protected var var_176:uint;
      
      protected var var_177:Boolean = false;
      
      public function P2P_Cluster()
      {
         super();
      }
      
      public function initialize(param1:class_2, param2:DataManager) : void
      {
         if(null == this.var_172)
         {
            this.var_171 = new Object();
            this.initData = param1;
            this.var_172 = param2;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = 0;
         console.log(this,"clear");
         for(_loc1_ in this.var_171)
         {
            if((this.var_171[_loc1_]) && this.var_171[_loc1_].length > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < this.var_171[_loc1_].length)
               {
                  if(this.var_171[_loc1_][_loc2_])
                  {
                     this.var_171[_loc1_][_loc2_].clear();
                     this.var_171[_loc1_][_loc2_] = null;
                  }
                  _loc2_++;
               }
            }
            delete this.var_171[_loc1_];
            true;
         }
         this.var_171 = null;
         this.initData = null;
         this.var_172 = null;
      }
      
      public function method_198(param1:String) : Boolean
      {
         var _loc3_:* = 0;
         var _loc2_:* = false;
         if(this.var_171[param1])
         {
            _loc3_ = 0;
            while(_loc3_ < (this.var_171[param1] as Array).length)
            {
               if(this.var_171[param1][_loc3_].ifPeerConnection())
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function method_199() : void
      {
         console.log(this,"change to WS!");
         this.var_177 = true;
         var _loc1_:* = "";
         for(_loc1_ in this.var_171)
         {
            this.var_171[_loc1_][0].clear();
            this.var_171[_loc1_][0] = null;
            if((LiveVodConfig.var_274) && LiveVodConfig.var_275 == "s")
            {
               this.var_171[_loc1_] = null;
               delete this.var_171[_loc1_];
               true;
            }
         }
      }
      
      public function method_200(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Selector = null;
         var _loc4_:Selector = null;
         if(!this.method_201(param1))
         {
            this.var_171[param1] = new Array(2);
            _loc2_ = "rtmfp";
            if(!this.var_177)
            {
               if(_loc2_ == "rtmfp")
               {
                  _loc3_ = new Selector(param1,this.initData.geo,_loc2_,1);
               }
               else
               {
                  _loc3_ = new Selector(param1,this.initData.geo,_loc2_,0);
               }
               this.var_171[param1][0] = new P2P_Loader(this.var_172,this,_loc3_);
               this.var_171[param1][0].startLoadP2P(this.initData,param1);
               Statistic.method_261().method_86(param1,this.var_172.method_8(param1));
               if((LiveVodConfig.var_274) && LiveVodConfig.var_275 == "d")
               {
                  if(_loc2_ == "rtmfp")
                  {
                     _loc4_ = new Selector(param1,this.initData.geo,_loc2_,2);
                  }
                  else
                  {
                     _loc4_ = new Selector(param1,this.initData.geo,_loc2_,0);
                  }
                  this.var_171[param1][1] = new WebSocket_Loader(this.var_172,this,_loc4_);
                  this.var_171[param1][1].startLoadP2P(this.initData,param1,LiveVodConfig.resourceID);
                  _loc4_.load();
                  return;
               }
            }
            else if((LiveVodConfig.var_274) && LiveVodConfig.var_275 == "s")
            {
               _loc3_ = new Selector(param1,this.initData.geo,_loc2_,2);
               this.var_171[param1][0] = new WebSocket_Loader(this.var_172,this,_loc3_);
               this.var_171[param1][0].startLoadP2P(this.initData,param1,LiveVodConfig.resourceID);
               Statistic.method_261().method_86(param1,this.var_172.method_8(param1));
            }
            
            _loc3_.load();
         }
      }
      
      public function method_201(param1:String) : Boolean
      {
         if(this.var_171.hasOwnProperty(param1))
         {
            return true;
         }
         return false;
      }
      
      public function method_154(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = "";
         for(_loc2_ in this.var_171)
         {
            if(param1.indexOf(_loc2_) != -1)
            {
               _loc3_ = 0;
               while(_loc3_ < (this.var_171[_loc2_] as Array).length)
               {
                  this.var_171[_loc2_][_loc3_]["peerHartBeatTimer"]();
                  _loc3_++;
               }
            }
         }
      }
      
      public function method_202(param1:Array) : void
      {
         var _loc2_:* = "";
         for(_loc2_ in this.var_171)
         {
            if(param1.indexOf(_loc2_) == -1)
            {
               this.method_30(_loc2_);
               Statistic.method_261().method_87(_loc2_);
            }
         }
         for each(_loc2_ in param1)
         {
            if(!this.var_171.hasOwnProperty(_loc2_))
            {
               this.method_200(_loc2_);
            }
         }
      }
      
      public function method_30(param1:String) : void
      {
         var _loc2_:* = 0;
         if(this.method_201(param1))
         {
            _loc2_ = 0;
            while(_loc2_ < (this.var_171[param1] as Array).length)
            {
               if(this.var_171[param1][_loc2_])
               {
                  this.var_171[param1][_loc2_].clear();
               }
               _loc2_++;
            }
            this.var_171[param1] = null;
            delete this.var_171[param1];
            true;
         }
      }
      
      public function handlerPiece(param1:Piece) : void
      {
         if(this.method_201(param1.groupID))
         {
            if(this.var_171[param1.groupID][0])
            {
               this.var_171[param1.groupID][0].handlerPiece(param1);
            }
            else if(this.var_171[param1.groupID][0])
            {
               this.var_171[param1.groupID][1].handlerPiece(param1);
            }
            
         }
      }
   }
}
