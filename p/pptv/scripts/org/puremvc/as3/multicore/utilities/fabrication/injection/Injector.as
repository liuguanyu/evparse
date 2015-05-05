package org.puremvc.as3.multicore.utilities.fabrication.injection
{
   import flash.utils.Dictionary;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   import flash.utils.getQualifiedClassName;
   import org.as3commons.reflect.Type;
   import org.as3commons.reflect.Field;
   import org.as3commons.reflect.MetaData;
   import org.as3commons.reflect.MetaDataArgument;
   
   public class Injector extends Object
   {
      
      public static const INJECT_PROXY:String = "InjectProxy";
      
      public static const INJECT_MEDIATOR:String = "InjectMediator";
      
      private static var CACHED_CONTEXT_INJECTION_DATA:Dictionary = new Dictionary();
      
      protected var facade:IFacade;
      
      protected var injectionMetadataTagName:String;
      
      protected var context;
      
      public function Injector(param1:IFacade, param2:*, param3:String)
      {
         super();
         this.facade = param1;
         this.context = param2;
         this.injectionMetadataTagName = param3;
      }
      
      public function inject() : Array
      {
         var _loc2_:InjectionField = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc1_:Array = [];
         var _loc3_:String = getQualifiedClassName(this.context) + "_" + this.injectionMetadataTagName;
         var _loc4_:Array = CACHED_CONTEXT_INJECTION_DATA[_loc3_] as Array;
         if(!_loc4_)
         {
            _loc4_ = [];
            _loc7_ = this.getInjectionFieldsByInjectionType(Type.forInstance(this.context),this.injectionMetadataTagName);
            for each(_loc4_[_loc4_.length] in _loc7_)
            {
            }
            CACHED_CONTEXT_INJECTION_DATA[_loc3_] = _loc4_;
         }
         var _loc5_:int = _loc4_.length;
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = this.processSingleField(_loc4_[_loc6_] as InjectionField);
            if(_loc8_)
            {
               _loc1_[_loc1_.length] = _loc8_;
            }
            _loc6_++;
         }
         return _loc1_;
      }
      
      private function getInjectionFieldsByInjectionType(param1:Type, param2:String) : Array
      {
         var _loc5_:Field = null;
         var _loc6_:Array = null;
         var _loc7_:MetaData = null;
         var _loc8_:InjectionField = null;
         var _loc9_:MetaDataArgument = null;
         var _loc3_:Array = [];
         var _loc4_:Array = param1.fields;
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = _loc5_.metaData;
            if((_loc6_) && (_loc6_.length))
            {
               for each(_loc7_ in _loc6_)
               {
                  if(_loc7_.name == param2)
                  {
                     _loc8_ = new InjectionField();
                     _loc8_.fieldName = _loc5_.name;
                     _loc8_.elementTypeIsInterface = _loc5_.type.isInterface;
                     _loc8_.elementClass = _loc5_.type.clazz;
                     _loc9_ = _loc7_.getArgument("name");
                     if(_loc9_)
                     {
                        _loc8_.elementName = _loc9_.value;
                     }
                     _loc3_.push(_loc8_);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      protected function elementExist(param1:String) : Boolean
      {
         throw new Error("Abstract method invocation error");
      }
      
      protected function getPatternElementForInjection(param1:String, param2:Class) : Object
      {
         throw new Error("Abstract method invocation error");
      }
      
      protected function onNoPatternElementAvaiable(param1:String) : void
      {
      }
      
      protected function onUnambiguousPatternElementName(param1:String) : void
      {
      }
      
      protected function getElementName(param1:InjectionField) : String
      {
         var _loc2_:String = param1.elementName;
         if(_loc2_ == null && !param1.elementTypeIsInterface)
         {
            _loc2_ = param1.elementClass["NAME"];
         }
         return _loc2_;
      }
      
      private function processSingleField(param1:InjectionField) : String
      {
         if(this.context[param1.fieldName] != null)
         {
            return null;
         }
         var _loc2_:String = this.getElementName(param1);
         if((_loc2_) && !this.elementExist(_loc2_))
         {
            this.onNoPatternElementAvaiable(_loc2_);
            return null;
         }
         if(!_loc2_ && (param1.elementTypeIsInterface))
         {
            this.onUnambiguousPatternElementName(param1.fieldName);
            return null;
         }
         var _loc3_:Class = param1.elementClass;
         var _loc4_:Object = this.getPatternElementForInjection(_loc2_,_loc3_);
         if((_loc4_) && _loc4_ is _loc3_)
         {
            this.context[param1.fieldName] = _loc4_;
         }
         else
         {
            this.onNoPatternElementAvaiable(_loc2_);
         }
         return param1.fieldName;
      }
   }
}
