extends Node2D

@onready var tilemap_rect : Rect2 = Rect2($TileMap.get_used_rect())



func _on_timer_timeout():
	for player in get_tree().get_nodes_in_group("players"):
		if not tilemap_rect.has_point(player.global_position):
			player.die()
	pass # Replace with function body.
