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


=begin
La clase nodo nos ayuda a dibujar las celdas ademas de que nos ayuda 
a poder generar los laberintos de forma procedural.

La clase se inicializa con la posicion(x,y) donde ubicaremos el centro de la celda 
de la cual a partiran nuestras cuatro paredes. las cuales seran Objetos de la clase 
Line de ruby2d.

Adicionalmente podemos asignarle una etiqueta a cada nodo para identificarlo este 
parametro es completamente opcional.

=end
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


    def markexplored(n)
        @visited = n
    end

    def show_node
        @wall1
        @wall3
        @wall2
        @center
    end

end

=begin

=end

class Grid
    attr_reader :rowsz, :colsz 
    @@matrix = []
    

    def initialize(rows, colums)
        x = 30
        y = 30

        @rowsz = rows
        @colsz = colums
        
        for i in 0...rows do
            r = []
            xaux = x
            for j in 0...colums do
                a = Node.new(xaux,y,1,'black')
                r.append(a);
                xaux += 30
            end
            @@matrix.append(r)
            y += 20
        end
    end

    


    def removewall(i, j)        
        @@matrix[i][j].deletewall(1)        
    end 

end

#Basic matrix
#a = Node.new(30,30, 1, 'black')

#b = Node.new(60, 30, 1, 'black')
#c = Node.new(30, 50, 1, 'black')
#d = Node.new(60, 50, 1, 'black')

#a.deletewall(2)

#g = Grid.new(30,30)
#
#tick = 0 
#update do
#    if tick < 30 then
#        g.removewall(tick,tick)
#        sleep 1
#    end
#    tick += 1
#
#end

show


