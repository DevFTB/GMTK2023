extends BossAction

@export var teleport_distance = 32 * 5

func do_effect(boss: Boss, direction: Vector2):
	boss.teleport(direction * teleport_distance)
	pass
