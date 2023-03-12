--[[
    push es una libreria que nos permite dibujar nuestro juego en una resolucion virtual
    en vez de utilizar la de la ventana, para un look mas retro
]]
push = require 'lib/push'

--[[
    la libreria 'class' que estamos utilizando nos permite representar cualquier cosa en 
    nuestro juego como codigo, en vez de mantener registro de muchas variables y metodos disparatados
]]
Class = require 'lib/class'

-- un par de constantes globales, centralizadas
require 'src/constants'

--[[
    una clase de maquina de estados basica que nos permite transicionar desde y hasta
    los estados de juego ordenadamente, evitando codigo monolithico en un solo archivo
]]
require 'src/StateMachine'

--[[
    cada uno de los estados individuales en los que nuestro juego puede estar uno a la vez;
    cada estado tiene sus propios metodos de update y render que pueden ser llamados por 
    nuestra maquina de estados, cada cuadro, para evitar hacer bulto de codigo en main.lua
]]
require 'src/states/BaseState'
require 'src/states/StartState'
