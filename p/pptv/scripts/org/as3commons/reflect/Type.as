package org.as3commons.reflect
{
   import flash.utils.describeType;
   import org.as3commons.ClassUtils;
   import flash.utils.getDefinitionByName;
   
   public class Type extends MetaDataContainer
   {
      
      public static const PRIVATE:Type = new Type();
      
      private static var _cache:Object = {};
      
      public static const UNTYPED:Type = new Type();
      
      public static const VOID:Type = new Type();
      
      private var _accessors:Array;
      
      private var _isStatic:Boolean;
      
      private var _fullName:String;
      
      private var _isFinal:Boolean;
      
      private var _isDynamic:Boolean;
      
      private var _constructor:Constructor;
      
      private var _staticConstants:Array;
      
      private var _constants:Array;
      
      private var _staticVariables:Array;
      
      private var _name:String;
      
      private var _methods:Array;
      
      private var _isInterface:Boolean;
      
      private var _variables:Array;
      
      private var _class:Class;
      
      public function Type()
      {
         super();
         _methods = [];
         _accessors = [];
         _staticConstants = [];
         _constants = [];
         _staticVariables = [];
         _variables = [];
      }
      
      private static function getTypeDescription(param1:Class) : XML
      {
         var parametersXML:XMLList = null;
         var args:Array = null;
         var n:int = 0;
         var clazz:Class = param1;
         var description:XML = describeType(clazz);
         var constructorXML:XMLList = description.factory.constructor;
         if((constructorXML) && constructorXML.length() > 0)
         {
            parametersXML = constructorXML[0].parameter;
            if((parametersXML) && parametersXML.length() > 0)
            {
               args = [];
               n = 0;
               while(n < parametersXML.length())
               {
                  args.push(null);
                  n++;
               }
               try
               {
                  ClassUtils.newInstance(clazz,args);
               }
               catch(e:Error)
               {
               }
               description = describeType(clazz);
            }
         }
         return description;
      }
      
      public static function forClass(param1:Class) : Type
      {
         var _loc2_:Type = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:Type = null;
         var _loc9_:Array = null;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc3_:String = ClassUtils.getFullyQualifiedName(param1);
         if(_cache[_loc3_])
         {
            _loc2_ = _cache[_loc3_];
         }
         else
         {
            _loc2_ = new Type();
            _cache[_loc3_] = _loc2_;
            _loc4_ = getTypeDescription(param1);
            _loc2_.fullName = _loc3_;
            _loc2_.name = ClassUtils.getNameFromFullyQualifiedName(_loc3_);
            _loc2_.clazz = param1;
            _loc2_.isDynamic = _loc4_.@isDynamic;
            _loc2_.isFinal = _loc4_.@isFinal;
            _loc2_.isStatic = _loc4_.@isStatic;
            _loc2_.isInterface = param1 === Object?false:_loc4_.factory.extendsClass.length() == 0;
            _loc2_.constructor = TypeXmlParser.parseConstructor(_loc2_,_loc4_.factory.constructor);
            _loc2_.accessors = TypeXmlParser.parseAccessors(_loc2_,_loc4_);
            _loc2_.methods = TypeXmlParser.parseMethods(_loc2_,_loc4_);
            _loc2_.staticConstants = TypeXmlParser.parseMembers(Constant,_loc4_.constant,_loc3_,true);
            _loc2_.constants = TypeXmlParser.parseMembers(Constant,_loc4_.factory.constant,_loc3_,false);
            _loc2_.staticVariables = TypeXmlParser.parseMembers(Variable,_loc4_.variable,_loc3_,true);
            _loc2_.variables = TypeXmlParser.parseMembers(Variable,_loc4_.factory.variable,_loc3_,false);
            TypeXmlParser.parseMetaData(_loc4_.factory[0].metadata,_loc2_);
            _loc5_ = ClassUtils.getImplementedInterfaces(_loc2_.clazz);
            _loc6_ = _loc5_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = Type.forClass(_loc5_[_loc7_]);
               concatMetadata(_loc2_,_loc8_.methods,"methods");
               concatMetadata(_loc2_,_loc8_.accessors,"accessors");
               _loc9_ = _loc8_.metaData;
               _loc10_ = _loc9_.length;
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  _loc2_.addMetaData(_loc9_[_loc11_]);
                  _loc11_++;
               }
               _loc7_++;
            }
         }
         return _loc2_;
      }
      
      private static function concatMetadata(param1:Type, param2:Array, param3:String) : void
      {
         var container:IMetaDataContainer = null;
         var type:Type = param1;
         var metaDataContainers:Array = param2;
         var propertyName:String = param3;
         for each(container in metaDataContainers)
         {
            type[propertyName].some(function(param1:Object, param2:int, param3:Array):Boolean
            {
               var _loc4_:Array = null;
               var _loc5_:* = 0;
               var _loc6_:* = 0;
               if(param1.name == Object(container).name)
               {
                  _loc4_ = container.metaData;
                  _loc5_ = _loc4_.length;
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     param1.addMetaData(_loc4_[_loc6_]);
                     _loc6_++;
                  }
                  return true;
               }
               return false;
            });
         }
      }
      
      public static function forName(param1:String) : Type
      {
         var result:Type = null;
         var name:String = param1;
         switch(name)
         {
            case "void":
               result = Type.VOID;
               break;
            case "*":
               result = Type.UNTYPED;
               break;
            default:
               try
               {
                  result = Type.forClass(Class(getDefinitionByName(name)));
               }
               catch(e:ReferenceError)
               {
               }
         }
         return result;
      }
      
      public static function forInstance(param1:*) : Type
      {
         var _loc2_:Type = null;
         var _loc3_:Class = ClassUtils.forInstance(param1);
         if(_loc3_ != null)
         {
            _loc2_ = Type.forClass(_loc3_);
         }
         return _loc2_;
      }
      
      public function get staticConstants() : Array
      {
         return _staticConstants;
      }
      
      public function set staticConstants(param1:Array) : void
      {
         _staticConstants = param1;
      }
      
      public function set fullName(param1:String) : void
      {
         _fullName = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get accessors() : Array
      {
         return _accessors;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function set accessors(param1:Array) : void
      {
         _accessors = param1;
      }
      
      public function set constants(param1:Array) : void
      {
         _constants = param1;
      }
      
      public function set isDynamic(param1:Boolean) : void
      {
         _isDynamic = param1;
      }
      
      public function get staticVariables() : Array
      {
         return _staticVariables;
      }
      
      public function get isInterface() : Boolean
      {
         return _isInterface;
      }
      
      public function set clazz(param1:Class) : void
      {
         _class = param1;
      }
      
      public function get methods() : Array
      {
         return _methods;
      }
      
      public function get isDynamic() : Boolean
      {
         return _isDynamic;
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
      
      public function get fullName() : String
      {
         return _fullName;
      }
      
      public function get fields() : Array
      {
         return accessors.concat(staticConstants).concat(constants).concat(staticVariables).concat(variables);
      }
      
      public function getField(param1:String) : Field
      {
         var _loc2_:Field = null;
         var _loc3_:Field = null;
         for each(_loc3_ in fields)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function get constants() : Array
      {
         return _constants;
      }
      
      public function set staticVariables(param1:Array) : void
      {
         _staticVariables = param1;
      }
      
      public function getMethod(param1:String) : Method
      {
         var _loc2_:Method = null;
         var _loc3_:Method = null;
         for each(_loc3_ in methods)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function get clazz() : Class
      {
         return _class;
      }
      
      public function set isInterface(param1:Boolean) : void
      {
         _isInterface = param1;
      }
      
      public function set isFinal(param1:Boolean) : void
      {
         _isFinal = param1;
      }
      
      public function set methods(param1:Array) : void
      {
         _methods = param1;
      }
      
      public function get isFinal() : Boolean
      {
         return _isFinal;
      }
      
      public function set variables(param1:Array) : void
      {
         _variables = param1;
      }
      
      public function set isStatic(param1:Boolean) : void
      {
         _isStatic = param1;
      }
      
      public function set constructor(param1:Constructor) : void
      {
         _constructor = param1;
      }
      
      public function get constructor() : Constructor
      {
         return _constructor;
      }
      
      public function get variables() : Array
      {
         return _variables;
      }
   }
}

import org.as3commons.reflect.IMetaDataContainer;
import org.as3commons.reflect.MetaDataArgument;
import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.Type;
import org.as3commons.reflect.Parameter;
import org.as3commons.reflect.IMember;
import org.as3commons.reflect.Constructor;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Accessor;
import org.as3commons.reflect.AccessorAccess;

class TypeXmlParser extends Object
{
   
   function TypeXmlParser()
   {
      super();
   }
   
   public static function parseMetaData(param1:XMLList, param2:IMetaDataContainer) : void
   {
      var _loc3_:XML = null;
      var _loc4_:Array = null;
      var _loc5_:XML = null;
      for each(_loc3_ in param1)
      {
         _loc4_ = [];
         for each(_loc5_ in _loc3_.arg)
         {
            _loc4_.push(new MetaDataArgument(_loc5_.@key,_loc5_.@value));
         }
         param2.addMetaData(new MetaData(_loc3_.@name,_loc4_));
      }
   }
   
   private static function parseParameters(param1:XMLList) : Array
   {
      var _loc3_:XML = null;
      var _loc4_:Type = null;
      var _loc5_:Parameter = null;
      var _loc2_:Array = [];
      for each(_loc3_ in param1)
      {
         _loc4_ = Type.forName(_loc3_.@type);
         _loc5_ = new Parameter(_loc3_.@index,_loc4_,_loc3_.@optional == "true"?true:false);
         _loc2_.push(_loc5_);
      }
      return _loc2_;
   }
   
   public static function parseMembers(param1:Class, param2:XMLList, param3:String, param4:Boolean) : Array
   {
      var _loc6_:XML = null;
      var _loc7_:IMember = null;
      var _loc5_:Array = [];
      for each(_loc6_ in param2)
      {
         _loc7_ = new param1(_loc6_.@name,_loc6_.@type.toString(),param3,param4);
         parseMetaData(_loc6_.metadata,_loc7_);
         _loc5_.push(_loc7_);
      }
      return _loc5_;
   }
   
   public static function parseConstructor(param1:Type, param2:XMLList) : Constructor
   {
      var _loc3_:Array = null;
      if(param2.length() > 0)
      {
         _loc3_ = parseParameters(param2[0].parameter);
         return new Constructor(param1,_loc3_);
      }
      return new Constructor(param1);
   }
   
   public static function parseAccessors(param1:Type, param2:XML) : Array
   {
      var _loc3_:Array = parseAccessorsByModifier(param1,param2.accessor,true);
      var _loc4_:Array = parseAccessorsByModifier(param1,param2.factory.accessor,false);
      return _loc3_.concat(_loc4_);
   }
   
   private static function parseMethodsByModifier(param1:Type, param2:XMLList, param3:Boolean) : Array
   {
      var _loc5_:XML = null;
      var _loc6_:Array = null;
      var _loc7_:Method = null;
      var _loc4_:Array = [];
      for each(_loc5_ in param2)
      {
         _loc6_ = parseParameters(_loc5_.parameter);
         _loc7_ = new Method(param1,_loc5_.@name,param3,_loc6_,Type.forName(_loc5_.@returnType));
         parseMetaData(_loc5_.metadata,_loc7_);
         _loc4_.push(_loc7_);
      }
      return _loc4_;
   }
   
   private static function parseAccessorsByModifier(param1:Type, param2:XMLList, param3:Boolean) : Array
   {
      var _loc5_:XML = null;
      var _loc6_:Accessor = null;
      var _loc4_:Array = [];
      for each(_loc5_ in param2)
      {
         _loc6_ = new Accessor(_loc5_.@name,AccessorAccess.fromString(_loc5_.@access),_loc5_.@type.toString(),_loc5_.@declaredBy.toString(),param3);
         parseMetaData(_loc5_.metadata,_loc6_);
         _loc4_.push(_loc6_);
      }
      return _loc4_;
   }
   
   public static function parseMethods(param1:Type, param2:XML) : Array
   {
      var _loc3_:Array = parseMethodsByModifier(param1,param2.method,true);
      var _loc4_:Array = parseMethodsByModifier(param1,param2.factory.method,false);
      return _loc3_.concat(_loc4_);
   }
}
