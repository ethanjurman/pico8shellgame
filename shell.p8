pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
state = "start"
round = 0
max_shuffles = 4
shuffles = 1
speed = 1
cursr = 1
winner = 1
rh=30 // raised height
lh=60 // lowered height
shell_arr={
 {10,rh},{50,rh},{90,rh}
}
shell_goal={
 {10,rh},{50,rh},{90,rh}
}
selected_shuffle_shells={}
points=0
debug=""

function draw_cursor()
 if cursr==1 then
 	sspr(40,0,16,16,10,60,32,32)
 end
 if cursr==2 then
 	sspr(40,0,16,16,50,60,32,32)
 end
 if cursr==3 then
 	sspr(40,0,16,16,90,60,32,32)
 end
end

function draw_shell(x,y)
	sspr(8,0,16,16,x,y,32,32)
end

function lower_shells(
  ending_state
)
	number_low = 0
	for i=1,#shell_arr do
		shell_goal[i][2]=lh
		if shell_arr[i][2] == lh then
			number_low+=1
		end
	end
	if number_low == #shell_arr then
		state=ending_state
	end
end

function reveal_shell(ending_state)
 shell_goal[1][2] = rh
	if shell_arr[1][2] == rh then
		if ((cursr-1)*40 + 10) == shell_arr[1][1] then
		 sfx(0)
			points+=1
		else
			sfx(1)
		end
		state=ending_state
	end
end

function raise_shells(
  shells,
  ending_state
)
	number_raised = 0
	for s in all(selected_shuffle_shells) do
  shell_goal[s][2] = rh
		if shell_arr[s][2] == rh then
			number_raised+=1
		end
	end
	if number_raised == #shells then
		state=ending_state
	end
end

function swap_selected_shells(
 shells,
 ending_state
)
 s1 = shell_arr[shells[1]]
 s2 = shell_arr[shells[2]]
 shell_goal[shells[1]][1] = s2[1]
 shell_goal[shells[2]][1] = s1[1]
 sfx(2)
 state = "shuffling"
end

function draw_coin()
	sspr(24,0,16,16,shell_arr[1][1]+8,lh+8,16,16)
end

function select_shells()
	s1 = flr(rnd(3)) + 1
	s2 = s1
	while s2 == s1 do
	 s2 = flr(rnd(3)) + 1
 end
 return {s1,s2}
end

function _init()
 state = "hide"	
 round = 0
end

function _update60()
 // move shells based on goal
 for i=1,#shell_arr do
 	if shell_arr[i][1] > shell_goal[i][1] then
 		shell_arr[i][1]-=speed
 		shell_arr[i][1]=max(shell_goal[i][1],shell_arr[i][1])
		end
		if shell_arr[i][1] < shell_goal[i][1] then
 		shell_arr[i][1]+=speed
 		shell_arr[i][1]=min(shell_goal[i][1],shell_arr[i][1])
		end
		if shell_arr[i][2] > shell_goal[i][2] then
 		shell_arr[i][2]-=speed
 		shell_arr[i][2]=max(shell_goal[i][2],shell_arr[i][2])
		end
		if shell_arr[i][2] < shell_goal[i][2] then
 		shell_arr[i][2]+=speed
 		shell_arr[i][2]=min(shell_goal[i][2],shell_arr[i][2])
		end
 end

	if state=="start" then
		if btn(4) or btn(5) then
			state="hide"
			round=0
		end
	end
	if state=="hide" then
		lower_shells(
		 "shuffle_start"
		)
		selected_shuffle_shells = select_shells()
	end
	if state=="shuffle_start" then
		raise_shells(
		 selected_shuffle_shells,
		 "shuffle_raised"
		)
	end
	if state=="shuffle_raised" then
		swap_selected_shells(
		 selected_shuffle_shells
		)
	end
	if state=="shuffling" then
		if shell_arr[1][1]==shell_goal[1][1] and
		   shell_arr[2][1]==shell_goal[2][1] and
		   shell_arr[3][1]==shell_goal[3][1] then
		 state="finish_shuffle"   	
  end
	end
	if state=="finish_shuffle" then
		if (shuffles > 0) then
		 state="shuffle_start"
			shuffles-=1
			selected_shuffle_shells = select_shells()
			lower_shells("shuffle_start")
		else
			state="ready"
			shuffles=max_shuffles
			lower_shells("ready")
		end
	end
	if state=="ready" or state=="reveal" then
		if btnp(➡️) then cursr+=1 end
		if btnp(⬅️) then cursr-=1 end
		if cursr>3 then cursr=3 end
		if cursr<1 then cursr=1 end
		if btnp(🅾️) then
		 state="reveal"
		 round+=1
		 speed+=0.25
		 if (round%10==0) then
		 	speed-=1.5
   end
		 if (round%5==0) then
		 	max_shuffles+=1
   end
		end
	end
	if state=="reveal" then
		reveal_shell("hide")
	end
end

function _draw()
 cls(15)
 // draw table
 rectfill(5,75,125,105,5)
 rectfill(5,70,125,100,4)
 rectfill(5,70,10,130,4)
 rectfill(120,70,125,130,4)
 if state=="hide" or state=="reveal" then
		draw_coin()
 end
 
 for i in all(shell_arr) do
 	draw_shell(
 	 i[1],
 	 i[2]
 	)
 end
 
 if state=="ready" then
 	draw_cursor()
 end
 //debug=state
	//print(debug)
	rectfill(92,10,130,20,5)
	rectfill(90,8,130,18,4)
	print(points,115,10,7)
end
__gfx__
00000000077707777777770000000aaaaaa0000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000
000000007666766666666670000aaaaaaaaaa000000cc777777cc000000000000000000000000000000000000000000000000000000000000000000000000000
007007007d6667777666666700aaa777777aaa0000c7700000077c00000000000000000000000000000000000000000000000000000000000000000000000000
000770007dd677667777666709aa7aaaa7a7aaa00c770000000077c0000000000000000000000000000000000000000000000000000000000000000000000000
0007700007d76676666777670aaaaaaaaa7a7aa00c700000000007c0000000000000000000000000000000000000000000000000000000000000000000000000
007007007677d667666667779a7aaaaaaaaaa7aac70000000000007c000000000000000000000000000000000000000000000000000000000000000000000000
000000007d767d667d666667aaaaaaaaaaaa777ac70000000000007c000000000000000000000000000000000000000000000000000000000000000000000000
000000007d7d67d667d666679a9aaaaaaaaaa7aac70000000000007c000000000000000000000000000000000000000000000000000000000000000000000000
000000007d77667d667ddd679a9aaaaaaaaaa7aac70000000000007c000000000000000000000000000000000000000000000000000000000000000000000000
000000007d67d667d66777d79aaaaaaaaaaaa7aac70000000000007c000000000000000000000000000000000000000000000000000000000000000000000000
000000007d67dd667d6666779aa9aaaaaaaaa7aac70000000000007c000000000000000000000000000000000000000000000000000000000000000000000000
000000007d677d66676666700aa9aaaaaaaa7aa00c700000000007c0000000000000000000000000000000000000000000000000000000000000000000000000
000000007d667dd667d6677009aa9aaaaaaaaaa00c770000000077c0000000000000000000000000000000000000000000000000000000000000000000000000
000000007ddd77dd67dd7700009aa9a99a7aaa0000c7700000077c00000000000000000000000000000000000000000000000000000000000000000000000000
0000000007ddd7dddd7770000009aaaaaaaa9000000cc777777cc000000000000000000000000000000000000000000000000000000000000000000000000000
000000000077777777700000000009999a90000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000026750287502b7502c7503075027750297502b7502d7502f7503d7003a70016700167001670016700157001570015700147000b7000000000000000000000000000000000000000000000000000000000
00010000167501475013750107500c7500c750197501675013750107500e750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000046100061000610036100b6101061015610196101d610216102461026610276102961029610296102a6102a610296102861027610266102461023610216101f6101e6101b61016610106100a61005610
