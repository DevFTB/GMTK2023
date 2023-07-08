extends State

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var animator = boss.get_node("AnimatedSprite2D") as AnimatedSprite2D
