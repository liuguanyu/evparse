package com.utl
{
   public class msgTipData extends Object
   {
      
      public var msgHtmlTxt:String = "";
      
      public var msgShow:Boolean = true;
      
      public var msgAutoHide:Boolean = true;
      
      public var msgSecond:Number = 5;
      
      public var msgCanReplace:Boolean = true;
      
      public function msgTipData(param1:String, param2:Boolean = true, param3:Boolean = true, param4:Number = 5, param5:Boolean = true)
      {
         super();
         this.msgHtmlTxt = param1;
         this.msgShow = param2;
         this.msgAutoHide = param3;
         this.msgSecond = param4;
         this.msgCanReplace = param5;
      }
   }
}
