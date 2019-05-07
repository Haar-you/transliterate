{
    const has_medial_y = 1;
    const has_medial_r = 2;
    const has_medial_w = 4;
    const has_medial_h = 8;


    const fin_stop = "ʔ";
    const fin_nasal = "ɴ";

    const high_tone = "́";
    const low_tone = "̀";
    const falling_tone = "̰";

    const high_tone_my = "း";
    const falling_tone_my = "့"

    const consonant_romanize = {
	"က": "k", "ခ": "hk", "ဂ": "g", "ဃ": "gh", "င": "ng",
	"စ": "c", "ဆ": "hc", "ဇ": "j", "ဈ": "jh", "ဉ": "ny", "ည": "ny",
	"ဋ": "t", "ဌ": "ht", "ဍ": "d", "ဎ": "dh", "ဏ": "n",
	"တ": "t", "ထ": "ht", "ဒ": "d", "ဓ": "dh", "န": "n",
	"ပ": "p", "ဖ": "hp", "ဗ": "b", "ဘ": "bh", "မ": "m",
	"ယ": "y", "ရ": "r", "လ": "l", "ဝ": "w", "သ": "s",
	"ဟ": "h", "ဠ": "l", "အ": "", "ံ": "m"
    };

    const digit_convert = {

	"၀": 0, "၁": 1, "၂": 2, "၃": 3, "၄": 4, "၅": 5, "၆": 6, "၇": 7, "၈": 8, "၉": 9
    };

    const digit_pron = {
	0: "θòʊɴɲa̰", 1: "tɪʔ", 2: "n̥ɪʔ", 3: "θóʊɴ", 4: "lé", 5: "ŋá", 6: "tɕʰaʊʔ", 7: "kʰʊ̀ɴ n̥ɪʔ", 8: "ʃɪʔ", 9: "kó"
    }

    const digit_pron_weakened = {
    	0: "θòʊɴɲa̰", 1: "tə", 2: "n̥ə", 3: "θóʊɴ", 4: "lé", 5: "ŋá", 6: "tɕʰaʊʔ", 7: "kʰʊ̀ɴ n̥ə", 8: "ʃɪʔ", 9: "kó"
    }
}

start
    = (burmese_segment / burmese_digit / burmese_sign / space / other) *

space
    = (" " / "　" / "\t")+{
	return "";
    }

burmese_segment
    = seg:(burmese_syllable / burmese_indep_vowel / burmese_symbol)+{
	const my = seg.map(x => x["my"]).join("");
	const mlc = seg.map(x => x["mlc"]).join(" ");
	const pron = seg.map(x => x["pron"]);

	return {
	    my: my,
	    mlc: mlc,
	    pron: pron
	};
    }


other
    = str:.

burmese_indep_vowel
    = vowel:("ဣ" / "ဤ" / "ဥ" / "ဦး" / "ဦ" / "ဧည့်" / "ဧ" / "ဩ" / "ဪ"){
	var pron = [];
	var mlc = "";
	
	switch(vowel){
	case "ဣ":{
	    pron = ["ʔḭ"];
	    mlc = "i.";
	    break;
	}
	case "ဤ":{
	    pron = ["ʔì"];
	    mlc = "i";
	    break;
	}
	case "ဥ":{
	    pron = ["ʔu" + falling_tone];
	    mlc = "u.";
	    break;
	}
	case "ဦ":{
	    pron = ["ʔu" + low_tone];
	    mlc = "u";
	    break;
	}
	case "ဦး":{
	    pron = ["ʔu" + high_tone];
	    mlc = "u";
	    break;
	}
	case "ဧ":{
	    pron = ["ʔe" + low_tone];
	    mlc = "e";
	    break;
	}
	case "ဧည့်":{
	    pron = ["ʔe" + falling_tone];
	    mlc = "eny.";
	    break;
	}
	case "ဩ":{
	    pron = ["ʔɔ́"];
	    mlc = "au:";
	    break;
	}
	case "ဪ":{
	    pron = ["ʔɔ̀"];
	    mlc = "au";
	    break;
	}
	}

	return {
	    my: vowel,
	    mlc: mlc,
	    pron: pron
	}
    }

burmese_digit
    = num:[၀၁၂၃၄၅၆၇၈၉]+{
	var my = num.join("");
	var mlc = "";
	var pron = [];

	mlc = num.map(x => digit_convert[x]).join("");

	
	while(1){
	    {
		var c = num.pop();
		if(!c) break;

		if(digit_convert[c] != 0) pron.push(digit_pron[digit_convert[c]]);
	    }

	    {
		var c = num.pop();
		if(!c) break;

		switch(digit_convert[c]){
		case 3: case 4: case 5: case 9:
		    pron.push("zɛ̀");
		    break;
		default:
		    pron.push("sʰɛ̀");
		}
		    
		if(digit_convert[c] != 0) pron.push(digit_pron_weakened[digit_convert[c]]);		
	    }

	    {
		var c = num.pop();
		if(!c) break;

		pron.push("jà");
		if(digit_convert[c] != 0) pron.push(digit_pron_weakened[digit_convert[c]]);		
	    }

	    {
		var c = num.pop();
		if(!c) break;

		switch(digit_convert[c]){
		case 3: case 4: case 5: case 9:
		    pron.push("da̰ʊɴ");
		    break;
		default:
		    pron.push("tʰàʊɴ");
		}

		if(digit_convert[c] != 0) pron.push(digit_pron_weakened[digit_convert[c]]);		
	    }

	    {
		var c = num.pop();
		if(!c) break;

		switch(digit_convert[c]){
		case 3: case 4: case 5: case 9:
		    pron.push("ðáʊɴ");
		    break;
		default:
		    pron.push("θáʊɴ");
		}
		
		if(digit_convert[c] != 0) pron.push(digit_pron_weakened[digit_convert[c]]);		
	    }
	    
	    {
		var c = num.pop();
		if(!c) break;

		switch(digit_convert[c]){
		case 3: case 4: case 5: case 9:
		    pron.push("ðéɪɴ");
		    break;
		default:
		    pron.push("θéɪɴ");
		}
		
		if(digit_convert[c] != 0) pron.push(digit_pron_weakened[digit_convert[c]]);		
	    }
	    
	    {
		var c = num.pop();
		if(!c) break;

		switch(digit_convert[c]){
		case 3: case 4: case 5: case 9:
		    pron.push("ðáɴ");
		    break;
		default:
		    pron.push("θáɴ");
		}

		if(digit_convert[c] != 0) pron.push(digit_pron_weakened[digit_convert[c]]);		
	    }
	}


	pron.reverse();
	pron = pron.join(" ");
	
	

	
	return {
	    my: my,
	    mlc: mlc,
	    pron: [[pron]]
	}
    }

burmese_symbol
    = symbol:("၌"/"၍"/"၎င်း"/"၏"){
	var pron = [];
	var mlc = "";
	
	switch(symbol){
	case "၌":{
	    pron = ["n̥aiʔ"];
	    mlc = "hnai.";
	    break;
	}
	case "၍":{
	    pron = ["jwé"];
	    mlc = "rwe";
	    break;
	}
	case "၏":{
	    pron = ["ʔḭ"];
	    mlc = "e";
	    break;
	}
	case "၎င်း":{
	    pron = ["la̰ ɡàuɴ"];
	    mlc = "la. kaung";
	    break;
	}
	}
	
	return {
	    my: symbol,
	    mlc: mlc,
	    pron: pron
	}
    }

burmese_sign
    = [၊။]

burmese_syllable
    = onset:onset rhyme:rhyme{
	var pron = [];

	onset["pron"].forEach(x => {
	    rhyme["pron"].forEach(y => {
		pron.push(x+y);
	    })
	});	 

	return {
	    my: onset["my"] + rhyme["my"],
	    mlc: onset["mlc"] + rhyme["mlc"],
	    pron: pron
	};
    }

rhyme
    = vowel:vowel fin_cons:(final_consonant/anusvara)* tone:(high_tone_mark/falling_tone_mark)?{
	var pron = [];
	var mlc = "";

	if(fin_cons.length > 0){
	    switch(vowel){
	    case "": case "ာ": case "ါ":{
		mlc = "a";
		pron = [];
		break;
	    }
	    case "ိ":{
		mlc = "i";
		pron = ["ei"];
		break;
	    }
	    case "ု":{
		mlc = "u";
		pron = ["oʊ"];
		break;
	    }
	    case "ေ":{
		mlc = "e";
		pron = [];
		break;
	    }
	    case "ော": case "ေါ":{
		mlc = "au";
		pron = ["aʊ"];
		break;
	    }
	    case "ို":{
		mlc = "ui";
		pron = ["ai"];
		break;
	    }
	    }

	    mlc += fin_cons.map(x => consonant_romanize[x[1]]).join("");

	    switch(fin_cons[0][1]){

	    case "က": case "ခ": case "ဂ": case "ဃ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["ɛ"+fin_stop];
		else pron = pron.map(s => s+fin_stop);
		break;
	    }
	    case "င":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["i"+fin_nasal];
		else pron = pron.map(s => s+fin_nasal);
		
		break;
	    }
	    case "စ": case "ဆ": case "ဇ": case "ဈ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["i"+fin_stop];
		else pron = pron.map(s => s+fin_stop);

		break;
	    }
	    case "ဉ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["i"+fin_nasal];
		else pron = pron.map(s => s+fin_nasal);
		
		break;
	    }
	    case "ည":{
		pron = ["i", "e", "ɛ"];
		break;
	    }
		
	    case "ဋ": case "ဌ": case "ဍ": case "ဎ": case "တ": case "ထ": case "ဒ": case "ဓ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_stop];
		else if(vowel == "ေ") pron = ["i"+fin_stop];
		else pron = pron.map(s => s+fin_stop);
		break;
	    }
	    case "ဏ": case "န":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_nasal];
		else if(vowel == "ေ") pron = ["i"+fin_nasal];
		else pron = pron.map(s => s+fin_nasal);
		break;
	    }

	    case "ပ": case "ဖ": case "ဗ": case "ဘ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_stop];
		else pron = pron.map(s => s+fin_stop);
		break;
	    }
	    case "မ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_nasal];
		else pron = pron.map(s => s+fin_nasal);
		break;
	    }

	    case "ံ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_nasal];
		else pron = pron.map(s => s+fin_nasal);
		break;
	    }

	    case "ယ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ"){
		    mlc = ["ai"];
		    pron = ["ɛ"];
		}
		else if(vowel == "ိ") pron = ["i"];
		else if(vowel == "ု") pron = ["u"];
		else if(vowel == "ေ") pron = ["e"];
		else if(vowel == "ော") pron = ["ɔ"];
		else if(vowel == "ို") pron = ["o"];
		break;
	    }
	    case "ရ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_nasal];
		else if(vowel == "ေ") pron = ["e"];
		else if(vowel == "ို") pron = ["o"];
		else pron = pron.map(s => s+fin_nasal);

		break;
	    }
	    case "လ": case "ဠ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_nasal];
		else if(vowel == "ို") pron = ["o"];
		else pron = pron.map(s => s+fin_nasal);
		break;
	    }	
	    case "ဝ":{
		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["ɔ"];
		break;
	    }	
	    case "သ":{

		if(vowel == "" || vowel == "ာ" || vowel == "ါ") pron = ["a"+fin_nasal];
		else if(vowel == "ေ") pron = ["i"+fin_stop, "e"];
		else pron = pron.map(s => s+fin_nasal);
		break;
	    }	
	    case "ဟ":{
		if(vowel == "ို") pron = ["o"];
		else pron = pron.map(s => s+fin_nasal);

		break;
	    }
	    }

	    if(tone == high_tone_my){
		pron = pron.map(x => {
		    if(x[x.length-1] != fin_stop){
			return x[0] + high_tone + x.slice(1);
		    }else{
			return x;
		    }
		});

		mlc += ":";
	    }
	    else if(tone == falling_tone_my || fin_cons[2]){
		pron = pron.map(x => {
		    if(x[x.length-1] != fin_stop){
			return x[0] + falling_tone + x.slice(1);
		    }else{
			return x;
		    }
		});

		mlc += ".";
	    }else{
		pron = pron.map(x => {
		    if(x[x.length-1] != fin_stop){
			return x[0] + low_tone + x.slice(1);
		    }else{
			return x;
		    }
		});	    
	    }

	    
	}else{
	    switch(vowel){
	    case "":{
		pron = ["a"+falling_tone];
		mlc = "a.";
		break;
	    }
	    case "ာ": case "ါ":{
		pron = ["a"+low_tone];
		mlc = "a";
		if(tone == high_tone_my){
		    pron = ["a"+high_tone];
		    mlc = "a:";
		}
		break;
	    }
	    case "ိ":{
		pron = ["i"+falling_tone]
		mlc = "i.";
		break;
	    }
	    case "ီ":{
		pron = ["i"+low_tone];
		mlc = "i";
		if(tone == high_tone_my){
		    pron = ["i"+high_tone];
		    mlc = "i:";
		}
		break;
	    }
	    case "ု":{
		pron = ["u"+falling_tone];
		mlc = "u.";
		break;
	    }
	    case "ူ":{
		pron = ["u"+low_tone];
		mlc = "u";
		if(tone == high_tone_my){
		    pron = ["u"+high_tone];
		    mlc = "u:";
		}
		break;
	    }
	    case "ေ":{
		pron = ["e"+low_tone];
		mlc = "e";
		if(tone == high_tone_my){
		    pron = ["e"+high_tone];
		    mlc = "e:";
		}else if(tone == falling_tone){
		    pron = ["e"+falling_tone];
		    mlc = "e.";
		}
		break;
	    }
	    case "ဲ":{
		pron = ["ɛ"+high_tone];
		mlc = "ai:";
		if(tone == falling_tone){
		    pron = ["ɛ"+falling_tone];
		    mlc = "ai.";
		}
		break;
	    }
	    case "ော": case "ေါ":{
		pron = ["o"+high_tone];
		mlc = "au:";
		if(tone == falling_tone){
		    pron = ["o"+falling_tone];
		    mlc = "au.";
		}
		break;
	    }
	    case "ော်": case "ေါ်":{
		pron = ["o"+low_tone];
		mlc = "au";
		break;
	    }
	    case "ို":{
		pron = ["ɔ"+low_tone];
		mlc = "ui";
		if(tone == high_tone_my){
		    pron = ["ɔ"+high_tone];
		    mlc = "ui:";
		}else if(tone == falling_tone){
		    pron = ["ɔ"+falling_tone];
		    mlc = "ui.";
		}
		break;
	    }
	    }

	    pron.push("ə");
	}

	var my = (vowel||"") + (fin_cons?fin_cons.map(x => x[0]).join(""):"") + (tone||"");

	return {
	    my: my,
	    mlc: mlc,
	    pron: pron
	}
    }


vowel
    = "ော်" / "ေါ်" / "ို" / "ော" / "ေါ" / "ာ" / "ါ" / "ိ" / "ီ" / "ု" / "ူ" / "ေ" / "ဲ" / ""

final_consonant
    = fin_cons:[ကခဂဃငစဆဇဈဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠအ] tone:falling_tone_mark? con:('်'/'္')+{
	return [(fin_cons||"")+(tone||"")+con.join(""), fin_cons, tone];
    }

anusvara
    = 'ံ' tone:falling_tone_mark?{
	return ['ံ'+(tone||""), 'ံ', tone];
    }

high_tone_mark = 'း'
falling_tone_mark = "့"






onset
    = init_cons:initial_consonant medi_cons:medial_consonant {
	var pron = [];
	var mlc = "";

	var my = init_cons;
	if(medi_cons & has_medial_y) my += "ျ";
	if(medi_cons & has_medial_r) my += "ြ";
	if(medi_cons & has_medial_w) my += "ွ";
	if(medi_cons & has_medial_h) my += "ှ";
	
	
	switch(init_cons){
	case "က":{
	    pron = ["k", "g"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = ["tɕ", "dʑ"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ခ":{
	    pron = ["kʰ", "g"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = ["tɕʰ", "dʑ"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဂ":{
	    pron = ["g"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = ["dʑ"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဃ":{
	    pron = ["g"];
	    break;
	}
	case "င":{
	    pron = ["ŋ"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = ["ɲ"];
	    if(medi_cons & has_medial_h) pron = pron.map(s => s+"̊");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "စ":{
	    pron = ["s", "z"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဆ":{
	    pron = ["sʰ", "z"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဇ":{
	    pron = ["z"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဈ":{
	    pron = ["z"];
	    break;
	}
	case "ဉ": case "ည":{
	    pron = ["ɲ"];
	    if(medi_cons & has_medial_h) pron = pron.map(s => s+"̊");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဋ":{
	    pron = ["t", "d"];
	    break;
	}
	case "ဌ":{
	    pron = ["tʰ", "d"];
	    break;
	}
	case "ဍ":{
	    pron = ["d"];
	    break;
	}
	case "ဎ":{
	    pron = ["d"];
	    break;
	}
	case "ဏ":{
	    pron = ["n"];
	    break;
	}
	case "တ":{
	    pron = ["t", "d"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ထ":{
	    pron = ["tʰ", "d"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဒ":{
	    pron = ["d"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဓ":{
	    pron = ["d"];
	    break;
	}
	case "န":{
	    pron = ["n"];
	    if(medi_cons & has_medial_h) pron = pron.map(s => s+"̥");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ပ":{
	    pron = ["p", "b"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = pron.map(s => s+"j");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဖ":{
	    pron = ["pʰ", "b"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = pron.map(s => s+"j");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဗ":{
	    pron = ["b"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = pron.map(s => s+"j");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဘ":{
	    pron = ["b", "pʰ"];
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = pron.map(s => s+"j");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "မ":{
	    pron = ["m"];
	    if(medi_cons & has_medial_h) pron = pron.map(s => s+"̥");
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = pron.map(s => s+"j");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ယ":{
	    pron = ["j"];
	    if(medi_cons & has_medial_h) pron = ["ʃ"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ရ":{
	    pron = ["j", "r"];
	    if(medi_cons & has_medial_h) pron = ["ʃ"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "လ":{
	    pron = ["l"];
	    if(medi_cons & has_medial_h) pron = pron.map(s => s+"̥");
	    if((medi_cons & has_medial_y) || (medi_cons & has_medial_r)) pron = pron.map(s => s+"j");
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဝ":{
	    pron = ["w"];
	    if(medi_cons & has_medial_h) pron = ["ʍ"];
	    break;
	}
	case "သ":{
	    pron = ["θ", "ð"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    if((medi_cons & has_medial_y) & (medi_cons & has_medial_h)) pron = ["ʃ"];
	    break;
	}
	case "ဟ":{
	    pron = ["h"];
	    if(medi_cons & has_medial_w) pron = pron.map(s => s+"w");
	    break;
	}
	case "ဠ":{
	    pron = ["l"];
	    break;
	}
	case "အ":{
	    pron = ["ʔ"];
	    break;
	}
	}

	mlc = consonant_romanize[init_cons];

	if(medi_cons & has_medial_y) mlc += "y";
	if(medi_cons & has_medial_r) mlc += "r";
	if(medi_cons & has_medial_w) mlc += "w";
	if(medi_cons & has_medial_h) mlc = "h" + mlc;
	
	return {
	    my: my,
	    mlc: mlc,
	    pron: pron
	}
    }

initial_consonant
    = [ကခဂဃငစဆဇဈဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠအ]

medial_consonant
    = medi_y:medial_y? medi_r:medial_r? medi_w:medial_w? medi_h:medial_h?{
	return (medi_y?1:0) + (medi_r?2:0) + (medi_w?4:0) + (medi_h?8:0);
    }

medial_h = 'ှ'
medial_w = 'ွ'
medial_y = 'ျ'
medial_r = 'ြ'
