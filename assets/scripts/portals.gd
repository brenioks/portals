@tool
extends Node

@onready var PortalA = %PortalA
@onready var PortalB = %PortalB
@onready var Player = %Player

func _ready():
	# Auto connect texture and viewport
	var PortalAViewport = PortalA.get_node("SubViewport")
	var PortalBViewport = PortalB.get_node("SubViewport")
	
	PortalA.get_node("Mesh").get_active_material(0).set_shader_parameter("albedo", PortalAViewport.get_texture())
	PortalB.get_node("Mesh").get_active_material(0).set_shader_parameter("albedo", PortalBViewport.get_texture())
	
	PortalA.get_node("Area3D").body_entered.connect(_portal_body_entered.bind(PortalA))
	PortalB.get_node("Area3D").body_entered.connect(_portal_body_entered.bind(PortalB))
	
	#PortalA.get_node("SubViewport/Camera").position = Vector3.ZERO
	#PortalB.get_node("SubViewport/Camera").position = Vector3.ZERO

func _physics_process(_delta):
	var PortalAMesh = PortalA.get_node("Mesh")
	var PortalBMesh = PortalB.get_node("Mesh")
	var PortalACamera = PortalA.get_node("SubViewport/Camera")
	var PortalBCamera = PortalB.get_node("SubViewport/Camera")
	var PortalAView = PortalA.get_node("SubViewport")
	var PortalBView = PortalB.get_node("SubViewport")
	
	var windowSize = get_viewport().size
	if PortalAView.size != windowSize || PortalBView.size != windowSize:
		PortalAView.size = windowSize
		PortalBView.size = windowSize
	
	if Engine.is_editor_hint():
		PortalACamera.global_position = PortalBMesh.global_position - Vector3(0, 0, 0)
		PortalBCamera.global_position = PortalAMesh.global_position - Vector3(0, 0, 0)
		PortalACamera.rotation = PortalB.rotation + Vector3(0, deg_to_rad(180), 0)
		PortalBCamera.rotation = PortalA.rotation + Vector3(0, deg_to_rad(180), 0)
	else:
		var MainCamera = Player.get_node("Camera")
		
		var PortalA_relativePosition = PortalB.global_transform.inverse() * MainCamera.global_transform
		PortalA_relativePosition = PortalA_relativePosition.rotated(Vector3.UP, PI)
		PortalA.get_node("CameraHolder").transform = PortalA_relativePosition
		PortalACamera.global_transform = PortalA.get_node("CameraHolder").global_transform
		
		var PortalB_relativePosition = PortalA.global_transform.inverse() * MainCamera.global_transform
		PortalB_relativePosition = PortalB_relativePosition.rotated(Vector3.UP, PI)
		PortalB.get_node("CameraHolder").transform = PortalB_relativePosition
		PortalBCamera.global_transform = PortalB.get_node("CameraHolder").global_transform
	

func _portal_body_entered(body, portal):
	if !(body is PhysicsBody3D): return
	var MainCamera = Player.get_node("Camera")
	if portal == PortalA:
		#var PortalA_relativePosition = Player.global_transform * PortalB.global_transform.affine_inverse()
		body.position += PortalB.position - body.position
		body.rotation += PortalB.rotation.rotated(Vector3.UP, PI)
	if portal == PortalB:
		body.position += PortalA.position - body.position
		#body.rotation += PortalA.rotation.rotated(Vector3.UP, PI)
