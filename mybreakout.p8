pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
ball_x=1
ball_y=64
ball_dx=2
ball_dy=2
ball_r=2
ball_dr=0.5

pad_x=52
pad_y=120
pad_dx=0
pad_w=24
pad_h=3

function _init()
 cls()
end

function _update()
 buttpress=false
 if btn(0) then
  --left
  pad_dx=-5
  buttpress=true
 end
 if btn(1) then
  --right
  pad_dx=5
  butpress=true
 end
 if not(buttpress) then
  pad_dx/=1.7
 end
 pad_x+=pad_dx
 
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
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,7)
end
__sfx__
000100001734017340173401733017320173100c300083000730007300093000a3000c3000e300113001330013300020000200001000010000200001000010000100001000010000100001000010000100001000
