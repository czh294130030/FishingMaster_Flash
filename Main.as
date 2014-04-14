package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	//设置flash尺寸，背景颜色，帧频
	//[SWF(width="1024", height="768", backgroundColor="#ffffff", frameRate="24")]
	public class Main extends Sprite
	{
		private var cannon_current_level:Number = 1;//当前加农炮的等级
		private var cannon_max_level:Number = 7;//加农炮的最高等级
		public function Main()
		{
			cannon_minus_mc.addEventListener(MouseEvent.MOUSE_DOWN, cannonMouseDown);
			cannon_minus_mc.addEventListener(MouseEvent.MOUSE_UP, cannonMouseUp);
			cannon_plus_mc.addEventListener(MouseEvent.MOUSE_DOWN, cannonMouseDown);
			cannon_plus_mc.addEventListener(MouseEvent.MOUSE_UP, cannonMouseUp);
			//减小加农炮;
			cannon_minus_mc.addEventListener(MouseEvent.CLICK, cannonMinusMouseClick);
			//增大加农炮;
			cannon_plus_mc.addEventListener(MouseEvent.CLICK, cannonPlusMouseClick);
		}
		//减小加农炮;
		private function cannonMinusMouseClick(e:MouseEvent):void
		{
			//加农炮已经为最小
			if (cannon_current_level==1)
			{
				cannon_current_level = 8;
			}
			//cannon_mc.gotoAndStop(--cannon_current_level);
		}
		//增大加农炮;
		private function cannonPlusMouseClick(e:MouseEvent):void
		{
			//加农炮已经为最大
			if (cannon_current_level == cannon_max_level)
			{
				cannon_current_level = 0;
			}
			//cannon_mc.gotoAndStop(++cannon_current_level);
		}
		//鼠标松开增大、减小加农炮按钮
		private function cannonMouseUp(e:MouseEvent):void
		{
			e.target.gotoAndStop(1);
		}
		//鼠标按下增大、减小加农炮按钮
		private function cannonMouseDown(e:MouseEvent):void
		{
			e.target.gotoAndStop(2);
		}
	}
}