extends Node2D

func _process(delta):
	if global.found_entity_item == true:
		$chest.visible = false

		