CREATE DATABASE SuperMercado
go
use SuperMercado
go

create table Pais(
 id_Pais int identity (1,1) primary key not null,
 NombreP nvarchar(30) not null
)

 go

 -- Procedimiento de actualizar para telefono
 create table Proveedor(
 Cod_Proveedor char(4) primary key not null,
 NombreProv nvarchar(30) not null, 
 Direccion nvarchar(50) not null,
 TelCProv char(8) check (TelCProv like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  Estado bit,
 id_Pais int foreign key references Pais(Id_pais) not null
 )
 

 go

 create table Categoria(
id int identity(1,1) primary key not null,
Categoria nvarchar(15) not null,
Estado bit not null,
Descripcion nvarchar(30) 
 )
 go

 create table Producto(
 Cod_Producto char(4) primary key not null,
 Nombre nvarchar(30) not null,
 Precio float,
 Descripcion nvarchar(30),
 Exist int,
 Cod_Proveedor char(4) foreign key references Proveedor(Cod_Proveedor) not null,
 Id_Categoria int foreign key references Categoria(id) not null
 )

 go

 
 
 
 
 -- Procedimiento de actualizar para salario y telefono


  go

  create table Compra(
  IdCompra int identity(1,1) primary key not null,
  FechaC date not null,
  Total float,
  )

  go

  create table DetalleCompra(
  IdCompra int foreign key references Compra(IdCompra) not null,
  Cod_Producto char(4) foreign key references Producto(Cod_Producto) not null,
  Cantidad int not null,
  preciocompra float,
  subtotal float,
  primary key(IdCompra,Cod_Producto)
  )
 
  go
  
  
 
go
  create table cliente(
  Correo nvarchar(30)  primary key not null,
  Nombre nvarchar(15) not null,
  Contrasena nvarchar(90),
  Apellido nvarchar(15) not null,
  edad  int not null,
  Direccion nvarchar(30),
  TelCC char(8) check (TelCC like '[2|5|7|8][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') not null
  )

  
  go
  

  create table venta(
  id_Venta int identity(1,1) primary key,
  correo nvarchar(30) foreign key references Cliente(Correo),
  Fecha date not null,
  SubTotal float,
  Descuento float,
  Total float
  )
  
  
  go
  

  create table detalle_Venta(
  id_Venta int foreign key references Venta(id_Venta),
  Cod_Producto char(4) foreign key references Producto(Cod_Producto),
  Cantidad int,
  Sub float,
  primary key(id_venta,Cod_Producto)
  )
 

  --Creacion de procedimientos de insercion
  
  --Pais
  go
  alter procedure In_Pais @NombreP nvarchar(30)
 as
 Declare @Pais nvarchar(30)
 set @Pais = (Select NombreP from Pais where NombreP=@NombreP)
 if(@NombreP='')
	BEGIN
	print 'El Pais no puede ser nulo'
	END
 else
 begin
	if(@Pais=@NombreP)
		begin
		print 'Este Pais ya ha sido registrado'
		end
	else
		begin
		insert into Pais values(@NombreP)
		select id_Pais as id, NombreP as nombre from Pais where id_Pais=SCOPE_IDENTITY() 
		end
 end

 go
 --Proveedor
 
alter procedure In_Proveedor @Cod_Prov char(4), @NombreProv nvarchar(30), @Direccion nvarchar(50), @TelCProv char(8), @Id_Pais int
 as
 declare @Proveedor char(4)
 set @Proveedor=(Select Cod_Proveedor from Proveedor where Cod_Proveedor=@Cod_Prov)
 declare @NombreProveedor nvarchar(30)
 set @NombreProveedor =(select NombreProv from Proveedor where NombreProv=@NombreProv)
 declare @Pais int
  set @Pais = (Select id_Pais from Pais where id_Pais=@Id_Pais)

  if(@Cod_Prov='' or @NombreProv='' or @Direccion='')
  begin
  print 'Los campos no pueden ser nulos'
  end
  else
  begin
	if(@Cod_Prov=@Proveedor or @NombreProv=@NombreProveedor)
	begin
	print'El proveedor ya ha sido registrado'
	end
	else
	begin
		if(@Pais=@Id_Pais)
		begin
		insert into Proveedor values(@Cod_Prov , @NombreProv, @Direccion , @TelCProv ,@Id_Pais,1)
		select Cod_Proveedor AS id ,NombreProv as nombre, Direccion as direccion, TelCProv as telefono, Pais.NombreP as pais from Proveedor inner join Pais on Proveedor.id_Pais = Pais.id_Pais where Proveedor.Cod_Proveedor = @Cod_Prov
		end
		else
		begin
		print 'El pais no ha sido registrado'
		end
	end
  end

  -- Aqui solo si queres agregar lo de que se registre Producto ya con cantidad inicial
  --Producto
  go
  alter procedure In_Producto @Cod_Producto char(4), @NOM nvarchar(30) ,@Precio float, @Descripcion nvarchar(30),  @Cod_Proveedor char(4), @id_categoria int 
 as
 declare @Producto char(4)
 set @Producto=(select Cod_Producto from Producto where Cod_Producto=@Cod_Producto)
 declare @Proveedor char(4)
 set @Proveedor=(Select Cod_Proveedor from Proveedor where Cod_Proveedor=@Cod_Proveedor)
 declare @Categoria int
 set @Categoria= (Select id from Categoria where id=@id_categoria)
 declare @nameProducto nvarchar(30)
 set @nameProducto = (select Nombre from Producto where Nombre = @NOM)
 if(@Cod_Producto='' or @Descripcion='' or @NOM='' or @id_categoria='')
 BEGIN
 print 'Los campos no pueden ser nulos'
 end
 else
 begin
	if(@Precio<=0)
	begin
	print 'El valor del precio no es valido'
	end
	else
	begin
		if(@Cod_Producto=@Producto or @nameProducto = @NOM)
		begin
		print 'Este Producto ya ha sido registrado'
		end
		else
		begin
			if(@Categoria=@id_categoria)
			begin
				if(@Proveedor=@Cod_Proveedor)
				begin
					insert into Producto values(@Cod_Producto ,@NOM, @Precio , @Descripcion ,0,  @Cod_Proveedor, @id_categoria,1)
					select Cod_Producto as id, nombre ,Producto.descripcion,  exist, precio, Categoria.categoria, Proveedor.NombreProv as proveedor from Producto inner join Proveedor on Producto.Cod_Proveedor=Proveedor.Cod_Proveedor inner join Categoria on Producto.Id_Categoria = Categoria.id where Producto.Cod_Producto = @Cod_Producto
					
				end
				else
				begin
					print 'El proveedor no ha sido registrado'
				end
			end
			else
			begin
				print 'La categoria no ha sido registrada'
			end
				
		end
	end
 end
 --- Procedure para ingresar categoria
  go
alter procedure In_Categoria @Categoria nvarchar (15), @Description nvarchar(30)
 as
 declare @NCategoria nvarchar (15)
 set @NCategoria = (select Categoria from Categoria where Categoria = @Categoria)

 
 if(@Categoria = '')
 begin
 print 'La categoria no puede ser nula'
 end
 else 
 begin	
	if(@NCategoria = @Categoria)
	begin	
	print 'La categoria ya ha sido registrada'
	end
	else
	begin
	insert into Categoria values(@Categoria, @Description, 1)
	select id , categoria , descripcion , Estado from Categoria where id = SCOPE_IDENTITY()
	return 
	end
 end
 
 
 
   
  --Nuevo Empleado
 go
  create procedure In_Empleado @Cod_Empleado char(4), @PNombre nvarchar(15), @SNombre nvarchar(15), @PApellido nvarchar(15), @SApellido nvarchar(15), @Salario float, @Cedula char(16), @Tel char(8), @Dir nvarchar(80)
 as
 declare @Empleado char(4)
 set @Empleado=(Select Cod_Empleado from Empleado where Cod_Empleado=@Cod_Empleado)
 declare @Fon char(1)
 set @Fon= (SUBSTRING(@TEL,1,1))
 if(@Cod_Empleado='' or @PNombre='' or @PApellido='' or @Dir='' or @Cedula='')
 begin
 print 'Los campos nombre, apellido, direccion y codigo no pueden ser nulos'
 end
 else
 begin
	if(@Salario<8000)
	begin
	print 'El salario ingresado no es valido'
	end
	else
	begin
		if(@fon='2' or @fon='5' or @fon='7' or @fon='8')
		begin
			if(@Cod_Empleado=@Empleado)
			begin
			print 'El Empleado ya fue registardo'
			end
			else
			begin
				insert into Empleado values(@Cod_Empleado , @PNombre , @SNombre , @PApellido , @SApellido , @Salario , @Cedula , @Tel , @Dir )
			end
		end
		else
		begin
		print 'El formato del celular no es valido'
		end
	end
 end


 
go
--Nuevo cliente
alter procedure In_Cliente @Correo nvarchar(30), @contrasena nvarchar(90), @Nombre nvarchar(15),@Apellido nvarchar(15), @edad int, @Direccion nvarchar(30), @Tel char(8)
  as
 
  declare @Fon char(1)
 set @Fon= (SUBSTRING(@TEL,1,1))
 declare @cliente nvarchar(30)
 set @cliente = (select Correo from cliente where Correo = @Correo)

  if(@Nombre='' or @Apellido='' or @edad='')
  begin
  print 'Los campos no pueden ser nulos'  
  end
  else
  begin
	if(@fon='2' or @fon='5' or @fon='7' or @fon='8')
	begin
		if(@Correo = @cliente)
		begin
		print 'El correo es utilizado por otro cliente'
		end
		else
		begin
		insert into cliente values(@Correo, @Nombre, @contrasena ,@Apellido , @edad , @Direccion , @Tel )
		select correo, nombre, apellido, edad, direccion, TelCC as telefono from cliente where correo = @Correo
		end
		
	end
	else
	begin
	print 'El formato del telefono no es valido '
	end
  end

  go

  --Insertar Nueva venta
  create procedure In_Venta @Cod_Cliente int, @Cod_Empleado char(4), @Descuento float
  as
  Declare @Cliente int
  set @Cliente= (select Cod_Cliente from cliente where Cod_Cliente= @Cod_Cliente)
  declare @Empleado char(4)
  set @Empleado = (select Cod_Empleado from Empleado where Cod_Empleado=@Cod_Empleado)

  if(@Cod_Cliente='' or @Cod_Empleado='')
  begin
	print 'Los codigos no pueden ser nulos'
  end
  else
  begin
		if(@Cliente=@Cod_Cliente)
		begin
			if(@Descuento<0)
			begin
				print'No se puede registrar ese descuento '
			end
			else 
			begin
					if(@Empleado=@Cod_Empleado)
					begin
						insert into venta values(@Cod_Cliente, @Cod_Empleado, GETDATE(), 0, @Descuento, 0)
					end
					else
					begin
						print 'El empleado no ha sido registrado '
					end
		    end	
		end
		else
		begin
			print'El cliente no ha sido registrado'
		end
  end

  go 
  --Nuevo detalle_Venta
  create procedure In_Detalle_Venta @id_Venta int, @Cod_Producto char(4), @Cantidad int
  as
  declare @Venta int
  set @Venta= (select Id_Venta from Venta where id_Venta= @id_Venta)
  declare @Producto char(4)
  set @Producto=(Select Cod_Producto from Producto where Cod_Producto=@Cod_Producto)
  declare @cantdisp as int
  set @cantdisp = (select Exist from Producto where Cod_Producto=@Cod_Producto)
  declare @ven as int
  set @ven = (select id_Venta from detalle_Venta where id_Venta=@id_Venta and Cod_Producto=@Cod_Producto)
  if(@id_Venta='' or @Cod_Producto='')
  begin
  print 'Los datos no pueden ser nulo'
  end
  else
  begin
	if(@id_Venta=@Venta)
	begin
			if(@Cod_Producto=@Producto)
			begin
					if(@id_Venta=@ven)
					begin
						print 'Este detalle venta ya fue registrado'
					end
					else
					begin
						if(@Cantidad>@cantdisp)
						begin
							print 'No hay suficiente inventario para realizar la venta.'
						end
						else
						begin
							-- Agrega la validacion de la cantidad gran hp
							insert into detalle_Venta values(@id_Venta, @Cod_Producto, @Cantidad,0)
						end
					end
			end
			else
			begin
			print 'El Producto no se ha registrado'
			end
	end
	else
	begin
	print 'La venta aun no se ha registrado'
	end

  end

  go

  --Nueva compra
alter procedure In_Compra
  as
  declare @fecha date
  set @fecha = (select GETDATE())
insert into Compra values(@fecha,0)
select IdCompra as id, FechaC as fecha, total from Compra where IdCompra =SCOPE_IDENTITY()
	

  go

  alter procedure In_DetalleCompra
  @IDC int,
  @CODR char(4),
  @CANT int,
  @PREC float
  as
  declare @compra as int
  set @compra = (select IdCompra from Compra where IdCompra = @IDC)
  declare @Producto as char(4)
  set @Producto = (Select Cod_Producto from Producto where Cod_Producto = @CODR)
  if(@CODR = '' or @IDC = null)
  begin
	print 'No puede ser nulo.'
  end
  else
  begin
	if(@CANT < 1)
	begin
		print 'La cantidad no puede ser menor que cero.'
	end
	else
	begin
		if(@IDC=@compra and @CODR=@Producto)
		begin
			insert into DetalleCompra values(@IDC,@CODR,@CANT,@PREC,0)
			select IdCompra as id, detallecompra.Cod_Producto as producto, cantidad, preciocompra as precio, subtotal from DetalleCompra inner join Producto on DetalleCompra.Cod_Producto = Producto.Cod_Producto where IdCompra = @IDC and DetalleCompra.Cod_Producto = @CODR
		end
		else
		begin
			print 'Datos no registrados.'
		end
	end
  end

  go
  --/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  --Creacion de procedimientos de busqueda

  -- Buscar Pais por nombre
alter procedure BuscPais
  @id int
  as
	if(@id='')
	begin
		print 'Id incorrecto.'
	end
	else
	begin
		select id_Pais as id, NombreP as nombre from Pais  where id_Pais = @id
	end

	go

	create procedure Busc_PaisN
  @nombre nvarchar(30)
  as
	if(@nombre='')
	begin
		print 'Id incorrecto.'
	end
	else
	begin
		select id_Pais as id from Pais where NombreP = @nombre
	end

	
	go
  --Ver proveedor por codigo
 alter procedure Bus_ProveedorC @Codigo char(4)
 as
 declare @proveedor char(4)
 set @proveedor = (select Cod_Proveedor from Proveedor where Cod_Proveedor = @Codigo)
 if(@Codigo='')
 begin
 print'El codigo del proveedor no puede ser nulo'
 end
 else
 begin
	if(@proveedor = @Codigo)
	begin
	select Cod_Proveedor AS id ,NombreProv as nombre, direccion, TelCProv as telefono, Pais.NombreP as pais, estado from Proveedor inner join Pais on Proveedor.id_Pais = Pais.id_Pais  where Proveedor.Cod_Proveedor=@Codigo
	end
	else
	begin
	print 'Proveedor no registrado'
	end
 end
 go
 --Ver proveedor por nombre 
 alter procedure Bus_ProveedorN @Nombre nvarchar(30)
 as
 if(@Nombre='')
 begin
 print'El nombre no puede estar vacio'
 end
 else
 begin
 select Cod_Proveedor as codigo from Proveedor where NombreProv=@Nombre
 end

 go
  --Buscar Producto por codigo
 alter procedure Bus_ProductoC @Codigo char(4)
 as
 declare @producto char(4)
 set @producto = (select Cod_Producto from Producto where Cod_Producto= @Codigo)
 if(@Codigo='' or @Codigo is null)
 begin
 print'El codigo no puede ser nulo'
 end
 else
 begin
	if(@Codigo = @producto)
	begin
	select Cod_Producto as codigo, nombre, precio, Producto.descripcion , Exist as cantidadDisponible, Categoria.categoria, Proveedor.NombreProv as proveedor from Producto inner join Proveedor on Producto.Cod_Proveedor=Proveedor.Cod_Proveedor inner join Categoria on Producto.Id_Categoria = Categoria.id where Producto.Cod_Producto = @Codigo
	end
	else
	begin
	print 'Codigo no registrado'
	end
	
 end
 go

 create procedure BuscProducto_Nombre
 @NOM nvarchar(30)
 as
	if(@NOM='')
	begin
		print 'Nombre no valido.'
	end
	else
	begin
		select Cod_Producto from Producto where Nombre=@NOM
	end

 go

 --Buscar Producto por proveedor
 create procedure Bus_ProveedorR @Proveedor char(4)
 as
 if(@Proveedor='')
 begin
 print 'El proveedor no puede ser nulo'
 end
 else
 begin
 select * from Producto where Cod_Proveedor=@Proveedor
 end

 
 go
 --Buscar categoria por nombre
alter procedure Bus_CategoriaN @Categoria nvarchar(15)
 as
 declare @id int
 set @id = (select id from Categoria where Categoria = @Categoria)
 if(@Categoria = '')
 begin
 print 'Categoria no puede estar vacia'
 end
 else
 begin
	if(@id = '')
	begin
	print 'Categoria no registrada'
	end
	else
	begin
	select id from Categoria where id = @id
	end
 end
 go

alter procedure Bus_CategoriaId @id int
 as
 declare @Categoria int
 set @Categoria = (select id from Categoria where id = @id)
 if(@Categoria = @id)
 begin
 select id, categoria, descripcion, estado from Categoria where id = @id
 end
 else
 begin
 print 'Categoria no registrada'
 end

 go
 --Busqueda de empleado por codigo
 create procedure Bus_EmpleadoC @Codigo char(4)
 as
 if(@Codigo='')
 begin
 print 'El codigo no puede estar vacio'
 end
 else
 begin
 Select * from Empleado where Cod_Empleado=@Codigo
 end

 go
 --Buscar empleado por nombre y apellido
 create procedure Bus_EmpleadoNA @Nombre nvarchar(15), @Apellido nvarchar(15)
 as
 if(@Nombre='' or @Apellido='')
 begin
 print 'El nombre o apellido no pueden ser nulos'
 end
 else
 begin
 Select * from Empleado where PNombre=@Nombre and PApellido=@Apellido
 end

 go

 -- Buscar codigo de empleado por nombre completo
 create procedure BusEmp_FullName
 @NAME nvarchar(65)
 as
	if(@NAME='')
	begin
		print 'Nombre invalido.'
	end
	else
	begin
		select Cod_Empleado from Empleado where (PNombre+' '+SNombre+' '+PApellido+' '+SApellido)=@NAME
	end

   go


  --Buscar compra por ID
  create procedure Bus_CompraId @id int
  as
  if(@id='')
  begin
  print 'El id no puede ser nulo'
  end
  else
  begin
  select * from Compra where IdCompra=@id
  end





 
	go
  
  --Buscar cliente por id
  alter procedure Bus_ClienteId @correo nvarchar(30)
  as
  declare @cliente nvarchar(30)
  set @cliente = (select correo from Cliente where correo = @correo)

  if(@correo='' or @correo is null)
  begin
  print 'el id no puede ser nulo'
  end
  else
  begin
	if(@cliente != @correo)
	begin
	print 'Cliente no registrado'
	end
	else
	begin
	select correo, nombre, apellido, edad, direccion, TelCC as telefono from cliente where correo = @correo
	end
	
  end

  go
  --Bsuqueda de las ventas por id
  create procedure Bus_VentaI @Id int
  as
  if(@Id='')
  begin
  print 'El id no puede ser nulo'
  end
  else
  begin
  Select * from venta where id_Venta=@Id
  end
  go
  
  --Bsuqueda de las ventas por Empelado
  create procedure Bus_VentaE @Empleado char(4)
  as
  if(@Empleado='')
  begin
  print 'El empelado no puede ser nulo'
  end
  else
  begin
  Select * from venta where Cod_Empleado=@Empleado
  end

  go
  --Buscar detalle venta por id
  create procedure Bus_Detalle_VentaI @Id int
  as
  if(@Id='')
  begin
  print 'El id no puede ser nulo'
  end
  else
  begin
  select * from detalle_Venta where id_Venta=@Id
  end

  go

  -- Buscar detalle de compra por id
  create procedure Bus_DetalleCompra @ID int
  as
	if(@ID=null)
	begin
		print 'No debe ser nulo.'
	end
	else
	begin
		select * from DetalleCompra where IdCompra=@ID
	end

  go
  
  --Buscar detalle venta por Producto
  create procedure Bus_Detalle_VentaR @Id char(4)
  as
  if(@Id='')
  begin
  print 'El id no puede ser nulo'
  end
  else
  begin
  select * from detalle_Venta where Cod_Producto=@Id
  end
  --/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  --Creacion de vistas
  go
 --Todos los paises
 create view AllPais(Id_Pais, NombreP)
 as
 select * from Pais

 --Todos los proveedores
 go

 create view AllProveedor(Codigo, Nombre, Direccion, Telefono, Pais)
 as

 select Cod_Proveedor, NombreProv, Direccion, TelCProv, NombreP from Proveedor inner join Pais on Proveedor.id_Pais=Pais.id_Pais
 
 
 go
 --Todos los empleados
 create view AllEmpleados (Codigo, Nombre, segundo_Nombre, Apellido, Segundo_Apellido, Salario, Cedula, Telefono, Direccion)
 as
 select * from Empleado

 go

 create view AllCompra(Solicitud,fecha, total, Empleado)
 as
 select * from Compra

 --Mostrar todos los departamentos



go
 --Mostrar todos los clientes
 create view AllCliente(Codigo, Nombre, Segundo_Nombre, Apellido, Segundo_Apellido, Cedula, Empresa, telefono)
 as
 Select Cod_Cliente, PNombre, SNombre, PApellido, SApellido, CedulaC, Empresa, TelCC from cliente

 --Mostrar todas las ventas
  go
  create view AllVenta(Id,CodigoCliente,CodigoEmpleado,SubTotal,Descuento, Total, Fecha)
  as
  Select * from venta

  go
  --Mostrar los detalles de Venta
  create view AllDetalleVenta(Id, Codigo, Cantidad, SubTotal)
  as
  select * from detalle_Venta

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  --Creacion de trigger de actualizacion de inventario 
   go
  --Actualizar inventario cuando se hace una venta
  create trigger Act_Venta on
Detalle_Venta after insert
as
declare @Id int
set @Id=(Select id_Venta from inserted)
declare @Producto char(4)
set @Producto=(Select Cod_Producto from inserted)
declare @precio as float
set @precio = (select Precio from Producto where Cod_Producto = @Producto)
update detalle_Venta set Sub = ((select Cantidad from inserted)*@precio) where id_Venta = @Id and Cod_Producto = @Producto
Update venta set SubTotal=(Select SUM(Sub) from detalle_Venta where id_Venta=@Id) where id_Venta=@Id
declare @Subtotal float
set @Subtotal=(select SubTotal from venta where id_Venta=@Id)
update venta set Total = (@Subtotal-@Subtotal*(select Descuento/100 from venta where id_Venta=@Id)) where id_Venta=@Id
declare @Ex int
set @Ex=(Select exist from Producto where Cod_Producto=@Producto)
update Producto set Exist=(@Ex-(Select cantidad from inserted)) where Cod_Producto=@Producto

go

-- Hace un cursor y esto para compra gran hp
--Actualizar inventario cuando se hace una compra
  create trigger Act_Compra on
DetalleCompra after insert
as
declare @compra as int
set @compra = (select IdCompra from inserted)
declare @Producto char(4)
set @Producto=(select Cod_Producto from inserted)
update DetalleCompra set subtotal = ((select preciocompra from inserted)*(select Cantidad from inserted)) where IdCompra=@compra and Cod_Producto=@Producto
update Compra set Total = (Select SUM(subtotal) from DetalleCompra where IdCompra=@compra) where IdCompra=@compra
update Producto set Exist=((select Exist from Producto where Cod_Producto=@Producto)+(select Cantidad from inserted)) where Cod_Producto=@Producto
 
 go

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--Crear procedimientos de actualizacion

alter procedure Act_Categoria @id int, @Categoria nvarchar(15), @descripcion nvarchar(30)
as
declare @IdCategoria int
set @IdCategoria = (select id from Categoria where id = @id)
declare @lookup nvarchar(15)
set @lookup = (select Categoria from Categoria where Categoria = @Categoria)
declare @checkNombre int
set @checkNombre = (select id from Categoria where Categoria = @Categoria)
if(@id = '' or @Categoria = '')
begin
print 'Campos no puede ser nulo'
end
else
begin
	if(@id = @IdCategoria)
	begin
		if(@lookup = @Categoria and @checkNombre != @id)
		begin
		Print 'Nombre ocupado'
		
		end
		else
		begin
			Update Categoria set Categoria = @Categoria, Descripcion = @descripcion where id = @id
			select id, categoria, descripcion from Categoria where id = @id
		end
	end
	else
	begin
	print 'Categoria no registrada'
	end
end

go

alter procedure Act_Proveedor @Cod_Prov char(4), @NombreProv nvarchar(30), @Direccion nvarchar(50), @TelCProv char(8), @Id_Pais int
as
declare @proveedor char(4)
set @proveedor = (select Cod_Proveedor from Proveedor where  Cod_Proveedor = @Cod_Prov)
declare @nameId char(4)
set @nameId = (select Cod_Proveedor from Proveedor where NombreProv = @NombreProv )
declare @Pais int
set @Pais = (select id_Pais from Pais where id_Pais= @Id_Pais)
if(@proveedor = '' or @NombreProv= '' )
begin
print 'Campos no pueden ser nulos'
end
else
begin
	if(@proveedor = @Cod_Prov)
	begin
		if(@Pais = @Id_Pais)
		begin	
			if(@nameId = @Cod_Prov or @nameId is null)
			begin
			 update Proveedor set NombreProv = @NombreProv, Direccion = @Direccion, TelCProv = @TelCProv, id_Pais = @Id_Pais where Cod_Proveedor = @Cod_Prov
			 select Cod_Proveedor as id ,NombreProv as nombre, Direccion as direccion, TelCProv as telefono, Pais.NombreP as pais from Proveedor inner join Pais on Proveedor.id_Pais = Pais.id_Pais where Proveedor.Cod_Proveedor = @Cod_Prov
			end
			else 
			begin
			print 'Nombre ocupado'

	
			end
		end
		else
		begin
		print 'Pais no registrado'
		end
	end
	else
	begin
	print 'Proveedor no registrado'
	end
end

go
alter procedure Act_Producto @Cod_Producto char(4), @NOM nvarchar(30) ,@Precio float, @Descripcion nvarchar(30),  @Cod_Proveedor char(4), @id_categoria int 
 as
 declare @Producto char(4)
 set @Producto=(select Cod_Producto from Producto where Cod_Producto=@Cod_Producto)
 declare @Proveedor char(4)
 set @Proveedor=(Select Cod_Proveedor from Proveedor where Cod_Proveedor=@Cod_Proveedor)
 declare @Categoria int
 set @Categoria= (Select id from Categoria where id=@id_categoria)
 declare @nameId char(4)
set @nameId = (select Cod_Producto from Producto where Nombre = @NOM )

 if(@Cod_Producto='' or @Descripcion='' or @NOM='' or @id_categoria='')
 BEGIN
 print 'Los campos no pueden ser nulos'
 end
 else
 begin
	if(@Precio<=0)
	begin
	print 'El valor del precio no es valido'
	end
	else
	begin
		if(@Cod_Producto!=@Producto)
		begin
		print 'Este Producto no ha sido registrado'
		end
		else
		begin
			if(@nameId = @Cod_Producto or @nameId is null)
			begin
				if(@Categoria=@id_categoria)
				begin
					if(@Proveedor=@Cod_Proveedor)
					begin
						update Producto set Nombre = @NOM, Precio = @Precio, Descripcion = @Descripcion, Cod_Proveedor = @Cod_Proveedor, Id_Categoria = @id_categoria where Cod_Producto = @Cod_Producto
						select Cod_Producto as id, nombre, Producto.descripcion, Exist as cantidadDisponible  ,precio , Categoria.categoria, Proveedor.NombreProv as proveedor from Producto inner join Proveedor on Producto.Cod_Proveedor=Proveedor.Cod_Proveedor inner join Categoria on Producto.Id_Categoria = Categoria.id where Producto.Cod_Producto = @Cod_Producto
					end
					else
					begin
						print 'El proveedor no ha sido registrado'
					end
				end
				else
				begin
					print 'La categoria no ha sido registrada'
				end
			end
			else
			begin
			print 'Nombre de producto ocupado'
			end				
		end
	end
 end
go
alter procedure Act_Cliente @Correo nvarchar(30), @Nombre nvarchar(15),@contrasena nvarchar(90),@Apellido nvarchar(15), @edad int, @Direccion nvarchar(30), @Tel char(8)
  as

    declare @cliente nvarchar(30)
  set @cliente = (select correo from Cliente where correo = @correo)
 
  declare @Fon char(1)
 set @Fon= (SUBSTRING(@TEL,1,1))

  if(@Nombre='' or @Apellido='' or @edad='')
  begin
  print 'Los campos no pueden ser nulos'  
  end
  else
  begin
	if(@fon='2' or @fon='5' or @fon='7' or @fon='8')
	begin
		if(@cliente = @Correo)
		begin
		update cliente set Nombre = @Nombre, Apellido = @Apellido, edad = @edad, Direccion = @Direccion, TelCC = @Tel, contrasena= @contrasena where correo = @Correo
		select correo, nombre, apellido, edad, direccion, TelCC as telefono from cliente where correo = @Correo
		end
		else
		begin
		print 'cliente no registrado'
		end
		
	end
	else
	begin
	print 'El formato del telefono no es valido '
	end
  end

go
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--Crear procedimientos de eliminacion
create procedure delet_Categoria @id int
as
declare @Categoria int
set @Categoria = (select id from Categoria where id = @id)
if(@Categoria = @id)
begin
	update Categoria set Estado = 0 where id = @id 
end
go 

create procedure delet_Proveedor @cod_Proveedor char(4)
as
declare @proveedor char(4)
set @proveedor = (select Cod_Proveedor from Proveedor where Cod_Proveedor = @cod_Proveedor)
if(@proveedor = @cod_Proveedor)
begin
	update Proveedor set Estado = 0 where Cod_Proveedor = @cod_Proveedor
end
else
begin
print 'Proveedor no registrado'
end
go
create procedure delet_Producto @codigo char(4)
as
declare @producto char(4)
set @producto = (select Cod_Producto from Producto where Cod_Producto = @codigo)

if(@codigo = '' or @codigo is null)
begin
print'el codigo no pueder estar vacio'
end
else
begin
	if(@producto = @codigo)
	begin
	update Producto set Estado = 0 where Cod_Producto=@codigo
	end
	else
	begin
	print 'Producto no registrado'
	end
end
go


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
exec In_Pais @NombreP = 'Nicaragua'
exec In_Pais @NombreP = 'Costa Rica'
exec In_Pais @NombreP = 'Guatemala'
exec BuscPais @id = '1'
exec Busc_PaisN @nombre = 'Nicaragua'
select * from Pais


exec In_Categoria @Categoria = 'arroz', @Description = ''
exec Bus_CategoriaN @Categoria = 'Granos'
exec Bus_CategoriaId @id = 25
exec delet_Categoria @id = 14

exec Act_Categoria @id = 22, @Categoria = 'eduardoDiaz', @descripcion = 'cadavexmasfuerte'

select * from Categoria



exec In_Proveedor @Cod_Prov ='AAA6' ,@NombreProv = 'Yasser', @Direccion='San sebastean', @TelCProv = '81761227', @Id_Pais='1' 
exec In_Proveedor @Cod_Prov ='AAA2' ,@NombreProv = 'Luis', @Direccion='San sebastean', @TelCProv = '81761227', @Id_Pais='1' 
exec In_Proveedor @Cod_Prov ='AAA3' ,@NombreProv = 'Ramon', @Direccion='San sebastean', @TelCProv = '81761227', @Id_Pais='1' 
exec In_Proveedor @Cod_Prov ='AAA8' ,@NombreProv = 'Ramon', @Direccion='San sebastean', @TelCProv = '81761227', @Id_Pais='1'
exec Bus_ProveedorC @Codigo = 'AAA1'
exec Act_Proveedor @Cod_Prov ='AAA1' ,@NombreProv = 'Jordi', @Direccion='San ', @TelCProv = '81761227', @Id_Pais='1'
exec delet_Proveedor @Cod_Proveedor = 'AAA3'

exec Bus_ProveedorN @Nombre = 'Luis'

select Cod_Proveedor from Proveedor where NombreProv = 'Yasser'
select * from Proveedor
select Cod_Proveedor AS codigo ,NombreProv as nombre, Direccion, TelCProv as telefono, Pais.NombreP as pais, Estado from Proveedor inner join Pais on Proveedor.id_Pais = Pais.id_Pais 

exec In_Producto @Cod_Producto ='CCC1' , @NOM='Pepsi 2 ltrs', @Precio=38, @Descripcion = 'Danino pa la salud', @Cod_Proveedor='AAA1', @id_categoria = 15
exec In_Producto @Cod_Producto ='CCC2' , @NOM='Caramelo', @Precio='40', @Descripcion = 'Danino pa la salud', @Cod_Proveedor='AAA1', @id_categoria = 16
exec In_Producto @Cod_Producto ='CCC3' , @NOM='Helado dos pinos', @Precio=38, @Descripcion = 'God pa la salud', @Cod_Proveedor='AAA1', @id_categoria = 17
exec In_Producto @Cod_Producto ='CCC7' , @NOM='Coca cola 90 ltrs', @Precio=38, @Descripcion = 'Danino pa la salud', @Cod_Proveedor='AAA1', @id_categoria = 18
 exec Bus_ProductoC @Codigo = 'CCC4'
 exec Act_Producto @Cod_Producto ='CCC4' , @NOM='Coca cola 4 ltrs', @Precio=80, @Descripcion = 'Danino pa la salud', @Cod_Proveedor='AAA1', @id_categoria = 18
 exec delet_Producto @codigo = 'CCC1'
 exec BuscProducto_Nombre @NOM = 'taquerito' 
select * from Producto
select Cod_Producto as codigo, Nombre as Producto, precio, Producto.Descripcion , Exist as cantidadDisponible, Categoria.Categoria, Proveedor.NombreProv as Proveedor, Producto.Estado from Producto inner join Proveedor on Producto.Cod_Proveedor=Proveedor.Cod_Proveedor inner join Categoria on Producto.Id_Categoria = Categoria.id


exec In_Cliente @Correo ='yasserlacayo@gmail.com',@contrasena = 'yasser38', @Nombre= 'Yasser Jose' ,@Apellido= 'Lacayo Tellez', @edad = 22, @Direccion ='san sebastean', @Tel = '81761227'
exec In_Cliente @Correo ='Ramonlacayo@gmail.com', @Nombre= 'Yasser Jose',@contrasena = 'yasser38' ,@Apellido= 'Lacayo Tellez', @edad = 22, @Direccion ='san sebastean', @Tel = '81761227'
exec In_Cliente @Correo ='Luislacayo@gmail.com', @Nombre= 'Yasser Jose',@contrasena = '$2b$10$vZxdBDr0t/qC6aQRu1xmjelFo7HADYUyeYCU4G3d9KAwvlyyFxOia' ,@Apellido= 'Lacayo Tellez', @edad = 22, @Direccion ='san sebastean', @Tel = '81761227'
exec In_Cliente @Correo ='jordilacayo@gmail.com', @Nombre= 'Yasser Jose',@contrasena = '$2b$10$vZxdBDr0t/qC6aQRu1xmjelFo7HADYUyeYCU4G3d9KAwvlyyFxOia' ,@Apellido= 'Lacayo Tellez', @edad = 22, @Direccion ='san sebastean', @Tel = '81761227'

exec Act_Cliente @Correo ='yasserlacayo@gmail.com',@contrasena = 'yasser38', @Nombre= 'Yasser Jose' ,@Apellido= 'Lacayo Tellez', @edad = 22, @Direccion ='san sebastean', @Tel = '81761227'

exec Bus_ClienteId @correo = 'yasserlacayo@gmail.com'

select * from cliente

exec In_Empleado @Cod_Empleado = '1112', @PNombre = 'Jose', @SNombre = 'jose', @PApellido = 'Jose', @SApellido = 'jose', @Salario = 18000, @Cedula = '001-101000-1025T', @Tel = '81761227', @Dir = 'san'
exec In_Empleado @Cod_Empleado = '1113', @PNombre = 'Jose', @SNombre = 'jose', @PApellido = 'Jose', @SApellido = 'jose', @Salario = 18000, @Cedula = '001-101000-1025T', @Tel = '81761227', @Dir = 'san'

exec In_Compra

select IdCompra as id, FechaC as fecha, total from Compra

exec In_DetalleCompra @IDC = 2, @CODR = 'CCC3', @CANT = 60, @PREC = 63
exec In_DetalleCompra @IDC = 3, @CODR = 'CCC4', @CANT = 60, @PREC = 20

select * from DetalleCompra 

select DetalleCompra.IdCompra as compra, FechaC as fecha, total, DetalleCompra.Cod_Producto as idProducto, Producto.nombre as producto, DetalleCompra.preciocompra as precio, DetalleCompra.subtotal from Compra inner join DetalleCompra on Compra.IdCompra = DetalleCompra.IdCompra inner join Producto on Producto.Cod_Producto = DetalleCompra.Cod_Producto where Compra.IdCompra = '2'

exec In_Venta @Cod_Cliente= '1', @Cod_Empleado = '1111', @Descuento = 0

select * from venta

exec In_Detalle_Venta @id_Venta =1, @Cod_Producto= 'CCC3', @Cantidad = 20

select * from DetalleCompra

 Create table Empleado(
 Cod_Empleado char(4) primary key not null,
 PNombre nvarchar(15) not null,
 SNombre nvarchar(15),
 PApellido nvarchar(15) not null,
 SApellido nvarchar(15),
 Salario float,
 Cedula char(16) not null,
 TelCEmp char(8) check (TelCEmp like '[2|5|7|8][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') not null,
 Direccion nvarchar(80) not null
 )