package com.alex.media.net.items
{
   import com.alex.utils.RichStringUtil;
   
   public class HTTPIndexItem extends Object
   {
      
      protected var _startTime:Number = 0;
      
      protected var _stopTime:Number = 0;
      
      protected var _duration:Number = 0;
      
      protected var _url:String;
      
      protected var _index:int;
      
      public function HTTPIndexItem(param1:Object, param2:int = 0)
      {
         super();
         this.init(param1,param2);
      }
      
      protected function init(param1:Object, param2:int = 0) : void
      {
         var content:String = null;
         var arr:Array = null;
         var firstIndex:int = 0;
         var var_3:Object = param1;
         var var_4:int = param2;
         this._index = var_4;
         try
         {
            content = String(var_3);
            arr = content.split("EXTINF:");
            content = String(arr[1]);
            content = RichStringUtil.removeNewlineOrEnter(content);
            content = RichStringUtil.removeNewlineOrEnter(content);
            firstIndex = content.indexOf(",");
            this._duration = Number(content.substring(0,firstIndex));
            content = content.substring(firstIndex + 1);
         }
         catch(e:Error)
         {
            _duration = 0;
         }
         try
         {
            this._url = RichStringUtil.trim(content);
         }
         catch(e:Error)
         {
            _url = null;
         }
      }
      
      public function set startTime(param1:Number) : void
      {
         this._startTime = param1;
         this._stopTime = this._startTime + this._duration;
      }
      
      public function get startTime() : Number
      {
         return this._startTime;
      }
      
      public function get stopTime() : Number
      {
         return this._stopTime;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}
