pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--station commander
--by vanawy

function _init()
 frame=1
 --init_menu()
 init_game()
end

function _update()
 frame+=1
 _uupdate()
end


function init_menu()
 _uupdate = update_menu
 _draw = draw_menu
 
	menu={}
	add(menu,"start")
	add(menu,"help")
	sel_action=1
	menu_act={}
	add(menu_act,init_game)
	add(menu_act,init_help)
end

function update_menu()
	if(btnp(⬆️)) sel_action-=1
	if(btnp(⬇️)) sel_action+=1
	if(sel_action>#menu) then
	 sel_action=sel_action%#menu
	end
	if(sel_action<1) sel_action=#menu
 
 if(btnp(❎) or btnp(🅾️)) then
  menu_act[sel_action]()
 end
end

function draw_menu()
 cls()
 print("station command",32,16,8)

	for i,action in ipairs(menu) do
	 local c=6
	 if(i==sel_action) then
	  c=7
	  action=">"..action.."<"
	 end
	 print(action,32,16+i*8,c)
	end
	print("⬆️,⬇️-up,down;❎,🅾️-select",
	 8,120,7
	)
end
-->8
--game state

function init_game()
 _uupdate = update_game
 _draw = draw_game
 frame=1
 
	make_target()
	explosions={}
end

function update_game()
 update_target()
 if(btnp(❎)) make_explosion(t.x,t.y)
 foreach(explosions,update_explosion)
end

function draw_game()
 cls()
 print(frame)
 draw_target() 
 foreach(explosions,draw_explosion)
end

function make_target()
	t={}
	t.x=64
	t.y=64
	t.sprite=1	
end

function draw_target()
	spr(t.sprite, t.x-4, t.y-4) 
end

function update_target()
	if (btn(⬅️)) t.x-=1
	if (btn(➡️)) t.x+=1
	if (btn(⬆️)) t.y-=1
	if (btn(⬇️)) t.y+=1
	t.x=range(t.x,0,128)
	t.y=range(t.y,0,128)
end

function make_explosion(x,y)
 local exp={}
 exp.x=x
 exp.y=y
 exp.r=6
 exp.ttl=0.5
 exp.time=exp.ttl
 add(explosions,exp)
 sfx(0)
end

function update_explosion(e)
 e.time-=1/30
 if(e.time<0) then
  del(explosions,e)
  return
 end
end

function draw_explosion(e)
 explosion(e.x,e.y,
  e.r-mapvalue(e.time,0,e.ttl,0,e.r)
 )
end


-->8
--game over state
-->8
--help

function init_help()
 _uupdate = update_help
 _draw = draw_help
end

function update_help()
 if(btnp(❎) or btnp(🅾️)) init_menu()
end

function draw_help()
 cls()
 print("help")
	print("❎,🅾️-back to menu",
	 8,120,7
	)
 
end
-->8
--misc

function range(v,a,b)
 return max(a,min(b,v))
end

function animate(start,len,frames,inc)
 return start+(inc or 1)
  *((frame/frames or 1)%len)
end

function mapvalue(v,a,b,ta,tb)
 return ta+(v-a)/(b-a)*(tb-ta)
end
-->8
--vfx

function explosion(x,y,r,c)
 circfill(x,y,r,c or 9)
 circfill(x,y,r-1,7)
end

function laser(x1,y1,x2,y2,w,c)
 local h=flr(w/2)
 for i=-h,h do
  local lx,ly,lx2,ly2
  local k=(y2-y1)/(x2-x1)
  lx=x1+(-1/k*(h+i))
  ly=y1+(-1/k*(h+i))
  lx2=x2-(-1/k*(h+i))
  ly2=y2+(-1/k*(h+i))
  color(7)
  if(abs(i)==h) color(c or 9)
  line(lx1,ly1,lx2,ly2)		   
 end
end
__gfx__
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010f00000c6500c6400c6300c6200c610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
