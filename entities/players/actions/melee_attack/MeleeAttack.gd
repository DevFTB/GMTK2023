extends Action
@export var damage = 1

func do(target):
	super.do(target)
	$ActionAnimation.rotation = self.global_position.angle_to_point(target.global_position) + PI
	target.take_damage(damage)
