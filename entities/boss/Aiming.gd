extends "res://entities/boss/BossState.gd"
@export var aimer : Node2D
var direction_vector

func enter():
	#animator.play("aiming")
	aimer.visible = true
	
	set_aim_direction()
	boss.movement_dir = Vector2.ZERO
	pass
func process_input(event: InputEvent):
	super.process_input(event)
	
	if event is InputEventMouseMotion:
		var pos_to_mouse = boss.get_global_mouse_position() -  boss.global_position

		direction_vector =  pos_to_mouse.normalized()
		aimer.rotation = direction_vector.angle()
		pass
	elif event is InputEventMouseButton:
		if event.is_action_pressed("rhythm_hit"):
			boss.attack_direction = direction_vector
			print(direction_vector)
			boss.activate_combo()

	pass
	
func exit():
	aimer.visible = false
	pass

func set_aim_direction():
	var pos_to_mouse = boss.get_global_mouse_position() -  boss.global_position

	direction_vector =  pos_to_mouse.normalized()
	aimer.rotation = direction_vector.angle()
