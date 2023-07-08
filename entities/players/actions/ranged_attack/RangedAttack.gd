extends Action
@export var damage = 1
@export var arrow_speed = 120
@export var arrow_scene: PackedScene

func do(target):
	timer = cooldown
	var arrow = arrow_scene.instantiate()
	add_child(arrow)
	arrow.global_position = self.global_position
	arrow.init(damage, arrow_speed, action_range, target)

	# todo should i add it as child of world instead? Arrow will disappear if archer dies.
	
	
