extends Node

@export var max_health: int
@export var speed: int
@export var player_class = ""
var health: int

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
	
	
func die():
	pass
