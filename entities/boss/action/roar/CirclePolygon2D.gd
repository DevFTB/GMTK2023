extends Polygon2D

@export var number_of_sides: int = 30
@export var radius: float = 1.0

func _ready():
	polygon = generate_circle_polygon(radius, number_of_sides, Vector2.ZERO)

func generate_circle_polygon(radius: float, num_sides: int, position: Vector2) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon: PackedVector2Array

	for _i in num_sides:
		polygon.append(vector + position)
		vector = vector.rotated(angle_delta)

	return polygon
