--[[
    representa un ladrilo en el mundo, con el cual la pelota puede colisionar;
    ladrillos de distintos colores tienen distintos atributos, al colisionar,
    la pelota rebota segun el angulo de la colision. cuando se eliminen todos los ladrilos
    el jugador deberia ser transportado a un nuevo arreglo de ladrillos
]]
Brick = Class{}

function Brick:init(x,y)
    -- usado para colorear y calculo de puntaje
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    --usado para ver si este ladrilo debe ser dibujado
    self.inPlay = true
end

--[[
    Gatilla in golpe al ladrillo, secandolo de juego si su salud llega a 0,
    o cambiando su color sino.
]]

function Brick:hit()
    gSounds['brick-hit-2']:play()
    self.inPlay = false
end


--[[
    multiplicar el color por 4 (-1) para nuetro desplazamiento de color, despues añadirle
    el tier. para dibujar el tier y el color correspondiente 
]]
function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
            gFrames['bricks'][1+((self.color - 1) * 4) + self.tier],
            self.x, self.y)
    end
end