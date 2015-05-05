package org.as3commons.reflect
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   public class MethodInvoker extends Object
   {
      
      private var _method:String = "";
      
      private var _target;
      
      private var _arguments:Array;
      
      public function MethodInvoker()
      {
         super();
         _arguments = [];
      }
      
      public function get method() : String
      {
         return _method;
      }
      
      public function set target(param1:*) : void
      {
         _target = param1;
      }
      
      public function set method(param1:String) : void
      {
         _method = param1;
      }
      
      public function set arguments(param1:Array) : void
      {
         _arguments = param1;
      }
      
      public function get target() : *
      {
         return _target;
      }
      
      public function get arguments() : Array
      {
         return _arguments;
      }
      
      public function invoke() : *
      {
         var _loc2_:* = undefined;
         var _loc4_:Array = null;
         var _loc3_:Function = target[method];
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.apply(target,this.arguments);
         }
         else if(target is Proxy)
         {
            _loc4_ = [method].concat(this.arguments);
            _loc2_ = Proxy(target).flash_proxy::callProperty.apply(target,_loc4_);
         }
         
         return _loc2_;
      }
   }
}
