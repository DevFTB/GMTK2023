extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBarHolder.get_node("HealthBar").value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func health_changed(new_health, difference):
	var max_health = get_parent().max_health
	$HealthBarHolder.get_node("HealthBar").value = round((float(new_health)/max_health) * 100)
	# grr this is kinda bad but eh
	if difference > 0:
		$DamageNumber.text = ""
		$HealNumber.text = str(abs(difference))
	else:
		$DamageNumber.text = str(abs(difference))
		$HealNumber.text = ""
	var damage_number_timer = $DamageNumberTimer
	damage_number_timer.start(1)
	
func display_speech(text, time=2):
	$SpeechBubble.visible = true
	var speech_timer = $SpeechBubble.get_node("Timer")
	$SpeechBubble.get_node("Speech").text = text
	speech_timer.start(time)


func _on_timer_timeout():
	$SpeechBubble.visible = false


func _on_damage_number_timer_timeout():
	$DamageNumber.text = ""
	$HealNumber.text = ""
