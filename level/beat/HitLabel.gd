extends Label

@export var visible_duration = 1
@export var fade_out_duration = 0.8

@export var success_colours : Array[Color]
@export var success_text : Array[String]

var active_tween : Tween = null

func display_hit_text(strength: float):
	var index = floor(strength *  float(success_colours.size()))
	
	if index == success_colours.size(): index -= 1
		
	if active_tween:
		active_tween.kill()
		
	self_modulate = success_colours[index]
	text = success_text[index]
	
	pivot_offset = size / 2
	
	active_tween = get_tree().create_tween()
	active_tween.tween_interval(visible_duration)
	
	active_tween.set_parallel(true)
	active_tween.tween_property(self, "self_modulate", Color(Color.WHITE, 0.0), fade_out_duration)
	active_tween.tween_property(self, "scale", Vector2.ONE, fade_out_duration).from(Vector2(1.4, 1.4))
	active_tween.tween_property(self, "rotation", PI / 5, fade_out_duration * 2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN).from(-PI / 5)
	pass
