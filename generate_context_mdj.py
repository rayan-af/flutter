
import json

def generate_context_mdj():
    mdj = {
      "_type": "Project",
      "_id": "P1",
      "name": "ContextDiagram",
      "ownedElements": [
        {
          "_type": "UMLModel",
          "_id": "M1",
          "_parent": { "$ref": "P1" },
          "name": "Model",
          "ownedElements": [
            {
              "_type": "UMLUseCaseDiagram",
              "_id": "D1",
              "_parent": { "$ref": "M1" },
              "name": "Diagramme de Contexte Statique",
              "defaultDiagram": True,
              "ownedViews": []
            }
          ]
        }
      ]
    }
    
    diagram = mdj["ownedElements"][0]["ownedElements"][0]
    views = diagram["ownedViews"]
    model_elements = mdj["ownedElements"][0]["ownedElements"]
    
    def add_actor(id, name, left, top):
        model_elements.append({
            "_type": "UMLActor",
            "_id": id,
            "_parent": { "$ref": "M1" },
            "name": name
        })
        views.append({
            "_type": "UMLActorView",
            "_id": id + "_view",
            "_parent": { "$ref": "D1" },
            "model": { "$ref": id },
            "subViews": [
                {
                    "_type": "UMLNameCompartmentView",
                    "_id": id + "_name_comp",
                    "_parent": { "$ref": id + "_view" },
                    "model": { "$ref": id },
                    "subViews": [
                        {
                            "_type": "LabelView",
                            "_id": id + "_stereo",
                            "_parent": { "$ref": id + "_name_comp" },
                            "visible": False,
                            "font": "Arial;13;0",
                            "left": left, "top": top + 60, "width": 80, "height": 13
                        },
                        {
                            "_type": "LabelView",
                            "_id": id + "_name",
                            "_parent": { "$ref": id + "_name_comp" },
                            "font": "Arial;13;1",
                            "left": left, "top": top + 60, "width": 80, "height": 13,
                            "text": name,
                            "wordWrap": True,
                            "horizontalAlignment": 2
                        },
                        {
                            "_type": "LabelView",
                            "_id": id + "_namespace",
                            "_parent": { "$ref": id + "_name_comp" },
                            "visible": False,
                            "font": "Arial;13;0",
                            "left": left, "top": top + 60, "width": 80, "height": 13,
                            "text": "(from Model)"
                        }
                    ],
                    "font": "Arial;13;0",
                    "left": left, "top": top + 55, "width": 80, "height": 23
                }
            ],
            "font": "Arial;13;0",
            "left": left, "top": top, "width": 80, "height": 80,
            "nameCompartment": { "$ref": id + "_name_comp" }
        })

    def add_class(id, name, left, top, width, height, stereo=None):
        model_elements.append({
            "_type": "UMLClass",
            "_id": id,
            "_parent": { "$ref": "M1" },
            "name": name,
            "stereotype": stereo if stereo else ""
        })
        subviews = [
            {
                "_type": "UMLNameCompartmentView",
                "_id": id + "_name_comp",
                "_parent": { "$ref": id + "_view" },
                "model": { "$ref": id },
                "subViews": [
                    {
                        "_type": "LabelView",
                        "_id": id + "_stereo",
                        "_parent": { "$ref": id + "_name_comp" },
                        "font": "Arial;13;0",
                        "left": left+5, "top": top+5, "width": width-10, "height": 13,
                        "text": "<<" + stereo + ">>" if stereo else "",
                        "visible": bool(stereo),
                        "horizontalAlignment": 2
                    },
                    {
                        "_type": "LabelView",
                        "_id": id + "_name",
                        "_parent": { "$ref": id + "_name_comp" },
                        "font": "Arial;13;1",
                        "left": left+5, "top": top+(20 if stereo else 10), "width": width-10, "height": 13,
                        "text": name,
                        "horizontalAlignment": 2
                    },
                    {
                        "_type": "LabelView",
                        "_id": id + "_namespace",
                        "_parent": { "$ref": id + "_name_comp" },
                        "visible": False,
                        "font": "Arial;13;0",
                        "left": left+5, "top": top+5, "width": width-10, "height": 13,
                        "text": "(from Model)"
                    }
                ],
                "font": "Arial;13;0",
                "left": left, "top": top, "width": width, "height": 40 if stereo else 30
            },
            {
                "_type": "UMLAttributeCompartmentView",
                "_id": id + "_attr_comp",
                "_parent": { "$ref": id + "_view" },
                "model": { "$ref": id },
                "font": "Arial;13;0",
                "left": left, "top": top+(40 if stereo else 30), "width": width, "height": 10
            },
            {
                "_type": "UMLOperationCompartmentView",
                "_id": id + "_op_comp",
                "_parent": { "$ref": id + "_view" },
                "model": { "$ref": id },
                "font": "Arial;13;0",
                "left": left, "top": top+(50 if stereo else 40), "width": width, "height": 10
            }
        ]
        
        views.append({
            "_type": "UMLClassView",
            "_id": id + "_view",
            "_parent": { "$ref": "D1" },
            "model": { "$ref": id },
            "subViews": subviews,
            "font": "Arial;13;0",
            "left": left, "top": top, "width": width, "height": height,
            "nameCompartment": { "$ref": id + "_name_comp" },
            "attributeCompartment": { "$ref": id + "_attr_comp" },
            "operationCompartment": { "$ref": id + "_op_comp" }
        })
        
    def add_dependency(id, source_id, target_id, pts, mult="0..1"):
        model_elements.append({
            "_type": "UMLDependency",
            "_id": id,
            "_parent": { "$ref": "M1" },
            "source": { "$ref": source_id },
            "target": { "$ref": target_id }
        })
        views.append({
            "_type": "UMLDependencyView",
            "_id": id + "_view",
            "_parent": { "$ref": "D1" },
            "model": { "$ref": id },
            "head": { "$ref": target_id + "_view" },
            "tail": { "$ref": source_id + "_view" },
            "lineStyle": 1,
            "points": pts,
            "font": "Arial;13;0",
            "nameLabel": {
                "_type": "EdgeLabelView",
                "_id": id + "_name",
                "_parent": { "$ref": id + "_view" },
                "model": { "$ref": id },
                "visible": True,
                "font": "Arial;13;0",
                "left": sum([int(p.split(":")[0]) for p in pts.split(";")])//2,
                "top": sum([int(p.split(":")[1]) for p in pts.split(";")])//2 - 15,
                "width": 30, "height": 13,
                "alpha": 1.57, "distance": 15, "hostEdge": { "$ref": id + "_view" }, "edgePosition": 1,
                "text": mult
            },
            "stereotypeLabel": {
                "_type": "EdgeLabelView",
                "_id": id + "_stereo",
                "_parent": { "$ref": id + "_view" },
                "model": { "$ref": id },
                "visible": False,
                "font": "Arial;13;0",
                "left": 0, "top": 0, "width": 0, "height": 13,
                "alpha": 1.57, "distance": 30, "hostEdge": { "$ref": id + "_view" }, "edgePosition": 1
            },
            "propertyLabel": {
                "_type": "EdgeLabelView",
                "_id": id + "_prop",
                "_parent": { "$ref": id + "_view" },
                "model": { "$ref": id },
                "visible": False,
                "font": "Arial;13;0",
                "left": 0, "top": 0, "width": 0, "height": 13,
                "alpha": -1.57, "distance": 15, "hostEdge": { "$ref": id + "_view" }, "edgePosition": 1
            }
        })

    # The System
    add_class("sys", "AdvFlutter System", 350, 250, 200, 200)
    
    # Stick figures
    add_actor("act_manager", "Manager", 200, 100)
    add_actor("act_chef", "Chef", 425, 70)
    add_actor("act_staff", "Staff", 650, 100)
    add_actor("act_customer", "Customer", 150, 350)
    
    # Actor Classes
    add_class("ext_firebase", "Firebase Backend", 350, 520, 150, 60, "actor")
    add_class("ext_ai", "AI Service", 650, 350, 150, 60, "actor")
    
    # Dependencies
    add_dependency("dep1", "act_manager", "sys", "240:180;350:250")
    add_dependency("dep2", "act_chef", "sys", "465:150;450:250")
    add_dependency("dep3", "act_staff", "sys", "690:180;550:250")
    add_dependency("dep4", "act_customer", "sys", "190:390;350:350")
    add_dependency("dep5", "sys", "ext_firebase", "425:450;425:520")
    add_dependency("dep6", "sys", "ext_ai", "550:350;650:380")

    with open("context_diagram.mdj", "w") as f:
        json.dump(mdj, f, indent=2)

generate_context_mdj()

