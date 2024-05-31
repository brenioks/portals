extends Node

@onready var PortalA = %PortalA
@onready var PortalB = %PortalB

func _ready():
	# Auto connect texture and viewport
	var PortalAViewport = PortalA.get_node("SubViewport").get_path()
	var PortalBViewport = PortalB.get_node("SubViewport").get_path()
	
	PortalA.get_node("Mesh").get_active_material(0).albedo_texture.viewport_path = PortalAViewport
	PortalB.get_node("Mesh").get_active_material(0).albedo_texture.viewport_path = PortalBViewport
