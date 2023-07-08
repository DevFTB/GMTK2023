# todo make player scene inherit from player scene.
extends CharacterBody2D

@export var max_health: int = 10
@export var speed: int = 60
@export var player_class = ""
var health: int

var slowed = false
var stunned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage: int):
	health -= damage
	$PlayerGUI.health_changed(health, -damage)
	if health <= 0:
		die()
	
func heal(heal: int):
	health = min(max_health, heal + health)
#	health = heal + health
	$PlayerGUI.health_changed(health, heal)
	print(name + " healed for  " + str(heal))

func move(loc, delta):
	var loc_diff = loc - global_position
	var vel_vec = loc_diff if loc_diff.length() < 1 else loc_diff.normalized()
	velocity = speed * vel_vec
	move_and_slide()
	
#	if (loc - global_position).length() <= speed * delta:
#		global_position = loc
#	else:
#		global_position += speed * delta * (loc -  global_position).normalized()
	
func die():
	pass
