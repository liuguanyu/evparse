package com.qiyi.player.core.model
{
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import com.qiyi.player.core.model.impls.FocusTip;
	import com.qiyi.player.base.pub.EnumItem;
	
	public interface IMovieInfo
	{
		
		function get info() : String;
		
		function get infoJSON() : Object;
		
		function get share() : Boolean;
		
		function get fullShare() : Boolean;
		
		function get subtitles() : Vector.<Language>;
		
		function get subTitle() : String;
		
		function get chains() : Array;
		
		function get defaultSubtitle() : Language;
		
		function get focusTips() : Vector.<FocusTip>;
		
		function get channel() : EnumItem;
		
		function get pageUrl() : String;
		
		function get ptUrl() : String;
		
		function get title() : String;
		
		function get albumName() : String;
		
		function get albumUrl() : String;
		
		function get allSet() : int;
		
		function get allowDownload() : Boolean;
		
		function get nextUrl() : String;
		
		function get qiyiProduced() : Boolean;
		
		function get putBarrage() : Boolean;
		
		function get source() : String;
		
		function get ready() : Boolean;
		
		function get previewImageUrl() : String;
	}
}
