extends Node

var zombies_killed = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("F11"):
		OS.window_fullscreen = !OS.window_fullscreen
		return
#	if Input.is_action_just_pressed("ui_accept"):
#		var img = Image.new()
#		img.data = get_tree().get_root().get_viewport().get_texture().get_data().data
#		img.flip_y()
#		img.save_png("res://Assets/Image3.png")
	pass
