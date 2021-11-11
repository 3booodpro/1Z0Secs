extends Node2D

onready var cam = $Camera2D

func _on_Timer_timeout():
	cam.get_node("CanvasLayer/Control/ProgressBar").value += 1
	if cam.get_node("CanvasLayer/Control/ProgressBar").value >= 120:
		SceneChanger.ChangeScene("res://Scenes/Win.tscn")
	pass # Replace with function body.
