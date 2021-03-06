package classes.ui
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class VScrollBar extends UIComponent
	{
		private var _lastScroll:Number = 0;
		private var _scrollFactor:Number = 0.5;
		
		private var _dragger:Sprite;
		
		public function VScrollBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(15, 100, false);
			super.init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_dragger = new Sprite();
			_dragger.buttonMode = true;
			addChild(_dragger);
			
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, e_startDrag);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff, 0.1);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			_dragger.graphics.clear();
			_dragger.graphics.lineStyle(1, 0xffffff, 0.5);
			_dragger.graphics.beginFill(0xffffff, 0.25);
			_dragger.graphics.drawRect(0, 0, width - 1, Math.max(height * scrollFactor, 30));
			_dragger.graphics.endFill();
			
			scroll = _lastScroll;
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_startDrag(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, e_stopDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			_dragger.startDrag(false, new Rectangle(0, 0, 0, height - _dragger.height));
		}
		
		private function e_stopDrag(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, e_stopDrag);
			_dragger.stopDrag();
			_lastScroll = _dragger.y / (height - 1 - _dragger.height);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function e_mouseMove(e:MouseEvent):void
		{
			_lastScroll = _dragger.y / (height - 1 - _dragger.height);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Returns the current scroll percent.
		 */
		public function get scroll():Number
		{
			return _lastScroll;
		}
		
		/**
		 * Sets the current scroll percent. Dispatchs Change Event.
		 * @param percent Range of 0-1
		 */
		public function set scroll(val:Number):void
		{
			scrollSilent = val;
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * Sets the current scroll percent.
		 * @param percent Range of 0-1
		 */
		public function set scrollSilent(val:Number):void
		{
			if (UIStyle.USE_ANIMATION)
				TweenLite.to(_dragger, 0.25, {y: ((height - _dragger.height) * Math.max(Math.min(val, 1), 0))});
			else
				_dragger.y = (height - _dragger.height) * Math.max(Math.min(val, 1), 0);
			_lastScroll = Math.max(Math.min(val, 1), 0);
		}
		
		/**
		 * Gets the current scroll factor.
		 * Scroll factor is the percent of the height the dragger should be displayed as.
		 */
		public function get scrollFactor():Number
		{
			return _scrollFactor;
		}
		
		/**
		 * Sets the scroll factor for the dragger to use.
		 */
		public function set scrollFactor(value:Number):void
		{
			_scrollFactor = value;
			draw();
		}
		
		/**
		 * Returns if the dragger is visible.
		 */
		public function get showDragger():Boolean
		{
			return _dragger.visible;
		}
		
		/**
		 * Show / Hide the dragger.
		 */
		public function set showDragger(value:Boolean):void
		{
			_dragger.visible = value;
		}
	}
}