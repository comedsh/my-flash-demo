package utils { 
	
	import flash.display.*;
	
	import flash.text.*;
	
	import flash.filters.DropShadowFilter;
	
	public class SimpleButtonRectangle extends SimpleButton {
		
		// 显示在按钮上的文本
		private var _text:String;
		
		// 保存矩形的宽度和高度
		private var _width:Number;
		
		private var _height:Number; 
		
		public function SimpleButtonRectangle( text:String, width:Number, height:Number ) {
			
			// Save the values to use them to create the button states 
			
			_text = text;
			
			_width= width;
			
			_height = height;
			
			// 创建按钮状态
			upState = createUpState( );
			
			overState = createOverState( );
			
			downState = createDownState( );
			
			hitTestState= upState;
			
		}
		// 创建状态对象
		private function createUpState( ):Sprite {
			
			var sprite:Sprite = new Sprite( );
			
			var background:Shape = createdColoredRectangle( 0x33FF66 );
			
			var textField:TextField= createTextField(false );
			
			sprite.addChild(background );
			
			sprite.addChild(textField);
			
			return sprite;
		}

		private function createOverState() : Sprite{
			
			var sprite:Sprite = new Sprite();
			
			var background:Shape = createdColoredRectangle( 0x70FF94 );
			
			var textField:TextField= createTextField( false );
			
			sprite.addChild(background );
			
			sprite.addChild(textField); 
			
			return sprite;
		}
		
		private function createDownState():Sprite {
			
			var sprite:Sprite = new Sprite();
			
			var background:Shape = createdColoredRectangle( 0xCCCCCC ); 
			
			var textField:TextField= createTextField( true ); 
			
			sprite.addChild( background );
			
			sprite.addChild( textField);
			
			return sprite;
		}
		
		private function createdColoredRectangle(color:uint ):Shape {
			
			var rect:Shape = new Shape( ); 
			
			rect.graphics.lineStyle(1, 0x000000 ); 
			
			rect.graphics.beginFill( color ); 
			
			rect.graphics.drawRoundRect(0, 0, _width, _height, 15 ); 
			
			rect.graphics.endFill( );
			
			rect.filters = [ new DropShadowFilter( 2 ) ];
			
			return rect; 
		}
		
		// 创建按钮上的文字
		private function createTextField( downState:Boolean ):TextField{ 
			
		
			var textField:TextField= new TextField( ); 
			
			textField.text= _text;
			
			textField.width= _width; 
			
			var format:TextFormat = new TextFormat( ); 
			
			format.align = TextFormatAlign.CENTER; 
			
			format.size = 8;
			
			textField.setTextFormat( format );
			
			//垂直居中
			textField.y = ( _height - textField.textHeight) / 2;
			
			textField.y -= 2; // Subtract 2 pixels to adjust for offset if ( downState ) {
			
			textField.x += 1;
			
			textField.y += 1; 
			
			return textField;
			
		}
		
	}
	
}	
		