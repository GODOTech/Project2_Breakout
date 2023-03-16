--[[
    Representa la pelotita que rebota contra las paredes, los ladrillos y la paleta del
    jugador; tiene un skin, se se puede asignar de manera aleatoria, solo para la variedad visual
]]
Ball = Class{}

function Ball:init(skin)
    --simples variables de psicionamiento y direccion
    self.width = 8
    self.height = 8

    -- estas variables son para llevar registro de la velocidad
    self.dy = 0
    self.dx = 0

    --este es el color de la pelota, e indexamos los quads relativo al bloke global, con esto
    self.skin = skin
end

--[[
    espera un argumento con una caja de contencion, sea la paleta o un ladrillo,
    y devuelve verdadero si las cajas de esta y el argumento se superponen 
]]
function Ball:collides(target)
    --primero chekear si la parte de abajo esta mas abajo que la parte de arriba (overlap)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    --despues chekear si el fondo esta mas alto que la cima del otro
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- si lo de arriba no es cierto, hay superposcicion
    return true
end

--poner la pelotita en medio de la pantalla, sin movimiento
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- permitirle a la pelota rebotar por las paredes
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = - self.dy
        gSounds['wall-hit']:play()
    end
end


--[[
    gTexture es nustra textura global para todos los bloques;
    gBallFrames es una tabla de quads mapeados a cada skin de la pelota
]]
function Ball:render()
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end