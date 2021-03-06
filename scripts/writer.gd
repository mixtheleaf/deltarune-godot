extends Control

var font:= preload("res://some_fonts/font.tres")

export var cur_color:Color
var special:=1
export var char_pos:Vector2
export var writing_pos:Vector2
export var rate:int

const portrait_offset = 84

var hspace:=16
var vspace:=36

func draw_char_custom(ch:String,font:Font):
	if special==1:
		if cur_color!=Color.white and cur_color!=Color.black:
			draw_char(font,char_pos+Vector2(1,1),ch,'',Color(1,1,1,0.3)*cur_color)
			draw_char(font,char_pos,ch,'',cur_color)
		else:
			draw_char(font,char_pos+Vector2(1,1),ch,'',Color(0,0,0.5))
			draw_char(font,char_pos,ch,'')
	else:
		draw_char(font,char_pos,ch,'',cur_color)
	char_pos.x+=hspace

var maxi:=0
var halt:=0

var curchar='string[i]'
var nextchar:=''
var nextchar2:=''
var prevchar:=''
var prevchar2:=''

var charline:=33

func _draw():
	char_pos=writing_pos
	var cid:=1
	var string=Global.msg
	var i:=0
	halt=0
	var linecount:=1
	var skipme:bool
	var length:=maxi
	if skip_button_held_down:
		skipme=true
	while i<length:
		var accept:=true
		curchar=string[i]
		nextchar=''
		nextchar2=''
		prevchar=''
		prevchar2=''
		if i<len(string)-1:
			nextchar=string[i+1]
		if i<len(string)-2:
			nextchar2=string[i+2]
		if i>1:
			prevchar=string[i-1]
		if i>2:
			prevchar2=string[i-2]
		if curchar=='&':
			print('what')
			accept=false
			linecount+=1
			char_pos.x=writing_pos.x
			char_pos.y+=vspace
		if curchar=='/':
			halt=1
			accept=false
			if nextchar=='%':
				halt=2
		if curchar=='%':
			accept=false
			if prevchar=='/':
				halt=2
			if nextchar=='%':
				queue_free()
			elif halt!=2:
				Global.nextmsg(self)
		if curchar=='\\':
			accept=false
			i+=2
			if nextchar=='s':
				if nextchar2=='0' and skipme:
					skipme=true
				elif nextchar2=='1':
					skipme=false
		if curchar=='^':
			accept=false
			i+=1
		if accept:
			draw_char_custom(curchar,Global.font)
			print(cid)
			cid+=1
			if cid>=charline:
				string=string.insert(i+1,'&')
				print(string)
				length+=1
				cid=1
		i+=1
		
	if proceed_button_held_down:
		match halt:
			1:
				Global.nextmsg(self)
			2:
				queue_free()
	if skipme:
		$Timer.start(0.01)
	

func _ready():
	$Timer.start(0.01)

#get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
#yield(VisualServer, "frame_post_draw")
#var temp:= get_viewport().get_texture()
#var imgtmp:=temp.get_data()
#imgtmp.lock()
#get_node("Label").text=str(imgtmp.get_pixelv(get_viewport().get_mouse_position())*255)
#imgtmp.unlock()

func _process(delta):
	update()

func next_msg():
	maxi=0
	halt=0
	$Timer.start(0.01)

var skip_button_held_down:=false
var proceed_button_held_down:=false
var automash_timer:=0


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		skip_button_held_down=true
	if event.is_action_released("ui_cancel"):
		skip_button_held_down=false
	if event.is_action_pressed("ui_accept"):
		proceed_button_held_down=true
	if event.is_action_released("ui_accept"):
		proceed_button_held_down=false


func _on_Timer_timeout():
	print('what')
	if maxi<len(Global.msg):
		print('hi')
		var cchar:=Global.msg[maxi]
		var nchar:=''
		if maxi<len(Global.msg)-1:
			nchar=Global.msg[maxi+1]
		if cchar=='/':
			halt=1
			$Timer.stop()
		if cchar=='|':
			maxi+=1
		if cchar=='^':
			if $Timer.time_left>=0.0:
				match int(nchar):
					1:
						$Timer.start($Timer.time_left+5.0/30.0)
					2:
						$Timer.start($Timer.time_left+10.0/30.0)
					3:
						$Timer.start($Timer.time_left+15.0/30.0)
					4:
						$Timer.start($Timer.time_left+20.0/30.0)
					5:
						$Timer.start($Timer.time_left+30.0/30.0)
					6:
						$Timer.start($Timer.time_left+40.0/30.0)
					7:
						$Timer.start($Timer.time_left+60.0/30.0)
					8:
						$Timer.start($Timer.time_left+90.0/30.0)
					9:
						$Timer.start($Timer.time_left+150.0/30.0)
				print($Timer.time_left)
		maxi+=1
		if cchar!='/' and $Timer.time_left==0.0:
			$Timer.start(max(float(rate)/30.0,0.01))
