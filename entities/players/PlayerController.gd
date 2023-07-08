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

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_phase("Normal")
	player_loc_ordering = get_players()
	phase_timer = 0
	heal_phase_allowed_timer = heal_phase_min_interval
	get_behind_me_phase_allowed_timer = get_behind_me_phase_min_interval



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	manage_phase()
	phase_timer = max(0, phase_timer - delta)
	heal_phase_allowed_timer = max(0, heal_phase_allowed_timer - delta)
	get_behind_me_phase_allowed_timer = max(0, get_behind_me_phase_allowed_timer - delta)
	
	# move
	if phase == "Heal":
		group_move(group_loc)
		
	elif phase =="Get behind me!":
		# todo: move towards, but not quite on boss
		group_move(Vector2(400, 400))
		
	else:
		for player in get_players():
			move_player(player)
	
	# action
#	for player in get_players():
#		for action in get_actions(player):
#			action.do()
		

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
			group_loc = Vector2(rng.randf_range(-500, 500), rng.randf_range(-500, 500))
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
	return player.get_node("Action").get_children()
	
func has_action(player, action):
	# todo check that node is truthy lol
	return true if player.get_node("Action").get_node_or_null(action) else false
	
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
			if (player_target_locs[i] -  player.position).length() <= player.speed:
				player.position = player_target_locs[i]
			else:
				player.position += player.speed *  (player_target_locs[i] -  player.position).normalized()

# each player moves individually - normal mode
func move_player(player):
	player.position += Vector2(rng.randf_range(-player.speed, player.speed), rng.randf_range(-player.speed, player.speed))
