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
	
	#PortalA.get_node("SubViewport/Camera").position = Vector3.ZERO
	#PortalB.get_node("SubViewport/Camera").position = Vector3.ZERO

func _physics_process(_delta):
	var PortalAMesh = PortalA.get_node("Mesh")
	var PortalBMesh = PortalB.get_node("Mesh")
	var PortalACamera = PortalA.get_node("SubViewport/Camera")
	var PortalBCamera = PortalB.get_node("SubViewport/Camera")
	var PortalAView = PortalA.get_node("SubViewport")
	var PortalBView = PortalB.get_node("SubViewport")
	
	if PortalAView.size != DisplayServer.window_get_size() || PortalBView.size != DisplayServer.window_get_size():
		PortalAView.size = DisplayServer.window_get_size()
		PortalBView.size = DisplayServer.window_get_size()
	
	if Engine.is_editor_hint():
		PortalACamera.global_position = PortalBMesh.global_position - Vector3(0, 0, 0)
		PortalBCamera.global_position = PortalAMesh.global_position - Vector3(0, 0, 0)
		PortalACamera.rotation = PortalB.rotation + Vector3(0, deg_to_rad(180), 0)
		PortalBCamera.rotation = PortalA.rotation + Vector3(0, deg_to_rad(180), 0)
	else:
		#var linked: Node = links[portal]
		#var trans: Transform3D = linked.global_transform.inverse() * get_camera_3d().global_transform
		#var up := Vector3(0, 1, 0)
		#trans = trans.rotated(up, PI)
		#portal.get_node("CameraHolder").transform = trans
		#var cam_pos: Transform3D = portal.get_node("CameraHolder").global_transform
		#portal.get_node("SubViewport/Camera3D").global_transform = cam_pos
		
		var PortalA_relativePosition = PortalB.get_node("Mesh").global_transform.inverse() * Player.get_node("Camera").global_transform
		PortalA_relativePosition = PortalA_relativePosition.rotated(Vector3.UP, PI)
		PortalA.get_node("CameraHolder").transform = PortalA_relativePosition
		PortalACamera.global_transform = PortalA.get_node("CameraHolder").global_transform
