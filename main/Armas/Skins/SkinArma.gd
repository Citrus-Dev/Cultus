class_name SkinArma
extends Node2D

export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var animador = get_node(animador) as AnimationPlayer
export(NodePath) onready var pos_mano_izq = get_node(pos_mano_izq) as Position2D
export(NodePath) onready var pos_mano_der = get_node(pos_mano_der) as Position2D
export(NodePath) onready var pos_casquillos = get_node(pos_casquillos) as Position2D

export(bool) var una_mano # El rig de IK tiene solo la mano derecha
