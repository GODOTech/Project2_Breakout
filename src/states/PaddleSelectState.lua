 --[[
    representa el estado del juego justo despues de comenzar;
    Simplemente dice 'Breakout' en texto grande 
    y el mesaje de presinar enter para seguir 
 ]]

 PaddleSelectState = Class{__includes = BaseState}

 function PaddleSelectState:enter(params)
    self.highScores = params.highScores    
 end

 --[[
    la paleta que estamos resaltando
    sera pasada a el estado de servir cuando presionemos enter
 ]]
 function PaddleSelectState:init()
    self.currentPaddle = 1
 end

 function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1     
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    --Seleccionar lapaleta y pasar al estado de servir, pasando la seleccion
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['confirm']:play()

        gStateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker.createMap(1),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 1
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end    
 end

 function PaddleSelectState:render()
    --instrucciones
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Selecciona tu Paleta!', 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, "center")
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('(Presiona Enter para continuar)', 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- La flecha izquierda deveria renderizarse normalmente si estamos mas que 1, sino
    -- en una forma sombreada para dejarnos saber que estamos todo a la izquierda posible
    if self.currentPaddle == 1 then
        --teñir; darle un mediotono gris con media opacidad
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 -24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    --Resetear color de dibujo a blanco completo para el rendering correcto
    love.graphics.setColor(1,1,1,1)

    --flecha derecha; deberia renderizarse normalmente si estmos en menos de 4, sino
    --en una forma sombreada para dejarnos saber que no se puede avanzar mas
    if self.currentPaddle == 4 then
        --teñir; darle un medio tono con media opacidad
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
 
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    --resetear el color de dibujo a blanco total para que se vea normal
    love.graphics.setColor (1, 1, 1, 1)

    --dibujar la paleta en si misma, basandonos en la que hemos seleccionado
    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)],
        VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3) 
end