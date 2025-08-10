L.OSM.layers = function (options) {
  const control = L.OSM.sidebarPane(options, "layers", "javascripts.map.layers.title", "javascripts.map.layers.header");

  control.onAddPane = function (map, button, $ui, toggle) {
    const layers = options.layers;

    const $baseContent = $("<div>").appendTo($ui);

    const baseSection = $("<div>")
      .attr("class", "base-layers d-grid gap-3 p-3 border-bottom border-secondary-subtle")
      .appendTo($baseContent);

    const $orthoDetails = $("<details>").appendTo($ui);
    const $summary = $("<summary>")
      .text(OSM.i18n.t("javascripts.map.layers.ortho") || "Base Layers")
      .appendTo($orthoDetails);

    const $orthoSubContent = $("<div>").appendTo($orthoDetails);

    const $orthoSubSection = $("<div>")
      .attr("class", "base-layers d-grid gap-3 p-3 border-bottom border-secondary-subtle")
      .appendTo($orthoSubContent);

    //=============

    const $planDetails = $("<details>").appendTo($ui);
    const $planSummary = $("<summary>")
      .text(OSM.i18n.t("javascripts.map.layers.plan") || "Base Layers")
      .appendTo($planDetails);

    const $planSubContent = $("<div>").appendTo($planDetails);

    const $planSubSection = $("<div>")
      .attr("class", "base-layers d-grid gap-3 p-3 border-bottom border-secondary-subtle")
      .appendTo($planSubContent);

    //=============

    addLayerButtons(layers.default, baseSection, null, null);
    addLayerButtons(layers[options.region], $orthoSubSection, $planSubSection, options.region);

    map.on("regionchange", function (e) {
      let regionalLayers = e.region === "yerevan" ? layers.yerevan : layers.gyumri;

      if (e.region === "yerevan") {
        map.options.groups.gyumri.eachLayer(l => map.options.groups.gyumri.removeLayer(l));
      }

      if (e.region === "gyumri") {
        map.options.groups.yerevan.eachLayer(l => map.options.groups.yerevan.removeLayer(l));
      }

      $orthoSubSection.empty();
      $planSubSection.empty();

      addLayerButtons(regionalLayers, $orthoSubSection, $planSubSection, e.region);
    });

    function addLayerButtons(layers, $orthoTarget, $planTarget, groupName) {
      layers.forEach(function (layer, i) {
        const id = `map-ui-layer-${groupName}` + i;

        const buttonContainer = $("<div class='position-relative'>")
          .appendTo(layer.options.layerId.startsWith("plan") ? $planTarget : $orthoTarget);

        const mapContainer = $("<div class='position-absolute top-0 start-0 bottom-0 end-0 z-0 bg-body-secondary'>")
          .appendTo(buttonContainer);

        const input = $("<input type='checkbox' class='btn-check' name='layer'>")
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

        input.on("click", function () {
          if (layer.options?.code === "M") return;
          if (map.hasLayer(layer)) {
            map.removeLayer(layer);
            return;
          }
          map.options.groups[groupName].clearLayers();

          if (groupName) {
            return map.options.groups[groupName].addLayer(layer);
          }

          map.addLayer(layer);
        });

        // item.on("dblclick", toggle);

        map.on("baselayerchange", function () {
          input.prop("checked", map.hasLayer(layer));
        });
      });
    }

    if (OSM.STATUS !== "api_offline" && OSM.STATUS !== "database_offline") {
      const overlaySection = $("<div>")
        .attr("class", "overlay-layers p-3")
        .appendTo($ui);

      $("<p>")
        .text(OSM.i18n.t("javascripts.map.layers.overlays"))
        .attr("class", "text-body-secondary small mb-2")
        .appendTo(overlaySection);

      const overlays = $("<ul class='list-unstyled form-check'>")
        .appendTo(overlaySection).sortable();

      const addOverlay = function (layer, name, maxArea) {
        const item = $("<li>")
          .appendTo(overlays);

        if (name === "notes" || name === "data") {
          item
            .attr("title", OSM.i18n.t("javascripts.site.map_" + name + "_zoom_in_tooltip"))
            .tooltip("disable");
        }

        const label = $("<label>")
          .attr("class", "form-check-label")
          .attr("id", `label-layers-${name}`)
          .appendTo(item);

        let checked = map.hasLayer(layer);

        const input = $("<input>")
          .attr("type", "checkbox")
          .attr("class", "form-check-input")
          .prop("checked", checked)
          .appendTo(label);

        label.append(layer.options.year ? `${OSM.i18n.t("javascripts.map.layers.data")} ${layer.options.year}` : OSM.i18n.t("javascripts.map.layers." + name));

        if (layer.options.year) {
          $("<div></div>")
            .prop("id", `layer-${layer.options.year}`)
            .appendTo(item);

          const pickr = Pickr.create({
            el: `#layer-${layer.options.year}`,
            theme: 'nano', // or 'monolith', or 'nano'
            default: layer.options.styles[layer.options.year].way.color,

            swatches: [
                'rgba(244, 67, 54, 1)',
                'rgba(233, 30, 99, 0.95)',
                'rgba(156, 39, 176, 0.9)',
                'rgba(103, 58, 183, 0.85)',
                'rgba(63, 81, 181, 0.8)',
                'rgba(33, 150, 243, 0.75)',
                'rgba(3, 169, 244, 0.7)',
                'rgba(0, 188, 212, 0.7)',
                'rgba(0, 150, 136, 0.75)',
                'rgba(76, 175, 80, 0.8)',
                'rgba(139, 195, 74, 0.85)',
                'rgba(205, 220, 57, 0.9)',
                'rgba(255, 235, 59, 0.95)',
                'rgba(255, 193, 7, 1)'
            ],

            components: {

                // Main components
                preview: true,
                opacity: true,
                hue: true,

                // Input / output Options
                interaction: {
                    hex: true,
                    input: true,
                    save: true
                }
            }
          });

          pickr
            .on("save", (color, instance) => {
              layer.options.styles[layer.options.year].way.color = color.toHEXA().toString();
              layer.options.styles[layer.options.year].area.color = color.toHEXA().toString();
              layer.setStyle({
                color: color.toHEXA().toString()
              });
              instance.hide();
              if (!input.is(":checked")) return;
              input.css("background-color", color.toHEXA().toString())
            })
        }

        input.on("change", function () {
          checked = input.is(":checked");
          if (layer.cancelLoading) {
            layer.cancelLoading();
          }

          if (checked) {
            map.addLayer(layer);
            if (!layer.options.year) return;
            const previousDataLayers = Cookies.get("_selected_data_layers")?.trim();
            Cookies.set("_selected_data_layers", previousDataLayers?.length ? `${previousDataLayers}|${layer.options.year}` : layer.options.year, {path: "/aero"});
            input.css("background-color", layer.options.styles[layer.options.year].way.color);
          } else {
            map.removeLayer(layer);
            const previousDataLayers = Cookies.get("_selected_data_layers")?.trim();
            Cookies.set("_selected_data_layers", previousDataLayers?.split("|").filter(d => d !== layer?.options?.year).join("|"), {path: "/aero"});
            input.css("background-color", "transparent");
            $(`#layers-${name}-loading`).remove();
          }
        });

        map.on("overlayadd overlayremove", function () {
          input.prop("checked", map.hasLayer(layer));
        });

        map.on("zoomend", function () {
          const disabled = map.getBounds().getSize() >= maxArea;
          $(input).prop("disabled", disabled);

          if (disabled && $(input).is(":checked")) {
            $(input).prop("checked", false)
              .trigger("change");
            checked = true;
          } else if (!disabled && !$(input).is(":checked") && checked) {
            $(input).prop("checked", true)
              .trigger("change");
          }

          $(item)
            .attr("class", disabled ? "disabled" : "")
            .tooltip(disabled ? "enable" : "disable");
        });
      };

      map.on("regionchange", function(e) {
        map.eachLayer(function (layer) {
          if (layer instanceof L.FeatureGroup) {
            map.removeLayer(layer);
          }
        });

        overlays.empty();

        addOverlay(map.noteLayer, "notes", OSM.MAX_NOTE_REQUEST_AREA);
        OSM.availableDataYears[e.region].forEach(year => addOverlay(map[`dataLayer${year}${e.region}`], `historydata${year}${e.region}`, OSM.MAX_REQUEST_AREA));
      });

      addOverlay(map.noteLayer, "notes", OSM.MAX_NOTE_REQUEST_AREA);
      // addOverlay(map.dataLayer, "data", OSM.MAX_REQUEST_AREA);
      // addOverlay(map.gpsLayer, "gps", Number.POSITIVE_INFINITY);
      OSM.availableDataYears[options.region].forEach(year => addOverlay(map[`dataLayer${year}${options.region}`], `historydata${year}${options.region}`, OSM.MAX_REQUEST_AREA));
    }
  };

  return control;
};
