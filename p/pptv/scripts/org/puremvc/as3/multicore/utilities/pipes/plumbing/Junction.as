package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
   
   public class Junction extends Object
   {
      
      public static const OUTPUT:String = "output";
      
      public static const INPUT:String = "input";
      
      protected var outputPipes:Array;
      
      protected var pipesMap:Array;
      
      protected var pipeTypesMap:Array;
      
      protected var inputPipes:Array;
      
      public function Junction()
      {
         inputPipes = new Array();
         outputPipes = new Array();
         pipesMap = new Array();
         pipeTypesMap = new Array();
         super();
      }
      
      public function addPipeListener(param1:String, param2:Object, param3:Function) : Boolean
      {
         var _loc5_:IPipeFitting = null;
         var _loc4_:* = false;
         if(hasInputPipe(param1))
         {
            _loc5_ = pipesMap[param1] as IPipeFitting;
            _loc4_ = _loc5_.connect(new PipeListener(param2,param3));
         }
         return _loc4_;
      }
      
      public function hasPipe(param1:String) : Boolean
      {
         return !(pipesMap[param1] == null);
      }
      
      public function hasOutputPipe(param1:String) : Boolean
      {
         return (hasPipe(param1)) && pipeTypesMap[param1] == OUTPUT;
      }
      
      public function retrievePipe(param1:String) : IPipeFitting
      {
         return pipesMap[param1] as IPipeFitting;
      }
      
      public function registerPipe(param1:String, param2:String, param3:IPipeFitting) : Boolean
      {
         var _loc4_:* = true;
         if(pipesMap[param1] == null)
         {
            pipesMap[param1] = param3;
            pipeTypesMap[param1] = param2;
            switch(param2)
            {
               case INPUT:
                  inputPipes.push(param1);
                  break;
               case OUTPUT:
                  outputPipes.push(param1);
                  break;
               default:
                  _loc4_ = false;
            }
         }
         else
         {
            _loc4_ = false;
         }
         return _loc4_;
      }
      
      public function removePipe(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         if(hasPipe(param1))
         {
            _loc2_ = pipeTypesMap[param1];
            switch(_loc2_)
            {
               case INPUT:
                  _loc3_ = inputPipes;
                  break;
               case OUTPUT:
                  _loc3_ = outputPipes;
                  break;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] == param1)
               {
                  _loc3_.splice(_loc4_,1);
                  break;
               }
               _loc4_++;
            }
            delete pipesMap[param1];
            true;
            delete pipeTypesMap[param1];
            true;
         }
      }
      
      public function hasInputPipe(param1:String) : Boolean
      {
         return (hasPipe(param1)) && pipeTypesMap[param1] == INPUT;
      }
      
      public function sendMessage(param1:String, param2:IPipeMessage) : Boolean
      {
         var _loc4_:IPipeFitting = null;
         var _loc3_:* = false;
         if(hasOutputPipe(param1))
         {
            _loc4_ = pipesMap[param1] as IPipeFitting;
            _loc3_ = _loc4_.write(param2);
         }
         return _loc3_;
      }
   }
}
