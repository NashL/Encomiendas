var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};

var usernameGlobal = "";

var pgp = require('pg-promise')(options);
var connectionString = 'postgres://postgres:postgres@localhost:5432/encomiendas';
var db = pgp(connectionString);

// add query functions

module.exports = {
//  getAllPuppies: getAllPuppies,
//  getSinglePuppy: getSinglePuppy,
//  createPuppy: createPuppy,
//  updatePuppy: updatePuppy,
//  removePuppy: removePuppy,
  getAllUsers: getAllUsers,
	checkLoginUser: checkLoginUser,
	welcome: welcomePage,
	presupuestos: presupuestos
	
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
  //db.none('insert into pups(name, breed, age, sex)' +      'values(${name}, ${breed}, ${age}, ${sex})',req.body)
//		db.func('checkLoginUser', ['oluza','12345678'])
		/*var doc = {
			usuario: "oluza",
			password: "12345678"
		}*/
		db.one('SELECT * FROM checkLoginUser(${username}, ${password})', req.body/*, doc*/)
//		db.func('checkLoginUser', ['oluza','12345678'])
    .then(function (data) {
		usernameGlobal = data['nombre_usuario'];
			res.redirect("/welcome");
			console.log(data);
/*      res.status(200)
        .json({
          status: 'success',
          message: 'Valid Login Dates'
        });*/

    })
    .catch(function (err) {
			console.log(err);
		  res.redirect('/');

/*      return next(err);*/
    });
}

function welcomePage(req, res, next){
	console.log("asdsadas");
	res.render('welcome', {
      username : usernameGlobal,
			title : 'Encomiendas PumaCari'
  });
}

function presupuestos(req, res, next){

	db.func('presupuestos_por_nombre_usuario', usernameGlobal)
	.then(function (data) {
		      res.render("presupuesto",{
						listapresupuesto: data
					}); 

		  })
		  .catch(function (error) {
		      console.log(error); // printing the error 
		  });
}


