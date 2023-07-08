extends CharacterBody2D
class_name Boss

signal started_combo(lc: ComboLifecycle)

@export var movement_speed = 200
@export var combos : Array[Combo] = []

var movement_dir = Vector2.ZERO
var active_combo : Node2D

func _process(delta):
	velocity = movement_dir * movement_speed
	move_and_slide()

func activate_combo(index: int) -> void:
	var combo = combos[index]
	
	var lifecycle = ComboLifecycle.new()
	lifecycle.combo = combo
	
	active_combo = lifecycle
	
	add_child(lifecycle)
	
	started_combo.emit(lifecycle)
	pass
