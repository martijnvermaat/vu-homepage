function pimpSitemap() {

    var sitemap, menu, item, link;

    sitemap = document.getElementById('sitemap');
    if (!sitemap) return;

    menu = document.evaluate("//div[@id='menu']/ul",
                             document,
                             null,
                             XPathResult.FIRST_ORDERED_NODE_TYPE,
                             null).singleNodeValue;
    if (!menu) return;

    link = document.createElement('a');
    link.href = '#';
    link.appendChild(document.createTextNode('Sitemap'));

    link.onclick = function() {
        if (sitemap.style.display == 'block') {
            sitemap.style.display = 'none';
            item.className = '';
        } else {
            sitemap.style.display = 'block';
            item.className = 'active';
        }
    };

    item = document.createElement('li');
    item.appendChild(link);
    menu.appendChild(item);

}


window.onload = function() {
    pimpSitemap();
};


/*

                    <li><a href="" onmousedown="document.getElementById('sitemap').style.display='block'" onmouseup="document.getElementById(\
'sitemap').style.display='none'">Sitemap</a></li>
*/
