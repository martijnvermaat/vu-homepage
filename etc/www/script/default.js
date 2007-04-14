function pimpSitemap() {

    var sitemap, menu, item, link;

    sitemap = document.getElementById('sitemap');
    if (!sitemap) return;

    menu = document.getElementById('menu').getElementsByTagName('ul')[0];
    if (!menu) return;

    link = document.createElement('a');
    link.href = '';
    link.appendChild(document.createTextNode('\u25bc Sitemap'));

    link.onclick = function() {
        if (sitemap.style.display == 'block') {
            sitemap.style.display = 'none';
            item.className = '';
        } else {
            sitemap.style.display = 'block';
            item.className = 'active';
        }
        return false;
    };

    item = document.createElement('li');
    item.appendChild(link);
    menu.appendChild(item);

}


window.onload = function() {
    pimpSitemap();
};
