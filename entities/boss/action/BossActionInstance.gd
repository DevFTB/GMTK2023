extends Node2D

@export var hit_duration = 0.4

@export var stun_duration = 0.0
@export var slow_duration = 0.0
@export var knockback = 0.0

var action : BossAction
var strength = 1

func _ready():
	for child in $Hitboxes.get_children():
		child.damaged.connect(_on_player_damaged)
		child.damage = ceil(strength * action.get_damage())
		
	$AnimationPlayer.animation_finished.connect(func(x): queue_free())
	$AnimationPlayer.play("hit")

	get_tree().create_timer(hit_duration).timeout.connect(disable_hitboxes)

func _on_player_damaged(player: Node2D):
	if stun_duration > 0.0:
		player.apply_stun(stun_duration)
	
	if slow_duration > 0.0:
		player.apply_slow(slow_duration)
	
	if knockback > 0.0:
		player.apply_knockback(knockback,  (player.position - global_position).normalized())
	# apply effects
	pass

func disable_hitboxes():
	for c in $Hitboxes.get_children():
		c.disable()

	pass # Replace with function body.
