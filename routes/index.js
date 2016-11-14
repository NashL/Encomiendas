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
router.get('/rest/users', db.getAllUsers);
router.post('/rest/checkLoginUser', db.checkLoginUser);
router.get('/welcome', db.welcome);
router.get('/presupuestos', db.presupuestos);

module.exports = router;
