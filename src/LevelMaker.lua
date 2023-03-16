--[[
    crea niveles aleatorios. devuelve una tabla de ladrillos 
    que el juego puede renderizar, basado en el nivel actual
]]
levelMaker = Class{}

function levelMaker.createMap(level)
    local bricks = {}

    -- Elegir aleatoriamente el numero de filas
    local numRows = math.random(1, 5)

    -- Elegir aleatoriamente el numero de columnas
    local numCols = math.random(7, 13)


    -- Colocar los ladrilos para que esten en contacto entre si y llenen el espacio
    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                --coordenada x
                (x-1)
                * 32
                + 8
                + (13 - numCols) * 16,

                -- coordenada y
                y * 16
            )

            table.insert(bricks, b)
        end
    end
    
    return bricks
end
