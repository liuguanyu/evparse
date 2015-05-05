package org.as3commons.reflect
{
   public class Method extends MetaDataContainer
   {
      
      private var _declaringType:Type;
      
      private var _parameters:Array;
      
      private var _name:String;
      
      private var _returnType:Type;
      
      private var _isStatic:Boolean;
      
      public function Method(param1:Type, param2:String, param3:Boolean, param4:Array, param5:*, param6:Array = null)
      {
         super(param6);
         _declaringType = param1;
         _name = param2;
         _isStatic = param3;
         _parameters = param4;
         _returnType = param5;
      }
      
      public function get declaringType() : Type
      {
         return _declaringType;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[Method(name:\'" + name + "\', isStatic:" + isStatic + ")]";
      }
      
      public function get returnType() : Type
      {
         return _returnType;
      }
      
      public function invoke(param1:*, param2:Array) : *
      {
         var _loc4_:MethodInvoker = new MethodInvoker();
         _loc4_.target = param1;
         _loc4_.method = name;
         _loc4_.arguments = param2;
         return _loc4_.invoke();
      }
      
      public function get parameters() : Array
      {
         return _parameters;
      }
      
      public function get fullName() : String
      {
         var _loc3_:Parameter = null;
         var _loc1_:* = "public ";
         if(isStatic)
         {
            _loc1_ = _loc1_ + "static ";
         }
         _loc1_ = _loc1_ + (name + "(");
         var _loc2_:* = 0;
         while(_loc2_ < parameters.length)
         {
            _loc3_ = parameters[_loc2_] as Parameter;
            _loc1_ = _loc1_ + _loc3_.type.name;
            _loc1_ = _loc1_ + (_loc2_ < parameters.length - 1?", ":"");
            _loc2_++;
         }
         _loc1_ = _loc1_ + ("):" + returnType.name);
         return _loc1_;
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
   }
}
