package org.puremvc.as3.multicore.utilities.fabrication.vo
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class InterceptorMapping extends Object implements IDisposable
   {
      
      public var noteName:String;
      
      public var clazz:Class;
      
      public var parameters:Object;
      
      public function InterceptorMapping(param1:String, param2:Class, param3:Object = null)
      {
         super();
         this.noteName = param1;
         this.clazz = param2;
         this.parameters = param3;
      }
      
      public function dispose() : void
      {
         this.noteName = null;
         this.clazz = null;
         this.parameters = null;
      }
   }
}
