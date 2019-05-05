pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
 cls()
 
 ball_x=1
 ball_y=33
 ball_x_ant=nil
 ball_y_ant=nil
 ball_dx=2
 ball_dy=2
 ball_r=2
 ball_dr=0.5
 
 pad_x=52
 pad_y=120
 pad_dx=0
 pad_w=24
 pad_h=3
	pad_c=7
end

function _update()
 local buttpress=false
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
 if ball_y<0 then
  ball_dy=-ball_dy
  sfx(0)
 end
 
 pad_c=7
 -- chack if ball hits pad
 if ball_box(pad_x,pad_y,pad_w,pad_h) then
  -- deal with collision
  if refl_ball_v(ball_x_ant,ball_y_ant,ball_x,ball_y,pad_x,pad_y,pad_x+pad_w,pad_y,pad_x+pad_w,pad_y+pad_h,pad_x,pad_y+pad_h) then
   ball_dy=-ball_dy
  else
   ball_dx=-ball_dx
  end
  pad_c=8
 end
 
 ball_x_ant=ball_x
 ball_y_ant=ball_y
end


function _draw()
 cls(1)
 circfill(ball_x,ball_y,ball_r,10)
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
end

function ball_box(box_x,box_y,box_w,box_h)
 -- checks for collision of the ball with a rectngle
 if ball_y-ball_r>box_y+box_h then
  return false
 end
 if ball_y+ball_r<box_y then
  return false
 end
 if ball_x-ball_r>box_x+box_w then
  return false
 end
 if ball_x+ball_r<box_x then
  return false
 end
 return true
end

function refl_ball_v(bxa,bya,bx,by,tx1,ty1,tx2,ty2,tx3,ty3,tx4,ty4)
 local m1,m2 -- slopes
 local dx,dy -- deltas
 local q1,q2,q3,q4 -- quadrants
 local mx,my -- helpers to find m2
 --find the quadrant
 dx=bx-bxa
 dy=by-bya
 m1=dy/dx
 if dx>0 then
  if dy>0 then 
   q1=true 
   my=ty1 
   mx=tx1 
  end
  if dy<0 then 
   q4=true 
   my=ty4 
   mx=tx4 
  end
 elseif dx<0 then
  if dy>0 then 
   q2=true 
   my=ty2 
   mx=tx2 
  end
  if dy<0 then 
   q3=true 
   my=ty3 
   mx=tx3 
  end
 end
 m2=(my-bya)/(mx-bxa)
 -- check if ball comes vert. or horiz.
 if dx==0 then 
  return true
 elseif dy==0 then
  return false
 end
 if q1 or q3 then
  if m1<m2 then 
   return false
  else 
   return true 
  end
 elseif q2 or q4 then
  if m1<m2 then 
   return true
  else 
   return false 
  end
 end
end

__sfx__
000100001734017340173401733017320173100c300083000730007300093000a3000c3000e300113001330013300020000200001000010000200001000010000100001000010000100001000010000100001000
