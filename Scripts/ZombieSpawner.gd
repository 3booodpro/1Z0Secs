extends Node2D

var rng = RandomNumberGenerator.new()
onready var progress_bar = get_parent().get_node("Camera2D/CanvasLayer/Control/ProgressBar")
onready var timer = $Timer

func _ready():
	randomize()
	rng.seed = randi()
	pass

func _on_Timer_timeout():
	if progress_bar.value < 40:
		timer.wait_time = 2
		var Zombie = preload("res://Scenes/Zombie.tscn").instance()
		Zombie.position = get_node(str(rng.randi_range(0,10))).position
		get_parent().add_child(Zombie)
	elif progress_bar.value >= 40 && progress_bar.value < 80:
		timer.wait_time = 1.5
		var Zombie = preload("res://Scenes/Zombie.tscn").instance()
		Zombie.position = get_node(str(rng.randi_range(0,10))).position
		Zombie.movespeed = 260
		Zombie.health = 2
		Zombie.modulate = Color(0.25098, 0.501961, 0.25098)
		get_parent().add_child(Zombie)
	elif progress_bar.value >= 80 && progress_bar.value < 120:
		timer.wait_time = 1
		var luck = rng.randi_range(1,100)
		if luck <= 25:
			var Zombie = preload("res://Scenes/ZombieBomb.tscn").instance()
			Zombie.position = get_node(str(rng.randi_range(0,10))).position
			get_parent().add_child(Zombie)
		else:
			var Zombie = preload("res://Scenes/Zombie.tscn").instance()
			Zombie.position = get_node(str(rng.randi_range(0,10))).position
			Zombie.movespeed = 260
			Zombie.health = 2
			Zombie.modulate = Color(0.25, 0.5, 0.25)
			get_parent().add_child(Zombie)
	else:
		timer.stop()
		print("Win")
	pass # Replace with function body.
