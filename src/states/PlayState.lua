--[[
    Representa el estado de juego que estamos jugando. el jugador deveria poder controlar la paleta,
    con la pelotita activamente rebotando. si cae debajo de la paleta, el jugador pierde un corazon
    y ser llevado a la pantalla de game over al 0 de salud o sino al estado de servir
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()
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

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()

    --texto de pausa, si esta pausado
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('PAUSA', 0, VIRTUAL_HEIGHT / 2 -16, VIRTUAL_WIDTH, 'center')
    end
end