extends CharacterBody2D
class_name Boss

signal started_combo(lc: ComboLifecycle)
signal boss_health_changed(new, max, difference)
signal boss_name_changed(name)
signal boss_died()

@export var movement_speed = 200
@export var combos : Array[Combo] = []
@export var max_health = 20

@export var prefix_path = "res://entities/boss/boss_name/prefixes.txt"
@export var suffix_path = "res://entities/boss/boss_name/suffixes.txt"

@export var boss_stats: BossStats

var health
var movement_dir = Vector2.ZERO
var active_combo : Node2D
var names
var boss_name
var i_name = 0

var selected_combo = -1
var attack_direction = Vector2.UP

var can_combo = [true, true]
@onready var combo_timers = [$Combo1Timer, $Combo2Timer]

func _ready():
	health = max_health
	names = generate_boss_names(50)
	boss_name = names[i_name]
	boss_name_changed.emit(boss_name)
	boss_health_changed.emit(health, max_health, 0)

func _process(delta):
	velocity = movement_dir * movement_speed
	move_and_slide()

func activate_combo() -> void:
	if can_combo[selected_combo]:
		var combo = combos[selected_combo]
		
		var lifecycle = ComboLifecycle.new()

		lifecycle.combo = combo
		
		active_combo = lifecycle
		
		lifecycle.rotation = attack_direction.angle()
		add_child(lifecycle)
		
		started_combo.emit(lifecycle)
		$BossStateMachine.transition_to("Attacking")
		combo_timers[selected_combo].start()
		can_combo[selected_combo] = false
		pass

func take_damage(damage: int):
	health -= damage
	boss_health_changed.emit(health, max_health, -damage)
	if health <= 0:
		die()
	print("Boss took %s damage. Now at %s HP" % [damage, health])
	
func die():
	boss_died.emit()
	
func generate_boss_names(n=50):
	var prefixes = read_file(prefix_path).split("\n")
	var suffixes = read_file(suffix_path).split("\n")
	
	# for some reason godot forces a newline at the end of the text file...
	prefixes = prefixes.slice(0, -1)
	suffixes = suffixes.slice(0, -1)
	
	var modifiers = {}
	for p in prefixes:
		modifiers[p] = "Prefix"
	for s in suffixes:
		modifiers[s] = "Suffix"

	var names = []
	var name = "Boss"
	
	for i in range(n):
		names.append(name)
		var new = modifiers.keys().pick_random()
		if modifiers[new] == "Prefix":
			name = new + " "  + name
		elif modifiers[new] == "Suffix":
			name = name + " " + new
		modifiers.erase(new)
	
	return names
# todo make sure this exports correctly!! otherwise just hardcode it in
func read_file(path):
	return FileAccess.open(path, FileAccess.READ).get_as_text()
	

func teleport(movement_vector: Vector2, duration = 0.3):
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position + movement_vector, duration)
	var collision = move_and_collide(movement_vector)
	if collision:
		var collider = collision.get_collider()
		var space_state = get_world_2d().direct_space_state
		
		var query = PhysicsShapeQueryParameters2D.new()
		query.collide_with_bodies = true
		query.collision_mask = 0x1000b
		
		var circle =  CircleShape2D.new()
		circle.radius = 192
		query.shape =circle
		query.transform.origin = collision.get_position()
		
		var hits = space_state.intersect_shape(query)
		
		for hit in hits:
			
			var hit_collider = hit.collider
			
			if hit_collider.is_in_group("player"):
				print(hit_collider)
				collider.apply_knockback(20*32, collision.get_travel().normalized())
	
#	if collider != null and collider.is_in_group("player"):
#		collider.apply_knockback(20*32, collision.get_travel().normalized())

func get_combo_cooldown(index: int):
	return combo_timers[index].time_left / combo_timers[index].wait_time


func _on_combo_1_timer_timeout():
	can_combo[0] = true
	pass # Replace with function body.


func _on_combo_2_timer_timeout():
	can_combo[1] = true
	pass # Replace with function body.
func reset():
	health = max_health
	boss_health_changed.emit(health, max_health, 0)

func evolve_name():
	if i_name < names.size() - 1:
		i_name += 1
		boss_name = names[i_name]
		boss_name_changed.emit(boss_name)
		return true
	return false
