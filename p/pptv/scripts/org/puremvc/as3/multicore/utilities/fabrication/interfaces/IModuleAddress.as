package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IModuleAddress extends IDisposable
   {
      
      function getClassName() : String;
      
      function getInstanceName() : String;
      
      function getInputName() : String;
      
      function getOutputName() : String;
      
      function getGroupName() : String;
   }
}
