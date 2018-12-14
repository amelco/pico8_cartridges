pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- arkanoid (arknoid)
-- first game in pico
-- for learning purposes
-- by andre herman

-- to do next
-- consertar colisao entre a barra e a bola
-- definir objeot bloco
-- colisao entre bola e bloco


local player
local ball
local ball_ant_x
local ball_ant_y
local blocks
local hud
local lives
local debug=false

function _init()
  -- quantidade inicial de vidas
  lives = 3
  -- definindo o joagdor (barra/bastao)
  player = {
    x = 64,
    y = 110,
    width = 24,
    height = 6,
    speed = 1,
    vx = 0,
    update = function(self)
      if (btn(0)) self.vx -= self.speed
      if (btn(1)) self.vx += self.speed
      -- aplica friccao
      self.vx = self.vx * 0.85
      -- aplica a velocidade
      self.x += self.vx
      -- checa limites da tela
      if self.x < 0 then
        self.x = 0
        self.vx = 0
      elseif self.x + self.width > 127 then
        self.x = 127 - self.width
        self.vx = 0
      end
    end,
    draw = function(self)
      spr(1, self.x, self.y, 3, 1)
      if debug then
        rect(self.x, self.y, self.x+self.width, self.y+self.height, 8)
      end
    end
  }

  -- definindo a bola
  ball ={
    -- posicao inicial da bola: no cetro do bastao
    x = player.x + player.width/2 - 4,
    y = player.y - player.height,
    width = 6,
    height = 6,
    speedx = 0,
    speedy = 0,
    maxspeed = 3,
    vx = 0,
    vy = 0,
    is_standing_player = true,
    update=function(self)
      -- se velocidade = 0 e bola tocando bastao, bola move junto com bastao
      if self.vx == 0 and self.vy == 0 and self.is_standing_player then
        self.x = player.x + player.width/2 - 4
        if (btn(4)) self.throw(self)
      end
      -- aplica velocidade
      self.vx += self.speedx
      self.vy += self.speedy
      -- limita a velocidade maxima
      self.vx = mid(-self.maxspeed, self.vx, self.maxspeed)
      self.vy = mid(-self.maxspeed, self.vy, self.maxspeed)
      -- atualiza posicao com base na velocidade
      self.x += self.vx
      self.y += self.vy
      -- checa cantos da tela
      if self.x <= 0 then
        self.x = 1
        self.speedx *= -1
        self.vx *= -1
      elseif self.x >= 127 - self.width then
        self.x = 127 - self.width - 1
        self.speedx *= -1
        self.vx *= -1
      elseif self.y <= 0 then
        self.y = 1
        self.speedy *= -1
        self.vy *= -1
      elseif self.y >= 127 - self.height then
        -- joagdor perde uma vida. bola volta ao inicio
        self.lose(self)
        self.x = player.x + player.width/2 - 4
        self.y = player.y - player.height
        self.vx = 0
        self.vy = 0
        self.speedx = 0
        self.speedy = 0
        self.is_standing_player = true
      end
      -- checa colisao com o bastao
      local x,y,w,h = player.x,player.y,player.width,player.height
      local top_hitbox = {x=x+3, y=y, width=w-6, height=h}
      local left_hitbox = {x=x, y=y, width=3, height=h}
      local right_hitbox = {x=x+w-3, y=y, width=3, height=h}
      -- aqui vem a matematica para redirecionar a bola dependendo da
      --   velocidade do bastao e direcao da bola
      if not self.is_standing_player then
        if objects_overlapping(self, top_hitbox) then -- checa colisao da bola com topo do bastao
          self.y = player.y - self.width
          self.speedy *= -1
          self.vy *= -1
        elseif objects_overlapping(self, left_hitbox) then  -- checa colisao da bola com lado esquerdo do bastao
          self.x = player.x-self.width
          self.speedx *= -1
          self.vx *= -1
        elseif objects_overlapping(self, right_hitbox) then -- checa colisao da bola com lado direito do bastao
          self.x = player.x+player.width
          self.speedx *= -1
          self.vx *= -1
        end
      end
    end,
    draw=function(self)
      spr(4, self.x, self.y)
      if debug then
        rect(self.x, self.y, self.x+self.width, self.y+self.height, 7)
        rectfill(player.x+3, player.y, player.x+player.width-3, player.y+player.height, 2)
        rectfill(player.x, player.y, player.x+3, player.y+player.height, 3)
        rectfill(player.x+player.width-3, player.y, player.x+player.width, player.y+player.height, 4)
        pset(self.x, self.y, 8)
      end
    end,
    throw=function(self)
      -- inserir a matematica para lancar a bola de acordo com a velocidade
      --   e direcao do bastao. Se bastao parado, vx e vy aleatorios
      self.speedy = -self.maxspeed * rnd()
      self.speedx = self.maxspeed * rnd()
      if (rnd()>0.5) self.maxspeed *= -1
      self.is_standing_player = false
    end,
    lose = function(self)
      -- player perde uma vida
      lives -= 1
    end
  }

  -- definindo o head over display
  hud = {
    x=5,
    y=123,
    lifes=3,
    update = function(self)

    end,
    draw = function(self)
      print("lives: "..lives, self.x, self.y)
      -- debug
      if debug then
        print ("pw="..player.width, 5, 5)
        print ("ph="..player.height, 5, 13)
        print ("bw="..ball.width, 50, 5)
        print ("bh="..ball.height, 50, 13)
      end
    end
  }

  blocks={}
  add(blocks,make_blocks(50,50))
end

function _update()
  player:update()
  ball:update()
  local block
  for block in all(blocks) do
    block:update(ball_ant_x,ball_ant_y)
    -- armazena posicao da bola
    ball_ant_x = ball.x
    ball_ant_y = ball.y
  end
end

function _draw()
  cls()
  rect(0,0,127,127, 1)
  player:draw()
  ball:draw()
  hud:draw()
  local block
  for block in all(blocks) do
    block:draw()
  end
end

function make_blocks(x,y)
  return {
    x=x,
    y=y,
    width=16,
    height=8,
    update=function(self)
      -- checa colisao da bola com bloco
      -- argumento posicao x,y do frame anterior
      -- local dx = ball.x - x_ant
      -- local dy = ball.y - y_ant
      -- if objects_overlapping(self, ball) then
      --   ball.x = ball_ant_x
      --   ball.y = ball_ant_y
      --   -- decide a direcao da bola
      --   if dy == 0 then
      --     ball.speedx *= -1
      --     ball.vx *= -1
      --   else
      --
      --   end
      -- end
      -- detecta colisao bola com bloco: top, right, bottom or left
      local x,y,w,h = self.x,self.y,self.width,self.height
      local top_hitbox = {x=x+2, y=y+1, width=w-4, height=h/2-1}
      local bottom_hitbox = {x=x+2, y=h/2, width=w-4, height=h-2}
      local left_hitbox = {x=x, y=y+1, width=1, height=h-2}
      local right_hitbox = {x=x+w-3, y=y+1, width=w-2, height=h-2}
      rect(top_hitbox.x, top_hitbox.y, top_hitbox.x+top_hitbox.width, top_hitbox.y+top_hitbox.height)
      if objects_overlapping(top_hitbox, ball) then
        -- ball.y = self.y - ball.width
        ball.speedy *= -1
        ball.vy *= -1
        del(blocks, self)
      elseif objects_overlapping(bottom_hitbox, ball) then
        -- ball.y = self.y + self.width
        ball.speedy *= -1
        ball.vy *= -1
        del(blocks, self)
      elseif objects_overlapping(left_hitbox, ball) then
        ball.speedx *= -1
        ball.vx *= -1
        del(blocks, self)
      elseif objects_overlapping(right_hitbox, ball) then
        ball.speedx *= -1
        ball.vx *= -1
        del(blocks, self)
      end
    end,
    draw=function(self)
      spr(5, self.x, self.y, 2, 1)
      if debug then
        rect(self.x+2, self.y+1, self.x+self.width-4, self.y+self.height/2-1)
        rect(self.x+2, self.y+self.height/2, self.x+self.width-4, self.y+self.height-2, 2)
        rect(self.x, self.y+1, self.x+1, self.y+self.height-2,3)
        rect(self.x+self.width-3, self.y+1, self.x+self.width-2, self.y+self.height-2,5)
      end
    end
  }
end

function objects_overlapping(obj1, obj2)
  -- detects colision between two retangular aligned (not rotated) objects
  return (obj1.x < obj2.x + obj2.width and obj1.x + obj1.width > obj2.x and obj1.y < obj2.y + obj2.height and obj1.height + obj1.y > obj2.y)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666666666666666666600006666006666666666666666666666666666666600000000000000000000000000000000000000000000000000000000
007007000677777777777777777777600666776069999999999999966eeeeeeeeeeeeee600000000000000000000000000000000000000000000000000000000
0007700067dddddddddddddddddddd760666676069aaaaaaaaaaaaa66e8888888888888600000000000000000000000000000000000000000000000000000000
000770006dddddddddddddddddddddd60766666069aaaaaaaaaaaaa66e8888888888888600000000000000000000000000000000000000000000000000000000
0070070006dddddddddddddddddddd600766666069aaaaaaaaaaaaa66e8888888888888600000000000000000000000000000000000000000000000000000000
00000000006666666666666666666600007766006666666666666666666666666666666600000000000000000000000000000000000000000000000000000000
