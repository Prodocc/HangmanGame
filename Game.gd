extends Node2D

@export
var group: ButtonGroup
var words_path = "res://words_list.txt"
var words_list
var curr_word
var word_to_guess
var letters_to_guess
var tries_to_lose = 6
var max_tries = 6
var sprites

# Called when the node enters the scene tree for the first time.
func _ready():
	$RoundResult.visible = false
	$Restart.visible = false
	$WordLabel.visible = false
	sprites = [$HeadSprite, $BodySprite, $LeftHandSprite, 
				$RightHandSprite, $LeftLegSprite, $DeathSprite]
	var file = FileAccess.open(words_path,FileAccess.READ)
	print("error after")
	print(FileAccess.get_open_error())
	print("error before")
	words_list = file.get_as_text().split("\n")
	file.close()
	for i in group.get_buttons():
		i.pressed.connect(self._button_pressed)
	_pick_new_word()
	print(curr_word)

func _button_pressed():
	var pressed_button = group.get_pressed_button().to_string()[0]
	_check_letter(pressed_button)
	group.get_pressed_button().disabled = true
	if(_check_win() || _check_lose()):
		$Restart.visible = true
		$RoundResult.visible = true
		for i in group.get_buttons():
			i.disabled = true
	else:
		$PencilSound.play()
		
		
func _on_restart_pressed():
	$PencilSound.play()
	$Restart.visible = false
	$RoundResult.visible = false
	for i in sprites:
		i.visible = false
	_pick_new_word()
	_enable_buttons()
	tries_to_lose = 6
	print(curr_word)
	

func _pick_new_word():
	curr_word = words_list[randi() % words_list.size() - 1]
	var tmp = []
	for i in curr_word.length():
		tmp.append("-")
	word_to_guess = ''.join(tmp)
	letters_to_guess = word_to_guess.length()
	$WordLabel.text = word_to_guess
	$WordLabel.visible = true

func _enable_buttons():
	for i in group.get_buttons():
		i.disabled = false
		
		
		
func _check_letter(pressed_button):
	var letters_indexes_array = []
	var letters_to_open = curr_word.count(pressed_button)
	print(letters_to_open)
	var from = 0
	if(letters_to_open): # contains letter(s)
		for i in letters_to_open:
			letters_indexes_array.append(curr_word.find(pressed_button, from))
			from = letters_indexes_array[i] + 1
		for j in letters_indexes_array:
			word_to_guess[j] = pressed_button
		$WordLabel.text = word_to_guess
		letters_to_guess = letters_to_guess - letters_to_open
	else:
		sprites[max_tries - tries_to_lose].visible = true
		tries_to_lose = tries_to_lose - 1		# doesn't contain letter(s)
		
		
func _check_win():
	if(letters_to_guess == 0):
		$RoundResult.text = 'You Win'
		$WinSound.play()
		return true
		
func _check_lose():
	if(tries_to_lose == 0):
		$NeckSnapSound.play()
		$WordLabel.text = curr_word
		$RoundResult.text = 'You Lose'
		return true

func _draw():
	var col = Color(0,0,0)
	var rect0 = Rect2(Vector2(725,550), Vector2(375,25))
	var rect1 = Rect2(Vector2(1000,550), Vector2(25,-475))
	var rect2 = Rect2(Vector2(1025,50), Vector2(-225,25))
	var rect3 = Rect2(Vector2(875,50), Vector2(25,125))
	draw_rect(rect0,col,true)
	draw_rect(rect1,col,true)
	draw_rect(rect2,col,true)
	draw_rect(rect3,col,true)
	draw_line(Vector2(955,560),Vector2(1015,460),col,25)
	draw_line(Vector2(1070,560),Vector2(1015,470),col,25)
