L.OSM.documents = function (options) {
  const control = L.OSM.sidebarPane(
    options,
    "documents",
    "javascripts.documents.title",
    "javascripts.documents.header",
  );

  control.onAddPane = function (map, button, $ui) {
    const $section = $("<div>").attr("class", "p-3").appendTo($ui);

    $ui.on("show", shown);

    function shown() {
      fetch("/app/documents")
        .then((r) => r.text())
        .then((html) => {
          $section.html(html);

          $section.find(".doc-section").each(function () {
            this.addEventListener("toggle", () => {
              const docList = this.querySelector(".doc-list");
              if (this.open && docList.dataset.loaded === "false") {
                const type = this.dataset.type;
                fetch(`/app/documents/by_type?type=${type}`)
                  .then((response) => response.text())
                  .then((html) => {
                    docList.innerHTML = html;
                    docList.dataset.loaded = "true";
                  });
              }
            });
          });
        });
    }
  };

  return control;
};
