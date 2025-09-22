L.OSM.topbarPane = function (options, uiClass, buttonTitle, paneTitle) {
  const control = L.control(options);

  control.onAdd = function (map) {
    const $container = $("<div>")
      .attr("class", `control-${uiClass}`);

    const button = $("<a>")
      .attr("class", "control-button")
      .attr("href", "#")
      .on("click", toggle);

    $(L.SVG.create("svg"))
      .append($(L.SVG.create("use")).attr("href", "#icon-" + uiClass))
      .attr("class", "h-100 w-100").attr("viewBox", "0 0 16 16")
      .appendTo(button);

    if (buttonTitle) {
      button.attr("title", OSM.i18n.t(buttonTitle));
    }

    button.appendTo($container);

    const $ui = control.$ui = $("<div>")
      .attr("class", `${uiClass}-ui position-relative z-n1`);

    $("<h2 class='p-3 pb-0 pe-5 text-break'>")
      .text(OSM.i18n.t(paneTitle))
      .appendTo($ui);

    options.topbar.addPane($ui);

    this.onAddPane(map, button, $ui, toggle);

    function toggle(e) {
      e.stopPropagation();
      e.preventDefault();
      if (!button.hasClass("disabled")) {
        options.topbar.togglePane($ui, button);
      }
      $(".leaflet-control .control-button").tooltip("hide");
    }

    return $container[0];
  };

  // control.onAddPane = function (map, button, $ui, toggle) {
  // }

  return control;
};
