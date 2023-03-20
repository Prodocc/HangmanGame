extends Node

var modulatePropertyValue = 0
var count = 0
var maxDelta = 5
var startToDraw = false
var angular_speed = PI
var tumble_weed_init_position = Vector2(1300, 562)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/TumbleWeedSprite.visible = false
	$ColorRect/TumbleWeedSprite.position = tumble_weed_init_position
	$Timer.set_wait_time(1)
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(startToDraw):
		if(modulatePropertyValue < 1):
			if(count == maxDelta):
				count = 0
				modulatePropertyValue = (modulatePropertyValue + delta)
				var nextColor = Color(1,1,1, modulatePropertyValue)
				$ColorRect/Label.modulate = nextColor
				$ColorRect/Button.add_theme_color_override("font_color",
								Color(0,0,0, modulatePropertyValue))
			else:
				count = count + 1
		else:
			$ColorRect/TumbleWeedSprite.visible = true
			startToDraw = false
	else:
		$ColorRect/TumbleWeedSprite.rotation -= angular_speed * delta # rotate tumbleweed
		$ColorRect/TumbleWeedSprite.position.x -= 2.5


func _on_timer_timeout():
	print('Time_out')
	startToDraw = true
	$ColorRect/Button.add_theme_color_override("font_hover_color",
								Color(0, 0, 0, 0.58823531866074))
	$Timer.stop()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")
