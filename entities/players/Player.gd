# todo make player scene inherit from player scene.
extends CharacterBody2D

@export var max_health: int = 10
@export var speed: int = 60
@export var player_class = ""
var health: int

var slowed = false
var stunned = false
var slow_factor = 0.5

var status_sprite_mappings = {
	"stunned": 0,
	"slowed": 1
}

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

func update_status_sprite():
	$StatusEffect.visible = true
	if stunned:
		$StatusEffect.frame = status_sprite_mappings["stunned"]
	elif slowed:
		$StatusEffect.frame = status_sprite_mappings["slowed"]
	else:
		$StatusEffect.visible = false

func apply_stun(time=1):
	stunned = true
	var stun_timer = $StatusEffect.get_node("StunTimer")
	if stun_timer.time_left < time:
		stun_timer.start(time)
	update_status_sprite()
	
func apply_slow(time=1):
	slowed = true
	var slow_timer = $StatusEffect.get_node("SlowTimer")
	if slow_timer.time_left < time:
		slow_timer.start(time)
	update_status_sprite()

func move(loc, delta):
	if not stunned:
		var loc_diff = loc - global_position
		var vel_vec = loc_diff if loc_diff.length() < 1 else loc_diff.normalized()
		if slowed:
			vel_vec *= slow_factor
		velocity = speed * vel_vec
		# TODO: sometimes you can drag players around as the boss, maybe should fix lol
		move_and_slide()

func do_action(action: Node2D, target):
	if not stunned:
		action.do(target)
	
#	if (loc - global_position).length() <= speed * delta:
#		global_position = loc
#	else:
#		global_position += speed * delta * (loc -  global_position).normalized()
	
func die():
	pass


func _on_stun_timer_timeout():
	stunned = false
	update_status_sprite()


func _on_slow_timer_timeout():
	slowed = false
	update_status_sprite()
