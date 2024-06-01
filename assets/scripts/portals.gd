@tool
extends Node

@onready var PortalA = %PortalA
@onready var PortalB = %PortalB
@onready var Player = %Player

func _ready():
	# Auto connect texture and viewport
	var PortalAViewport = PortalA.get_node("SubViewport").get_path()
	var PortalBViewport = PortalB.get_node("SubViewport").get_path()
	
	PortalA.get_node("Mesh").get_active_material(0).albedo_texture.viewport_path = PortalAViewport
	PortalB.get_node("Mesh").get_active_material(0).albedo_texture.viewport_path = PortalBViewport

func _physics_process(_delta):
	var PortalAMesh = PortalA.get_node("Mesh")
	var PortalBMesh = PortalB.get_node("Mesh")
	var PortalACamera = PortalA.get_node("SubViewport/Camera")
	var PortalBCamera = PortalB.get_node("SubViewport/Camera")
	
	#if !Engine.is_editor_hint():
	PortalACamera.global_position = PortalBMesh.global_position
	PortalBCamera.global_position = PortalAMesh.global_position
	PortalACamera.rotation = PortalB.rotation + Vector3(0, deg_to_rad(180), 0)
	PortalBCamera.rotation = PortalA.rotation + Vector3(0, deg_to_rad(180), 0)
	if !Engine.is_editor_hint():
		
		var PortalA_PointA = Player.position + PortalACamera.position
		var PortalA_AngleA = PortalACamera.position.angle_to(Player.position)
		var PortalA_AngleB = PortalA_AngleA + PI
		var PortalA_PointB = PortalACamera.position.rotated(PortalA_PointA, PortalA_AngleB)
		PortalACamera.rotation.y += PortalA_AngleB#deg_to_rad(PortalACamera.position.angle_to(PortalA_PointB))#deg_to_rad(PortalACamera.position.angle_to(Player.position))
		#PortalBCamera.rotation.y += deg_to_rad(PortalBCamera.position.angle_to(Player.position))
