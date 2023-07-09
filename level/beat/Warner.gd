extends Control

@export var hold_texture: Texture2D
@export var press_texture: Texture2D


var beat = 0

var velocity = Vector2.RIGHT

func start_tween(destination_x: float, time_to_move: float):
	print(time_to_move)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2(destination_x, 0), time_to_move).from_current()
	tween.tween_property(self, "scale", Vector2.ONE * 1, time_to_move).from(Vector2.ONE * 0.5)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

func set_input(beat:int, is_press, is_hold):
	print("warner set, b", beat, is_press, is_hold)
	self.beat = beat
	$TypeLabel.text = ("Press"  if not is_hold else "Hold") if is_press else "Release"
	$TextureRect.texture = hold_texture if is_hold else press_texture
	
func update_gui_for_beat(current_beat: int):
	$BeatLabel.text = str(beat - current_beat)
	#if current_beat == beat:
	#	queue_free()

func _process(delta):
	pass
	#position += velocity * delta
