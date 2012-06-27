/* @author: Chris Barna <@ctbarna> */
$(document).ready(function () {
	$.get("http://registry.usa.gov/accounts.json?service_id=github", function (data) {
		for (var i = 0; i < data.accounts.length; i += 1) {
			$("#main").append("<h2>"+data.accounts[i].organization+"</h2><ul id=\""+data.accounts[i].account+"\"></ul>");
			$.getJSON("https://api.github.com/users/"+data.accounts[i].account+"/repos?callback=?", function (repo_data) {
				for (var j = 0; j < repo_data.data.length; j += 1) {
					$("#"+repo_data.data[j].owner.login.toLowerCase()).append("<li>"+repo_data.data[j].name+"</li>");
				}
			});
		}
	})	
});