package assets
{
	import classes.ui.Label;
	import classes.ui.ResizeListener;
	import classes.ui.UIAnchor;
	import classes.ui.UIComponent;
	import classes.ui.UICore;
	import classes.ui.UIStyle;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class sGameBackground extends UIComponent
	{
		private static var _lineBMD:BitmapData;
		private var _matrix:Matrix = new Matrix();
		private var _text:String;
		private var _field:Label;
		
		public function sGameBackground()
		{
			CONFIG::debug
			{
				addEventListener(Event.ADDED_TO_STAGE, e_onStage);
			}
			
			ResizeListener.addObject(this);
		}
		
		override protected function init():void 
		{
			// Init Lines
			if (!_lineBMD)
			{
				var _lineSprite:Sprite = new Sprite();
				_lineSprite.graphics.lineStyle(1, 0, 0.12);
				for (var i:int = -510; i < 510; i += 7)
				{
					_lineSprite.graphics.moveTo(i, 510);
					_lineSprite.graphics.lineTo(i + 510, 0);
				}
				
				_lineBMD = new BitmapData(510, 510, true, 0x00000000);
				_lineBMD.draw(_lineSprite);
			}
			super.init();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		CONFIG::debug
		{
			private function e_onStage(e:Event):void
			{
				removeEventListener(Event.ADDED_TO_STAGE, e_onStage);
				
				if (parent && parent is UICore && !_text)
					text = CONFIG::timeStamp + " - " + (parent as UICore).class_name;
			}
		}
		
		public function set text(t:String):void
		{
			_text = t;
			if (_text == null)
				_text = "";
			
			// Create Textbox
			if (_text != "")
			{
				if (!_field)
				{
					_field = new Label(this, 2, -22);
					_field.mouseEnabled = false;
					_field.alpha = 0.3;
					_field.anchor = UIAnchor.BOTTOM_LEFT;
				}
			}
			
			// Update Textbox
			if (_field)
				_field.text = _text;
		}
		
		override public function draw():void
		{
			// Create Background
			_matrix.createGradientBox(Constant.GAME_WIDTH, Constant.GAME_HEIGHT, 5.75);
			this.graphics.clear();
			this.graphics.beginGradientFill(GradientType.LINEAR, [UIStyle.BG_LIGHT, UIStyle.BG_DARK], [1, 1], [0x00, 0xFF], _matrix);
			this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			this.graphics.endFill();
			
			this.graphics.beginBitmapFill(_lineBMD);
			this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			this.graphics.endFill();
		}
		
		override public function onResize():void
		{
			draw();
		}
	}

}