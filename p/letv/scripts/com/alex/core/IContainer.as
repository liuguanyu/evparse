package com.alex.core
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.display.DisplayObject;
   
   public interface IContainer
   {
      
      function globalToLocal(param1:Point) : Point;
      
      function globalToLocal3D(param1:Point) : Vector3D;
      
      function addElement(param1:IUIComponent) : DisplayObject;
      
      function removeElement(param1:IUIComponent) : DisplayObject;
      
      function containsElement(param1:IUIComponent) : Boolean;
      
      function getElementIndex(param1:IUIComponent) : int;
      
      function removeElementAt(param1:int) : DisplayObject;
      
      function setElementIndex(param1:IUIComponent, param2:int) : void;
      
      function swapElement(param1:IUIComponent, param2:IUIComponent) : void;
      
      function get numElement() : int;
   }
}
