--[[
    el estado en el cual estamos esperando para tirar la pelota; aca basicamente solo estamos moviendo
    la paleta de izquierda a derecha junto con la pelota hasta que presionemos enter, aunque todo en
    el juego en si deve estar renderizado para el saque en si, incluyendo nuestra salud, nivel y puntaje 
]]
ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    --agarrar el estado de juego de params
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints

    --inicializar nueva pelota (color aleatorio por diversion XD)

    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    -- que la bola rastree al jugador
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) -4
    self.ball.y = self.paddle.y - 8
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- pass in all important state info to the PlayState
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball = self.ball,
            level = self.level,
            recoverPoints = self.recoverPoints
        })
    end
    
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end 

function ServeState:render()
    self.paddle:render()
    self.ball:render()

   for k, brick in pairs(self.bricks) do
    brick:render()    
   end

   renderScore(self.score)
   renderHealth(self.health)

   love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
        
   love.graphics.setFont(gFonts['medium'])
   love.graphics.printf('Presiona Enter para sacar!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end