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
    attr_reader :w1, :w2,:w3,:w4, :relleno


    attr_reader :father , :distance , :explored
    
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
            color: color, z: 10 # width: 4,
        )
        @w1 = true
        #Pared derecha
        @wall2 = Line.new(
            x1: x+20 , y1:y-8,
            x2: x+20 , y2:y+8,
            color: color, z: 10   #width: 4,
        )
        @w2 = true
        #Pared inferior
        @wall3 = Line.new(
            x1: x-10 , y1:y+10,
            x2: x+20 , y2:y+10,
            color: color,z: 10 # width: 4, 
        )
        @w3 = true
        #Pared izquierda
        @wall4 = Line.new(
            x1: x-10 , y1:y-8,
            x2: x-10 , y2:y+8,
            color: color,z: 10 # width: 4, 
        )
        @w4 = true
        #centro(relativamete :v)
        @center = Square.new(
            x: x , y: y, 
            color: 'blue' , size: size, 
            z: 5
        )

        @relleno = Quad.new(
            x1: self.wall1.x2, y1: self.wall1.y1,
            x2: self.wall1.x1, y2: self.wall1.y1,
            x3:  self.wall3.x1, y3: self.wall3.y1,
            x4: self.wall3.x2, y4: self.wall3.y1,
            color: 'black', opacity: 1.0, z: 15
        )

        @visited = 1 #Para generar laberitos
        @father = nil
        @distance = Float::INFINITY
        @explored = 1 #Para explorar los nodos
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


    def in_node(x,y)
        if x >= self.wall1.x1 and x <= self.wall1.x2 and y >= self.wall1.y1 and y <= self.wall3.y1
            true
        else
            false
        end
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
        self.relleno.opacity = 0.0
    end

    def w1 
        return @w1
    end
    def w2 
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


    def explored(x)
        @explored = x
    end


    def stat
        @explored        
    end


    def father=(f)
        @father = f
    end

    def distance=(d)
        @distance = d
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
        @center.color = 'blue'
        @visited = 1
        @center.size = 1
        @father = nil
        @distance = Float::INFINITY
        @explored = 1
        @relleno.opacity = 1.0
        @relleno.color = 'black'
    end


    def res_s
        @center.color = 'blue'
        @visited = 1
        @center.size = 1
        @father = nil
        @distance = Float::INFINITY
        @explored = 1
        if @relleno.opacity != 1.0
            @relleno.opacity = 0.0 
        end
    end

    def show_node
        @wall1
        @wall3
        @wall2
        @center
    end



end


class Tablero
    attr_reader :status, :nodesE, :gridsz, :gen_alg
    attr_reader :wl1,:wl3,:wl2,:wl4,:wl5,:wl6, :wl7
    attr_reader :wl8, :wl9, :wl10
    attr_reader :solvedS, :startxt, :startV, :endtxt, :endV
    attr_reader :lk1, :lk2

    def initialize(rows , coloums)
        @wl1 = Line.new(
            x1: 950, y1: 90,
            x2: 1250 , y2: 90,
            color:'black', z: 10
        )
        @wl2 = Line.new(
            x1: 950, y1: 90,
            x2: 950 , y2: 600,
            color:'black', z: 10
        )

        @wl3 = Line.new(
            x1: 950, y1: 600,
            x2: 1250 , y2: 600,
            color:'black', z: 10
        )

        @wl4 = Line.new(
            x1: 1250, y1: 90,
            x2: 1250 , y2: 600,
            color:'black', z: 10
        )

        @wl5 = Line.new(
            x1: 950, y1: 150,
            x2: 1250 , y2: 150,
            color:'black', z: 10
        )
        @wl6 = Line.new(
            x1: 1100, y1: 90,
            x2: 1100 , y2: 150,
            color:'black', z: 10
        )
        @wl7 = Line.new(
            x1: 950, y1: 120,
            x2: 1250 , y2: 120,
            color:'black', z: 10
        )

        @wl8 = Line.new(
            x1: 950, y1: 200,
            x2: 1250, y2: 200,
            color: 'black', z: 10
        )

        @wl9 = Line.new(
            x1: 950, y1: 175,
            x2: 1250, y2: 175,
            color: 'black', z: 10
        )

        @wl10 = Line.new(
            x1: 1100, y1: 150,
            x2: 1100, y2: 200, 
            color: 'black', z: 10
        )


        @gridsz = Text.new(
            'Grid size: ' + (rows.to_s + 'x' + coloums.to_s) , x: 960,
            y: 100, size:15, 
            color: 'black', z: 10
        )

        @status = Text.new(
            '---' , x: 960,
            y: 125, size:15, 
            color: 'black', z: 10
        )

        @solvedS = Text.new(
            '----', x:1110,
            y: 125 ,size: 15 , z: 10,
            color: 'black'
        )


        @startxt = Text.new(
            'START', x: 960,
            y: 155 ,size: 15 , z: 10,
            color: 'black'
        )

        @startV = Text.new(
            '0,0', x:1110,
            y: 155 ,size: 15 , z: 10,
            color: 'black'
        )
        @lk1 = false

        @endtxt = Text.new(
            'END', x:960,
            y: 180 ,size: 15 , z: 10,
            color: 'black'
        )

        @endV = Text.new(
            '0,0', x:1110,
            y: 180 ,size: 15 , z: 10,
            color: 'black'
        )
        @lk2 = false


        @gen_alg =  Text.new(
            'Generation Algorithm: ' , x: 1102,
            y: 100, size:10, 
            color: 'black', z: 10
        )

    end


    def start_value
        s = []
        st = ''
        for c in 0...self.startV.text.length do
            if self.startV.text[c] != ',' and  self.startV.text[c].respond_to?('to_i') 
                st +=  self.startV.text[c]
            else
                s.append st.to_i
                st = ''
            end
        end
        s.append st.to_i

        return s
    end

    def end_value
        s = []
        st = ''
        for c in 0...self.endV.text.length do
            if self.endV.text[c] != ',' and  self.endV.text[c].respond_to?('to_i') 
                st +=  self.endV.text[c]
            else
                s.append st.to_i
                st = ''
            end
        end
        s.append st.to_i

        return s
    end


    def status=(x)
    end

    def lk1=(x)
        @lk1 = x
    end
    def lk2=(x)
        @lk2 = x
    end
end








#a = Node.new(60,30,1,'black')
=begin
    Dibujamos un tablero de n * n y almacenamos los nodos en un arreglo bidimensional
    llamado grid.
    Podemos modificar el tamaño del tablero modificando las variables ROWS y COLUMNS. 
=end 


#El tamaño maximo del filas y columnas es  <= 30
ROWS = 30
COLUMNS = 30
tab = Tablero.new(ROWS,COLUMNS)
grid = []

xstep = 30
ystep = 30
#Creamos un array bidimensional de nodos que funcionara como tablero para los laberintos
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

#Algunos bloques de codigo para funciones relacionadas con saber la posicion del mouse sobre un objeto 
#Determina si el mouse se encuentra en el recuadro de start
in_starttxt = lambda do |x,y|
    if x >= 1100 and x <= 1250 and y >= 150 and y <= 175
        true
    else
        false
    end
end
#Determina si el mouse se encuentra en el recuadro de end
in_endtxt = lambda do |x,y|
    if x >= 1100 and x <= 1250 and y > 175 and y <= 200
        true
    else
        false
    end
end

#Determina si el mouse se encuentra en el grid y retorna el index del nodo de lo contrario retorna nil
def is_in_grid (x,y,grid)
    for i in 0...ROWS do
        for j in 0...COLUMNS do
            if grid[i][j].in_node(x,y)
                return [i,j]
            end
        end
    end
    return nil
end


rs = 0
cl = 0
i = 0
j = 0

stack = []

#genlab = 1

#stack << [0,0]
=begin
    Generamos un laberinto de  manera  aleatoria  tomando  como punto de  partida el  espacio [0,0]
    posteriormente con introducimos  dicho elemento a una pila (Stack) y con ayuda del  update loop
    de ruby2d comenzamos seleccionando una pared al azar posteriomente la eliminamos(Si es posible)
    y avanzamos a la casilla contigua a la pared que hallamos eliminado insertando  la posicion  de
    dicha casilla en la  pila y marcamos la celda con un numero  2 (en exploracion)  repetimos este 
    proceso hasta que no podamos escoger ninguna de las 4 paredes,entoces hacemos pop a la pila que 
    ha estado almacenando las posiciones hasta encontrar alguna en la que se pueda eliminar alguna 
    de las 4 paredes. Este proceso termina cuando la pila se queda vacia.
=end

rest = 0

start = [0,0]
end_path = [29, 29]

tab.startV.text = tab.start_value

tab.endV.text = tab.end_value

#debug = Text.new(
#    'Current Queue : ',x: 50,
#    y: 700, size: 10, color: 'black',
#    z: 10 
#)

#Determina si la tecla presionada es un numero
def is_keypad(s)
    case s
    when 'keypad 0'
        0
    when 'keypad 1'
        1
    when 'keypad 2'
        2
    when 'keypad 3'
        3
    when 'keypad 4'
        4
    when 'keypad 5'
        5
    when 'keypad 6'
        6
    when 'keypad 7'
        7
    when 'keypad 8'
        8
    when 'keypad 9'
        9
    when '1'
        1
    when '2'
        2
    when '3'
        3
    when '4'
        4
    when '5'
        5
    when '6'
        6
    when '7'
        7
    when '8'
        8
    when '9'
        9
    when '0'
        0
    else
        -1
    end
end


#Eventos en caso de que alguno de los botones del mouse sea presionado
on :mouse_down do |event|

    case event.button
    when :left
        if in_starttxt.call event.x , event.y then
            tab.lk1 = true
            tab.lk2 = false
            tab.startV.text = '[]'
        end

        if in_endtxt.call event.x,event.y then
            tab.lk2 = true
            tab.lk1 = false
            tab.endV.text = '[]'
        end


        if is_in_grid(event.x, event.y,grid)  != nil then
            if tab.lk1 then
                a = is_in_grid(event.x, event.y,grid)
                tab.startV.text = a[0].to_s+','+a[1].to_s 
            end 
            
            if tab.lk2 then
                a = is_in_grid(event.x, event.y,grid)
                tab.endV.text = a[0].to_s+','+a[1].to_s
            end
        end
    else
    end
end


#Eventos en caso de que se presione alguna tecla
on :key_down do |event|


    if (is_keypad(event.key) != -1 or event.key == ',' or event.key == '[' or event.key == ']') and event.key != 'backspace'
        if is_keypad(event.key) != -1 
            x = is_keypad(event.key)
        else
            x = event.key
        end
        if tab.startV.text == '[]'
            tab.startV.text = ''
        end
        if tab.endV.text == '[]'
            tab.endV.text = ''
        end
        if tab.lk1 then
            
            tab.startV.text += x.to_s
        end

        if tab.lk2 then
            
            tab.endV.text  += x.to_s      
        end
    end


    if event.key == 'backspace'
        if tab.lk1 then
            tab.startV.text = tab.startV.text.chop 
        end
        if tab.lk2 then
            tab.endV.text = tab.endV.text.chop 
        end


    end
    
    if rest >= 4 
        rest = 0
    end
    if event.key == 'r' then
        tab.solvedS.text = '---'
        tab.solvedS.color = 'black'
        tab.status.text = 'Reseting Grid'
        tab.status.color = 'red'
        tab.status.size = 5
        i = 0
        j = 0
        update do

            if grid[0][j] != nil
                grid[0][j].restart 
            end

            if grid[1][j] != nil
                grid[1][j].restart 
            end

            if grid[2][j] != nil
                grid[2][j].restart 
            end

            if grid[3][j] != nil
                grid[3][j].restart 
            end

            if grid[4][j] != nil
                grid[4][j].restart 
            end

            if grid[5][j] != nil
                grid[5][j].restart 
            end

            if grid[6][j] != nil
                grid[6][j].restart 
            end

            if grid[7][j] != nil
                grid[7][j].restart 
            end

            if grid[8][j] != nil
                grid[8][j].restart 
            end

            if grid[9][j] != nil
                grid[9][j].restart 
            end

            if grid[10][j] != nil
                grid[10][j].restart 
            end

            if grid[11][j] != nil
                grid[11][j].restart 
            end

            if grid[12][j] != nil
                grid[12][j].restart 
            end

            if grid[13][j] != nil
                grid[13][j].restart 
            end

            if grid[14][j] != nil
                grid[14][j].restart 
            end

            if grid[15][j] != nil
                grid[15][j].restart 
            end

            if grid[16][j] != nil
                grid[16][j].restart 
            end

            if grid[17][j] != nil
                grid[17][j].restart 
            end

            if grid[18][j] != nil
                grid[18][j].restart 
            end

            if grid[19][j] != nil
                grid[19][j].restart 
            end

            if grid[20][j] != nil
                grid[20][j].restart 
            end

            if grid[21][j] != nil
                grid[21][j].restart 
            end

            if grid[22][j] != nil
                grid[22][j].restart 
            end

            if grid[23][j] != nil
                grid[23][j].restart 
            end

            if grid[24][j] != nil
                grid[24][j].restart 
            end

            if grid[25][j] != nil
                grid[25][j].restart 
            end

            if grid[26][j] != nil
                grid[26][j].restart 
            end

            if grid[27][j] != nil
                grid[27][j].restart 
            end

            if grid[28][j] != nil
                grid[28][j].restart 
            end

            if grid[29][j] != nil
                grid[29][j].restart 
            end

            j+= 1

            if j >= COLUMNS-1 then
                tab.status.text = 'Grid reset'
                tab.status.color = 'orange'
            end
        end

        
    end


    if event.key == 't' then
        tab.solvedS.text = '---'
        tab.solvedS.color = 'black'
        tab.status.text = 'Reseting maze'
        tab.status.color = 'red'
        tab.status.size = 5
        i = 0
        j = 0
        update do

            if grid[0][j] != nil
                grid[0][j].res_s 
            end

            if grid[1][j] != nil
                grid[1][j].res_s 
            end

            if grid[2][j] != nil
                grid[2][j].res_s 
            end

            if grid[3][j] != nil
                grid[3][j].res_s 
            end

            if grid[4][j] != nil
                grid[4][j].res_s 
            end

            if grid[5][j] != nil
                grid[5][j].res_s 
            end

            if grid[6][j] != nil
                grid[6][j].res_s 
            end

            if grid[7][j] != nil
                grid[7][j].res_s 
            end

            if grid[8][j] != nil
                grid[8][j].res_s 
            end

            if grid[9][j] != nil
                grid[9][j].res_s 
            end

            if grid[10][j] != nil
                grid[10][j].res_s 
            end

            if grid[11][j] != nil
                grid[11][j].res_s 
            end

            if grid[12][j] != nil
                grid[12][j].res_s 
            end

            if grid[13][j] != nil
                grid[13][j].res_s 
            end

            if grid[14][j] != nil
                grid[14][j].res_s 
            end

            if grid[15][j] != nil
                grid[15][j].res_s 
            end

            if grid[16][j] != nil
                grid[16][j].res_s 
            end

            if grid[17][j] != nil
                grid[17][j].res_s 
            end

            if grid[18][j] != nil
                grid[18][j].res_s 
            end

            if grid[19][j] != nil
                grid[19][j].res_s 
            end

            if grid[20][j] != nil
                grid[20][j].res_s 
            end

            if grid[21][j] != nil
                grid[21][j].res_s 
            end

            if grid[22][j] != nil
                grid[22][j].res_s 
            end

            if grid[23][j] != nil
                grid[23][j].res_s 
            end

            if grid[24][j] != nil
                grid[24][j].res_s 
            end

            if grid[25][j] != nil
                grid[25][j].res_s 
            end

            if grid[26][j] != nil
                grid[26][j].res_s 
            end

            if grid[27][j] != nil
                grid[27][j].res_s 
            end

            if grid[28][j] != nil
                grid[28][j].res_s 
            end

            if grid[29][j] != nil
                grid[29][j].res_s 
            end

            j+= 1

            if j >= COLUMNS-1 then
                tab.status.text = 'Maze reset'
                tab.status.color = 'orange'
            end
        end

        
    end

    if event.key == 'k'
        tab.gen_alg.text = 'Generation Algorithm: 1'
        tab.status.text = 'Generating Maze'
        tab.status.color = 'lime'
        genlab = 1
        stack = []
        stack << [0,0]


        update do
            #TE AMO LIZA FLORES <3 (si lees esto casate conmigo :3)
            if genlab == 1
                current = stack[-1]

                randw = rand(4)+1

                if randw == 1
                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1 then
                        grid[current[0]][current[1]].deletewall(1)
                        grid[current[0]-1][current[1]].deletewall(3)
                        grid[current[0]-1][current[1]].visited(2)
                        stack << [current[0]-1,current[1]]
                    else  
                        w = [2,3,4]
                        randw = w[rand(3)]
                    
                    
                        if randw == 2
                            if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1 then
                                grid[current[0]][current[1]].deletewall(2)
                                grid[current[0]][current[1]+1].deletewall(4)
                                grid[current[0]][current[1]+1].visited(2)
                                stack << [current[0],current[1]+1]
                            else
                                w = [3,4]
                                randw = w[rand(2)]
                                if randw == 3
                                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1 then
                                        grid[current[0]][current[1]].deletewall(3)
                                        grid[current[0]+1][current[1]].deletewall(1)
                                        grid[current[0]+1][current[1]].visited(2)
                                        stack << [current[0]+1, current[1]]
                                    else
                                        if current[1] != 0 and grid[current[0]][current[1]-1].status == 1 then
                                            grid[current[0]][current[1]].deletewall(4)
                                            grid[current[0]][current[1]-1].deletewall(2)
                                            grid[current[0]][current[1]-1].visited(2)
                                            stack << [current[0], current[1]-1]
                                        else
                                            stack.pop
                                        end
                                    end

                                else
                                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1 then
                                        grid[current[0]][current[1]].deletewall(4)
                                        grid[current[0]][current[1]-1].deletewall(2)
                                        grid[current[0]][current[1]-1].visited(2)
                                        stack << [current[0], current[1]-1]
                                    else
                                        if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1 then
                                            grid[current[0]][current[1]].deletewall(3)
                                            grid[current[0]+1][current[1]].deletewall(1)
                                            grid[current[0]+1][current[1]].visited(2)
                                            stack << [current[0]+1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                
                                end

                            
                            end 
                        end


                        if randw == 3
                            if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1 then
                                grid[current[0]][current[1]].deletewall(3)
                                grid[current[0]+1][current[1]].deletewall(1)
                                grid[current[0]+1][current[1]].visited(2)
                                stack << [current[0]+1,current[1]]
                            else
                                w = [2,4]
                                randw = w[rand(2)]
                                if randw == 2
                                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1 then
                                        grid[current[0]][current[1]].deletewall(2)
                                        grid[current[0]][current[1]+1].deletewall(4)
                                        grid[current[0]][current[1]+1].visited(2)
                                        stack << [current[0], current[1]+1]
                                    else
                                        if current[1] != 0 and grid[current[0]][current[1]-1].status == 1 then
                                            grid[current[0]][current[1]].deletewall(4)
                                            grid[current[0]][current[1]-1].deletewall(2)
                                            grid[current[0]][current[1]-1].visited(2)
                                            stack << [current[0], current[1]-1]
                                        else
                                            stack.pop
                                        end
                                    end

                                else
                                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1 then
                                        grid[current[0]][current[1]].deletewall(4)
                                        grid[current[0]][current[1]-1].deletewall(2)
                                        grid[current[0]][current[1]-1].visited(2)
                                        stack << [current[0], current[1]-1]
                                    else
                                        if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1 then
                                            grid[current[0]][current[1]].deletewall(2)
                                            grid[current[0]][current[1]+1].deletewall(4)
                                            grid[current[0]][current[1]+1].visited(2)
                                            stack << [current[0], current[1]+1]
                                        else
                                            stack.pop
                                        end
                                    end
                                
                                end



                            
                            end 
                        end


                        if randw == 4
                            if current[1] != 0 and grid[current[0]][current[1]-1].status == 1 then
                                grid[current[0]][current[1]].deletewall(4)
                                grid[current[0]][current[1]-1].deletewall(2)
                                grid[current[0]][current[1]-1].visited(2)
                                stack << [current[0],current[1]-1]
                            else
                                w = [3,2]
                                randw = w[rand(2)]
                                if randw == 3
                                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1 then
                                        grid[current[0]][current[1]].deletewall(3)
                                        grid[current[0]+1][current[1]].deletewall(1)
                                        grid[current[0]+1][current[1]].visited(2)
                                        stack << [current[0]+1, current[1]]
                                    else
                                        if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1 then
                                            grid[current[0]][current[1]].deletewall(2)
                                            grid[current[0]][current[1]+1].deletewall(4)
                                            grid[current[0]][current[1]+1].visited(2)
                                            stack << [current[0], current[1]+1]
                                        else
                                            stack.pop
                                        end
                                    end

                                else
                                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1 then
                                        grid[current[0]][current[1]].deletewall(2)
                                        grid[current[0]][current[1]+1].deletewall(4)
                                        grid[current[0]][current[1]+1].visited(2)
                                        stack << [current[0], current[1]+1]
                                    else
                                        if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1 then
                                            grid[current[0]][current[1]].deletewall(3)
                                            grid[current[0]+1][current[1]].deletewall(1)
                                            grid[current[0]+1][current[1]].visited(2)
                                            stack << [current[0]+1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                
                                end
                            end 
                        end
                    end

                end
                
                if randw == 2
                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                        grid[current[0]][current[1]].deletewall(2)
                        grid[current[0]][current[1]+1].deletewall(4)
                        grid[current[0]][current[1]+1].visited(2)
                        stack << [current[0], current[1]+1]
                    else
                        w = [1,3,4]
                        randw = w[rand(3)]
                        if randw == 1
                            if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                grid[current[0]][current[1]].deletewall(1)
                                grid[current[0]-1][current[1]].deletewall(3)
                                grid[current[0]-1][current[1]].visited(2)
                                stack << [current[0]-1, current[1]]
                            else
                                w = [3,4]
                                randw = w[rand(2)]
                                if randw == 3
                                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(3)
                                        grid[current[0]+1][current[1]].deletewall(1)
                                        grid[current[0]+1][current[1]].visited(2)
                                        stack << [current[0]+1,current[1]]
                                    else
                                        if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                            grid[current[0]][current[1]].deletewall(4)
                                            grid[current[0]][current[1]-1].deletewall(2)
                                            grid[current[0]][current[1]-1].visited(2)
                                            stack << [current[0], current[1]-1]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                        grid[current[0]][current[1]].deletewall(4)
                                        grid[current[0]][current[1]-1].deletewall(2)
                                        grid[current[0]][current[1]-1].visited(2)
                                        stack << [current[0],current[1]-1]
                                    else
                                        if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(3)
                                            grid[current[0]+1][current[1]].deletewall(1)
                                            grid[current[0]+1][current[1]].visited(2)
                                            stack << [current[0]+1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                                
                            end
                        end

                        if randw == 3
                            if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                grid[current[0]][current[1]].deletewall(3)
                                grid[current[0]+1][current[1]].deletewall(1)
                                grid[current[0]+1][current[1]].visited(2)
                                stack << [current[0]+1, current[1]]
                            else
                                w = [1,4]
                                randw = w[rand(2)]
                                if randw == 1
                                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(1)
                                        grid[current[0]-1][current[1]].deletewall(3)
                                        grid[current[0]-1][current[1]].visited(2)
                                        stack << [current[0]-1,current[1]]
                                    else
                                        if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                            grid[current[0]][current[1]].deletewall(4)
                                            grid[current[0]][current[1]-1].deletewall(2)
                                            grid[current[0]][current[1]-1].visited(2)
                                            stack << [current[0], current[1]-1]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                        grid[current[0]][current[1]].deletewall(4)
                                        grid[current[0]][current[1]-1].deletewall(2)
                                        grid[current[0]][current[1]-1].visited(2)
                                        stack << [current[0],current[1]-1]
                                    else
                                        if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(1)
                                            grid[current[0]-1][current[1]].deletewall(3)
                                            grid[current[0]-1][current[1]].visited(2)
                                            stack << [current[0]-1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                                
                            end
                        end

                        if randw == 4
                            if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                grid[current[0]][current[1]].deletewall(4)
                                grid[current[0]][current[1]-1].deletewall(2)
                                grid[current[0]][current[1]-1].visited(2)
                                stack << [current[0], current[1]-1]
                            else
                                w = [3,1]
                                randw = w[rand(2)]
                                if randw == 3
                                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(3)
                                        grid[current[0]+1][current[1]].deletewall(1)
                                        grid[current[0]+1][current[1]].visited(2)
                                        stack << [current[0]+1,current[1]]
                                    else
                                        if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(1)
                                            grid[current[0]-1][current[1]].deletewall(3)
                                            grid[current[0]-1][current[1]].visited(2)
                                            stack << [current[0]-1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(1)
                                        grid[current[0]-1][current[1]].deletewall(3)
                                        grid[current[0]-1][current[1]].visited(2)
                                        stack << [current[0]-1,current[1]]
                                    else
                                        if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(3)
                                            grid[current[0]+1][current[1]].deletewall(1)
                                            grid[current[0]+1][current[1]].visited(2)
                                            stack << [current[0]+1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                                
                            end
                        end

                    end
                end

                if randw == 3
                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                        grid[current[0]][current[1]].deletewall(3)
                        grid[current[0]+1][current[1]].deletewall(1)
                        grid[current[0]+1][current[1]].visited(2)
                        stack << [current[0]+1, current[1]]
                    else
                        w = [1,2,4]
                        randw = w[rand(3)]

                        if randw == 1
                            if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                grid[current[0]][current[1]].deletewall(1)
                                grid[current[0]-1][current[1]].deletewall(3)
                                grid[current[0]-1][current[1]].visited(2)
                                stack << [current[0]-1, current[1]]
                            else
                                w = [2,4]
                                randw = w[rand(2)]

                                if randw == 2
                                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                        grid[current[0]][current[1]].deletewall(2)
                                        grid[current[0]][current[1]+1].deletewall(4)
                                        grid[current[0]][current[1]+1].visited(2)
                                        stack << [current[0],current[1]+1]
                                    else
                                        if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                            grid[current[0]][current[1]].deletewall(4)
                                            grid[current[0]][current[1]-1].deletewall(2)
                                            grid[current[0]][current[1]-1].visited(2)
                                            stack << [current[0], current[1]-1]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                        grid[current[0]][current[1]].deletewall(4)
                                        grid[current[0]][current[1]-1].deletewall(2)
                                        grid[current[0]][current[1]-1].visited(2)
                                        stack << [current[0],current[1]-1]
                                    else
                                        if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                            grid[current[0]][current[1]].deletewall(2)
                                            grid[current[0]][current[1]+1].deletewall(4)
                                            grid[current[0]][current[1]+1].visited(2)
                                            stack << [current[0], current[1]+1]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                            end
                        end

                        if randw == 2
                            if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                grid[current[0]][current[1]].deletewall(2)
                                grid[current[0]][current[1]+1].deletewall(4)
                                grid[current[0]][current[1]+1].visited(2)
                                stack << [current[0], current[1]+1]
                            else
                                w = [1,4]
                                randw = w[rand(2)]

                                if randw == 1
                                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(1)
                                        grid[current[0]-1][current[1]].deletewall(3)
                                        grid[current[0]-1][current[1]].visited(2)
                                        stack << [current[0]-1,current[1]]
                                    else
                                        if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                            grid[current[0]][current[1]].deletewall(4)
                                            grid[current[0]][current[1]-1].deletewall(2)
                                            grid[current[0]][current[1]-1].visited(2)
                                            stack << [current[0], current[1]-1]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                        grid[current[0]][current[1]].deletewall(4)
                                        grid[current[0]][current[1]-1].deletewall(2)
                                        grid[current[0]][current[1]-1].visited(2)
                                        stack << [current[0],current[1]-1]
                                    else
                                        if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(1)
                                            grid[current[0]-1][current[1]].deletewall(3)
                                            grid[current[0]-1][current[1]].visited(2)
                                            stack << [current[0]-1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                            end
                        end

                        if randw == 4
                            if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                                grid[current[0]][current[1]].deletewall(4)
                                grid[current[0]][current[1]-1].deletewall(2)
                                grid[current[0]][current[1]-1].visited(2)
                                stack << [current[0], current[1]-1]
                            else
                                w = [2,1]
                                randw = w[rand(2)]

                                if randw == 2
                                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                        grid[current[0]][current[1]].deletewall(2)
                                        grid[current[0]][current[1]+1].deletewall(4)
                                        grid[current[0]][current[1]+1].visited(2)
                                        stack << [current[0],current[1]+1]
                                    else
                                        if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(1)
                                            grid[current[0]-1][current[1]].deletewall(3)
                                            grid[current[0]-1][current[1]].visited(2)
                                            stack << [current[0]-1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(1)
                                        grid[current[0]-1][current[1]].deletewall(3)
                                        grid[current[0]-1][current[1]].visited(2)
                                        stack << [current[0]-1,current[1]]
                                    else
                                        if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                            grid[current[0]][current[1]].deletewall(2)
                                            grid[current[0]][current[1]+1].deletewall(4)
                                            grid[current[0]][current[1]+1].visited(2)
                                            stack << [current[0], current[1]+1]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                            end
                        end

                    end
                end

                if randw == 4
                    if current[1] != 0 and grid[current[0]][current[1]-1].status == 1
                        grid[current[0]][current[1]].deletewall(4)
                        grid[current[0]][current[1]-1].deletewall(2)
                        grid[current[0]][current[1]-1].visited(2)
                        stack << [current[0],current[1]-1]
                    else
                        w = [1,2,3]
                        randw = w[rand(3)]

                        if randw == 1
                            if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                grid[current[0]][current[1]].deletewall(1)
                                grid[current[0]-1][current[1]].deletewall(3)
                                grid[current[0]-1][current[1]].visited(2)
                                stack << [current[0]-1, current[1]]
                            else
                                w = [2,3]
                                randw = w[rand(2)]

                                if randw == 2
                                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                        grid[current[0]][current[1]].deletewall(2)
                                        grid[current[0]][current[1]+1].deletewall(4)
                                        grid[current[0]][current[1]+1].visited(2)
                                        stack << [current[0], current[1]+1]
                                    else
                                        if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(3)
                                            grid[current[0]+1][current[1]].deletewall(1)
                                            grid[current[0]+1][current[1]].visited(2)
                                            stack << [current[0]+1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(3)
                                        grid[current[0]+1][current[1]].deletewall(1)
                                        grid[current[0]+1][current[1]].visited(2)
                                        stack << [current[0]+1, current[1]]
                                    else
                                        if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                            grid[current[0]][current[1]].deletewall(2)
                                            grid[current[0]][current[1]+1].deletewall(4)
                                            grid[current[0]][current[1]+1].visited(2)
                                            stack << [current[0], current[1]+1]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                            end
                        end


                        if randw == 2
                            if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                grid[current[0]][current[1]].deletewall(2)
                                grid[current[0]][current[1]+1].deletewall(4)
                                grid[current[0]][current[1]+1].visited(2)
                                stack << [current[0], current[1]+1]
                            else
                                w = [1,3]
                                randw = w[rand(2)]

                                if randw == 1
                                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(1)
                                        grid[current[0]-1][current[1]].deletewall(3)
                                        grid[current[0]-1][current[1]].visited(2)
                                        stack << [current[0]-1, current[1]]
                                    else
                                        if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(3)
                                            grid[current[0]+1][current[1]].deletewall(1)
                                            grid[current[0]+1][current[1]].visited(2)
                                            stack << [current[0]+1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(3)
                                        grid[current[0]+1][current[1]].deletewall(1)
                                        grid[current[0]+1][current[1]].visited(2)
                                        stack << [current[0]+1, current[1]]
                                    else
                                        if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(1)
                                            grid[current[0]-1][current[1]].deletewall(3)
                                            grid[current[0]-1][current[1]].visited(2)
                                            stack << [current[0]-1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                            end
                        end

                        if randw == 3
                            if current[0] != ROWS-1 and grid[current[0]+1][current[1]].status
                                grid[current[0]][current[1]].deletewall(3)
                                grid[current[0]+1][current[1]].deletewall(1)
                                grid[current[0]+1][current[1]].visited(2)
                                stack << [current[0]+1, current[1]]
                            else
                                w = [2,1]
                                randw = w[rand(2)]

                                if randw == 2
                                    if current[1] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                        grid[current[0]][current[1]].deletewall(2)
                                        grid[current[0]][current[1]+1].deletewall(4)
                                        grid[current[0]][current[1]+1].visited(2)
                                        stack << [current[0], current[1]+1]
                                    else
                                        if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                            grid[current[0]][current[1]].deletewall(1)
                                            grid[current[0]-1][current[1]].deletewall(3)
                                            grid[current[0]-1][current[1]].visited(2)
                                            stack << [current[0]-1, current[1]]
                                        else
                                            stack.pop
                                        end
                                    end
                                else
                                    if current[0] != 0 and grid[current[0]-1][current[1]].status == 1
                                        grid[current[0]][current[1]].deletewall(1)
                                        grid[current[0]-1][current[1]].deletewall(3)
                                        grid[current[0]-1][current[1]].visited(2)
                                        stack << [current[0]-1, current[1]]
                                    else
                                        if current[0] != COLUMNS-1 and grid[current[0]][current[1]+1].status == 1
                                            grid[current[0]][current[1]].deletewall(2)
                                            grid[current[0]][current[1]+1].deletewall(4)
                                            grid[current[0]][current[1]+1].visited(2)
                                            stack << [current[0], current[1]+1]
                                        else
                                            stack.pop
                                        end
                                    end
                                end
                            end
                        end
                        
                    end
                end

                if stack.length == 0
                    genlab = 0
                end

            end
            
            if genlab == 0  
                tab.status.text = 'Maze Generated'
                tab.status.color = 'olive'
            end
        end



    end

    #Implemetacion de algoritmos para solucionar el laberinto

    #BFS
    if event.key == 'b'
        end_path = tab.end_value
        start = tab.start_value
        s = []
        grid[start[0]][start[1]].relleno.color = 'green'
        grid[start[0]][start[1]].relleno.opacity = 0.4
        grid[end_path[0]][end_path[1]].relleno.color = 'red'
        grid[end_path[0]][end_path[1]].relleno.opacity = 0.4

        s.unshift start

        grid[start[0]][start[1]].explored(2)
        grid[start[0]][start[1]].distance = 0

        e = false
        update do
            
            if e == false
                tab.solvedS.text = 'Solving'
                tab.solvedS.color = 'yellow'
                current = s.pop
                
                if current[0]-1 >= 0 and grid[current[0]-1][current[1]].stat == 1 and (grid[current[0]][current[1]].w1 == false and grid[current[0]-1][current[1]].w3 == false)
                    grid[current[0]-1][current[1]].father = current
                    grid[current[0]-1][current[1]].distance = grid[current[0]][current[1]].distance+1 
                    grid[current[0]-1][current[1]].explored(2)
                    
                    grid[current[0]-1][current[1]].relleno.color = 'yellow'
                    grid[current[0]-1][current[1]].relleno.opacity = 0.5
                    s.unshift [current[0]-1,current[1]]
                end

                if current[1]+1 < COLUMNS and grid[current[0]][current[1]+1].stat == 1 and (grid[current[0]][current[1]].w2 == false and grid[current[0]][current[1]+1].w4 == false)
                    grid[current[0]][current[1]+1].father = current
                    grid[current[0]][current[1]+1].distance = grid[current[0]][current[1]].distance+1
                    grid[current[0]][current[1]+1].explored(2)
                    

                    grid[current[0]][current[1]+1].relleno.color = 'yellow'
                    grid[current[0]][current[1]+1].relleno.opacity = 0.5
                    
                    s.unshift [current[0],current[1]+1]
                end


                if current[0]+1 < ROWS and grid[current[0]+1][current[1]].stat == 1  and (grid[current[0]][current[1]].w3 == false or grid[current[0]+1][current[1]].w1 == false)
                    grid[current[0]+1][current[1]].father = current
                    grid[current[0]+1][current[1]].distance = grid[current[0]][current[1]].distance+1
                    grid[current[0]+1][current[1]].explored(2)
                    
                    grid[current[0]+1][current[1]].relleno.color = 'yellow'
                    grid[current[0]+1][current[1]].relleno.opacity = 0.5
                    
                    s.unshift [current[0]+1,current[1]]
                end

                if current[1]-1 >= 0 and grid[current[0]][current[1]-1].stat == 1  and (grid[current[0]][current[1]].w4 == false or grid[current[0]][current[1]-1].w2 == false)
                    grid[current[0]][current[1]-1].father = current
                    grid[current[0]][current[1]-1].distance = grid[current[0]][current[1]].distance+1
                    grid[current[0]][current[1]-1].explored(2)
                
                    grid[current[0]][current[1]-1].relleno.color = 'yellow'
                    grid[current[0]][current[1]-1].relleno.opacity = 0.5

                    s.unshift [current[0],current[1]-1]
                end

                grid[current[0]][current[1]].explored(3)
                
                #sleep 0.1
                #debug.text  = s
                if (current[0] == end_path[0] and current[1] == end_path[1])
                    tab.solvedS.text = 'Solved'
                    tab.solvedS.color = 'olive'
                    e = true
                    s = []
                    #debug.text = s
                elsif s.length == 0
                    e = true
                    tab.solvedS.text = 'No Solution'
                    tab.solvedS.color = 'red'
                end 
            end


            if e == true 
                if end_path != nil and grid[end_path[0]][end_path[1]].stat == 3 and end_path != start
                    
                    grid[end_path[0]][end_path[1]].center.size = 5
                    grid[end_path[0]][end_path[1]].center.color = 'red'
                    grid[end_path[0]][end_path[1]].relleno.color = 'red'
                    grid[end_path[0]][end_path[1]].relleno.opacity = 0.0
                    end_path = grid[end_path[0]][end_path[1]].father
                end
                
            end
            
        end

        
    end



    if event.key == 'd'
        end_path = tab.end_value
        start = tab.start_value
        s = []
        grid[start[0]][start[1]].relleno.color = 'green'
        grid[start[0]][start[1]].relleno.opacity = 0.4
        grid[end_path[0]][end_path[1]].relleno.color = 'red'
        grid[end_path[0]][end_path[1]].relleno.opacity = 0.4

        s << start

        e = true
        update do
            if e 
                tab.solvedS.text = 'Solving'
                tab.solvedS.color = 'yellow'
                current = s.pop

                if current[0]-1 >= 0 and grid[current[0]-1][current[1]].stat == 1 and (grid[current[0]][current[1]].w1 == false and grid[current[0]-1][current[1]].w3 == false)
                    grid[current[0]-1][current[1]].father = current
                    grid[current[0]-1][current[1]].distance = grid[current[0]][current[1]].distance+1 
                    grid[current[0]-1][current[1]].explored(2)
                    
                    grid[current[0]-1][current[1]].relleno.color = 'yellow'
                    grid[current[0]-1][current[1]].relleno.opacity = 0.5
                    s <<  [current[0]-1,current[1]]
                end

                if current[1]+1 < COLUMNS and grid[current[0]][current[1]+1].stat == 1 and (grid[current[0]][current[1]].w2 == false and grid[current[0]][current[1]+1].w4 == false)
                    grid[current[0]][current[1]+1].father = current
                    grid[current[0]][current[1]+1].distance = grid[current[0]][current[1]].distance+1
                    grid[current[0]][current[1]+1].explored(2)
                    grid[current[0]][current[1]+1].relleno.color = 'yellow'
                    grid[current[0]][current[1]+1].relleno.opacity = 0.5
                    
                    s <<  [current[0],current[1]+1]
                end


                if current[0]+1 < ROWS and grid[current[0]+1][current[1]].stat == 1  and (grid[current[0]][current[1]].w3 == false or grid[current[0]+1][current[1]].w1 == false)
                    grid[current[0]+1][current[1]].father = current
                    grid[current[0]+1][current[1]].distance = grid[current[0]][current[1]].distance+1
                    grid[current[0]+1][current[1]].explored(2)
                    
                    grid[current[0]+1][current[1]].relleno.color = 'yellow'
                    grid[current[0]+1][current[1]].relleno.opacity = 0.5
                    
                    s << [current[0]+1,current[1]]
                end

                if current[1]-1 >= 0 and grid[current[0]][current[1]-1].stat == 1  and (grid[current[0]][current[1]].w4 == false or grid[current[0]][current[1]-1].w2 == false)
                    grid[current[0]][current[1]-1].father = current
                    grid[current[0]][current[1]-1].distance = grid[current[0]][current[1]].distance+1
                    grid[current[0]][current[1]-1].explored(2)
                
                    grid[current[0]][current[1]-1].relleno.color = 'yellow'
                    grid[current[0]][current[1]-1].relleno.opacity = 0.5

                    s <<  [current[0],current[1]-1]
                end

                grid[current[0]][current[1]].explored(3)
                
                #sleep 0.1
                #debug.text  = s
                if (current[0] == end_path[0] and current[1] == end_path[1])
                    tab.solvedS.text = 'Solved'
                    tab.solvedS.color = 'olive'
                    e = false
                    s = []
                    #debug.text = s
                elsif s.length == 0
                    e = false
                    tab.solvedS.text = 'No Solution'
                    tab.solvedS.color = 'red'
                end 

            end


            if e == false 
                if end_path != nil and grid[end_path[0]][end_path[1]].stat == 3 and end_path != start
                    
                    grid[end_path[0]][end_path[1]].center.size = 5
                    grid[end_path[0]][end_path[1]].center.color = 'red'
                    grid[end_path[0]][end_path[1]].relleno.color = 'red'
                    grid[end_path[0]][end_path[1]].relleno.opacity = 0.0
                    end_path = grid[end_path[0]][end_path[1]].father
                end
                
            end
        end
    end 

    rest += 1 

end





show