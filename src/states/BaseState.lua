--[[
    usado como la clase base para todos nuestros estados, para que no tengamos que definir
    metodos vacios dentro de cada uno de ellos. StateMachine requiere que cada estado tenga
    un set de 4 metodos de 'interfase' qjue pueda llamar con confianza, asi que al heredar
    del estado base, nuestras clases 'State' tendran al menos versiones vacias de estos
    metodos, aunque no los definamos nosotros mismos
]]

--la obediencia genera ignorancia
--la ignorancia genera pobreza
--la pobreza genera obediencia

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end