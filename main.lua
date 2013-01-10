local herbs = {x=0,y=0,z=1}
local background = {}
local camera = {x=0, y=0, z=0}
local clouds = {}

function love.load()
   for i = 1,1000 do
      table.insert(clouds,{
                      x=math.random()*10000,
                      z=math.random()*10000,
                      y=0,
                      sprite=love.graphics.newImage("sprites/clouds.png")})
   end
   table.sort(clouds,function(a,b) return a.z>b.z end)--,function(cloud,f) if cloud ~= nil then return cloud.z else return 0 e end)
   herbs.sprite = love.graphics.newImage("sprites/islands/herbsplace.png")
   background.sprite = love.graphics.newImage("sprites/background.png")
   love.graphics.setMode( 640, 480, true)
   effect = love.graphics.newPixelEffect
[[
  const float LOG2 = 1.442695;
  uniform float Distance;
  const float density = 0.2;
  //const vec4 fcol = vec4(1.0,1.0,1.0,1.0);
  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
    vec4 fcol = vec4(
      mix(
        vec3(0.54, 0.70, 0.89),
        vec3(0.25, 0.42, 0.76),

        clamp(abs(pixel_coords.y-240)/240.0,0.0,1.0)).rgb,
      1.0);
    vec4 original = Texel(texture, texture_coords).rgba;

    float fogFactor = exp2( -density *
                             density *
                             Distance *
                             Distance *
                             LOG2);

    fogFactor = clamp(fogFactor, 0.0, 1.0);

    return vec4(mix(fcol.rgb, original.rgb, fogFactor ),original.a);
  }
]]
end

function toColor(r,g,b,v)
        love.graphics.setColor(r+(255-r)*v,g+(255-g)*v,b+(255-b)*v)
end
function manyClouds(distance,x,y)

   if distance < 1 then return end
   effect:send("Distance",distance)


   love.graphics.push()
   love.graphics.translate(0,240)
   love.graphics.scale(1/distance,1/distance)
   --toColor(41,197,255,1/distance);
   love.graphics.draw(herbs.sprite,herbs.x,herbs.y)
   love.graphics.pop()
   manyClouds(distance-2,distance,y)
end

-- TODO clip far
function pdraw(object)
   local distance = (object.z-camera.z)/500
   if distance < 0.1 then return end
   effect:send("Distance",distance)
   love.graphics.push()
   love.graphics.translate(320,240)
   love.graphics.scale(1/distance,1/distance)
   --toColor(41,197,255,1/distance);
   love.graphics.draw(object.sprite,object.x-camera.x,object.y-camera.y)
   love.graphics.pop()
end

function love.draw()
        love.graphics.setPixelEffect()
        love.graphics.setColorMode("replace")
        love.graphics.setBlendMode("alpha")

        --love.graphics.setColor(255,255,255);
        --love.graphics.setColorMode("modulate");
        --love.graphics.draw(herbs.sprite,0,0)
        love.graphics.setPixelEffect(effect)
        effect:send("Distance",1000.0)
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill",0,0,640,480)
        love.graphics.draw(background.sprite,0,0)
        --love.graphics.draw(herbs.sprite,0,0)
        for i,v in ipairs(clouds) do
           pdraw(v)
        end
        pdraw(herbs)
        --manyClouds(49,0,0)
end


function love.update(dt)
   if love.keyboard.isDown("left") then
      camera.x=camera.x-5
   end
   if love.keyboard.isDown("right") then
      camera.x=camera.x+5
   end
   if love.keyboard.isDown("up") then
      camera.z=camera.z+5
   end
   if love.keyboard.isDown("down") then
      camera.z=camera.z-5
   end
   if love.keyboard.isDown("a") then
      camera.y=camera.y-5
   end
   if love.keyboard.isDown(";") then
      camera.y=camera.y+5
   end

end

function love.keypressed(key)   -- we do not need the unicode, so we can leave it out
   if key == "escape" then
      love.event.push("quit")   -- actually causes the app to quit
   end
end
