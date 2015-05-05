package org.as3commons.reflect
{
   public class AbstractMember extends MetaDataContainer implements IMember
   {
      
      private var _declaringType:String;
      
      private var _name:String;
      
      private var _isStatic:Boolean;
      
      private var _type:String;
      
      public function AbstractMember(param1:String, param2:String, param3:String, param4:Boolean, param5:Array = null)
      {
         super(param5);
         _name = param1;
         _type = param2;
         _declaringType = param3;
         _isStatic = param4;
      }
      
      public function get declaringType() : Type
      {
         return Type.forName(_declaringType);
      }
      
      public function get type() : Type
      {
         return Type.forName(_type);
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
   }
}
