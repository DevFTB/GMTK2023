extends CharacterBody2D
class_name Boss

signal started_combo(lc: ComboLifecycle)

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



func _ready():
	health = max_health
	names = generate_boss_names(60)

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
	$BossStateMachine.transition_to("Attacking")
	pass

func take_damage(damage: int):
	health -= damage
	print("Boss took %s damage. Now at %s HP" % [damage, health])
	
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
