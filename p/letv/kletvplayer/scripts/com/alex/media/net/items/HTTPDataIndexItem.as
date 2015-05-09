package com.alex.media.net.items
{
   public class HTTPDataIndexItem extends HTTPIndexItem
   {
      
      public function HTTPDataIndexItem(param1:Object, param2:int = 0)
      {
         super(param1,param2);
      }
      
      override protected function init(param1:Object, param2:int = 0) : void
      {
         var var_3:Object = param1;
         var var_4:int = param2;
         _index = var_4;
         try
         {
            _url = var_3.url;
            if(_url.indexOf("?") != -1)
            {
               _url = _url + ("&rstart=" + var_3.startOffset);
            }
            else
            {
               _url = _url + ("?rstart=" + var_3.startOffset);
            }
            if(var_3.stopOffset > 0)
            {
               _url = _url + ("&rend=" + var_3.stopOffset);
            }
         }
         catch(e:Error)
         {
         }
         _startTime = var_3.startTime;
         _stopTime = var_3.stopTime;
         _duration = _stopTime - _startTime;
      }
   }
}
