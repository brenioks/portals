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
	
	PortalA.get_node("SubViewport/Camera").position = Vector3.ZERO
	PortalB.get_node("SubViewport/Camera").position = Vector3.ZERO

func _physics_process(_delta):
	var PortalAMesh = PortalA.get_node("Mesh")
	var PortalBMesh = PortalB.get_node("Mesh")
	var PortalACamera = PortalA.get_node("SubViewport/Camera")
	var PortalBCamera = PortalB.get_node("SubViewport/Camera")
	
	if Engine.is_editor_hint():
		PortalACamera.global_position = PortalBMesh.global_position - Vector3(0, 0, 0)
		PortalBCamera.global_position = PortalAMesh.global_position - Vector3(0, 0, 0)
		PortalACamera.rotation = PortalB.rotation + Vector3(0, deg_to_rad(180), 0)
		PortalBCamera.rotation = PortalA.rotation + Vector3(0, deg_to_rad(180), 0)
	else:
		## Convert from global space to local space at the entrance (this) portal
		#var local:Transform3D = global_transform.affine_inverse() * real
		## Compensate for any scale the entrance portal may have
		#var unscaled:Transform3D = local.scaled(global_transform.basis.get_scale())
		## Flip it (the portal always flips the view 180 degrees)
		#var flipped:Transform3D = unscaled.rotated(Vector3.UP, PI)
		## Apply any scale the exit portal may have (and apply custom exit scale)
		#var exit_scale_vector:Vector3 = exit_portal.global_transform.basis.get_scale()
		#var scaled_at_exit:Transform3D = flipped.scaled(Vector3.ONE / exit_scale_vector * exit_scale)
		## Convert from local space at the exit portal to global space
		#var local_at_exit:Transform3D = exit_portal.global_transform * scaled_at_exit
		#return local_at_exit
		
		var relative = PortalA.get_node("Mesh").global_transform.affine_inverse() * Player.get_node("Camera").global_transform
		var unscaled = relative.scaled(PortalA.get_node("Mesh").global_transform.basis.get_scale())
		var flipped = unscaled.rotated(Vector3.UP, PI)
		var exitScaleVector = PortalB.global_transform.basis.get_scale()
		var scaledAtExit	= flipped.scaled(Vector3.ONE / exitScaleVector * 1)
		var localAtExit:Transform3D = PortalB.get_node("Mesh").global_transform * scaledAtExit
		PortalACamera.global_transform = localAtExit
