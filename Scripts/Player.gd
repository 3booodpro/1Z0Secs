extends KinematicBody2D

export(NodePath) var pixel_cam_path = null;

var motion = Vector2(0,0)
var gun_motion = Vector2(0,0)
var movespeed = 280
var health = 30
var shake_strength = 32

var rng = RandomNumberGenerator.new()

var near_table = false

func _ready():
	randomize()
	rng.seed = randi()
	pass

func _physics_process(delta):
	Move()
	Look()
	Shoot()
	move_and_slide(motion + gun_motion)
	if health <= 0:
		if $Death.playing == false:
			$Death.play()
		Global.zombies_killed = 0
		SceneChanger.ReloadScene()
	
	if near_table && Global.zombies_killed >= 50:
		$Label.visible = true
		if Input.is_action_just_pressed("e"):
			var cam = get_node(pixel_cam_path)
			if $AnimationPlayer.current_animation == "gun":
				cam.get_node("CanvasLayer/Control/AnimationPlayer").play("upgrade")
				Global.zombies_killed -= 50
				$ShootTimer.wait_time = 0.175
				$AnimationPlayer.play("gun2")
				health += 15
				health = clamp(health,0,30)
				return
			if $AnimationPlayer.current_animation == "gun2":
				cam.get_node("CanvasLayer/Control/AnimationPlayer").play("upgrade")
				Global.zombies_killed -= 50
				$ShootTimer.wait_time = 0.1
				$AnimationPlayer.play("gun3")
				health += 10
				health = clamp(health,0,30)
				return
			if $AnimationPlayer.current_animation == "gun3":
				Global.zombies_killed -= 50
				$ShootTimer.wait_time = 0.1
				$AnimationPlayer.play("gun3")
				health += 10
				health = clamp(health,0,30)
				cam.get_node("CanvasLayer/Control/Label3").text = "Health"
				cam.get_node("CanvasLayer/Control/AnimationPlayer").play("upgrade")
				return
	else:
		$Label.visible = false
	
	var cam = get_node(pixel_cam_path)
	cam.get_node("CanvasLayer/Control/HurtColor").color.a8 = lerp(cam.get_node("CanvasLayer/Control/HurtColor").color.a8,0,0.1)
	
	pass

func Move():
	var right_left = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var down_up = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	motion.x = lerp(motion.x,movespeed * right_left,0.75)
	motion.y = lerp(motion.y,movespeed * down_up,0.75)
	motion = motion.clamped(movespeed)
	pass

func Look():
	var cam = get_node(pixel_cam_path)
	var cam_pos = Vector2(0,0)
	var final_pos = Vector2(0,0)
	cam_pos.x = round(lerp(cam.position.x,position.x + ((get_global_mouse_position().x - position.x) / 10),0.15))
	cam_pos.y = round(lerp(cam.position.y,position.y + ((get_global_mouse_position().y - position.y) / 10),0.15))
	cam.global_position = cam_pos
	if cam.has_node("CanvasLayer/Control/Label"):
		cam.get_node("CanvasLayer/Control/Label").text = "Health: " + str(health)
	if cam.has_node("CanvasLayer/Control/Label2"):
		cam.get_node("CanvasLayer/Control/Label2").text = "Zombies: " + str(Global.zombies_killed)
	rotation = (get_global_mouse_position() - global_position).angle()
	pass

func Shoot():
	if Input.is_action_pressed("shoot") && $ShootTimer.is_stopped():
		$ShootTimer.start()
		$Shoot.play()
		var bullet = preload("res://Scenes/bullet.tscn").instance()
		bullet.global_position = $Position2D.global_position
		bullet.rotation = rotation
		get_parent().get_node("Bullets").add_child(bullet)
		gun_motion = Vector2(-movespeed,0).rotated(rotation)
	gun_motion = lerp(gun_motion,Vector2.ZERO,0.1)
	pass

func hit(value):
	var cam = get_node(pixel_cam_path)
	health -= value
	$Ouch.play()
	var x = rng.randi_range(-shake_strength,shake_strength)
	var y = rng.randi_range(-shake_strength,shake_strength)
	$ShakeTween.interpolate_method(cam,"set_offset",cam.offset,Vector2(x,y),0.1,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$ShakeTween.start()
	cam.get_node("CanvasLayer/Control/HurtColor").color.a8 = 127
	
	var Blood = preload("res://Scenes/Blood.tscn").instance()
	Blood.position = position
	Blood.emitting = true
	get_parent().add_child(Blood)
	
	pass

func _on_ShakeTween_tween_all_completed():
	var cam = get_node(pixel_cam_path)
	if cam.offset != Vector2.ZERO:
		$ShakeTween.interpolate_method(cam,"set_offset",cam.offset,Vector2(0,0),0.1)
		$ShakeTween.start()
	pass # Replace with function body.

func set_offset(value):
	var cam = get_node(pixel_cam_path)
	var x = round(value.x)
	var y = round(value.y)
	cam.offset = Vector2(x,y)
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Table"):
		near_table = true
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("Table"):
		near_table = false
	pass # Replace with function body.
