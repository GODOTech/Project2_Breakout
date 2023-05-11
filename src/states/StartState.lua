--[[
    Representa el estado en el que el juego arranca, solo debe mostrar el titulo
    y el mensaje de 'press enter'
]]

--[[
    el '__includes' significa que vamos a heredar todos los metodos que BaseState tiene,
    asi tendra versiones vacias de todos los metodos de StateMachine, incluso si no los 
    sobreescribimos, util para evitar codigo superfluo! 
]]
StartState = Class{__includes = BaseState}

-- si es que tenemos resaltado 'Start' o 'High Scores'
local highlighted = 1

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
    --cambiar la opcion resaltada si presionamos "ariba" o "abajo"
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted  == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end
    
    --confirmar la opcion que marcamos en pantalla
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('paddle-select', {
                highScores = self.highScores
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end

    --ya no tenemos esta global, asi que se incluye aca
    if love .keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState.render()
    -- titulo
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('BREAKout', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

    --instrucciones
    love.graphics.setFont(gFonts['medium'])

    --si estamos resaltando 1, dibujar esa opcion en azul
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("COMEZAR", 0, VIRTUAL_HEIGHT / 2 +70, VIRTUAL_WIDTH, 'center')

    --resetear color
    love.graphics.setColor(1, 1, 1, 1)
    
    --dibujar la opcion 2 en azul si estamos resaltando esa
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end

    love.graphics.printf('TABLA DE PUNTAJES', 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    --resetear color
    love.graphics.setColor(1, 1, 1, 1)
end
