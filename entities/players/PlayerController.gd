extends Node

signal all_players_dead()

var phase
@export var heal_phase_min_interval = 40
@export var get_behind_me_phase_min_interval = 30
@export var heal_phase_length = 10
@export var get_behind_me_phase_length = 10
@export var player_num_level_multipler = 1
#@export var levels_per_statup = 1

@export var class_scenes: Dictionary
@export var class_stats: Dictionary

var normal_phase_speeches = [
	"Back to your positions",
	"Split!",
	"Run!!",
	"Retreat!",
	"Grouping down"
]
var phase_speeches = {
	"Normal": {
		"Fighter": normal_phase_speeches,
		"Healer": normal_phase_speeches,
		"Tank": normal_phase_speeches,
		"Archer": normal_phase_speeches
	},
	"Heal": {
		"Healer": [
			"Group up for healing!",
			"Healy time!",
			"Take your medicine!",
			"Somebody call for the doctor?"
		]
	},
	"Get behind me!": {
		"Tank": [
			"Get behind me!",
			"Strength in numbers!",
			"Group up!",
			"REEEEEEEE!",
			"Form up!"
		]
	}
}

var heal_phase_allowed_timer
var get_behind_me_phase_allowed_timer
var phase_timer
var group_loc
var player_loc_ordering

var boss

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_phase("Normal")
	player_loc_ordering = get_players()
	phase_timer = 0
	heal_phase_allowed_timer = heal_phase_min_interval
	get_behind_me_phase_allowed_timer = get_behind_me_phase_min_interval
	boss = get_node("../Boss")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	manage_phase()
	phase_timer = max(0, phase_timer - delta)
	heal_phase_allowed_timer = max(0, heal_phase_allowed_timer - delta)
	get_behind_me_phase_allowed_timer = max(0, get_behind_me_phase_allowed_timer - delta)
	
	var players = get_players()
	
	# if all players dead
	if players.size() == 0:
		all_players_dead.emit()
	
	# move
	if phase == "Heal":
		group_move(group_loc, delta)
		
	elif phase =="Get behind me!":
		var avg_player_loc = players.map(func(p): return p.global_position).reduce(func(a, b): return a + b, Vector2(0, 0))/players.size()
		
		# TODO: continually swap places by changing player_loc_ordering so that tank is closest and fighter is second closest
		
		group_move(get_loc_dist_from(avg_player_loc, boss.global_position, 100), delta)
		
	else:
		for player in players:
			move_player_handler(player, delta)
	
	# action
	for player in players:
			for action in get_actions(player):
				match action.name:
					"Heal":
						if action.off_cooldown():
							var players_in_range = players.filter(func(p): return action.in_range(p))
							if players_in_range.size() > 0:
								# slightly hacky way to get healer to do mass heal during the group heal time
								# will start group healing once they have reached their target location (check is also hacky)
								if phase == "Heal" and (player.global_position - group_loc).length() < 48:
									for p_heal in players_in_range:
										player.do_action(action, p_heal)
								else:
									player.do_action(action, players_in_range.reduce(func(min, p): return p if player.health < min.health else min))
					"MeleeAttack", "RangedAttack":
						if action.off_cooldown() and action.in_range(boss):
							player.do_action(action, boss)
		

func get_players():
	return self.get_children().filter(func(p): return not p.dead)
	
func set_phase(inp_phase):
	match inp_phase:
		"Normal":
			pass
		"Heal":
			heal_phase_allowed_timer = heal_phase_min_interval
			phase_timer = heal_phase_length
			player_loc_ordering = get_players()
			# TODO: set heal location better lol
			group_loc = get_random_spot_on_world()
		"Get behind me!":
			get_behind_me_phase_allowed_timer = get_behind_me_phase_min_interval
			phase_timer = get_behind_me_phase_length
			player_loc_ordering = get_players()
	
	phase = inp_phase
	#print("New phase: " + phase)

func do_phase_speech(phase):
	var players = get_players()
	var valid_speakers = players.filter(func(p): return phase_speeches[phase].has(get_player_class(p)))
	if valid_speakers.size() > 0:
		var speaker = valid_speakers.pick_random()
		speaker.speak(phase_speeches[phase][get_player_class(speaker)].pick_random())
	
func manage_phase():
	var swapped_normal = false
	if phase_timer == 0 and phase != "Normal":
		swapped_normal = true
		set_phase("Normal")
	
	var player_classes = get_player_classes().values()
	var players = get_players()
	if phase == "Normal":
		var team_health_prop = float(players.map(func(p): return p.health).reduce(func(a, b): return a + b, 0))/players.map(func(p): return p.max_health).reduce(func(a, b): return a + b, 0)
		if player_classes.has("Healer") and heal_phase_allowed_timer == 0 and team_health_prop <= 0.4:
			set_phase("Heal")
			do_phase_speech("Heal")
		elif player_classes.has("Tank") and get_behind_me_phase_allowed_timer == 0:
			set_phase("Get behind me!")
			do_phase_speech("Get behind me!")
	
	# need this statement as otherwise two dialogues will pop up at the same time
	# when switching back to normal then instantly to another phase
	if swapped_normal and phase == "Normal":
		do_phase_speech("Normal")
		
		

# tank and fighter have same actions for now so cant determine based on that atm
# will leave it as a function incase we want to do it that way later
func get_player_class(player):
#	match get_actions(player):
#		[""]
	return player.player_class
	
func get_player_classes():
	var classes = {}
	for player in get_players():
		classes[player] = get_player_class(player)
	return classes
	
func get_actions(player):
	if player.get_node_or_null("Actions") == null:
		return []
	return player.get_node("Actions").get_children()
	
#func has_action(player, action):
#	return true if player.get_node("Action").get_node_or_null(action) else false
	
# move to clump as a group - target loc to move to, and theyll move to a circle around
# it in playerorder
func group_move(target_loc, delta):
	var player_target_locs = []
	var player_num_ordering = player_loc_ordering.size()
	for i in range(player_num_ordering):
		player_target_locs.append(target_loc + 16 * Vector2.from_angle(i * 2 * PI / player_num_ordering))
	
	for i in range(player_loc_ordering.size()):
		var player = player_loc_ordering[i]
		# if players die, ordering will remain the same from last set, but with missing person in circle
		if player:
			player.move(player_target_locs[i], delta)
			
# gets location dist distance from to, on the line from from to to
# may have to change it to use boss eclipse lter
func get_loc_dist_from(from: Vector2, to: Vector2, dist):
	return to + ((from - to).normalized() * dist)

# each player moves individually - normal mode
func move_player_handler(player, delta):
#	player.global_position += Vector2(rng.randf_range(-player.speed, player.speed), rng.randf_range(-player.speed, player.speed))
	match get_player_class(player):
		"Tank", "Fighter":
			player.move(get_loc_dist_from(player.global_position, boss.global_position, 80), delta)
		"Archer":
			player.move(get_loc_dist_from(player.global_position, boss.global_position, 220), delta)
		# todo try move healer not boss side of to heal player
		"Healer":
			player.move(get_loc_dist_from(player.global_position, get_most_damaged_player().global_position, 64), delta)
		
		
# todo: can pick themself - is this an issue?
func get_most_damaged_player():
	return get_players().reduce(func(min, player): return player if player.health < min.health else min)
	
## ok this is like fully repeated and not great but i cbf
## this is the most scuffed function ever
#func set_get_behind_me_player_loc_ordering(target_loc):
#	var players = get_players()
#	var player_classes = get_player_classes().values()
#	var player_target_locs = []
#	var player_num_ordering = player_loc_ordering.size()
#	var closest_indices_to_boss = []
#	for i in range(player_num_ordering):
#		closest_indices_to_boss.append(i)
#		player_target_locs.append(target_loc + 16 * Vector2.from_angle(i * 2 * PI / player_num_ordering))
#
#	closest_indices_to_boss.sort_custom(func(a, b): return dist_to_boss(player_target_locs[a]) < dist_to_boss(player_target_locs[b]))
#
#	var class_closeness_priority_idx = []
#	if player_classes.has("Tank"):
#		class_closeness_priority.append(players.find())
#	return
#
#func dist_to_boss(loc):
#	return (loc - boss.global_position()).length()

func clear_players():
	for player in self.get_children():
		player.queue_free()


func spawn_players(level):
	var classes = class_scenes.keys()
	var num_players = classes.size() + player_num_level_multipler * level
	var randomly_allocated_players = num_players - classes.size()
	var class_spawns = {}
	for c in classes:
		class_spawns[c] = 1
		
	for i in range(randomly_allocated_players):
		class_spawns[classes.pick_random()] += 1
	
	var spawn_point = get_random_spot_on_world()
	
	var spawn_num = 1
	for c in classes:
		for i in range(class_spawns[c]):
			var player = create_player(c, level)
			player.global_position = get_spawn_loc(spawn_point, spawn_num)
			spawn_num += 1

# this is totally not way too convoluted to spawn them all in a circle
func get_spawn_loc(group_spawn_loc, n):
	var total = 0
	var num = 4
	var spawn_level = 1
	while n <= total:
		total += num
		num *= 2
		spawn_level += 1
	
	return group_spawn_loc + 20 * spawn_level * Vector2.from_angle((n - total) * 2 * PI / num)

func create_player(player_class, level):
	var player_scene = class_scenes[player_class]
	var new_player = player_scene.instantiate()
	set_player_attrs(new_player, level)
	add_child(new_player)
	
	return new_player
	

func set_player_attrs(player, level):
	# for level 0 we want stats to be base
	var player_class = player.player_class
	var stats = class_stats[player_class]
	
	player.max_health = int(stats.base_health + level * stats.health_scaling)
	player.speed = int(stats.base_speed + level * stats.speed_scaling)
	var action
	match player_class:
		"Fighter", "Tank":
			action = player.get_node("Actions/MeleeAttack")
			action.damage = int(stats.base_ability_power + level * stats.ability_power_scaling)
			action.cooldown = stats.base_ability_cooldown
		"Archer":
			action = player.get_node("Actions/RangedAttack")
			action.damage = int(stats.base_ability_power + level * stats.ability_power_scaling)
			action.cooldown = stats.base_ability_cooldown
		"Healer":
			action = player.get_node("Actions/Heal")
			action.heal = int(stats.base_ability_power + level * stats.ability_power_scaling)
			action.cooldown = stats.base_ability_cooldown
	
	
func get_random_spot_on_world():
	return Vector2(rng.randf_range(100, 600), rng.randf_range(100, 600))
	

func reset(n):
	clear_players()
	spawn_players(n)
	
	set_phase("Normal")
	player_loc_ordering = get_players()
	phase_timer = 0
	heal_phase_allowed_timer = heal_phase_min_interval
	get_behind_me_phase_allowed_timer = get_behind_me_phase_min_interval
	

# kill random player on click for debugging
#func _input(event: InputEvent):
#	if event.is_action_pressed("rhythm_hit") and len(get_players()) > 0:
#		get_players().pick_random().take_damage(1000)
