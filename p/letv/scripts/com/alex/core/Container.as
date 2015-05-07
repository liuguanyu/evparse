package com.alex.core
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.display.DisplayObject;
   import com.alex.surface.ISurface;
   
   public class Container extends UIComponent implements IContainer
   {
      
      public function Container(param1:ISurface = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function globalToLocal(param1:Point) : Point
      {
         return skin.globalToLocal(param1);
      }
      
      public function globalToLocal3D(param1:Point) : Vector3D
      {
         return skin.globalToLocal3D(param1);
      }
      
      public function addElement(param1:IUIComponent) : DisplayObject
      {
         return skin.addChild(param1.skin);
      }
      
      public function removeElement(param1:IUIComponent) : DisplayObject
      {
         return skin.removeChild(param1.skin);
      }
      
      public function containsElement(param1:IUIComponent) : Boolean
      {
         return skin.contains(param1.skin);
      }
      
      public function getElementIndex(param1:IUIComponent) : int
      {
         return skin.getChildIndex(param1.skin);
      }
      
      public function removeElementAt(param1:int) : DisplayObject
      {
         return skin.removeChildAt(param1);
      }
      
      public function setElementIndex(param1:IUIComponent, param2:int) : void
      {
         skin.setChildIndex(param1.skin,param2);
      }
      
      public function swapElement(param1:IUIComponent, param2:IUIComponent) : void
      {
         skin.swapChildren(param1.skin,param2.skin);
      }
      
      public function get numElement() : int
      {
         return skin.numChildren;
      }
   }
}
