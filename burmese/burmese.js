const parse = peg$parse;

function convert(text){
    var $div_result = $("#div-result");


    $div_result.empty();
    text.split("\n").forEach(line => {

	var $div_line = $("<div></div>", {style: "float: none; clear: both;"});


	const parsed = parse(line);

	parsed.forEach(elem => {

	    var $table = $("<table></table>", {"class": "table-segment"});

	    
	    if(typeof(elem) == "string"){
		if(elem == "") return;
		$table.append(
		    $("<tr></tr>").append($("<td></td>", {text: elem})),
		    $("<tr></tr>").append($("<td></td>", {style: "white-space: pre;", text: " "})),
		    $("<tr></tr>").append($("<td></td>", {style: "white-space: pre;", text: " "}))
		);
	    }else{
		var $prons = $("<div></div>");
		
		elem["pron"].forEach(x => {
		    var $list = $("<select></select>");
		    x.forEach(p => {
			$list.append($("<option></option>", {text: p}));
		    });
		    $prons.append($list);
		});
		var $my = $("<a></a>", {
		    text: elem["my"],
		});

		$table.append(
		    $("<tr></tr>").append($("<td></td>").append($my)),
		    $("<tr></tr>").append($("<td></td>", {text: elem["mlc"]})),
		    $("<tr></tr>").append($("<td></td>").append($prons))
		);
	    }

	    $div_line.append(
		$table
	    );
	});

	
	$div_result.append(
	    $("<div></div>", {style: "float: none; clear: both;", text: line}),
	    $div_line
	);
    });
}
