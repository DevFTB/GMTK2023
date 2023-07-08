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