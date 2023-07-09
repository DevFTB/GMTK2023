extends State

@onready var boss : Boss = get_tree().get_first_node_in_group("boss")
@onready var animator = boss.get_node("AnimatedSprite2D") as AnimatedSprite2D

@export var movement_modifier : float = 1.0

func process_input(event: InputEvent):
	if event is InputEventKey:
		var axis = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		boss.movement_dir = axis
		
		if event.is_action_pressed("activate_combo_1"):
			#boss.activate_combo(0)
			if boss.can_activate_combo(0):
				state_machine.transition_to("Aiming")
				boss.selected_combo = 0

			
		if event.is_action_pressed("activate_combo_2"):
			#boss.activate_combo(1)
			if boss.can_activate_combo(1):
				state_machine.transition_to("Aiming")
				boss.selected_combo = 1
