package cn.pplive.player.view.source
{
   public class DtListItem extends Object
   {
      
      public var ft:Number;
      
      public var addr:Array;
      
      public var st:Number;
      
      public var id:String;
      
      public var bwt:Number;
      
      public var key:String;
      
      public function DtListItem(param1:Number, param2:Array, param3:Number, param4:String, param5:Number, param6:String)
      {
         super();
         this.ft = param1;
         this.addr = param2;
         this.st = param3;
         this.id = param4;
         this.bwt = param5;
         this.key = param6;
      }
   }
}
