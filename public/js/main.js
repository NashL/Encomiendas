/*function signin() {
 $.ajax({
      type : "POST",
      url : "/api/checkLoginUser",
      contentType : "application/json; charset=UTF-8;",
      data : JSON.stringify({
        "username" : $("#inputUsername").val(),
        "password" : $("#inputPassword").val()
      }),
      success : function(data) {
				console.log("return ajax post petition SUCCESS");	
				console.log("Successa:" + data);
    	}
    	,
    	error : function(data) {
				console.log("return errorrrr ");
      	alert("Error: " + data);
  	  }
 	});
}*/

function eliminar(idParam){
	console.log(idParam);
}

function editar(idParam){
    console.log(idParam);
}


// Delete User
function deleteBudget(idParam) {

	// Pop up a confirmation dialog
	var confirmation = confirm('Esta seguro que desea eliminar este presupuesto?');

	// Check and make sure the user confirmed
	if (confirmation === true) {

		// If they did, do our delete
		$.ajax({
			type: 'DELETE',
			url: '/presupuestos/delete/' + idParam
		});

	}
	else {

		// If they said no to the confirm, do nothing
		return false;

	}

};


// Validating Empty Field

//Function To Display Popup
function div_show() {
	document.getElementById('abc').style.display = "block";
}
//Function to Hide Popup
function div_hide(){
	document.getElementById('abc').style.display = "none";
}

function crear_presupuesto() {
	//This performs a POST-Request.
	//Use "$.get();" in order to perform a GET-Request (you have to take a look in the rest-API-documentation, if you're unsure what you need)
	//The Browser downloads the webpage from the given url, and returns the data.
	$.post("/presupuestos/crear", function (data) {
		//As soon as the browser finished downloading, this function is called.
		//$('#demo').html(data);
	});
}