/* Author: Theodosis Tsaklanos - 8170136
 * Author: Paris Mpampaniotis - 8170080
 */
function clearAllFilters(cb) {
    var checkBoxesArray = document.getElementsByName(cb);
    for (var i = 0; i < checkBoxesArray.length; i++) {
        checkBoxesArray[i].checked = false;
    }
}

function resetForm() {
    document.getElementById("review_product").reset();
    for(var i = 2; i <= 5; i++) {
        document.getElementById(i).style.color = "#606060";
    }
}
function fillStars(id) {
	document.getElementById('rating').value = id;
	for(var i = 1; i <= 5; i++) {
		var color = "#606060";
		if(i <= id) {
			color = "#315b96";
		}
		document.getElementById(i).style.color = color;
	}
}
