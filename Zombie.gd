extends KinematicBody2D

onready var target = get_parent().get_node("Player")
var health = 1
var movespeed = 220
var strong = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Line2D.set_as_toplevel(true)
	pass # Replace with function body.

func _physics_process(delta):
	var path = get_parent().get_node("Navigation2D").get_simple_path(position,target.position)
	var for_wall = Vector2()
	$Line2D.set_deferred("points",path)
	look_at(path[1])
	if is_on_wall():
		if !$RayCast1.is_colliding() && $RayCast2.is_colliding():
			for_wall = Vector2(0,-movespeed).rotated(rotation)
		elif $RayCast1.is_colliding() && !$RayCast2.is_colliding():
			for_wall = Vector2(0,movespeed).rotated(rotation)
		else:
			for_wall = Vector2()
	move_and_slide((path[1] - position).normalized() * movespeed + for_wall)
	if position.distance_to(target.position) < 35 && $Timer.is_stopped():
		$Timer.start()
		target.hit(strong)
		$Attack.play()
	pass

func damage(value):
	health -= value
	if health <= 0:
		var Blood = preload("res://Scenes/Blood.tscn").instance()
		Blood.position = position
		Blood.emitting = true
		Blood.local_coords = true
		Blood.process_material.initial_velocity = 128
		Blood.process_material.spread = 45
		Blood.process_material.direction.x = -1
		Blood.process_material.damping = 100
		Blood.rotation = rotation
		Blood.get_node("Sound").autoplay = true
		get_parent().add_child(Blood)
		Global.zombies_killed += 1
		queue_free()
	pass
