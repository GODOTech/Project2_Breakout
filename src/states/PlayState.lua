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
        self.ball.y = self.paddle.y -8
        self.ball.dy = -self.ball.dy

        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = 50 + (8* math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    --Detectar colision a lo largo de todos los ladrillos
    for k, brick in pairs(self.bricks) do

        --solo preguntar colision si el ladrillo esta en juego
        if brick.inPlay and self.ball:collides(brick) then
            
            --gatillar la funcion hit del ladrillo, que lo saca de juego
            brick:hit()
--[[
    codigo de collision para ladrillos
    revisamos si el lado opuesto de nuestra velocidad esta fuera del ladrillo; si es asi, gatillamos
    la colision de ese lado. Sino mientras estemos dentro de x + ancho del ladrillo y deberia revisar
    si la parte superior o inferior esta fuera del ladrillo, colisionando correctamente con ambas. 
]]

            --borde izquierdo; checkear solo si nos movemos a la derecha
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                
                --invertir velocidad x y resetear poscicion afuera del ladrillo
                self.ball.dx = - self.ball.dx
                self.ball.x = brick.x - 8
                
                --borde derecho; solo checkear si nos estamos moviendo a la izquierda
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then

                --invertir velocidad x y resetear la poscicion fuera del ladrillo
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32

            -- top edge if no X collisions, always check
             elseif self.ball.y < brick.y then   

                -- flip y velocity and reset position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
                
                --El borde del fondo si no hay colisiones en x ni arriba, ultima posibilidad
            else
                -- invertir la velocidad en y; resetear la poscicion fuera del ladrillo
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end

            --cambiar ligeramente la velocidad en y para acelerar el juego
            self.ball.dy = self.ball.dy * 1.02

            --permite collisionar son un ladrillo a la vez, por las esquinas
            break
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