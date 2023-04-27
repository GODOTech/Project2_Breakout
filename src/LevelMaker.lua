--[[
    crea niveles aleatorios. devuelve una tabla de ladrillos 
    que el juego puede renderizar, basado en el nivel actual
]]

--patrones globales (utilizados para que el mapa entero tenga cierta forma)

NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

--Patrones por fila
SOLID = 1       --Todos los colores son iguales en esta fila
ALTERNATE = 2   --Colores alternos
SKIP = 3        --Saltear blocke de pormedio
NONE = 4        --Sin blockes en esta fila

LevelMaker = Class{}
--[[
    crea una tabla de ladrillos para ser devuelta al juego principal, con diferentes
    posibilidades de randomizar las filas y columnas de ladrillos. Calcula que los colores
    y los tiers en base al nivel en el que estamos
]]
function LevelMaker.createMap(level)
    local bricks = {}

    -- Elegir aleatoriamente el numero de filas
    local numRows = math.random(1, 5)

    -- Elegir aleatoriamente el numero de columnas, asegurando que sean pares
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    --Ladrillo del color mas alto en este nivel , nunca mas de 3
    local highestTier = math.min(3,math.floor(level / 5))

    --color mas alto del tier mas alto
    local highestColor = math.min(5, level % 5 +3)

    -- Colocar los ladrilos para que esten en contacto entre si y llenen el espacio
    for y = 1, numRows do
        --si queremos habilitar el salteado para esta fila
        local skipPattern = math.random(1,2) == 1 and true or false

        -- si es que queremos habilitar el patron alternado de color para esta fila
        local alternatePattern = math.random(1, 2) == 1 and true or false

        --elegir 2 colores entre los cuales alternar
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)

        --usado solamente cuando queremos saltear un blocke, para el patron salteado
        local skipFlag = math.random(2) == 1 and true or false

        --usado solo cuando queremos alternar un blocke, para el patron alternado
        local alternateFlag = math.random(2) == 1 and true or false

        --color solido que vamos a usar si no estamos alternando
        local solidColor = math.random(1,highestColor)
        local solidTier = math.random(0, highestTier)
        
        for x = 1, numCols do
            --si saltear esta encendido y salteamos una iteracion...
            if skipPattern and skipFlag then
                --Apagar el salteado para la proxima iteracion
                skipFlag = not skipFlag

                --lua no tiene una declaracion de continue, asi que esta es la circumvalacion:
                goto continue
            else
                --cambiar la marca a cierto en una iteracion que no utilizamos
                skipFlag = not skipFlag
            end
            
            b = Brick(
                --coordenada x
                (x-1)                       --reducir x por 1 porque las tablas estan 1-indexadas las coordenadas son 0 
                * 32                        --multiplicar por 32, el ancho del ladrillo
                + 8                     --la pantalla debe tener 8 pixeles de relleno; podemos acoplar 13 cols + 16 pixeles toatal
                + (13 - numCols) * 16,  --relleno del lado izquierdo para cuando hay menos de 13 columnas

                -- coordenada y
                y * 16                  --solo usar y * 16, ya que necesitamos relleno en la parte de arriba tambien
            )

            --Si estamos alternando, decifrar en que color/tier estamos
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            --Si no estamos alternando y llegamos hasta aca, usamos el color/tier solido
            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks, b)

            --la version de la declaracion 'continue' de lua
            ::continue::
        end
    end
    
    --en caso que no hayamos genrado ningun ladrillo, tratar denuevo
    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end
