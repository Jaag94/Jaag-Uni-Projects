/* Filename: w5P.js
   Target html: w5P.html
   Purpose : To validate user input of phone number. Checks lengths, character type, and first 2 digits to determine if numer is valid 
   and if number is mobile or likely landline
   Author: Jaag Eickemeyer
   Date written: 13/04/22
   Revisions:  14/04/22 v1.1 Revised by Jaag Eickemeyer
*/

// function validates the character length of the input and then validates the data type
function validatePhone (phone) {
	var valid = true;
	if (phone.length != 10) { // if phone length is not equal to 10
		valid = false;
	}
		if (isNaN(phone)) { // checks if input is not a number
			valid = false; // returns false if not a number
		}
return valid;	// returns true if length is 10 and all numbers	
}

// extracts first 2 string charcaters to then check if phone number is mobile or not
function isNumberMobile(phNum) {
	phNum = phNum.substring(0,2) // extracting first 2 characters
	if (phNum != "04") { // if first 2 charcaters dont equal "04"
		return false;
	}
	else {
		return true;	
	}
}
// function used to accept inputs, link to html elements and determine what needs to be output onto the html page
function acceptInput() {
	var phoneNo = document.getElementById("phone").value; // store refrence html label element phone
	var isPhoneValid;
	isPhoneValid = validatePhone(phoneNo); // calling validatePhone function 
	var textout = document.getElementById("msg"); // store refrence html element msg
	var isMobile;
	if (isPhoneValid == true) { // if input is valid
		isMobile = isNumberMobile(phoneNo); // calling function isNumberMobile
		if (isMobile == true) { // if mobile is true
			textout.innerHTML="Phone number valid. Phone number is mobile"; // output if the number is mobile "Phone number is mobile"
		}
		else {
			textout.innerHTML="Phone number valid. Phone number is probably landline";	// output for valid numbers that are not mobile "Phone number is probably landline"
		}			
	}
	else {
		textout.innerHTML="Phone number invalid"; // output for invalid inputs "Phone number invalid"
	}
}

function init() {
	var btn = document.getElementById("send"); // storing html button refrence
	btn.onclick = acceptInput; // calling acceptInput function with an onclick event
}

window.onload = init;  