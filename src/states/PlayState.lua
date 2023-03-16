--[[
    Representa el estado de juego que estamos jugando. el jugador deveria poder controlar la paleta,
    con la pelotita activamente rebotando. si cae debajo de la paleta, el jugador pierde un corazon
    y ser llevado a la pantalla de game over al 0 de salud o sino al estado de servir
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()

    --inicializar la bola con skin #1
    self.ball  = Ball(1)

    --darle una velocidad de arranque random
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    --darle a la bola poscicion en el centro
    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

    --usar la createMap 'estatica' para generar la tabla de la pared
    self.bricks = levelMaker.createMap()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
    self.paused = true
        gSounds['pause']:play()
        return
    end
    

    --Actualizar las posiciones en basea a la velocidad
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        -- revertir la velocidad y si se detecta colision entre la pelota y la paleta
        self.ball.dy = -self.ball.dy
        gSounds['paddle-hit']:play()
    end

    --Detectar colision a lo largo de todos los ladrillos
    for k, brick in pairs(self.bricks) do

        --solo preguntar colision si el ladrillo esta en juego
        if brick.inPlay and self.ball:collides(brick) then
            
            --gatillar la funcion hit del ladrillo, que lo saca de juego
            brick:hit()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    --renderizar pared
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    self.paddle:render()
    self.ball:render()

    --texto de pausa, si esta pausado
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('PAUSA', 0, VIRTUAL_HEIGHT / 2 -16, VIRTUAL_WIDTH, 'center')
    end
end