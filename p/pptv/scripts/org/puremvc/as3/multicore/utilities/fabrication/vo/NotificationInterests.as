package org.puremvc.as3.multicore.utilities.fabrication.vo
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class NotificationInterests extends Object implements IDisposable
   {
      
      public var classpath:String;
      
      public var interests:Array;
      
      public var qualifications:Object;
      
      public function NotificationInterests(param1:String, param2:Array, param3:Object)
      {
         super();
         this.classpath = param1;
         this.interests = param2;
         this.qualifications = param3;
      }
      
      public function dispose() : void
      {
         this.classpath = null;
         this.interests = null;
         this.qualifications = null;
      }
   }
}
