extends Area2D

@export var damage = 5

signal damaged(body: Node2D)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.take_damage(damage)
		damaged.emit(body)
	pass # Replace with function body.

func disable():
	monitoring = false
	
	var hv = get_node_or_null("HitboxVisual")
	if hv != null:
		hv.visible = false

	


	
