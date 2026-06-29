
import json

mdj = {
  "_type": "Project",
  "_id": "AAAAAAFF+h6SjaM2Hec=",
  "name": "AdvFlutter_Architecture",
  "ownedElements": [
    {
      "_type": "UMLModel",
      "_id": "AAAAAAFF+qBWK6M3Z8Y=",
      "_parent": { "$ref": "AAAAAAFF+h6SjaM2Hec=" },
      "name": "Model",
      "ownedElements": [
        {
          "_type": "UMLPackageDiagram",
          "_id": "AAAAAAFF+qBtyKM79qY=",
          "_parent": { "$ref": "AAAAAAFF+qBWK6M3Z8Y=" },
          "name": "HighLevelArchitecture",
          "defaultDiagram": True,
          "ownedViews": [
            {
              "_type": "UMLPackageView",
              "_id": "view_ui",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "pkg_ui" },
              "subViews": [
                 {
                    "_type": "UMLNameCompartmentView",
                    "_id": "view_ui_name_comp",
                    "_parent": { "$ref": "view_ui" },
                    "model": { "$ref": "pkg_ui" },
                    "subViews": [
                       {
                          "_type": "LabelView",
                          "_id": "view_ui_stereo",
                          "_parent": { "$ref": "view_ui_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": -16, "top": -16, "width": 64, "height": 13
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_ui_name",
                          "_parent": { "$ref": "view_ui_name_comp" },
                          "font": "Arial;13;1",
                          "left": 253, "top": 78, "width": 118, "height": 13,
                          "text": "ui"
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_ui_namespace",
                          "_parent": { "$ref": "view_ui_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": -16, "top": -16, "width": 73.6, "height": 13,
                          "text": "(from Model)"
                       }
                    ],
                    "font": "Arial;13;0",
                    "left": 248, "top": 73, "width": 128, "height": 23
                 }
              ],
              "font": "Arial;13;0",
              "containerChangeable": True,
              "left": 248, "top": 56, "width": 128, "height": 88,
              "nameCompartment": { "$ref": "view_ui_name_comp" }
            },
            {
              "_type": "UMLPackageView",
              "_id": "view_providers",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "pkg_providers" },
              "subViews": [
                 {
                    "_type": "UMLNameCompartmentView",
                    "_id": "view_providers_name_comp",
                    "_parent": { "$ref": "view_providers" },
                    "model": { "$ref": "pkg_providers" },
                    "subViews": [
                       {
                          "_type": "LabelView",
                          "_id": "view_providers_stereo",
                          "_parent": { "$ref": "view_providers_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": 0, "top": 0, "width": 64, "height": 13
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_providers_name",
                          "_parent": { "$ref": "view_providers_name_comp" },
                          "font": "Arial;13;1",
                          "left": 85, "top": 214, "width": 118, "height": 13,
                          "text": "providers"
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_providers_namespace",
                          "_parent": { "$ref": "view_providers_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": 0, "top": 0, "width": 73.6, "height": 13,
                          "text": "(from Model)"
                       }
                    ],
                    "font": "Arial;13;0",
                    "left": 80, "top": 209, "width": 128, "height": 23
                 }
              ],
              "font": "Arial;13;0",
              "containerChangeable": True,
              "left": 80, "top": 192, "width": 128, "height": 88,
              "nameCompartment": { "$ref": "view_providers_name_comp" }
            },
            {
              "_type": "UMLPackageView",
              "_id": "view_domain",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "pkg_domain" },
              "subViews": [
                 {
                    "_type": "UMLNameCompartmentView",
                    "_id": "view_domain_name_comp",
                    "_parent": { "$ref": "view_domain" },
                    "model": { "$ref": "pkg_domain" },
                    "subViews": [
                       {
                          "_type": "LabelView",
                          "_id": "view_domain_stereo",
                          "_parent": { "$ref": "view_domain_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": 0, "top": 0, "width": 64, "height": 13
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_domain_name",
                          "_parent": { "$ref": "view_domain_name_comp" },
                          "font": "Arial;13;1",
                          "left": 421, "top": 214, "width": 118, "height": 13,
                          "text": "domain"
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_domain_namespace",
                          "_parent": { "$ref": "view_domain_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": 0, "top": 0, "width": 73.6, "height": 13,
                          "text": "(from Model)"
                       }
                    ],
                    "font": "Arial;13;0",
                    "left": 416, "top": 209, "width": 128, "height": 23
                 }
              ],
              "font": "Arial;13;0",
              "containerChangeable": True,
              "left": 416, "top": 192, "width": 128, "height": 88,
              "nameCompartment": { "$ref": "view_domain_name_comp" }
            },
            {
              "_type": "UMLPackageView",
              "_id": "view_core",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "pkg_core" },
              "subViews": [
                 {
                    "_type": "UMLNameCompartmentView",
                    "_id": "view_core_name_comp",
                    "_parent": { "$ref": "view_core" },
                    "model": { "$ref": "pkg_core" },
                    "subViews": [
                       {
                          "_type": "LabelView",
                          "_id": "view_core_stereo",
                          "_parent": { "$ref": "view_core_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": 0, "top": 0, "width": 64, "height": 13
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_core_name",
                          "_parent": { "$ref": "view_core_name_comp" },
                          "font": "Arial;13;1",
                          "left": 253, "top": 366, "width": 118, "height": 13,
                          "text": "core"
                       },
                       {
                          "_type": "LabelView",
                          "_id": "view_core_namespace",
                          "_parent": { "$ref": "view_core_name_comp" },
                          "visible": False,
                          "font": "Arial;13;0",
                          "left": 0, "top": 0, "width": 73.6, "height": 13,
                          "text": "(from Model)"
                       }
                    ],
                    "font": "Arial;13;0",
                    "left": 248, "top": 361, "width": 128, "height": 23
                 }
              ],
              "font": "Arial;13;0",
              "containerChangeable": True,
              "left": 248, "top": 344, "width": 128, "height": 88,
              "nameCompartment": { "$ref": "view_core_name_comp" }
            },
            {
              "_type": "UMLDependencyView",
              "_id": "view_dep_ui_core",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "dep_ui_core" },
              "subViews": [
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_ui_core_name", "_parent": { "$ref": "view_dep_ui_core" },
                    "model": { "$ref": "dep_ui_core" }, "visible": False, "font": "Arial;13;0", "left": 326, "top": 237, "width": 0, "height": 13,
                    "alpha": 1.57, "distance": 15, "hostEdge": { "$ref": "view_dep_ui_core" }, "edgePosition": 1
                 },
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_ui_core_stereo", "_parent": { "$ref": "view_dep_ui_core" },
                    "model": { "$ref": "dep_ui_core" }, "visible": False, "font": "Arial;13;0", "left": 341, "top": 237, "width": 0, "height": 13,
                    "alpha": 1.57, "distance": 30, "hostEdge": { "$ref": "view_dep_ui_core" }, "edgePosition": 1
                 },
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_ui_core_prop", "_parent": { "$ref": "view_dep_ui_core" },
                    "model": { "$ref": "dep_ui_core" }, "visible": False, "font": "Arial;13;0", "left": 296, "top": 237, "width": 0, "height": 13,
                    "alpha": -1.57, "distance": 15, "hostEdge": { "$ref": "view_dep_ui_core" }, "edgePosition": 1
                 }
              ],
              "font": "Arial;13;0",
              "head": { "$ref": "view_core" },
              "tail": { "$ref": "view_ui" },
              "lineStyle": 1,
              "points": "311:144;311:343",
              "showVisibility": True,
              "nameLabel": { "$ref": "view_dep_ui_core_name" },
              "stereotypeLabel": { "$ref": "view_dep_ui_core_stereo" },
              "propertyLabel": { "$ref": "view_dep_ui_core_prop" }
            },
            {
              "_type": "UMLDependencyView",
              "_id": "view_dep_ui_prov",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "dep_ui_prov" },
              "subViews": [
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_ui_prov_name", "_parent": { "$ref": "view_dep_ui_prov" },
                    "model": { "$ref": "dep_ui_prov" }, "visible": False, "font": "Arial;13;0", "left": 0, "top": 0, "width": 0, "height": 13,
                    "alpha": 1.57, "distance": 15, "hostEdge": { "$ref": "view_dep_ui_prov" }, "edgePosition": 1
                 },
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_ui_prov_stereo", "_parent": { "$ref": "view_dep_ui_prov" },
                    "model": { "$ref": "dep_ui_prov" }, "visible": False, "font": "Arial;13;0", "left": 0, "top": 0, "width": 0, "height": 13,
                    "alpha": 1.57, "distance": 30, "hostEdge": { "$ref": "view_dep_ui_prov" }, "edgePosition": 1
                 },
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_ui_prov_prop", "_parent": { "$ref": "view_dep_ui_prov" },
                    "model": { "$ref": "dep_ui_prov" }, "visible": False, "font": "Arial;13;0", "left": 0, "top": 0, "width": 0, "height": 13,
                    "alpha": -1.57, "distance": 15, "hostEdge": { "$ref": "view_dep_ui_prov" }, "edgePosition": 1
                 }
              ],
              "font": "Arial;13;0",
              "head": { "$ref": "view_providers" },
              "tail": { "$ref": "view_ui" },
              "lineStyle": 1,
              "points": "281:144;177:191",
              "showVisibility": True,
              "nameLabel": { "$ref": "view_dep_ui_prov_name" },
              "stereotypeLabel": { "$ref": "view_dep_ui_prov_stereo" },
              "propertyLabel": { "$ref": "view_dep_ui_prov_prop" }
            },
            {
              "_type": "UMLDependencyView",
              "_id": "view_dep_prov_core",
              "_parent": { "$ref": "AAAAAAFF+qBtyKM79qY=" },
              "model": { "$ref": "dep_prov_core" },
              "subViews": [
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_prov_core_name", "_parent": { "$ref": "view_dep_prov_core" },
                    "model": { "$ref": "dep_prov_core" }, "visible": False, "font": "Arial;13;0", "left": 0, "top": 0, "width": 0, "height": 13,
                    "alpha": 1.57, "distance": 15, "hostEdge": { "$ref": "view_dep_prov_core" }, "edgePosition": 1
                 },
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_prov_core_stereo", "_parent": { "$ref": "view_dep_prov_core" },
                    "model": { "$ref": "dep_prov_core" }, "visible": False, "font": "Arial;13;0", "left": 0, "top": 0, "width": 0, "height": 13,
                    "alpha": 1.57, "distance": 30, "hostEdge": { "$ref": "view_dep_prov_core" }, "edgePosition": 1
                 },
                 {
                    "_type": "EdgeLabelView", "_id": "view_dep_prov_core_prop", "_parent": { "$ref": "view_dep_prov_core" },
                    "model": { "$ref": "dep_prov_core" }, "visible": False, "font": "Arial;13;0", "left": 0, "top": 0, "width": 0, "height": 13,
                    "alpha": -1.57, "distance": 15, "hostEdge": { "$ref": "view_dep_prov_core" }, "edgePosition": 1
                 }
              ],
              "font": "Arial;13;0",
              "head": { "$ref": "view_core" },
              "tail": { "$ref": "view_providers" },
              "lineStyle": 1,
              "points": "177:280;281:343",
              "showVisibility": True,
              "nameLabel": { "$ref": "view_dep_prov_core_name" },
              "stereotypeLabel": { "$ref": "view_dep_prov_core_stereo" },
              "propertyLabel": { "$ref": "view_dep_prov_core_prop" }
            }
          ]
        },
        {
          "_type": "UMLPackage",
          "_id": "pkg_ui",
          "_parent": { "$ref": "AAAAAAFF+qBWK6M3Z8Y=" },
          "name": "ui",
          "ownedElements": [
            {
              "_type": "UMLDependency",
              "_id": "dep_ui_core",
              "_parent": { "$ref": "pkg_ui" },
              "source": { "$ref": "pkg_ui" },
              "target": { "$ref": "pkg_core" }
            },
            {
              "_type": "UMLDependency",
              "_id": "dep_ui_prov",
              "_parent": { "$ref": "pkg_ui" },
              "source": { "$ref": "pkg_ui" },
              "target": { "$ref": "pkg_providers" }
            }
          ]
        },
        {
          "_type": "UMLPackage",
          "_id": "pkg_providers",
          "_parent": { "$ref": "AAAAAAFF+qBWK6M3Z8Y=" },
          "name": "providers",
          "ownedElements": [
            {
              "_type": "UMLDependency",
              "_id": "dep_prov_core",
              "_parent": { "$ref": "pkg_providers" },
              "source": { "$ref": "pkg_providers" },
              "target": { "$ref": "pkg_core" }
            }
          ]
        },
        {
          "_type": "UMLPackage",
          "_id": "pkg_domain",
          "_parent": { "$ref": "AAAAAAFF+qBWK6M3Z8Y=" },
          "name": "domain"
        },
        {
          "_type": "UMLPackage",
          "_id": "pkg_core",
          "_parent": { "$ref": "AAAAAAFF+qBWK6M3Z8Y=" },
          "name": "core"
        }
      ]
    }
  ]
}

with open("architecture.mdj", "w") as f:
    json.dump(mdj, f, indent=2)

