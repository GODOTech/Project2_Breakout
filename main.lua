require 'src/Dependencies'
--[[
    llamado solo una vez al comienzo del juego;
    usado para setear los objetos, variables, etc. y preparar el mundo del juego
]]

function love.load()
    --setear el filtro a 'nearest-neighbor', para un verdadero look retro
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    --sembrar el GNA para que los valores aleatorios sean siempre distintos
    math.randomseed(os.time())

    --barra de titulo
    love.window.setTitle('BREAKout')

    --inicializar nuestras fuentes retro
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
love.graphics.setFont(gFonts['small'])

gTextures= {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
}

--inicializar nuestra resolucion virtual, la cual sera renderizada en nuestra ventana,
--sin importar sus dimensiones

push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
})

gSounds = {
    ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
    ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

    ['music'] = love.audio.newSource('sounds/music.wav', 'static')
}

--[[
    La maquina de estados que vamos a utilizar para transcicionar entre los estados de juego
    en vez de amasijar todo junto en nuestros metodos de draw y update

    Nuestro estdo de juego puede ser cualquiera de los siguientes:

    1.'start'(el comienzo de juego donde se nos pide que presionemos 'enter')
    2.'paddle-select'(donde vamos a selecionar la paleta)
    3.'serve'(esperando la presion de la tecla para lanzar la bola)
    4.'play'(la pelota esta en juego!)
    5.'victory'(se termino el nivel, con un jingle de victoria)
    6.'game-over'(el jugador perdio; mostrar puntaje y pernitir el restart)
]]


gStateMachine = StateMachine {
    ['start'] = function() return StartState() end
}

gStateMachine:change('start')

--[[
    una tabla que vamos a utilizar para llevar registro de que teclas fueron presionadas
    en este cuadro, para circumbalar el echo de que el llamado por defecto de LÖVE
    no nos dejaria probar un input desde dentro de otras funciones 
]]
love.keyboard.keysPressed = {}
end

--[[
    Llamado cada vez que cambiamos las dimensiones de nuestra ventana, solo nesecitamos
    llamar a push para que maneje el resizing.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Llamado cada cuadro, pasando 'dt' desde el ultimo cuadro. 'dt' es una contraccion para
    'deltaTime' y esmedida en segundos. Multiplicando esto por cualquier cambio que querramos
    hacer en nuestro juego, le permite desempeñarze concistentemente atravez de todo hardware;
    de otro modo, cualquier cambio sera aplicado lo mas rapido posible y eso varia segun la maquina
]]

function love.update(dt)
    --esta vez pasamos dt al estado del objeto que estamos utilizando actualmente
    gStateMachine:update(dt)

    --resetear teclas pulsadas
    love.keyboard.keysPressed = {}
end

--[[
    un llamado que procesa un pulsado de teclas a medida que van pasando, solo una vez.
    no tiene en cuenta teclas que se mantienen pulsadas, lo que es manejado por una funcion separada
    ('love.keyboard.isDown'). util para cuando queremos que la cosas pasen de inmediato, solo una vez,
    como por ejemplo 'salir'
]]
function love.keypressed(key)
    --añadir a la tabla de teclas presinoadas este cuadro
    love.keyboard.keysPressed[key] = true
end

--[[
    una funcion customizada que nos permite detectar teclas individoales fuera del llamado
    de 'love.keypressed' por defecto, ya que no podemos llamar esa logica en otro lado por defecto.
]]

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--[[
    llamado cada cuadro despues del update;
    es responsable de simplemente dibujar los objetos del juego en la pantalla
]]
function love.draw()
    -- comenzar a dibujar con push, en nuestra resolucion virtual
    push:apply('start')

    --el fondo deberia ser dibujado sin importar el estado, escalado a la resolucion virtual
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        --dibujar en las coordenadas 0, 0
        0, 0,
        --sin rotacion
        0,
        -- factor de escala en X e Y para que llena la pantalla
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    --usar la maquina de estados para diferir el rendering al estado corriente en que estamos
    gStateMachine:render()

    --mostrar los cuadros por segundo para debuguear
    displayFPS()

    push:apply('end')
end

function displayFPS()
    --simplemente mostrar los FPS atravez de todos los estados
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: '.. tostring(love.timer.getFPS()), 5, 5)
end
