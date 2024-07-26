extends Control

@export var scroll_speed: float = 100.0  # Adjust the scroll speed as needed

func _process(delta):
	_scroll_background(delta)

func _scroll_background(delta):
	var viewport_height = get_viewport_rect().size.y

	# Move backgrounds downwards
	$VBoxContainer.get_child(0).position.y += scroll_speed * delta
	$VBoxContainer.get_child(1).position.y += scroll_speed * delta
	
	# Check if background has moved below the viewport
	if $VBoxContainer.get_child(0).position.y - 300 > viewport_height:
		$VBoxContainer.get_child(0).position.y = $VBoxContainer.get_child(1).position.y - ($VBoxContainer.get_child(1).scale.y * 256)

	# Check if background2 has moved below the viewport
	if $VBoxContainer.get_child(1).position.y - 300 > viewport_height:
		$VBoxContainer.get_child(1).position.y = $VBoxContainer.get_child(0).position.y - ($VBoxContainer.get_child(0).scale.y * 256)
