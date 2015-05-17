package com.pplive.p2p.struct
{
	public class StructUtil extends Object
	{
		
		public function StructUtil()
		{
			super();
		}
		
		public static function getSubPieceCountByFileLength(param1:uint) : uint
		{
			return Math.ceil(param1 / Constants.SUBPIECE_SIZE);
		}
		
		public static function getPieceCountByFileLength(param1:uint) : uint
		{
			return Math.ceil(param1 / Constants.PIECE_SIZE);
		}
		
		public static function getBlockCountByFileLength(param1:uint) : uint
		{
			return Math.ceil(param1 / Constants.BLOCK_SIZE);
		}
		
		public static function getPieceCountInBlock(param1:uint, param2:uint) : uint
		{
			var _loc3:uint = getBlockCountByFileLength(param1) - 1;
			if(param2 == _loc3)
			{
				if(param1 % Constants.BLOCK_SIZE == 0)
				{
					return Constants.PIECE_NUM_PER_BLOCK;
				}
				return Math.ceil(param1 % Constants.BLOCK_SIZE / Constants.PIECE_SIZE);
			}
			if(param2 < _loc3)
			{
				return Constants.PIECE_NUM_PER_BLOCK;
			}
			return 0;
		}
		
		public static function getSubPieceCountInBlock(param1:uint, param2:uint) : uint
		{
			var _loc3:uint = getBlockCountByFileLength(param1) - 1;
			if(param2 == _loc3)
			{
				if(param1 % Constants.BLOCK_SIZE == 0)
				{
					return Constants.SUBPIECE_NUM_PER_BLOCK;
				}
				return Math.ceil(param1 % Constants.BLOCK_SIZE / Constants.SUBPIECE_SIZE);
			}
			if(param2 < _loc3)
			{
				return Constants.SUBPIECE_NUM_PER_BLOCK;
			}
			return 0;
		}
		
		public static function getSubPieceCountInPiece(param1:uint, param2:Piece) : uint
		{
			var _loc3:Piece = getLastPieceByFileLength(param1);
			if(param2.compare(_loc3) == 0)
			{
				if(param1 % Constants.PIECE_SIZE == 0)
				{
					return Constants.SUBPIECE_NUM_PER_PIECE;
				}
				return Math.ceil(param1 % Constants.PIECE_SIZE / Constants.SUBPIECE_SIZE);
			}
			if(param2.compare(_loc3) < 0)
			{
				return Constants.SUBPIECE_NUM_PER_PIECE;
			}
			return 0;
		}
		
		public static function getLastPieceByFileLength(param1:uint) : Piece
		{
			var _loc2:uint = param1 % Constants.BLOCK_SIZE;
			if(_loc2 == 0)
			{
				return new Piece(param1 / Constants.BLOCK_SIZE - 1,Constants.PIECE_NUM_PER_BLOCK - 1);
			}
			return new Piece(param1 / Constants.BLOCK_SIZE,Math.ceil(_loc2 / Constants.PIECE_SIZE) - 1);
		}
		
		public static function getLastSubPieceByFileLength(param1:uint) : SubPiece
		{
			var _loc2:uint = param1 % Constants.BLOCK_SIZE;
			if(_loc2 == 0)
			{
				return new SubPiece(param1 / Constants.BLOCK_SIZE - 1,Constants.SUBPIECE_NUM_PER_BLOCK - 1);
			}
			return new SubPiece(param1 / Constants.BLOCK_SIZE,Math.ceil(_loc2 / Constants.SUBPIECE_SIZE) - 1);
		}
		
		public static function getLastSubPieceSizeByFileLength(param1:uint) : uint
		{
			var _loc2:uint = param1 % Constants.SUBPIECE_SIZE;
			return _loc2 != 0?_loc2:Constants.SUBPIECE_SIZE;
		}
		
		public static function getPieceFromSubPiece(param1:SubPiece) : Piece
		{
			return new Piece(param1.blockIndex,param1.subPieceIndex / Constants.SUBPIECE_NUM_PER_PIECE);
		}
		
		public static function getSubPieceIndexInPiece(param1:SubPiece) : uint
		{
			return param1.subPieceIndex % Constants.SUBPIECE_NUM_PER_PIECE;
		}
	}
}
