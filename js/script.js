/* @author: Chris Barna <@ctbarna> */
$(document).ready(function () {
	$.get("http://registry.usa.gov/accounts.json?service_id=github", function (data) {
		for (var i = 0; i < data.accounts.length; i += 1) {
			$("#main").append("<div id=\""+data.accounts[i].account+"\" class=\"organization\"><h2>"+data.accounts[i].organization+"</h2></div>");
			$.getJSON("https://api.github.com/users/"+data.accounts[i].account+"/repos?callback=?", function (repo_data) {
				for (var j = 0; j < repo_data.data.length; j += 1) {
					var appendStr = "<div class=\"project\">";

					if (repo_data.data[j].language !== null) {
						appendStr += "<span class=\"language label\">"+repo_data.data[j].language+"</span>";
					}

					appendStr += "<span class=\"forks\"><i class=\"icon-random\"></i> "+repo_data.data[j].forks+"</span>";
					appendStr += "<span class=\"watchers\"><i class=\"icon-eye-open\"></i> "+repo_data.data[j].watchers+"</span>";

					appendStr += "<h3><a href=\""+repo_data.data[j].html_url+"\">"+repo_data.data[j].name+"</a></h3>";

					if (repo_data.data[j].description !== null) {
						appendStr += "<p>"+repo_data.data[j].description+"</p>";
					}

					$("#"+repo_data.data[j].owner.login.toLowerCase())
						.append(appendStr);
				}
			});
		}
	})	
});