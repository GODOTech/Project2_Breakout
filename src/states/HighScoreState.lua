--[[
    Representa la pantalla donde podemos ver todos los puntajes guardados
]]

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    --volver a la pantalla de inicio si presionamos escape
    if love.keyboard.wasPressed('escape') then
       gSounds['wall-hit']:play()
       
       gStateMachine:change('start', {
        highScore = self.highScores
       })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    --iterar por todos los puntajes en nuestra tabla
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        -- numero del puntaje (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4,
            60 + i * 13, 50, 'left')

        --nombre del puntaje 
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 
            60 + i * 13, 50, 'right')

        --el puntaje en si mismo
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            60 + i * 13, 100, 'right')
    end
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Presiona ¨ESC¨ para volver',
    0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end