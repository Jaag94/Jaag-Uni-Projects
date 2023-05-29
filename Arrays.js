/* Filename: w8P.js
   Target html: w8P.html
   Purpose : Create bookings using onclick events and a global array containing objects
   Author:  Jaag Eickemeyer
   Date written: 05/05/22
   Revisions:  Rev 1.0 Jaag Eickemeyer 12/05/22 line 17 converted numPeople to a number data type
*/

// global array
var arrTourBook = [];

// creates objects for the global array then uses .push to add them to the end of the array
function addTourBooking() {
	var newTourCode = document.getElementById("code").value;
    var newTitle = document.getElementById("title").value;
	var newNumPeople = document.getElementById("people").value;
	var newBooking = {tourCode: newTourCode, title: newTitle, numPeople: Number (newNumPeople)}; // variables become properties of newBooking object, numPeople stores a number data type
	arrTourBook.push(newBooking); // .push method to add object to arrTourBook array
}

// function to output a list of all bookings and values, outputs error message if arrTourBook contains no data
function listBookings() {
	var bOutput = "List of Bookings <br/>";
	var bIndex = 0;
	 if (arrTourBook.length == 0) { 
        document.getElementById("error").innerHTML = "This list is empty, please refresh the page and enter data using the texboxes and use the Add Booking buttton";
    } 
	for (bIndex; bIndex < arrTourBook.length; bIndex++) { // for loop starts at 0 goes till length of arrTourBook is reached
		bOutput = bOutput + "Tour code: " + arrTourBook[bIndex].tourCode + " "
		+ "Title: " + arrTourBook[bIndex].title + " "
		+ "Number of participants: " +arrTourBook[bIndex].numPeople + "<br/>";
	}
	document.getElementById("output1").innerHTML = bOutput; // output shows Tour code: xxx Title: xxx Number of participants: xxx with xxx replaced by vaules in the array
}

// function to output stats of the array inc number of objects, total number of people and average number of people per booking
function showStats () {
	var sIndex = 0;
	var sTotal = 0;
	for (sIndex; sIndex < arrTourBook.length; sIndex++) { // for loop starts at 0 goes till length of arrTourBook is reached
		sTotal = sTotal + arrTourBook[sIndex].numPeople; // calculating total of numPeople
	}
	var avPeople = sTotal/arrTourBook.length;
	document.getElementById("output2").innerHTML = "Total Tour Bookings: " + arrTourBook.length + "<br/>"
	+ "Total number of people: " + sTotal + "<br/>"
	+ "Averagre number of people per tour: " + avPeople.toFixed(0); // output of stats with line breaks, average rounds to nearest whole figure 
}

function init() {
	document.getElementById("add").onclick = addTourBooking;
    document.getElementById("list").onclick = listBookings;
	document.getElementById("stats").onclick = showStats;
}

window.onload = init;  

