extends Area2D

@export var damage = 5

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.take_damage(damage)
	pass # Replace with function body.
