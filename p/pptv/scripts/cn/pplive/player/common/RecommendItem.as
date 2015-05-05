package cn.pplive.player.common
{
   public class RecommendItem extends Object
   {
      
      public var id:String;
      
      public var title:String;
      
      public var capture:String;
      
      public var link:String;
      
      public function RecommendItem(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         this.id = param1;
         this.title = param2;
         this.capture = param3;
         this.link = param4;
      }
   }
}
