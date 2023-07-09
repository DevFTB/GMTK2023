extends BossAction
@export var base_tiles = 3
@export var tiles_per_level = 2
@export var knockback_scaling = 0.6

func do_effect(boss: Boss, direction: Vector2):
	var dash_distance = (base_tiles + (tiles_per_level * (level - 1))) * 32
	boss.teleport(direction * dash_distance, dash_distance* knockback_scaling, level)
	pass
