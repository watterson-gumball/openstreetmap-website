L.OSM.measure = function (options) {
  const control = L.OSM.topbarPane(options, "measure", null, "javascripts.measure.title");

  control.onAddPane = function (map, button, $ui, toggle) {
    control._measure = new L.Control.Measure({
      primaryLengthUnit: "meters",
      secondaryLengthUnit: "kilometers",
      primaryAreaUnit: "sqmeters",
      secondaryAreaUnit: "hectares",
      activeColor: "#f79e5a",
      completedColor: "#eab676",
    });

    control._measure.onAdd(map);

    $(control._measure.$interaction).appendTo($ui).find("h3, p").remove();
    control._measure._collapse = function () {};

    $ui
      .on("show", shown)
      .on("hide", hidden);

    function handleClose(e) {
      if (options.topbar.state.get(control.$ui) === 'hidden') return;
      toggle(e.originalEvent)
    }

    map.on('click', handleClose);

    function shown() {
      control._measure._expand();
      control._measure._locked = true;
    }

    function hidden() {
      if (!control._measureVertexes) return;
      control._measure._finishMeasure();
      control._measure._locked = true;
    }
  };

  return control;
};
