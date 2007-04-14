function dropDownNavigation() {

    var navigation, menu, item, link;

    navigation = document.getElementById('navigation');
    if (!navigation) return;

    menu = document.getElementById('menu').getElementsByTagName('ul')[0];
    if (!menu) return;

    link = document.createElement('a');
    link.href = '#navigation';
    link.appendChild(document.createTextNode('\u25bc Sitemap'));

    link.onclick = function() {
        if (navigation.style.display == 'block') {
            navigation.style.display = 'none';
            item.className = '';
        } else {
            navigation.style.display = 'block';
            item.className = 'active';
        }
        return false;
    };

    item = document.createElement('li');
    item.appendChild(link);
    menu.appendChild(item);

}


window.onload = function() {
    dropDownNavigation();
};
