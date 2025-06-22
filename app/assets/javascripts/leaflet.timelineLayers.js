L.OSM.timelineLayers = function (options) {
  const control = L.OSM.subSidebarPane(options, "timeline-layers", "javascripts.map.timeline_layers.title", "javascripts.map.timeline_layers.header");

  control.onAddPane = function (map, button, $ui, toggle) {
    const timelineLayerGroup = L.layerGroup().addTo(map);

    const layers = options.layers;

    const baseSection = $("<div>")
      .attr("class", "base-timeline-layers d-grid gap-3 p-3 border-secondary-subtle")
      .appendTo($ui);

    layers.forEach(function (layer, i) {
      const id = "sub-map-ui-layer-" + i;

      const buttonContainer = $("<div class='position-relative'>")
        .appendTo(baseSection);

      const mapContainer = $("<div class='position-absolute top-0 start-0 bottom-0 end-0 z-0 bg-body-secondary'>")
        .appendTo(buttonContainer);

      const input = $("<input type='checkbox' class='btn-check' name='timeline-layer'>")
        .prop("id", id)
        .prop("checked", map.hasLayer(layer))
        .appendTo(buttonContainer);

      const item = $("<label class='btn btn-outline-primary border-4 rounded-3 bg-transparent position-absolute p-0 h-100 w-100 overflow-hidden'>")
        .prop("for", id)
        .append($("<span class='badge position-absolute top-0 start-0 rounded-top-0 rounded-start-0 py-1 px-2 bg-body bg-opacity-75 text-body text-wrap text-start fs-6 lh-base'>").append(layer.options.name))
        .appendTo(buttonContainer);

      map.whenReady(function () {
        const miniMap = L.map(mapContainer[0], { attributionControl: false, zoomControl: false, keyboard: false });
        miniMap.createPane("timelinePane");
        miniMap.addLayer(new layer.constructor(layer.options));

        miniMap.dragging.disable();
        miniMap.touchZoom.disable();
        miniMap.doubleClickZoom.disable();
        miniMap.scrollWheelZoom.disable();

        $ui
          .on("show", shown)
          .on("hide", hide);

        function shown() {
          miniMap.invalidateSize();
          setView({ animate: false });
          map.on("moveend", moved);
        }

        function hide() {
          map.off("moveend", moved);
        }

        function moved() {
          setView();
        }

        function setView(options) {
          miniMap.setView(map.getCenter(), Math.max(map.getZoom() - 2, 0), options);
        }
      });

      $ui
        .on("show", control.Activate)
        .on("hide", control.deActivate);

      options.subSidebar.on("sidebar:layers-show", layersShowHandler);
      options.subSidebar.on("sidebar:layers-hide", layersHideHandler);

      function layersShowHandler() {
        control.enableButton();
      }

      function layersHideHandler() {
        if (control._isActive) toggle();

        control.disableButton();
      }

      input.on("click", function () {
        if (map.hasLayer(layer)) {
          map.removeLayer(layer);
          return;
        }

        map.addLayer(layer);
      });

      // item.on("dblclick", toggle);

      map.on("baselayerchange", function () {
        input.prop("checked", timelineLayerGroup.hasLayer(layer));
      });
    });
  };

  return control;
};