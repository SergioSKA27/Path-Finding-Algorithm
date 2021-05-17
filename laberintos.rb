require 'ruby2d'
=begin
Para ejecutar la aplicacion tenemos que haber instalado previamente 
la gema de ruby2d.
=end
set title: 'LABERINTOS'
set background: 'white'
set width: 1280
set height: 720 
set resizable: true

$actualbackground = get :background
sleep 1


class Node
    attr_reader :x_pos , :y_pos, :color, :sqr, :size , :center
    attr_reader :wall1, :wall2, :wall3, :wall4, :visited
    attr_reader :w1, :w2,:w3,:w4
    @@father = nil
    @@distance = 1e9
    
=begin
    La clase toma como parametros un punto sobre el cual estableceremos un 
    punto , y a partir de el dibujaremos cutro lineas que representaran las paredes
    de cada celda.
    Los sig. paremtros son el tamaño que tendra el punto el tamaño recomendado es uno 
    pero puedes variar el tamaño y las celdas mantendran su misma proporcion por lo que 
    puedes marcar una casilla simplemente incrementando el tamaño del centro.
    Por ultimo podemos seleccionar el color que queramos tener en las paredes de la celda 
    tanto como en el centro
=end
    def initialize(x, y, size, color ,*args )
        @x_pos = x 
        @y_pos = y
        @color = color
        @size = size
        #Pared superior
        @wall1 = Line.new(
            x1: x-10 , y1:y-10,
            x2: x+20 , y2:y-10,
            color: color, width: 4
        )
        @w1 = true
        #Pared derecha
        @wall2 = Line.new(
            x1: x+20 , y1:y-8,
            x2: x+20 , y2:y+8,
            color: color, width: 4
        )
        @w2 = true
        #Pared inferior
        @wall3 = Line.new(
            x1: x-10 , y1:y+10,
            x2: x+20 , y2:y+10,
            color: color, width: 4
        )
        @w3 = true
        #Pared izquierda
        @wall4 = Line.new(
            x1: x-10 , y1:y-8,
            x2: x-10 , y2:y+8,
            color: color, width: 4
        )
        @w4 = true
        #centro(relativamete :v)
        @center = Square.new(
            x: x , y: y, 
            color: 'blue' , size: size, 
            z: 5
        )

        @visited = 1
    end
=begin
    changewall nos permite repintar las paredes para poder
    recolorear las paredes para poder retir una pared sin
    necesidad de eleminar directamente el objeto.
    
    pared 1
   p--------p
   a|      |a
   r|      |r
   e|      |e
   d|      |d
   4|------|2
    pared 3

    La funcion recibe como parametro el color con que la vamos a pintar
    *ver colores disponibles en ruby2d
=end
    def changewall1(x)
        @wall1.color = x
        @w1 = false 
    end
    def changewall2(x)
        @wall2.color = x
        @w2 = false 
    end
    def changewall3(x)
        @wall3.color = x
        @w3 = false
    end
    def changewall4(x)
        @wall4.color = x
        @w4 = false
    end
=begin
agiliza el proceso de eliminar una pared seleccionando la pared que queramos 
eliminar y la colorea automaticamente al color del background actual.
=end
    def deletewall(num)
        x = $actualbackground

        if num == 1 then
            self.changewall1(x)
        elsif num == 2 then
            self.changewall2(x)
        elsif num == 3 then 
            self.changewall3(x)
        else 
            self.changewall4(x)
        end
    end

    def wlll1 
        return @w1
    end
    def wlll2 
        return @w2
    end
    def w3 
        return @w3
    end
    def w4 
        return @w4
    end

    def visited(n)
        @visited = n
    end

    def status
        return @visited
    end

    def mark(x)

        if x == 1 then 
            @center.size = 5
            @center.color = 'green'
        elsif x == 2 then 
            @center.size = 5
            @center.color = 'blue'
        else
            @center.size =  10
            @center.color = 'red'
        end
        
    end
    
    def unmark
        for i in 30..1 do
            sleep 1
            self.center(i)
        end
    end




    def numwalls
        n = 0
        if @w1 == true then 
            n += 1
        end
        if @w2 == true then 
            n += 1
        end
        if @w2 == true then 
            n += 1
        end
        if @w2 == true then 
            n += 1
        end

        return n
    end

    def restart
        @wall1.color = 'black'
        @wall2.color = 'black'
        @wall3.color = 'black'
        @wall4.color = 'black'
        @w1 = true
        @w2 = true
        @w3 = true
        @w4 = true
    end

    def show_node
        @wall1
        @wall3
        @wall2
        @center
    end

end


#a = Node.new(60,30,1,'black')
=begin
    Dibujamos un tablero de n * n y almacenamos los nodos en un arreglo bidimensional
    llamado grid.
    Podemos modificar el tamaño del tablero modificando las variables ROWS y COLUMNS. 
=end 

ROWS = 30
COLUMNS = 30
grid = []

xstep = 30
ystep = 30
for i in 0...ROWS do
    r = []
    xaux = xstep
    for j in 0...COLUMNS do
        n = Node.new(xaux,ystep,1,'black')
        r.append(n)
        xaux += 30
    end
    grid.append(r)
    ystep += 20
end

sleep 5

rs = 0
cl = 0
i = 0
j = 0

stack = []

genlab = 1

stack << [0,0]
update do
    
    if genlab == 1 then
        
        top = stack[-1]
        
        randwall = rand(4)+1

        
        if randwall == 1 then
            if top[0] -1 >  0 and grid[top[0]-1][top[1]].status != 3 then
                grid[top[0]][top[1]].deletewall(1)
                stack << [top[0]-1, top[1]]
                grid[top[0]-1][top[1]].visited(2)
            else 
                while randwall == 1
                    randwall = rand(4) +1
                end

                if randwall == 2 then
                    if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                        grid[top[0]][top[1]].deletewall(2)
                        stack << [top[0], top[1]+1]
                        grid[top[0]][top[1]+1].visited(2)
                    else
                        ns = [3,4]
                        randwall = ns[rand(2)]
                        if randwall == 3 then
                            if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(3)
                                stack << [top[0]+1, top[1]]
                                grid[top[0]+1][top[1]].visited(2)
                            else
                                if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(4)
                                    stack << [top[0], top[1]-1]
                                    grid[top[0]][top[1]-1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 4 then
                            if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                grid[top[0]][top[1]].deletewall(4)
                                stack << [top[0], top[1]-1]
                                grid[top[0]][top[1]-1].visited(2)
                            else
                                if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(3)
                                    stack << [top[0]+1, top[1]]
                                    grid[top[0]+1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 3 then
                    if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                        grid[top[0]][top[1]].deletewall(3)
                        stack << [top[0]+1, top[1]]
                        grid[top[0]+1][top[1]].visited(2)
                    else
                        ns = [2,4]
                        randwall = ns[rand(2)]
                        if randwall == 2 then
                            if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                grid[top[0]][top[1]].deletewall(2)
                                stack << [top[0], top[1]+1]
                                grid[top[0]][top[1]+1].visited(2)
                            else
                                if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(4)
                                    stack << [top[0], top[1]-1]
                                    grid[top[0]][top[1]-1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 4 then
                            if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                grid[top[0]][top[1]].deletewall(4)
                                stack << [top[0], top[1]-1]
                                grid[top[0]][top[1]-1].visited(2)
                            else
                                if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(2)
                                    stack << [top[0], top[1]+1]
                                    grid[top[0]][top[1]+1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 4 then
                    if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                        grid[top[0]][top[1]].deletewall(4)
                        stack << [top[0], top[1]-1]
                        grid[top[0]][top[1]-1].visited(2)
                    else
                        ns = [3,2]
                        randwall = ns[rand(2)]
                        if randwall == 3 then
                            if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(3)
                                stack << [top[0]+1, top[1]]
                                grid[top[0]+1][top[1]].visited(2)
                            else
                                if top[1]+1 < COLUMNS and grid[top[0]][top[1]+1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(2)
                                    stack << [top[0], top[1]+1]
                                    grid[top[0]][top[1]+1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 2 then
                            if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                grid[top[0]][top[1]].deletewall(2)
                                stack << [top[0], top[1]+1]
                                grid[top[0]][top[1]+1].visited(2)
                            else
                                if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(3)
                                    stack << [top[0]+1, top[1]]
                                    grid[top[0]+1][top[1]].visited(2)

                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end


            end
        end

        #Te amo liza flores <3(si leees esto casate conmigo :3)

        if randwall == 2 then
            if top[1] + 1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                grid[top[0]][top[1]].deletewall(2)
                stack << [top[0], top[1]+1]
                grid[top[0]][top[1]+1].visited(2)
            else 
                while randwall == 2
                    randwall = rand(4) +1
                end

                if randwall == 1 then
                    if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                        grid[top[0]][top[1]].deletewall(1)
                        stack << [top[0]-1, top[1]]
                        grid[top[0]-1][top[1]].visited(2)
                    else
                        ns = [3,4]
                        randwall = ns[rand(2)]
                        if randwall == 3 then
                            if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(3)
                                stack << [top[0]+1, top[1]]
                                grid[top[0]+1][top[1]].visited(2)
                            else
                                if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(4)
                                    stack << [top[0], top[1]-1]
                                    grid[top[0]][top[1]-1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 4 then
                            if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                grid[top[0]][top[1]].deletewall(4)
                                stack << [top[0], top[1]-1]
                                grid[top[0]][top[1]-1].visited(2)
                            else
                                if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(3)
                                    stack << [top[0]+1, top[1]]
                                    grid[top[0]+1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 3 then
                    if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                        grid[top[0]][top[1]].deletewall(3)
                        stack << [top[0]+1, top[1]]
                        grid[top[0]+1][top[1]].visited(2)
                    else
                        ns = [1,4]
                        randwall = ns[rand(2)]
                        if randwall == 1 then
                            if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(1)
                                stack << [top[0]-1, top[1]]
                                grid[top[0]-1][top[1]].visited(2)
                            else
                                if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(4)
                                    stack << [top[0], top[1]-1]
                                    grid[top[0]][top[1]-1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 4 then
                            if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                grid[top[0]][top[1]].deletewall(4)
                                stack << [top[0], top[1]-1]
                                grid[top[0]][top[1]-1].visited(2)
                            else
                                if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(1)
                                    stack << [top[0]-1, top[1]]
                                    grid[top[0]-1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 4 then
                    if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                        grid[top[0]][top[1]].deletewall(4)
                        stack << [top[0], top[1]-1]
                        grid[top[0]][top[1]-1].visited(2)
                    else
                        ns = [3,1]
                        randwall = ns[rand(2)]
                        if randwall == 3 then
                            if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(3)
                                stack << [top[0]+1, top[1]]
                                grid[top[0]+1][top[1]].visited(2)
                            else
                                if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(1)
                                    stack << [top[0]-1, top[1]]
                                    grid[top[0]-1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 1 then
                            if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(1)
                                stack << [top[0]-1, top[1]]
                                grid[top[0]-1][top[1]].visited(2)
                            else
                                if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(3)
                                    stack << [top[0]+1, top[1]]
                                    grid[top[0]-+1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end


            end
        end

        
        if randwall == 3 then
            if top[0] + 1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                grid[top[0]][top[1]].deletewall(3)
                stack << [top[0]+1, top[1]]
                grid[top[0]+1][top[1]].visited(2)
            else 
                while randwall == 3
                    randwall = rand(4) + 1
                end

                if randwall == 2 then
                    if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                        grid[top[0]][top[1]].deletewall(2)
                        stack << [top[0], top[1]+1]
                        grid[top[0]][top[1]+1].visited(2)
                    else
                        ns = [1,4]
                        randwall = ns[rand(2)]
                        if randwall == 1 then
                            if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(1)
                                stack << [top[0]-1, top[1]]
                                grid[top[0]-1][top[1]].visited(2)
                            else
                                if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(4)
                                    stack << [top[0], top[1]-1]
                                    grid[top[0]][top[1]-1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 4 then
                            if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                grid[top[0]][top[1]].deletewall(4)
                                stack << [top[0], top[1]-1]
                                grid[top[0]][top[1]-1].visited(2)
                            else
                                if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(1)
                                    stack << [top[0]-1, top[1]]
                                    grid[top[0]-1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 1 then
                    if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                        grid[top[0]][top[1]].deletewall(1)
                        stack << [top[0]-1, top[1]]
                    else
                        ns = [2,4]
                        randwall = ns[rand(2)]
                        if randwall == 2 then
                            if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                grid[top[0]][top[1]].deletewall(2)
                                stack << [top[0], top[1]+1]
                            else
                                if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(4)
                                    stack << [top[0], top[1]-1]
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 4 then
                            if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                                grid[top[0]][top[1]].deletewall(4)
                                stack << [top[0], top[1]-1]
                            else
                                if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(2)
                                    stack << [top[0], top[1]+1]
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 4 then

                    if top[1]-1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                        grid[top[0]][top[1]].deletewall(4)
                        stack << [top[0], top[1]-1]
                        grid[top[0]][top[1]-1].visited(2)
                    else
                        ns = [1,2]
                        randwall = ns[rand(2)]
                        if randwall == 1 then
                            if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(1)
                                stack << [top[0]-1, top[1]]
                                grid[top[0]-1][top[1]].visited(2)
                            else
                                if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(2)
                                    stack << [top[0], top[1]+1]
                                    grid[top[0]][top[1]+1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 2 then
                            if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                grid[top[0]][top[1]].deletewall(2)
                                stack << [top[0], top[1]+1]
                                grid[top[0]][top[1]+1].visited(2)
                            else
                                if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(1)
                                    stack << [top[0]-1, top[1]]
                                    grid[top[0]-1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end


            end
        end


        if randwall == 4 then
            if top[1] -1 > 0 and grid[top[0]][top[1]-1].status != 3 then
                grid[top[0]][top[1]].deletewall(4)
                stack << [top[0], top[1]-1]
                grid[top[0]][top[1]-1].visited(2)
            else 
                while randwall == 4
                    randwall = rand(4) +1
                end

                if randwall == 2 then
                    if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                        grid[top[0]][top[1]].deletewall(2)
                        stack << [top[0], top[1]+1]
                        grid[top[0]][top[1]+1].visited(2)

                    else
                        ns = [3,1]
                        randwall = ns[rand(2)]
                        if randwall == 3 then
                            if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(3)
                                stack << [top[0]+1, top[1]]
                                grid[top[0]+1][top[1]].visited(2)
                            else
                                if top[0]-1 >= 0 and grid[top[0]-1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(1)
                                    stack << [top[0]-1, top[1]]
                                    grid[top[0]-1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 1 then
                            if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(1)
                                stack << [top[0]-1, top[1]]
                                grid[top[0]-1][top[1]].visited(2)
                            else
                                if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(3)
                                    stack << [top[0]+1, top[1]]
                                    grid[top[0]+1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 3 then
                    if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                        grid[top[0]][top[1]].deletewall(3)
                        stack << [top[0]+1, top[1]]
                        grid[top[0]+1][top[1]].visited(2)
                    else
                        ns = [2,1]
                        randwall = ns[rand(2)]
                        if randwall == 2 then
                            if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                grid[top[0]][top[1]].deletewall(2)
                                stack << [top[0], top[1]+1]
                                grid[top[0]][top[1]+1].visited(2)
                            else
                                if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(1)
                                    stack << [top[0]-1, top[1]]
                                    grid[top[0]-1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 1 then
                            if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(1)
                                stack << [top[0]-1, top[1]]
                                grid[top[0]-1][top[1]].visited(2)
                            else
                                if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(2)
                                    stack << [top[0], top[1]+1]
                                    grid[top[0]][top[1]+1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end



                if randwall == 1 then
                    if top[0]-1 > 0 and grid[top[0]-1][top[1]].status != 3 then
                        grid[top[0]][top[1]].deletewall(1)
                        stack << [top[0]-1, top[1]]
                        grid[top[0]-1][top[1]].visited(2)
                    else
                        ns = [3,2]
                        randwall = ns[rand(2)]
                        if randwall == 3 then
                            if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                grid[top[0]][top[1]].deletewall(3)
                                stack << [top[0]+1, top[1]]
                                grid[top[0]+1][top[1]].visited(2)
                            else
                                if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                    grid[top[0]][top[1]].deletewall(2)
                                    stack << [top[0], top[1]+1]
                                    grid[top[0]][top[1]+1].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                        if randwall == 2 then
                            if top[1]+1 < COLUMNS-1 and grid[top[0]][top[1]+1].status != 3 then
                                grid[top[0]][top[1]].deletewall(2)
                                stack << [top[0], top[1]+1]
                                grid[top[0]][top[1]+1].visited(2)
                            else
                                if top[0]+1 < ROWS-1 and grid[top[0]+1][top[1]].status != 3 then
                                    grid[top[0]][top[1]].deletewall(3)
                                    stack << [top[0]+1, top[1]]
                                    grid[top[0]+1][top[1]].visited(2)
                                else
                                    stack.pop
                                end
                            end
                        end

                    end


                end


            end
        end

        grid[top[0]][top[1]].visited(3)
        grid[top[0]][top[1]].center.size += 1


        if stack.length == 0 then 
            genlab = 0
        end

    end#genlab


    if genlab == 0 then

        if i < ROWS and j < COLUMNS then 
        
            if rand(2) != 0 then
                if i == 0 and j == 0 then
                    grid[i][j].deletewall(3)
                elsif i == 0 and j != 0 and j < COLUMNS-1 then
                    rw = rand(3)+1
                    wr = %w{2 1 3}
                    grid[i][j].deletewall(wr[rand(3)])
                elsif i == 0 and j != 0 and j == COLUMNS-1 then
                    wr = %w{1 2}    
                    grid[i][j].deletewall(wr[rand(3)])             
                elsif i == ROWS-1 and j == 0 then
                    wr = %w{2 1}
                    grid[i][j].deletewall(wr[rand(2)])
                elsif i == ROWS-1 and j != 0 and j < COLUMNS-1 then
                    wr = %w{2 1 4}    
                    grid[i][j].deletewall(wr[rand(3)])
                    
                elsif i == ROWS-1 and j != 0 and j == COLUMNS-1 then
                    wr = %w{4 1}
                    grid[i][j].deletewall(wr[rand(2)])
                else
                    wr = %w{1 2 3 4}    
                    grid[i][j].deletewall(wr[rand(4)])
                end

            end

        end

        j += 1

        if j== COLUMNS and i < ROWS-1 then 
            j = 0
            i += 1
        end

        

        
        
    end

end


on :key do
    i = 0
    j = 0
    update do
        if i < ROWS and j < COLUMNS then
            grid[i][j].restart 
        end

        j += 1

        if j== COLUMNS and i < ROWS-1 then 
            j = 0
            i += 1
        end
    end
end



=begin
update do
    
    if rs < ROWS and cl < COLUMNS then
        
        grid[rs][cl].deletewall(rand(3) +1)
        grid[rs][cl].mark(3)
    end
    cl += 1
    if cl == COLUMNS and rs < ROWS-1 then 
        cl = 0;
        rs += 1;
    end
=end

show