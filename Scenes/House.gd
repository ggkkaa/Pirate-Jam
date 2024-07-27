extends Node2D

@onready var table = $StaticBody2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	table.shape.size.x = get_viewport_rect().size.x
