package com.letv.plugins.kernel.model.special
{
   import com.letv.plugins.kernel.controller.auth.transfer.TransferResult;
   import com.letv.pluginsAPI.kernel.PayType;
   import com.letv.pluginsAPI.kernel.DefinitionType;
   import com.letv.plugins.kernel.Kernel;
   
   public class TransferData extends Object
   {
      
      private static var _instance:TransferData;
      
      private var _trylook:Boolean;
      
      private var _trylookType:String = "-1";
      
      private var _listVip:Array;
      
      private var _listFree:Array;
      
      private var _listTotal:Array;
      
      public function TransferData()
      {
         super();
      }
      
      public static function getInstance() : TransferData
      {
         if(_instance == null)
         {
            _instance = new TransferData();
         }
         return _instance;
      }
      
      public function flush(param1:TransferResult) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         if(param1 != null)
         {
            _loc2_ = (param1.trylook) || 0;
            this._trylook = _loc2_ >= 3;
            switch(_loc2_)
            {
               case 0:
                  this._trylookType = PayType.FREE;
                  break;
               case 3:
                  this._trylookType = PayType.MONTH;
                  break;
               case 4:
                  this._trylookType = PayType.VOD;
                  break;
               case 5:
                  this._trylookType = PayType.VOD_MONTH;
                  break;
               default:
                  this._trylookType = PayType.VOD_MONTH;
            }
            _loc3_ = param1.paylist;
            _loc4_ = {};
            _loc6_ = _loc3_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_ = String(_loc3_[_loc7_]);
               _loc4_[_loc5_] = true;
               _loc7_++;
            }
            this._listFree = [];
            this._listVip = [];
            this._listTotal = DefinitionType.STACK;
            _loc6_ = this._listTotal.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_ = String(this._listTotal[_loc7_]);
               if(_loc4_[_loc5_])
               {
                  this._listVip.push(_loc5_);
               }
               else
               {
                  this._listFree.push(_loc5_);
               }
               _loc7_++;
            }
            Kernel.sendLog("ServicePayList free:" + this._listFree.toString() + " vip:" + this._listVip.toString());
         }
         else
         {
            this._trylook = false;
            this._trylookType = PayType.FREE;
            this._listVip = DefinitionType.VIP_QUEUE;
            this._listFree = DefinitionType.FREE_STACK;
            this._listTotal = DefinitionType.STACK;
         }
      }
      
      public function get trylook() : Boolean
      {
         return this._trylook;
      }
      
      public function get trylookType() : String
      {
         return this._trylookType;
      }
      
      public function get listVip() : Array
      {
         return this._listVip;
      }
      
      public function get listFree() : Array
      {
         return this._listFree;
      }
      
      public function get listTotal() : Array
      {
         return this._listTotal;
      }
      
      public function isPayD(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         if(this._listVip == null || this._listVip.length == 0)
         {
            return false;
         }
         while(_loc2_ < this._listVip.length)
         {
            if(this._listVip[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}
