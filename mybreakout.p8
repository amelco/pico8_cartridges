pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
ball_x=1
ball_dx=2
ball_y=64
ball_dy=2
ball_r=2
ball_dr=0.5
frame=0
col=0

function _init()
 cls()
end

function _update()
 frame+=1
 ball_x+=ball_dx
 ball_y+=ball_dy

 if ball_x>127 or ball_x<0 then
  ball_dx=-ball_dx
  sfx(0)
 end
 if ball_y>127 or ball_y<0 then
  ball_dy=-ball_dy
  sfx(0)
 end
end

function _draw()
 cls(1)
 circfill(ball_x,ball_y,ball_r,10)
end
__sfx__
000100001734017340173401733017320173100c300083000730007300093000a3000c3000e300113001330013300020000200001000010000200001000010000100001000010000100001000010000100001000
