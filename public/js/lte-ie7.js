/* Load this script using conditional IE comments if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'Portfolio-Icons\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-portfolioiconmonstr-dribbble-4-icon' : '&#xe000;',
			'icon-portfolioiconmonstr-edit-4-icon' : '&#xe001;',
			'icon-portfolioiconmonstr-eye-7-icon' : '&#xe002;',
			'icon-portfolioiconmonstr-home-4-icon' : '&#xe003;',
			'icon-portfolioiconmonstr-favorite-4-icon' : '&#xe004;',
			'icon-portfolioiconmonstr-gear-5-icon' : '&#xe005;',
			'icon-portfolioiconmonstr-github-10-icon' : '&#xe006;',
			'icon-portfolioiconmonstr-linkedin-4-icon' : '&#xe007;',
			'icon-portfolioiconmonstr-twitter-4-icon' : '&#xe008;',
			'icon-portfolioiconmonstr-user-icon' : '&#xe009;',
			'icon-portfolionoun_project_195' : '&#xe00a;',
			'icon-portfolionoun_project_1185' : '&#xe00b;',
			'icon-portfolionoun_project_2824' : '&#xe00c;',
			'icon-portfolionoun_project_2830' : '&#xe00d;',
			'icon-portfolionoun_project_5430' : '&#xe00e;',
			'icon-portfolionoun_project_10602' : '&#xe00f;',
			'icon-portfolionoun_project_4500' : '&#xe010;',
			'icon-portfolionoun_project_16711' : '&#xe011;',
			'icon-portfolionoun_project_16301' : '&#xe012;',
			'icon-portfoliobehance' : '&#xe013;',
			'icon-portfolioiconmonstr-laptop-4-icon' : '&#xe014;',
			'icon-portfoliopencil' : '&#xe015;',
			'icon-portfolioscreen' : '&#xe016;',
			'icon-portfoliouser' : '&#xe017;',
			'icon-portfolioaccessibility' : '&#xe018;',
			'icon-portfolioheart' : '&#xe019;',
			'icon-portfolioheart-2' : '&#xe01a;',
			'icon-portfolioclose' : '&#xe01b;',
			'icon-portfolioshuffle' : '&#xe01c;',
			'icon-portfolioloop' : '&#xe01d;',
			'icon-portfolioampersand' : '&#xe01e;',
			'icon-portfoliocode' : '&#xe01f;',
			'icon-portfolioth' : '&#xf00a;',
			'icon-portfolioth-list' : '&#xf00b;',
			'icon-portfolioth-large' : '&#xf009;',
			'icon-portfolioremove-sign' : '&#xf057;',
			'icon-portfoliominus-sign' : '&#xf056;',
			'icon-portfolioplus-sign' : '&#xf055;',
			'icon-portfoliook-sign' : '&#xf058;',
			'icon-portfoliochevron-right' : '&#xf054;',
			'icon-portfoliochevron-left' : '&#xf053;',
			'icon-portfoliocalendar' : '&#xf073;',
			'icon-portfoliocog' : '&#xe020;',
			'icon-portfoliofeed' : '&#xe021;',
			'icon-portfoliophone' : '&#xe022;',
			'icon-portfoliouser-2' : '&#xe023;',
			'icon-portfolioglobe' : '&#xe024;',
			'icon-portfolioenvelope-alt' : '&#xf0e0;',
			'icon-portfolioemail' : '&#xe025;',
			'icon-portfoliorefresh' : '&#xe026;',
			'icon-portfolioloop-2' : '&#xe027;',
			'icon-portfoliolocked' : '&#xe028;',
			'icon-portfoliounlocked' : '&#xe029;',
			'icon-portfoliovolume-mute' : '&#xe02a;',
			'icon-portfoliovolume-medium' : '&#xe02b;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/icon-portfolio[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};