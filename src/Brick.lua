--[[
    representa un ladrilo en el mundo, con el cual la pelota puede colisionar;
    ladrillos de distintos colores tienen distintos atributos, al colisionar,
    la pelota rebota segun el angulo de la colision. cuando se eliminen todos los ladrilos
    el jugador deberia ser transportado a un nuevo arreglo de ladrillos
]]
Brick = Class{}

--algunos de colores en nuestra paleta
paletteColors = {

    --Azul
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    
    --Verde
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },

    --Rojo
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },

    -- violeta
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    
    -- dorado
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
} 

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

    --Sistema de particulas perteneciente al ladrilo, emitido en golpe
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    --dura entre 0.5 - 1 segundos
    self.psystem:setParticleLifetime(0.5, 1)

    --darle una aceleracion entre x1, y1 y x2, y2 (0,0) y (80, 80). añadir fuerza hacia abajo
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    --esparcir particulas, normal se ve mas natural, que uniforme,desviacion en x e y
    self.psystem:setEmissionArea('normal', 10, 10)
end

--[[
    Gatilla in golpe al ladrillo, secandolo de juego si su salud llega a 0,
    o cambiando su color sino.
]]
function Brick:hit()
    --[[setear el sistema de particulas para interpolar 2 colores, en este caso, le damos nuestro
    self.colour pero con una variacion en el alpha; mas brillante para niveles altos, desvaneciendose
    a 0 durante el tiempo de vida de la particula (el segundo color)
    ]]

    self.psystem:setColors(
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        55 * (self.tier + 1) / 255,
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        0
    )
    self.psystem:emit(64)
    
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    --Si estamos en un tier alto, bajamos uno
    --Si estmos en el color mas bajo, bajamos un color
    if self.tier > 0 then
        if self.color == 1 then
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

function Brick:update(dt)
    self.psystem:update(dt)
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


--[[
    necesitamos un renderizador a parte para nuestras particulas que pueda ser llamado despues de que
    todos los ladrillos fueron dibujados, de lo contrario, algunos ladrillos serian renderizados sobre
    el sistema de particulas de otros ladrillos
]]
function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end