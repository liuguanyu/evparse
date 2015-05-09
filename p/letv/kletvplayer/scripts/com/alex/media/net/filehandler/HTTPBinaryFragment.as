package com.alex.media.net.filehandler
{
   import flash.utils.ByteArray;
   import com.alex.media.net.items.HTTPIndexItem;
   import flash.utils.IDataInput;
   
   public class HTTPBinaryFragment extends ByteArray
   {
      
      private var _errorCode:int = -1;
      
      private var _httpCode:int = -1;
      
      private var _percent:Number = 0;
      
      private var _item:HTTPIndexItem;
      
      private var _isComplete:Boolean;
      
      private var _isLoading:Boolean;
      
      public function HTTPBinaryFragment(param1:HTTPIndexItem)
      {
         super();
         this._item = param1;
      }
      
      public function destroy() : void
      {
         this._item = null;
         this._percent = 0;
         this._errorCode = -1;
         this._isLoading = false;
         this._isComplete = false;
         if(this.length > 0)
         {
            clear();
         }
      }
      
      public function interrupt() : void
      {
         if(!this.isComplete)
         {
            position = 0;
            this._percent = 0;
            this._errorCode = -1;
            this._isLoading = false;
            this._isComplete = false;
            if(this.length > 0)
            {
               clear();
            }
         }
      }
      
      public function get bytes() : ByteArray
      {
         var _loc1_:ByteArray = null;
         if(this.bytesAvailable > 0)
         {
            _loc1_ = new ByteArray();
            this.readBytes(_loc1_,0,this.bytesAvailable);
            return _loc1_;
         }
         return null;
      }
      
      public function get item() : HTTPIndexItem
      {
         return this._item;
      }
      
      public function get index() : int
      {
         return this._item.index;
      }
      
      public function get url() : String
      {
         return this._item.url;
      }
      
      public function get stopTime() : Number
      {
         return this._item.stopTime;
      }
      
      public function get startTime() : Number
      {
         return this._item.startTime;
      }
      
      public function get duration() : Number
      {
         return this._item.duration;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function get isLoading() : Boolean
      {
         return this._isLoading;
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      public function get errorCode() : int
      {
         return this._errorCode;
      }
      
      public function get httpCode() : int
      {
         return this._httpCode;
      }
      
      public function flush(param1:IDataInput, param2:Number, param3:int = -1, param4:int = -1) : void
      {
         if(param1 == null)
         {
            this._isComplete = false;
            this.interrupt();
         }
         else if(param1.bytesAvailable > 0)
         {
            param1.readBytes(this,this.length,param1.bytesAvailable);
         }
         
         this._percent = param2;
         if(param3 >= 0)
         {
            this._httpCode = param4;
            this._errorCode = param3;
         }
         else if(this._percent < 1)
         {
            this._isLoading = true;
            this._isComplete = false;
         }
         else
         {
            this._isLoading = false;
            this._isComplete = true;
         }
         
      }
   }
}
