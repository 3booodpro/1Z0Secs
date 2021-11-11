extends KinematicBody2D

var movespeed = 1000
var damage = 1

func _physics_process(delta):
	move_and_slide(Vector2(movespeed,0).rotated(rotation))
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		pass
	elif body.is_in_group("Enemy"):
		body.damage(damage)
		queue_free()
	else:
		queue_free()
	pass # Replace with function body.
