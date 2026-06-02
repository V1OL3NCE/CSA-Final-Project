extends Camera2D

@export var zoom_speed: float = 0.3
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0

var target_zoom: Vector2 = Vector2.ONE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Increase vector values to zoom IN
			target_zoom += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Decrease vector values to zoom OUT
			target_zoom -= Vector2(zoom_speed, zoom_speed)
		
		# Prevent zooming out too far or in too deep
		target_zoom = target_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func _process(delta: float) -> void:
	# Smoothly slide current zoom towards the target zoom
	zoom = zoom.lerp(target_zoom, 10 * delta)
