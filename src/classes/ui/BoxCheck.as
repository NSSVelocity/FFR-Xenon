package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class BoxCheck extends UIComponent
	{
		protected var _checked:Boolean = false;
		
		protected var _background_color:uint = 0xFFFFFF;
		protected var _background_alpha:Number = 0.1;
		protected var _check_color:uint = 0x51B6FF;
		protected var _check_alpha:Number = 0.6;
		
		protected var _border_alpha:Number = 0.6;
		protected var _border_color:uint = 0xFFFFFF;
		
		public function BoxCheck(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, isChecked:Boolean = false):void
		{
			_checked = isChecked;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			setSize(14, 14, false);
			super.init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			this.graphics.clear();
			
			//- Draw Box
			var _alpha:Number = (highlight ? 1.5 : 1);
			this.graphics.lineStyle(1, border_color, _border_alpha * _alpha);
			if (checked)
				this.graphics.beginFill(check_color, _check_alpha * _alpha);
			else
				this.graphics.beginFill(color, _background_alpha * _alpha);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		/**
		 * Method call to react like a mouse click on the component.
		 */
		override public function doClickEvent():void
		{
			onMouseClick();
		}
		
		///////////////////////////////////
		// event handler
		///////////////////////////////////
		
		/**
		 * Internal click handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseClick(e:MouseEvent = null):void
		{
			if(enabled)
				checked = !checked;
		}
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			draw();
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			draw();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Returns true if checked.
		 */
		public function get checked():Boolean
		{
			return _checked;
		}
		
		public function set checked(val:Boolean):void
		{
			_checked = val;
			draw();
		}
		
		override public function set highlight(val:Boolean):void
		{
			super.highlight = val;
			draw();
		}
		
		public function get color():uint
		{
			return _background_color;
		}
		
		public function set color(value:uint):void
		{
			_background_color = value;
			draw();
		}
		
		public function get border_color():uint
		{
			return _border_color;
		}
		
		public function set border_color(value:uint):void
		{
			_border_color = value;
			draw();
		}
		
		public function get check_color():uint
		{
			return _check_color;
		}
		
		public function set check_color(value:uint):void
		{
			_border_color = value;
			draw();
		}
	
	}

}