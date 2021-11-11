extends Node2D

func _ready():
	$Camera2D/CanvasLayer/Control/VBoxContainer/Play.grab_focus()
	pass # Replace with function body.

func _on_Play_pressed():
	SceneChanger.ChangeScene("res://Scenes/World.tscn")
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_Music_value_changed(value):
	if value == -13:
		AudioServer.set_bus_volume_db(1,-80)
	else:
		AudioServer.set_bus_volume_db(1,value)
	pass # Replace with function body.

func _on_Sounds_value_changed(value):
	if value == -13:
		AudioServer.set_bus_volume_db(2,-80)
	else:
		AudioServer.set_bus_volume_db(2,value)
	pass # Replace with function body.

func _on_Tutorial_pressed():
	$Camera2D/CanvasLayer/Control2.visible = !$Camera2D/CanvasLayer/Control2.visible
	pass # Replace with function body.
