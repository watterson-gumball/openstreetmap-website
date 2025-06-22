L.OSM.subSidebarPane = function (options, uiClass, buttonTitle, paneTitle) {
  const control = L.control(options);

  control._isActive = false;

  control.enableButton = function () {
    this._button?.removeClass("disabled");
  };

  control.disableButton = function () {
    this._button?.addClass("disabled");
  };

  control.Activate = function() {
    control._isActive = true;
  };

  control.deActivate = function() {
    control._isActive = false;
  };

  control.onAdd = function (map) {
    const $container = $("<div>")
      .attr("class", "control-" + uiClass);

    const button = $("<a>")
      .attr("class", "control-button disabled")
      .attr("href", "#")
      .on("click", toggle);

    $(L.SVG.create("svg"))
      .append($(L.SVG.create("use")).attr("href", "#icon-layers"))
      .attr("class", "h-100 w-100")
      .appendTo(button);

    if (buttonTitle) {
      button.attr("title", OSM.i18n.t(buttonTitle));
    }

    button.appendTo($container);

    const $ui = $("<div>")
      .attr("class", `${uiClass}-ui position-relative z-n1`)
      .data("name", uiClass);

    $("<h2 class='p-3 pb-0 pe-5 text-break'>")
      .text(OSM.i18n.t(paneTitle))
      .appendTo($ui);

    options.subSidebar.addPane($ui);

    control._button = button;

    this.onAddPane(map, button, $ui, toggle);

    function toggle(e) {
      e?.stopPropagation();
      e?.preventDefault();

      if (!button.hasClass("disabled")) {
        // control._isActive = !control._isActive;
        options.subSidebar.togglePane($ui, button);
      }
      $(".leaflet-control .control-button").tooltip("hide");
    }

    return $container[0];
  };

  // control.onAddPane = function (map, button, $ui, toggle) {
  // }

  return control;
};
