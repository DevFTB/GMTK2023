extends CharacterBody2D

@export var max_health: int = 10
@export var speed: int = 60
@export var player_class = ""
var health: int

var slowed = false
var stunned = false
var dead = false
var slow_factor = 0.5

@export var wall_hit_damage = 6



var death_messages = ["AHHHHH", "It's over", "Nooooo", "It's just a flesh wound", "ow"]
var flying_messages = ["WHOA!!!!", "I can see the world!", "It's not the fall that kills you."]
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

func take_damage(damage: int, immediate_source = false):
	print("taking %s" % damage)
	health -= damage
	$PlayerGUI.health_changed(health, -damage)
	$PlayerSound.play_sound("hurt")
	if health <= 0:
		die(immediate_source)
		
	$Sprite2D.material.set_shader_parameter("should_flash", true)
	get_tree().create_timer(0.4).timeout.connect(func(): $Sprite2D.material.set_shader_parameter("should_flash", false))
	
func heal(heal: int):
	health = min(max_health, heal + health)
#	health = heal + health
	$PlayerGUI.health_changed(health, heal)
	#(name + " healed for  " + str(heal))

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

# knockback sends them flying
var _flying = false
var _gravity = -32
var _velocity_override = Vector2.ZERO
var _scale_override = 1
var _time_per_pixel = 0.003
var _knockback_scale_factor = 0.1 / (3 * 32)
var _deceleration_factor = 0.5
func apply_knockback(knock_back, direction: Vector2):
	_flying = true
	_velocity_override = direction.normalized() / _time_per_pixel
	
	var time = knock_back * _time_per_pixel
	
	# remove player mask
	collision_mask = collision_mask & ~(1 << 3) & ~(1 << 1)
	
	var scale_factor = 1.5 + _knockback_scale_factor * knock_back
	
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", $Sprite2D.scale * scale_factor, time / 3).from_current()
	tween.tween_property($Sprite2D, "scale", $Sprite2D.scale, 2*time / 3).set_delay( time/3)
	tween.tween_callback(func():
		_flying = false;
		collision_mask = collision_mask | (1 << 3) | (1 << 1)
		)
	
	_wall_hit = false
	
	if knock_back > 96:
		speak(flying_messages[randi() % flying_messages.size()])
		$PlayerSound.play_sound("launch")
	elif randi() % 4 == 0:
		speak("WHOA!")
		

	pass
var _wall_hit =false
func move(loc, delta):
	if not stunned and not _flying and not dead:
		var loc_diff = loc - global_position
		var vel_vec = loc_diff if loc_diff.length() < 1 else loc_diff.normalized()
		if slowed:
			vel_vec *= slow_factor
		velocity = speed * vel_vec
		
		# set way player is facing based on velocity
		$Sprite2D.set_flip_h(not (velocity.angle() <= PI/2 and velocity.angle() >= -PI/2))
		
		move_and_slide()
	else:
		if _flying:
			var collision = move_and_collide(_velocity_override * delta)
			if collision:
				print(collision.get_collider())
				if collision.get_collider().is_in_group("environment") and not _wall_hit:
					_wall_hit = true
					take_damage(wall_hit_damage, true)
			_velocity_override -= _velocity_override * _deceleration_factor *delta
	
func speak(text, time=2):
	$PlayerGUI.display_speech(text, time)
	$PlayerSound.play_sound("speech")

func do_action(action: Node2D, target):
	if not stunned and not dead:
		action.do(target)
	
#	if (loc - global_position).length() <= speed * delta:
#		global_position = loc
#	else:
#		global_position += speed * delta * (loc -  global_position).normalized()
	
func die(immediate = false):
	dead = true
	speak(death_messages.pick_random(), 1)
	
	if not immediate:
		await get_tree().create_timer(1.0).timeout
	$PlayerGUI.visible = false
	$StatusEffect.visible = false
	$Sprite2D.visible = false
	
	
	$CollisionShape2D.set_deferred("disabled", true)
	$DeadSprite.visible = true

func _on_stun_timer_timeout():
	stunned = false
	update_status_sprite()


func _on_slow_timer_timeout():
	slowed = false
	update_status_sprite()
