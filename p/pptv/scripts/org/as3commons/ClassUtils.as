package org.as3commons
{
   import flash.utils.getDefinitionByName;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.events.TimerEvent;
   import flash.utils.describeType;
   import flash.utils.getQualifiedSuperclassName;
   import flash.system.ApplicationDomain;
   
   public class ClassUtils extends Object
   {
      
      private static const PACKAGE_CLASS_SEPARATOR:String = "::";
      
      private static var _timer:Timer;
      
      public static const CLEAR_CACHE_INTERVAL:uint = 60000;
      
      public static var clearCacheInterval:uint = CLEAR_CACHE_INTERVAL;
      
      private static var _describeTypeCache:Object = {};
      
      public function ClassUtils()
      {
         super();
      }
      
      public static function getName(param1:Class) : String
      {
         return getNameFromFullyQualifiedName(getFullyQualifiedName(param1));
      }
      
      public static function getImplementedInterfaceNames(param1:Class) : Array
      {
         var _loc2_:Array = getFullyQualifiedImplementedInterfaceNames(param1);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = getNameFromFullyQualifiedName(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getImplementedInterfaces(param1:Class) : Array
      {
         var _loc2_:Array = getFullyQualifiedImplementedInterfaceNames(param1);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = getDefinitionByName(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getNameFromFullyQualifiedName(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:int = param1.indexOf(PACKAGE_CLASS_SEPARATOR);
         if(_loc3_ == -1)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = param1.substring(_loc3_ + PACKAGE_CLASS_SEPARATOR.length,param1.length);
         }
         return _loc2_;
      }
      
      public static function clearDescribeTypeCache() : void
      {
         _describeTypeCache = {};
         if((_timer) && (_timer.running))
         {
            _timer.stop();
         }
      }
      
      private static function getFromString(param1:String) : XML
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         return getFromObject(_loc2_);
      }
      
      public static function getFullyQualifiedName(param1:Class, param2:Boolean = false) : String
      {
         var _loc3_:String = getQualifiedClassName(param1);
         if(param2)
         {
            _loc3_ = convertFullyQualifiedName(_loc3_);
         }
         return _loc3_;
      }
      
      public static function newInstance(param1:Class, param2:Array = null) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Array = param2 == null?[]:param2;
         switch(_loc4_.length)
         {
            case 1:
               _loc3_ = new param1(_loc4_[0]);
               break;
            case 2:
               _loc3_ = new param1(_loc4_[0],_loc4_[1]);
               break;
            case 3:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2]);
               break;
            case 4:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
               break;
            case 5:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4]);
               break;
            case 6:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5]);
               break;
            case 7:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6]);
               break;
            case 8:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7]);
               break;
            case 9:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7],_loc4_[8]);
               break;
            case 10:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7],_loc4_[8],_loc4_[9]);
               break;
            default:
               _loc3_ = new param1();
         }
         return _loc3_;
      }
      
      public static function isAssignableFrom(param1:Class, param2:Class) : Boolean
      {
         return param1 == param2 || (isSubclassOf(param2,param1)) || (isImplementationOf(param2,param1));
      }
      
      public static function getSuperClassName(param1:Class) : String
      {
         var _loc2_:String = getFullyQualifiedSuperClassName(param1);
         var _loc3_:int = _loc2_.indexOf(PACKAGE_CLASS_SEPARATOR) + PACKAGE_CLASS_SEPARATOR.length;
         return _loc2_.substring(_loc3_,_loc2_.length);
      }
      
      private static function timerHandler(param1:TimerEvent) : void
      {
         clearDescribeTypeCache();
      }
      
      public static function getFullyQualifiedImplementedInterfaceNames(param1:Class, param2:Boolean = false) : Array
      {
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:String = null;
         var _loc3_:Array = [];
         var _loc4_:XML = getFromObject(param1);
         var _loc5_:XMLList = _loc4_.factory.implementsInterface;
         if(_loc5_)
         {
            _loc6_ = _loc5_.length();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = _loc5_[_loc7_].@type.toString();
               if(param2)
               {
                  _loc8_ = convertFullyQualifiedName(_loc8_);
               }
               _loc3_.push(_loc8_);
               _loc7_++;
            }
         }
         return _loc3_;
      }
      
      public static function isInterface(param1:Class) : Boolean
      {
         return param1 === Object?false:describeType(param1).factory.extendsClass.length() == 0;
      }
      
      public static function getFullyQualifiedSuperClassName(param1:Class, param2:Boolean = false) : String
      {
         var _loc3_:String = getQualifiedSuperclassName(param1);
         if(param2)
         {
            _loc3_ = convertFullyQualifiedName(_loc3_);
         }
         return _loc3_;
      }
      
      public static function isImplementationOf(param1:Class, param2:Class) : Boolean
      {
         var result:Boolean = false;
         var classDescription:XML = null;
         var clazz:Class = param1;
         var interfaze:Class = param2;
         if(clazz == null)
         {
            result = false;
         }
         else
         {
            classDescription = getFromObject(clazz);
            result = !(classDescription.factory.implementsInterface.(@type == getQualifiedClassName(interfaze)).length() == 0);
         }
         return result;
      }
      
      public static function convertFullyQualifiedName(param1:String) : String
      {
         return param1.replace(PACKAGE_CLASS_SEPARATOR,".");
      }
      
      public static function isSubclassOf(param1:Class, param2:Class) : Boolean
      {
         var clazz:Class = param1;
         var parentClass:Class = param2;
         var classDescription:XML = getFromObject(clazz);
         var parentName:String = getQualifiedClassName(parentClass);
         return !(classDescription.factory.extendsClass.(@type == parentName).length() == 0);
      }
      
      public static function getSuperClass(param1:Class) : Class
      {
         var _loc2_:Class = null;
         var _loc3_:XML = getFromObject(param1);
         var _loc4_:XMLList = _loc3_.factory.extendsClass;
         if(_loc4_.length() > 0)
         {
            _loc2_ = ClassUtils.forName(_loc4_[0].@type);
         }
         return _loc2_;
      }
      
      public static function forName(param1:String, param2:ApplicationDomain = null) : Class
      {
         var result:Class = null;
         var name:String = param1;
         var applicationDomain:ApplicationDomain = param2;
         if(!applicationDomain)
         {
            applicationDomain = ApplicationDomain.currentDomain;
         }
         while(!applicationDomain.hasDefinition(name))
         {
            if(applicationDomain.parentDomain)
            {
               applicationDomain = applicationDomain.parentDomain;
               continue;
            }
            break;
         }
         try
         {
            result = applicationDomain.getDefinition(name) as Class;
         }
         catch(e:ReferenceError)
         {
            throw new ClassNotFoundError("A class with the name \'" + name + "\' could not be found.");
         }
         return result;
      }
      
      public static function forInstance(param1:*, param2:ApplicationDomain = null) : Class
      {
         var _loc3_:String = getQualifiedClassName(param1);
         return forName(_loc3_,param2);
      }
      
      private static function getFromObject(param1:Object) : XML
      {
         var _loc3_:XML = null;
         var _loc2_:String = getQualifiedClassName(param1);
         if(_describeTypeCache.hasOwnProperty(_loc2_))
         {
            _loc3_ = _describeTypeCache[_loc2_];
         }
         else
         {
            if(!_timer)
            {
               _timer = new Timer(clearCacheInterval,1);
               _timer.addEventListener(TimerEvent.TIMER,timerHandler);
            }
            if(!(param1 is Class))
            {
               var param1:Object = param1.constructor;
            }
            _loc3_ = describeType(param1);
            _describeTypeCache[_loc2_] = _loc3_;
            if(!_timer.running)
            {
               _timer.start();
            }
         }
         return _loc3_;
      }
   }
}
