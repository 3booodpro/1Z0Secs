extends CanvasLayer

func ChangeScene(path):
	layer = 100
	$Control/AnimationPlayer.play("Fade_in")
	yield($Control/AnimationPlayer,"animation_finished")
	get_tree().change_scene(path)
	$Control/AnimationPlayer.play("Fade_out")
	yield($Control/AnimationPlayer,"animation_finished")
	layer = -100
	pass

func ReloadScene():
	layer = 100
	$Control/AnimationPlayer.play("Fade_in")
	yield($Control/AnimationPlayer,"animation_finished")
	get_tree().reload_current_scene()
	$Control/AnimationPlayer.play("Fade_out")
	yield($Control/AnimationPlayer,"animation_finished")
	layer = -100
	pass
