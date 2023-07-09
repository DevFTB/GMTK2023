extends CharacterBody2D
class_name Boss

signal started_combo(lc: ComboLifecycle)
signal boss_health_changed(new, max, difference)
signal boss_name_changed(name)

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

var selected_combo = -1
var attack_direction = Vector2.UP

func _ready():
	health = max_health
	names = generate_boss_names(50)
	boss_name = names[0]
	boss_name_changed.emit(boss_name)
	boss_health_changed.emit(health, max_health, 0)

func _process(delta):
	velocity = movement_dir * movement_speed
	move_and_slide()

func activate_combo() -> void:
	var combo = combos[selected_combo]
	
	var lifecycle = ComboLifecycle.new()

	lifecycle.combo = combo
	
	active_combo = lifecycle
	
	lifecycle.rotation = attack_direction.angle()
	add_child(lifecycle)
	
	started_combo.emit(lifecycle)
	$BossStateMachine.transition_to("Attacking")
	pass

func take_damage(damage: int):
	health -= damage
	boss_health_changed.emit(health, max_health, -damage)
	#print("Boss took %s damage. Now at %s HP" % [damage, health])
	
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
