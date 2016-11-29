var promise = require('bluebird');

var options = {
    // Initialization Options
    promiseLib: promise
};

var usernameGlobal = "";
var id_presupuestador = "";
var userLogged ;
var ciudades = "";
var fragilidad = ""
var prioridad = "";
var presupuestos_list="";
var clientes_list = "";
var pgp = require('pg-promise')(options);
//-------------- Aqui configura tu base de datos(...)
var connectionString = 'postgres://postgres:postgres@localhost:5432/encomiendas';
var db = pgp(connectionString);

// add query functions

module.exports = {
    getAllUsers: getAllUsers,
    checkLoginUser: checkLoginUser,
    welcome: welcomePage,
    presupuestos: presupuestos,
    eliminar_presupuesto: eliminarPresupuesto,
    crear_presupuesto: crearPresupuesto,
    save_budget: savePresupuesto,
    merge_budget: mergePresupuesto,
    actualizar_presupuesto: actualizarPresupuesto,
    clientes:clientes,
    crear_cliente:crearCliente,
    save_client:saveClient,
    actualizar_cliente:update_client,
    merge_client:mergeClient,
    eliminar_cliente:eliminarCliente,
    entregas:entregas,
    crear_entrega:crearEntrega,
    save_delivery:saveDelivery,
    actualizar_entrega:update_delivery,
    merge_delivery:mergeDelivery,
    eliminar_entrega:eliminarEntrega,
    paquetes_por_entrega: paquetes_por_entrega,
    crear_paquetes_por_entrega: crear_paquetes_por_entrega,
    save_package: save_package,
    actualizar_paquete: actualizar_paquete,
    eliminar_paquete: eliminar_paquete,
    mergePackage: mergePackage
};

function getAllUsers(req, res, next) {
    db.any('SELECT * FROM getUsers()')
        .then(function (data) {
            res.status(200)
                .json({
                    status: 'success',
                    data: data,
                    message: 'Retrieved ALL users'
                });
        })
        .catch(function (err) {
            return next(err);
        });
}

function checkLoginUser(req, res, next) {
    db.one('SELECT * FROM checkLoginUser(${username}, ${password})', req.body)
        .then(function (data) {
            userLogged = data;
            usernameGlobal = data['nombre_usuario'];
            db.func('presupuestador_by_user', userLogged['id_usuario'])
                .then(function (data) {
                    id_presupuestador = data[0]['id_presupuestador'];
                    console.log(data);
                })
                .catch(function (error) {
                    console.log(error);
                });
            res.redirect("/welcome");
            console.log(data);

        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/');
        });
}

function welcomePage(req, res, next){
    res.render('welcome', {
        username : usernameGlobal,
        title : 'Encomiendas PumaCari'
    });
}

function presupuestos(req, res, next){
    db.func('presupuestos_por_usuario', usernameGlobal)
        .then(function (data) {
            res.render("presupuesto",{
                listapresupuesto: data
            });

        })
        .catch(function (error) {
            console.log(error);
        });
}

function savePresupuesto(req, res) {
    db.func('guardar_presupuesto', [req.body.description, parseInt(req.body.weight), parseInt(req.body.price),
        parseInt(id_presupuestador), req.body.partida, req.body.destino, req.body.fragilidad, req.body.prioridad, req.body.direccion])
        .then(function (data) {
            res.redirect('/presupuestos');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/presupuestos');
        });
}

function eliminarPresupuesto(req, res) {
    var presupuestoId = parseInt(req.params.id);
    db.func('eliminar_presupuesto', presupuestoId)
        .then(function (data) {
            res.redirect('/presupuestos');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/presupuestos');
        });
}

function mergePresupuesto(req, res, next) {
    console.log(req.body.id);
    db.func('actualizar_presupuesto', [req.body.id, req.body.description, parseInt(req.body.weight), parseInt(req.body.price), parseInt(id_presupuestador), req.body.partida, req.body.destino, req.body.fragilidad, req.body.prioridad, req.body.direccion])
        .then(function (data) {
            console.log(data);
            res.redirect('/presupuestos');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/presupuestos');
        });
}

function crearPresupuesto(req, res, next){
    db.func('ciudades_de_reparto')
        .then(function (data){
            ciudades = data;
            db.func('fragilidad')
                .then(function (data){
                    fragilidad = data;
                    db.func('prioridad')
                        .then(function (data){
                            prioridad = data;
                            res.render('crear_preuspuesto', {
                                username : usernameGlobal,
                                title : 'Encomiendas PumaCari',
                                cities: ciudades,
                                fragilidades: fragilidad,
                                prioridades: prioridad
                            });

                        })
                        .catch(function (err){
                            console.log(err);
                        });

                })
                .catch(function (err){
                    console.log(err);
                });

        })
        .catch(function (err){
          console.log(err);
        });
}

function actualizarPresupuesto(req, res){
    db.func('ciudades_de_reparto')
        .then(function (data){
            ciudades = data;
            db.func('fragilidad')
                .then(function (data){
                    fragilidad = data;
                    db.func('prioridad')
                        .then(function (data){
                            prioridad = data;
                            var presupuestoId = parseInt(req.params.id_presupuesto);
                            db.func('obtener_presupuesto', presupuestoId)
                                .then(function (data) {
                                    res.render("editar_presupuesto", {
                                        username : usernameGlobal,
                                        title : 'Encomiendas PumaCari',
                                        cities: ciudades,
                                        fragilidades: fragilidad,
                                        prioridades: prioridad,
                                        presupuesto: data[0]
                                    });
                                });
                        })
                        .catch(function (err){
                            console.log(err);
                        });

                })
                .catch(function (err){
                    console.log(err);
                });

        })
        .catch(function (err){
            console.log(err);
        });
}

function getBudget(req,res){

        db.func('presupuestador_by_user', userLogged['id_usuario'])
            .then(function (data) {
                console.log(data);
                id_presupuestador = data['id_presupuestador'];
            })
            .catch(function (error) {
                console.log(error);
            });
}

////////// CLIENTES

function clientes(req, res, next){

    db.func('clientes', 1)
        .then(function (data) {
            res.render("clientes",{
                listaclientes: data
            });

        })
        .catch(function (error) {
            console.log(error);
        });
}

function crearCliente(req, res, next) {
    res.render('crear_cliente', {
        username: usernameGlobal,
        title: 'Encomiendas PumaCari',
        cities: ciudades,
        fragilidades: fragilidad,
        prioridades: prioridad
    });
}
function saveClient(req, res) {
    db.func('crear_persona', [req.body.nombres, req.body.apellido_paterno, req.body.apellido_materno,
                                req.body.tipo_documento, req.body.numero_documento, req.body.telefono,
                                req.body.correo_electronico])
        .then(function (data) {
            db.func('crear_cliente', data)
                .then(function (data) {
                    res.redirect('/clientes');
                });
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/clientes');
        });
}


function update_client(req, res){
    var clienteId = parseInt(req.params.id_cliente);
    db.func('obtener_cliente', clienteId)
        .then(function (data) {
            console.log(data);
            res.render("editar_cliente", {
                username : usernameGlobal,
                title : 'Encomiendas PumaCari'
            });

        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/');
        });

}

function mergeClient(req, res, next) {
    db.func('actualizar_cliente', [req.body.id, req.body.nombres, req.body.apellido_paterno, req.body.apellido_materno,
        req.body.tipo_documento, req.body.numero_documento, req.body.telefono,
        req.body.correo_electronico])
        .then(function (data) {
            res.redirect('/clientes');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/clientes');
        });
}

function eliminarCliente(req, res) {
    var clienteId = parseInt(req.params.id);
    db.func('eliminar_cliente', clienteId)
        .then(function (data) {
            res.redirect('/clientes');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/clientes');
        });
}

////////// ENTREGAS

function entregas(req, res, next){
    db.func('entregas', 0)
        .then(function (data) {
            res.render("entregas",{
                listaEntregas: data
            });
        })
        .catch(function (error) {
            console.log(error);
        });
}

function crearEntrega(req, res, next) {
    db.func('presupuestos')
        .then(function (data) {
            presupuestos_list=data;
            db.func('clientes', 1)
                .then(function (data) {
                    clientes_list=data;
                    res.render('crear_entrega', {
                        username: usernameGlobal,
                        title: 'Encomiendas PumaCari',
                        listaClientes: clientes_list,
                        listaPresupuestos: presupuestos_list
                    });
                })
                .catch(function (error) {
                    console.log(error);
                });

        })
        .catch(function (error) {
            console.log(error);
        });


}
function saveDelivery(req, res) {
    db.func('crear_entrega', [req.body.id_presupuesto, req.body.id_cliente])
        .then(function (data) {
            res.redirect('/entregas');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/entregas');
        });
}

function update_delivery(req, res){
    db.func('presupuestos')
        .then(function (data) {
            presupuestos_list=data;
            db.func('clientes', 1)
                .then(function (data) {
                    clientes_list=data;
                    db.func('obtener_entrega', req.params.id_entrega)
                    .then(function (data) {
                        console.log(data);
                        res.render("editar_entrega", {
                            username : usernameGlobal,
                            title : 'Encomiendas PumaCari',
                            entrega: data[0],
                            listaClientes: clientes_list,
                            listaPresupuestos: presupuestos_list
                        });
                    })
                    .catch(function (err) {
                        console.log(err);
                        res.redirect('/');
                    });
                })
                .catch(function (error) {
                    console.log(error);
                });

        })
        .catch(function (error) {
            console.log(error);
        });
}

function mergeDelivery(req, res, next) {
    db.func('actualizar_entrega', [req.body.id, req.body.id_presupuesto, req.body.id_cliente])
        .then(function (data) {
            res.redirect('/entregas');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/entregas');
        });
}

function eliminarEntrega(req, res) {
    //var clienteId = parseInt(req.params.id);
    db.func('eliminar_entrega', req.params.id)
        .then(function (data) {
            res.redirect('/entregas');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/entregas');
        });
}

function paquetes_por_entrega(req,res){
    db.func('paquetes_por_entrega', req.params.id_entrega)
        .then(function (data) {
            res.render("paquetes",{
                listaPaquetes: data,
                id_entrega: req.params.id_entrega
            });
        })
        .catch(function (error) {
            console.log(error);
        });
}

function crear_paquetes_por_entrega(req, res, next) {
    
    res.render('crear_paquete', {
        username: usernameGlobal,
        title: 'Encomiendas PumaCari',
        id_entrega: req.params.id_entrega
    });
}

function save_package(req, res) {
    var _entrega = req.body.id_entrega;
    db.func('guardar_paquete', [_entrega, req.body.descripcion, req.body.peso])
        .then(function (data) {
            res.redirect('/entregas/'+_entrega+'/paquetes');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/entregas/'+_entrega+'/paquetes');
        });
}

function actualizar_paquete(req, res){
    db.func('obtener_paquete', req.params.id_paquete)
        .then(function (data) {
            console.log(data);
            res.render("editar_paquete", {
                username : usernameGlobal,
                title : 'Encomiendas PumaCari',
                paquete: data[0],
                entrega: req.params.id_entrega
            });

        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/');
        });
}


function eliminar_paquete(req, res) {
    console.log(req.params.id_entrega);
    console.log(req.params.id);
    var param_entrega = req.params.id_entrega;
    db.func('eliminar_paquete', req.params.id)
        .then(function (data) {
            res.redirect('/entregas/'+param_entrega+'/paquetes');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/entregas/'+param_entrega+'/paquetes');
        });
}

function mergePackage(req, res, next) {

    var param_entrega = req.body.id_entrega;
    db.func('actualizar_paquete', [req.body.id_paquete, req.body.descripcion, req.body.peso])
        .then(function (data) {
            res.redirect('/entregas/'+param_entrega+'/paquetes');
        })
        .catch(function (err) {
            console.log(err);
            res.redirect('/entregas/'+param_entrega+'/paquetes');
        });
}

function load_presupuestos(){
    db.func('presupuestos')
        .then(function (data) {
            presupuestos_list=data;
        })
        .catch(function (error) {
            console.log(error);
        });
}

function load_clientes(){

    db.func('clientes', 1)
        .then(function (data) {
            clientes_list=data;
        })
        .catch(function (error) {
            console.log(error);
        });
}
