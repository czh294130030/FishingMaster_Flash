package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	//设置flash尺寸，背景颜色，帧频
	//[SWF(width="1024", height="768", backgroundColor="#ffffff", frameRate="24")]
	public class Main extends Sprite
	{
		private var base:Base=new Base();
		private var cannon_current_level:Number = 1;//当前加农炮的等级
		private var cannon_max_level:Number = 7;//加农炮的最高等级
		private var bullet_speed:Number = 10;//子弹移动速度
		private var cannon:MovieClip = null;//加农炮
		private var isCanShoot:Boolean = true;//是否有效发射子弹
		private var shootTimer:Timer = null;//用来控制射击时间间隔
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
			//创建鱼群;
			createFish();
			//创建加农炮
			createCannon();
			//用户金额容器显示初始化
			base.initUserMoney();
			//显示金额
			base.displayMoney(base.my_money);
			//舞台监控鼠标单击事件开火
			stage.addEventListener(MouseEvent.CLICK, fire);
			//添加Timer用来控制间隔1s单击鼠标发射子弹有效
			shootTimer = new Timer(1000,0);
			shootTimer.addEventListener(TimerEvent.TIMER, shootTimerHandler);
		}
		//添加Timer用来控制间隔1s单击鼠标发射子弹有效
		private function shootTimerHandler(e:TimerEvent):void
		{
			isCanShoot = true;
			shootTimer.stop();
		}
		//开火
		private function fire(e:MouseEvent):void
		{
			if (e.stageY <= 690 && isCanShoot)
			{
				//获取加农炮（子弹）需要调整的角度
				var angle1:Number = getAngleBy2Points(cannon.x,cannon.y,e.stageX,e.stageY);
				//显示金额
				base.my_money -=  cannon_current_level;
				base.displayMoney(base.my_money);
				//加农炮
				cannon.gotoAndPlay(2);
				cannon.rotation = angle1;
				//子弹
				var bullet:Bullet=new Bullet();
				bullet.gotoAndStop(cannon_current_level);
				bullet.rotation = angle1;
				var radian1:Number=angle1*(Math.PI/180);
				bullet["v_x"] = bullet_speed * Math.sin(radian1);
				bullet["v_y"] =  -  bullet_speed * Math.cos(radian1);
				bullet["type"] = cannon_current_level;
				bullet.x = cannon.x + cannon.height * Math.sin(radian1);
				bullet.y = cannon.y - cannon.height * Math.cos(radian1);
				bullet.addEventListener(Event.ENTER_FRAME, bulletMoving);
				stage.addChild(bullet);
				isCanShoot = false;
				shootTimer.start();
			}
		}
		/*获取长方形元件的中心点与鼠标点击点连线和长方形的角度  
		x1代表中心点的X坐标  
		y1代表中心点的Y坐标  
		x2代表鼠标点的X坐标  
		y2代表鼠标垫的Y坐标*/
		private function getAngleBy2Points(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			//获取长方形元件的中心点与鼠标点击点连线和长方形的弧度  
			var radian1:Number=Math.atan((x2-x1)/(y1-y2));
			//根据弧度获取角度  
			var angle1:Number=radian1/(Math.PI/180);
			if (x2 >= x1)
			{
				if (y2 <= y1)
				{
					angle1 = angle1;
				}
				else
				{
					angle1 +=  180;
				}
			}
			else
			{
				if (y2 > y1)
				{
					angle1 +=  180;
				}
				else
				{
					angle1 +=  360;
				}
			}
			return angle1;
		}
		//子弹移动
		private function bulletMoving(e:Event):void
		{
			var mc:Bullet = e.target as Bullet;
			mc.x +=  mc["v_x"];
			mc.y +=  mc["v_y"];
			var f_array:Array = base.f_array;
			if (f_array.length > 0)
			{
				for (var i:Number=0; i<f_array.length; i++)
				{
					var fish_mc:MovieClip = f_array[i];
					//如果子弹和鱼有交集
					if (mc.hitTestObject(fish_mc))
					{
						//子弹停止运动，跳到网，500ms后删除网
						mc.removeEventListener(Event.ENTER_FRAME, bulletMoving);
						mc.gotoAndStop(mc["type"]+7);
						var removeWebTimer:Timer = new Timer(500,1);
						removeWebTimer.addEventListener(TimerEvent.TIMER, function(e:Event){removeWebTimerHandler(e,mc)});
						removeWebTimer.start();
						//如果子弹的等级高于鱼的等级，鱼被抓住;
						if (mc["type"] >= fish_mc["f_t"])
						{
							base.fishIsCatched(fish_mc);
						}
					}
				}
			}
			if (mc.y < 0)
			{
				mc.removeEventListener(Event.ENTER_FRAME, bulletMoving);
				stage.removeChild(mc);
			}
		}
		//删除网
		private function removeWebTimerHandler(e:Event, mc:MovieClip)
		{
			if (stage.contains(mc))
			{
				stage.removeChild(mc);
			}
		}
		//创建鱼群
		private function createFish():void
		{
			base.createFish(stage);
		}
		//减小加农炮;
		private function cannonMinusMouseClick(e:MouseEvent):void
		{
			//加农炮已经为最小
			if (cannon_current_level==1)
			{
				cannon_current_level = 8;
			}
			cannon_current_level--;
			createCannon();
		}
		//增大加农炮;
		private function cannonPlusMouseClick(e:MouseEvent):void
		{
			//加农炮已经为最大
			if (cannon_current_level == cannon_max_level)
			{
				cannon_current_level = 0;
			}
			cannon_current_level++;
			createCannon();
		}
		//创建加农炮
		private function createCannon():void
		{
			//如果舞台已经存在加农炮，删掉它
			if (cannon!=null)
			{
				stage.removeChild(cannon);
			}
			switch (cannon_current_level)
			{
				case 1 :
					cannon=new Cannon1();
					break;
				case 2 :
					cannon=new Cannon2();
					break;
				case 3 :
					cannon=new Cannon3();
					break;
				case 4 :
					cannon=new Cannon4();
					break;
				case 5 :
					cannon=new Cannon5();
					break;
				case 6 :
					cannon=new Cannon6();
					break;
				case 7 :
					cannon=new Cannon7();
					break;
				default :
					cannon=new Cannon1();
					break;
			}
			cannon.x = (cannon_minus_mc.x+cannon_plus_mc.x+cannon_plus_mc.width)/2;
			cannon.y = cannon_minus_mc.y + 35;
			stage.addChild(cannon);
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