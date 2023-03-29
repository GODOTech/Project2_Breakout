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
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    --Si estamos en un tier alto, bajamos uno
    --Si estmos en el color mas bajo, bajamos un color
    if self.tier > 0 then
        if sellf.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        --Si estamos en el nivel mas bajo y en el color base, quitar el ladrillo
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end
    --Otro sonido si el ladrillo es destruido
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
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