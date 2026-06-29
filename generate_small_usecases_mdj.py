
import json
import uuid

def gen_id():
    return "AAAAA" + str(uuid.uuid4()).replace("-", "")[:15]

def create_mdj(filename, name, actors_data, usecases_data, connections):
    mdj = {
      "_type": "Project",
      "_id": gen_id(),
      "name": name,
      "ownedElements": [
        {
          "_type": "UMLModel",
          "_id": gen_id(),
          "name": "Model",
          "ownedElements": [
            {
              "_type": "UMLUseCaseDiagram",
              "_id": "D1",
              "name": name,
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
    
    actor_ids = {}
    uc_ids = {}
    actor_view_coords = {}
    uc_view_coords = {}
    
    def add_actor_v2(name, left, top):
        aid = gen_id()
        vid = gen_id()
        comp_id = gen_id()
        actor_ids[name] = aid
        model_elements.append({"_type": "UMLActor", "_id": aid, "name": name})
        views.append({
            "_type": "UMLActorView", "_id": vid, "_parent": {"$ref": "D1"}, "model": {"$ref": aid},
            "subViews": [
                {
                    "_type": "UMLNameCompartmentView", "_id": comp_id, "_parent": {"$ref": vid}, "model": {"$ref": aid},
                    "subViews": [
                        {"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": comp_id}, "visible": False, "left": left, "top": top+60, "width": 80, "height": 13},
                        {"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": comp_id}, "font": "Arial;13;1", "left": left, "top": top+60, "width": 80, "height": 13, "text": name, "wordWrap": True, "horizontalAlignment": 2},
                        {"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": comp_id}, "visible": False, "left": left, "top": top+60, "width": 80, "height": 13}
                    ],
                    "font": "Arial;13;0", "left": left, "top": top+55, "width": 80, "height": 23
                }
            ],
            "font": "Arial;13;0", "left": left, "top": top, "width": 80, "height": 80,
            "nameCompartment": {"$ref": comp_id}
        })
        actor_view_coords[name] = (vid, left+40, top+40)

    def add_usecase_v2(name, left, top):
        uid = gen_id()
        vid = gen_id()
        comp_id = gen_id()
        uc_ids[name] = uid
        model_elements.append({"_type": "UMLUseCase", "_id": uid, "name": name})
        w, h = 160, 50
        views.append({
            "_type": "UMLUseCaseView", "_id": vid, "_parent": {"$ref": "D1"}, "model": {"$ref": uid},
            "subViews": [
                {
                    "_type": "UMLNameCompartmentView", "_id": comp_id, "_parent": {"$ref": vid}, "model": {"$ref": uid},
                    "subViews": [
                        {"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": comp_id}, "visible": False, "left": left, "top": top+15, "width": w, "height": 13},
                        {"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": comp_id}, "font": "Arial;13;1", "left": left, "top": top+15, "width": w, "height": 13, "text": name, "wordWrap": True, "horizontalAlignment": 2},
                        {"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": comp_id}, "visible": False, "left": left, "top": top+15, "width": w, "height": 13}
                    ],
                    "font": "Arial;13;0", "left": left, "top": top+10, "width": w, "height": 23
                }
            ],
            "font": "Arial;13;0", "left": left, "top": top, "width": w, "height": h,
            "nameCompartment": {"$ref": comp_id}
        })
        uc_view_coords[name] = (vid, left+w//2, top+h//2)

    def add_association_v2(act_name, uc_name):
        asc_id = gen_id()
        model_elements.append({
            "_type": "UMLAssociation", "_id": asc_id,
            "end1": {"_type": "UMLAssociationEnd", "_id": gen_id(), "reference": {"$ref": actor_ids[act_name]}},
            "end2": {"_type": "UMLAssociationEnd", "_id": gen_id(), "reference": {"$ref": uc_ids[uc_name]}}
        })
        
        sv_id, sx, sy = actor_view_coords[act_name]
        tv_id, tx, ty = uc_view_coords[uc_name]
        
        views.append({
            "_type": "UMLAssociationView", "_id": gen_id(), "_parent": {"$ref": "D1"}, "model": {"$ref": asc_id},
            "head": {"$ref": tv_id}, "tail": {"$ref": sv_id},
            "lineStyle": 1, "points": str(sx)+":"+str(sy)+";"+str(tx)+":"+str(ty), "font": "Arial;13;0"
        })

    sub_vid = gen_id()
    views.append({
        "_type": "UMLUseCaseSubjectView", "_id": sub_vid, "_parent": {"$ref": "D1"},
        "subViews": [{"_type": "LabelView", "_id": gen_id(), "_parent": {"$ref": sub_vid}, "font": "Arial;13;1", "left": 305, "top": 55, "width": 310, "height": 13, "text": "AdvFlutter System", "horizontalAlignment": 2}],
        "font": "Arial;13;0", "left": 300, "top": 50, "width": 320, "height": max(150 + 65 * len(usecases_data), 300)
    })

    for i, a in enumerate(actors_data):
        if "Firebase" in a or "AI" in a or "Customer" in a:
            add_actor_v2(a, 700, 100 + (i%2)*150)
        else:
            add_actor_v2(a, 100, 100 + i*150)
        
    for i, u in enumerate(usecases_data):
        add_usecase_v2(u, 380, 80 + i*65)
        
    for act, ucs in connections.items():
        for uc in ucs:
            if uc in uc_ids:
                add_association_v2(act, uc)
            
    with open(filename, "w") as f:
        json.dump(mdj, f, indent=2)

create_mdj(
    "manager_usecases.mdj", "Manager Use Cases",
    ["Manager", "AI Service", "Firebase Backend"],
    ["View Dashboard", "Manage Inventory", "Edit Menu & Dishes", "Analyze Recipe Costing", "Log Waste", "Use AI Assistant", "Authenticate"],
    {
        "Manager": ["View Dashboard", "Manage Inventory", "Edit Menu & Dishes", "Analyze Recipe Costing", "Log Waste", "Use AI Assistant", "Authenticate"],
        "AI Service": ["Use AI Assistant"],
        "Firebase Backend": ["View Dashboard", "Authenticate"]
    }
)

create_mdj(
    "staff_usecases.mdj", "Staff & Customer Use Cases",
    ["Staff", "Customer", "Firebase Backend"],
    ["Process POS Orders", "Manage Table Mapping", "Make Reservation", "Authenticate"],
    {
        "Staff": ["Process POS Orders", "Manage Table Mapping", "Make Reservation", "Authenticate"],
        "Customer": ["Make Reservation", "Authenticate"],
        "Firebase Backend": ["Process POS Orders", "Authenticate"]
    }
)

create_mdj(
    "chef_usecases.mdj", "Chef Use Cases",
    ["Chef", "Firebase Backend"],
    ["View Orders", "Log Waste", "Authenticate"],
    {
        "Chef": ["View Orders", "Log Waste", "Authenticate"],
        "Firebase Backend": ["View Orders", "Authenticate"]
    }
)

