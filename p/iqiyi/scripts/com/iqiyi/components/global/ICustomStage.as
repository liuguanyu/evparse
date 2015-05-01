package com.iqiyi.components.global {
	public interface ICustomStage {
		
		function isFullScreen() : Boolean;
		
		function setFullScreen() : void;
		
		function setNormalScreen() : void;
		
		function isTopMostLayer() : Boolean;
		
		function setTopMostLayer() : void;
		
		function setNormalLayer() : void;
		
		function getAccelerator() : Boolean;
		
		function setAccelerator(param1:Boolean) : void;
		
		function getFlip() : Boolean;
		
		function flipVideo(param1:Boolean) : void;
	}
}
