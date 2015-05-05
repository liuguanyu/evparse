package cn.pplive.player.view.source
{
   public class DragListItem extends Object
   {
      
      public var br:Number;
      
      public var fs:Number;
      
      public var du:Number;
      
      public var vw:Number;
      
      public var vh:Number;
      
      public var ft:Number;
      
      public var sgm:Array;
      
      public function DragListItem(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Array)
      {
         super();
         this.br = param1;
         this.fs = param2;
         this.du = param3;
         this.vw = param4;
         this.vh = param5;
         this.ft = param6;
         this.sgm = param7;
      }
   }
}
