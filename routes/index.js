var express = require('express');
var router = express.Router();

router.get('/', function(req, res) {
  res.render('index', { title: 'Encomiendas PumaCari' });
});


/* GET home page. 
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
*/

var db = require('../queries');


/*router.get('/api/puppies', db.getAllPuppies);
router.get('/api/puppies/:id', db.getSinglePuppy);
router.post('/api/puppies', db.createPuppy);
router.put('/api/puppies/:id', db.updatePuppy);
router.delete('/api/puppies/:id', db.removePuppy);*/
//router.get('/rest/users', db.getAllUsers);
router.post('/rest/checkLoginUser', db.checkLoginUser);
router.get('/welcome', db.welcome);
router.get('/presupuestos', db.presupuestos);
//router.get('/presupuestos/edit:id', db.editar_presupuesto);

router.get('/presupuestos/delete/:id', db.eliminar_presupuesto);
//router.delete('/presupuestos/delete/:id', db.eliminar_presupuesto);
router.post('/presupuestos/crear', db.crear_presupuesto);
router.post('/rest/saveBudget', db.save_budget);
router.post('/rest/updateBudget', db.merge_budget);
router.get('/presupuestos/editar/:id_presupuesto', db.actualizar_presupuesto);
router.post('/presupuestos/filtrar', db.filtrar_presupuestos);

router.get('/clientes', db.clientes);
router.post('/clientes/crear', db.crear_cliente);
router.post('/rest/saveClient', db.save_client);
router.get('/clientes/editar/:id_cliente', db.actualizar_cliente);
router.post('/rest/updateClient', db.merge_client);
router.get('/clientes/delete/:id', db.eliminar_cliente);

router.get('/entregas', db.entregas);
router.post('/entregas/crear', db.crear_entrega);
router.post('/rest/saveDelivery', db.save_delivery);
router.get('/entregas/editar/:id_entrega', db.actualizar_entrega);
router.post('/rest/updateDelivery', db.merge_delivery);
router.get('/entregas/delete/:id', db.eliminar_entrega);

router.get('/entregas/:id_entrega/paquetes', db.paquetes_por_entrega);
router.get('/entregas/:id_entrega/paquetes/crear', db.crear_paquetes_por_entrega);
router.post('/rest/savePackage', db.save_package);
router.get('/entregas/:id_entrega/paquetes/editar/:id_paquete', db.actualizar_paquete);
router.post('/rest/updatePackage', db.mergePackage);
router.get('/entregas/:id_entrega/paquetes/delete/:id', db.eliminar_paquete);

module.exports = router;
