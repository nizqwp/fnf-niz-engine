package shaders;

import lime.utils.Assets;
import openfl.display.Shader;

class Shader_parser extends Shader 
{
  @fragment var code = ('
		#pragma header
		const float scale = 1.0;

		void main()
		{
			if (mod(floor(openfl_TextureCoordv.y * openfl_TextureSize.y / scale), 2.0) == 0.0)
				gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			else
				gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
		}');
	public function new(name:String)
	{
    var frag = Assets.getText('assets/data/frags/$name.frag');
    code = (frag);
    
		super();
	}
}
