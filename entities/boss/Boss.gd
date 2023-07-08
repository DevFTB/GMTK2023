extends CharacterBody2D

@export var movement_speed = 200
var movement_dir = Vector2.ZERO

var combos : Array[Combo] = []
var active_combo : Node2D

func _process(delta):
	velocity = movement_dir * movement_speed
	move_and_slide()

func _input(event):
	if event is InputEventKey:
		var axis = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		movement_dir = axis
		
		if event.is_action_pressed("activate_combo_1"):
			activate_combo(0)
		if event.is_action_pressed("activate_combo_2"):
			activate_combo(1)

func activate_combo(index: int) -> void:
	pass
