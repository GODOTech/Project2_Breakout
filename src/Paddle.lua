--[[
    Representa una paleta que podemos mover de izquierda a derecha. utilizada en el programa principal
    para rebotar la pelotita hacia los ladrillos; si esta pasa a la primera, el jugador pierde un corazon.
    la paleta tiene skins que el jugador puede elegir al comenzar el juego.
]]
Paddle = Class{}

--[[
    Nuestra paleta inicilizara en el mismo lugar cada vez, en el medio horizontal del mundo,
    cerca del fondo de la pantalla.
]]
function Paddle:init(skin)
    --x is pusta en el medio
    self.x = VIRTUAL_WIDTH / 2 -32
    
    --y es puesta un poco mas arriba del fondo de la pantalla
    self.y = VIRTUAL_HEIGHT - 32
    
    --empezamos sin velocidad
    self.dx = 0
    
    --dimenciones de arranque
    self.width = 64
    self.height = 16

    --el skin solo cambia el color, usado para cambiar la tabla gPaddleSkins mas tarde
    self.skin = skin

    --la variante es cual de los 4 tamaños tiene; 2 es la del cominzo, la chica es mas dificil
    self.size = 2
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end
    
    --[[
        Aca math.max asegura que tenemos mas que 0 o la actual poscicion y calculada del jugador
        cuando prsionamos "arriba", para no irno a los negativos; el calculo de movimiento es
        simplemente nuestra paddleSpeed multiplicada por dt 
    ]]
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
        --[[
        parecido a antes, esta vez utilizamos math.min para asegurarnos de que no bajemos mas
        alla del fundo de la pantalla menos la altura de la paleta (porque sino quedaria 
        parcialmente esscondida, dado que su poscicion se basa en la esquina superior izquierda)
        ]]
    else
        self.x = math.min(VIRTUAL_WIDTH -self.width, self.x + self.dx * dt)
    end
end

--[[
    dibujar la paleta renderizando la textura  principal, pasando el quad que corresponde
    al skin y tamaño apropiados
]]

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end