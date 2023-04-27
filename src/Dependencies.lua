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

-- La pelotita que rebota por ahi, rompiendo ladrillos y bajando vidas
require 'src/Ball'

-- Entidades en nuestro mapa de juego, que nos dan puntos por colisionar contra ellos
require 'src/Brick'

-- Una clacse generada para hacer arreglos de ladrillo
require 'src/LevelMaker'

-- La entidad rectnagular de los controles del jugador, que rebotan la pelota
require 'src/Paddle'

--[[
    una clase de maquina de estados basica que nos permite transicionar desde y hasta
    los estados de juego ordenadamente, evitando codigo monolithico en un solo archivo
]]
require 'src/StateMachine'

--[[
    funciones utilitarias, principalmente para dividir nuestro sprite sheeat en multiples Quads
    de diferentes tamaños de paletas, pelotas, ladrillos, etc
]]
require 'src/Util'

--[[
    cada uno de los estados individuales en los que nuestro juego puede estar uno a la vez;
    cada estado tiene sus propios metodos de update y render que pueden ser llamados por 
    nuestra maquina de estados, cada cuadro, para evitar hacer bulto de codigo en main.lua
]]
require 'src/states/BaseState'
require 'src/states/EnterHighScoreState'
require 'src/states/GameOverState'
require 'src/states/HighScoreState'
require 'src/states/PlayState'
require 'src/states/ServeState'
require 'src/states/StartState'
require 'src/states/VictoryState'