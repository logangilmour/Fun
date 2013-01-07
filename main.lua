local herbs = {}
local clouds = {}
local background = {}

function love.load()
	herbs.sprite = love.graphics.newImage("sprites/islands/herbsplace.png")
	clouds.sprite = love.graphics.newImage("sprites/clouds.png")
	background.sprite = love.graphics.newImage("sprites/background.png")
	love.graphics.setMode( 640, 480, true)
	
	effect = love.graphics.newPixelEffect
	[[
		
		const float LOG2 = 1.442695;
		const float z = 2.0;
		const float density = 0.5;
		const vec4 fcol = vec4(1.0,1.0,1.0,1.0);
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
			float fogFactor = exp2( -density * 
				   density * 
				   z * 
				   z * 
				   LOG2 );
			fogFactor = clamp(fogFactor, 0.0, 1.0);
			return mix(fcol, Texel(texture, texture_coords).rgba, fogFactor );
		}
	]]
end

function toColor(r,g,b,v)
	love.graphics.setColor(r+(255-r)*v,g+(255-g)*v,b+(255-b)*v)
end
function manyClouds(distance,x,y)

	if distance < 1 then return end
	love.graphics.push()
	love.graphics.translate(x,y)
	love.graphics.scale(1/distance,1/distance)
	toColor(41,197,255,1/distance);
	love.graphics.draw(herbs.sprite,0,0)
	love.graphics.pop()
	manyClouds(distance-1,distance,y)
end
function love.draw()
	love.graphics.setPixelEffect()
	love.graphics.setColorMode("replace")
	love.graphics.setBlendMode("alpha")
	love.graphics.draw(background.sprite,0,0)
	--love.graphics.setColor(255,255,255);
	--love.graphics.setColorMode("modulate");
	--love.graphics.draw(herbs.sprite,0,0)
	love.graphics.setPixelEffect(effect)
	love.graphics.draw(herbs.sprite,0,0)
	--manyClouds(100,0,0)
end


function love.update(dt)

end

function love.keypressed(key)   -- we do not need the unicode, so we can leave it out
   if key == "escape" then
      love.event.push("quit")   -- actually causes the app to quit
   end
end