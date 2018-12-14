pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local score
local game_objects

function _init()
  game_objects={}
  -- start the score counter at zero
  score=0
  -- create player object
  make_player(64,24)
  local i
  for i=1,rnd(9)+1 do
    make_coin(rnd(100)+20, 80)
  end
  for i=1,14 do
    make_block(8*i,90)
  end
  make_block(50,50)
  make_block(80,70)
  make_block(40,82)
end

function _update()
  local obj
  -- update all the game objects
  for obj in all(game_objects) do
    obj:update()
    -- player:check_coin_collision(coin)
    -- player:check_block_collision(block)
  end
end

function _draw()
  cls()
  -- draw the score
  print(score,5,5,7)
  -- draw all the game objects
  for obj in all(game_objects) do
    obj:draw()
  end
end

function make_player(x,y)
  return make_game_obj(x,y,8,8,{
   move_speed=1,
   vx=0,
   vy=0,
   is_standing_on_block=false,
   draw=function(self)
     spr(1,self.x,self.y)
   end,
   update=function(self)
     -- aplica friccao
     self.vx=self.vx*0.5
     -- move o player com as setas do teclado
     if (btn(0)) self.vx-=self.move_speed
     if (btn(1)) self.vx+=self.move_speed
     -- pula quando z eh pressionado
     if btn(4) and self.is_standing_on_block then
       self.vy = -3
       self.is_standing_on_block=false
       -- STOPPED HERE (CONTINUE)
     end
     -- aplica a gravidade
     self.vy+=0.2
     -- limites de velocidade
     self.vx=mid(-3,self.vx,3)
     self.vy=mid(-3,self.vy,3)
     -- aplica a velocidade
     self.x+=self.vx
     self.y+=self.vy
   end,
   check_coin_collision=function(self,coin)
     if objects_overlapping(self, coin) and not coin.is_collected then
       coin.is_collected=true
       score+=1
     end
   end,
   check_block_collision=function(self,block)
     -- calculate the four hitboxes
     local x,y,w,h = self.x, self.y, self.width, self.height
     local top_hitbox={x=x+3.1,y=y,width=w-6.2,height=h/2}
     local bottom_hitbox={x=x+3.1,y=y+h/2,width=w-6.2,height=h/2}
     local left_hitbox={x=x,y=y+3.1,width=w/2,height=h-6.2}
     local right_hitbox={x=x+w/2,y=y+3.1,width=w/2,height=h-6.2}
     if objects_overlapping(bottom_hitbox,block) then
       self.y=block.y-self.height
       if (self.vy>0) self.vy=0   -- impede que aumente vy quando em cima de um bloco
       self.is_standing_on_block=true
     elseif objects_overlapping(right_hitbox,block) then
       self.x=block.x-self.width
       if (self.vx>0) self.vx=0
     elseif objects_overlapping(left_hitbox,block) then
       self.x=block.x+self.width
       if (self.vx<0) self.vx=0
     elseif objects_overlapping(top_hitbox,block) then
       self.y=block.y+self.height
       if (self.vy<0) self.vy=0   -- impede que aumente vy quando em baixo de um bloco
     end
   end
  })
end

-- game object creation functions
function make_block(x,y)
  return make_game_obj(x,y,8,8,{
    draw=function(self)
      spr(6,self.x,self.y)
      -- rect(self.x,self.y,self.x+self.width,self.y+self.height,8)
    end
  })
end

function make_coin(x,y)
  return make_game_obj(x,y,6,7,{
    is_collected=false,
    draw=function(self)
      if not self.is_collected then
        spr(17,self.x,self.y)
        -- rect(self.x,self.y,self.x+self.width,self.y+self.height,12)
      end
    end
  })
end


function make_game_obj(x,y,width,height,properties)
  local obj={
    x=x,
    y=y,
    width=width,
    height=height,
    update=function(self)
      -- do nothing
    end,
    draw=function(self)
      -- don't draw anything
    end,
    center=function(self)
      return self.x+self.width/2,self.y+self.height/2
    end,
    check_for_hit=function(self, other)
      return objects_overlapping(self,other)
    end,
    check_for_collision=function(self,other)
    end
  }
  -- add additional properties
  local key,value
  for key,value in pairs(properties) do
    obj[key]=value
  end
  -- add to the game objects
  add(game_objects,obj)
  --return game object
  return obj
end

-- hit detection helper functions
function rects_overlapping(left1,top1,right1,bottom1,left2,top2,right2,bottom2)
  return right1>left2 and right2>left1 and bottom1>top2 and bottom2>top1
end

function objects_overlapping(obj1, obj2)
  return rects_overlapping(obj1.x,obj1.y,obj1.x+obj1.width,obj1.y+obj1.height,obj2.x,obj2.y,obj2.x+obj2.width,obj2.y+obj2.height)
end

-- function circ_overlapping(x1,y1,r1,x2,y2,r2)
--   local dx=mid(-127,x2-x1,127)   -- maximum distance is 128 (screen size). evita oveflow
--   local dy=mid(-127,y2-y1,127)
--   -- local dist=sqrt(dx*dx+dy*dy)
--   -- return dist<r1+r2
--   -- substituindo sqrt() por multiplicacao por ser menos intenso computacionalmente
--   return dx*dx+dy*dy<(r1+r2)*(r1+r2)
-- end

__gfx__
00000000000777000000000000000000000000000000000077777777000000000000000000000000000000000000000000000000000000000000000000000000
0000000000700070000000000000000000000000000000007666666d000000000000000000000000000000000000000000000000000000000000000000000000
00700700000777000000000000000000000000000000000076777d6d000000000000000000000000000000000000000000000000000000000000000000000000
00077000000070000000000000000000000000000000000076766d6d000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777770000000000000000000000000000000076766d6d000000000000000000000000000000000000000000000000000000000000000000000000
00700700000070000000000000000000000000000000000076dddd6d000000000000000000000000000000000000000000000000000000000000000000000000
0000000000070700000000000000000000000000000000007666666d000000000000000000000000000000000000000000000000000000000000000000000000
0000000000700070000000000000000000000000000000007ddddddd000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003c0173b0173802736037340373304731047300572e0572c0572a05728057260572405722057200571f0571c0571b057180571605713057110570f0570d0570c0570b0570905707057050570105700007
