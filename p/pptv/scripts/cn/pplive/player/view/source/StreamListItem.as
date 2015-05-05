package cn.pplive.player.view.source
{
   public class StreamListItem extends Object
   {
      
      public var rid:String;
      
      public var bitrate:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var ft:Number;
      
      public var vip:String;
      
      public var dt:DtListItem;
      
      public var drag:DragListItem;
      
      public function StreamListItem(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:String, param7:DtListItem = null, param8:DragListItem = null)
      {
         super();
         this.rid = param1;
         this.bitrate = param2;
         this.width = param3;
         this.height = param4;
         this.ft = param5;
         this.vip = param6;
         this.dt = param7;
         this.drag = param8;
      }
   }
}
