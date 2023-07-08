extends Area2D

var damage
var speed
var range
var target

var dist_travelled

# Called when the node enters the scene tree for the first time.
func _ready():
	dist_travelled = 0
	print("arrow created")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = self.global_position + (speed * delta * Vector2.from_angle(self.rotation))
	dist_travelled += speed * delta
	if dist_travelled > range:
		queue_free()
		
	print(self.global_position)

#func init(p_damage=0, p_speed=1, p_range=1, p_target=null)
#	damage = p_damage
#	speed = p_speed
#	range = p_range
#	target = p_target

func init(p_damage, p_speed, p_range, p_target):
	damage = p_damage
	speed = p_speed
	range = p_range
	target = p_target
	
	self.rotation = self.global_position.angle_to_point(target.global_position)
	
