--[[
    representa el estado en el que se encuentra el juego cuando completamos un nivel.
    muy similar al ServeState, exepto que aca incrementamos el nivel
]]

VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.health = params.health
    self.ball = params.ball
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    --que la pelota siga al jugador
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    -- ir a la pantalla de 'play' si el jugador presiona enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)
    
    -- texto de nivel completado
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Presiona Enter para servir!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
end