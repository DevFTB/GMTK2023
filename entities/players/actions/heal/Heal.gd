extends Action
@export var heal = 5
@export var heal_animation_scene: PackedScene

func do(target):
	timer = cooldown
	var heal_animation = heal_animation_scene.instantiate()
	target.add_child(heal_animation)
	heal_animation.position = Vector2(0, 0)
	target.heal(heal)
