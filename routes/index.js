var express = require('express');
var router = express.Router();

router.get('/', function(req, res) {
  res.render('index', { title: 'Encomiendas PumaCari' });
});

var db = require('../queries');


router.get('/rest/users', db.getAllUsers);
router.post('/rest/checkLoginUser', db.checkLoginUser);
router.get('/welcome', db.welcome);
router.get('/presupuestos', db.presupuestos);
module.exports = router;
