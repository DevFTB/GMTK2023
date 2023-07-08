extends Node

var phase
@export var heal_phase_min_interval = 40
@export var get_behind_me_phase_min_interval = 30
@export var heal_phase_length = 10
@export var get_behind_me_phase_length = 10

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
	# move
	if phase == "Heal":
		group_move(group_loc)
		
	elif phase =="Get behind me!":
		# todo: move towards, but not quite on boss
		# todo: continually swap places by changing player_loc_ordering so that tank is closest and fighter is second closest
		
		var avg_player_loc = players.map(func(p): return p.global_position).reduce(func(a, b): return a + b, Vector2(0, 0))/players.size()
#		print("avg player loc: " + str(avg_player_loc))
		group_move(get_loc_dist_from(avg_player_loc, boss.global_position, 32))
		
	else:
		for player in get_players():
			move_player_handler(player)
	
	# action
	for player in get_players():
		for action in get_actions(player):
			match action.name:
				"MeleeAttack", "RangedAttack":
					if action.off_cooldown() and action.in_range(boss):
						action.do(boss)
				"Heal":
					pass
		

func get_players():
	return self.get_children()
	
func set_phase(inp_phase):
	match inp_phase:
		"Normal":
			pass
		"Heal":
			heal_phase_allowed_timer = heal_phase_min_interval
			phase_timer = heal_phase_length
			player_loc_ordering = get_players()
			group_loc = Vector2(rng.randf_range(100, 600), rng.randf_range(100, 600))
		"Get behind me!":
			get_behind_me_phase_allowed_timer = get_behind_me_phase_min_interval
			phase_timer = get_behind_me_phase_length
			player_loc_ordering = get_players()
	
	phase = inp_phase
	print("New phase: " + phase)
	
func manage_phase():
	if phase_timer == 0 and phase != "Normal":
		set_phase("Normal")
	
	var player_classes = get_player_classes().values()
	if phase == "Normal":
		if player_classes.has("Healer") and heal_phase_allowed_timer == 0:
			set_phase("Heal")
		elif player_classes.has("Tank") and get_behind_me_phase_allowed_timer == 0:
			set_phase("Get behind me!")
		
		

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
#	# todo check that node is truthy lol
#	return true if player.get_node("Action").get_node_or_null(action) else false
	
# move to clump as a group - target loc to move to, and theyll move to a circle around
# it in playerorder
func group_move(target_loc):
	var player_target_locs = []
	var player_num_ordering = player_loc_ordering.size()
	for i in range(player_num_ordering):
		player_target_locs.append(target_loc + 16 * Vector2.from_angle(i * 2 * PI / player_num_ordering))
	
	for i in range(player_loc_ordering.size()):
		var player = player_loc_ordering[i]
		# if players die, ordering will remain the same from last set, but with missing person in circle
		if player:
			move_player(player, player_target_locs[i])
			
# gets location dist distance from to, on the line from from to to
# may have to change it to use boss eclipse lter
func get_loc_dist_from(from: Vector2, to: Vector2, dist):
	return to + ((from - to).normalized() * dist)

# each player moves individually - normal mode
# todo: reduce clumping
func move_player_handler(player):
#	player.global_position += Vector2(rng.randf_range(-player.speed, player.speed), rng.randf_range(-player.speed, player.speed))
	match get_player_class(player):
		"Tank", "Fighter":
			move_player(player, get_loc_dist_from(player.global_position, boss.global_position, 32))
		"Archer":
			move_player(player, get_loc_dist_from(player.global_position, boss.global_position, 256))
		"Healer":
			move_player(player, get_loc_dist_from(player.global_position, get_most_damaged_player().global_position, 16))
		
	
func move_player(player, loc):
	if (loc - player.global_position).length() <= player.speed:
		player.global_position = loc
	else:
		player.global_position += player.speed *  (loc -  player.global_position).normalized()
	
func get_most_damaged_player():
	return get_players().reduce(func(min, player): return player if player.health < min.health else min)
