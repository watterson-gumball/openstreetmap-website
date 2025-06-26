L.OSM.documents = function (options) {
  const control = L.OSM.sidebarPane(options, "documents", "javascripts.documents.title", "javascripts.documents.header");

  control.onAddPane = function (map, button, $ui) {
    const $section = $("<div>")
      .attr("class", "p-3")
      .appendTo($ui);

    $ui
      .on("show", shown);

    function shown() {
      fetch("/documents")
        .then(r => r.text())
        .then(html => { $section.html(html); });
    }
  };

  return control;
};